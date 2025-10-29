# i3 EZ Start Pack

## Overview

The **i3 EZ Start** pack provides a fully self-contained set of Klipper macros and configuration utilities for Prusa-style i3 printers and similar setups. It simplifies start, end, tuning, and maintenance operations, replacing older macros while maintaining slicer compatibility. This package is safe, modular, and easily installed or removed.

---

## 🧰 Included Macros

### Namespaced Macros (Safe)

These are unique and prefixed with `EZ_` to prevent conflicts:

* `EZ_PRINT_START`, `EZ_PRINT_END`
* `EZ_PAUSE`, `EZ_RESUME`, `EZ_CANCEL`
* `EZ_PARK`, `EZ_WIPE_NOZZLE`, `EZ_PURGE_LINE`
* `EZ_LOAD_FILAMENT`, `EZ_UNLOAD_FILAMENT`, `EZ_M600`
* `EZ_HEATSOAK`, `EZ_COOLDOWN`, `EZ_PREHEAT`
* `EZ_MESH`, `EZ_QGL`, `EZ_Z_TILT`
* `EZ_PA_TUNE`, `EZ_FLOW_TUNE`, `EZ_SHAPER_SCAN`
* `EZ_SAVE_CFG`, `EZ_UNINSTALL`

### Compatibility Aliases (Overrides Common Macros)

The following common macro names are redefined to route through the EZ system for drop-in compatibility:

* `PRINT_START` → `EZ_PRINT_START`
* `PRINT_END` → `EZ_PRINT_END`
* `PAUSE`, `RESUME`, `CANCEL_PRINT` → EZ equivalents
* `M600` → `EZ_M600`
* `PURGE_LINE`, `PRIME_LINE` → `EZ_PURGE_LINE`
* `G29` → `EZ_MESH`

---

## ⚠️ Macros to Eliminate or Comment Out

Before installing, search for and disable any existing macros with these names in your configuration files:

```
PRINT_START
PRINT_END
PAUSE
RESUME
CANCEL_PRINT
M600
LOAD_FILAMENT
UNLOAD_FILAMENT
PRIME_LINE
PURGE_LINE
PREHEAT
HEATSOAK
COOLDOWN
G29
```

Remove or comment out any duplicates outside `ez_start.cfg` to prevent conflicts.

---

## ✅ What It Does *Not* Override

This pack leaves your **hardware** configuration intact:

* `[extruder]`, `[heater_bed]`, `[bed_mesh]`, `[probe]`, `[beacon]`, `[cartographer]`, `[fan]`, `[input_shaper]`, etc.
* `[virtual_sdcard]`, `[pause_resume]`, `[save_variables]` (used if present; defaults are provided if missing).

---

## 📋 Recommended Include Order

Order matters! The EZ pack must load **after** your existing macro files so its aliases take effect.

```ini
[include hardware.cfg]
[include sensors.cfg]
[include macros_legacy.cfg]   # Old macros (commented duplicates)
[include ez_start.cfg]        # EZ pack last
```

---

## 🔍 Quick Collision Check (2-Minute Cleanup)

1. Open **Machine → Config** in Mainsail/Fluidd.
2. Use the file search tool to find and comment out macros listed above.
3. Keep hardware sections and uniquely named macros from other plugins (KAMP, Beacon, etc.).

---

## ⚙️ Required Support Sections

Ensure these exist in your config:

```ini
[pause_resume]

[virtual_sdcard]
path: ~/printer_data/gcodes

[save_variables]
filename: ~/printer_data/config/variables.cfg

[respond]
```

---

## 🧩 Slicer Configuration

* **Start G-code:** `PRINT_START`
* **End G-code:** `PRINT_END`
* **Filament change:** `M600`
* Remove all other purge/heat/mesh G-code in the slicer. EZ Start handles it.

---

## 🧠 Compatibility Notes

* **KAMP / Beacon / Cartographer:** fully compatible; EZ Start will call their commands internally if detected.
* Avoid generic-name duplicates like a second `PAUSE` macro from KAMP.
* Use original command names, or let EZ Start handle them.

---

## ❌ Uninstall / Revert

To remove the EZ Start system:

1. Run `EZ_UNINSTALL` in your console.
2. Comment out `[include ez_start.cfg]`.
3. Restart Klipper.

Your previous macros will regain control automatically.

---

## 💡 Advanced Tip

If you only want the `EZ_` namespace macros (no overrides), you can toggle alias support in `ez_start.cfg` by disabling the alias section.

```ini
# [EZ_ALIAS_SUPPORT] = True → enables overrides (default)
# [EZ_ALIAS_SUPPORT] = False → disables overrides
```

---

## 📦 Installation Summary

1. Download the latest **EZ Start Pack** from the releases section.
2. Drop `ez_start.cfg` into your printer’s config folder.
3. Add `[include ez_start.cfg]` at the end of your `printer.cfg`.
4. Restart Klipper and run `EZ_SETUP` to finalize.

---

## 🧹 Maintenance Commands

| Command          | Description                                                 |
| ---------------- | ----------------------------------------------------------- |
| `EZ_SETUP`       | Initializes and verifies configuration                      |
| `EZ_SAVE_CFG`    | Saves all runtime variables                                 |
| `EZ_UNINSTALL`   | Removes EZ pack and restores previous macros                |
| `EZ_MESH`        | Runs adaptive bed mesh (calls KAMP/Cartographer if present) |
| `EZ_PA_TUNE`     | Pressure advance tuning line                                |
| `EZ_FLOW_TUNE`   | Flow rate tuning line                                       |
| `EZ_SHAPER_SCAN` | Resonance scan wrapper                                      |

---

## 🧾 License

MIT License. You may freely modify and distribute this package with attribution.

---

## 👨‍🔧 Author

Developed by **Kyle Nyberg** as part of the Fathom Design Engineering project suite.

---

**Enjoy faster, cleaner, and safer Klipper printing with i3 EZ Start!**
