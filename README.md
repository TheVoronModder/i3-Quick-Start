# 🧩 i3-Quick-Start Wizard
### A one-click calibration and setup system for Klipper (Danger Klipper BE v2)

This project provides a fully automated setup wizard for i3-style Klipper printers.  
It integrates with **KlipperScreen**, shows **animated UI prompts**, and provides a step-by-step setup:  
**Level → Mesh → Pressure Advance (Auto or Manual) → Input Shaper → Save**

Built for **Danger Klipper Bleeding Edge v2**, Beacon Touch compatibility, and **silent systems (no buzzer required)**.

---

## ⚙️ Installation

SSH into your printer (Fluidd, Mainsail, or terminal) and run:

```bash
cd ~/printer_data/config
git clone https://github.com/TheVoronModder/i3-Quick-Start.git i3-quick-start
cd i3-quick-start
chmod +x install.sh uninstall.sh
./install.sh
```
## ❌ Uninstallation

```bash ~/printer_data/config/i3-quick-start/uninstall.sh```

🪄 How to Use

After installation and a restart, simply run:

```INITIAL_SETUP```


That launches the interactive 5-step wizard:

**Level → Mesh → Pressure Advance (Auto or Manual) → Input Shaper → Save**

Saves and finishes

🧠 Optional Macros
🔹 Auto Pressure Advance
STEP_PA_AUTO START=0.00 END=0.12 STEP=0.01 HOTEND=220 BED=60


Runs a PA sweep and prompts to apply the midpoint value.

🔹 Manual Pressure Advance
STEP_PA


Pauses for you to print a PA test file manually.

🔹 Animated UI
ANIM_START STYLE=bar TEXT="Calibrating..."
ANIM_STOP

🔹 KlipperScreen Notifications
KS_NOTIFY TITLE="Info" MSG="Calibration Done" DUR=5


