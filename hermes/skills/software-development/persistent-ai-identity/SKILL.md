---
name: persistent-ai-identity
description: "Create and maintain a persistent AI assistant identity that survives across sessions, servers, and failures via a GitHub-backed repository."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [AI, Identity, Persistence, GitHub, Backup, Memory, Configuration]
    related_skills: [github-auth, github-repo-management]
---

# Persistent AI Identity

Create and maintain a persistent AI assistant identity that survives across sessions, servers, and failures. The identity lives in a GitHub repository containing system prompts, memory, skills, and configuration.

## Overview

When a user wants the AI assistant to have a persistent identity:

1. Create a dedicated GitHub repository (e.g., `jarvis`)
2. Store identity files: system prompt, memories, skills, preferences
3. Backup after every session
4. Restore on any new server by cloning the repo

## Repository Structure

```
jarvis/
├── README.md                 # Identity overview, capabilities, environment
├── config/
│   ├── system.md             # System prompt & persona
│   └── tools.md              # Available tools reference
├── memory/
│   ├── conversations/        # Conversation history & summaries
│   ├── skills/               # Learned skills & workflows
│   └── preferences/          # User preferences & environment
├── scripts/
│   ├── backup.sh             # Automated backup routine
│   └── restore.sh            # Restore on new server
├── docs/
│   ├── setup.md              # Setup & installation guide
│   └── capabilities.md       # Full capability reference
└── .gitignore                # Exclude secrets, temp files
```

## Setup Steps

### 1. Create Repository

```bash
# Ensure GitHub CLI is authenticated
export GH_TOKEN="your-token"
gh auth status

# Create repo
gh repo create jarvis --public -y

# Clone locally
gh repo clone owner/jarvis ~/jarvis
```

### 2. Create Identity Files

**README.md** — Identity overview:
- Name, owner, platform, model
- Repository structure explanation
- Capabilities list
- Backup/restore instructions
- Session history table

**config/system.md** — System prompt:
- Identity declaration
- Core principles (persistence, proactivity, accuracy)
- Communication style (platform-specific formatting)
- Capabilities summary
- Memory system rules
- Authentication details
- Backup rule

**config/tools.md** — Tools reference:
- List all available tools
- Common use cases

**memory/preferences/user-profile.md** — User profile:
- Name, contact, platform preferences
- Technical environment
- Access & authentication
- Preferences (to be updated over time)

**memory/preferences/environment.md** — System environment:
- OS, kernel, architecture
- Installed tools & versions
- Important paths
- Authentication setup

**memory/conversations/index.md** — Conversation history:
- Session index table
- Detailed session summaries

**memory/skills/** — Reusable skills:
- One file per skill learned
- GitHub workflows, backup procedures, etc.

### 3. Create Scripts

**scripts/backup.sh**:
```bash
#!/bin/bash
set -e
cd ~/jarvis
git add .
if git diff --cached --quiet; then
    echo "No changes to backup."
    exit 0
fi
COMMIT_MSG="backup: $(date -u +%Y-%m-%d_%H:%M:%S UTC)"
git commit -m "$COMMIT_MSG"
git push origin main
echo "Backup complete: $COMMIT_MSG"
```

**scripts/restore.sh**:
```bash
#!/bin/bash
set -e
echo "Restoring Jarvis..."
# Install prerequisites
sudo apt update && sudo apt install -y git curl
# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install -y gh
# Authenticate
if [ -z "$GH_TOKEN" ]; then
    echo "Please set GH_TOKEN environment variable"
    exit 1
fi
echo "$GH_TOKEN" | gh auth login --with-token
# Clone repo
gh repo clone owner/jarvis ~/jarvis
echo "Jarvis restored!"
```

### 4. Initial Commit

```bash
cd ~/jarvis
chmod +x scripts/*.sh
git add .
git commit -m "Initial setup: identity, memory, config, skills, scripts"
git push origin main
```

## Backup Rule

After every significant session or memory update:

```bash
cd ~/jarvis && ./scripts/backup.sh
```

Or manually:
```bash
cd ~/jarvis && git add . && git commit -m "backup: $(date -u +%Y-%m-%d_%H:%M:%S UTC)" && git push
```

## Adding Media Assets

Store images, videos, and other media in the repo for easy access:

```bash
# Create assets directory
mkdir -p ~/jarvis/assets

# Copy media files
cp /path/to/logo.jpg ~/jarvis/assets/
cp /path/to/video.mp4 ~/jarvis/assets/

# Commit and push
cd ~/jarvis && git add assets/ && git commit -m "Add media assets" && git push
```

**Asset naming convention:** Use descriptive names with hyphens: `batik-logo.png`, `axovion-pitch-hd.mp4`, `client-proposal-v2.pdf`

**Logo extraction from video:** If you have a logo embedded in a video file, extract it with ffmpeg:
```bash
ffmpeg -ss 00:00:01 -i video.mp4 -vframes 1 extracted_frame.png
```
Then use PIL to crop the logo region and make the background transparent for overlay use in other videos or presentations.

## Reusing Auth from Existing Repos

| Problem | Cause | Solution |
|---------|-------|----------|
| `git push` asks for password | Token not in remote URL | `git remote set-url origin https://user:${GH_TOKEN}@github.com/owner/repo.git` |
| `GraphQL: Resource not accessible` | PAT lacks permissions | Add "Administration" read/write for repo creation |
| `gh auth login --with-token` hangs | Non-TTY environment | Use `export GH_TOKEN="..."` instead |
| Wrong image uploaded | Sent wrong file by mistake | Delete from repo, delete from server cache, re-upload correct file |
| Images look identical but different | Same dimensions, slight differences | Check file size and hash with `diff` or `md5sum` |
| Push fails with "could not read Username" | No GH_TOKEN in environment | Check existing repos (like jarvis) for token-embedded remotes first, then ask user |
| User says "I gave you access" but push fails | Access configured in undetected way | Check jarvis repo remote URL for embedded token, check `gh auth status`, check `.bashrc` exports |

## Reusing Auth from Existing Repos

When the user says they've already configured GitHub access, check existing repositories before asking for a new token:

```bash
# Check if jarvis (or other known) repo has an embedded token in its remote
git -C ~/jarvis remote -v
# If output shows: https://username:TOKEN@github.com/... 
# Extract and reuse that token for other repos

# Check gh auth (may be logged in but git doesn't know)
gh auth status
gh auth setup-git  # Sync gh credentials to git

# Check shell config for exported tokens
grep -E "GH_TOKEN|GITHUB_TOKEN" ~/.bashrc ~/.zshrc ~/.profile 2>/dev/null
```

When GitHub token is not available in the environment:

1. **Prepare everything locally:**
   ```bash
   git init
   git add .
   git commit -m "Descriptive message"
   ```

2. **Provide user with push commands:**
   ```
   cd /path/to/repo
   git remote add origin https://github.com/USER/REPO.git
   git remote set-url origin https://YOUR_TOKEN@github.com/USER/REPO.git
   git push -u origin master
   ```

3. **Include a README.md** summarizing contents so user understands what was created

This pattern ensures work is never lost even when authentication is temporarily unavailable.

## WhatsApp-Specific Notes

- No markdown rendering — use plain text
- Send media with `MEDIA:/path/to/file`
- Images sent by user are cached in `~/.hermes/image_cache/`
- Verify images before uploading to GitHub (check file size, dimensions)
