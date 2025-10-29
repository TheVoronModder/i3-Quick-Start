#!/usr/bin/env bash
set -euo pipefail

echo "==> i3-startup-wizard uninstaller"

# Detect Klipper config dir
CONFIG_DIR=""
if [ -d "$HOME/printer_data/config" ]; then
  CONFIG_DIR="$HOME/printer_data/config"
elif [ -d "$HOME/klipper_config" ]; then
  CONFIG_DIR="$HOME/klipper_config"
else
  echo "Could not find Klipper config directory. Looked for ~/printer_data/config and ~/klipper_config"
  exit 1
fi

DEST="$CONFIG_DIR/i3-startup-wizard"
PRINTER_CFG="$CONFIG_DIR/printer.cfg"
INCLUDE_LINE="[include i3-startup-wizard/i3-wizard.cfg]"

if [ -f "$PRINTER_CFG" ]; then
  echo "-> Removing include from printer.cfg (if present)"
  sed -i "\~$INCLUDE_LINE~d" "$PRINTER_CFG" || true
fi

if [ -d "$DEST" ]; then
  echo "-> Deleting $DEST"
  rm -rf "$DEST"
fi

echo "-> Restarting Klipper"
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl restart klipper || true
else
  sudo service klipper restart || true
fi

echo "==> Uninstall complete."
