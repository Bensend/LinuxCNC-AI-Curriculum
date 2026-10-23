# 4400 — Guard-chain qualification and change-control worksheet

Status: **NOT RUN**, reusable field template, not a design approval. Applies to 2590, 25B0/25C0/25E0, and 4400. Copy into the cumulative Safety Design Package with stable IDs; do not erase stale evidence.

## A. Define safety function and exposure

| Stable ID | Record |
|---|---|
| `BND-` | Machine, guarding zones, entry/egress and service modes |
| `ENE-/HAZ-` | Each hazardous motion/energy and people exposed |
| `SF-/PHY-` | Separate guard-open demand, actual hazard cessation, occupancy and maintenance isolation |
| `SRS-` | Required detection, stopping, restart and diagnostics; target/method only with justified basis |
| `AUTH-` | Ordinary LinuxCNC/HAL/FPGA vs independent safety control vs physical final elements |

## B. Device topology and independent evidence

| Required witness | Exact selected fact / manual edition | Class | UNKNOWN / impact |
|---|---|---|---|
| Each guard's device variant, actuator and mounting | | | |
| Passive dry contacts or integrated self-monitoring outputs | | | |
| Two-channel physical series, individual wiring or supported cascade | | | |
| Number of gates, operators, simultaneous/frequent openings | | | |
| Receiver input mapping, discrepancy detection, fault latching and reset | | | |
| Wiring shorts, test pulses, cross-fault coverage, shared power/0 V | | | |
| Cascade length and component/chain reliability composition | | | |
| Per-gate diagnostics (ordinary HMI only as supplemental) | | | |
| Safety outputs and final-element physical effect | | | |
| Machine-level stopping, restraint, residual-energy and access proof | | | |

## C. Adversarial fault sequence — do not perform on an exposed hazardous machine

Predeclare predicted selected-receiver behavior for each case and record whether manufacturer's published design evidence suffices. Freeze a bounded safe bench experiment **only** if the remaining decision-critical question is not adequately resolved by documentation.

| Case | Expected independent evidence | Selected result / status |
|---|---|---|
| Open A alone, B closed | Both contact paths expected to open if healthy; selected receiver diagnosis | NOT RUN |
| A contact/channel fault with B closed | Is a discrepancy detected/latched? | NOT RUN |
| A fault with B simultaneously open | Can B's opening conceal A's mismatch? | NOT RUN |
| Restore B and A in different orders | Does receiver preserve diagnostic fault until repair? | NOT RUN |
| Supply/0 V fault shared by both channels | Does a plausible state remain possible? | NOT RUN |
| Held reset, power return, retained ordinary start | Does independent safety owner prevent unauthorized restart? | NOT RUN |
| Relay healthy but physical motion persists | Independent stop/hold/restraint witness wins | NOT RUN |
| Gate reinstalled after service, actuator misaligned | Guard usability and fault detection verified | NOT RUN |

## D. Human-defeat and design-for-restoration review

Record at least three real tasks that require guard opening. For each, record time/inconvenience using the guard correctly, the shortcut incentive, likely defeat method, and **design correction** (alignment, captive hardware, quick maintenance mode with independently justified alternate protection, local status, accessible reset, physical escape). A written instruction to “never bypass” is not a design correction.

## E. Decision / change control

- `DEP-*` series topology and common causes recorded: [ ]
- `ARC-*` chosen after actual component/receiver comparison: [ ]
- `VAL-*` physical safe-state evidence independent of input logic: [ ]
- `HF-*` foreseeable bypass corrected or residual restriction documented: [ ]
- `CHG-*` all affected SRS/PHY/DEP/ARC/VAL/PT marked STALE after change: [ ]
- `UNK-*` selected DC/PFHd/PL/SIL and physical limits remain UNKNOWN until proven: [ ]
- Decision: **NOT READY FOR EXPOSED-PERSON OPERATION** unless actual machine-level evidence proves the minimum threshold.

Reference: `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md`, `hardware/SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md`, and the 4400 fault-masking research note.
