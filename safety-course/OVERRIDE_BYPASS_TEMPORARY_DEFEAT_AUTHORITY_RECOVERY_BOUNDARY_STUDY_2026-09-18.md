# Override / bypass / temporary-defeat authority and recovery boundary study — 2026-09-18

## Purpose

Independent Lane-B study of a practical maintenance/commissioning hazard: a safety function that is intentionally overridden, muted, bypassed, inhibited, or temporarily defeated to recover material or diagnose equipment.

This is deliberately independent of the primary lane's current gravity-axis brake-proof/recovery work and the previous Lane-B EDM wiring study.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly supported by cited manufacturer material.
- **DOC-CONFIRMED** — repository/document behavior directly stated by an authoritative document.
- **TEST-CONFIRMED** — demonstrated by a controlled test. None in this study.
- **COMMUNITY-REPORTED** — community observation not independently verified. None relied upon here.
- **INFERENCE** — engineering conclusion derived from cited evidence; not a machine-specific fact.
- **UNKNOWN** — requires the actual machine design, validation, or measurement.

## Authoritative evidence

### SICK Flexi Soft override behavior

**SOURCE-CONFIRMED:** SICK Flexi Soft Safety Designer operating instructions describe Override as a means to release a muting function after a power failure, E-stop, muting error, or similar event leaves material in a protective field. The manual warns that the protective device can be indicating a dangerous state while Override causes Release, and requires visual inspection of the hazardous area, nobody present, and prevention of access while Override is active. It also constrains activation to a deliberate input sequence and limits override cycles.

Source: SICK, *Flexi Soft in the Safety Designer*, operating instructions, section “Override input”: https://cdn.sick.com/media/docs/3/83/083/operating_instructions_flexi_soft_in_the_safety_designer_configuration_software_en_im0081083.pdf

### SICK Flexi Classic muting override

**SOURCE-CONFIRMED:** SICK Flexi Classic Muting describes Override as manual initiation of muting after a muting-condition error. It requires the override control to be located where the operator has a clear view of the entire hazardous area, requires checking the muting components, and calls for examination/verification when repeated successive cycles require Override.

Source: SICK, *Flexi Classic Muting Modular Safety Controller*, section 5.5 Override: https://www.sick.com/media/docs/6/26/926/Operating_instructions_Flexi_Classic_Muting_Modular_safety_controller_en_IM0026926.PDF

### GuardLogix safety-application integrity

**SOURCE-CONFIRMED:** Rockwell GuardLogix documentation separates safety application state from standard control, supports safety locking/signatures, and describes the safety signature as identifying validated safety-application memory/execution characteristics. This is evidence that modification/commissioning authority over safety logic is a distinct lifecycle concern, not an ordinary HMI permission.

Sources:
- https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-add-on-instructions.html
- https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/create-a-controller-project/project-configuration-for-safety-controllers/passwords-for-safety-locking-and-unlocking.html

## Boundary freeze

**INFERENCE:** The curriculum must not collapse these states:

**SAFEGUARD HEALTHY != OVERRIDE REQUESTED != OVERRIDE AUTHORIZED != OVERRIDE ACTIVE != HAZARD ABSENT != RECOVERY COMPLETE != SAFETY FUNCTION RESTORED != VALIDATION RESTORED != ORDINARY START AUTHORITY.**

A temporary defeat is not simply another operating mode bit. It is a controlled reduction/change of protection that needs explicit entry conditions, bounded authority, conspicuous state, an exit path, and proof that normal protection has returned.

## Architecture rules for OpenPressBrake teaching

1. **Safety authority owns safety defeat.** **INFERENCE:** LinuxCNC/HAL/ordinary FPGA may request or display an override where the validated architecture permits it, but must not be the sole authority that bypasses a personnel-protective safety function.
2. **Recovery purpose is narrow.** **SOURCE-CONFIRMED/INFERENCE:** Manufacturer override examples are for clearing a defined abnormal condition, not converting a safeguard into a convenient production-disable switch.
3. **Visibility/access assumptions are part of the function.** **SOURCE-CONFIRMED:** The cited SICK instructions explicitly depend on visual inspection/clear view and preventing personnel access. If the real machine cannot satisfy those assumptions, that particular pattern cannot simply be copied.
4. **Override indication is not hazard proof.** **INFERENCE:** An HMI `OVERRIDE ACTIVE` indication proves at most a logical state. It does not prove personnel clear, pressure removed, gravity load retained, contactors open, STO effective, or other final-element state.
5. **Power cycle must not silently preserve defeat authority.** **INFERENCE:** After power restoration or controller restart, stale ordinary-control state must not recreate an override without the validated safety-side conditions and fresh deliberate action.
6. **Return to normal requires proof, not just bit clearing.** **INFERENCE:** Clearing an override request is not equivalent to proving the safeguard, safety inputs, final elements, and required feedback are healthy again.
7. **Repeated override demand is diagnostic evidence.** **SOURCE-CONFIRMED:** SICK explicitly calls for examination/verification after repeated successive override need. The curriculum should treat repeated defeat requests as a fault/maintenance signal rather than normalize them.
8. **Safety-logic modification is a separate lifecycle event.** **SOURCE-CONFIRMED/INFERENCE:** GuardLogix safety locking/signatures support teaching that changing safety logic/configuration is distinct from invoking a designed operational recovery function and should trigger the appropriate revalidation/change-control process.

## Failure-path worksheet

| Challenge | Dangerous false assumption | Required question/evidence |
|---|---|---|
| Override input stuck/shorted active | override cannot persist accidentally | Does the selected safety function require a transition, timeout, cycle limit, or other diagnostic? |
| HMI/PLC ordinary bit remains true after reset | software state may safely re-authorize defeat | Which independent safety-side conditions must be newly satisfied? |
| Operator cannot see full hazard zone | visual check is still adequate | Is the override pattern valid at all, or is another safeguarding/recovery method required? |
| Person enters while override active | clear-at-entry remains clear | What prevents access during the reduced-protection interval? |
| Guard/light curtain returns healthy | hazard is therefore absent | Which physical energy/final-element witnesses are separately required? |
| Maintenance jumper left installed | production restart will expose it | Is defeat physically/key controlled, supervised, indicated, logged, time/cycle bounded, or caught by return-to-service checks? |
| Repeated recovery cycles | nuisance behavior can be normalized | What fault investigation threshold does the manufacturer/application require? |
| Safety program edited to “temporarily” bypass logic | same as designed override | Was validated safety logic changed, signature/lock affected, and revalidation required? |
| Override cleared but feedback stale | normal protection is restored | What fresh input/final-element/EDM evidence is required before safety release? |
| Ordinary START already asserted | release may immediately move | Does restoration require a fresh separate start/rearm sequence? |

## Minimum-safe-to-operate gate

**INFERENCE:** If a personnel-protective function is defeated and the implementation cannot demonstrate the required restricted recovery conditions, prevent access, and prove restoration of the normal safety chain, the machine is not in a normal minimum-safe-to-operate state. Experimental troubleshooting should instead control the hazard by isolation/restraint or remote exclusion appropriate to the actual hazard.

## OpenPressBrake UNKNOWNs

Do **not** infer from this study:

- which safeguards, if any, OpenPressBrake will permit to be muted/overridden;
- key-switch/enabling-device topology;
- required hold-to-run behavior;
- maximum override time or cycle count;
- safe speed, stopping distance, pressure, force, or hydraulic state;
- PL/SIL/category/DC claims;
- actual safety controller or safety I/O;
- whether a given recovery requires STO, contactors, hydraulic blocking/dumping, mechanical restraint, or another final element;
- machine-specific restart/rearm sequence.

These remain **UNKNOWN** until selected architecture and machine evidence exist.

## Verification plan (question-driven; no compute justified)

For each future designed defeat/recovery function, validate on the real safety implementation:

1. Can ordinary LinuxCNC/FPGA control alone cause the defeat? Expected architecture answer: no where personnel safety relies on it.
2. Can a stuck input, stale bit, power cycle, or communication recovery recreate defeat without fresh deliberate safety-side authorization?
3. Can a person enter or remain in the hazard area while the override assumptions say the area is clear?
4. Does releasing the override restore every required safeguard and final-element witness before safety authority returns?
5. Can an already-asserted ordinary motion command cause immediate motion when safety authority returns?
6. Are temporary jumpers/configuration changes unmistakable and caught before return to service?
7. Does repeated override use trigger investigation rather than becoming routine production behavior?

No simulation, synthesis, benchmark, or executable test is justified by the present documentation question. Future executable verification, if needed, must run only on `[self-hosted, openpressbrake]`.

## Precise next independent work

Find a complete professional implementation that exposes:

**abnormal condition -> override required -> deliberate safety-side authorization -> restricted hazardous-area conditions -> temporary final-element release -> abnormal condition cleared -> safeguard re-proved -> safety release -> separate ordinary START**

and trace what happens for a stuck override input, power cycle during override, repeated override requests, and failure to restore the safeguard. Prefer a manufacturer application schematic/manual that shows physical inputs and safety outputs, not only function-block prose.
