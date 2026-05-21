---
name: claude-code-video-toolkit
title: Claude Code Video Toolkit
description: AI-native video production workspace using Remotion, ElevenLabs/Qwen3-TTS, ACE-Step music, Playwright recording, and FFmpeg. Complete workflow from concept to final render.
category: creative
tags: [video, remotion, production, toolkit, ai]
author: digitalsamba
source: https://github.com/digitalsamba/claude-code-video-toolkit
version: 1.0.0
---

# Claude Code Video Toolkit

Complete AI-native video production system. Source: https://github.com/digitalsamba/claude-code-video-toolkit

## Architecture

```
claude-code-video-toolkit/
├── .claude/skills/        # Domain knowledge (remotion, elevenlabs, ffmpeg, etc.)
├── .claude/commands/      # Guided workflows (/video, /brand, /record-demo)
├── tools/                 # Python CLI automation
├── templates/             # Remotion project templates
│   ├── sprint-review/     # Config-driven sprint reviews
│   ├── product-demo/      # Marketing videos (dark tech aesthetic)
│   └── ai-engineering-review/
├── lib/                   # Shared components & transitions
│   ├── components/        # AnimatedBackground, SlideTransition, NarratorPiP, etc.
│   ├── transitions/       # glitch, lightLeak, zoomBlur, rgbSplit, etc.
│   └── theme/             # ThemeProvider, brand system
├── brands/                # Brand profiles (colors, fonts, voice)
└── _internal/toolkit-registry.json  # Canonical catalog of all capabilities
```

## Templates

### product-demo
- Dark tech aesthetic with animated backgrounds
- Scene types: title, problem, solution, demo, stats, cta
- Components: AnimatedBackground, Vignette, LogoWatermark, NarratorPiP
- Transitions: glitch, lightLeak, zoomBlur via TransitionSeries
- Config-driven via `demo-config.ts`

### sprint-review
- Config-driven content via `sprint-config.ts`
- Pre-built slides: Title, Overview, Summary, Credits
- Demo components: single video, split-screen

## Shared Components (lib/components/)

| Component | Purpose |
|-----------|---------|
| AnimatedBackground | Floating shapes (subtle/tech/warm/dark variants) |
| SlideTransition | Scene transitions (fade, zoom, slide-up, blur-fade) |
| Label | Floating badge with optional JIRA reference |
| Vignette | Cinematic edge darkening |
| LogoWatermark | Corner branding overlay |
| SplitScreen | Side-by-side comparison |
| NarratorPiP | Picture-in-picture presenter (SadTalker compatible) |
| FilmGrain | SVG noise for cinematic texture |
| MazeDecoration | Isometric grid corner decoration |

## Custom Transitions (lib/transitions/)

| Transition | Best For | Options |
|------------|----------|---------|
| glitch | Tech demos, cyberpunk | intensity, slices, rgbShift |
| lightLeak | Celebrations, film | temperature, direction |
| zoomBlur | CTAs, high energy | direction, blurAmount |
| rgbSplit | Modern tech | direction, displacement |
| clockWipe | Time content | startAngle, direction |
| pixelate | Retro/gaming | maxBlockSize, gridSize |
| checkerboard | Playful | pattern, stagger |

## Python Tools

### Voiceover Generation
```bash
# Per-scene (recommended)
python tools/voiceover.py --scene-dir public/audio/scenes --json

# Qwen3-TTS (free, self-hosted)
python tools/voiceover.py --provider qwen3 --speaker Ryan --scene-dir public/audio/scenes --json
```

### Music Generation (ACE-Step 1.5)
```bash
# Background music
python tools/music_gen.py --preset corporate-bg --duration 60 --output bg.mp3

# Scene presets: corporate-bg, upbeat-tech, ambient, dramatic, tension, hopeful, cta, lofi
```

### Timing Sync
```bash
python3 tools/sync_timing.py --apply --padding 1.5
```

### Browser Recording
```bash
# Playwright demo recording
python tools/record_demo.py --url https://yourapp.com --output demo.mp4
```

## Timing Rules

- **Voiceover drives timing** — narration length determines scene duration
- **Reading pace**: ~150 WPM (2.5 words/second)
- **Demo pacing**: 1.5-2x speedup typical
- **Transitions**: 1-2s padding between scenes
- **FPS**: 30fps (frames = seconds × 30)

### TTS Duration Drift
- ElevenLabs compresses pauses — 50s script may produce 40-45s audio
- Qwen3 varies by speaker/tone — Ryan "professional" ~10% faster than "warm"
- Short scenes drift more (30%) than long scenes (10%)

**Fix:** Generate audio first, then anchor visuals to known timestamps.

## Audio-Anchored Timelines (Prevention)

```python
# Generate per-scene VO first
python tools/voiceover.py --scene-dir public/audio/scenes --json

# Read actual durations from JSON output
# Anchor every visual element to absolute timestamps

text_clip("TIRED OF",     start=0.5,  duration=1.2)
text_clip("THIRD-PARTY",  start=1.0,  duration=1.8)
vo_clip("01_tired.mp3",   start=0.3)
vo_clip("02_worries.mp3", start=4.0)
```

## Cloud GPU Providers

| Provider | Best For | Setup |
|----------|----------|-------|
| RunPod | Default, reliable | `python tools/<tool>.py --setup` |
| Modal | Faster cold starts | `modal deploy docker/modal-<tool>/app.py` |
| acemusic | Music generation (free API key) | Get key at acemusic.ai/api-key |

## Remotion Patterns

### Sequencing
```tsx
<Series>
  <Series.Sequence durationInFrames={150}><TitleSlide /></Series.Sequence>
  <Series.Sequence durationInFrames={900}><DemoClip /></Series.Sequence>
</Series>
```

### Transitions
```tsx
import { TransitionSeries, linearTiming } from '@remotion/transitions';
import { glitch } from '../../../lib/transitions';

<TransitionSeries>
  <TransitionSeries.Sequence durationInFrames={90}><TitleSlide /></TransitionSeries.Sequence>
  <TransitionSeries.Transition presentation={glitch({ intensity: 0.8 })} timing={linearTiming({ durationInFrames: 20 })} />
  <TransitionSeries.Sequence durationInFrames={120}><ContentSlide /></TransitionSeries.Sequence>
</TransitionSeries>
```

### Media (NEVER use raw HTML video)
```tsx
<OffthreadVideo src={staticFile('demo.mp4')} />
<Audio src={staticFile('voiceover.mp3')} volume={1} />
<Audio src={staticFile('music.mp3')} volume={0.15} />
```

## Project Lifecycle

```
planning → assets → review → audio → editing → rendering → complete
```

## Brand System

```
brands/my-brand/
├── brand.json    # Colors, fonts, typography
├── voice.json    # ElevenLabs voice settings
└── assets/       # Logo, backgrounds
```

## Key Conventions

1. Always invoke tools from toolkit root directory
2. Use `<OffthreadVideo>` and `<Audio>` from remotion package
3. Generate audio first, then sync visuals
4. Use `sync_timing.py` after voiceover generation
5. Per-scene audio generation recommended over single file
6. `--preprocess full` for SadTalker (preserves dimensions)
