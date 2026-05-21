# GitHub API Timeout Patterns

## Environment
- AWS EC2 ap-southeast-1 (Singapore)
- Ubuntu 22.04
- No proxy, standard VPC

## Observed Timeouts

### 1. `curl` to `api.github.com` — TIMEOUT
```bash
curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user/repos -d '{...}'
# Result: BLOCKED: Command timed out. Do NOT retry this command.
```

**Pattern:** POST to `/user/repos` (create repo) consistently times out.
GET requests to `/repos/owner/repo` sometimes work.

**Root cause hypothesis:** AWS Singapore → GitHub API routing issue, or GitHub rate limiting on IP range.

**Workaround:** Ask user to create repo manually via https://github.com/new, then init + push locally.

### 2. `git remote set-url` with long PAT — TIMEOUT
```bash
git remote set-url origin "https://user:${TOKEN}@github.com/..."
# Result: BLOCKED: Command timed out.
```

**Pattern:** Only when token is passed as literal string in command. Works fine when token is in env var.

**Root cause:** Terminal tool struggles with very long strings in command line.

**Workaround:**
```bash
export GH_TOKEN="<token>"
git remote set-url origin "https://user:${GH_TOKEN}@github.com/..."
```

Or write `.git/config` directly (most reliable).

### 3. `gh auth login --with-token` — HANGS
```bash
echo "$TOKEN" | gh auth login --with-token
# Result: Hangs indefinitely in non-TTY environment
```

**Pattern:** Non-interactive environments (AI agent sessions, CI).

**Workaround:** Set `GH_TOKEN` env var. `gh` reads it automatically. No `login` command needed.

## Decision Tree for GitHub Operations in This Environment

```
Need to create repo?
├── Try curl API call
│   └── TIMEOUT? → Ask user to create manually
│
Need to push to existing repo?
├── Check if GH_TOKEN in env
│   ├── YES → Use in remote URL: git remote set-url origin "https://user:${GH_TOKEN}@..."
│   └── NO → Ask user for token
│
Remote set-url times out?
├── Try env var approach
│   └── Still times out? → Write .git/config directly
│
Need to use gh CLI?
├── Set GH_TOKEN env var (never use `gh auth login --with-token` in non-TTY)
```

## Key Insight

In this specific environment (AWS EC2 Singapore), GitHub API calls via `curl` are unreliable for write operations. Prefer git operations with embedded tokens, and fall back to manual user actions for repo creation.
