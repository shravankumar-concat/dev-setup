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
if [ ! -f "$HOME/.local/bin/zoxide" ]; then
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# -----------------------
# Ensure PATH everywhere (CRITICAL: must be first in bashrc)
# -----------------------
for file in ~/.bashrc ~/.profile; do
  if ! grep -q 'DEV_SETUP_PATH_FIX' "$file" 2>/dev/null; then
    cat << 'EOF' >> "$file"

# DEV_SETUP_PATH_FIX (do not remove)
export PATH="$HOME/.local/bin:$PATH"
EOF
  fi
done

# -----------------------
# Clean previous DEV SETUP block (avoid duplicates)
# -----------------------
sed -i '/# DEV_SETUP_START/,/# DEV_SETUP_END/d' ~/.bashrc || true

# -----------------------
# Add clean DEV SETUP block (ORDER MATTERS)
# -----------------------
cat << 'EOF' >> ~/.bashrc

# DEV_SETUP_START

# PATH (must be before tool init)
export PATH="$HOME/.local/bin:$PATH"

# Init tools
eval "$(starship init bash)"
eval "$(zoxide init bash)"

# Aliases
alias ls='eza --icons'
alias ll='eza -lah --icons --git'
alias la='eza -A --icons'

alias gs='git status'
alias gp='git pull'
alias gc='git commit -m'
alias gl='git log --oneline --graph --decorate'

alias cls='clear'

# Default workspace
cd /workspace

# DEV_SETUP_END
EOF

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
echo "👉 Open a new terminal OR run: source ~/.bashrc"