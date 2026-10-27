# 4400-M66-01 — Technician review: a completed input wait is not proof of safety

**Use after:** [pinned source audit](../research/4400_LINUXCNC_M66_WAIT_TIMEOUT_AND_NONSAFETY_INPUT_AUTHORITY_AUDIT_2026-10-27.md), [M62/M63 queued output review](../research/4400_AIR_CLEAN_01_LINUXCNC_PINNED_M62_M63_QUEUED_AIR_OUTPUT_SOURCE_TRACE_2026-10-27.md), and the [2520–25F0 safety package](SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md). **Status:** non-graduated documentary transfer; no new graded exercises, no bench or machine tests.

## What a technician must distinguish

| Indication or action | What it establishes in normal control | What it **does not** establish |
|---|---|---|
| `M66 P0 L3 Q5` returns with `#5399=1` | Ordinary motion input was HIGH at interpreter result read, and the wait did not report timeout. | A fresh edge, a valid safety sensor, an unbypassed guard, physical clamp retention, safe Y1/Y2 stop, or a safety-rated response time. |
| `M66 P0 L1 Q5` completes | Task observed LOW then HIGH through the normal status path. | Dual-channel discrepancy detection, OSSD integrity, independent safe-speed/position or proof against a stuck/wrong sensor. |
| `#5399=-1` | Wait timed out (or invalid result in the normal input-reader contract); program logic can inspect it. | Automatic machine emergency stop, physical energy isolation or hydraulic load retention. |
| G-code `(abort,...)` executes | Ordinary program execution is interrupted. | Contactors opened, pressure exhausted, ram mechanically held, or protective-device function validated. |
| PLC/HMI says 'ready' | Diagnostic/status assertion in the documented channel. | Independent physical safe state, unless a qualified design-specific witness proves it. |

**Design-review question, not a live test:** For an auxiliary process step that uses M66, locate the **actual** HAL input owner, verify the L mode and Q timeout, inspect the next program line for an explicit result check, and document what normal output cleanup happens on both timeout and operator abort. A stuck-HIGH `L3` input is a credible false-ready path; use independently verified sensing where the ordinary process requires it, but do not pretend it becomes a personnel-safety circuit.

**Example review pattern (illustrative, not deployable machine code):** wait for a process signal; check `#5399` **immediately**; on any unexpected result, inhibit further normal motion, report a specific fault, require an intentional new start after correction. The machine's independent safety system must remain effective even if the G-code is removed, stuck, delayed, or wrong.

**Human-factor acceptance:** normal faults should be understandable without cabinet access or bypassing a guard. Provide a clear wait/timeout indication, correct sensor labels, an operator-accessible recovery path, and a service procedure that uses actual energy isolation and physical restraint before maintenance. A guard or sensor repeatedly defeated to avoid nuisance waits indicates a design/workflow defect, not a valid exception.

**Open selected-machine proof:** installed AKAS/Pilz model/program, independently qualified safe-speed and muting path, safety final elements, actual Y1/Y2 stop and gravity hold, guard/maintenance access, deliberate reset/rearm. Reuse [restricted Stage A/OPB-D02](4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md); do not publish private PLC exports or serial numbers. **G0/G1 HOLD.**

**Provenance:** [LinuxCNC development M66 docs](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/docs/src/gcode/m-code.adoc#L467-L515), [Task wait state](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/task/emctaskmain.cc#L3048-L3100), [interpreter `#5399` read](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/rs274ngc/rs274ngc_pre.cc#L1519-L1532). No TEST-CONFIRMED claim or physical machine witness.


**Upstream example caution:** the LinuxCNC simulated VMC tool-change program checks `#5399 LT 0` (timeout) after several M66 waits. The pinned input reader samples **current** status after the wait, so a changed signal could produce a nonnegative but **unexpected** level. A normal process review should verify both timeout handling and the expected returned level, then address sensor stability and independent physical retention as separate requirements. This is a **source-derived hypothetical**, not an executed bug report or a safety-rated validation.
