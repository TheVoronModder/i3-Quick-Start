# i3-Quick-Start Wizard (Klipper Jinja2 Safe)

This is a minimal, **Klipper-safe Jinja2** macro pack for fast bring‑up on Raspberry Pi + Klipper (Mainsail/Fluidd).  
No vendor‑specific commands — only standard Klipper/M-code and basic G-code.

## What you get
- `cfg/i3-wizard.cfg` – Core macros (PRINT_START, PRINT_END, PREHEAT, PURGE_LINE, PA_TUNE).
- `install.sh` – Copies the cfg into your Klipper config folder and adds an `[include …]` line.
- `uninstall.sh` – Removes the include and deletes the folder.

> Tested for Jinja2 syntax and general Klipper acceptability. Avoids optional modules (Bed Mesh, QGL, custom plugins) so it won’t error on printers that don’t have them configured.

---

## Requirements
- Raspberry Pi running Klipper (KIAUH or similar)
- Mainsail or Fluidd
- A safe home position near front‑left of the bed (adjust purge line if needed)

---

## STEP 1 — Select Your Bed Size (PAINFULLY OBVIOUS EDIT)
Open `cfg/i3-wizard.cfg` and find the **I3_SIZE** macro.  
**UNCOMMENT EXACTLY ONE** size block (250, 300, or 350), then **SAVE** and **RESTART** Klipper.

You'll see a big ✅ message in the console if it's set, or a ❌ error if you missed it.

---

## Install (SSH)
```bash
# 1) Upload this folder (or the zip) to your Pi, then SSH in
cd ~/i3-startup-wizard
chmod +x install.sh uninstall.sh

# 2) Run the installer
./install.sh
```

What the installer does:
1. Detects your Klipper config dir (`~/printer_data/config` or `~/klipper_config`).
2. Creates `i3-startup-wizard/` inside it.
3. Copies `cfg/i3-wizard.cfg` there.
4. Appends `[include i3-startup-wizard/i3-wizard.cfg]` to `printer.cfg` if not already present.
5. Restarts Klipper.

---

## Uninstall
```bash
./uninstall.sh
```

This removes the include line from `printer.cfg`, deletes the wizard folder, and restarts Klipper.

---

## How to Use


### Slicer Integration (auto purge keep-out)
Pass model bounds so the wizard can keep the purge **≥10% away** from your print area.

**Orca/SuperSlicer `PRINT_START` example:**

```
PRINT_START BED=[first_layer_bed_temperature] EXTRUDER=[first_layer_temperature]   MINX={first_layer_min_x} MINY={first_layer_min_y} MAXX={first_layer_max_x} MAXY={first_layer_max_y}
```

If bounds aren’t provided, it will fall back to a fixed front-left purge line.

### Quick Start
- Start a print:
  ```
  PRINT_START BED=60 EXTRUDER=200 PURGE=1
  ```
- End a print:
  ```
  PRINT_END
  ```
- Just preheat:
  ```
  PREHEAT BED=60 EXTRUDER=200 SOAK=90
  ```
- Draw a purge line at the front‑left:
  ```
  PURGE_LINE LENGTH=120 FLOW=12
  ```

### Pressure Advance Tuning Line
This will lay down a single straight line while stepping PA from `START` to `END` in `STEP` increments. Read the line quality and pick the smoothest section.
```
PA_TUNE START=0.00 END=0.12 STEP=0.01 LENGTH=160 SPEED=150 LAYER=0.20
```

> Tip: After testing, set your chosen PA permanently in `printer.cfg`:
> ```
> [extruder]
> pressure_advance: <your_value>
> ```

---

## File Overview
```
i3-startup-wizard/
├─ cfg/
│  └─ i3-wizard.cfg
├─ install.sh
├─ uninstall.sh
└─ README.md
```

---

## Notes & Safety
- Macros rely only on standard Klipper G/M‑codes; **no** optional modules are called.
- You can change purge positions and bed size at the top of `i3-wizard.cfg`.
- Always keep a finger near the power switch on first run and watch the axes carefully.

MIT License.
