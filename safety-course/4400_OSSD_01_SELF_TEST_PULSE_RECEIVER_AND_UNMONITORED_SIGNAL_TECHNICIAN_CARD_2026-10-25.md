# 4400-OSSD-01 — Safety sensor self-test pulses versus receiver filtering and unmonitored auxiliary status
**Learner-facing 4400 safety card, 2026-10-25; NON-GRADUATED.** [Original SICK TGS 2009 source audit](../research/4400_SICK_TGS_OSSD_TEST_PULSE_NONMONITORED_SIGNAL_AND_RECEIVER_SCOPE_AUDIT_2026-10-25.md). No selected-machine device or tests.

## Mechanism
The inspected SICK TGS light curtain's **OSSD** deliberately goes briefly LOW during internal self-testing. Its OEM instructs designers to select downstream controls that **do not drop out because of those normal test pulses**. The same OEM calls the additional **signal output unmonitored**, even though it is used within a specified two-channel PLC evaluation arrangement. **Neither a green auxiliary status nor a self-test waveform is a substitute for a qualified safety-function design.**

Do not confuse:
1. Sensor-originated OSSD LOW self-test (SICK TGS original §5.1);
2. Receiver-originated test pulses on dry-contact safety inputs (Rockwell 5034-IB8S/XT, companion PULSE-01);
3. Safety-output-to-load positive supply backfeed (Rockwell 5034-OB8S/XT, companion OUT-01);
4. Actual physical press-brake Y1/Y2 stop/hold, independent of the above.

## Eight paper-only technician cases (NOT SCORED)
| # | Case | Evidence question |
|---|---|---|
| 1 | TGS OSSD brief LOW pulse makes downstream relay chatter | Exact OEM self-test and receiver input compatibility, not bypass |
| 2 | Mechanic replaces OSSD input with ordinary LinuxCNC digital input | Independent safety authority missing |
| 3 | TGS unmonitored signal output is used as if it were an independent safety OSSD | Exact OEM signal role and monitoring limitation |
| 4 | Input filter lengthened to suppress nuisance trips | Risk of masking real demand; exact qualified receiver validation needed |
| 5 | Sensor is replaced with another SICK model | Revision-specific output electrical characteristics and response |
| 6 | Extra cable length/capacitance is added | OEM output load/cable limits and fault-detection effect |
| 7 | A light curtain's LEDs are green but someone can step behind the field | Physical guarding, occupancy, fresh restart and access |
| 8 | OSSD OFF is seen, but hydraulic ram still moves | Final-element stop, trapped pressure, gravity holding separate |

For each case, label **DOC-CONFIRMED / INFERENCE / UNKNOWN**, specify an evidence request and a safe no-energy next step. No live fault injection or guessing numerical filters/PL/SIL/stopping distance.

## Make the safe solution the convenient solution
Retain exact sensor and receiver manuals at the machine, label monitored versus auxiliary terminals, preapprove compatible replacement part numbers, make the guard easy to clean and align, and provide an accessible fault-history display. Investigate nuisance trips at the cause rather than encouraging jumpers or disabled input tests.

## Physical and graduation gates
Qualified G0 must obtain selected sensor/receiver models, as-built cable and output roles, actual protective field/access, final-element/EDM and Y1/Y2 physical stop/hold, maintenance LOTO, rescue and fresh start. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED. External information-separated fresh transfer and physical validation NOT RUN; no machine safe-to-operate claim.
