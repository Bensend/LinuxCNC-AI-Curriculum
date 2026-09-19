# Emergency-Stop Span of Control, Reset, and Restart Authority Study

Date: 2026-09-19
Active level: 4000 safety course / professional machine implementation
Lane: independent Lane B

## Why this branch

The primary safety lane is currently tracing press-brake post-replacement hydraulic testing/restraint proof. This study deliberately uses a different evidence package and files: emergency-stop scope, local reset, and restart authority. It does not infer hydraulic behavior or alter the primary lane's artifacts.

## Question

What should a fresh AI keep separate when an emergency-stop device acts on a machine or multi-machine system, and what does resetting the actuated device actually authorize?

## Evidence

### E1 — emergency stop is a complementary protective measure, not proof that all hazardous energy is absent

**DOC-CONFIRMED.** Pilz's current ISO 13850 guidance states that an emergency-stop command latches and must remain latched until manual release. It also explicitly distinguishes emergency stop from emergency switching-off: emergency stop need not remove power from the complete machine.

Source: Pilz, `Emergency stop device halts a hazardous movement – EN ISO 13850`, current manufacturer standards guidance consulted 2026-09-19.

Curriculum consequence:

`E-STOP ACTIVE != ALL MACHINE POWER REMOVED != STORED ENERGY CONTROLLED != SAFE FOR SERVICE`.

Emergency stop can be an essential safety function while still being the wrong evidence for maintenance isolation or zero-energy claims.

### E2 — reset belongs at the device that initiated the emergency-stop command

**DOC-CONFIRMED.** Pilz's ISO 13850 FAQ for a plant consisting of multiple individual machines states that reset may only occur directly at the emergency-stop device that initiated the command and by intentional human action. The device should be reset only after the hazard that caused the emergency-stop action has been safely removed.

Source: Pilz, `Emergency stop is operated on a machine`, current standards FAQ consulted 2026-09-19.

This is especially important for distributed LinuxCNC/OpenPressBrake architectures. A supervisory HMI acknowledgement, LinuxCNC MACHINE ON bit, FPGA communication recovery, or remote PLC state must not silently impersonate the intentional local release/reset required by the credited emergency-stop architecture.

### E3 — reset prepares restart; reset is not restart

**DOC-CONFIRMED.** The same Pilz guidance states that resetting the actuated emergency-stop device must not automatically restart the machine; it only prepares the machine for restart. Actual start requires deliberate actuation of a control intended for that purpose.

Rockwell's current GuardLogix ESTOP instruction documentation independently exposes this separation at implementation level: manual reset requires the dual inputs to return to their active state and then a separate circuit-reset transition. It also detects a circuit-reset input that was already held when the channels recover. Rockwell warns that when automatic circuit reset is used, other measures are required to prevent unexpected or unintended start.

Sources:
- Pilz, `Emergency stop is operated on a machine`, consulted 2026-09-19.
- Rockwell Automation, `Emergency Stop (ESTOP)` / Studio 5000 Logix Designer safety instruction documentation, current page consulted 2026-09-19.

### E4 — reset location and visibility are part of the architecture, not an HMI convenience

**DOC-CONFIRMED.** Pilz notes that if the emergency-stop device location does not allow the affected operating range to be checked completely, additional restart/reset controls may be required and the machine risk assessment must address this. SICK's machinery safety guide independently states that after a protective-device stop, the stopped state is maintained until manual reset and subsequent restart; reset is permitted only when safety functions/protective devices are functional.

Sources:
- Pilz ISO 13850 FAQ above.
- SICK, `Safety Guide for the Americas`, reset/restart section.

This supports a practical design rule: the person restoring safety authority must not be forced to rely on an ordinary LinuxCNC screen indication as the sole evidence that the affected hazard area is clear.

## Durable authority ladder

Keep these states separate:

`emergency condition detected`
`-> E-stop device actuated/latched`
`-> safety function commands its defined stop reaction`
`-> affected final elements reach their required state`
`-> physical hazardous motion/condition reaches the machine-specific required state`
`-> initiating hazard corrected`
`-> actuated E-stop device intentionally released/reset`
`-> any required safety reset/rearm completed`
`-> machine eligible to accept a fresh ordinary start`
`-> deliberate fresh START/CYCLE/JOG command`
`-> production motion`

The exact final-element reaction and physical safe-state witness are machine specific.

## New freezes

**E-STOP PRESSED != ALL ENERGY ISOLATED != STORED ENERGY CONTROLLED != SAFE TO SERVICE.**

**E-STOP DEVICE RELEASED != SAFETY RESET COMPLETE != FINAL ELEMENT PROVED != HAZARD AREA CLEAR != PRODUCTION AUTHORITY.**

**SAFETY RESET ACCEPTED != ORDINARY START.**

**REMOTE HMI ACKNOWLEDGEMENT != INTENTIONAL RESET AT THE DEVICE THAT INITIATED THE E-STOP COMMAND.**

**LINUXCNC MACHINE ON / READY != PERSONNEL-SAFETY AUTHORITY.** LinuxCNC/HAL/ordinary FPGA may display or consume E-stop status and permissives, but credited personnel-safety authority remains in the independent safety architecture.

## Failure-path / commissioning worksheet

For a real implementation, deliberately challenge these questions without inventing machine-specific timings:

1. Actuate each E-stop device individually. Record exactly which hazards/final elements its credited safety function affects.
2. Verify that the actuated device remains latched until intentional release.
3. Attempt supervisory/HMI acknowledgement while the initiating device remains actuated. It must not be misrepresented as physical device reset.
4. Release/reset the device while an ordinary START/CYCLE/JOG request is stale or held. Verify that restoration of safety authority does not convert stale intent into fresh hazardous motion.
5. Power-cycle ordinary LinuxCNC/FPGA control while the E-stop is active; verify ordinary-controller recovery cannot defeat the independent safety state.
6. Restore the E-stop device with the affected area not demonstrably clear. Identify what independent architecture prevents unintended restart; if none is evidenced, mark UNKNOWN rather than assuming operator visibility.
7. Inject one-channel disagreement where the chosen dual-channel evaluator supports diagnostic testing. Verify disagreement prevents safety output restoration and requires the documented correction/reset path.
8. Where multiple E-stop devices or machine sections exist, trace the actual span of control for each device. Do not infer that every red mushroom stops every hazard, or that one reset location is valid for every zone.
9. Verify the physical final-element/hazard witness appropriate to the machine. Contactor/valve/STO command bits alone are not proof of the physical result.
10. After safety rearm, require the application's documented fresh production initiation rather than allowing reset to serve as START.

## Provenance labels

- **DOC-CONFIRMED:** manufacturer/standards guidance above establishes latch/reset/restart separation and the complementary-protection boundary.
- **SOURCE-CONFIRMED:** not claimed here; no source-code behavior was needed for the architecture question.
- **TEST-CONFIRMED:** none; no physical OpenPressBrake E-stop system was exercised in this study.
- **COMMUNITY-REPORTED:** none used as authority.
- **INFERENCE:** stale LinuxCNC ordinary motion intent should not become fresh intent when independent safety authority returns; this follows the existing curriculum restart-integrity rule but still requires application implementation/validation.
- **UNKNOWN:** OpenPressBrake E-stop device count, span(s) of control, final elements, stop category, reset locations, physical-safe-state criteria, stopping performance, hydraulic response, PL/SIL/category/DC/CCF, and exact restart sequence.

## No-compute decision

No simulation or executable verification can answer the unresolved physical/machine-specific questions in this branch. No GitHub Actions job is justified. If a later executable question arises, it must use only the self-hosted `[self-hosted, openpressbrake]` runner.

## Exact next Lane-B checkpoint

Find a professional multi-zone or multi-machine implementation that exposes the full chain:

`specific E-stop device -> documented span of control -> independent safety evaluator -> actual final elements -> physical stop/safe-state witness -> local release/reset of the initiating device -> area-clear/restart interlock where required -> safety rearm -> separate fresh ordinary START`.

Prefer evidence that deliberately tests a device outside the selected zone, a held/stale START during reset, or a one-channel E-stop fault. Keep zone boundaries and machine-specific stop behavior UNKNOWN until directly documented or tested.