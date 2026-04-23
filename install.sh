#!/bin/bash
set -e

echo "📦 Installing tools..."

apt update

apt install -y git curl || true
apt install -y eza || true

# starship
if ! command -v starship &> /dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# zoxide
if ! command -v zoxide &> /dev/null; then
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

echo "✅ install complete"