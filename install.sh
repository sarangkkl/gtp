#!/usr/bin/env bash
# install.sh — install gtp to /usr/local/bin

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GTP_SRC="${SCRIPT_DIR}/gtp"
INSTALL_DIR="/usr/local/bin"
INSTALL_PATH="${INSTALL_DIR}/gtp"

if [[ ! -f "$GTP_SRC" ]]; then
  echo "Error: gtp script not found at ${GTP_SRC}" >&2
  exit 1
fi

# Check if we need sudo
if [[ -w "$INSTALL_DIR" ]]; then
  cp "$GTP_SRC" "$INSTALL_PATH"
  chmod +x "$INSTALL_PATH"
else
  echo "Installing to ${INSTALL_PATH} (requires sudo)..."
  sudo cp "$GTP_SRC" "$INSTALL_PATH"
  sudo chmod +x "$INSTALL_PATH"
fi

echo "✓ gtp installed to ${INSTALL_PATH}"
echo ""
echo "Get started:"
echo "  gtp setup_new_account"
echo "  gtp help"
