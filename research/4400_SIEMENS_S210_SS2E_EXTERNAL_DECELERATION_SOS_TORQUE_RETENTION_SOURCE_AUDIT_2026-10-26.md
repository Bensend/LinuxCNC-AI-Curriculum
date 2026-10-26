# 4400-SS2E-01 — External Safe Stop 2: ordinary deceleration, delayed safe standstill, retained torque

**Original-source investigation / DOC-CONFIRMED exact Siemens S210 07/2021 variant / NON-GRADUATED.** This is distinct from [SS1E-01](4400_SIEMENS_S210_SS1_EXTERNAL_STOP_NO_RAMP_MONITORING_AND_TIMER_SOURCE_AUDIT_2026-10-26.md): the post-delay target is **SOS** (torque retained), not STO (torque removed).

## Exact original

Siemens *SINUMERIK MC Safety Integrated Commissioning Manual*, 07/2021 **A5E47011139B AC**, SINUMERIK MC with SINAMICS S210. Direct original manufacturer PDF: https://cache.industry.siemens.com/dl/files/295/109801295/att_1077953/v1/S210_MC_SI_commiss_man_0721_en-US.pdf. Inspected §5.2.4 printed pp. **137–139**, §7.4.5.3 printed pp. **229–231**. Do not extrapolate to another drive/firmware or installed OpenPressBrake.

## What the manufacturer actually states

- **DOC-CONFIRMED, §7.4.5.3 p.230:** **SS2E** does **not autonomously brake** the motor; the drive follows the higher-level speed setpoint. During **p9553** delay, **SBR and SAM are not monitored and there is no standstill detection**. The higher-level controller must supply a setpoint that stops the motor no later than the delay expires.
- **DOC-CONFIRMED, pp.230–231:** **SOS** becomes active after p9553. The source does *not* say that the delay alone proves the motor stopped; the SOS standstill monitoring is a distinct subsequent state with configured tolerance **p9530**.
- **DOC-CONFIRMED, p.229:** ordinary **SS2** keeps the motor in speed control with full torque available after braking and transitions to monitored standstill. This is different from **STO**, which suppresses torque and is not electrical isolation. Do not claim SS2E removes hazardous energy or that it makes hands-on maintenance safe.
- **DOC-CONFIRMED, §5.2.4 p.137:** with an ordinary higher-level motion controller, an internally triggered OFF3 stop can provoke the controller to detect target/actual mismatch and initiate **OFF2/pulse cancellation**. Siemens advises SS2E or SOS for that integration issue; that recommendation is not a general personnel-safety approval of ordinary controller deceleration.
- **DOC-CONFIRMED, p.230:** SS2E control/status uses PROFIsafe telegram 901 bit 28 in this edition. Status bit or normal HMI reporting is **not** independent proof of safe load-side position or occupancy.

## Failure-path comparison (not a timing simulation)

| Selected function | Deceleration owner | Transition | Hazard if ordinary controller fails |
| --- | --- | --- | --- |
| SS1E | Higher-level speed command | STO after timer | Torque removed potentially before actual standstill; gravity/coast risk |
| SS2E | Higher-level speed command | SOS monitoring after timer | Motion can persist during unmonitored delay; SOS fault response must be qualified; torque remains during normal SOS |
| SS2-r with SBR | Drive OFF3 ramp | SOS after delay, SBR monitoring in configured scope | Higher-level controller may trigger OFF2 on following error; design coordination needed |

**INFERENCE:** If LinuxCNC were chosen as the higher-level setpoint source, it could provide *normal* controlled deceleration but cannot by itself satisfy personnel-safety reliability, fault reaction or load holding. The independent safety design must specify how to react to a lost/stale/incorrect setpoint, how SOS fault transitions to safe final elements, and how the load remains physically held if torque disappears. The actual hydraulic Y1/Y2 press-brake beam is not a motor shaft and cannot be proven by a motor-only SOS bit.

**UNKNOWN:** selected hardware, safety firmware, p9553/p9530, stopping time, actual speed and load-side holding, hydraulic energy, PL/SIL, guards, independent validation. No values inferred.

## Human-factor design and release gate

Make “why SS2E is active but motion is still possible” visible to the operator without offering a bypass shortcut. Protect against retained start commands; provide a deliberate independent reset/rearm and fresh motion request. During service, require qualified physical isolation, trapped-energy verification and independent load restraint; **SOS is not LOTO**. G0/G1 HOLD until selected machine-specific stop/hold/access/pressure evidence is obtained. No live fault injection or people-exposed experiments. **0 hosted/local compute, no physical test, no independent evaluation.**
