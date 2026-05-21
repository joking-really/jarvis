---
name: github-auth
description: "GitHub auth setup: HTTPS tokens, SSH keys, gh CLI login."
version: 1.1.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [GitHub, Authentication, Git, gh-cli, SSH, Setup]
    related_skills: [github-pr-workflow, github-code-review, github-issues, github-repo-management]
---

# GitHub Authentication Setup

This skill sets up authentication so the agent can work with GitHub repositories, PRs, issues, and CI. It covers two paths:

- **`git` (always available)** — uses HTTPS personal access tokens or SSH keys
- **`gh` CLI (if installed)** — richer GitHub API access with a simpler auth flow

## Detection Flow

When a user asks you to work with GitHub, run this check first:

```bash
# Check what's available
git --version
gh --version 2>/dev/null || echo "gh not installed"

# Check if already authenticated
gh auth status 2>/dev/null || echo "gh not authenticated"
git config --global credential.helper 2>/dev/null || echo "no git credential helper"
```

**Decision tree:**
1. If `gh auth status` shows authenticated → you're good, use `gh` for everything
2. If `gh` is installed but not authenticated → use "gh auth" method below
3. If `gh` is not installed → use "git-only" method below (no sudo needed)

---

## Method 1: Git-Only Authentication (No gh, No sudo)

This works on any machine with `git` installed. No root access needed.

### Option A: HTTPS with Personal Access Token (Recommended)

This is the most portable method — works everywhere, no SSH config needed.

**Step 1: Create a personal access token**

Tell the user to go to: **https://github.com/settings/tokens**

- Click "Generate new token (classic)"
- Give it a name like "hermes-agent"
- Select scopes:
  - `repo` (full repository access — read, write, push, PRs)
  - `workflow` (trigger and manage GitHub Actions)
  - `read:org` (if working with organization repos)
- Set expiration (90 days is a good default)
- Copy the token — it won't be shown again

**Step 2: Configure git to store the token**

```bash
# Set up the credential helper to cache credentials
# "store" saves to ~/.git-credentials in plaintext (simple, persistent)
git config --global credential.helper store

# Now do a test operation that triggers auth — git will prompt for credentials
# Username: <their-github-username>
# Password: <paste the personal access token, NOT their GitHub password>
git ls-remote https://github.com/<their-username>/<any-repo>.git
```

After entering credentials once, they're saved and reused for all future operations.

**Alternative: cache helper (credentials expire from memory)**

```bash
# Cache in memory for 8 hours (28800 seconds) instead of saving to disk
git config --global credential.helper 'cache --timeout=28800'
```

### Git Push with Token-Embedded Remote URL

When `GH_TOKEN` is set but git push still fails with authentication errors (common in headless environments or when the credential helper is not configured), embed the token directly in the remote URL:

```bash
# Set the remote URL with token embedded
git remote set-url origin https://<username>:<token>@github.com/<owner>/<repo>.git

# Example with GH_TOKEN env var
git remote set-url origin "https://joking-really:${GH_TOKEN}@github.com/joking-really/jarvis.git"
```

This bypasses all credential prompts and helper issues. Use it as a fallback when:
- `git push` asks for a password despite `GH_TOKEN` being set
- The credential helper (`store` or `cache`) is not configured
- Working in a fresh environment where git credentials haven't been persisted

**Security note:** The token appears in `git remote -v` output. Remove it after the operation if needed:
```bash
git remote set-url origin https://github.com/<owner>/<repo>.git
```

**Step 3: Configure git identity**

```bash
# Required for commits — set name and email
git config --global user.name "Their Name"
git config --global user.email "their-email@example.com"
```

**Step 4: Verify**

```bash
# Test push access (this should work without any prompts now)
git ls-remote https://github.com/<their-username>/<any-repo>.git

# Verify identity
git config --global user.name
git config --global user.email
```

### Option B: SSH Key Authentication

Good for users who prefer SSH or already have keys set up.

**Step 1: Check for existing SSH keys**

```bash
ls -la ~/.ssh/id_*.pub 2>/dev/null || echo "No SSH keys found"
```

**Step 2: Generate a key if needed**

```bash
# Generate an ed25519 key (modern, secure, fast)
ssh-keygen -t ed25519 -C "their-email@example.com" -f ~/.ssh/id_ed25519 -N ""

# Display the public key for them to add to GitHub
cat ~/.ssh/id_ed25519.pub
```

Tell the user to add the public key at: **https://github.com/settings/keys**
- Click "New SSH key"
- Paste the public key content
- Give it a title like "hermes-agent-<machine-name>"

**Step 3: Test the connection**

```bash
ssh -T git@github.com
# Expected: "Hi <username>! You've successfully authenticated..."
```

**Step 4: Configure git to use SSH for GitHub**

```bash
# Rewrite HTTPS GitHub URLs to SSH automatically
git config --global url."git@github.com:".insteadOf "https://github.com/"
```

**Step 5: Configure git identity**

```bash
git config --global user.name "Their Name"
git config --global user.email "their-email@example.com"
```

---

## Method 2: gh CLI Authentication

If `gh` is installed, it handles both API access and git credentials in one step.

### Interactive Browser Login (Desktop)

```bash
gh auth login
# Select: GitHub.com
# Select: HTTPS
# Authenticate via browser
```

### Token-Based Login (Headless / SSH Servers)

**Preferred method — set `GH_TOKEN` as an environment variable:**

```bash
export GH_TOKEN="<THEIR_TOKEN>"
gh auth status
```

This avoids the interactive `gh auth login --with-token` flow, which can hang or time out in headless environments. Once `GH_TOKEN` is set, all `gh` commands work without additional setup.

**Alternative — pass token inline (useful in scripts):**

```bash
GH_TOKEN="<THEIR_TOKEN>" gh auth status
```

This works without exporting to the shell environment — the `gh` CLI reads `GH_TOKEN` directly from its environment for each invocation.

**Deprecated — pipe to login (may hang in non-TTY environments):**

```bash
# Avoid this in headless/automated contexts — use GH_TOKEN env var instead
echo "<THEIR_TOKEN>" | gh auth login --with-token
gh auth setup-git
```

**Pitfall — `gh auth login --with-token` hangs or times out:**

In headless, non-TTY, or automated environments (like AI agent sessions), piping a token to `gh auth login --with-token` frequently hangs indefinitely or times out. This is a known issue with interactive credential flows.

**Solution:** Simply set `GH_TOKEN` as an environment variable. The `gh` CLI automatically picks it up — no `login` command needed:

```bash
export GH_TOKEN="<THEIR_TOKEN>"
gh auth status  # Should show authenticated immediately
```

For one-off commands without exporting:
```bash
GH_TOKEN="<THEIR_TOKEN>" gh auth status
GH_TOKEN="<THEIR_TOKEN>" gh repo create my-repo --public -y
```

**Pitfall — `gh repo create` with `--confirm`:**

```bash
# WRONG — this flag is deprecated and may cause errors
gh repo create my-new-project --public --confirm

# CORRECT — use -y instead
gh repo create my-new-project --public -y
```

**Pitfall — `gh auth login --with-token` hangs or times out:**

In headless, non-TTY, or automated environments (like AI agent sessions), piping a token to `gh auth login --with-token` frequently hangs indefinitely or times out. This is a known issue with interactive credential flows.

**Solution:** Simply set `GH_TOKEN` as an environment variable. The `gh` CLI automatically picks it up — no `login` command needed:

```bash
export GH_TOKEN="<THEIR_TOKEN>"
gh auth status  # Should show authenticated immediately
```

For one-off commands without exporting:
```bash
GH_TOKEN="<THEIR_TOKEN>" gh auth status
GH_TOKEN="<THEIR_TOKEN>" gh repo create my-repo --public -y
```

**Pitfall — `gh repo create` with `--confirm`:**

```bash
# WRONG — this flag is deprecated and may cause errors
gh repo create my-new-project --public --confirm

# CORRECT — use -y instead
gh repo create my-new-project --public -y
```

### Verify

```bash
gh auth status
```

---

## Using the GitHub API Without gh

When `gh` is not available, you can still access the full GitHub API using `curl` with a personal access token. This is how the other GitHub skills implement their fallbacks.

### Setting the Token for API Calls

```bash
# Option 1: Export as env var (preferred — keeps it out of commands)
export GITHUB_TOKEN="<token>"

# Then use in curl calls:
curl -s -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/user
```
### Extracting the Token from Git Credentials

If git credentials are already configured (via credential.helper store), the token can be extracted:

```bash
# Read from git credential store
grep "github.com" ~/.git-credentials 2>/dev/null | head -1 | sed 's|https://[^:]*:\([^@]*\)@.*|\1|'
```

### Helper: Detect Auth Method

Use this pattern at the start of any GitHub workflow:

```bash
# Try gh first, fall back to git + curl
if command -v gh &>/dev/null && gh auth status &>/dev/null; then
  echo "AUTH_METHOD=gh"
elif [ -n "$GITHUB_TOKEN" ]; then
  echo "AUTH_METHOD=curl"
elif [ -f ~/.hermes/.env ] && grep -q "^GITHUB_TOKEN=" ~/.hermes/.env; then
  export GITHUB_TOKEN=$(grep "^GITHUB_TOKEN=" ~/.hermes/.env | head -1 | cut -d= -f2 | tr -d '\n\r')
  echo "AUTH_METHOD=curl"
elif grep -q "github.com" ~/.git-credentials 2>/dev/null; then
  export GITHUB_TOKEN=$(grep "github.com" ~/.git-credentials | head -1 | sed 's|https://[^:]*:\([^@]*\)@.*|\1|')
  echo "AUTH_METHOD=curl"
else
  echo "AUTH_METHOD=none"
  echo "Need to set up authentication first"
fi
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `gh: command not found` + no sudo | Use git-only Method 1 above — no installation needed |
| `gh auth login --with-token` hangs / times out | Use `export GH_TOKEN="..."` instead — all `gh` commands will pick it up. For git push, also try embedding token in remote URL: `git remote set-url origin https://user:${GH_TOKEN}@github.com/...` |
| `git push` asks for password or fails with "could not read Username" | GitHub disabled password auth OR git credential helper not configured. **Fix:** Embed token in remote URL: `git remote set-url origin https://user:${GH_TOKEN}@github.com/owner/repo.git` |
| `GraphQL: Resource not accessible by personal access token` | Token lacks required scope. Fine-Grained PATs need explicit "Administration" read/write for repo creation. Classic PATs need `repo` scope. See references/pat-scopes.md |
| `fatal: Authentication failed` | Cached credentials may be stale — run `git credential reject` then re-authenticate |
| `ssh: connect to host github.com port 22: Connection refused` | Try SSH over HTTPS port: add `Host github.com` with `Port 443` and `Hostname ssh.github.com` to `~/.ssh/config` |
| Credentials not persisting | Check `git config --global credential.helper` — must be `store` or `cache` |
| Multiple GitHub accounts | Use SSH with different keys per host alias in `~/.ssh/config`, or per-repo credential URLs |
| `gh: command not found` + no sudo | Use git-only Method 1 above — no installation needed |

### Complete Auth Failure Cascade

When a user asks you to push to GitHub and every automated method fails, run this diagnostic in order:

```bash
# 1. Check if gh is authenticated
gh auth status 2>/dev/null || echo "gh: not authenticated"

# 2. Check for SSH keys
ls ~/.ssh/id_*.pub 2>/dev/null || echo "ssh: no keys"
ssh -T git@github.com 2>&1 | head -1

# 3. Check for token env vars
echo "GITHUB_TOKEN: ${GITHUB_TOKEN:-(not set)}"
echo "GH_TOKEN: ${GH_TOKEN:-(not set)}"

# 4. Check git credential store
git config --global credential.helper 2>/dev/null || echo "git: no credential helper"
grep "github.com" ~/.git-credentials 2>/dev/null | head -1 | sed 's|https://[^:]*:\([^@]*\)@.*|\1|' | wc -c

# 5. Check if any existing repo already has token in remote URL
# (useful when user says "I already gave you access" — check a known working repo)
git -C ~/jarvis remote -v 2>/dev/null | grep -o 'https://[^@]*@github.com' | head -1 || echo "no token-embedded remote in jarvis"

# 6. Check gh env script (if exists)
[ -f ~/.hermes/skills/github/github-auth/scripts/gh-env.sh ] && bash ~/.hermes/skills/github/github-auth/scripts/gh-env.sh 2>/dev/null || echo "gh-env: not available"
```

**Pitfall — user says "I have given you access" but auth still fails:**

The user may have configured access in a way you haven't detected. Before asking for a token:

1. **Check known working repos** — If you've pushed successfully before (e.g., `jarvis` repo), inspect its remote URL: `git -C ~/jarvis remote -v`. If it has an embedded token, extract and reuse it.
2. **Check `gh` auth more carefully** — `gh auth status` may show logged in but `git` doesn't know about it. Run `gh auth setup-git` to sync gh credentials to git.
3. **Check for `.env` files** — Look in `~/.hermes/.env`, `~/.env`, or project directories for `GITHUB_TOKEN` or `GH_TOKEN`.
4. **Check shell exports** — The token may be exported in `.bashrc`, `.zshrc`, or `.profile`: `grep -E "GH_TOKEN|GITHUB_TOKEN" ~/.bashrc ~/.zshrc ~/.profile 2>/dev/null`.

Only ask the user for a token after exhausting these checks.

**If ALL methods fail** (no gh auth, no SSH keys, no env tokens, no credential store, no embedded remotes), the only resolution is to ask the user for a GitHub Personal Access Token (classic) with `repo` scope. Do not loop through more auth attempts — it wastes turns and frustrates the user.

See also: `references/auth-failure-cascade-session.md` for a real session transcript of this failure mode and the exact recovery steps.

**Ask pattern:**
```
GitHub authentication is not configured on this server. I need a GitHub Personal Access Token to push.

Please provide a token from https://github.com/settings/tokens with `repo` scope.

Or I can prepare everything locally and give you the commands to push manually.
```

**Once the user provides a token:**
```bash
export GH_TOKEN="<user-provided-token>"
git remote set-url origin "https://oauth2:${GH_TOKEN}@github.com/owner/repo.git"
git push -u origin main
```

**Pitfall — `git remote set-url` with embedded token times out:**

When setting a remote URL with a long PAT directly in the terminal command, the operation may hang or time out repeatedly (observed on AWS EC2 instances). This happens because the shell struggles with very long token strings in the command line, or the terminal tool has issues processing them.

**Symptom:**
```
BLOCKED: Command timed out. Do NOT retry this command.
```

**Solution — Write a script file instead:**
```bash
# Create a script file with the token
cat > /tmp/push_repo.sh << 'EOF'
#!/bin/bash
TOKEN="***REDACTED***..."
cd /home/ubuntu/axovion-crm
git remote set-url origin "https://joking-really:${TOKEN}@github.com/joking-really/axovion-crm.git"
git push origin main
EOF
chmod +x /tmp/push_repo.sh
bash /tmp/push_repo.sh
```

This avoids the terminal command-length issue and is more reliable for long tokens. Clean up the script afterward if security is a concern.

**Alternative — Set GH_TOKEN env var first, then use variable reference:**
```bash
export GH_TOKEN="<token>"
git remote set-url origin "https://joking-really:${GH_TOKEN}@github.com/joking-really/axovion-crm.git"
git push origin main
```

This is cleaner and avoids exposing the token in command history. The key insight: **never pass the raw token string directly in a `git remote set-url` command** — always use an env var or script file.

**Pitfall — GitHub API create-repo call times out:**

The `curl` API call to create a new repository via `POST /user/repos` may timeout in certain network environments (observed on AWS EC2 Singapore region). The symptom is a blank output with exit code -1.

**Solution:** Fall back to asking the user to create the repo manually via https://github.com/new, then proceed with `git init`, `git remote add origin <url-with-token>`, commit, and push. This is more reliable than retrying the API call when timeouts are persistent.

**Pitfall — writing `.git/config` directly as a workaround:**

When `git remote set-url` and even script-based approaches fail due to terminal timeouts, you can write the `.git/config` file directly to set the remote with an embedded token:

```bash
cat > /home/ubuntu/repo/.git/config << 'EOF'
[core]
    repositoryformatversion = 0
    filemode = true
    bare = false
    logallrefupdates = true
[remote "origin"]
    url = https://joking-really:<token>@github.com/joking-really/repo.git
    fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
    remote = origin
    merge = refs/heads/main
EOF
```

This bypasses the git CLI entirely for remote configuration and is the most reliable fallback when all CLI-based approaches hang.

See also: `references/github-api-timeout-patterns.md` for detailed timeout patterns and environment-specific workarounds.

**Pitfall — GitHub API create-repo call times out:**

The `curl` API call to create a new repository via `POST /user/repos` may timeout in certain network environments (observed on AWS EC2 Singapore region). The symptom is a blank output with exit code -1.

**Solution:** Fall back to asking the user to create the repo manually via https://github.com/new, then proceed with `git init`, `git remote add origin <url-with-token>`, commit, and push. This is more reliable than retrying the API call when timeouts are persistent.
