# Audio-Video Synchronization for Manim Videos

## When to use

When adding voiceover or background music to a Manim video after rendering. Manim scenes have fixed durations based on animation timing, but externally-generated audio (TTS, recorded narration) rarely matches exactly. This guide covers the post-production sync workflow using ffmpeg.

## The Problem

Manim scene durations are determined by `self.play()` and `self.wait()` calls:
- Scene 1 video: 13.6 seconds
- Scene 1 audio (TTS): 14.04 seconds

These mismatches cause audio cutoffs or trailing silence if simply concatenated.

## Solution: Per-Scene Sync with ffmpeg

### Step 1: Measure all durations

```bash
# Video durations
for f in media/videos/script/1080p60/Scene*.mp4; do
  echo -n "$f: "
  ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f"
done

# Audio durations
for i in 1 2 3 4 5 6 7 8 9 10; do
  echo -n "scene$i: "
  ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 audio/scene${i}.mp3
done
```

### Step 2: Sync each scene individually

Use `tpad` (freeze last frame) when audio is longer, `apad` (silence padding) when video is longer:

```bash
# Audio LONGER than video: extend video by freezing last frame
ffmpeg -y -i video.mp4 -i audio.mp3 \
  -filter_complex "[0:v]tpad=stop_mode=clone:stop_duration=0.9[v]" \
  -map "[v]" -map 1:a -t 14.5 \
  -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
  scene1_synced.mp4

# Video LONGER than audio: extend audio with silence
ffmpeg -y -i video.mp4 -i audio.mp3 \
  -filter_complex "[1:a]apad=pad_dur=4.7[a]" \
  -map 0:v -map "[a]" -t 13 \
  -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
  scene2_synced.mp4
```

**Key parameters:**
- `tpad=stop_mode=clone:stop_duration=N` — freeze last video frame for N seconds
- `apad=pad_dur=N` — add N seconds of silence to audio
- `-t DURATION` — hard cut both tracks to exact duration
- `-c:v libx264 -preset fast -crf 23` — re-encode video (required when using filters)
- `-c:a aac -b:a 192k` — standard AAC audio encoding

### Step 3: Concatenate synced scenes

```bash
cat > concat.txt << 'EOF'
file 'final_scenes/scene1_synced.mp4'
file 'final_scenes/scene2_synced.mp4'
EOF
ffmpeg -y -f concat -safe 0 -i concat.txt -c copy final_with_voice.mp4
```

### Step 4: Adjust audio volume (optional)

```bash
ffmpeg -y -i final_with_voice.mp4 \
  -filter_complex "[0:a]volume=0.8[a1]" \
  -map 0:v -map "[a1]" -c:v copy \
  final.mp4
```

## Automated Batch Script

For videos with many scenes, generate a shell script programmatically:

```bash
#!/bin/bash
# add_audio.sh — auto-generated per project
mkdir -p final_scenes

# Scene 1: video 13.6s, audio 14.04s → extend video
ffmpeg -y -i media/videos/script/1080p60/Scene1_Hook.mp4 -i audio/scene1.mp3 \
  -filter_complex "[0:v]tpad=stop_mode=clone:stop_duration=0.9[v]" \
  -map "[v]" -map 1:a -t 14.5 \
  -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
  final_scenes/scene1.mp4

# Scene 2: video 13s, audio 8.35s → extend audio
ffmpeg -y -i media/videos/script/1080p60/Scene2_Agitation.mp4 -i audio/scene2.mp3 \
  -filter_complex "[1:a]apad=pad_dur=4.7[a]" \
  -map 0:v -map "[a]" -t 13 \
  -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
  final_scenes/scene2.mp4

# ... repeat for all scenes
```

## Common Pitfalls

1. **Using `-c copy` with filters** — `-c copy` skips re-encoding and ignores filters. Always use `-c:v libx264` when applying `tpad`.

2. **Wrong duration math** — Calculate `stop_duration` as `(audio_duration - video_duration)` plus a small buffer (0.3-0.5s). Round up to avoid cutoffs.

3. **Non-monotonic DTS after concat** — Harmless warning from ffmpeg. The output is valid. Ignore unless playback fails.

4. **Forgetting `-t`** — Without `-t`, ffmpeg uses the longer track's natural duration, which may not match your target.

5. **Audio too quiet/loud** — TTS output varies by provider. Normalize with `volume=0.8` or `volume=1.2` as needed.

## Alternative: manim-voiceover Plugin

For new projects, consider `manim-voiceover` which auto-syncs animation duration to voiceover length:

```bash
pip install "manim-voiceover[gtts]"
```

This eliminates post-production sync entirely but requires integrating TTS into the Python script. See `references/rendering.md` for details.
