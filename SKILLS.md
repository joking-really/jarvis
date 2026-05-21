# Axovion Agent Capability Index

This document maps every skill in this repository to its operational domain.
Use this to understand what this agent can do and how to invoke capabilities.

## Core Framework
| Skill | Domain | Purpose |
|-------|--------|---------|
| axovion-master-agent | Operations | Central agency framework, quality standards, role definition |

## Software Development
| Skill | Domain | Purpose |
|-------|--------|---------|
| plan | Planning | Write implementation plans to .hermes/plans/ |
| spike | Validation | Throwaway experiments before build |
| subagent-driven-development | Execution | Delegate tasks via subagents (2-stage review) |
| test-driven-development | Quality | Enforce RED-GREEN-REFACTOR workflow |
| systematic-debugging | Quality | 4-phase root cause debugging |
| python-debugpy | Debugging | Python remote debugging via debugpy |
| node-inspect-debugger | Debugging | Node.js debugging via --inspect |
| requesting-code-review | Quality | Pre-commit security scan + quality gates |
| hermes-agent-skill-authoring | Documentation | Author in-repo SKILL.md files |
| saas-architecture-discovery | Architecture | SaaS product architecture discovery sessions |
| writing-plans | Planning | Implementation plans with bite-sized tasks |

## DevOps
| Skill | Domain | Purpose |
|-------|--------|---------|
| agent-backup-restore | Operations | Backup/restore agent state: skills, memories, config |
| kanban-orchestrator | Project Management | Decomposition playbook for kanban orchestrator |
| kanban-worker | Project Management | Worker agent pitfalls and edge cases |
| webhook-subscriptions | Integration | Event-driven agent runs via webhooks |

## GitHub
| Skill | Domain | Purpose |
|-------|--------|---------|
| github-auth | Authentication | GitHub auth setup: tokens, SSH, gh CLI |
| github-pr-workflow | Workflow | PR lifecycle: branch, commit, open, CI, merge |
| github-code-review | Quality | Review PRs with inline comments |
| github-issues | Management | Create, triage, label, assign issues |
| github-repo-management | Repository | Clone, create, fork, manage remotes |
| codebase-inspection | Analysis | Inspect codebases: LOC, languages, ratios |

## Creative
| Skill | Domain | Purpose |
|-------|--------|---------|
| axovion-remotion-reels | Video | Axovion TOF/MOF/BOF reel generation via Remotion |
| remotion-video-generation | Video | General Remotion video generation |
| excalidraw | Diagrams | Hand-drawn Excalidraw JSON diagrams |
| architecture-diagram | Diagrams | Dark-themed SVG architecture diagrams |
| sketch | Mockups | Throwaway HTML mockups (2-3 variants) |
| claude-design | Design | One-off HTML artifacts (landing, deck, prototype) |
| ascii-art | Art | ASCII art via pyfiglet, cowsay, boxes |
| p5js | Generative Art | p5.js sketches: gen art, shaders, interactive |
| pixel-art | Art | Pixel art with era palettes |

## Media
| Skill | Domain | Purpose |
|-------|--------|---------|
| video-editing-ffmpeg | Video | Video editing, analysis, manipulation |
| youtube-content | Content | Transcripts to summaries, threads, blogs |
| gif-search | Media | Search/download GIFs from Tenor |
| spotify | Audio | Spotify playback, search, queue management |
| songsee | Audio | Audio spectrograms and feature extraction |
| heartmula | Audio | Suno-like song generation |

## MLOps
| Skill | Domain | Purpose |
|-------|--------|---------|
| llama-cpp | Inference | Local GGUF inference + HF Hub discovery |
| serving-llms-vllm | Serving | vLLM high-throughput LLM serving |
| audiocraft-audio-generation | Audio | MusicGen text-to-music, AudioGen text-to-sound |
| segment-anything-model | Vision | SAM zero-shot image segmentation |
| obliteratus | Research | Abliterate LLM refusals |
| dspy | Research | Declarative LM programs, auto-optimize prompts |
| huggingface-hub | Models | HF CLI: search, download, upload |
| evaluating-llms-harness | Evaluation | lm-eval-harness benchmarking |
| weights-and-biases | Experiment Tracking | W&B logging, sweeps, model registry |

## Productivity
| Skill | Domain | Purpose |
|-------|--------|---------|
| google-workspace | Productivity | Gmail, Calendar, Drive, Docs, Sheets |
| notion | Productivity | Notion API: pages, databases, markdown |
| airtable | Productivity | Airtable REST API: records, filters, upserts |
| linear | Project Management | Linear issues, projects, teams |
| powerpoint | Documents | Create, read, edit .pptx decks |
| nano-pdf | Documents | Edit PDF text/typos via nano-pdf CLI |
| ocr-and-documents | Documents | Extract text from PDFs/scans |
| maps | Geo | Geocode, POIs, routes, timezones |

## Research
| Skill | Domain | Purpose |
|-------|--------|---------|
| arxiv | Research | Search arXiv papers |
| blogwatcher | Monitoring | Monitor blogs and RSS/Atom feeds |
| llm-wiki | Knowledge | Karpathy's LLM Wiki |
| polymarket | Markets | Query Polymarket data |

## Social Media
| Skill | Domain | Purpose |
|-------|--------|---------|
| xurl | X/Twitter | Post, search, DM, media via xurl CLI |

## Note-Taking
| Skill | Domain | Purpose |
|-------|--------|---------|
| obsidian | Notes | Read, search, create, edit Obsidian vault |

## Smart Home
| Skill | Domain | Purpose |
|-------|--------|---------|
| openhue | Home | Philips Hue lights, scenes, rooms |

## Autonomous Agents
| Skill | Domain | Purpose |
|-------|--------|---------|
| claude-code | Coding | Delegate to Claude Code CLI |
| codex | Coding | Delegate to OpenAI Codex CLI |
| opencode | Coding | Delegate to OpenCode CLI |

## MCP
| Skill | Domain | Purpose |
|-------|--------|---------|
| native-mcp | Integration | MCP client: connect servers, register tools |

---

## Quick Reference: Skill Commands

```bash
# List all skills
hermes skills list

# View a skill
hermes skills view axovion-master-agent

# Create a new skill
hermes skills create --name my-skill --category devops

# Update a skill
hermes skills patch my-skill --file SKILL.md
```

## Agent Revival

If this agent needs to be restored from backup:

```bash
git clone https://github.com/joking-really/jarvis.git
cd jarvis
./scripts/full-restore.sh
```

Then re-enter all credentials (they are redacted from the backup for security).
