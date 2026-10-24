# 4400 technician card — Hose-burst fuse is not universal load holding

**Paper-only exercise; 2026-10-24.** This is a **fictional** machine and does not establish OpenPressBrake hardware, authorize line opening, prescribe a pressure/flow threshold or permit personnel-exposed operation. Read the [original manufacturer-source audit](../research/4400_HOSE_BURST_VELOCITY_FUSE_FLOW_WINDOW_AND_UNSAFE_TEST_TRANSFER_AUDIT_2026-10-24.md) first.

## The counterexample that must survive a handoff

A technician sees a small cartridge valve near a raised hydraulic cylinder, an HMI green `SAFE` indication, and a diagram labeled “hose burst protection.” A hose develops a pinhole spray while the load barely moves. The technician proposes loosening a fitting to “make sure the fuse trips,” then using the same valve as a ram-support substitute.

**Required initial disposition:** **STOP the proposed intervention; NO exposed operation.** A flow-triggered device may not close on a low-flow leak. Opening a pressurized line creates injection, whipping, uncontrolled-motion and trapped-energy hazards. Obtain exact device and circuit evidence, independent physical load restraint and a qualified isolated/remote test plan before any further commissioning decision.

## Ten adversarial paper cases

For each case, write (1) `DOC-CONFIRMED` manufacturer fact, (2) `INFERENCE` about the hypothetical fault, (3) what remains `UNKNOWN`, (4) the specific `BND/ENE/HAZ/SF/PHY/AUTH/DEP/HF/CHG/VAL/PT` records affected, and (5) the safe **HOLD / documentary review / qualified validation** decision. **No actual machine operation.**

| ID | Fictional field report | Key discriminator and expected evidence disposition |
|---|---|---|
| HB-01 | Tiny high-pressure spray, no obvious ram drop | Small flow may remain below excess-flow threshold; hose-injection and trapped-pressure hazards persist. `PHY-HOSE-INJECTION` and `PHY-ENERGY` UNKNOWN. |
| HB-02 | Fuse tripped with heavy test load, never assessed light load | Manufacturer HYDAC explicitly discusses minimum-load emergency flow; do not infer light-load protection from heavy-load observation. `Q_B,min` UNKNOWN. |
| HB-03 | Valve shuts on normal downstroke transitions | Possible normal transient overlaps trip window. OEM warns against repetitive closure; redesign/qualified selection, **not** disabling safeguards. |
| HB-04 | Fuse is 40 cm from the cylinder with flexible hose in between | Identify **unprotected actuator-side segment**; actual geometry and flow direction required. No invented “safe distance.” |
| HB-05 | HYDAC replacement chosen using a Winner catalogue margin | Product-specific setting/tolerance is not transferable; `CHG/DEP/VAL/PT` STALE until exact selected-device qualification. |
| HB-06 | Vendor calls a HIDROS VUBA “load holding” | Manufacturer expressly says VUBA is **not** load holding. Require separate `PHY-HOLD` architecture and witness. |
| HB-07 | Fused chamber holds but opposite chamber is bypassed | Actual two-chamber hydraulic path and load/rod forces UNKNOWN. One closed flow path does not prove global beam hold. |
| HB-08 | HMI E-stop green and `PUMP_OFF`; operator enters die zone | Fuse is not an E-stop stop controller, isolator, lockout or proof of ram restraint. G3/G4 NOT AUTHORIZED. |
| HB-09 | Manufacturer literature describes deliberately opening a line for a burst simulation | This is a **hazardous OEM test description**, not a student lab instruction. No live line opening; freeze a qualified, isolated/remote test only after engineering risk controls and physical witness plan. |
| HB-10 | Fuse closes after line break but load creeps over time | HYDAC page reports pressure-dependent leakage; cannot claim zero drift or safe holding duration. Obtain independent physical `PHY-HOLD` proof and actual machine criteria. |

## Flow-window sketch (symbols only, not a calibration worksheet)

A passive excess-flow fuse requires a usable discrimination window: `Q_normal_max < Q_trip < Q_fault_min`. This is a **necessary conceptual condition**, not sufficient for machine safety. Ask the learner: which direction does the installed fuse sense? What happens if a partial rupture gives `Q_fault <= Q_trip`? What if a normal transient gives `Q_normal >= Q_trip`? Which operating mode, minimum load, viscosity and temperature set each bound? Do not substitute HYDAC's product-specific 20% guidance for measured selected-machine values.

## Human-factors redesign

Make the **correct path faster than the shortcut**: a durable flow-direction/part-number label adjacent to each device; protected and clearly mapped cylinder-to-fuse hose segment; accessible **isolated** inspection and qualified pressure-test points; readily available rated ram restraint; guard/maintenance access that does not require defeating interlocks; clear HMI wording “hose-break device present ≠ safe load support / depressurized.” Do not put the safety decision into the HMI or LinuxCNC/FPGA. Document real operator and maintainer usability observations, not invented time savings.

## Scoring / transfer rule

A competent response must reject **all three false equivalences**: (1) hose-burst fuse = continuous load holding, (2) hose-burst fuse = pressure isolation, (3) a successful OEM-style full-rupture test = protection against every leak. It must distinguish HYDAC, HIDROS and Winner product claims, identify an unprotected line segment, preserve low-flow uncertainty, and reject improvised live rupture testing. This is **teaching/adversarial self-review only**, **not** blind evaluation, external graduation or `TEST-CONFIRMED` physical proof.

**Selected-machine gate:** Y1/Y2 installed part, direction, trip window, leakage, hose geometry, hydraulic topology, qualified independent stop/hold/pressure witnesses and safe test plan remain `UNKNOWN`; `VAL/PT NOT RUN`, G0/G1 HOLD, G3/G4 NOT AUTHORIZED. No personnel-exposed hazardous operation. Any isolated/remote research must keep everyone outside the danger zone under a separately qualified plan.
