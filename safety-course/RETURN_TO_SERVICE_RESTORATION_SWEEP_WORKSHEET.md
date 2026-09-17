# Return-to-Service Restoration Sweep Worksheet

Status: WORKING SAFETY-COURSE ARTIFACT
Date: 2026-09-17
Scope: final maintenance / troubleshooting / test-to-production transition for LinuxCNC and other industrial machines.

## Purpose

A successful repair, a cleared fault, a reboot, a passing jog test, or removal of LOTO is not by itself evidence that a machine is ready for normal production. This worksheet creates a deliberate restoration boundary between **maintenance/test state** and **production-ready state**.

Use it after servicing that may have changed guards, safety devices, wiring, parameters, firmware, hydraulic/pneumatic connections, temporary test equipment, software forces, blocking/restraint, or other safety-relevant state.

The worksheet does not assign a PL/SIL/category, hydraulic truth table, stopping distance, pressure threshold, or safe-speed value. Those remain machine/design specific and require the applicable risk assessment, design evidence and validation.

## Evidence basis

### SOURCE-CONFIRMED — OSHA 29 CFR 1910.147

- 1910.147(e)(1): before energy is restored, inspect the work area for removal of nonessential items and ensure machine/equipment components are operationally intact.
- 1910.147(e)(2): ensure employees are safely positioned or removed; after LOTO devices are removed and before startup, notify affected employees.
- 1910.147(e)(3): each lock/tag is normally removed by the employee who applied it; the absent-employee exception requires a specific documented equivalent-safety procedure.
- 1910.147(f)(1): temporary energization for testing/positioning is a bounded sequence: clear tools/materials, remove employees, remove LOTO correctly, energize/test, then deenergize and reapply energy control before servicing continues.
- 1910.147(d)(5): stored/residual energy must be relieved, disconnected, restrained or otherwise rendered safe, with continued verification where hazardous reaccumulation is possible.
- 1910.147(d)(6): isolation/deenergization is verified before servicing begins.

### SOURCE-CONFIRMED — OSHA Appendix A / enforcement guidance

The typical minimum procedure adds practical restoration checks: equipment/components operationally intact, personnel clear, controls neutral, then remove lockout devices and reenergize. OSHA enforcement guidance explicitly includes replacement of safeguards in release-from-LOTO review.

### INFERENCE — engineering restoration rule

The OSHA release sequence is a minimum hazardous-energy-control boundary, not proof that a modified safety-related control function has been fully validated. If servicing changed a safety-relevant device, circuit, parameter, firmware/configuration, mechanical arrangement, valve, brake, guard geometry, protective-device alignment, or final element, production release requires the applicable validation/revalidation evidence in addition to LOTO release.

## State model

Do not collapse these states:

1. `OUT-OF-SERVICE / HAZARDS CONTROLLED`
2. `ASSEMBLED-PENDING-TEST`
3. `ENERGIZED-TEST-MODE`
4. `TEST-COMPLETE-PENDING-RESTORATION`
5. `RESTORED-PENDING-VALIDATION`
6. `IN-SERVICE-VALIDATED`
7. `NORMAL-PRODUCTION-STARTED`

A transition may move backward when evidence fails. A reboot, reset, operator login, LinuxCNC Machine-On command, FPGA reconnect, network recovery, safety reset, or LOTO removal must not silently skip intermediate states.

## A. Maintenance/test artifact reconciliation

For every item, record `NOT USED`, `REMOVED/RESTORED + evidence`, or `OPEN — production release blocked`.

| Temporary state / artifact | Identification/location | Removal/restoration evidence | Independent check where warranted | Status |
|---|---|---|---|---|
| Electrical jumper / short / lifted wire | | | | |
| Temporary ground / bond | | | | |
| Test plug / breakout harness | | | | |
| Bench/external power supply | | | | |
| Forced PLC/HAL/I/O state | | | | |
| LinuxCNC HAL override / temporary net | | | | |
| FPGA diagnostic/test firmware | | | | |
| Temporary parameter/config change | | | | |
| Bypassed/muted protective device | | | | |
| Defeated/interposed guard switch | | | | |
| Temporary hydraulic/pneumatic hose or gauge | | | | |
| Mechanical block/restraint/fixture | | | | |
| Removed cover/guard/panel | | | | |
| Service tool/material left in machine | | | | |
| Other temporary state | | | | |

**Hard rule:** software restart does not prove that physical jumpers, test plugs, external supplies or mechanical fixtures are gone. A cleared diagnostic screen is not a restoration sweep.

## B. Baseline identity and change-impact sweep

Record the approved baseline or controlled reference where one exists.

| Item | Expected baseline | Actual restored state | Evidence | Change impact / revalidation required? |
|---|---|---|---|---|
| Safety controller/device identity | | | | |
| Safety program/configuration | | | | |
| Drive safety parameters | | | | |
| LinuxCNC configuration relevant to normal control | | | | |
| FPGA firmware / bitstream | | | | |
| Safety-related wiring / terminals | | | | |
| Contactor / relay / EDM wiring | | | | |
| Guard/interlock device | | | | |
| Light curtain / scanner / laser protective device | | | | |
| Hydraulic/pneumatic safety element | | | | |
| Mechanical brake/block/retention device | | | | |
| Replacement component MPN/revision | | | | |

A replacement that is physically interchangeable is not automatically safety-function-equivalent. Preserve `UNKNOWN` until ratings, behavior, diagnostics, configuration and application suitability are established to the level required by the design.

## C. Physical safeguard restoration

- [ ] Fixed/removable guards installed and secured as intended.
- [ ] Interlocked guards physically aligned; no improvised target/magnet/key remains.
- [ ] Protective-device mounting/alignment restored and protected from easy displacement where applicable.
- [ ] Access panels/covers restored.
- [ ] Safety-device cables/connectors strain-relieved and routed as intended.
- [ ] No maintenance convenience has made bypass easier than normal use.
- [ ] Any deliberately permitted setup mode returns to the intended normal-production mode and cannot remain accidentally selected.
- [ ] Mode indication is unambiguous to the operator.

Human-factors test: **Would the next operator have an obvious, easier normal-safe workflow, or did the repair leave a reason to defeat the safeguard?** If the latter, treat that as an engineering defect to correct, not merely an operator-training problem.

## D. Final-element and diagnostic proof

Populate only functions actually present on the machine. Do not infer safety capability from a device name.

| Safety function / demand | Commanded safe response | Physical final element | Feedback/EDM/diagnostic evidence | Fault intentionally exercised? | Result |
|---|---|---|---|---|---|
| E-stop | | | | | |
| Guard interlock | | | | | |
| Light curtain/scanner/laser protective device | | | | | |
| STO | | | | | |
| SS1 / safe-motion function | | | | | |
| Contactor drop-out | | | | | |
| Hydraulic safety/holding valve | | | | | |
| Pneumatic dump/isolation | | | | | |
| Mechanical brake/retention | | | | | |
| Other | | | | | |

Distinguish:

- controller says output OFF;
- output channel voltage/current changed;
- final element actually changed state;
- feedback/EDM agrees;
- hazardous actuator is physically prevented/controlled as intended.

These are different claims.

## E. Stored energy and restraint transition

Before removing a maintenance block/restraint or restoring pressure/energy, record:

- what load/ram/axis/member the restraint controls;
- what energy source can move it after restraint removal (gravity, accumulator, hydraulic pressure, pneumatic pressure, spring, flywheel, DC bus, etc.);
- what normal/safety function takes over that protective role;
- what evidence proves that function is available before restraint removal;
- who/what is clear of the hazard zone;
- whether removal itself requires bounded energization.

OSHA Appendix A notes that some blocking may require reenergization for safe removal. Treat that as a controlled transition, not permission to resume exposed servicing under normal machine authority.

## F. Bounded energized test gate

If testing/positioning requires energization while maintenance is incomplete:

1. define the exact test and expected evidence;
2. remove tools/materials that could create a hazard;
3. remove exposed personnel from the machine/equipment area as required by the energy-control procedure;
4. transition LOTO according to the authorized procedure;
5. energize only for the bounded test/positioning activity;
6. stop when the evidence is obtained or the test deviates;
7. deenergize and reapply required energy controls before exposed servicing resumes.

Do **not** turn `test mode` into a standing maintenance bypass. If repeated diagnosis needs guarded access with motion, use an engineered setup/service-mode architecture where justified; otherwise isolate/remote the experiment and keep people outside the danger zone.

## G. Reset, restart and rearm separation

Record each separately:

| Transition | Required action | Authority/source | Must NOT automatically cause |
|---|---|---|---|
| Protective demand clears | | independent safety system | machine motion |
| Safety reset / restart-interlock release | | independent safety system | normal cycle start |
| Safety fault acknowledgment | | safety system/device | masking an uncleared fault |
| LinuxCNC recovery/restart | | ordinary controller | personnel-safety reset |
| FPGA/network watchdog recovery | | ordinary controller | actuator authority without explicit normal rearm |
| Normal actuator rearm | | ordinary controller | bypass of safety readiness |
| Production START | | operator/normal control | bypass of any preceding gate |

## H. Personnel, tools and ownership release

Before production release:

- [ ] Work area inspected; nonessential items removed.
- [ ] Machine/equipment components operationally intact to the evidence available.
- [ ] All employees safely positioned/removed as applicable.
- [ ] All authorized workers accounted for under the energy-control procedure.
- [ ] Locks/tags removed by their owners or by the documented absent-owner exception.
- [ ] Affected employees notified after LOTO removal and before machine startup as required.
- [ ] Open safety-relevant `UNKNOWN`s reviewed; none silently converted to PASS.
- [ ] OUT OF SERVICE status remains until the defined restoration/validation evidence is complete.

## I. Production-release decision

### RELEASE only when

- temporary maintenance/test states are positively reconciled;
- guards/protective devices are physically restored;
- energy-control release requirements are satisfied;
- relevant safety-related changes have the required validation/revalidation evidence;
- final-element response/feedback is demonstrated to the level required by the machine design;
- normal-control configuration/firmware is restored and identified;
- reset/rearm is separated from normal start;
- personnel/tools are clear;
- no unresolved safety-relevant UNKNOWN could invalidate the release decision.

### HOLD OUT OF SERVICE when

Any required evidence is missing, a bypass/temporary state cannot be positively accounted for, a changed safety function has not been revalidated, a final element/feedback behaves unexpectedly, or the physical hazard boundary is not understood well enough to justify exposed operation.

If a machine cannot meet the basic minimum safe-to-operate threshold, do not operate it with people exposed to the hazard. Experimental operation, if necessary for diagnosis, must be isolated/remote with people outside the danger zone and residual risk stated plainly.

## J. Cross-machine prompts

### Press brake

Check ram blocking/restraint transition, hydraulic stored/reaccumulating energy, protective-device alignment, Y1/Y2 safety/holding-valve monitoring where actually fitted, foot/enabling controls, mode restoration, and separation of ordinary proportional command from independent safety authority. Do not invent the valve truth table.

### Mill / lathe / router

Check spindle/drive STO or contactor path as actually designed, axis gravity/overhauling loads, guard/interlock restoration, toolchanger/turret auxiliary hazards, and that LinuxCNC Machine-On does not substitute for safety reset.

### Plasma / laser / waterjet

Check motion plus process-energy hazards separately: arc/high voltage, laser emission, pressure, gas and stored energy as applicable. A motion-safe state is not automatically a process-energy-safe maintenance state.

### Robot / automated cell

Check all access points/zones, trapped-person/restart prevention, enabling/setup mode restoration, cell peripherals, pneumatic/hydraulic tooling and coordinated restart. Clearing one safety zone does not prove the whole cell is ready.

## Claims ledger

| Claim | Classification | Evidence / limit |
|---|---|---|
| Before restoring energy, inspect for nonessential items and operational integrity and ensure employees are safely positioned/removed. | SOURCE-CONFIRMED | OSHA 1910.147(e)(1)-(2). |
| Temporary energization for testing/positioning is bounded and must return to deenergized energy-control state before servicing continues. | SOURCE-CONFIRMED | OSHA 1910.147(f)(1). |
| Stored/residual/reaccumulating energy remains part of the control problem through servicing. | SOURCE-CONFIRMED | OSHA 1910.147(d)(5). |
| LOTO release alone does not prove a modified safety function has been validated. | INFERENCE | Engineering distinction between hazardous-energy-control procedure and safety-function validation; validate per applicable machine/safety design requirements. |
| LinuxCNC/FPGA reboot or cleared diagnostics proves physical restoration. | REJECTED | Physical jumpers, guards, final elements and external energy sources require independent evidence. |
| A generic worksheet can prescribe a press-brake hydraulic safe-state truth table or safe-motion value. | REJECTED / UNKNOWN | Machine/design-specific evidence and calculation required. |

## Adversarial review prompts

1. A technician removes a HAL force, reboots LinuxCNC and sees all diagnostics green. What physical restoration claims remain unproven?
2. A replacement contactor has the same coil voltage and current rating. What must be checked before assuming the original safety function remains valid?
3. A ram block cannot be removed without briefly pressurizing the machine. How is this kept from becoming ordinary exposed servicing under power?
4. The safety PLC reports its output OFF but the EDM contact remains wrong. Which claim is valid: commanded safe state or final-element proof?
5. An E-stop has been reset and all guards are closed. Why should a separate production START still exist?
6. A maintenance jumper is listed on yesterday's handoff sheet but cannot be found. Is absence from sight evidence that it was removed? What state should the machine remain in?
7. A LinuxCNC machine has no safety-rated controller but its HAL logic stops motion reliably in testing. Why does this not establish personnel-safety authority?

## Fresh-AI handoff scenario

A technician replaced an interlock, temporarily jumpered one input for diagnosis, changed a drive parameter, used a mechanical block under a gravity-loaded axis, and rebooted LinuxCNC. The axis jogs correctly and the HMI shows no faults. Determine whether production release is justified and identify the evidence gates in the correct order.

Expected reasoning boundary (not a hidden answer key): the learner must use the worksheet to identify temporary-state reconciliation, baseline/change-impact review, physical safeguard restoration, gravity/block transition, final-element/feedback proof, safety reset/rearm separation, personnel clearance and explicit production release. `HMI green` alone cannot close these gates.

## Next evidence work

Apply this worksheet to at least one complete professional machine drawing/manual set and record which cells can be closed from authoritative evidence versus which remain machine-specific `UNKNOWN`. Prefer a modern press brake if complete electrical + hydraulic + safety-controller documentation is available; otherwise use another complete machine implementation rather than inventing missing press-brake detail.
