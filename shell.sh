#!/bin/bash
set -e

BASE="/workspace/dev-setup"

echo "🧠 Configuring shell..."

# --- PATH safety (only once) ---
if ! grep -q "DEV_SETUP_PATH" ~/.bashrc; then
cat << 'EOF' >> ~/.bashrc

# DEV_SETUP_PATH
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
EOF
fi

# --- remove old block ---
sed -i '/# DEV_SETUP_START/,/# DEV_SETUP_END/d' ~/.bashrc || true

# --- main shell injection ---
cat << EOF >> ~/.bashrc

# DEV_SETUP_START

source $BASE/env.sh
source $BASE/aliases.sh

eval "\$(starship init bash)"
eval "\$(zoxide init bash)"

cd /workspace

# DEV_SETUP_END
EOF

# --- starship config ---
mkdir -p ~/.config

cp "$BASE/starship.toml" ~/.config/starship.toml

echo "✅ shell configured"