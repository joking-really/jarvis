# Remotion Video Production — Session Reference

## Complete Workflow

### 1. Project Initialization
```bash
npx create-video@latest axovion-reels --blank --y
cd axovion-reels
npm i
```

### 2. Directory Structure
```
axovion-reels/
├── public/              # All assets go here for staticFile()
│   ├── *.mp4           # Stock footage
│   └── *.mp3           # TTS audio
├── src/
│   ├── components/
│   │   ├── AudioSegment.tsx
│   │   ├── VideoBackground.tsx
│   │   ├── TextOverlay.tsx
│   │   ├── ScreenMockup.tsx
│   │   └── ProgressBar.tsx
│   ├── compositions/
│   │   ├── TOFReel.tsx
│   │   ├── MOFReel.tsx
│   │   └── BOFReel.tsx
│   └── Root.tsx
└── remotion.config.ts
```

### 3. TTS Audio Generation

**Option A: edge-tts (Free, No API Key)**
```bash
pip install edge-tts --break-system-packages
edge-tts --text "Your script here" --voice en-US-GuyNeural --write-media audio.mp3
```

**Option B: ElevenLabs (Premium Quality)**
- API key required
- Better voice quality and naturalness
- Use for final production

### 4. Stock Footage Sourcing (Pexels)

**API Key:** Free, 200 requests/hour
**Registration:** pexels.com/api

```python
import urllib.request
import json

API_KEY = "your_pexels_key"

def search_videos(query, per_page=3):
    url = f"https://api.pexels.com/videos/search?query={query.replace(' ', '+')}&per_page={per_page}&orientation=portrait"
    req = urllib.request.Request(url, headers={
        "Authorization": API_KEY,
        "User-Agent": "curl/8.18.0"
    })
    with urllib.request.urlopen(req, timeout=15) as resp:
        data = json.loads(resp.read().decode())
    return data['videos']
```

**Recommended Search Queries by Reel Type:**

| TOF (Awareness) | MOF (Trust) | BOF (Conversion) |
|-----------------|-------------|------------------|
| phone ringing | code screen | stressed businessman |
| office phone | error message | waiting room |
| missed call | test fail | calculator math |
| business handshake | laptop screen dark | spreadsheet excel |
| frustrated customer | business chart down | phone call business |
| office night | typing keyboard | businessman laptop |

### 5. Asset Download Script

```bash
#!/bin/bash
# download-assets.sh
ASSETS=(
  "tof_hook_bg.mp4:https://videos.pexels.com/..."
  "tof_problem_bg1.mp4:https://videos.pexels.com/..."
  # ... etc
)

for asset in "${ASSETS[@]}"; do
  IFS=':' read -r filename url <<< "$asset"
  curl -L -o "public/$filename" "$url"
done
```

### 6. Frame Duration Calculation

```bash
# Get audio duration
ffprobe -v error -show_entries format=duration -of csv=p=0 audio.mp3

# Calculate frames (at 30fps)
# frames = duration_seconds * 30
```

### 7. Key Components

**VideoBackground.tsx:**
- Darkens and blurs stock footage
- Fade in/out transitions
- Configurable blur and darken levels

**TextOverlay.tsx:**
- Animated text (fade, slideUp)
- Shadow effects for readability
- Responsive positioning

**ScreenMockup.tsx:**
- Types: callLog, crmPipeline, calculator, errorLog, codeEditor
- Dark theme UI mockups
- Realistic data display

**ProgressBar.tsx:**
- Colored progress indicator
- Matches reel theme color

### 8. Composition Configuration

```typescript
// Root.tsx
<Composition
  id="TOFReel"
  component={TOFReel}
  durationInFrames={1511}  // Calculated from audio
  fps={30}
  width={1080}
  height={1920}
/>
```

### 9. Render Commands

```bash
# Development preview
npm run dev

# Render single reel
npx remotion render TOFReel --codec=h264 --output=tof.mp4

# With longer timeout (for slow machines)
npx remotion render TOFReel --codec=h264 --output=tof.mp4 --timeout=300000

# All three reels
npx remotion render TOFReel --codec=h264 --output=tof.mp4
npx remotion render MOFReel --codec=h264 --output=mof.mp4
npx remotion render BOFReel --codec=h264 --output=bof.mp4
```

### 10. Performance Notes

- **EC2 t3.micro/small:** 40+ minutes per reel (too slow)
- **Local machine with GPU:** 2-5 minutes per reel
- **Remotion Lambda:** Cloud rendering, pay per minute
- **Alternative:** Use Remotion as editor blueprint, rebuild in Premiere/After Effects

### 11. Common Pitfalls

| Problem | Cause | Solution |
|---------|-------|----------|
| 404 on assets | staticFile path wrong | Assets must be in `public/`, path should not include `public/` |
| Browser crashes | Video loading timeout | Increase `--timeout` flag |
| Slow render | No GPU, low CPU | Render locally or use Lambda |
| Audio out of sync | Wrong frame calculation | Verify `duration * fps` matches |
| TypeScript errors | Missing imports | Check component imports |

### 12. Editor Handoff Format

When full render isn't feasible, provide:

1. **Shot List:**
   - Segment timestamps
   - Stock footage URLs/categories
   - Screen mockup specs
   - Text overlay copy

2. **Audio Files:**
   - All TTS segments as MP3
   - Named by segment (tof_hook.mp3, etc.)

3. **Visual Direction:**
   - Dark theme (#0a0a0a background)
   - Blue (#3b82f6) for TOF, Amber (#f59e0b) for MOF, Green (#10b981) for BOF
   - AXOVION watermark bottom-right
   - Progress bar at bottom

4. **Screen Mockup Data:**
   - Call logs with missed calls
   - CRM pipelines with lost deals
   - Calculator with leak math
   - Error logs with failures
   - Code editors with bug comments
