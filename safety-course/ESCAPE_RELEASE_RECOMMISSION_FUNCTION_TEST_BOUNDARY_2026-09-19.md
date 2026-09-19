# Escape-release recommission and function-test boundary

Date: 2026-09-19

## Question

After a person uses an escape release on an accessible guard-locking system, what does a professional manufacturer require before return to service, and which authorities remain separate?

## DOC-CONFIRMED evidence — Pilz PSEN ml sa / DHM

Pilz's current operating manual exposes an unusually useful end-to-end escape-release recovery sequence.

When the escape release is operated from inside the danger zone, it mechanically acts on the auxiliary release, unlocks the safety gate immediately, and drives safety outputs 12 and 22 low. The device emits a warning; operation of the escape release is therefore visible to the safety chain rather than being an invisible mechanical egress action.

Pilz then specifies a dedicated **recommissioning** procedure:

1. restore/pull back the escape-release button;
2. acknowledge the stop signal in the controller;
3. carry out a function test using the escape release, performed by qualified personnel.

This is stronger than a simple `close gate -> reset -> run` model. Use of the escape release creates a return-to-service obligation that includes deliberate functional proof of the egress/safety function.

## DOC-CONFIRMED context — guard locking and restart

Pilz separately states that personnel-protection guard locking keeps the guard locked until hazardous machine functions have ceased; hazardous functions associated with the guard cannot operate until the guard is closed and locked. Its guard-locking product guidance also states that restart is not possible until the safety gate is closed and locked.

Pilz documents both power-reset and automatic-reset variants of PSENmlock. Therefore `device reset mechanism` must not be generalized into one universal power-cycle rule. The safety architecture must follow the selected validated device/application.

## Frozen authority chain

`ESCAPE RELEASE ACTUATED != HAZARD ABSENT`

`ESCAPE PATH AVAILABLE != PERSONNEL CLEAR`

`ESCAPE RELEASE RESTORED != STOP ACKNOWLEDGED != ESCAPE FUNCTION RE-PROVED != GUARD CLOSED != GUARD LOCKED != HAZARDOUS FUNCTION AUTHORIZED != ORDINARY START`

The function test after escape-release use proves the escape-release/safety-device behavior required by that manufacturer's recommissioning procedure. It does not prove that every person has left a large/blind cell, that every final element is physically safe, or that stale ordinary motion intent may resume.

## Human-factors design lesson

Escape release must remain easy and immediate from inside the danger zone. Recovery should be intentionally harder than escape: the operator/maintainer should be led through restoration, acknowledgement, and functional proof instead of being encouraged to bypass the device because recommissioning is obscure.

A practical HMI can make this sequence straightforward by clearly naming the reason motion authority is absent and the next permitted recovery action. That convenience does not move personnel-safety authority into ordinary LinuxCNC/HAL/FPGA software.

## Cross-check — fault diagnostics

Pilz Safety Device Diagnostics distinguishes undefined guard-lock position, OSSD faults, chain/open-circuit faults, and internal errors and assigns corrective actions such as escape-release positioning, wiring checks, power cycling, or device replacement. Diagnostic communication therefore helps locate the defect but remains distinct from safety output state and from physical proof that the hazardous machine has ceased.

## Explicit UNKNOWNs / non-transfer rules

- Do not infer that all escape-release devices require the exact PSEN ml DHM recommission sequence.
- Do not infer automatic restart permission from an automatic-reset device variant.
- Do not infer personnel-clear for a bodily-enterable/blind cell merely from a closed/locked guard.
- Do not infer that a successful escape-release function test proves final-element stopping performance.
- Application-specific reset/restart logic, stopping time, PL/SIL/category, and personnel-retention method remain machine-specific.

## Curriculum consequence

This closes a useful missing recovery boundary: a professional accessible-guard implementation explicitly treats escape-release use as an event requiring **recommissioning and functional re-proof**, not merely mechanical restoration of the handle/gate.

For complete cells, this sequence must be composed with the existing personnel-retention rule:

`escape/re-entry state -> personnel-clear proof -> guard close/lock -> required safety-device function proof -> safety reset/rearm -> application-specific ordinary start authority`.

## Sources

- Pilz PSEN ml sa / PSEN ml DHM Operating Manual 1005457-EN-05, function description and §4.9.1 Recommissioning.
- Pilz guard-locking application/product documentation.
- Pilz Safety Device Diagnostics System Description 1003827-EN-08.
