# Exceptional-State Manifest and Production-Handoff Pattern

Session start: 2026-09-21T04:38:32Z

## Purpose

This study turns the previous force/simulation findings into a reusable production-handoff pattern without promoting ordinary controller diagnostics into personnel-safety authority.

## Evidence classes

Claims below use the curriculum labels `DOC-CONFIRMED`, `INFERENCE`, and `UNKNOWN`. No runtime test was performed in this study.

## Authoritative implementation evidence

### Rockwell Logix — one engineering surface aggregates multiple controller exception classes

**DOC-CONFIRMED.** Current Studio 5000 documentation says the Online Bar exposes controller status, force status, online-edit status, redundancy status, and safety status. Its Forces Status distinguishes Forces/No Forces and whether I/O or SFC forces are enabled/disabled and installed/not installed. Its Online Edit Status separately indicates whether online edits exist and exposes their edit state.

Source: Rockwell Automation, *About the Online Bar*, Studio 5000 Logix Designer 38.01: https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-01/contents-ditamap/studio-5000-logix-designer/toolbars/about-the-online-bar.html

**DOC-CONFIRMED.** Rockwell controller modes are distinct from these exception states. Remote Run permits online editing. Program mode is explicitly not an emergency stop and is not a safety device. Therefore controller mode alone is not a production-cleanliness witness.

Source: Rockwell Automation, *Controller Operation Modes*, ControlLogix 5590: https://www.rockwellautomation.com/en-fi/docs/technical/logix5000/_online/1756-um900/controllogix-5590-controller-user-manual-ditamap/create-a-controller-project/controller-operation-modes.html

**DOC-CONFIRMED.** Rockwell's safety-application guidance distinguishes pending edits, test edits and assembled edits. A test edit executes edited logic while the original remains in controller memory. Safety online editing requires alternate protection while changes are in progress and documented impact analysis/testing. Standard-routine online edits have different validation implications from safety edits.

Source: Rockwell Automation, *Edit a Safety Application*, GuardLogix 5580 safety reference: https://www.rockwellautomation.com/en-ca/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-applications/edit-a-safety-application.html

### Rockwell PlantPAx — bypass state can be explicit and persistent until a clearing command

**DOC-CONFIRMED.** PlantPAx interlock instructions expose bypass status. Published Process Control Instructions state that a maintenance bypass request remains active until a maintenance `Check` command is received; bypass can also be active because the instruction is in Maintenance or Override depending on configuration. This is a concrete example of an exceptional operating state with explicit machine-readable state and explicit clearing semantics.

Sources:
- Rockwell Automation, *PlantPAx Process Control Instructions*, publication PROCES-RM215, interlock handling.
- Rockwell Automation, *Monitor PINTLK parameter values*, which exposes overall `Bypassed` / `Not bypassed` and per-interlock states.

### Pilz — exceptional maintenance state can be made restart-incompatible

**DOC-CONFIRMED.** Pilz's `key in pocket` maintenance safeguarding stores signed-in personnel IDs in a safe list. Machine restart is withheld while personnel remain signed in; after all personnel leave and sign out, the IDs are removed and restart can again be enabled. This is safety-related authority, unlike an ordinary controller force-clean indicator.

Source: Pilz, *Protection against unauthorised machine restart / key in pocket*: https://www.pilz.com/en-US/company/news/articles/238605

**DOC-CONFIRMED.** Pilz SecurityBridge separately exposes Setup and Bypass modes and provides status outputs for connection/operating-mode indication. This is industrial-security equipment, not personnel-safety proof, but it reinforces the human-factors pattern that exceptional modes should be observable rather than implicit.

Source: Pilz, *SecurityBridge*: https://www.pilz.com/en-INT/products/networks/fieldbus-and-ethernet-systems/securitybridge

## Exceptional-state manifest

The manifest is not a single `SAFE` bit. It is a typed inventory of known exception mechanisms with explicit evidence authority.

| Exceptional state | Preferred evidence | Production handoff disposition | Safety authority? |
|---|---|---|---|
| I/O/SFC force values installed | Controller-readable status where supported | Block ordinary production until values are removed, not merely disabled | No |
| Force facility enabled | Controller-readable status | Block ordinary production unless a documented production use explicitly requires it | No |
| Pending/test online edits | Controller/engineering status where supported | Resolve to accepted production revision or cancel; record disposition | Safety edits require safety-process treatment; standard edit status alone is not safety proof |
| Simulated I/O | Platform-specific machine-readable status when available | Block ordinary production while simulation remains active | No |
| Software permissive/interlock bypass | Explicit bypass status where implementation exposes it | Block ordinary production unless the bypass is an intentional, documented production mode | Depends on architecture; never assume ordinary PLC bypass status is personnel-safety authority |
| Maintenance/service/setup/override mode | Mode state plus documented transition rules | Production requires explicit exit and restoration of production mode | Only if implemented by an appropriate safety-related architecture |
| Safety-function muting/override | Safety-device/controller diagnostic state plus application validation | Must follow the safety function's own validated rules; do not fold into ordinary manifest logic | Yes, when implemented as part of validated safety function |
| Temporary jumper/test plug/fixture | Physical inspection/removal evidence unless independently sensed | Positive removal/restore inspection required | Not by itself |
| Temporary hydraulic/mechanical restraint or test aid | Physical inspection/removal evidence | Positive removal plus any affected physical revalidation | Not by itself |
| Personnel retained in safeguarded maintenance zone | Safety-related trapped-key/key-in-pocket/personnel-presence mechanism where designed | Restart remains inhibited until the validated release sequence completes | Yes, if architecture is safety-related and validated |

## Production-handoff state model

A practical normal-control implementation may compute a **PRODUCTION_CONFIGURATION_CLEAN** summary from only the exception classes it can actually observe. It must retain the constituent reasons so an operator/technician sees *why* handoff is blocked.

Recommended ordinary-control logic concept:

`production_configuration_clean = no_installed_forces AND no_unresolved_edits AND no_simulation AND no_ordinary_bypasses AND production_mode_selected AND physical_exception_check_signed_off`

This is an **INFERENCE / design pattern**, not a copied safety function. The expression must be adapted to the platform's documented observability. A field that cannot be observed must remain `UNKNOWN` or require a procedural/physical witness; it must not silently default to clean.

A production start should additionally require the independently designed personnel-safety chain to be ready. Do not combine these into one unqualified `safe=true` variable.

## Human-factors rules

1. **Exceptional states should be harder to forget than to clear.** Persistent banner/alarm/reason codes are preferable to a commissioning notebook entry.
2. **Disabled is not absent.** Where a platform distinguishes installed-but-disabled exceptions, handoff should normally require removal rather than mere disablement.
3. **Unknown is not clean.** A controller cannot prove a jumper, mechanical prop, hydraulic test fixture, or disconnected safeguard was physically restored unless an independent sensing/validation mechanism actually observes it.
4. **Show the blocking reason.** A generic `NOT READY` indication encourages bypass hunting; expose `FORCE INSTALLED`, `TEST EDIT ACTIVE`, `MAINTENANCE MODE`, `PHYSICAL TEST-AID SIGNOFF MISSING`, etc.
5. **Reboot is not sanitation.** Clearing semantics are platform-specific and must come from documentation or test evidence.
6. **Shift handoff is a state transition, not a conversation.** The incoming shift should receive an inspectable manifest with unresolved exceptions impossible to hide behind a verbal `it's back to normal` claim.
7. **Safety readiness remains independent.** An empty ordinary exception manifest does not validate E-stop, guard, ESPE, STO, hydraulic blocking/decompression, brake, stopping performance, or personnel clearance.

## Frozen distinctions

- **RUN MODE != PRODUCTION CONFIGURATION CLEAN.**
- **NO ACTIVE FORCE != NO FORCE VALUES INSTALLED** on platforms that distinguish those states.
- **NO CONTROLLER-REPORTED EXCEPTIONS != NO PHYSICAL TEMPORARY AIDS PRESENT.**
- **PRODUCTION CONFIGURATION CLEAN != PERSONNEL-SAFETY FUNCTION VALIDATED.**
- **SAFETY FUNCTION READY != ORDINARY PRODUCTION CONFIGURATION CLEAN.**
- **MODE SELECTED != MODE TRANSITION CONSEQUENCES VALIDATED.**
- **SHIFT HANDOFF COMPLETE != EXCEPTIONAL STATE CLEARED unless each applicable exception class has positive disposition.**

## Open questions / next evidence

1. Find an authoritative machine or controller implementation that exposes multiple exceptional-state classes programmatically to the running application, not only in the engineering UI.
2. Find documented semantics for online/test edits and simulation across reboot/download/redundancy switchover where those semantics materially affect handoff.
3. Trace a real machine implementation where ordinary production enable is explicitly gated by an exceptional-state summary while the personnel-safety chain remains independent.
4. Do not invent LinuxCNC/HostMot2 support for a generic manifest. If applied to LinuxCNC later, enumerate only actual HAL/component/configuration states that are inspectable and keep physical signoff separate.

## Compute disposition

No simulation/build/test was justified. This study resolves a documentation/architecture question from authoritative evidence, so no GitHub-hosted or self-hosted compute was consumed.
