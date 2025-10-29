


# 🧩 i3-Quick-Start Wizard
### A one-click calibration and setup system for Klipper (Danger Klipper BE v2)

This project provides a fully automated setup wizard for i3-style Klipper printers.  
It integrates with **KlipperScreen**, shows **animated UI prompts**, and provides a step-by-step setup:  
**Level → Mesh → Pressure Advance (Auto or Manual) → Input Shaper → Save**

Built for **Danger Klipper Bleeding Edge v2**, Beacon Touch compatibility.

If you do not have Kalico Bleeding Edge v2 installed this is the Kalico website linking directly to the instructions:

https://docs.kalico.gg/Migrating_from_Klipper.html

Make sure you reflash your MCU to take full advantage of all the goodies otherwise the **i3-Quick-Start Wizard** will throw alot of errors. 

---

## ⚙️ Installation

SSH into your printer (Fluidd, Mainsail, or terminal) and run:

```bash
cd ~/printer_data/config
rm -rf i3-quick-start
git clone https://github.com/TheVoronModder/i3-quick-start.git i3-quick-start
cd i3-quick-start
chmod +x install.sh uninstall.sh
./install.sh


```

The installer:
- Detects your `printer_data/config` path automatically.
- Adds the `[include i3-wizard/cfg/*.cfg]` line **above** the `SAVE_CONFIG` block in your `printer.cfg`.
- Adds a Moonraker `[update_manager i3_wizard]` section (so you can update it from the web UI).
- Restarts Klipper, Moonraker, and KlipperScreen automatically.

---

## ❌ Uninstall

To cleanly remove it:
```bash
cd ~/printer_data/config/i3-quick-start
./uninstall.sh

```

The uninstaller:
- Removes the include line from `printer.cfg`
- Removes the `[update_manager i3_wizard]` block from `moonraker.conf`
- Optionally deletes the local folder  
- Restarts all services cleanly

---

## 🪄 How to Use

After installation and a restart, simply run:

```gcode
INITIAL_SETUP
```

That launches the interactive 5-step wizard:
1. **Gantry Leveling** (`Z_TILT_ADJUST` or `QGL`)
2. **Bed Mesh Calibration**
3. **Pressure Advance**
   - Choose **Auto PA Sweep** or **Manual PA Test**
4. **Input Shaper Calibration**
   - Runs Beacon Touch auto-calibration for X/Y
5. **Saves and finishes**

---

## 🧠 Optional Macros

### 🔹 Auto Pressure Advance
```gcode
STEP_PA_AUTO START=0.00 END=0.12 STEP=0.01 HOTEND=220 BED=60
```
Runs a PA sweep and prompts to apply the midpoint value.

### 🔹 Manual Pressure Advance
```gcode
STEP_PA
```
Pauses for you to print a PA test file manually.

### 🔹 Animated UI
```gcode
ANIM_START STYLE=bar TEXT="Calibrating..."
ANIM_STOP
```

### 🔹 KlipperScreen Notifications
```gcode
KS_NOTIFY TITLE="Info" MSG="Calibration Done" DUR=5
```

---

## 📁 File Structure

```
i3-quick-start/
├── install.sh        # Installer (safe include + Moonraker update_manager)
├── uninstall.sh      # Clean removal script
├── README.md         # Full documentation
└── cfg/
    ├── animations.cfg   # Animated M117 feedback
    ├── ui_macros.cfg    # KlipperScreen toasts & prompts
    ├── pa_auto.cfg      # Auto Pressure Advance sweep macros
    └── wizard.cfg       # INITIAL_SETUP wizard & calibration sequence
```

---

## 🧩 Compatibility
| Feature | Supported |
|----------|------------|
| **Firmware** | Danger Klipper BE v2 |
| **MCU** | Leviathan 1.2 / 1.3 |
| **Sensor** | Beacon Touch |
| **UI** | KlipperScreen |
| **Printer** | i3 / Voron / CoreXY variants |

---

## 🧱 Credits
Developed by **TheVoronModder** (learning python as I go)
Optimized for **Beacon Touch + DK BE v2** with support for **FDE Inertia Cube i3 Platform**

MIT License © 2025

---

### 🔗 Update via Mainsail/Fluidd
If your `moonraker.conf` includes the `[update_manager i3_wizard]` section, you can update directly:
> **Machine > Updates > i3_wizard > Update**

---

### 💡 Tip
You can fork and modify this wizard easily to fit any printer:
- Adjust bed mesh size, PA range, or animations in `/cfg/*.cfg`
- All macros are **fully Jinja2-safe and DK BE v2 compliant**
