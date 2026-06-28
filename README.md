# gtp — Git Persona Manager

Switch between multiple GitHub accounts on the same machine — no more wrong-user commits or manual token juggling.

## The Problem

When you have multiple GitHub accounts (personal, work, client), you constantly deal with:
- Commits going out under the wrong name/email
- Manually inserting tokens into clone URLs
- `osxkeychain` caching the wrong credentials for push/pull

`gtp` fixes all of this with a single active profile that gets injected automatically into every git operation.

## Install

### Homebrew (recommended)

```bash
brew install sarangkkl/gtp/gtp
```

> If prompted about an untrusted tap, run `brew trust sarangkkl/gtp` then retry.

### Manual

```bash
curl -o /usr/local/bin/gtp https://raw.githubusercontent.com/sarangkkl/gtp/main/gtp
chmod +x /usr/local/bin/gtp
```

Or clone and install:

```bash
git clone https://github.com/sarangkkl/gtp.git
cd gtp
sudo ./install.sh
```

## Quick Start

```bash
# Add your first account (auto-activated)
gtp setup_new_account

# Add a second account
gtp setup_new_account

# Switch between them
gtp use work
gtp use personal
```

## Commands

### Profile Management

```bash
gtp setup_new_account       # Interactive wizard: alias, username, name, email, token
gtp use <profile>           # Switch active profile
gtp status                  # Show active profile + all saved profiles
gtp list                    # Table of all profiles
gtp edit <profile>          # Update a profile (press Enter to keep existing value)
gtp remove <profile>        # Delete a profile
```

### Git Commands

```bash
gtp git clone <url>         # Clone with token auto-injected + local identity set
gtp git commit -m "msg"     # Commit under the active profile's name/email
gtp git push                # Push using the active profile's token
gtp git pull                # Pull using the active profile's token
gtp git fetch               # Fetch using the active profile's token
gtp git <anything>          # All other git commands pass through unchanged
```

## How It Works

`gtp` stores profiles in `~/.gitpersona/profiles/<alias>/` — one plain text file per field, no dependencies required.

```
~/.gitpersona/
├── active              ← name of the currently active profile
└── profiles/
    ├── work/
    │   ├── username    ← GitHub username
    │   ├── name        ← display name for commits
    │   ├── email       ← email for commits
    │   └── token       ← personal access token (chmod 600)
    └── personal/
        └── ...
```

### Clone

HTTPS URLs get the token injected before being passed to git:

```
https://github.com/user/repo.git
         ↓
https://TOKEN@github.com/user/repo.git
```

After a successful clone, `user.name` and `user.email` are written into the repo's local `.git/config` automatically.

SSH URLs are passed through unchanged (configure SSH keys separately per account).

### Commit

Identity is injected via environment variables which override any global `~/.gitconfig`:

```bash
GIT_AUTHOR_NAME="Your Name" GIT_AUTHOR_EMAIL="you@email.com" git commit ...
```

### Push / Pull / Fetch

An inline credential helper supplies the token, bypassing `osxkeychain` and any cached credentials:

```bash
git -c credential.helper= \
    -c "credential.helper=!f(){ echo username=...; echo password=TOKEN; }; f" \
    push
```

## Example Session

```bash
$ gtp setup_new_account
=== New GitHub Profile Setup ===
Profile alias: work
GitHub username: gaurav-corp
Display name: Gaurav (Work)
Email: gaurav@company.com
GitHub personal access token: ************
✓ Profile 'work' saved and set as active.

$ gtp setup_new_account
Profile alias: personal
GitHub username: sarangkkl
Display name: Gaurav
Email: gaurav@personal.com
GitHub personal access token: ************
✓ Profile 'personal' saved.

$ gtp status
=== Active Profile ===
  Alias:     work
  Username:  gaurav-corp
  Name:      Gaurav (Work)
  Email:     gaurav@company.com
  Token:     ****abcd

=== All Profiles ===
  ALIAS          USERNAME               EMAIL
  ──────────────────────────────────────────────────────────────────────
  * work         gaurav-corp            gaurav@company.com
    personal     sarangkkl              gaurav@personal.com

$ gtp git clone https://github.com/org/private-repo.git
Cloning into 'private-repo'...
✓ Set user.name='Gaurav (Work)' and user.email='gaurav@company.com' in 'private-repo'.

$ gtp use personal
✓ Switched to profile 'personal' (sarangkkl / gaurav@personal.com).

$ gtp git clone https://github.com/sarangkkl/my-project.git
Cloning into 'my-project'...
✓ Set user.name='Gaurav' and user.email='gaurav@personal.com' in 'my-project'.
```

## Token Permissions

When creating a GitHub Personal Access Token, the minimum required scopes are:

| Operation | Scope needed |
|---|---|
| Clone private repos | `repo` |
| Push / pull | `repo` |
| Public repos only | `public_repo` |

Generate one at: **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)**

## Security

- Token files are stored with `chmod 600` (readable only by you)
- Tokens are masked in all terminal output (`****xxxx`)
- No tokens are ever written to shell history (input is hidden with `read -s`)
- Credentials are never stored in global git config

## Requirements

- bash 4+ or zsh
- git
- macOS, Linux, or WSL

No external dependencies. Pure shell script.

## License

MIT © [sarangkkl](https://github.com/sarangkkl)
