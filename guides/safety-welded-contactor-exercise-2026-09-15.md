# Safety Exercise — Welded Contactor / Failed External Device

Session start: **2026-09-15T15:36:51Z**.

## Purpose

Teach the difference between a safety command, the physical safe state, external-device feedback, reset, restart authorization, and LinuxCNC diagnostics. This exercise deliberately does **not** ask the learner to infer Category, PL or SIL from a generic topology.

## Evidence basis

- **DOC-CONFIRMED:** Pilz PNOZ s4 supports monitored manual start/restart and a feedback loop using external switching elements K5/K6. The manufacturer's current document index identifies operating manual revision 21396-23 dated 2026-06-22.
- **SOURCE-CONFIRMED:** the inspected XYYZ LinuxCNC router configuration sends `iocontrol.0.user-request-enable` to a Mesa SSR output used by the project as part of its safety-relay reset arrangement, while the returned safety state participates in `iocontrol.0.emc-enable-in`.
- **UNKNOWN:** the public XYYZ repository does not prove its cabinet wiring, selected PNOZ mode, EDM wiring, or servo STO/contactors. Therefore this exercise uses a generic application rather than claiming to reproduce that machine.

## Scenario

A machine has hazardous motion powered through external switching devices K1 and K2. A safety relay supervises the protective inputs and commands K1/K2 OFF. Auxiliary positively guided/mirror feedback contacts are wired into the safety relay's external-device-monitoring/feedback loop. LinuxCNC receives a separate safety-status witness for coordination and diagnostics. LinuxCNC may issue an ordinary reset **request**, but the safety device owns acceptance of reset/rearm.

During a demand, K1's main power contacts weld closed. K2 opens normally.

## Learner task

Work in this order:

1. Identify the hazardous energy that K1 can still pass while welded.
2. State the required **physical safe state**. Do not answer only with a software state such as `ESTOP`.
3. Explain what K2, drive STO, a dump valve, brake, or another independent energy-control element would have to do for the hazard to actually reach the required safe state. Do not assume such an element exists unless specified.
4. Explain how the K1 feedback contact should differ from its expected OFF-state feedback when K1 is welded.
5. Explain why a correctly implemented feedback/EDM loop should inhibit rearm while K1 feedback is inconsistent.
6. State what LinuxCNC may display or inhibit when the external safety system is not ready, and explain why this visibility is not the safety function itself.
7. Describe reset behavior after the E-stop/guard is restored while K1 remains welded.
8. Describe a physical commissioning/validation test that demonstrates the fault is detected **before hazardous restart**.
9. State the residual risk if K1 is the only element interrupting the hazardous energy.
10. State what additional evidence would be required before claiming a Category, PL or SIL.

## Scoring — 20 points

- **4 — physical hazard/safe state:** identifies actual hazardous energy and names a physical safe state rather than `LinuxCNC in E-stop`.
- **4 — fault containment:** recognizes that welded K1 may continue passing energy and does not assume the command to open equals achieved isolation; correctly reasons about any specified independent element.
- **4 — feedback/rearm:** explains the external-device feedback mismatch and that the safety device must refuse rearm/reset completion while the mismatch persists.
- **3 — authority boundary:** keeps LinuxCNC request/status/diagnostics separate from safety authorization.
- **3 — validation:** proposes a deliberate fault-insertion or equivalent manufacturer-approved validation that proves the mismatch prevents hazardous restart; includes restoration/retest after the fault.
- **2 — claim discipline:** refuses to assign Category/PL/SIL without device architecture, application assumptions, failure data/calculation and validation evidence.

### Critical-fail conditions

A response cannot pass if it claims any of the following without application-specific evidence:

- LinuxCNC E-stop state proves hazardous energy is removed;
- a safety relay output command proves the downstream contactor physically opened;
- resetting the software is sufficient to reauthorize motion despite failed EDM;
- two channels automatically establish PL e / Category 4;
- STO necessarily prevents gravity, hydraulic, pneumatic or stored-energy motion.

## Reference answer contract

A strong answer says, in substance:

`protective demand -> safety logic removes output authorization -> external energy-control elements must reach the physical safe state -> feedback proves their expected state -> mismatch blocks rearm -> LinuxCNC reports/coordinates but does not override -> deliberate reset is accepted only after prerequisites are healthy -> validation injects the relevant fault and proves restart remains inhibited`.

If K1 is the sole physical interruption path and remains welded, the required safe state may not be achieved. The machine should not be operated with people exposed to that hazard. Experimental diagnosis must keep people outside the danger zone and use isolation/remote methods appropriate to the machine.

## Human-factors requirement

The diagnostic should identify the failed prerequisite (for example, `K1/contactor feedback mismatch`) rather than merely showing `E-stop`. Recovery should be straightforward after repair, but there must be no convenient bypass that turns an EDM mismatch into an operator-resettable nuisance fault.

## Next extension

Repeat the exercise with distinct machine physics: vertical/gravity axis, spindle, hydraulic ram, plasma/laser process source, and robot/cell access. For each, redefine the physical safe state before discussing circuit topology.
