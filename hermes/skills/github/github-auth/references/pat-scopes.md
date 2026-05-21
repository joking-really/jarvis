# GitHub PAT Scope Reference

Quick reference for which GitHub Personal Access Token (PAT) scopes are needed for common operations.

## Classic PAT Scopes

| Scope | What it enables |
|-------|----------------|
| `repo` | Full control of private repositories (read, write, push, PRs, issues, releases) |
| `public_repo` | Full control of public repositories only |
| `workflow` | Update GitHub Actions workflow files |
| `read:org` | Read organization membership |
| `write:org` | Write organization data |
| `admin:repo_hook` | Full control of repository hooks |
| `delete_repo` | Delete repositories |
| `gist` | Create and manage gists |

**Minimum for most repo work:** `repo` + `workflow`

## Fine-Grained PAT Scopes

Fine-Grained PATs use repository/organization permissions instead of OAuth scopes.

| Operation | Required Permission |
|-----------|-------------------|
| Clone, pull, push | Contents (read/write) |
| Create PRs, issues | Pull requests (read/write), Issues (read/write) |
| **Create/delete repositories** | **Administration (read/write)** |
| Manage secrets | Secrets (read/write) |
| Manage Actions | Actions (read/write) |
| View repo settings | Metadata (read) |

**Important:** Fine-Grained PATs are **repository-scoped** by default. To create a new repo (which is not scoped to an existing repo), you must:
1. Grant "Administration" read/write permission
2. Set the token's "Repository access" to "All repositories" (or the specific org where you want to create repos)

## Common Errors

### `GraphQL: Resource not accessible by personal access token`

This means the token is valid and authenticated, but lacks the specific permission for the operation.

**For repo creation with `gh repo create`:**
- Classic PAT: needs `repo` or `public_repo` scope
- Fine-Grained PAT: needs "Administration" read/write + access to the target owner (user or org)

**For org-level operations:**
- Classic PAT: needs `read:org` or `write:org`
- Fine-Grained PAT: needs the specific org permission + org-level access selected

### `401 Bad credentials`

Token is invalid, expired, or was revoked. Generate a new one.

### `403 Resource not accessible by integration`

The token works but the app/integration doesn't have permission for this resource. Usually means the Fine-Grained PAT doesn't include the target repository in its access list.

## Token Type Decision Tree

```
Need to create/delete repos?
├── Yes → Classic PAT with `repo` scope (simplest)
│   OR Fine-Grained PAT with Administration read/write + "All repositories"
│
└── No, just work with existing repos
    ├── One or a few specific repos → Fine-Grained PAT (most secure)
    └── Many repos across orgs → Classic PAT with `repo` scope
```

## Creating Tokens

- **Classic PATs:** https://github.com/settings/tokens
- **Fine-Grained PATs:** https://github.com/settings/personal-access-tokens

For Fine-Grained PATs, always verify:
1. The **resource owner** (your account or an org)
2. The **repository access** (All repositories, or select specific ones)
3. The **permissions** granted (especially Administration for repo creation)
