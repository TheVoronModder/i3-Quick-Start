# i3-Quick-Start Wizard (Klipper Jinja2 Safe)

This is a minimal, **Klipper-safe Jinja2** macro pack for fast bring-up on Raspberry Pi + Klipper (Mainsail/Fluidd).  
No vendor-specific commands — only standard Klipper/M-code and basic G-code.

## What you get
- `cfg/i3-wizard.cfg` – Core macros (bed-size selector, PRINT_START/END, PREHEAT, PURGE_LINE, PURGE_LINE_AUTO, PA_TUNE, IS_* helpers).
- `install.sh` – Copies the cfg into your Klipper config folder and adds an `[include …]` line.
- `uninstall.sh` – Removes the include and deletes the folder.

> Tested for Jinja2 syntax and general Klipper acceptability. Avoids optional modules (Bed Mesh, QGL, custom plugins) so it won’t error on printers that don’t have them configured.

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

## Using Shake&Tune (graphs & images)

This wizard ships with **helpers** that play nice with the Shake&Tune add‑on. They don’t replace it — they just run the right Klipper commands and remind you where to look for data.

1) Record resonance data:
```
# Run both axes (creates CSVs that Shake&Tune can plot)
ST_SWEEP_BOTH

# Or run a single axis
IS_TEST_RESONANCE AXIS=X
IS_TEST_RESONANCE AXIS=Y
```

2) Visualize:
- Open the **Shake&Tune** panel in Mainsail/Fluidd.
- Pick the latest resonance files (typically in `/tmp/resonances_*.csv`).
- Generate your graphs/images, then save them from the UI.

3) (Optional) Calibrate and then visualize:
```
IS_RUN_BOTH SAVE=1     # Calibrates with SHAPER_CALIBRATE
ST_AFTER_CAL           # Prints a reminder to open Shake&Tune
```

> Notes
> - If you see an error about `[resonance_tester]`, wire your accelerometer and add the required sections first.
> - File locations can vary by distro; Shake&Tune can browse to the right place for you.

---

## Input Shaper Quickstart

These helpers are **safe**: they only run if you’ve already configured an accelerometer and the required sections in `printer.cfg`.

### Check current values
```
IS_STATUS
```

### Auto-calibrate (ADXL required)
```
# Tune X then Y (won't save unless you add SAVE=1)
IS_RUN_BOTH
# Or one axis
IS_TUNE_AXIS AXIS=X
IS_TUNE_AXIS AXIS=Y
# Save tuned values to printer.cfg
IS_RUN_BOTH SAVE=1
```

### Raw resonance sweep (optional)
```
IS_TEST_RESONANCE AXIS=X
IS_TEST_RESONANCE AXIS=Y
```

---

## Slicer Integration (auto purge keep-out)
Pass model bounds so the wizard can keep the purge **≥10% away** from your print area.

**Orca/SuperSlicer `PRINT_START` example:**

```
PRINT_START BED=[first_layer_bed_temperature] EXTRUDER=[first_layer_temperature]   MINX={first_layer_min_x} MINY={first_layer_min_y} MAXX={first_layer_max_x} MAXY={first_layer_max_y}
```

If bounds aren’t provided, it will fall back to a fixed front-left purge line.

---

## How to Use

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
- Draw a purge line at the front-left:
  ```
  PURGE_LINE LENGTH=120 FLOW=12
  ```

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
- Macros rely only on standard Klipper G/M-codes; **no** optional modules are called.
- You can change purge positions and bed size at the top of `i3-wizard.cfg`.
- Always keep a finger near the power switch on first run and watch the axes carefully.

MIT License.
