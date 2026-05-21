---
name: axovion-remotion-reels
title: Axovion Remotion Reels Pipeline
description: Create full-funnel marketing reels using Remotion with TTS audio, stock footage, and programmatic screen mockups.
triggers:
  - create marketing reels
  - remotion video pipeline
  - full funnel video scripts
---

# Axovion Remotion Reels Pipeline

## Overview

Creates 3-funnel marketing reels (TOF/MOF/BOF) using Remotion with:
- Edge-TTS generated voiceover
- Pexels stock footage (free API)
- Programmatic screen mockups (call logs, CRM, calculators, terminals)
- Animated text overlays with fade/slide effects
- Progress bars and subtle corner branding

**Visual Identity: "Dark Operational Intelligence"**
- NO generic stock: handshakes, smiling teams, fake meetings, stressed businessmen
- YES systems visuals: terminals, dashboards, response timers, pipeline flows, code editors, system notifications
- Dark UI aesthetic (#0a0a0a backgrounds, #222 borders, monospace fonts)
- Subtle branding: "AXOVION // SYSTEMS" in corner (not floating watermark)
- Voice tone: calm, observant, dangerous, certain — never excited or salesy

## Prerequisites

- Node.js + npm
- Remotion CLI (`npx create-video@latest`)
- Pexels API key (free, 200 req/hour)
- edge-tts Python package (`pip install edge-tts`)

## Project Structure

```
axovion-reels/
├── src/
│   ├── Root.tsx                 # Composition registry
│   ├── compositions/
│   │   ├── TOFReel.tsx          # Top of Funnel (Awareness)
│   │   ├── MOFReel.tsx          # Middle of Funnel (Consideration)
│   │   └── BOFReel.tsx          # Bottom of Funnel (Conversion)
│   └── components/
│       ├── VideoBackground.tsx  # Darkened video with transitions
│       ├── TextOverlay.tsx      # Animated text (fade, slideUp)
│       ├── ScreenMockup.tsx     # 5 mockup types
│       ├── ProgressBar.tsx      # Bottom progress indicator
│       └── AudioSegment.tsx     # Audio with fade in/out
├── public/                      # Assets (audio + video)
└── remotion.config.ts
```

## Step 1: Initialize Project

```bash
cd ~
npx create-video@latest axovion-reels --blank --y
cd axovion-reels
npm i
mkdir -p src/compositions src/components src/audio src/assets
```

## Step 2: Generate TTS Audio

```bash
# Install edge-tts
pip install edge-tts

# Generate audio segments
cd src/audio
edge-tts --text "HOOK_SCRIPT_HERE" --voice en-US-GuyNeural --write-media hook.mp3
# Repeat for each script segment
```

**Voice options:**
- `en-US-GuyNeural` — professional male
- `en-US-JennyNeural` — professional female
- `en-GB-RyanNeural` — British male

## Step 3: Download Stock Footage

Use Pexels API (free key from pexels.com/api):

```python
import urllib.request, json

API_KEY = "YOUR_PEXELS_KEY"
queries = ["office phone", "businessman laptop", "phone screen", "receptionist"]

for q in queries:
    url = f"https://api.pexels.com/videos/search?query={q}&per_page=3&orientation=portrait"
    req = urllib.request.Request(url, headers={"Authorization": API_KEY, "User-Agent": "curl/8.0"})
    # Parse JSON, extract HD video URLs, download with curl/wget
```

**Orientation:** Always use `portrait` for reels (1080x1920)

## Step 4: Build Components

### AudioSegment (CRITICAL — prevents doubling)
Always wrap audio in a Sequence so each segment plays at its correct timeline position:

```tsx
import { Audio, staticFile, Sequence } from "remotion";

export const AudioSegment = ({ src, startFrame, durationInFrames }) => (
  <Sequence from={startFrame} durationInFrames={durationInFrames}>
    <Audio src={staticFile(src)} startFrom={0} endAt={durationInFrames} />
  </Sequence>
);

// Usage in composition:
<AudioSegment src="hook.mp3" startFrame={0} durationInFrames={171} />
<AudioSegment src="problem.mp3" startFrame={171} durationInFrames={246} />
```

**Never use bare `<Audio>` without Sequence** — all tracks will play from frame 0 and overlap.

### VideoBackground
- Darkens video to 40% brightness
- Adds subtle blur (2px)
- Fade in/out transitions (10 frames)

### TextOverlay
- 52px bold white text with shadow
- Animations: `fade`, `slideUp`
- Centered with 40px padding

### ScreenMockup Types
1. `callLog` — missed calls list with red/green indicators
2. `crmPipeline` — pipeline stages with lost deals highlighted
3. `calculator` — ROI math display
4. `errorLog` — test results with pass/fail
5. `codeEditor` — code with bug comments

### TerminalMockup
- Realistic terminal with header (red/yellow/green dots)
- Typing animation with cursor blink
- Lines appear progressively based on frame count
- Use for: build logs, deployment status, system checks

### ResponseTimer
- MS-precision timer (e.g., "0000ms" → "5000ms")
- Progress bar that turns red at critical threshold
- Use for: showing response time leaks

### SystemNotification
- Slide-in notifications from top-right
- Types: success (green), error (red), warning (amber), info (blue)
- Use for: missed calls, build failures, qualification checks, revenue leaks

### PipelineFlow
- 4-stage horizontal pipeline: INBOUND → RINGING → MISSED/ANSWERED → COMPETITOR WINS/QUALIFIED
- Active stage highlighted with glow
- Shows lead ID, source, intent, value
- Use for: visualizing lead loss to competitors

## Step 5: Compose Reels

Each reel structure:
```tsx
<AbsoluteFill style={{ background: "#0a0a0a" }}>
  {/* Background videos per segment */}
  <VideoBackground src="hook_bg.mp4" ... />
  
  {/* Audio tracks */}
  <Audio src={staticFile("hook.mp3")} ... />
  
  {/* Text overlays timed to audio */}
  <TextOverlay text="..." startFrame={0} durationInFrames={127} />
  
  {/* Screen mockups */}
  <ScreenMockup type="callLog" startFrame={100} ... />
  
  {/* Progress bar */}
  <ProgressBar totalFrames={1511} color="#3b82f6" />
  
  {/* Brand watermark */}
  <div style={{position: "absolute", bottom: 24, right: 24}}>AXOVION</div>
</AbsoluteFill>
```

## Step 6: Render

```bash
# Development preview
npm run dev

# Production render
npx remotion render TOFReel --codec=h264 --output=tof.mp4
npx remotion render MOFReel --codec=h264 --output=mof.mp4
npx remotion render BOFReel --codec=h264 --output=bof.mp4
```

**Performance notes:**
- CPU rendering is slow (~40min per reel on EC2 t3.medium)
- Use GPU-enabled machine for faster renders
- Or use Remotion Lambda for serverless rendering

## Script Writing Guidelines

**CRITICAL: Default to "expensive" not "educated"**
- Specific observations that create financial tension
- Avoid generic claims any LinkedIn bro could write
- NO defensive language: "not a pitch," "follow for more"
- NO algorithm-aware CTAs: "DM me 'leak'" — sounds Instagram marketer
- NO content-creator framing
- End with observations, not requests
- First 10-15 posts must build competence, positioning, perceived intelligence, technical legitimacy BEFORE any personality or founder story

**The user will push back HARD on anything that sounds like:**
- "AI agency Twitter"
- "Instagram marketer"
- "growth hacker"
- "motivational creator"
- "freelancer"

**What to sell:**
- Response speed
- Operational reliability
- Captured intent
- Reduced leakage
- Revenue continuity

**AI is the mechanism, not the sell.**

### TOF (Awareness) — Pain First
- Hook: Attack a specific pain point with specificity
- Problem: Make it emotionally believable
- Observation: Share a counterintuitive truth
- Tension: Create financial urgency
- Bridge: Connect to operational reality
- Close: One sharp line, no CTA — "Speed compounds." / "Response time is now infrastructure."

**Example TOF hook (STRONG):**
"Most clinics lose leads while the receptionist is eating lunch."

**Example TOF hook (WEAK — do NOT use):**
"Businesses lose thousands from 5-minute delays." (too generic)

### MOF (Consideration) — Show The Work
- Hook: Promise behind-the-scenes
- Failures: Show 3 specific problems with technical detail
- Close: Position against polished competitors
- Show iteration, not polished demos

### BOF (Conversion) — Filter and Qualify
- Hook: Exclude unqualified prospects — "Most businesses are too early for this."
- Filter: Set minimum requirements (20+ calls/day, real sales process)
- ROI: Show the math — multiply by deal value by working days
- Positioning: Define exactly what you do AND what you don't do
- Close: Soft CTA — "DM me" / "I'll calculate the leak"

**Post order: TOF first, then MOF, then BOF.** Wrong order kills funnel psychology.

## Common Pitfalls

### Content & Tone Pitfalls
1. **NEVER sound like "AI agency Twitter"** — no excited voice, no hype, no "AI is the future"
2. **NEVER use defensive language** — "not a pitch," "just my opinion" — kills authority
3. **NEVER use algorithm-aware CTAs** — "follow for more," "DM me a keyword" — sounds cheap
4. **NEVER explain why in TOF** — don't say "not because AI is trendy" — just observe
5. **ALWAYS sound expensive** — specific, dangerous, financially intelligent, emotionally uncomfortable

### Technical Pitfalls
6. **AUDIO DOUBLING — CRITICAL:** All `<Audio>` elements without a `<Sequence>` wrapper play from frame 0 simultaneously. `startFrom` controls where in the audio file to start, NOT when in the timeline. Always wrap audio segments in `<Sequence from={startFrame}>` or use an `AudioSegment` component. See `references/session-2025-05-20-axovion-reels.md` for the full fix pattern.
7. **Motion graphics look robotic:** Default `interpolate()` is linear. Always add `easing: Easing.out(Easing.cubic)` for natural feel. Use `Easing.back()` for entrance bounces.
8. **CSS transitions don't work in Remotion:** Never use `transition: "..."` or `@keyframes` in styles. Animate everything with `interpolate()` + `useCurrentFrame()`.
9. **Video overlap during transitions:** Reduce fade overlap window to 5 frames max. Add subtle scale animation (1.05→1) to hide the transition.
10. **Cursor blink too fast:** Terminal cursors at 30fps blink every frame — distracting. Use `relativeFrame % 20 < 10` for ~0.66s blink rate.
11. **Audio paths:** Use `staticFile("filename.mp3")` not `staticFile("audio/filename.mp3")` — files must be in `public/` root
12. **Video paths:** Same — `public/` root, no subfolders in src paths
13. **Frame calculations:** Multiply audio duration by fps (30) to get frames
14. **TypeScript:** Run `npx tsc --noEmit` before rendering to catch errors
15. **Render timeout:** Use `--timeout=300000` for slow machines

### Environment Pitfalls (EC2)
11. **GitHub push with PAT:** Use `oauth2` prefix in URL: `https://oauth2:${TOKEN}@github.com/user/repo.git`. Set URL via `git remote set-url origin <url>` then push. Do NOT ask user for token if already in memory — check memory first.
12. **Terminal timeouts:** Commands with `&` backgrounding or interactive prompts will timeout. Use `terminal(background=true)` for long renders, or run git commands directly without backgrounding.
13. **Remotion render on EC2:** Extremely slow (~40min per reel on t3.medium). User will likely render locally or use Remotion Lambda. Don't promise fast renders on this machine.

## Visual Direction Reference

**DO use:**
- Terminal screens with real commands
- Response timers (ms precision)
- System notifications (missed call, build failed, revenue leak)
- Pipeline flows showing lead loss
- CRM dashboards with real data
- Code editors with bug fixes
- Call logs with timestamps
- Calculator/ROI math displays
- Dark UI, monospace fonts, system aesthetics
- Slow zooms, hard cuts, minimal transitions
- Ambient/cinematic music, minimal percussion

**DO NOT use:**
- Handshakes
- Smiling teams
- Fake meetings
- Stressed businessmen
- Frustrated customers
- Generic office B-roll
- TikTok animations
- Emojis
- Flashy captions
- Overediting
- Motivational music
- Logo splashes / floating watermarks

**Branding:**
- Subtle corner text: "AXOVION // SYSTEMS"
- Font: 'JetBrains Mono' or 'Fira Code'
- Color: rgba(255,255,255,0.25) — barely visible
- NO animated logos, NO full-screen brand cards