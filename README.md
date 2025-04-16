# Dotfiles

My personalized dotfiles for development and system administration, managed with Chezmoi.

## Features

- **Fish Shell**: Custom prompt, aliases, and functions
- **WezTerm**: Modern terminal emulator with session management
- **Git**: Advanced configuration with useful aliases
- **DevOps Tools**: Kubernetes, Docker, AWS, and more
- **Color Scheme**: Purple and green Joker-inspired theme

## Requirements

- [Chezmoi](https://www.chezmoi.io/) for dotfile management
- [Fish Shell](https://fishshell.com/) as the primary shell
- [Nerd Fonts](https://www.nerdfonts.com/) for icons and glyphs

## Installation

### Quick Install

```bash
# Run the chezmoi installer and initialize with your dotfiles
# You will be prompted for configuration values during installation
sh -c "$(curl -fsLS get.chezmoi.io)" -- init danieljnowak
```

Then apply your configuration:

```bash
~/.local/bin/chezmoi apply
```

### Manual Installation

1. Install Chezmoi:
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)"
   ```

2. Initialize dotfiles:
   ```bash
   chezmoi init danieljnowak
   ```

3. Preview changes:
   ```bash
   chezmoi diff
   ```

4. Apply configuration (you'll be prompted for values):
   ```bash
   chezmoi apply
   ```

## Core Tools

The configuration supports these essential tools:

- **Fish Shell**: Modern shell with great features
- **Starship**: Cross-shell prompt
- **WezTerm**: Terminal emulator
- **Zellij**: Terminal workspace manager
- **Bat**: Better cat with syntax highlighting
- **Eza**: Modern ls replacement
- **Git**: Version control with LazyGit UI
- **K9s**: Kubernetes TUI
- **Terraform, AWS CLI, Docker**: DevOps tools

## Customization

Most configuration is in the `~/.config` directory:

- `~/.config/fish/`: Fish shell configuration
- `~/.config/wezterm/`: Terminal emulator settings
- `~/.config/starship.toml`: Prompt configuration

## Managing Secrets

Secrets are stored in a separate `.chezmoidata.local.yaml` file that is **not tracked by git**. This prevents accidentally committing sensitive information to your repository.

When setting up on a new machine:

1. Run `chezmoi init danieljnowak` to download the dotfiles
2. Copy `.chezmoidata.example.yaml` to `.chezmoidata.local.yaml`
3. Edit `.chezmoidata.local.yaml` with your secrets
4. Run `chezmoi apply` to apply the configuration with your secrets

You can also use the included `run_after_clone.sh` script after cloning the repository, which will guide you through this process:

```bash
cd ~/.local/share/chezmoi  # Or wherever your source directory is
./run_after_clone.sh
```

Secrets are stored in `~/.env_secrets` which is set to mode 600 (read/write for owner only). To load these secrets in your shell:

```bash
source load-secrets
```

This will load environment variables like `GITHUB_TOKEN` and `OPENAI_API_KEY`.

## Update

To update your dotfiles:

```bash
chezmoi update
```

## Contributing

Feel free to fork and customize for your own use!

Core Terminal Tools
Fish Shell - Your primary shell
Starship - Cross-shell prompt
WezTerm - Terminal emulator
Zellij - Terminal workspace manager
Bat - Better cat with syntax highlighting
Eza - Modern ls replacement
Ripgrep - Fast grep alternative
Fd - Modern find replacement
Fzf - Fuzzy finder
Zoxide - Smarter cd command
Version Control
Git - Version control
LazyGit - Terminal UI for Git
Git-Delta - Better git diffs
GitHub CLI - GitHub from terminal
DevOps & Infrastructure
kubectl - Kubernetes CLI
k9s - Kubernetes TUI
Helm - Kubernetes package manager
Terraform - Infrastructure as code
AWS CLI - AWS management
Docker - Container runtime
Docker Compose - Container orchestration
Ansible - Configuration management
Monitoring & Debugging
htop - Interactive process viewer
Atuin - Shell history management
HTTPie - Modern curl alternative
jq - JSON processor
yq - YAML processor
netstat/ss - Network statistics
nmap - Network exploration
dig/nslookup - DNS lookup
Security & Credentials
Bitwarden CLI - Password management
openssl - SSL/TLS toolkit
ssh-audit - SSH server auditing
sshuttle - VPN over SSH
Data Processing
awk/sed - Text processing
tmux - Terminal multiplexer (alternative to Zellij)
tmuxinator - Tmux session manager
Neovim/Vim - Text editor
API & Web
curl - HTTP client
wget - Network downloader
socat - Multipurpose relay
Container Management
podman - Alternative to Docker
skopeo - Container image tool
dive - Explore Docker layers
Cloud Specific
gcloud - Google Cloud CLI
az - Azure CLI
doctl - DigitalOcean CLI
Monitoring & Observability
stern - Multi-pod Kubernetes logs
k6 - Load testing
ctop - Container metrics viewer