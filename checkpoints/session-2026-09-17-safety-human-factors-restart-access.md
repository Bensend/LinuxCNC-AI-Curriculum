# Safety human-factors / restart-access session — 2026-09-17

- Session start UTC: `2026-09-17T05:36:23Z`
- Session end UTC: `2026-09-17T05:38:14Z`
- Actual elapsed: `1.85 min`
- Overlap status: `NO EVIDENCE OF OVERLAP` — current durable prior checkpoint ended `2026-09-17T03:47:00Z`.
- Compute: `NONE`; authoritative manufacturer documentation + engineering synthesis only. No GitHub-hosted Actions minutes consumed; self-hosted compute was not justified.
- Status: CHECKPOINTED — safety course remains active.

## Durable work completed

1. Added `safety-course/HUMAN_FACTORS_RESTART_ACCESS_AND_GUARDING_REVIEW_2026-09-17.md`.
   - separated reset from machine start and ordinary-controller rearm;
   - added reset sightline/reachability review;
   - added access-request vs guard-unlock authority distinction;
   - added escape/occupancy/restart-inhibition review for accessible guarded spaces;
   - converted foreseeable safeguard defeat/inconvenience into an engineering review item rather than a warning-only issue.
2. Strengthened `safety-course/FIELD_COMMISSIONING_MINIMUM_OPERATE_CARD.md` with RESET/START SEPARATION, ACCESS/UNLOCK AUTHORITY, ESCAPE/OCCUPANCY and DEFEAT RESISTANCE gates.
3. Added `safety-course/STALE_COMMAND_RESTART_ADVERSARIAL_TEST_MATRIX_2026-09-17.md` covering foot controls, cycle start, jog, queued program motion, HAL/PLC state, network commands, FPGA registers, analog/current commands and process enables across safety/control interruptions.

## Evidence gained

- SICK machinery-safety guidance: manual reset outside hazard zone, inaccessible from inside, with visibility of the hazardous area; reset must not itself create dangerous movement.
- SICK S300 Mini: reset restores monitoring readiness and machine restart is a second step; automatic reset is restricted to cases where occupancy cannot create danger.
- SICK sBot Stop: reset pushbutton outside hazardous area and primary protective field.
- Pilz PSENmlock family: accessible guard solutions include inside escape release and restart-lockout provisions; personnel-protection guard locking must address power-loss behavior.
- Rockwell DCSTL: unlock request is distinct from lock feedback and unlocking is conditioned on hazard absence.

## Exact next work

1. Apply the expanded commissioning card to a complete modern machine drawing/implementation set that exposes safeguarding, safety logic, final elements, access/guard locking and physical energy paths together.
2. Specifically trace one stale-command restart path end-to-end: command source -> LinuxCNC/HAL -> transport/FPGA -> actuator request -> independent safety authority -> physical final element.
3. Preserve machine-specific PL/SIL/DC, stopping, pressure, timing and hydraulic truth-table values as `UNKNOWN` until established by authoritative design evidence/measurement.
4. If complete public press-brake evidence remains source-limited, rotate to a professional mill/lathe/robot/cell implementation rather than manufacturing speculative press-brake detail.

## LESSON_LOG safe-append status

`LESSON_LOG.md` remains a large/truncated file through the available GitHub connector, and no verified atomic append action is exposed. It was not overwritten. Append this exact row only through a verified safe append path:

`| 2026-09-17 | Safety course — human factors, restart/access, stale-command validation | 2026-09-17T05:36:23Z | 2026-09-17T05:38:14Z | 1.85 | RESTART/ACCESS HUMAN-FACTORS GATES + STALE-COMMAND MATRIX | Complete modern-machine application with physical energy trace | No overlap; no compute. |`
