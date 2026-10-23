# 4400 conditional guard/egress mechanical qualification worksheet

Use only when a guard lock and/or inside escape release is actually selected. This augments—not replaces—the cumulative Safety Design Package and selected safety-block qualification worksheet.

| Package IDs | Evidence to collect | Narrow claim allowed | Evidence class / status |
|---|---|---|---|
| `BND/HAZ/SF` | Modes, access geometry, whole-body entry, persons/tasks, stop/access-time proposition | What is exposed and when | |
| `PHY` | Door retained against relevant load; lock released; door physically opens; route is passable; machine physical safe state | Each proposition independently, not one “guard OK” bit | |
| `SRS/AUTH` | Independent owner of unlock permission, separate reset/start, power-loss behavior | Safety-control allocation, not LinuxCNC safety credit | |
| `ARC` | Exact switch/actuator/bracket/handle/accessory SKU; mounting orientation, fasteners, support/hinge, release route | Manufacturer data only for exact installation | |
| `DEP` | Common frame deformation, bracket loosening, contamination, cable bends, release obstruction, shared electrical supplies | Dependency and CCF exposure | |
| `HF` | Access to release inside; reachability outside; routine cleaning/service; spare actuator custody; ease of guard reinstallation | Defeat incentives and mitigations | |
| `VAL/PT` | Qualified-person physical escape/door-opening checks under safely controlled conditions; lock signal/OSSD/rearm test; physical stop/holding witness | Actual tested condition only | |
| `CHG/UNK/RR` | Bracket, actuator, cable, geometry, manual revision, stop/hold, pressure/load changes; stale proofs and restrictions | Unresolved facts remain blocking | |

**Mandatory contradiction cases:** lock signal healthy but door cannot open; safety output low but trapped person cannot exit; bracket replacement with old holding-force claim; spare actuator can spoof guard; inside release reachable from outside; cable routing changed after proof; ordinary start retained after guard restoration. Record each as a separate `VAL` case with its own physical witness and `NOT RUN/PASS/FAIL/BLOCKED/STALE` status.

**Service gate:** use documented isolation and restraint before manual inspection. Do not use live hazardous operation to test escape with a person inside. If minimum protection cannot be established, no people exposed; remote/isolated experimentation only with residual risks recorded.
