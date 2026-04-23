#!/bin/bash
set -e

echo "🚀 [dev-setup] Bootstrapping environment..."

BASE="/workspace/dev-setup"

#bash "$BASE/install.sh"
bash "$BASE/shell.sh"

echo "✅ [dev-setup] Ready. Restart shell or run: source ~/.bashrc"