# 4400 — Schmalz vacuum gripping: loss-of-suction drop, reserve vacuum and clamp-enable authority
**2026-10-24 | three original manufacturer PDFs directly inspected | documentary, no selected-machine validation**

## Why this branch matters
A safety stop that cuts compressed air or vacuum-pump power can itself create a falling-object hazard. Conversely, keeping vacuum available to hold a load can leave residual energy and create unexpected release during service. This is a machine-class transfer problem for robots, gantries, vacuum lifters and CNC vacuum workholding—not a claim about OpenPressBrake.

## Direct original OEM evidence, edition scoped
**A — FMP(-S) area gripper:** Schmalz *Operating Instructions FMP(-S)-SVK / FMP(-S)-SW*, **30.30.01.01017, status 11.2019, index 6**, original 32-page bilingual manual, PDF p. 5 (index 4), §§1.3–1.4:
https://media.schmalz.com/MAM_Library/Dokumente/Bedienungsanleitung/30/3030/303001/30300101017/4e0640d71edd_BAL_30.30.01.01017_en-EN.pdf
**DOC-CONFIRMED:** designed for automated operation in secured areas without people; warns that the load can drop when vacuum generation fails, including generator power loss or compressed-air drop; warns specifically about compressed-air loss during E-stop. Exact model pressure/valve details are product-specific. **Do not** infer a universal E-stop 'dump air' rule.

**B — VOL vacuum reservoir:** Schmalz *Operating Instructions Vacuum Reservoir VOL*, **30.30.01.02412, issue 01, 12/22**, original nine-page manual, PDF pp. 4–8:
https://media.schmalz.com/MAM_Library/Dokumente/Bedienungsanleitung/30/3030/303001/30300102412/8948f3f235b2_BAL_30.30.01.02412_en-EN.pdf
**DOC-CONFIRMED:** the manufacturer identifies reservoir, gauge, filter and non-return valve, marks selected items as having safety functions, and explicitly says the area below a gripper/load remains a danger zone. Its §6.6 defines a **specific** leak-retention check and §7 warns of load-fall risk at inadequate vacuum. The gauge/red band and leakage criterion are **not** machine-level certified holding time, independent person protection, or universal design values.

**C — VAGG vacuum clamping unit:** Schmalz *Operating instructions Vacuum Unit VAGG 10/21/40/63*, **30.30.01.03769, issue 02, 07/24**, original 34-page manual, PDF pp. 17, 22–23:
https://media.schmalz.com/MAM_Library/Dokumente/Bedienungsanleitung/30/3030/303001/30300103769/013b6e66f18c_BAL_30.30.01.03769_en-EN.pdf
**DOC-CONFIRMED:** integrated vacuum sensor and audible warning; on inadequate vacuum, its output for machine enabling is interrupted. It recommends measurement close to the workpiece, and warns the workpiece may move or release after power loss, line break, low compressed air or malfunction. The manual requires qualified maintenance and rechecking after faults. **The PDF excerpt does not establish a safety-rated PL/SIL for the enable output**, so classify personnel-safety credit UNKNOWN rather than assuming an ordinary output is a safety function.

## Three different physical hazard propositions
| Use case | Hazard | Necessary independent proposition | False shortcut |
|---|---|---|---|
| Robot/gantry suspended load | Falling workpiece after vacuum or compressed-air loss | No person exposed to drop zone; defined load retention/catch or controlled setdown under selected faults | E-stop cuts power, therefore people are safe |
| Reservoir-backed lift | Reserve vacuum decays, non-return valve leaks, cups lose seal | Selected load retention duration, leak path, physical load witness and exclusion | Gauge still green, therefore infinite hold |
| CNC vacuum workholding | Workpiece slips, ejects or shifts while tool/spindle remains energized | Clamping integrity and coordinated machine hazard response at the **workpiece** | Vacuum unit's machine-enable output is certified personnel safety |

## Cross-failure and human-factors analysis
1. **Power cut drops suspended load.** Emergency stopping of motion and continued grip may be competing requirements; safety design must explicitly resolve their ordering, independent final elements and physical proof.
2. **Reservoir non-return valve holds vacuum temporarily.** It is not a universal guarantee under porous workpiece, cup seal leak, punctured hose or heavy load. Product leak check is not a whole-machine proof.
3. **Vacuum gauge at reservoir differs from cup/workpiece.** A valve, restriction or disconnected hose can make reservoir vacuum plausible while the gripping surface loses suction.
4. **Enable output opens on low vacuum.** This may stop a normal machine cycle but does not itself prove a safe stop or that a falling load is caught; classify interface safety integrity UNKNOWN without exact OEM/installation evidence.
5. **E-stop causes compressed-air drop.** For FMP-S this can trigger the very release hazard described by its OEM; never assume all pneumatic dump strategies are safe for every gripper.
6. **Defeat incentive.** Frequent nuisance vacuum alarms, blocked filters, awkward cup replacement and poor gauge visibility invite bypass. Provide simple, reachable maintenance, obvious status and protected work zone; do not solve with 'ignore low vacuum' buttons.

## Selected-machine evidence and claim labels
**DOC-CONFIRMED:** three exact Schmalz manuals and sections above. **INFERENCE:** cross-machine fault and authority decomposition. **UNKNOWN:** selected gripper/reservoir/clamp presence, workpiece retention, measured leak rate, independent safety architecture, protective stopping, PL/SIL, restart, physical holding and hazard-zone occupancy. **TEST-CONFIRMED:** none. **SOURCE-CONFIRMED LinuxCNC:** none newly. The VAGG output is not credited as safety-rated by implication. No physical drop test or human-exposed operation authorized.

## Engineering transfer
For an automated plasma gantry with a vacuum sheet handler, keep torch energy, gantry stop and suspended sheet retention separate. For a CNC router, loss of vacuum clamping can create projectile hazard despite the workpiece not being suspended. For a robot, a gripper's reserve vacuum and a mechanical secondary catch address different failure modes. Actual safeguards depend on the selected SRS and hardware, not this paper example.
