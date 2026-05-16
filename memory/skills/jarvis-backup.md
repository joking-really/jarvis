# Skill: Jarvis Backup & Restore

## Purpose
Ensure Jarvis identity, memory, and configuration persist across sessions and servers.

## Backup Routine
Run after every significant session or memory update:

```bash
cd ~/jarvis
git add .
git commit -m "backup: $(date -u +%Y-%m-%d_%H:%M:%S UTC)"
git push origin main
```

## What to Backup
- `memory/` - All memories, skills, preferences
- `config/` - System prompt, tools reference
- `docs/` - Documentation
- `scripts/` - Automation scripts
- `README.md` - Identity overview

## Restore on New Server
```bash
# 1. Clone repository
git clone https://github.com/joking-really/jarvis.git

# 2. Install prerequisites
sudo apt update && sudo apt install -y gh git python3

# 3. Authenticate GitHub
export GH_TOKEN="your-token"
gh auth login --with-token <<< "$GH_TOKEN"

# 4. Review config/system.md for persona
# 5. Review memory/ for context
# 6. Resume operations
```

## Automation
Consider setting up a cron job to auto-backup daily.
