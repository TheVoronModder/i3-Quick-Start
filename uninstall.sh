\
#!/usr/bin/env bash
# i3-quick-start :: uninstaller (supports nested 'i3-quick-start_pack' include)
set -euo pipefail
echo "== i3-quick-start :: uninstaller (nested-pack aware) =="

# locate printer.cfg
CANDS=("$HOME/printer_data/config/printer.cfg" "$HOME/klipper_config/printer.cfg")
PRN=""
for c in "${CANDS[@]}"; do [[ -f "$c" ]] && PRN="$c" && break; done
[[ -z "${PRN:-}" ]] && echo "printer.cfg not found" && exit 1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_NAME="$(basename "$SCRIPT_DIR")"

# remove either nested or flat include
INC_NESTED="\[include ${REPO_NAME}/i3-quick-start_pack/quickstart.cfg\]"
INC_FLAT="\[include ${REPO_NAME}/quickstart.cfg\]"

cp -a "$PRN" "${PRN}.bak.$(date +%Y%m%d-%H%M%S)"
sed -i -e "/^[[:space:]]*${INC_NESTED}[[:space:]]*$/d" "$PRN"
sed -i -e "/^[[:space:]]*${INC_FLAT}[[:space:]]*$/d"  "$PRN"

# remove KlipperScreen menu block (if present)
CONF="$HOME/.config/KlipperScreen.conf"
if [[ -f "$CONF" ]]; then
  awk '
    BEGIN{skipblk=0}
    /^\[menu __quickstart\]$/{skipblk=1}
    skipblk && /^\[/ && $0!~"^\\[menu __quickstart\\]$"{skipblk=0}
    !skipblk{print}
  ' "$CONF" > "$CONF.tmp" && mv "$CONF.tmp" "$CONF"
fi

sudo systemctl restart klipper || sudo service klipper restart || true
sudo systemctl restart KlipperScreen 2>/dev/null || true
echo "Uninstall complete."
