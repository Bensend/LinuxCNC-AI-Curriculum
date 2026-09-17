# Safety Contractor, Visitor, and Temporary-Personnel Interface Card

Status: curriculum architecture / field-use worksheet. Machine-specific values remain UNKNOWN until supported by installed evidence.

## Frozen principle

**Presence, badge access, a login, a key, contractor status, training attendance, or permission to enter a work area does not by itself establish authorization or competence to isolate energy, defeat a safeguard, reset a safety function, rearm ordinary control, release a machine to service, or start hazardous motion.**

The host/contractor/personnel interface must make responsibility explicit while preserving physical hazardous-energy control and the independence of personnel-safety functions from ordinary LinuxCNC/HAL/FPGA control.

## Evidence labels

Use only: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

Do not promote a policy, badge list, HMI state, LinuxCNC bit, FPGA command, or contractor statement into proof of physical isolation or safety-function performance.

## Regulatory anchors — bounded to their actual scope

### OSHA 29 CFR 1910.147(f)(2) — outside personnel

`SOURCE-CONFIRMED`: When outside servicing personnel perform work covered by 1910.147, the on-site employer and outside employer must inform each other of their respective lockout/tagout procedures. The on-site employer must ensure its employees understand and comply with restrictions/prohibitions of the outside employer's energy-control program.

Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

This is a LOTO requirement. It is not evidence that every contractor interaction is governed solely by 1910.147, nor does it establish machine-specific functional-safety performance.

### OSHA 29 CFR 1910.147(f)(3) — group work

`SOURCE-CONFIRMED`: Group LOTO must provide protection equivalent to personal LOTO; responsibility and exposure status must be controlled, and when multiple crews/groups are involved an authorized employee is designated to coordinate affected workforces and continuity of protection. Each authorized employee applies/removes a personal device in the group mechanism as work begins/ends.

Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

### OSHA 29 CFR 1910.147(f)(4) — shift/personnel change

`SOURCE-CONFIRMED`: Specific procedures are required to maintain continuity of LOTO protection through shift/personnel changes, including orderly transfer between off-going and oncoming employees.

Sources:
- https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147
- https://www.osha.gov/etools/lockout-tagout/tutorial/shift-personnel-changes

### OSHA 29 CFR 1910.147(c)(7) — training/communication

`SOURCE-CONFIRMED`: Authorized, affected, and other employees have different energy-control training/communication obligations. Authorized employees require knowledge and skills for energy isolation/control; affected employees require instruction in purpose/use; other employees in the area must understand the procedure and prohibition on restart/reenergization of locked/tagged equipment.

Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

## Pre-work interface card

Complete before outside or temporary personnel enter a machine hazard/service boundary.

| Item | Record / evidence | Status |
|---|---|---|
| Machine / asset identity |  | UNKNOWN |
| Work scope and physical boundary |  | UNKNOWN |
| Host responsible person |  | UNKNOWN |
| Outside-employer responsible person |  | UNKNOWN |
| Personnel performing covered servicing |  | UNKNOWN |
| Personnel merely affected / observing |  | UNKNOWN |
| Visitor exclusion boundary |  | UNKNOWN |
| Host energy-control procedure ID/revision |  | UNKNOWN |
| Contractor energy-control procedure ID/revision |  | UNKNOWN |
| Procedure exchange completed |  | UNKNOWN |
| Conflicts between procedures identified/resolved |  | UNKNOWN |
| Electrical isolation points | installed evidence required | UNKNOWN |
| Hydraulic isolation / stored-energy controls | installed evidence required | UNKNOWN |
| Pneumatic isolation / stored-energy controls | installed evidence required | UNKNOWN |
| Gravity / elevated-member blocking or restraint | installed evidence required | UNKNOWN |
| Other stored/mechanical energy | installed evidence required | UNKNOWN |
| Isolation verification method | task/machine specific | UNKNOWN |
| Group LOTO coordination needed? |  | UNKNOWN |
| Shift/personnel transfer method needed? |  | UNKNOWN |
| Energized testing/positioning needed? | separate controlled procedure | UNKNOWN |
| Safeguard defeat/override needed? | separate authorization + restoration control | UNKNOWN |
| Safety reset authority | named role, not merely HMI access | UNKNOWN |
| Ordinary LinuxCNC/HAL/FPGA rearm authority | named role | UNKNOWN |
| Return-to-service release authority | named role | UNKNOWN |
| START authority after release | named role | UNKNOWN |

## Role boundary

### Authorized servicing personnel

Authorization must match the task. A person qualified to edit HAL or FPGA firmware is not thereby authorized to perform LOTO, alter a safety-controller configuration, defeat an interlock, work on hydraulic stored energy, or release the machine after safety work.

### Affected personnel

Affected personnel must know that servicing/energy control is active and must not attempt restart/reenergization. Being an experienced operator does not convert affected status into servicing authorization.

### Visitors / observers

A visitor or observer receives no safety authority from being escorted, badged, or allowed into the facility. Keep visitors outside the defined hazard/service boundary unless the actual risk-control plan specifically permits their presence. If their presence can expose them to hazardous energy or interfere with the work, treat that as a control problem rather than relying on verbal caution.

### Temporary personnel

Temporary status does not lower the competency requirement for the assigned task. Verify the person's task-specific role, applicable training/competence evidence, supervision, machine-specific briefing, and limits of authority. Do not infer competence from agency assignment, job title, prior machine experience, or possession of a key/password.

## Host / outside-employer exchange

Before covered servicing begins, explicitly reconcile:

1. Who owns each isolation and who verifies it.
2. Which energy sources each procedure recognizes.
3. How stored/reaccumulating energy is controlled.
4. How personal/group locks or tags are applied and transferred.
5. How multiple crews are coordinated.
6. Who may request temporary energization for test/positioning and how personnel are cleared before it occurs.
7. How the system returns to protected servicing after the test.
8. How shift/personnel changes preserve continuity.
9. Who can authorize safeguard defeat/override and who independently verifies restoration.
10. Who performs safety reset, ordinary-control rearm, return-to-service release, and subsequent START.

If procedures conflict, status is `UNKNOWN — WORK NOT CLEARED` until the conflict is resolved. Do not choose whichever procedure is more convenient in the field.

## Reset / rearm / release / START separation

Keep these transitions distinct:

`hazard physically controlled for work` -> `work complete` -> `safeguards/final elements restored and verified` -> `energy-control release per procedure` -> `independent safety reset when allowed` -> `ordinary LinuxCNC/FPGA rearm` -> `machine released to operation` -> `separate START command`

A reset must not silently become START. A LinuxCNC Machine-On command or FPGA enable is ordinary-control context and cannot substitute for personnel-safety authorization or physical final-element/energy-path evidence.

## Shift and personnel changes

Never allow a personnel change to create an unowned protection gap. Record:

- off-going authorized person(s);
- oncoming authorized person(s);
- transfer method;
- group-lockbox/control status where applicable;
- machine/work state at handoff;
- unresolved hazards or temporary configurations;
- installed blocks/restraints/isolation status;
- bypasses, jumpers, forces, overrides, test leads, or temporary wiring;
- configuration changes made during the prior shift;
- who now owns release and restoration.

A verbal statement such as "it is still locked out" is not a substitute for the required energy-control process or machine-specific verification.

## Safeguard defeat / temporary override

When a task genuinely requires temporary defeat or override, record it as an exceptional controlled state, not normal maintenance convenience. At minimum identify the device/function affected, reason, person authorizing, personnel protected, alternate physical controls, start/end state, and restoration verification.

`INFERENCE`: The safer architecture makes temporary states visible and difficult to leave behind. This supports human-factors robustness but does not by itself prove a safety performance level.

Never treat a keyed selector, password, software permission, hidden HMI page, FPGA bit, or LinuxCNC HAL signal as a replacement for the independent safety function or required hazardous-energy isolation.

## Release-to-service challenge

Before return to service, answer each independently:

- Are all personnel accounted for and safely positioned/removed as applicable?
- Are tools, test leads, temporary wiring, jumpers, forces, blocks used only for servicing, and loose materials reconciled?
- Are required guards/interlocks/protective devices physically restored?
- Are final elements and feedback paths restored to the documented installed configuration?
- Were configuration changes captured and subjected to the applicable revalidation scope?
- Were isolation devices removed/transferred only under the applicable procedure?
- Have affected personnel received required notification?
- Is safety reset allowed now?
- Is ordinary-control rearm allowed now?
- Has an identified person actually released the machine for operation?
- Does hazardous motion still require a separate deliberate START?

Any unsupported item remains `UNKNOWN`; do not convert UNKNOWN to PASS because production is waiting.

## Failure-path prompts

Challenge these cases during curriculum review:

- contractor procedure omits a host-recognized hydraulic accumulator or gravity hazard;
- host procedure assumes a contractor-controlled disconnect is isolated;
- two crews each believe the other owns the group lockbox/release;
- shift change occurs with a temporary jumper or software force still present;
- contractor finishes electrical work but a hydraulic/mechanical restraint remains altered;
- visitor crosses a boundary during an energized test;
- temporary worker has HMI access but not task authorization;
- contractor can reset the safety relay but host personnel still occupy the hazard area;
- safety reset succeeds while LinuxCNC retains a stale motion/output request;
- ordinary controller reports outputs OFF while physical final-element/energy state is unverified;
- production pressure causes an override key/password to be left available after service;
- the person who made a safety configuration change is absent at shift handoff and the installed revision is uncertain.

## OpenPressBrake application boundary

For OpenPressBrake, keep at least these authorities separate in teaching and implementation:

- independent personnel-safety system authority;
- hazardous electrical/hydraulic/mechanical energy isolation and restraint;
- ordinary LinuxCNC machine state;
- FPGA/watchdog/output authority;
- proportional/directional command state;
- safety reset;
- ordinary-control rearm;
- return-to-service release;
- subsequent START.

Exact press-brake hydraulic truth tables, stopping distances/times, pressure thresholds, safe-speed values, PL/SIL/DC claims, guard geometry, final-element arrangement, and installed isolation points remain `UNKNOWN` until machine-specific evidence establishes them.

## Completion record

| Field | Record |
|---|---|
| Host responsible person |  |
| Outside-employer responsible person |  |
| Work completed |  |
| Temporary conditions reconciled |  |
| Configuration identity after work |  |
| Physical restoration evidence |  |
| Functional challenge evidence |  |
| Energy-control release completed |  |
| Safety reset owner |  |
| Ordinary rearm owner |  |
| Return-to-service release owner |  |
| Outstanding UNKNOWN items |  |

## Next independent study

Build `SAFETY_SAFEGUARD_DEFEAT_KEY_OVERRIDE_ACCESS_REGISTER.md`: control issuance/recovery of safeguard keys, override tools, passwords and service credentials; bind each use to a named purpose/time/restoration check; distinguish access control from safety authority; and analyze loss, duplication, shared credentials, abandoned overrides, and production-pressure failure paths. Do not invent machine-specific override modes or permissible safety values.