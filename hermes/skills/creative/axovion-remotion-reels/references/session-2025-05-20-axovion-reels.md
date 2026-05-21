# Session: 2025-05-20 — Axovion 3-Funnel Reels

## What Was Built

Complete Remotion project for Axovion's first 3 LinkedIn/Instagram reels:

| Reel | Duration | Script Focus | Color |
|------|----------|-------------|-------|
| TOFReel | 50s | "Most clinics lose leads while the receptionist is eating lunch" | Blue #3b82f6 |
| MOFReel | 37s | "I spent 3 weeks tuning an AI voice agent. Here's what broke" | Amber #f59e0b |
| BOFReel | 63s | "Most businesses are too early for this" | Emerald #10b981 |

## Audio Segments Generated

15 MP3 files using edge-tts (en-US-GuyNeural):
- TOF: hook, problem, observation, tension, close
- MOF: hook, fail1, fail2, fail3, close
- BOF: hook, filter, roi, positioning, close

## Stock Footage Sourced (Pexels API)

16 portrait-orientation clips downloaded:
- phone ringing, office calls, missed calls, business handshake
- frustrated customer, code screen, error messages, test fails
- chart down, laptop dark, stressed businessman, waiting room
- calculator, phone call business, businessman laptop, office night

## Screen Mockups Created

5 programmatic mockup types in ScreenMockup.tsx:
1. `callLog` — red/green missed/answered calls with loss amount
2. `crmPipeline` — pipeline stages with "Lost - No Response" highlighted
3. `calculator` — ROI math: missed calls × deal value × working days
4. `errorLog` — test results showing 25% pass rate
5. `codeEditor` — TypeScript config with bug comments

## Key Technical Notes

- All assets must be in `public/` root (not subfolders) for `staticFile()` to work
- Video components reference files without `assets/` prefix: `src="hook_bg.mp4"`
- Frame calculations: audio duration (seconds) × 30 fps
- TypeScript compiles clean with `npx tsc --noEmit`
- Render on this EC2 is CPU-only and very slow (~40min per reel)

## GitHub Push Issue

Terminal commands timeout when trying to set remote URL with PAT. Workaround:
```bash
cd ~/axovion-reels
git remote set-url origin https://oauth2:TOKEN@github.com/joking-really/axovion_reels.git
git push -u origin main
```
Run directly on EC2, not through agent terminal.

## User Content Quality Bar (CRITICAL)

From this session, learned user's exacting standards:
- Hooks must be "expensive" not "educated" — specific observations that create financial tension
- Avoid: defensive language ("not a pitch"), algorithm-aware CTAs ("DM me 'leak'"), content-creator framing
- End with observations, not requests for follows/engagement
- First 10-15 posts: build competence, positioning, intelligence, legitimacy — THEN personality
- AI is the mechanism, not the sell. Sell: response speed, operational reliability, captured intent, reduced leakage, revenue continuity
- Visuals must be operational (dashboards, call logs, CRM, terminals) not generic B-roll
- User will push back hard on anything sounding like "AI agency Twitter" or "Instagram marketer"

---

# Session: 2026-05-21 — Audio Doubling & Motion Graphics Fix

## Problems Found

1. **Audio doubling / overlapping voices** — All `<Audio>` elements played from frame 0 simultaneously. Each had `startFrom={0}` which controls where in the audio file to start playing, NOT when in the timeline to start. All audio tracks overlapped, creating a cacophony.

2. **Motion graphics looked bad / hard to understand** — Multiple issues:
   - Video backgrounds overlapped during 10-frame transition windows
   - All animations were linear (robotic feel)
   - Text overlays had no easing
   - Terminal cursor blinked every frame (too fast, distracting)
   - Pipeline progress was choppy
   - No staggered entrances — everything appeared at once
   - ProgressBar used CSS `transition` which doesn't work in Remotion
   - Text shadows were too weak for readability

## Fixes Applied

### Audio Fix: Wrap in `<Sequence>`

**WRONG (causes doubling):**
```tsx
<Audio src={staticFile("hook.mp3")} startFrom={0} endAt={171} />
<Audio src={staticFile("problem.mp3")} startFrom={0} endAt={246} />
// Both play from frame 0! They overlap!
```

**RIGHT (properly sequenced):**
```tsx
// AudioSegment.tsx
import { Audio, staticFile, Sequence } from "remotion";

export const AudioSegment = ({ src, startFrame, durationInFrames }) => (
  <Sequence from={startFrame} durationInFrames={durationInFrames}>
    <Audio src={staticFile(src)} startFrom={0} endAt={durationInFrames} />
  </Sequence>
);

// In composition:
<AudioSegment src="hook.mp3" startFrame={0} durationInFrames={171} />
<AudioSegment src="problem.mp3" startFrame={171} durationInFrames={246} />
```

### Motion Graphics Fixes

| Component | Fix |
|-----------|-----|
| VideoBackground | Reduced overlap window from 10→5 frames, added subtle scale animation (1.05→1), cubic easing |
| TextOverlay | Added `scaleIn` animation, stronger text shadow, cubic easing on all fades |
| PipelineFlow | Staggered per-stage entrance with `Easing.back(1.2)`, smoother cubic progress |
| ResponseTimer | Added pulse glow when critical, smoother cubic easing |
| TerminalMockup | Slowed cursor blink from every frame → every 20 frames (~0.66s) |
| SystemNotification | Added scale-in with slight bounce (`Easing.back(1.2)`) |
| ScreenMockup | Added scale entrance animation |
| ProgressBar | Removed broken CSS `transition`, added glow pulse at leading edge, cubic easing |

### Key Pattern: Always Use Easing

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

// EVEN BETTER — with slight bounce for entrances
const scale = interpolate(
  relativeFrame,
  [0, 15],
  [0.95, 1],
  { extrapolateLeft: "clamp", extrapolateRight: "clamp", easing: Easing.out(Easing.back(1.3)) }
);
```

### Key Pattern: Proper Component Lifecycle

Every animated component should:
1. Accept `startFrame` and `durationInFrames` props
2. Calculate `relativeFrame = frame - startFrame`
3. Return `null` when outside active window (with buffer for transitions)
4. Use `interpolate` with `extrapolateLeft: "clamp"` and `extrapolateRight: "clamp"`
5. Apply easing to all animated properties
6. Never use CSS `transition` or `animation` — animate with `interpolate` only

```tsx
export const MyComponent = ({ startFrame, durationInFrames }) => {
  const frame = useCurrentFrame();
  const relativeFrame = frame - startFrame;

  // Buffer for fade in/out
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

## Files Modified

- `src/components/AudioSegment.tsx` — Rewritten with Sequence wrapper
- `src/components/VideoBackground.tsx` — Scale + cubic easing
- `src/components/TextOverlay.tsx` — scaleIn, better shadows, easing
- `src/components/PipelineFlow.tsx` — Staggered animations
- `src/components/ResponseTimer.tsx` — Pulse effect, smoother easing
- `src/components/TerminalMockup.tsx` — Slower cursor blink
- `src/components/SystemNotification.tsx` — Scale + bounce
- `src/components/ScreenMockup.tsx` — Scale entrance
- `src/components/ProgressBar.tsx` — Glow pulse, cubic easing
- `src/compositions/TOFReel.tsx` — Uses AudioSegment
- `src/compositions/MOFReel.tsx` — Uses AudioSegment
- `src/compositions/BOFReel.tsx` — Uses AudioSegment
