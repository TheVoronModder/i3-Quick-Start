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
