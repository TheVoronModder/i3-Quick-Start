\
#!/usr/bin/env bash
set -euo pipefail

# i3-wizard uninstaller — removes include, update_manager block, and repo dir (optional)

detect_config_dir() {
  if [[ -d "$HOME/printer_data/config" ]]; then
    echo "$HOME/printer_data/config"
  elif [[ -d "$HOME/klipper_config" ]]; then
    echo "$HOME/klipper_config"
  else
    echo "ERROR: Could not find Klipper config dir (expected ~/printer_data/config or ~/klipper_config)." >&2
    exit 1
  fi
}

CONFIG_DIR="$(detect_config_dir)"
TARGET_DIR="$CONFIG_DIR/i3-wizard"
PRINTER_CFG="$CONFIG_DIR/printer.cfg"

echo "Using CONFIG_DIR=$CONFIG_DIR"

# 1) Remove include line from printer.cfg
INCLUDE_LINE='[include i3-wizard/cfg/*.cfg]'
if grep -Fq "$INCLUDE_LINE" "$PRINTER_CFG"; then
  echo "Removing include from printer.cfg"
  cp "$PRINTER_CFG" "$PRINTER_CFG.bak.$(date +%Y%m%d-%H%M%S)"
  # Delete the include line and the comment header line above it if present
  awk 'BEGIN{removed=0} {if ($0 ~ /\[include i3-wizard\/cfg\/\*\.\cfg\]/) {removed=1; next} 
       if (removed==1 && $0 ~ /^# === i3-wizard/) {next} print $0}' "$PRINTER_CFG" > "$PRINTER_CFG.tmp"
  mv "$PRINTER_CFG.tmp" "$PRINTER_CFG"
else
  echo "Include not found in printer.cfg"
fi

# 2) Remove [update_manager i3_wizard] block if present
# Try common moonraker.conf locations
MOONRAKER_CONF=""
for cand in \
  "$CONFIG_DIR/../moonraker.conf" \
  "$HOME/printer_data/config/moonraker.conf" \
  "$HOME/klipper_config/../moonraker.conf"
do
  [[ -f "$cand" ]] && MOONRAKER_CONF="$cand" && break
done

if [[ -n "$MOONRAKER_CONF" ]] && grep -Fq "[update_manager i3_wizard]" "$MOONRAKER_CONF"; then
  echo "Removing update_manager block from moonraker.conf"
  sudo cp "$MOONRAKER_CONF" "$MOONRAKER_CONF.bak.$(date +%Y%m%d-%H%M%S)"
  sudo awk 'BEGIN{skip=0}
    /^\[update_manager i3_wizard\]/ {skip=1; next}
    /^\[update_manager / && skip==1 {skip=0} 
    {if (skip==0) print $0}' "$MOONRAKER_CONF" > /tmp/moonraker.conf.tmp
  sudo mv /tmp/moonraker.conf.tmp "$MOONRAKER_CONF"
else
  echo "No update_manager i3_wizard block found."
fi

# 3) Optionally remove the repo dir
if [[ -d "$TARGET_DIR" ]]; then
  read -r -p "Delete $TARGET_DIR directory as well? [y/N] " ans
  if [[ "${ans:-N}" =~ ^[Yy]$ ]]; then
    rm -rf "$TARGET_DIR"
    echo "Deleted $TARGET_DIR"
  else
    echo "Kept $TARGET_DIR"
  fi
fi

echo "Restarting Moonraker/Klipper/KlipperScreen (sudo may prompt)..."
if command -v sudo >/dev/null 2>&1; then
  sudo systemctl restart moonraker || true
  sudo systemctl restart klipper || true
  sudo systemctl restart KlipperScreen || sudo systemctl restart klipperscreen || true
else
  systemctl restart moonraker || true
  systemctl restart klipper || true
  systemctl restart KlipperScreen || systemctl restart klipperscreen || true
fi

echo "i3-wizard uninstall complete."
