# 4400-ACCESS-01 — Timed guard release, monitored-only safe speed, and power-to-lock fault polarity
**Safety course | 2026-10-25 | NON-GRADUATED | PAPER / documentary evidence only**

## Prerequisites and outcome
Prerequisites: 2520 hazard-to-SRS, 2530 allocation, 25B0/25C0 safety validation and access, 4400-SD-01/SD-02 diagnostic-vs-safe unlock, 4400-MON-01 safe-speed sensing and independent Y1/Y2 gravity load. Learner must identify **which** proposition an OEM safety monitor actually proves, what response it commands, and whether the guard can open with residual hazard.

Primary source: [direct 2013 Rockwell original-OEM audit](../research/4400_ROCKWELL_KINETIX_SAFE_STOP_UNCHECKED_UNLOCK_STATUS_ONLY_AND_POWER_TO_LOCK_SOURCE_AUDIT_2026-10-25.md); manual https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/2094-rm001_-en-p.pdf, printed pp.58–65, 84. Supporting official Pilz EN/IEC 61800-5-2 explainer https://www.pilz.com/en-US/support/lexicon/articles/200448.

## Three failure mechanisms that look like a successful safety state
**A — Timer expired, hazard not measured.** Rockwell Kinetix 6200/6500 safe-speed option, 2013 manual p.60: **STO without standstill checking** withdraws motion power, then releases the door after configured Maximum Stop Time **regardless of actual speed**. This may be appropriate only where independently justified by the risk assessment and stopping-time evidence; it is **not** an observed zero-speed proof. Never copy the example timer into another machine.

**B — Safe status, no automatic action.** The same manual p.84: **SLS Status Only** reports a safety speed-status signal for a separate safety PLC and explicitly does **not** stop automatically on overspeed. A safety-rated measurement is not a safety function until the receiver, logic, final element and physical consequence are allocated and validated. A green ordinary HMI speed tile does not substitute.

**C — Output OFF, door unlocked.** The same manual p.65: **Power to Lock** uses output OFF to mean **unlocked**; selected faults force output OFF and the OEM warns about this condition. Distinguish *loss of locking* from *safe release*, and *inside escape* from *automatic unlocking*. A power-to-release alternative has different failure tradeoffs, not a universal best answer.

## Worked safe-state proposition table
| Stage | Observable item | May prove | Cannot prove alone |
|---|---|---|---|
| Normal LinuxCNC / FPGA | commanded speed=0; servo ready; cycle paused | ordinary command/state | safe physical stop, load held, guarding integrity |
| Safety speed monitor | below configured threshold | **at the selected sensor**, under its diagnostic assumptions | hazard at disconnected output shaft; ram holding; pressure removed |
| Safety status-only output | overspeed or status asserted | monitor's configured logical proposition | final safety reaction or power removal |
| Safety stop output | torque inhibit requested / state faulted | commanded/integrated drive safety function, within manual scope | stopped high-inertia tool; vertical load mechanically restrained |
| Guard output | DC_Out changes polarity-dependent state | requested lock/unlock output state | actual lock engagement, escape, occupancy, residual hazard |
| Final element and machine | qualified measured stop/hold/energy witness | particular selected-machine safe-state proposition | all lifecycle states or SIL/PL without full validation |

## Physical machine transfer
- **Press brake:** two independent Y1/Y2 axes, hydraulic/gravity/pressure, ram support and tool retention must be separately proven. The Kinetix manual's SS1 vertical-axis restriction is *product-specific*, not a hydraulic design recommendation.
- **Lathe/mill:** spindle coast-down, chuck/workpiece stored kinetic energy, tool magazine and unexpected restart; release cannot rely on commanded zero.
- **Saw/grinder:** wheel/blade inertia and changing diameter; standstill and guard release are distinct from spindle STO.
- **Robot/cell:** multiple hazardous axes and zones; one axis' speed status cannot release a common gate without every relevant safe-state witness and occupancy protection.
- **Plasma table:** arc, high voltage, fumes and gas energy remain hazards even if gantry motion is stopped.

## Human-factor default architecture
Offer a visible **Request Safe Access** control. The independent safety chain denies unlock until its validated physical stop/hold and access prerequisites are satisfied. Explain denial with useful ordinary diagnostics while keeping diagnostic paths unable to override safety authority. Make guard reinstall, cleaning, maintenance and reset straightforward; avoid nuisance-trip workarounds and defeated locks. Fault and power-return should not restore a previous cycle's motion request. For service work, apply independent hazardous-energy isolation and physical restraints; safe motion monitoring alone is not lockout.

## Documentary verification before any physical test
1. Identify exact device/manual/firmware and as-built configuration.
2. Classify mode as standstill-checked, time-based release, or status-only; do not infer from product branding.
3. Trace speed sensor to actual hazardous element; analyze mechanical coupling and common causes.
4. Trace **safe** output to independent logic, final element, and physical hazard removal.
5. Trace door output polarity, power loss, selected faults and actual locking state.
6. Trace occupancy/inside escape and reset/rearm/fresh motion authorization.
7. Trace stored kinetic energy, gravity load, hydraulic pressure and service restraint separately.
8. Record qualified evidence and the responsible verifier for each proposition.
All remain **UNKNOWN/NOT RUN** for OpenPressBrake until qualified selected-machine evidence exists. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No people-exposed operation.

## Evaluation, evidence and promotion
Use the [open technician cases](4400_ACCESS_01_SIXTEEN_FALSE_SAFE_STATE_PAPER_CASES_2026-10-25.md) as **practice, not blind scores**. External evaluator 2520–25F0 remains independent and unexecuted. DOC-CONFIRMED source-specific Rockwell/Pilz; INFERENCE architecture; SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none; selected-machine physical proof UNKNOWN.

**Promotion / unresolved:** actual selected drive mode, sensor mounting, guard polarity, stop time, hydraulic Y1/Y2 holding, inside escape, SRS/PL/SIL and physical validation remain critical and **block machine release**. Counterfactual test: if any physical assumption fails, the safe-access conclusion can reverse, so these are not safely promotable as mere documentation polish. Do not graduate this safety branch without independent evaluation and qualified physical proof.
