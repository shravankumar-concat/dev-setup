#!/bin/bash
set -e

echo "🚀 Bootstrapping dev environment..."

# -----------------------
# Install base tools (only if missing)
# -----------------------
if ! command -v eza &> /dev/null; then
  apt update && apt install -y eza curl git
fi

# -----------------------
# Install Starship
# -----------------------
if ! command -v starship &> /dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# -----------------------
# Install zoxide
# -----------------------
if ! command -v zoxide &> /dev/null; then
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# -----------------------
# Configure bash (idempotent)
# -----------------------
if ! grep -q "starship init bash" ~/.bashrc; then
cat << 'EOF' >> ~/.bashrc

# ---- DEV SETUP ----
eval "$(starship init bash)"
eval "$(zoxide init bash)"

alias ls='eza --icons'
alias ll='eza -lah --icons --git'
alias la='eza -A --icons'

alias gs='git status'
alias gp='git pull'
alias gc='git commit -m'
alias gl='git log --oneline --graph --decorate'

alias cls='clear'
EOF
fi

# -----------------------
# Starship config
# -----------------------
mkdir -p ~/.config

cat << 'EOF' > ~/.config/starship.toml
add_newline = false

[character]
success_symbol = "❯"
error_symbol = "❯"

[directory]
truncation_length = 3

[git_branch]
symbol = " "

[python]
symbol = "🐍 "
EOF

echo "✅ Environment ready"