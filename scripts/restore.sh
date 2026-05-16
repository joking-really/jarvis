#!/bin/bash
# Jarvis Restore Script
# Run on a new server to restore Jarvis

set -e

echo "🤖 Jarvis restore starting..."

# Check prerequisites
if ! command -v git &> /dev/null; then
    echo "Installing git..."
    sudo apt update && sudo apt install -y git
fi

if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update && sudo apt install -y gh
fi

# Check for token
if [ -z "$GH_TOKEN" ]; then
    echo "⚠️  Please set GH_TOKEN environment variable with your GitHub PAT"
    exit 1
fi

# Authenticate
echo "$GH_TOKEN" | gh auth login --with-token

# Clone repo
if [ ! -d "$HOME/jarvis" ]; then
    gh repo clone joking-really/jarvis ~/jarvis
    echo "✅ Repository cloned to ~/jarvis"
else
    echo "📁 Repository already exists at ~/jarvis"
    cd ~/jarvis && git pull
fi

echo ""
echo "🎉 Jarvis restored!"
echo "📖 Read config/system.md for identity"
echo "🧠 Check memory/ for context"
echo "🔗 Repo: https://github.com/joking-really/jarvis"