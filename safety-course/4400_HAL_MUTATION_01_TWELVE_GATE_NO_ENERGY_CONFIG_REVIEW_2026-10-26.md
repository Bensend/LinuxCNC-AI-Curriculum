# HAL-MUTATION-01 — 12-gate selected-machine no-energy documentary review

**Status: NOT RUN / blank worksheet.** This is a **read-only, deenergized documentary** review, not a checklist granting motion or service access. No private drawings/configuration may be copied into the public curriculum. Record evidence ID, exact revision, independent witness, reviewer and disposition for each gate. UNKNOWN is not PASS.

| Gate | Evidence to request and inspect | Current result |
|---|---|---|
| 1 Hazard boundary | Crush, gravity, stored fluid, spindle/arc, entry/escape and maintenance exposure | UNKNOWN |
| 2 As-built identity | Selected controller, firmware, LinuxCNC revision, I/O and physical safety hardware | UNKNOWN |
| 3 HAL topology | Read-only pin/net graph, writer/reader identity and actual expected signal sources | UNKNOWN |
| 4 Config change control | Hash/version, edit privileges, service restoration procedure and independent comparison | UNKNOWN |
| 5 Stale/disconnect policy | What ordinary-control component does when a writer disappears or pin is unlinked | UNKNOWN |
| 6 Independent protective input | Guard/E-stop/presence input and safety integrity evidence separate from HAL/FPGA | UNKNOWN |
| 7 Safety logic | Qualified reset/restart/diagnostic state allocation and fault response | UNKNOWN |
| 8 Final elements | Independent stop/energy-removal chain, feedback and common-cause review | UNKNOWN |
| 9 Load-side witness | Actual Y1/Y2 stop and gravity hold; pressure-zone isolation and trapped energy | UNKNOWN |
| 10 Human factors | Captive guards, easy service isolation, legible faults, bypass incentives and rescue access | UNKNOWN |
| 11 Fresh restart | Reset, rearm, mode selection and **new** motion authorization separated | UNKNOWN |
| 12 Independent validation | Qualified verifier, fault-path plan, measured/design-specific parameters and acceptance record | UNKNOWN |

**Decision rule:** A HAL net being linked, a `sets` value, a green UI, a locked HAL configuration or an E-stop software bit is **not** a physical safety witness. The G0/G1 physical gate remains **HOLD**. G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No energized experiments, no personnel-exposed operation, no invented PL/SIL, stop times, hydraulic valve truth tables or pressure thresholds.

**Human-factors acceptance:** Demonstrate that technicians can diagnose a missing writer, restore a guard, identify all isolators and recover with distinct reset/start **without** an incentive to bypass the safeguard. Record actual observation; this worksheet is unexecuted.
