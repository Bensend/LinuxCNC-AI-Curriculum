# Maintenance restart prevention vs hazardous-energy isolation boundary study

Date: 2026-09-19
Lane: independent safety curriculum Lane B

## Why this lane

The primary safety lane is currently advancing press-brake tool-setup muting and safely monitored reduced-speed authority. This study deliberately uses different evidence and files. It addresses a neighboring maintenance architecture question that must not be conflated with setup mode: when does a personnel-retention/restart-prevention system provide valid protection, and when is physical hazardous-energy isolation still required?

## Evidence classification

### Pilz Key-in-pocket — personnel retention / restart prevention

**DOC-CONFIRMED.** Pilz documents its Key-in-pocket maintenance safeguarding as protection against unauthorized/unplanned restart while people remain in a danger zone. Each entering person authenticates with a personal RFID transponder; the person's security ID is retained in a safe list in the safety controller, and the person keeps the transponder while inside. Productive mode is not released until all people have exited and signed out and the safe list is empty.

**DOC-CONFIRMED.** Pilz also documents a blind-spot check for large installations without full visibility before restart. This is useful evidence that `SAFE LIST EMPTY` and `PERSONNEL CLEAR` are not automatically identical claims in every application.

**DOC-CONFIRMED.** Pilz describes Key-in-pocket as an electronic restart-protection solution and contrasts it with conventional LOTO. This is evidence about the documented Pilz application, not permission to substitute an electronic restart-prevention system for energy isolation wherever servicing exposes hazardous stored or supplied energy.

Sources:
- Pilz, “System release PSS 4000 1.25 – Key-in-pocket solution”, 2023-08-28.
- Pilz, “Access management for your plant and machinery”, Key-in-pocket maintenance safeguarding section.

### Pilz LOTO — physical hazardous-energy control

**DOC-CONFIRMED.** Pilz separately describes lockout/tagout as a method for controlling hazardous energy during repair and maintenance, explicitly including electrical, mechanical, hydraulic and other energy supplies. Its LOTO material describes isolation from energy supplies so unintended restart is excluded.

Source:
- Pilz, “Lockout/tagout system — Control hazardous energy safely”.

## Architecture boundary

The combined evidence supports keeping two different safety questions separate:

`PERSON IDENTIFIED/AUTHORIZED != PERSON SAFELY INSIDE`

`PERSON LOGGED INTO RETENTION LIST != HAZARDOUS ENERGY ISOLATED`

`SAFE LIST NONEMPTY -> RESTART INHIBITED` is a restart-prevention function, not proof that electrical, hydraulic, pneumatic, gravity, spring or other stored energy is absent.

`SAFE LIST EMPTY != BLIND AREA CLEAR != PHYSICAL ENERGY SAFE != PRODUCTION START AUTHORIZED`

`LOTO APPLIED != PERSONNEL RETENTION LIST EMPTY != MACHINE FUNCTIONALLY REVALIDATED`

A maintenance architecture can need more than one of these layers. Personnel-retention logic addresses unexpected restart while people remain within a safeguarded space. Physical energy isolation addresses exposure to energy that can injure a person even if ordinary machine commands are inhibited. Functional revalidation addresses whether safety functions and final elements are fit to return to service after the work.

## LinuxCNC / ordinary FPGA boundary

**INFERENCE.** LinuxCNC/HAL or an ordinary FPGA may display maintenance state, inhibit ordinary commands, record diagnostics, and consume a safety permissive. It must not be treated as the sole personnel-retention authority when that function is credited for bodily-entry protection, nor can a LinuxCNC `machine-off`, `estop`, `motion-disabled`, or stale-command state prove hazardous energy isolated.

A robust UI should expose these as distinct states rather than compressing them into one green `SAFE` lamp:

- ordinary machine control disabled;
- safety-side restart prevention active;
- personnel-retention list/status;
- physical energy isolation / service state where applicable;
- safety-function/final-element revalidation state;
- production restart authority.

## Failure-path analysis

Commissioning/validation should challenge at least these questions where the architecture uses the corresponding function:

1. One person signs in and enters; another person enters through another controlled access point. Does restart prevention retain every credited entrant rather than only the last transaction?
2. One person exits/signs out while another remains inside. Does restart remain inhibited?
3. The retained-person list becomes empty but a blind area has not been checked where such a check is required. Can production restart still be prevented until the separate personnel-clear condition is satisfied?
4. Safety-side restart prevention is active, but hydraulic pressure, gravity load, capacitor energy, spring energy or another hazardous source remains. Does the service procedure correctly require the applicable physical energy-control method rather than interpreting restart inhibition as zero energy?
5. Physical isolation is applied, but a retained-person or access state remains unresolved. Does restoration of energy avoid becoming automatic production authority?
6. LinuxCNC/HAL restarts, reconnects, or reports MACHINE ON while the independent restart-prevention function is active. Does ordinary control remain subordinate to the safety authority?
7. A transponder/credential is lost or an abnormal maintenance state is recovered. Is there a controlled recovery/recommissioning path rather than a bypass that silently clears personnel memory?
8. Service ends and energy is restored. Are affected safety functions/final elements re-proved as required before production authorization, instead of treating energy restoration as proof of machine safety?

## Human-factors lesson

A usable personnel-retention system can make the safer maintenance path easier by giving each entrant an explicit personal token and preventing restart until everyone is accounted for. But the operator-facing model must not imply that possession of a key/token makes stored energy harmless. Likewise, a LOTO state should not erase the separate question of whether people are clear and the safety system has been correctly recommissioned.

## Durable freeze

**RESTART PREVENTION != HAZARDOUS-ENERGY ISOLATION. PERSONNEL RETENTION != ZERO ENERGY. SAFE LIST EMPTY != PERSONNEL CLEAR != SAFETY FUNCTION REVALIDATED != PRODUCTION AUTHORITY. ORDINARY LINUXCNC/FPGA DISABLE != PERSONNEL-SAFETY AUTHORITY.**

Also preserve:

**ELECTRONIC MAINTENANCE SAFEGUARDING MAY BE A VALIDATED RESTART-PREVENTION FUNCTION IN ITS DOCUMENTED APPLICATION; THAT DOES NOT UNIVERSALLY REPLACE TASK-SPECIFIC PHYSICAL ENERGY ISOLATION.**

## OpenPressBrake unknowns

The following remain **UNKNOWN** and must not be invented:

- whether OpenPressBrake will use a retained-person/key-in-pocket architecture at all;
- which maintenance tasks require which electrical, hydraulic, gravity, pneumatic or mechanical isolation points;
- whether a particular task can be performed under a validated maintenance safeguarding mode rather than full isolation;
- actual accumulator/trapped-pressure behavior, discharge time or safe pressure;
- physical ram/blocking requirements;
- personnel-clear/blind-spot procedure;
- safety performance level/category/SIL/DC/CCF;
- post-service machine-specific proof and restart sequence.

## Compute decision

No simulation, synthesis or executable test would answer the unresolved physical/application questions in this study. No GitHub-hosted or self-hosted compute was used.

## Precise next-work checkpoint

Seek a professional maintenance implementation that exposes the complete boundary in one system:

`personnel entry/retention -> safety-side restart prevention -> task-specific physical energy isolation where required -> stored-energy verification -> maintenance -> controlled energy restoration -> retained-person/blind-area clear -> affected safety-function/final-element re-proof -> safety rearm -> separate fresh ordinary production initiation`.

Prefer evidence with an abnormal recovery case such as lost credential, incomplete sign-out, power cycle during maintenance, or attempted restart while one entrant remains retained. Keep this lane separate from the primary press-brake setup/muting/safe-speed work and from the unresolved hydraulic holding-valve service proof.