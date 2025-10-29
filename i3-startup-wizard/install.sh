#!/usr/bin/env bash
set -euo pipefail

echo "==> i3-startup-wizard installer"

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
mkdir -p "$DEST"

echo "-> Copying cfg to $DEST"
cp -f ./cfg/i3-wizard.cfg "$DEST/"

INCLUDE_LINE="[include i3-startup-wizard/i3-wizard.cfg]"
PRINTER_CFG="$CONFIG_DIR/printer.cfg"

if ! grep -qxF "$INCLUDE_LINE" "$PRINTER_CFG"; then
  echo "-> Adding include to printer.cfg"
  echo "" >> "$PRINTER_CFG"
  echo "$INCLUDE_LINE" >> "$PRINTER_CFG"
else
  echo "-> Include already present"
fi

echo "-> Restarting Klipper"
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl restart klipper || true
else
  sudo service klipper restart || true
fi

echo "==> Install complete. Verify in Mainsail/Fluidd console: 'RESTART' if needed."
