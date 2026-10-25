# 4400-ATC-01 — 14 technician paper challenges and blank field witness
**2026-10-25 | LEARNER-VISIBLE / PAPER ONLY / NOT SCORED**

For each case separate (1) OEM mechanical retention, (2) normal CNC command/sensor, (3) independent protection, (4) tool capture and personnel exclusion, (5) service energy, (6) reset/restart, and (7) discriminating evidence. No live tool-drop or unexpected release experiment with people exposed.

| ID | Paper scenario |
|---|---|
| ATC-T01 | Spindle is stopped, clamp switch green, but Belleville washers have lost force. |
| ATC-T02 | Precharge solenoid remains energized briefly after release command ends. |
| ATC-T03 | Toolholder drops before double arm can grab it. |
| ATC-T04 | Arm-home prox sensor cable fails, Z advances toward arm. |
| ATC-T05 | Extractor fingers are worn and carousel pocket loses tool during rotation. |
| ATC-T06 | Heavy tool is substituted without checking holder/pocket capacity. |
| ATC-T07 | TRP sensor misaligned; drawbar releases only partly and arm pulls on stuck tool. |
| ATC-T08 | Service technician isolates electrical power but compressed air remains trapped at TRP. |
| ATC-T09 | Air supply fails: does spring-clamped mechanism guarantee tool retention? Identify assumptions. |
| ATC-T10 | Controller E-stop latched, toolchanger mechanism is held by gravity and spring preload. |
| ATC-T11 | Guard is closed but a worker remains inside under tool carousel. |
| ATC-T12 | Reset clears fault and queued M6 resumes without fresh deliberate start. |
| ATC-T13 | HSK-specific push-out/force values are copied to a different spindle family. |
| ATC-T14 | Guard latches poorly; operators routinely tape it shut. Propose a safer, easier workflow. |

## Blank selected machine witness
| Evidence | Qualified owner / artifact | Status |
|---|---|---|
| Machine, spindle/toolholder/arm/pocket exact OEM model and revisions | restricted inventory | UNKNOWN |
| Mechanical drawbar/pull-stud retention force criteria and instrument | qualified OEM record | UNKNOWN |
| Capture/transfer phase map and independent fault monitoring | as-built wiring/sequence | UNKNOWN |
| TRP pneumatic/valve/precharge, trapped-energy/isolation map | as-built pneumatic diagram | UNKNOWN |
| Access, guard, egress and drop-zone coverage | site observation and risk assessment | UNKNOWN |
| Protected stop/hold and deliberate restart after faults | approved no-exposure physical witness | NOT RUN |
| Independent fresh evaluator and scored novel transfer | sealed oracle after precommit | NOT RUN |

**Conditional only**: no Haas toolchanger, UR robot or such system is asserted installed on OpenPressBrake. Its Y1/Y2 ram independent stop/hold, hydraulic isolation and rear guarding remain UNKNOWN. No invented numerical limits, PL/SIL or safety certification. G0/G1 HOLD; G3/G4 NOT AUTHORIZED.
