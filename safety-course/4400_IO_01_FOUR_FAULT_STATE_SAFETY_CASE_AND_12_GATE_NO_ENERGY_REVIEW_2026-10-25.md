# 4400-IO-01 — Four different diagnostic outcomes; one independent physical safe-state requirement
**Integrated 4000 safety engineering worksheet, 2026-10-25. Documentary G0 review only; 12 gates NOT RUN.** Derived from exact original [Rockwell/Pilz input audit](../research/4400_ROCKWELL_PILZ_TEST_PULSE_SHARED_SOURCE_CROSS_SHORT_AND_SAFETY_INPUT_VARIANT_AUDIT_2026-10-25.md), [Rockwell output backfeed audit](../research/4400_ROCKWELL_POINTMAX_SAFETY_OUTPUT_SA_BACKFEED_DETECTED_NOT_SAFE_OEM_AUDIT_2026-10-25.md) and [SICK TGS OSSD audit](../research/4400_SICK_TGS_OSSD_TEST_PULSE_NONMONITORED_SIGNAL_AND_RECEIVER_SCOPE_AUDIT_2026-10-25.md).

## Why the distinction matters
A safe machine requires the hazardous **physical state** to be controlled, not merely an OFF request or an alarm. Manufacturer documents establish four **different** fault/test mechanisms that a generic "dual-channel safety I/O" description conceals.

| Case | Specific OEM fact (DOC-CONFIRMED for named model) | Diagnostic indication | Physical hazard conclusion |
|---|---|---|---|
| **A: invisible input bridge** | Rockwell 5034-IB8S/XT two SI fed from same TO can have undetected cross-short in Safety Pulse Mode | May not detect that bridge | **UNKNOWN** until other independent protective-function evidence |
| **B: detected output bypass** | Rockwell 5034-OB8S/XT SA+ -> SO_n can prevent load shutdown despite fault bit | Fault detected | **Potentially still energized** under named OEM condition; physical stop/hold separately UNKNOWN |
| **C: automatic test-source recovery** | Rockwell 5034 input TO turns off for overload/short-to-ground, then restarts commanded state after fault removal | Fault sets then clears | Input-test recovery is **not** a machine reset or fresh motion command; physical state UNKNOWN |
| **D: deliberate sensor self-test** | SICK TGS OSSD briefly pulses LOW during normal active operation; auxiliary signal unmonitored | Pulse is normal sensor test, not necessarily a safety demand | Downstream receiver must be compatible; actual physical safety UNKNOWN |

**Avoid the false binary "detected fault = safe" or "two channels = detected fault".** The first is disproved by Case B; the second by Case A. Cases C/D demonstrate why a fault/status transition does not automatically imply a legitimate motion start or stop. **This table does not imply that any named component is installed on OpenPressBrake.**

## Fault-path decomposition for a press brake
```text
Hazard/task (person at front/rear/tooling)
  -> physical protective device (contact / OSSD)
  -> safety-rated input (channel identity / diagnostic owner)
  -> safety logic (fault response, reset, occupancy)
  -> safety output (field short/backfeed and monitoring)
  -> independent physical final element (electrical/hydraulic)
  -> actual Y1/Y2 stop + gravity hold + pressure isolation
  -> guarded access / maintenance lockout / rescue
  -> deliberate reset, then a NEW ordinary motion command
```
Normal LinuxCNC/HAL/FPGA may command process motion and display diagnostic state, but **must not** replace qualified safety logic, physical energy removal or independent stop/hold evidence.

## Twelve-gate no-energy documentary review (ALL NOT RUN)
| Gate | Required evidence | Decision now |
|---|---|---|
| IO-G0-01 | Selected machine ID, operation/maintenance modes, exposed persons and hazard boundary | UNKNOWN |
| IO-G0-02 | Safety-function requirements, stop/hold/guard/LOTO/rearm dependencies and applicable standards editions | UNKNOWN |
| IO-G0-03 | Exact sensor part/revision and contact vs active OSSD vs unmonitored auxiliary signal role | UNKNOWN |
| IO-G0-04 | Exact receiver SI/TO model, mode, terminal assignments, pulse-source identity and fault exclusions | UNKNOWN |
| IO-G0-05 | Short/open/cross-short/24V/0V field-wiring coverage, cable routing and common-cause assessment | UNKNOWN |
| IO-G0-06 | Sensor-originated self-test, receiver compatibility, input filter, cable electrical loading and configuration revision | UNKNOWN |
| IO-G0-07 | Safety output SO/SA+ paths, external backfeed possibilities, output mode and qualified final-element feedback | UNKNOWN |
| IO-G0-08 | Actual power isolation, valve/pilot/pressure and independent Y1/Y2 physical stop/hold, including gravity | UNKNOWN |
| IO-G0-09 | Guards/escape/access/occupancy and no-exposure maintenance plan | UNKNOWN |
| IO-G0-10 | Loss/return of supply, detected/undetected faults, diagnostic clearing, reset and **fresh** motion command | UNKNOWN |
| IO-G0-11 | Service human factors: labeled exact terminals, keyed replacements, easy guard reinstatement, no jumper residue | UNKNOWN |
| IO-G0-12 | Qualified independent documentary signoff, then separately approved physical validation protocol and witnesses | NOT RUN |

**Release rule:** do not mark any UNKNOWN as PASS from an HMI, relay READY, two channels, a datasheet safety class or a fault bit. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED. No personnel-exposed operation while basic physical stop/hold/guarding is unproven. Any experimental operation must be isolated/remote, with people outside danger zone and residual risk explicitly controlled by qualified personnel.

## Design-for-human-behavior challenge
A mechanic has 20 minutes to restore production after a nuisance safety trip. A useful engineering design has an accessible terminal map with source/destination/mode, visible cable inspection path, preapproved sensor/controller replacements, diagnostic cause without needing a jumper, and a short guard-restoration/rearm checklist. If bypassing a safety input is faster than fixing its source/mode mismatch, **redesign the service path**; training alone will not fix that incentive.

## Independent competency and evidence status
No blind challenge generated or self-scored. A future evaluator should supply an **unseen** exact OEM sensor/receiver/output combination and require a precommitted learner fault-path prediction before revealing the result. The 12 gates are **documentary preparation**, not execution or functional-safety certification. **TEST-CONFIRMED none, SOURCE-CONFIRMED new LinuxCNC source none, DOC-CONFIRMED exact OEM only, INFERENCE system architecture, UNKNOWN selected machine.** No simulation/Actions/physical test justified by these already answered documentary questions.
