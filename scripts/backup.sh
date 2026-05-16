#!/bin/bash
# Jarvis Backup Script
# Run this after every session to persist memory

set -e

cd ~/jarvis

echo "🤖 Jarvis backup starting..."

# Add all changes
git add .

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "No changes to backup."
    exit 0
fi

# Commit with timestamp
COMMIT_MSG="backup: $(date -u +%Y-%m-%d_%H:%M:%S UTC)"
git commit -m "$COMMIT_MSG"

# Push to GitHub
git push origin main

echo "✅ Backup complete: $COMMIT_MSG"
echo "🔗 https://github.com/joking-really/jarvis"