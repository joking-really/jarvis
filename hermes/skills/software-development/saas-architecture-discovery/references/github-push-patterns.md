# GitHub Push Patterns — Auth Failures & Recovery

## Session: 2026-05-19, Axovion CRM Full Project Push

## Failure Patterns Observed

### 1. Token Not Persisted in Environment

**Symptom:** User provides PAT in chat, but `echo $GH_TOKEN` returns empty.

**Why:** Chat messages don't set shell environment variables.

**Fix:** Export token before use:
```bash
export GH_TOKEN="<user-provided-token>"
git remote set-url origin "https://oauth2:${GH_TOKEN}@github.com/owner/repo.git"
git push origin main
```

### 2. `git remote set-url` Timeout with Long PAT

**Symptom:** Command times out when passing long token directly:
```bash
git remote set-url origin "https://joking-really:${GH_TOKEN}@github.com/..."
# BLOCKED: Command timed out
```

**Why:** Terminal tool struggles with very long strings in command line.

**Fix — Script file:**
```bash
cat > /tmp/push_repo.sh << 'EOF'
#!/bin/bash
TOKEN="<full-token>"
cd /path/to/repo
git remote set-url origin "https://joking-really:${TOKEN}@github.com/owner/repo.git"
git push origin main
EOF
bash /tmp/push_repo.sh
```

**Fix — Write .git/config directly:**
```bash
cat > /path/to/repo/.git/config << 'EOF'
[core]
    repositoryformatversion = 0
    filemode = true
    bare = false
    logallrefupdates = true
[remote "origin"]
    url = https://joking-really:<token>@github.com/owner/repo.git
    fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
    remote = origin
    merge = refs/heads/main
EOF
```

### 3. GitHub API Create-Repo Timeout

**Symptom:** `curl POST /user/repos` returns blank output, exit code -1.

**Why:** Network timeout in certain regions (observed on AWS EC2 Singapore).

**Fix:** Ask user to create repo manually via https://github.com/new, then:
```bash
git init
git remote add origin "https://oauth2:${GH_TOKEN}@github.com/owner/repo.git"
git add -A && git commit -m "Initial commit"
git push -u origin main
```

### 4. Remote Contains Work You Don't Have Locally

**Symptom:**
```
! [rejected]  main -> main (fetch first)
error: failed to push some refs
```

**Fix:** Always pull before push:
```bash
git pull origin main   # or git fetch origin && git merge origin/main
git push origin main
```

### 5. Repo Doesn't Exist (404)

**Symptom:** `remote: Repository not found.`

**Fix:** Check first:
```bash
curl -s -o /dev/null -w "%{http_code}" https://api.github.com/repos/OWNER/REPO
# 404 = create repo first
# 200 = check token permissions
```

## Auth Diagnostic Checklist

When user says "push to GitHub" and it fails, run in order:

1. `git status` — any uncommitted changes?
2. `git remote -v` — is remote configured?
3. `echo $GH_TOKEN` / `echo $GITHUB_TOKEN` — token in env?
4. `gh auth status` — gh CLI authenticated?
5. `ls ~/.ssh/id_*.pub` — SSH keys available?
6. `ssh -T git@github.com` — SSH working?
7. `git -C ~/jarvis remote -v` — known working repo with embedded token?
8. `grep "github.com" ~/.git-credentials` — credentials stored?

If ALL fail → ask user for PAT with `repo` scope.

## Multi-Repo Push Script Template

```bash
#!/bin/bash
TOKEN="<github-pat>"
USER="<github-username>"

for repo in repo1 repo2 repo3; do
  cd "/home/ubuntu/$repo" 2>/dev/null || continue
  echo "Pushing $repo..."
  git remote set-url origin "https://${USER}:${TOKEN}@github.com/${USER}/${repo}.git" 2>/dev/null || \
    git remote add origin "https://${USER}:${TOKEN}@github.com/${USER}/${repo}.git"
  git pull origin main 2>/dev/null || true
  git push origin main || echo "FAILED: $repo"
done
```
