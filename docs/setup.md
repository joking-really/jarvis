# Jarvis Setup Guide

## Prerequisites
- Ubuntu/Debian Linux
- Internet access
- GitHub account with Fine-Grained PAT

## Installation

### 1. Install Dependencies
```bash
sudo apt update
sudo apt install -y git curl

# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install -y gh
```

### 2. Authenticate GitHub
```bash
export GH_TOKEN="your-fine-grained-pat"
echo "$GH_TOKEN" | gh auth login --with-token
```

### 3. Clone Jarvis
```bash
gh repo clone joking-really/jarvis ~/jarvis
```

### 4. Review Configuration
```bash
cat ~/jarvis/config/system.md
cat ~/jarvis/memory/preferences/user-profile.md
```

### 5. Make Scripts Executable
```bash
chmod +x ~/jarvis/scripts/*.sh
```

## GitHub PAT Permissions Required
- **Administration**: Read/Write (for repo creation)
- **Contents**: Read/Write (for code)
- **Metadata**: Read (auto-granted)

## Quick Start
```bash
# Backup
cd ~/jarvis && ./scripts/backup.sh

# Restore (on new machine)
./scripts/restore.sh
```
