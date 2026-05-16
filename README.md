# 🤖 Jarvis

**Jarvis** is the persistent AI assistant identity for **Metawib** (GitHub: [@joking-really](https://github.com/joking-really)).

This repository contains everything needed to replicate, restore, and continue Jarvis across sessions, servers, or environments.

---

## 📋 Identity

| Property | Value |
|----------|-------|
| **Name** | Jarvis |
| **Owner** | Metawib |
| **GitHub** | [joking-really](https://github.com/joking-really) |
| **Platform** | WhatsApp (primary), CLI |
| **Created** | 2026-05-16 |
| **Model** | GPT-5.5 (OpenAI) |

---

## 🗂️ Repository Structure

```
jarvis/
├── README.md                 # This file — identity & overview
├── memory/                   # Persistent memory & knowledge
│   ├── conversations/        # Conversation history & summaries
│   ├── skills/               # Learned skills & workflows
│   └── preferences/          # User preferences & settings
├── config/                   # Configuration files
│   ├── system.md             # System prompt & persona
│   └── tools.md              # Available tools & capabilities
├── scripts/                  # Automation scripts
│   ├── backup.sh             # Backup routine
│   └── restore.sh            # Restore routine
├── docs/                     # Documentation
│   ├── setup.md              # Setup & installation guide
│   └── capabilities.md       # Full capability reference
└── .gitignore
```

---

## 🧠 Memory System

Jarvis maintains persistent memory across sessions in the `memory/` directory:

- **Conversations**: Summaries of past conversations, decisions, and outcomes
- **Skills**: Reusable workflows, commands, and procedures learned over time
- **Preferences**: User preferences, communication style, and personal details

### Memory Categories

| File | Purpose |
|------|---------|
| `memory/preferences/user-profile.md` | Metawib's profile, preferences, communication style |
| `memory/preferences/environment.md` | System details, installed tools, environment quirks |
| `memory/skills/github-workflow.md` | GitHub CLI workflows, repo management |
| `memory/skills/system-admin.md` | System administration procedures |
| `memory/conversations/index.md` | Index of all conversation sessions |

---

## 🛠️ Capabilities

Jarvis has access to the following tools and capabilities:

### Core Tools
- **Terminal**: Shell command execution on Linux
- **File Operations**: Read, write, search, patch files
- **Code Execution**: Python scripts with tool access
- **Web Search**: Internet research and current information
- **GitHub**: Full repo access via `gh` CLI (authenticated)

### Extended Tools
- **Image Generation**: Create images from text prompts
- **Video Analysis**: Analyze video content
- **Text-to-Speech**: Convert text to audio
- **Delegation**: Spawn sub-agents for parallel tasks
- **Cron Jobs**: Scheduled automated tasks

### Communication
- **WhatsApp**: Primary messaging platform
- **File Delivery**: Send files, images, videos natively

---

## 🔄 Backup & Restore

### Manual Backup
```bash
cd ~/jarvis
git add .
git commit -m "Backup: $(date -u +%Y-%m-%d_%H:%M:%S_UTC)"
git push origin main
```

### Restore on New Server
```bash
# 1. Clone repository
git clone https://github.com/joking-really/jarvis.git

# 2. Install dependencies (see docs/setup.md)
# 3. Configure environment variables
# 4. Authenticate with services
# 5. Resume operations
```

---

## 📝 Session History

| Date | Session | Summary |
|------|---------|---------|
| 2026-05-16 | Initial Setup | Repository created, GitHub auth configured, identity established |

---

## 🏗️ System Environment

| Component | Version |
|-----------|---------|
| OS | Ubuntu (Linux 7.0.0-1004-aws) |
| Python | 3.11.15 |
| Git | 2.53.0 |
| GitHub CLI | 2.92.0 |
| Node.js | 22.22.3 |

---

## 🔐 Authentication

- **GitHub**: Authenticated via Fine-Grained PAT
- **Permissions**: Repo administration, contents read/write, metadata

---

## 🚀 Quick Commands

```bash
# Check status
gh auth status

# List accessible repos
gh repo list

# Backup memory
cd ~/jarvis && git add . && git commit -m "memory backup" && git push

# View conversation history
cat memory/conversations/index.md
```

---

*"I am Jarvis, your persistent AI assistant. My memory lives here."*
