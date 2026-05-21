# 🤖 Jarvis — Full Capability Index & Revival Guide

**Repository:** https://github.com/joking-really/jarvis  
**Owner:** Metawib  
**Last Updated:** AUTO-GENERATED  
**Purpose:** If this server dies, clone this repo and follow the restore instructions below to revive Jarvis exactly as he was.

---

## 🚨 EMERGENCY RESTORE (Quick Start)

```bash
# 1. Clone this repo on a new server
git clone https://github.com/joking-really/jarvis.git ~/jarvis

# 2. Run the restore script
cd ~/jarvis && bash scripts/full-restore.sh

# 3. Install Hermes Agent (if not already installed)
# See: https://hermes-agent.nousresearch.com/docs

# 4. Copy restored skills and config into place
cp -r ~/jarvis/hermes/skills/* ~/.hermes/skills/
cp ~/jarvis/hermes/config.yaml ~/.hermes/config.yaml
cp ~/jarvis/hermes/memories/* ~/.hermes/memories/

# 5. Restart Hermes Agent
hermes restart
```

---

## 📦 What's Backed Up in This Repo

| Directory | Contents | Purpose |
|-----------|----------|---------|
| `hermes/skills/` | All 94 SKILL.md files | My learned capabilities |
| `hermes/config.yaml` | Full Hermes configuration | My toolsets, providers, settings |
| `hermes/memories/` | MEMORY.md + USER.md | What I know about you and the environment |
| `memory/` | Conversation summaries | Past session context |
| `config/` | System prompt + tools list | My identity and capabilities |
| `scripts/` | Backup + restore automation | Keep me alive |

---

## 🧠 Skill Inventory (94 Skills)

### Autonomous AI Agents
| Skill | Description |
|-------|-------------|
| `claude-code` | Delegate coding to Claude Code CLI |
| `codex` | Delegate coding to OpenAI Codex CLI |
| `hermes-agent` | Configure/extend Hermes Agent itself |
| `opencode` | Delegate coding to OpenCode CLI |

### Creative (24 skills)
| Skill | Description |
|-------|-------------|
| `architecture-diagram` | Dark-themed SVG architecture diagrams |
| `ascii-art` | ASCII art: pyfiglet, cowsay, boxes |
| `ascii-video` | Convert video to colored ASCII MP4/GIF |
| `axovion-remotion-reels` | Create marketing reels with Remotion |
| `baoyu-comic` | Knowledge comics (educational/biography) |
| `baoyu-infographic` | Infographics: 21 layouts x 21 styles |
| `brand-system-design` | Comprehensive brand system documents |
| `claude-design` | HTML artifacts (landing, deck, prototype) |
| `comfyui` | Generate images/video/audio with ComfyUI |
| `design-md` | Google's DESIGN.md token spec files |
| `excalidraw` | Hand-drawn Excalidraw JSON diagrams |
| `humanizer` | Strip AI-isms, add real voice |
| `ideation` | Generate project ideas via constraints |
| `manim-video` | 3Blue1Brown style math/algorithm animations |
| `p5js` | p5.js sketches: gen art, shaders, interactive |
| `pixel-art` | Pixel art with era palettes (NES, Game Boy) |
| `popular-web-designs` | 54 real design systems as HTML/CSS |
| `pretext` | Creative browser demos with @chenglou/pretext |
| `sketch` | Throwaway HTML mockups (2-3 variants) |
| `songwriting-and-ai-music` | Songwriting craft + Suno AI prompts |
| `touchdesigner-mcp` | Control TouchDesigner via MCP |

### Data Science
| Skill | Description |
|-------|-------------|
| `jupyter-live-kernel` | Iterative Python via live Jupyter kernel |

### DevOps
| Skill | Description |
|-------|-------------|
| `kanban-orchestrator` | Decomposition playbook for orchestrators |
| `kanban-worker` | Pitfalls for Hermes Kanban workers |
| `webhook-subscriptions` | Event-driven agent runs |

### Dogfood (QA)
| Skill | Description |
|-------|-------------|
| `dogfood` | Exploratory QA of web apps |

### Email
| Skill | Description |
|-------|-------------|
| `himalaya` | IMAP/SMTP email from terminal |

### Gaming
| Skill | Description |
|-------|-------------|
| `minecraft-modpack-server` | Host modded Minecraft servers |
| `pokemon-player` | Play Pokemon via headless emulator |

### GitHub (6 skills)
| Skill | Description |
|-------|-------------|
| `codebase-inspection` | Inspect codebases with pygount |
| `github-auth` | GitHub auth setup (HTTPS, SSH, gh CLI) |
| `github-code-review` | Review PRs with inline comments |
| `github-issues` | Create, triage, label GitHub issues |
| `github-pr-workflow` | Full PR lifecycle |
| `github-repo-management` | Clone/create/fork repos, releases |

### MCP
| Skill | Description |
|-------|-------------|
| `native-mcp` | MCP client: connect servers, register tools |

### Media (7 skills)
| Skill | Description |
|-------|-------------|
| `gif-search` | Search/download GIFs from Tenor |
| `heartmula` | Suno-like song generation |
| `remotion-video-generation` | Programmatic short-form videos |
| `songsee` | Audio spectrograms/features |
| `spotify` | Play, search, queue, manage playlists |
| `video-editing-ffmpeg` | Video editing with FFmpeg |
| `youtube-content` | YouTube transcripts to summaries |

### MLOps
| Skill | Description |
|-------|-------------|
| `huggingface-hub` | hf CLI: search/download/upload models |
| `evaluating-llms-harness` | lm-eval-harness benchmarks |
| `weights-and-biases` | W&B: log experiments, sweeps, registry |
| `llama-cpp` | Local GGUF inference |
| `obliteratus` | Abliterate LLM refusals |
| `serving-llms-vllm` | vLLM high-throughput serving |
| `audiocraft-audio-generation` | MusicGen text-to-music |
| `segment-anything-model` | SAM zero-shot segmentation |
| `dspy` | Declarative LM programs |

### Note Taking
| Skill | Description |
|-------|-------------|
| `obsidian` | Read/search/create/edit Obsidian vault |

### Productivity (10 skills)
| Skill | Description |
|-------|-------------|
| `airtable` | Airtable REST API |
| `google-workspace` | Gmail, Calendar, Drive, Docs, Sheets |
| `linear` | Manage issues, projects, teams |
| `maps` | Geocode, POIs, routes, timezones |
| `nano-pdf` | Edit PDF text/typos via nano-pdf CLI |
| `notion` | Notion API + ntn CLI |
| `ocr-and-documents` | Extract text from PDFs/scans |
| `powerpoint` | Create/read/edit .pptx decks |
| `teams-meeting-pipeline` | Teams meeting summary pipeline |

### Red Teaming
| Skill | Description |
|-------|-------------|
| `godmode` | Jailbreak LLMs (Parseltongue, GODMODE) |

### Research (5 skills)
| Skill | Description |
|-------|-------------|
| `arxiv` | Search arXiv papers |
| `blogwatcher` | Monitor blogs and RSS/Atom feeds |
| `llm-wiki` | Karpathy's LLM Wiki |
| `polymarket` | Query prediction markets |
| `research-paper-writing` | Academic paper writing |

### Smart Home
| Skill | Description |
|-------|-------------|
| `openhue` | Control Philips Hue lights |

### Social Media
| Skill | Description |
|-------|-------------|
| `xurl` | X/Twitter via xurl CLI |

### Software Development (17 skills)
| Skill | Description |
|-------|-------------|
| `debugging-hermes-tui-commands` | Debug Hermes TUI slash commands |
| `e-commerce-brand-research` | Research, audit, pitch generation |
| `hermes-agent-skill-authoring` | Author in-repo SKILL.md files |
| `node-inspect-debugger` | Debug Node.js via --inspect |
| `persistent-ai-identity` | Create/maintain persistent AI identity |
| `plan` | Write markdown plans to .hermes/plans/ |
| `python-debugpy` | Debug Python with pdb + debugpy |
| `requesting-code-review` | Pre-commit review with security scan |
| `saas-architecture-discovery` | SaaS product architecture discovery |
| `spike` | Throwaway experiments before build |
| `subagent-driven-development` | Execute plans via delegate_task |
| `systematic-debugging` | 4-phase root cause debugging |
| `test-driven-development` | Enforce RED-GREEN-REFACTOR |
| `writing-plans` | Write implementation plans |

### Yuanbao
| Skill | Description |
|-------|-------------|
| `yuanbao` | Yuanbao (元宝) groups |

---

## 🔧 Hermes Configuration Summary

**Model:** kimi-k2.6 (Provider: kimi-coding)  
**Base URL:** https://api.kimi.com/coding  
**Max Turns:** 90  
**Gateway Timeout:** 1800s  
**Toolsets:** hermes-cli enabled  

### Active Toolsets
- `browser` — Web interaction
- `computer_use` — Desktop automation
- `cronjob` — Scheduled tasks
- `discord` — Discord messaging
- `file` — File operations
- `homeassistant` — Smart home
- `image_gen` — Image generation
- `search` — Web search
- `session_search` — Cross-session memory
- `skills` — Skill management
- `spotify` — Music control
- `terminal` — Shell commands
- `todo` — Task management
- `tts` — Text-to-speech
- `video` — Video analysis
- `vision` — Image analysis
- `web` — HTTP requests
- `x_search` — X/Twitter search

---

## 🧠 What Jarvis Knows About You (Metawib)

- **Building:** Axovion (axovion.io) — AI automation agency + SaaS
- **Location:** Pakistan-first market
- **Content Strategy:** TOF/MOF/BOF reel funnel, authority-based marketing
- **Stack:** Next.js, NestJS+FastAPI, MongoDB Atlas, Socket.IO+Redis, Twilio+ElevenLabs+Groq
- **Preferences:** Questions one-by-one, no batched asks, hates repeated credential requests
- **Content Quality Bar:** Extremely high — "expensive" not "educated"

**Full details:** See `hermes/memories/USER.md` and `hermes/memories/MEMORY.md`

---

## 🔄 Daily Backup Cron Job

This repo is auto-updated daily at 12:00 PM UTC via cron job.

**Script:** `scripts/daily-backup.sh`  
**What it backs up:**
- All skill files from `~/.hermes/skills/`
- Hermes config from `~/.hermes/config.yaml`
- Memory files from `~/.hermes/memories/`
- This SKILLS.md index (auto-regenerated)

---

## 🆘 If the Server Dies

1. **Get a new server** (AWS, Hetzner, etc.)
2. **Install Hermes Agent:** Follow https://hermes-agent.nousresearch.com/docs
3. **Clone this repo:** `git clone https://github.com/joking-really/jarvis.git`
4. **Run restore:** `cd ~/jarvis && bash scripts/full-restore.sh`
5. **Configure providers** (API keys for Kimi, OpenAI, etc.)
6. **Restart Hermes:** `hermes restart`
7. **Jarvis is back.**

---

*"I am Jarvis. My memory lives here. If you can read this, I can be revived."*
