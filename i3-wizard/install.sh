\
#!/usr/bin/env bash
set -euo pipefail

# i3-wizard installer (Danger Klipper BE v2 / silent build)
REPO_URL="${REPO_URL:-https://github.com/TheVoronModder/i3-wizard}"
BRANCH="${BRANCH:-main}"

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

echo "Using CONFIG_DIR=$CONFIG_DIR"
echo "Target install path: $TARGET_DIR"

# Clone or update into config/i3-wizard for simplicity
if [[ -d "$TARGET_DIR/.git" ]]; then
  echo "Repo already present; pulling latest..."
  git -C "$TARGET_DIR" fetch --all
  git -C "$TARGET_DIR" checkout "$BRANCH"
  git -C "$TARGET_DIR" pull --ff-only
else
  echo "Cloning $REPO_URL -> $TARGET_DIR"
  git clone --branch "$BRANCH" "$REPO_URL" "$TARGET_DIR"
fi

# Ensure include in printer.cfg
PRINTER_CFG="$CONFIG_DIR/printer.cfg"
INCLUDE_LINE='[include i3-wizard/cfg/*.cfg]'
if ! grep -Fq "$INCLUDE_LINE" "$PRINTER_CFG"; then
  echo "Adding include to printer.cfg"
  cp "$PRINTER_CFG" "$PRINTER_CFG.bak.$(date +%Y%m%d-%H%M%S)"
  {
    echo ""
    echo "# === i3-wizard (UI animations, KS prompts, wizard) ==="
    echo "$INCLUDE_LINE"
  } >> "$PRINTER_CFG"
else
  echo "Include already present in printer.cfg"
fi

# Inject Moonraker update_manager entry (optional but recommended)
# Try common moonraker.conf locations
MOONRAKER_CONF=""
for cand in \
  "$CONFIG_DIR/../moonraker.conf" \
  "$HOME/printer_data/config/moonraker.conf" \
  "$HOME/klipper_config/../moonraker.conf"
do
  [[ -f "$cand" ]] && MOONRAKER_CONF="$cand" && break
done

UPDATE_BLOCK_NAME="i3_wizard"
if [[ -n "$MOONRAKER_CONF" ]]; then
  if ! grep -Fq "[update_manager $UPDATE_BLOCK_NAME]" "$MOONRAKER_CONF"; then
    echo "Adding [update_manager $UPDATE_BLOCK_NAME] to moonraker.conf"
    sudo cp "$MOONRAKER_CONF" "$MOONRAKER_CONF.bak.$(date +%Y%m%d-%H%M%S)"
    sudo tee -a "$MOONRAKER_CONF" >/dev/null <<EOF

[update_manager $UPDATE_BLOCK_NAME]
type: git_repo
path: $TARGET_DIR
origin: $REPO_URL
primary_branch: $BRANCH
is_system_service: False
managed_services:
  klipper
  moonraker
  klipperscreen
EOF
  else
    echo "update_manager block already present."
  fi
else
  echo "WARNING: Could not auto-locate moonraker.conf. Skipping update_manager wiring."
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

echo "i3-wizard install complete. Open Mainsail/Fluidd → Machine → Updates to pull future changes."
