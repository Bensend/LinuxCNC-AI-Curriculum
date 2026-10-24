# 4400-VAC-01 — Blank vacuum workpiece retention, stop and restart witness
**2026-10-24 | NOT RUN | qualified planning only; no live drop testing or exposed-person operation**

## Machine/task identity
- Machine / mode / workpiece / tooling / revision: UNKNOWN
- Suspended load or table-clamped workpiece? UNKNOWN
- Selected FMP/VOL/VAGG or other actual OEM/variant/firmware: UNKNOWN
- As-built pneumatic/vacuum/electrical drawing and approved SRS: MISSING
- Independent safety designer, qualified witness, owner authorization: UNASSIGNED
- Guard/whole-body access/drop zone and remote/isolated plan: UNKNOWN

## Physical propositions (independent rows)
| Record | Exact selected evidence required | State |
|---|---|---|
| `PHY-GRIP` | Actual workpiece-level retention, not reservoir tap only | NOT RUN |
| `PHY-DROP` | Protected drop/fall boundary and secondary restraint if required | NOT RUN |
| `PHY-CLAMP` | Tool/workpiece relative motion and clamping integrity | NOT RUN |
| `PHY-STOP` | Independent hazardous motion/tool stop | NOT RUN |
| `PHY-ENABLE` | Certified vs ordinary vendor machine-enable output identity | UNKNOWN |
| `PHY-LEAK` | Exact model/variant leak and reserve-vacuum criteria from OEM and SRS | NOT RUN |
| `PHY-ENERGY` | Task-safe isolation, setdown/support and residual vacuum/air | NOT RUN |
| `PHY-RESTART` | New deliberate start, no queued command after recovery | NOT RUN |

## Fault and common-cause review
Document vacuum generator power loss, compressed-air loss, cup leak, porous material, hose rupture, check valve, reservoir gauge location, workpiece movement, audible alarm reachability and tool energy. Do not use a product-specific vacuum number or leakage interval as a universal machine safe-exposure time. If any item contradicts expected physical behavior, HOLD, preserve raw evidence, mark affected `SRS/ARC/DEP/VAL/PT/CHG` STALE.

**Current status:** selected equipment and independent safe-to-operate threshold UNKNOWN. Do not perform exposed-person hazardous operation or intentional falling-load experiments.
