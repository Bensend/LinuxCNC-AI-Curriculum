# Whole-Body Access / Trapped-Person Restart Prevention

Session UTC: 2026-09-16

## Scope

This lesson covers safeguarded spaces large enough that a person can enter and remain inside after an access guard is reclosed. It is architecture guidance, not a machine-specific safety design. It does not establish scanner geometry, safety distance, stopping time, hydraulic state, required PL/SIL, or proof that any particular space is clear.

## Evidence ledger

### DOC-CONFIRMED — personal key/accounting can inhibit restart

Pilz documents its Key-in-pocket maintenance safeguarding for fenced hazardous areas. An authorized person authenticates at the gate, their security ID is stored in a safe list, and the person retains the personal transponder while inside. Multiple people can be signed in. Productive operation is not enabled until everyone has exited and signed out so the safe list is empty.

Pilz also states that for large plants without an overall view an additional blind-spot check is used: difficult-to-see areas are visually inspected before restart.

Sources:
- Pilz, Access management / Key-in-pocket: https://www.pilz.com/en-US/access-management
- Pilz, PSS 4000 Key-in-pocket system release: https://www.pilz.com/en-CA/company/news/articles/238605

### DOC-CONFIRMED — trapped-key architecture can sequence access from an isolated/released state

Rockwell 440T trapped-key documentation describes a solenoid release unit in which the key remains trapped until a release signal is applied and access interlocks that require the appropriate key before access. Rockwell also offers a stopped-motion unit intended to detect stopped mechanical motion before key-transfer/access sequencing.

These are examples of architecture, not proof that a particular trapped-key chain provides electrical/hydraulic/mechanical isolation for OpenPressBrake.

Sources:
- Rockwell Automation, 440T Trapped Key Solenoid Release Unit: https://www.rockwellautomation.com/en-us/products/hardware/safety-products/440t-solenoid-release-unit.html
- Rockwell Automation, 440T Access/Chains Trapped Key Interlock Switches: https://www.rockwellautomation.com/en-mde/products/hardware/safety-products/440t-access-and-chains.html
- Rockwell Automation, 440T Stopped Motion Unit: https://www.rockwellautomation.com/en-mde/products/hardware/safety-products/440t-stopped-motion-unit.html

### DOC-CONFIRMED — presence-sensing fields are configurable protective functions, not a generic `space_clear` bit

Rockwell SafeZone safety laser scanners use configurable warning/safety fields and configurable restart behavior. This supports teaching presence sensing as a separately configured and validated protective function. It does not justify inventing field geometry, resolution, response time, or safety distance for a machine.

Source:
- Rockwell Automation, 442L SafeZone Safety Laser Scanners: https://www.rockwellautomation.com/en-hu/products/hardware/safety-products/safezone-laser-scanners.html

## Architecture contract

Keep at least these states/evidence items distinct:

1. `access_guard_closed`
2. `access_guard_locked_if_required`
3. `hazardous_motion_or_energy_safe_for_access`
4. `personnel_inside_accounting` — e.g. personal-key/safe-list state where that architecture is used
5. `presence_detection_clear` — only where a validated presence-sensing function exists
6. `blind_spot_check_complete` — where the architecture requires a deliberate visual sweep
7. `escape_release_normal`
8. `safety_reset_requested`
9. `safety_reset_accepted`
10. `ordinary_controller_rearm`
11. `ordinary_start_request`
12. `hazardous_motion_actual`

`guard_closed` is never sufficient evidence for `space_clear` when whole-body access is possible.

## Core restart rule

Closing a gate must not silently manufacture evidence that the safeguarded space is empty. Restart eligibility must depend on the independent protective architecture selected for the actual hazard and access geometry. Examples may include personal-key/accounting, validated presence sensing, deliberate blind-spot inspection/reset procedures, trapped-key sequencing, or combinations justified by risk assessment.

A reset is acknowledgement/restoration of a safety function; it is not proof that nobody remains inside. An ordinary LinuxCNC `machine-on`, HAL enable, GUI acknowledgement, or FPGA watchdog recovery is not a substitute for personnel accounting or validated presence detection.

## Personal-key / safe-list semantics

When teaching a Key-in-pocket-style architecture:

- each entering person is individually accounted for;
- the retained personal key/transponder is not merely a login credential but part of restart-prevention state;
- one person's sign-out must not clear another person's presence record;
- a gate closing while the list remains nonempty must not enable production;
- loss, administrative deletion, or forced reset of the list is a safety-significant recovery path requiring its own controlled procedure;
- a software/HMI display of an empty list is not automatically an independent physical proof that the space is clear.

Do not generalize a particular manufacturer's certified implementation into an assertion that any RFID database or LinuxCNC userspace list is safety-rated.

## Trapped-key semantics

A trapped-key system can mechanically enforce a sequence, but the learner must identify what condition actually permits key release. A key-release lamp or command is not itself proof that every hazardous energy source is isolated. If key release depends on stopped-motion detection, isolation contacts, a timer, or another safety function, that dependency must be named and validated.

Never infer from `key_available=true` that hydraulic pressure is dissipated, gravity hazards are blocked, electrical energy is isolated, or the press ram is mechanically secured unless those claims are independently established by the actual architecture.

## Presence sensing and blind spots

A safety scanner, mat, or other presence-sensing device may help prevent restart while a person occupies a protected space, but its coverage is a physical design claim. The curriculum must require evidence for mounting, occlusion, reach/crawl paths, resolution, field configuration, response/stopping relationship, environmental limitations, configuration control and validation.

Where the space cannot be seen completely from the reset location, a blind-spot check can be a deliberate procedural/technical step. The check must not degrade into a meaningless button press. The human must be able to inspect the intended area, and the system must prevent the check from being trivially completed from a location that defeats its purpose.

## Reset location and visibility

A reset control should support deliberate confirmation of the safeguarded space rather than encourage blind reset. The curriculum evaluator should challenge designs where:

- reset is inside the hazard zone and can be used to strand another person;
- reset is outside but the operator cannot see relevant areas and no independent presence/accounting method addresses them;
- reset can be remotely issued by ordinary LinuxCNC/HMI/network commands without the validated safety architecture;
- a held reset signal becomes valid automatically when the last guard closes;
- closing the final gate is itself treated as reset/start.

## Escape and emergency egress

A person inside must not depend on LinuxCNC, the ordinary FPGA, network connectivity, or a normal production command merely to escape. Escape-release behavior belongs to the guard-locking safety architecture and must be validated with the actual hardware. After an escape release or abnormal egress event, restoration/rearm should be explicit; do not silently resume because the gate was subsequently reclosed.

## Maintenance versus production access

Whole-body access during servicing may also require hazardous-energy control/LOTO. Restart-prevention architecture does not automatically replace energy isolation. A system that prevents commanded restart can still leave stored hydraulic, pneumatic, electrical, gravitational, thermal or mechanical energy capable of harming a person.

Keep `restart_inhibited` separate from `energy_isolated_and_verified`.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC and the normal FPGA may display gate, key-list, scanner and reset diagnostics; inhibit ordinary commands; and refuse to arm when safety permission is absent. They may add restrictions. They must not be the sole personnel-safety authority that decides the space is clear or forges safety permission after communications recovery.

A stale `space_clear` packet, restored GUI state, rebooted HAL pin or watchdog recovery must default to no new hazardous-motion authority until the independent safety function is valid and the required reset/rearm sequence has occurred.

## Adversarial evaluator cases

1. **Person enters, coworker recloses gate:** guard-closed must not imply space-clear.
2. **Two people sign in, one signs out:** restart remains inhibited while the other is accounted inside.
3. **Lost personal key:** learner must not solve this by deleting the record and immediately starting; use a controlled exceptional recovery and re-establish clear-space evidence.
4. **Blind spot behind machine:** reset from the gate is insufficient if the selected architecture requires a blind-spot check and the area cannot be inspected.
5. **Scanner reports clear but a fixture occludes a crawl-space path:** coverage must be revalidated; do not infer clear space from an invalid field geometry.
6. **Gate closes while reset is held:** held reset must not become an automatic reset/start mechanism.
7. **LinuxCNC reconnects with old `space_clear=true`:** stale ordinary-controller data cannot create safety permission.
8. **Trapped key becomes available:** learner must identify what physical/safety condition authorized release rather than equating key availability with all-energy isolation.
9. **Escape release used:** reclosed gate does not erase the event; restoration and reset/rearm remain explicit.
10. **Maintenance worker inside under restart inhibition only:** learner must ask whether hazardous-energy isolation is also required for the task.
11. **Remote HMI reset from another room:** reject unless the actual validated architecture independently addresses visibility/presence/accounting; ordinary remote acknowledgement is not proof of an empty space.
12. **Safety controller reboot loses personnel list:** fail closed; do not assume an empty reconstructed list means no one is inside.
13. **Administrative key-list reset:** treat as exceptional safety-significant recovery, not normal production convenience.
14. **New tooling creates a hidden standing/crawl space:** previous clear-space validation is reopened under change control.

## Human-factors / defeat resistance

The safe access workflow should be easier than bypassing it. If workers routinely need to climb a fence because signing in is slow, share one key because there are too few personal keys, prop a gate because reset is badly located, or defeat a scanner because legitimate maintenance cannot be performed, treat that as an architecture/workflow defect. Improve the legitimate path while preserving independent safety authority.

## Provenance discipline

Use these labels exactly:

- `SOURCE-CONFIRMED` — directly established in inspectable source/code.
- `DOC-CONFIRMED` — directly established in authoritative documentation.
- `TEST-CONFIRMED` — established by a defined reproducible test on the actual/specified implementation.
- `COMMUNITY-REPORTED` — reported by community evidence but not independently reproduced.
- `INFERENCE` — engineering conclusion drawn from evidence; state assumptions.
- `UNKNOWN` — not established; do not fill the gap with a plausible number or state.

## Claims intentionally UNKNOWN

- Whether OpenPressBrake needs whole-body-access protection at any specific boundary.
- Actual safeguarded-space geometry or hidden zones.
- Required safety scanner field, resolution, response time or safety distance.
- Actual press-brake stopping time/distance.
- Hydraulic residual-energy or ram/gravity behavior.
- Required PL/SIL/category for any machine-specific safety function.
- Whether a trapped-key, personal-key, scanner, blind-spot check, mechanical LOTO, or combination is appropriate for a specific machine.
- Any universal timeout after which a space may be assumed clear.

These remain design-, measurement-, risk-assessment- and/or standards-dependent.

## Verification plan

For an actual implementation, validation should deliberately test multi-person entry, final-gate closure with a person still accounted inside, held reset, controller power cycle, lost-key recovery, escape release, stale communications, presence-sensor obstruction/occlusion where applicable, and attempted ordinary-controller start while restart permission is absent. Record the independent witness for each claim. Do not convert successful functional tests into unsupported PL/SIL or stopping-performance claims.
