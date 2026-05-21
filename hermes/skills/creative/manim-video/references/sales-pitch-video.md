# Sales Pitch Videos with Manim

## When to Use

Use Manim for sales pitch videos when the user needs:
- A polished, animated presentation for a client pitch
- Problem-solution arc with visual impact
- Brand-consistent motion graphics (dark luxury, tech, corporate)
- Pricing cards, feature showcases, and strong CTAs
- Voiceover-synced output with smooth transitions

## Why Manim Over Traditional Tools

- **Programmatic precision**: Exact timing, exact colors, exact positioning
- **Brand consistency**: Color palette defined once, applied everywhere
- **Scalability**: Change one constant, re-render all scenes
- **No design software needed**: No After Effects, no Premiere, no Canva Pro
- **Version controlled**: Python code is diffable and reusable

## Narrative Arc for Sales Pitches

The proven structure for closing high-ticket clients:

```
1. HOOK      — Client's pain point with data/counter
2. AGITATION — Cost of inaction, gap widening
3. SOLUTION  — Your agency/product intro
4. FEATURES  — 3-5 services with visual demos
5. PROOF     — Stats, mockups, before/after
6. PRICING   — Clear, simple, no hidden fees
7. CTA       — One action, one contact method
```

## Brand Color System

Define a palette dictionary at the top of `script.py`:

```python
BG = "#0A0A0F"           # Deep black background
SURFACE = "#12121A"      # Card backgrounds
PRIMARY_TEXT = "#C0C0C8" # Silver body text
HEADING_TEXT = "#FFFFFF" # White headings
ACCENT_CYAN = "#00D4FF"  # Glows, highlights, secondary CTAs
ACCENT_ORANGE = "#F97316" # Primary CTAs, pricing, urgency
SUCCESS = "#10B981"      # Positive stats, checkmarks
```

## Scene Templates

### Pain Point Card Grid
```python
cards_data = [
    ("Slow replies", "= lost sales"),
    ("Cart abandoned", "= revenue gone"),
    ("No try-on", "= fewer conversions")
]

cards = VGroup()
for main, sub in cards_data:
    card = RoundedRectangle(height=1.8, width=4.2, corner_radius=0.2,
                           fill_color=SURFACE, fill_opacity=1,
                           stroke_color=ACCENT_CYAN, stroke_width=2)
    main_text = Text(main, font_size=24, color=HEADING_TEXT, weight=BOLD)
    sub_text = Text(sub, font_size=18, color=PRIMARY_TEXT)
    main_text.move_to(card.get_center() + UP*0.3)
    sub_text.move_to(card.get_center() + DOWN*0.3)
    cards.add(VGroup(card, main_text, sub_text))

cards.arrange(RIGHT, buff=0.5)
```

### Animated Counter
```python
counter_value = Text("PKR 0", font_size=40, color=ACCENT_ORANGE, weight=BOLD)
for i in range(0, 501, 20):
    new_val = Text(f"PKR {i}K+", font_size=40, color=ACCENT_ORANGE, weight=BOLD)
    new_val.move_to(counter_value.get_center())
    self.play(Transform(counter_value, new_val), run_time=0.05)
```

### Pricing Card
```python
card = RoundedRectangle(height=3.5, width=5, corner_radius=0.3,
                       fill_color=SURFACE, fill_opacity=1,
                       stroke_color=ACCENT_ORANGE, stroke_width=3)
price = Text("$300", font_size=72, color=ACCENT_ORANGE, weight=BOLD)
per = Text("/month per AI bot", font_size=24, color=PRIMARY_TEXT)
price_group = VGroup(price, per)
price_group.arrange(RIGHT, buff=0.2)
price_group.move_to(card.get_center() + UP*0.5)
```

### CTA Button with Pulse
```python
cta_box = RoundedRectangle(height=1.2, width=5, corner_radius=0.2,
                          fill_color=ACCENT_ORANGE, fill_opacity=1)
cta_text = Text("Book Your Free Demo", font_size=28, color=HEADING_TEXT, weight=BOLD)
cta_text.move_to(cta_box.get_center())
cta = VGroup(cta_box, cta_text)

# Pulse animation
self.play(cta.animate.scale(1.05), run_time=0.5)
self.play(cta.animate.scale(1/1.05), run_time=0.5)
```

## Adding Real Images and Logos

### Client Logo
```python
# Download client logo first
# curl -L -o client_logo.png "URL"

if os.path.exists("client_logo.png"):
    logo = ImageMobject("client_logo.png")
    logo.scale(1.5)
    logo.to_edge(UP, buff=0.8)
```

### Agency Logo (Transparent PNG)
```python
# Extract from existing video or download
# ffmpeg -ss 00:00:01 -i existing_video.mp4 -vframes 1 frame.png
# Then crop and make transparent with PIL

if os.path.exists("agency_logo_transparent.png"):
    agency_logo = ImageMobject("agency_logo_transparent.png")
    agency_logo.scale(2.0)
    agency_logo.move_to(UP*0.5)
```

### Creating Mockup Images with PIL

When `image_generate` is unavailable, use PIL to create professional mockups:

```python
from PIL import Image, ImageDraw

# Dashboard mockup
img = Image.new("RGBA", (900, 600), (18, 18, 26, 255))
draw = ImageDraw.Draw(img)

# Sidebar
draw.rectangle([0, 0, 200, 600], fill=(26, 26, 42, 255))
draw.text((20, 20), "DASHBOARD", fill=(0, 212, 255, 255))

# Stats cards with rounded rectangles
draw.rounded_rectangle([220, 20, 450, 120], radius=10,
    fill=(26, 26, 42, 255), outline=(0, 212, 255, 255), width=2)
draw.text((240, 60), "2,847", fill=(0, 212, 255, 255))

img.save("mockup_dashboard.png")
```

## Audio Sync Pipeline

### 1. Generate Voiceovers Per Scene
```bash
# Use text_to_speech tool for each scene
# Save as audio/scene1.mp3, audio/scene2.mp3, etc.
```

### 2. Measure Durations
```bash
for i in 1 2 3 4 5 6 7 8 9 10; do
    echo -n "scene$i video: "
    ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 \
        media/videos/script/1080p60/Scene${i}_Name.mp4
    echo -n "scene$i audio: "
    ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey:1 \
        audio/scene${i}.mp3
done
```

### 3. Match Video to Audio Duration

**If video is shorter than audio** — extend video by cloning last frame:
```bash
ffmpeg -y -i scene_video.mp4 -i scene_audio.mp3 \
    -filter_complex "[0:v]tpad=stop_mode=clone:stop_duration=DIFF[v]" \
    -map "[v]" -map 1:a -t AUDIO_DURATION \
    -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
    final_scene.mp4
```

**If video is longer than audio** — pad audio with silence:
```bash
ffmpeg -y -i scene_video.mp4 -i scene_audio.mp3 \
    -filter_complex "[1:a]apad=pad_dur=DIFF[a]" \
    -map 0:v -map "[a]" -t VIDEO_DURATION \
    -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
    final_scene.mp4
```

### 4. Concatenate All Final Scenes
```bash
cat > concat.txt << 'EOF'
file 'final_scenes/scene1.mp4'
file 'final_scenes/scene2.mp4'
...
EOF
ffmpeg -y -f concat -safe 0 -i concat.txt -c copy final_pitch.mp4
```

## Common Pitfalls

- **ImageMobject requires PNG** — Convert JPG to PNG first with PIL
- **Transparent logos need RGBA** — Use PIL to add alpha channel: `img.convert("RGBA")`
- **Audio/video duration mismatch** — Always measure both before muxing
- **Non-monotonic DTS warnings** — Harmless during concat; ignore if output plays correctly
- **Font rendering at low quality** — `-ql` (480p) has poor text; use `-qm` for text-heavy previews
- **Background processes for long renders** — Use `terminal(background=true, notify_on_complete=true)` for `-qh` renders

## File Delivery

The final video will be on the server at a known path. Common delivery methods:
- **SCP**: `scp ubuntu@SERVER_IP:/path/to/video.mp4 .`
- **HTTP server**: `python3 -m http.server 8080` in the video directory
- **Cloud upload**: rclone, or API-based upload if credentials available

External file-sharing services (transfer.sh, file.io, etc.) are often blocked on cloud servers. Prefer direct download methods.
