
# i3-wizard (KlipperScreen Wizard — DK BE v2, Silent)

Animated KlipperScreen prompts and a one-click calibration wizard for i3-style printers, designed for **Danger Klipper Bleeding Edge v2**. 
This build is **silent** (no buzzer required) and Beacon Touch–ready for Input Shaper.

## Install (one-liner on your printer)
```bash
cd ~/printer_data/config
rm -rf i3-wizard
git clone https://github.com/TheVoronModder/i3-wizard.git
cd i3-wizard
chmod +x install.sh uninstall.sh
./install.sh

```

> Override if you fork:
> `REPO_URL=https://github.com/<you>/i3-wizard BRANCH=main bash -c "$(curl -fsSL https://raw.githubusercontent.com/<you>/i3-wizard/main/install.sh)"`

## Uninstall
```bash
bash ~/printer_data/config/i3-wizard/uninstall.sh
```

## What you get
- **INITIAL_SETUP** wizard: Level → Mesh → (Manual) PA → Input Shaper → Save
- **Clean Jinja2** Klipper macros compatible with **DK BE v2**
- **KlipperScreen** toasts, modal prompts, animated status (spinner/dots/bar)

## Optional
- If you have dual Z or CoreXY, the wizard auto-detects and runs `Z_TILT_ADJUST` or `QUAD_GANTRY_LEVEL`. 
- Input Shaper uses standard `SHAPER_CALIBRATE AXIS=X/Y`. If you’ve configured Beacon Touch as your shaper source, it will be used automatically.

## Files
```
cfg/
  animations.cfg   # animated M117 status
  ui_macros.cfg    # toasts + OK/Cancel prompts
  wizard.cfg       # step chain + INITIAL_SETUP
install.sh         # installer + update_manager wiring
uninstall.sh       # clean removal
```
