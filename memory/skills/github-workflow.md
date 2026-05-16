# Skill: GitHub Workflow

## Authentication
- Use `GH_TOKEN` env var for all gh commands
- Account: joking-really
- Verify: `gh auth status`

## Common Commands
```bash
# Check auth
GH_TOKEN=$GH_TOKEN gh auth status

# List repos
GH_TOKEN=$GH_TOKEN gh repo list

# Create repo
GH_TOKEN=$GH_TOKEN gh repo create <name> --public -y

# Clone repo
GH_TOKEN=$GH_TOKEN gh repo clone <owner>/<repo>

# Push changes
cd ~/jarvis && git add . && git commit -m "msg" && git push
```

## Permissions Required
- Administration: Read/Write (for repo creation)
- Contents: Read/Write (for code)
- Metadata: Read (required, auto-granted)

## Pitfalls
- Fine-grained PATs need explicit permission grants
- `--confirm` flag is deprecated, use `-y` instead
- Token must be passed via env var, not stdin in some contexts
