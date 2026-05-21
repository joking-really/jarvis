---
name: video-editing-ffmpeg
description: "Video editing, analysis, and manipulation with FFmpeg. Frame extraction, trimming, concatenation, effects, and format conversion."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Video, FFmpeg, Media, Editing, Analysis]
    related_skills: [gif-search, youtube-content]
---

# Video Editing with FFmpeg

Edit, analyze, and manipulate video files using FFmpeg. Covers common operations from inspection to complex edits.

## Prerequisites

```bash
ffmpeg -version | head -1
```

If not installed:
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install -y ffmpeg

# macOS
brew install ffmpeg
```

---

## 1. Video Inspection

### Basic Info

```bash
# File type
file video.mp4

# Detailed stream info
ffprobe -v error -show_format -show_streams video.mp4

# Duration only
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 video.mp4

# Video stream properties
ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,width,height,r_frame_rate,bit_rate -of default=noprint_wrappers=1 video.mp4
```

### Frame Analysis

```bash
# Show frame types (I, P, B frames)
ffprobe -v error -select_streams v:0 -show_entries frame=pkt_pts_time,pict_type -of csv=p=0 video.mp4 | head -20

# Count frames
ffprobe -v error -count_frames -select_streams v:0 -show_entries stream=nb_read_frames -of default=noprint_wrappers=1:nokey=1 video.mp4
```

---

## 2. Frame Extraction

### Extract Thumbnails at Intervals

```bash
# Extract one frame every 5 seconds
ffmpeg -i video.mp4 -vf "fps=1/5,scale=320:-1" -q:v 2 output/thumb_%03d.jpg

# Extract frames at specific timestamps
ffmpeg -ss 00:00:10 -i video.mp4 -vframes 1 -q:v 2 scene_at_10s.jpg
ffmpeg -ss 00:01:30 -i video.mp4 -vframes 1 -q:v 2 scene_at_90s.jpg

# Extract last frame (use -sseof for end-relative seek)
ffmpeg -sseof -3 -i video.mp4 -vframes 1 -q:v 2 last_frame.jpg
```

### Extract Scene-by-Scene Thumbnails

For a video with known scene structure, extract representative frames:

```bash
# Create output directory
mkdir -p thumbnails

# Extract frame at each scene start (adjust timestamps as needed)
TIMESTAMPS=("00:00:00" "00:00:20" "00:00:35" "00:00:45" "00:01:05" "00:01:20" "00:01:35" "00:01:50" "00:02:05" "00:02:18")

for i in "${!TIMESTAMPS[@]}"; do
    ffmpeg -y -ss "${TIMESTAMPS[$i]}" -i video.mp4 -vframes 1 -q:v 2 "thumbnails/scene$((i+1)).jpg" 2>&1 | tail -1
done
```

**Pitfall — last frame extraction fails with "Nothing was written":**

When extracting the final frame of a video, `-ss` with an exact timestamp may seek past the end of the file.

```bash
# WRONG — may fail if 00:02:20 is past the actual end
ffmpeg -ss 00:02:20 -i video.mp4 -vframes 1 last_frame.jpg

# CORRECT — seek from end using -sseof
ffmpeg -sseof -3 -i video.mp4 -vframes 1 -q:v 2 last_frame.jpg
```

The `-sseof -3` flag seeks to 3 seconds before the end of the file, ensuring a valid frame is always extracted regardless of exact duration.

---

## 3. Video Trimming and Cutting

### Trim by Time

```bash
# Extract segment from 30s to 60s (30 seconds long)
ffmpeg -i video.mp4 -ss 00:00:30 -t 30 -c copy output.mp4

# Extract from 1:30 to 2:00
ffmpeg -i video.mp4 -ss 00:01:30 -to 00:02:00 -c copy output.mp4

# Trim without re-encoding (fast, but keyframe-boundary may shift slightly)
ffmpeg -ss 00:00:30 -i video.mp4 -t 30 -c copy output.mp4
```

### Split into Segments

```bash
# Split every 60 seconds
ffmpeg -i video.mp4 -c copy -map 0 -segment_time 60 -f segment -reset_timestamps 1 output_%03d.mp4
```

---

## 4. Concatenation

### Concatenate Multiple Videos

```bash
# Create a concat list file
cat > concat.txt <<EOF
file 'part1.mp4'
file 'part2.mp4'
file 'part3.mp4'
EOF

# Concatenate (re-encodes for compatibility)
ffmpeg -f concat -safe 0 -i concat.txt -c copy output.mp4
```

---

## 5. Effects and Filters

### Add Text Overlay

```bash
# Simple text at bottom center
ffmpeg -i video.mp4 -vf "drawtext=text='Hello World':fontsize=24:fontcolor=white:x=(w-text_w)/2:y=h-text_h-20" -c:a copy output.mp4

# Text with background box
ffmpeg -i video.mp4 -vf "drawtext=text='Title':fontsize=48:fontcolor=white:box=1:boxcolor=black@0.5:boxborderw=10:x=(w-text_w)/2:y=50" -c:a copy output.mp4
```

### Fade In/Out

```bash
# Fade in first 2 seconds, fade out last 2 seconds
ffmpeg -i video.mp4 -vf "fade=t=in:st=0:d=2,fade=t=out:st=28:d=2" -c:a copy output.mp4
```

### Speed Changes

```bash
# 2x speed (skip every other frame)
ffmpeg -i video.mp4 -vf "setpts=0.5*PTS" -af "atempo=2.0" output.mp4

# 0.5x speed (slow motion)
ffmpeg -i video.mp4 -vf "setpts=2.0*PTS" -af "atempo=0.5" output.mp4
```

### Resize/Scale

```bash
# Scale to 720p
ffmpeg -i video.mp4 -vf "scale=1280:720" -c:a copy output.mp4

# Scale to width 640, maintain aspect ratio
ffmpeg -i video.mp4 -vf "scale=640:-2" -c:a copy output.mp4
```

---

## 6. Format Conversion

```bash
# MP4 to WebM
ffmpeg -i video.mp4 output.webm

# MP4 to GIF
ffmpeg -i video.mp4 -vf "fps=10,scale=480:-1:flags=lanczos" output.gif

# Extract audio only
ffmpeg -i video.mp4 -vn -acodec copy output.aac
ffmpeg -i video.mp4 -vn -acodec libmp3lame output.mp3
```

---

## 7. Add Audio

```bash
# Replace audio track
ffmpeg -i video.mp4 -i audio.mp3 -c:v copy -map 0:v:0 -map 1:a:0 -shortest output.mp4

# Mix audio (video audio + background music)
ffmpeg -i video.mp4 -i music.mp3 -filter_complex "[0:a][1:a]amix=inputs=2:duration=first" -c:v copy output.mp4
```

---

## 8. Common Pitfalls

| Problem | Cause | Solution |
|---------|-------|----------|
| `Conversion failed!` with `-vframes 1` | Output filename doesn't specify single image | Use `-update 1` or ensure output path is a single file, not pattern |
| `-ss` before `-i` vs after `-i` | `-ss` before `-i` is fast but less accurate; after is slow but frame-accurate | Use `-ss` before `-i` for speed, after for precision |
| `-c copy` produces broken video | Cut not on keyframe | Remove `-c copy` to re-encode, or use `-avoid_negative_ts make_zero` |
| Concatenation fails | Different codecs/resolutions | Re-encode first: `ffmpeg -i input.mp4 -c libx264 -vf scale=1920:1080 -pix_fmt yuv420p normalized.mp4` |
| `Nothing was written into output file` | Seeking past end of file | Check duration with ffprobe first; use `-sseof -3` for end-relative |

---

## Quick Reference

| Task | Command |
|------|---------|
| Get info | `ffprobe -v error -show_format -show_streams video.mp4` |
| Extract frame at time | `ffmpeg -ss 00:01:00 -i video.mp4 -vframes 1 frame.jpg` |
| Trim segment | `ffmpeg -i video.mp4 -ss 30 -t 10 -c copy out.mp4` |
| Concatenate | `ffmpeg -f concat -i list.txt -c copy out.mp4` |
| Add text | `ffmpeg -i video.mp4 -vf "drawtext=text='Hello':x=10:y=10" out.mp4` |
| Speed up 2x | `ffmpeg -i video.mp4 -vf "setpts=0.5*PTS" -af "atempo=2" out.mp4` |
| Scale to 720p | `ffmpeg -i video.mp4 -vf "scale=1280:720" out.mp4` |
| Extract audio | `ffmpeg -i video.mp4 -vn audio.mp3` |
| Convert to GIF | `ffmpeg -i video.mp4 -vf "fps=10,scale=480:-1" out.gif` |
