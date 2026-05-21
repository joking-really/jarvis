---
name: remotion-video-generation
description: "Build programmatic short-form videos with Remotion: React-based video compositions with TTS audio, programmatic mockups, stock footage placeholders, and automated asset downloads."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [remotion, video, reels, tiktok, shorts, programmatic-video, tts, automation]
    related_skills: [video-editing-ffmpeg, brand-system-design, youtube-content]
---

# Remotion Video Generation

Build programmatic short-form videos (Reels, TikTok, YouTube Shorts, LinkedIn video) using Remotion — a React-based video rendering framework. Compose videos with code: timed text overlays, TTS audio, programmatic screen mockups, stock footage placeholders, and automated asset pipelines.

## When To Use

- Creating multiple video variations from a script (A/B testing hooks)
- Building videos with programmatic elements (dashboards, metrics, timestamps)
- Generating videos where timing and precision matter (beat-synced, frame-accurate)
- Producing content at scale without manual video editing
- Creating video prototypes or storyboards for editors to finish in post

## Prerequisites

- Node.js 18+ and npm
- ffmpeg (for video/audio processing)
- curl or wget (for downloading assets)
- Optional: TTS tool (edge-tts, piper, or ElevenLabs API key)

## Project Setup

### Initialize Remotion Project

```bash
npx create-video@latest my-reels --blank --y
cd my-reels
npm i
```

### Key Dependencies

```bash
npm i @remotion/cli remotion
```

### Project Structure

```
my-reels/
├── src/
│   ├── Root.tsx              # Composition registry
│   ├── Composition.tsx       # Your video component
│   └── index.css             # Tailwind or custom styles
├── public/
│   └── assets/               # Downloaded stock footage, images
├── scripts/
│   └── download-assets.sh    # Asset fetcher
├── remotion.config.ts        # Render config
└── package.json
```

## Core Workflow

### 1. Write the Script First

Before touching code, write the video script with timestamps:

```
[0:00-0:03] HOOK: "Most clinics lose leads while the receptionist is eating lunch."
[0:03-0:10] PROBLEM: "Your highest-intent leads don't call at 10 AM..."
[0:10-0:17] OBSERVATION: "The first business to respond usually gets paid."
```

See `brand-system-design` skill for script writing guidance (expensive hooks, TOF/MOF/BOF structure).

### 2. Generate TTS Audio

**Option A: edge-tts (free, fast)**
```bash
# Install
pip install edge-tts

# Generate audio for each segment
edge-tts --text "Most clinics lose leads while the receptionist is eating lunch." \
  --write-media public/assets/hook.mp3 \
  --voice en-US-GuyNeural
```

**Option B: ElevenLabs (premium quality)**
```bash
curl -X POST https://api.elevenlabs.io/v1/text-to-speech/VOICE_ID \
  -H "xi-api-key: $ELEVENLABS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"text": "Your script here", "model_id": "eleven_multilingual_v2"}' \
  --output public/assets/hook.mp3
```

**Segment each line separately** so you can time them precisely in Remotion.

### 3. Create Programmatic Mockups

For screen recordings (CRM dashboards, call logs, metrics):

**Option A: HTML-to-Video with Remotion**
Build the UI in React within your Remotion composition. Use dark theme, real-looking data.

**Option B: Generate screenshots programmatically**
```bash
# Use playwright or puppeteer to render HTML and screenshot
npx playwright screenshot mockup.html public/assets/dashboard.png
```

**Option C: Use Remotion's built-in components**
```tsx
// Programmatic call log
<div className="bg-[#0A0A0F] p-4 rounded">
  <div className="text-[#8A8F98] text-sm">Missed Calls</div>
  <div className="text-[#00F0FF] text-2xl font-bold">23</div>
  <div className="text-red-400 text-xs">↑ 12% vs last week</div>
</div>
```

### 4. Source Stock Footage

**Free sources (no API key needed):**
- Pexels: `https://api.pexels.com/v1/search?query=...` (free tier: 200/hr)
- Pixabay: `https://pixabay.com/api/?q=...` (free tier: 100/min)
- Unsplash: `https://api.unsplash.com/search/photos?query=...`

**Search strategy:**
- Use specific queries: "dark office desk", "phone screen close up", "typing laptop night"
- Filter for vertical (9:16) or square (1:1) orientation
- Prefer dark, minimal, operational footage

### 5. Build the Remotion Composition

```tsx
// src/Composition.tsx
import { AbsoluteFill, Audio, Sequence, staticFile, Video, Img } from "remotion";

export const MyReel = () => {
  return (
    <AbsoluteFill className="bg-[#0A0A0F]">
      {/* Hook segment: 0-3s */}
      <Sequence from={0} durationInFrames={90}>
        <Audio src={staticFile("assets/hook.mp3")} />
        <div className="flex items-center justify-center h-full">
          <h1 className="text-white text-4xl font-bold text-center px-8">
            Most clinics lose leads while the receptionist is eating lunch.
          </h1>
        </div>
      </Sequence>

      {/* Problem segment: 3-10s with stock footage */}
      <Sequence from={90} durationInFrames={210}>
        <Audio src={staticFile("assets/problem.mp3")} />
        <Video src={staticFile("assets/office-dark.mp4")} className="absolute inset-0 opacity-50" />
        <div className="relative z-10 flex items-center justify-center h-full">
          <p className="text-white text-2xl text-center px-8">
            Your highest-intent leads don't call at 10 AM on a Tuesday...
          </p>
        </div>
      </Sequence>

      {/* Observation segment: 10-17s with mockup */}
      <Sequence from={300} durationInFrames={210}>
        <Audio src={staticFile("assets/observation.mp3")} />
        <Img src={staticFile("assets/call-log.png")} className="absolute inset-0 object-cover opacity-30" />
        <div className="relative z-10 flex items-center justify-center h-full">
          <p className="text-[#00F0FF] text-3xl font-bold text-center px-8">
            The first business to respond usually gets paid.
          </p>
        </div>
      </Sequence>
    </AbsoluteFill>
  );
};
```

### 6. Create Asset Download Script

```bash
#!/bin/bash
# scripts/download-assets.sh

mkdir -p public/assets

# TTS audio (already generated, just verify)
[ -f public/assets/hook.mp3 ] || echo "WARNING: hook.mp3 missing"

# Stock footage
curl -L "https://videos.pexels.com/video-files/.../video.mp4" -o public/assets/office-dark.mp4

# Images
curl -L "https://images.unsplash.com/photo-..." -o public/assets/dashboard-bg.jpg

echo "Assets downloaded. Ready to render."
```

### 7. Register and Render

```tsx
// src/Root.tsx
import { Composition } from "remotion";
import { MyReel } from "./Composition";

export const RemotionRoot = () => (
  <>
    <Composition
      id="TOF-Reel"
      component={MyReel}
      durationInFrames={900}  // 30s at 30fps
      fps={30}
      width={1080}
      height={1920}  // 9:16 vertical
    />
  </>
);
```

```bash
# Preview in browser
npm run dev

# Render to MP4
npx remotion render src/index.tsx TOF-Reel out/reel-1.mp4
```

## Composition Patterns

### Pattern: Proper Audio Sequencing (CRITICAL)

**WRONG — causes audio doubling/overlap:**
```tsx
// All Audio elements play from frame 0 of the composition!
<Audio src={staticFile("hook.mp3")} startFrom={0} endAt={90} />
<Audio src={staticFile("problem.mp3")} startFrom={0} endAt={210} />
```

**RIGHT — wrap each audio in a Sequence:**
```tsx
import { Audio, Sequence, staticFile } from "remotion";

// Hook segment: 0-3s
<Sequence from={0} durationInFrames={90}>
  <Audio src={staticFile("hook.mp3")} />
</Sequence>

// Problem segment: 3-10s
<Sequence from={90} durationInFrames={210}>
  <Audio src={staticFile("problem.mp3")} />
</Sequence>
```

`startFrom` on Audio controls where in the audio file to start playing, NOT when in the timeline to start. Always use `Sequence` for timeline positioning.

### Pattern 1: Text-Only Reel
Simple typography with TTS. No footage needed.
- Use large, bold text
- Dark background with subtle gradient
- One sentence per screen
- 2-3 second holds

### Pattern 2: Stock Footage + Text Overlay
Video background with text on top.
- Stock footage at 50-70% opacity
- Text in white or brand accent color
- Ensure text has contrast (dark overlay behind text)

### Pattern 3: Screen Mockup Reel
Programmatic UI elements with TTS.
- Build dashboards in React
- Animate metrics counting up
- Show real-looking data
- Dark theme, minimal UI

### Pattern 4: Mixed Media
Combine all three: stock footage, mockups, and text.
- Use Sequences for precise timing
- Transition between types with simple fades
- Maintain consistent visual style

## Timing Guidelines

| Element | Duration | Frames @ 30fps |
|---------|----------|----------------|
| Hook text | 2.5-3.5s | 75-105 |
| Problem statement | 6-8s | 180-240 |
| Single observation | 2-3s | 60-90 |
| CTA / Close | 2-3s | 60-90 |
| Stock footage clip | 3-5s | 90-150 |
| Transition (fade) | 0.3s | 9 |

**Total reel length:** 30-60 seconds (900-1800 frames @ 30fps)

## Visual Style Rules

- **Background:** `#0A0A0F` or `#141419` (never pure white)
- **Text:** White `#FFFFFF` or light gray `#8A8F98`
- **Accents:** Brand primary for CTAs, cyan `#00F0FF` for data/metrics
- **Typography:** Inter or similar sans-serif, bold weights for hooks
- **Safe zones:** Keep text within 60px of edges
- **Max text per screen:** 12 words for readability

## Pitfalls

| Problem | Cause | Solution |
|---------|-------|----------|
| **Audio doubling / overlapping voices** | Bare `<Audio>` without `<Sequence>` wrapper | Wrap each audio in `<Sequence from={startFrame}>`. `startFrom` controls file position, not timeline position |
| **Motion graphics look robotic/jerky** | Default `interpolate()` is linear | Add `easing: Easing.out(Easing.cubic)` to all interpolations |
| **CSS transitions/animations don't work** | Remotion renders frame-by-frame | Animate exclusively with `interpolate()` + `useCurrentFrame()`. Never use CSS `transition` or `@keyframes` |
| **Video backgrounds overlap ugly** | Fade window too wide (10+ frames) | Reduce to 5 frames, add subtle scale (1.05→1) during transition |
| **Cursor blink too fast/distracting** | Blinking every frame at 30fps | Use `relativeFrame % 20 < 10` for ~0.66s blink rate |
| Text unreadable on footage | Poor contrast | Add dark overlay (50% black) behind text |
| Audio out of sync | TTS not segmented | Generate each line as separate MP3 |
| Stock footage looks generic | Wrong search terms | Use specific queries: "dark office desk" not "business" |
| Render fails | Missing assets | Run download-assets.sh before render |
| Video feels slow | Too long per screen | Cut ruthlessly. 2-3s max per text screen |
| TTS sounds robotic | Wrong voice/model | Use ElevenLabs for premium, edge-tts GuyNeural for acceptable |
| File too large | High bitrate | Remotion defaults are fine; don't override unless needed |

## Animation Best Practices

### Always Use Easing

```tsx
import { interpolate, Easing } from "remotion";

// BAD — linear, robotic
const opacity = interpolate(relativeFrame, [0, 10], [0, 1]);

// GOOD — cubic ease out, natural feel
const opacity = interpolate(
  relativeFrame,
  [0, 10],
  [0, 1],
  { extrapolateLeft: "clamp", extrapolateRight: "clamp", easing: Easing.out(Easing.cubic) }
);

// ENTRANCE — slight bounce for playful elements
const scale = interpolate(
  relativeFrame,
  [0, 15],
  [0.95, 1],
  { extrapolateLeft: "clamp", extrapolateRight: "clamp", easing: Easing.out(Easing.back(1.3)) }
);
```

### Component Lifecycle Pattern

Every animated component should follow this structure:

```tsx
import { useCurrentFrame, interpolate, Easing } from "remotion";

export const AnimatedComponent = ({ startFrame, durationInFrames }) => {
  const frame = useCurrentFrame();
  const relativeFrame = frame - startFrame;

  // Return null outside active window (with buffer for transitions)
  if (relativeFrame < -15 || relativeFrame >= durationInFrames + 15) return null;

  const opacity = interpolate(
    relativeFrame,
    [0, 10, durationInFrames - 10, durationInFrames],
    [0, 1, 1, 0],
    { extrapolateLeft: "clamp", extrapolateRight: "clamp", easing: Easing.out(Easing.cubic) }
  );

  return <div style={{ opacity }}>...</div>;
};
```

### Key Rules
- **Never use CSS `transition` or `animation`** — they don't work in Remotion's frame-by-frame renderer
- **Always pass `extrapolateLeft: "clamp"` and `extrapolateRight: "clamp"`** to prevent values going out of bounds
- **Use `Easing.out(Easing.cubic)`** for fades and entrances
- **Use `Easing.inOut(Easing.cubic)`** for progress bars and continuous motion
- **Use `Easing.out(Easing.back(n))`** for playful entrances (notifications, cards)
- **Keep transition windows short** — 5-10 frames max for fades, 15-20 for slides
- **Add subtle scale** (0.95→1 or 1.05→1) during transitions to hide hard cuts

## Advanced: Multi-Variant Generation

Generate multiple hook variations from one base composition:

```tsx
// Pass hook text as prop
export const MyReel = ({ hookText, hookAudio }: { hookText: string; hookAudio: string }) => (
  <AbsoluteFill>
    <Sequence from={0} durationInFrames={90}>
      <Audio src={staticFile(hookAudio)} />
      <h1>{hookText}</h1>
    </Sequence>
    {/* Rest of composition... */}
  </AbsoluteFill>
);

// Register multiple compositions
<Composition id="Hook-A" component={MyReel} defaultProps={{ hookText: "Variant A...", hookAudio: "hook-a.mp3" }} />
<Composition id="Hook-B" component={MyReel} defaultProps={{ hookText: "Variant B...", hookAudio: "hook-b.mp3" }} />
```

Render all variants:
```bash
for id in Hook-A Hook-B Hook-C; do
  npx remotion render src/index.tsx $id out/$id.mp4
done
```

## References

- `templates/AudioSegment.tsx` — **CRITICAL** — wraps Audio in Sequence to prevent doubling
- `templates/AnimatedComponent.tsx` — Base pattern for all animated overlays with proper easing
- `references/remotion-example-composition.tsx` — Complete working example of a TOF reel composition
- `references/download-assets-template.sh` — Asset download script template

## Related Skills

- `brand-system-design` — Video script writing, expensive hooks, TOF/MOF/BOF structure
- `video-editing-ffmpeg` — Post-processing, format conversion, concatenation
- `youtube-content` — YouTube-specific optimization and thumbnails
