# SICK sBot Speed stand-behind restart acceptance sequence

Date: 2026-09-20
Course: 4000 safety / accessible-cell validation

## Why this matters

The prior scanner work had manufacturer evidence for restart interlock, reset location and physical field-boundary testing, but the combined retained-person/stand-behind challenge remained inference. A SICK complete safety-system manual now supplies a much closer acceptance sequence.

## Manufacturer acceptance evidence

**DOC-CONFIRMED** — SICK `sBot Speed CIP – KU` operating instructions (8024758, indexed current publication) contain an annex test table with a concrete sequence:

1. start the robot in Automated mode;
2. interrupt protective field PF1;
3. interrupt PF2;
4. stand behind the protective fields **or** approve PF1 and PF2 simultaneously;
5. expected result: robot stops, and restart is possible only when all protective fields are free and the reset pushbutton has been actuated.

The same test table separately requires reading the current field sets from the scanner, determining the distance between PF1 and PF2 at the transition into the hazardous area, and checking the protective-field dimensions/required overlap.

Source: SICK, *sBot Speed CIP – KU*, operating instructions 8024758, annex/test sequence.

This is stronger than generic component guidance because it is a manufacturer-provided acceptance sequence for an integrated safety system and explicitly contains the previously sought **stand-behind** action.

## Supporting complete-system checklist evidence

**DOC-CONFIRMED** — SICK `sBot Stop` operating instructions include a manufacturer checklist requiring, among other things:

- no entry into the hazardous area without interrupting the primary protective field;
- no ability to walk behind the safety laser scanner protective field;
- assurance that no people are in the hazardous area during or after reset;
- protective devices installed so they cannot be stood behind, bypassed or crawled beneath;
- anti-manipulation measures.

Source: SICK, *sBot Stop*, operating instructions 8023421/12KF/2019-01-22, manufacturer checklist.

## New freeze

**ACCESS FIELD INTERRUPTED != RETAINED PERSON DETECTED.**

**PROTECTIVE FIELDS LATER CLEAR != RESTART AUTHORIZED WHILE THE ACCEPTANCE CONDITIONS ARE UNSATISFIED.**

**CONFIGURED FIELD OVERLAP != PHYSICAL OVERLAP VERIFIED AT THE HAZARDOUS-AREA TRANSITION.**

**RESET PUSHBUTTON ACTUATED != PROTECTIVE FIELDS FREE != PERSONNEL-CLEAR PROVED BY A DIFFERENT ARCHITECTURE.**

**SCANNER ACCEPTANCE PASS != OPENPRESSBRAKE SAFETY ARCHITECTURE VALIDATED.**

## Important interpretation boundary

The sBot Speed sequence is application-specific robot safety-system evidence. It demonstrates that deliberate stand-behind behavior belongs in a real manufacturer acceptance test; it does **not** license copying the sBot geometry, reset logic, field arrangement, safety performance level, timing, robot safe functions or acceptance parameters into another machine.

The phrase in the acceptance table that restart is possible only when all protective fields are free and reset has been actuated must not be overread as proof that a scanner alone establishes personnel-clear in arbitrary cells. The companion sBot Stop checklist instead reinforces that the physical architecture must prevent/monitor stand-behind and ensure people are absent during/after reset.

## Status of the earlier derived adversarial script

The following portions are now directly manufacturer-supported rather than merely inferred:

- deliberate protective-field interruption;
- deliberate stand-behind action in an integrated acceptance sequence;
- observing actual robot stop;
- requiring protective fields free before restart;
- requiring reset before restart;
- checking physical field overlap/dimensions.

Still **UNKNOWN / INFERENCE** as one combined manufacturer script:

- leave a person/test body deliberately hidden in an interior blind area that the safety architecture claims to monitor by some other means;
- deliberately hold an ordinary motion/start command active across the safety trip/reset;
- prove that stale ordinary command cannot cause hazardous motion after safety reset;
- require a new edge/fresh ordinary production start and observe the final element.

Those stale-command/fresh-start elements remain supported by separate reset/restart evidence elsewhere in the curriculum but are not present in this sBot acceptance table.

## Curriculum consequence

Accessible-cell validation should teach two distinct challenges:

1. **geometry/presence challenge** — deliberately enter, traverse and attempt to stand behind/bypass the sensing arrangement while verifying the intended safety response;
2. **restart-authority challenge** — after the protective demand, verify the required clear/reset conditions and separately validate the machine's ordinary restart behavior.

Do not collapse them into a single `scanner clear = safe` condition.

## Human-factors consequence

A design that permits a worker to step through an access field and disappear into an unmonitored interior location is not repaired by a warning label. Prefer continuous interior presence monitoring, geometry that prevents stand-behind, trapped-key/personnel-retention mechanisms where appropriate, or another engineered measure selected by the machine risk assessment. Reset placement and visibility should make correct clearance verification practical rather than burdensome.

## Compute

No simulation/build/test compute was justified. No GitHub-hosted runner or self-hosted runner was used.

## Information-gain decision / next branch

The narrow scanner stand-behind acceptance gap is now materially improved and generic scanner searching should stop. The remaining stale-command/fresh-start portion is already a cross-cutting restart-authority topic rather than a scanner-specific source gap.

Next high-value safety work should rotate to a different physical evidence gap: trace a complete **guard-lock escape/release recovery and retained-person restart** acceptance sequence if current Lane-B work has not already closed it; otherwise select a different protective-device/final-element family with an unresolved physical witness rather than duplicating scanner evidence.
