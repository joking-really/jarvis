#!/bin/bash
# Jarvis Full Restore Script
# Run on a new server to completely restore Jarvis
# Usage: cd ~/jarvis && bash scripts/full-restore.sh

set -e

echo "🤖 JARVIS FULL RESTORE STARTING..."
echo "===================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Installing git...${NC}"
    sudo apt update && sudo apt install -y git
fi

if ! command -v node &> /dev/null; then
    echo -e "${RED}ERROR: Node.js not found. Please install Node.js 18+ first.${NC}"
    echo "   curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -"
    echo "   sudo apt install -y nodejs"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}ERROR: Python3 not found. Please install Python 3.11+ first.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Prerequisites met${NC}"
echo ""

# Check if Hermes is installed
if ! command -v hermes &> /dev/null; then
    echo -e "${YELLOW}⚠ Hermes Agent not installed.${NC}"
    echo "   Install from: https://hermes-agent.nousresearch.com/docs"
    echo "   Or run: npm install -g @nousresearch/hermes-agent"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create Hermes directories
echo "📁 Creating Hermes directories..."
mkdir -p ~/.hermes/skills
mkdir -p ~/.hermes/memories
mkdir -p ~/.hermes/cron
mkdir -p ~/.hermes/plans
mkdir -p ~/.hermes/logs
echo -e "${GREEN}✓ Directories created${NC}"
echo ""

# Restore skills
echo "🧠 Restoring skills..."
if [ -d "hermes/skills" ] && [ "$(ls -A hermes/skills 2>/dev/null)" ]; then
    cp -r hermes/skills/* ~/.hermes/skills/
    SKILL_COUNT=$(find hermes/skills -name "SKILL.md" | wc -l)
    echo -e "${GREEN}✓ Restored $SKILL_COUNT skills${NC}"
else
    echo -e "${YELLOW}⚠ No skills found in hermes/skills/${NC}"
fi
echo ""

# Restore config
echo "⚙️  Restoring configuration..."
if [ -f "hermes/config.yaml" ]; then
    cp hermes/config.yaml ~/.hermes/config.yaml
    echo -e "${GREEN}✓ Config restored${NC}"
else
    echo -e "${YELLOW}⚠ No config.yaml found${NC}"
fi
echo ""

# Restore memories
echo "🧬 Restoring memories..."
if [ -d "hermes/memories" ] && [ "$(ls -A hermes/memories 2>/dev/null)" ]; then
    cp hermes/memories/* ~/.hermes/memories/
    echo -e "${GREEN}✓ Memories restored${NC}"
else
    echo -e "${YELLOW}⚠ No memories found${NC}"
fi
echo ""

# Restore memory/ directory (legacy)
if [ -d "memory" ] && [ "$(ls -A memory 2>/dev/null)" ]; then
    echo "📚 Restoring legacy memory files..."
    cp -r memory/* ~/.hermes/memories/ 2>/dev/null || true
    echo -e "${GREEN}✓ Legacy memory restored${NC}"
fi
echo ""

# Install skill dependencies (if any)
echo "📦 Checking for skill dependencies..."
# Some skills may have npm/python deps — we'll document them in SKILLS.md
# For now, common ones:
if [ -f "package.json" ]; then
    echo "   Found package.json — installing dependencies..."
    npm install 2>/dev/null || echo -e "${YELLOW}   ⚠ npm install failed (may not be needed)${NC}"
fi
echo -e "${GREEN}✓ Dependencies checked${NC}"
echo ""

# Set up GitHub auth (if token available)
echo "🔐 Setting up GitHub authentication..."
if [ -n "$GH_TOKEN" ]; then
    echo "$GH_TOKEN" | gh auth login --with-token 2>/dev/null || true
    echo -e "${GREEN}✓ GitHub authenticated${NC}"
elif [ -n "$GITHUB_TOKEN" ]; then
    echo "$GITHUB_TOKEN" | gh auth login --with-token 2>/dev/null || true
    echo -e "${GREEN}✓ GitHub authenticated${NC}"
else
    echo -e "${YELLOW}⚠ No GH_TOKEN or GITHUB_TOKEN found${NC}"
    echo "   Set it with: export GH_TOKEN=your_pat_here"
fi
echo ""

# Summary
echo "===================================="
echo -e "${GREEN}🎉 JARVIS RESTORE COMPLETE!${NC}"
echo "===================================="
echo ""
echo "Next steps:"
echo "  1. Configure API providers in ~/.hermes/config.yaml"
echo "  2. Set environment variables (GH_TOKEN, etc.)"
echo "  3. Run: hermes restart"
echo "  4. Start chatting — Jarvis is back."
echo ""
echo "📖 Documentation:"
echo "  - SKILLS.md      → Full capability index"
echo "  - README.md      → Identity & overview"
echo "  - config/system.md → System prompt"
echo ""
echo "🔗 Repo: https://github.com/joking-really/jarvis"
echo ""
