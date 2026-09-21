# 25E0 adversarial exercise — exceptional-state carryover into production

Date: 2026-09-21

## Scenario

A machine is commissioned after maintenance. During troubleshooting:

- a safety input was forced true in the safety-controller engineering tool;
- a separate ordinary LinuxCNC diagnostic input was simulated;
- a temporary physical jumper was installed on a non-safety pressure diagnostic;
- the safety application was unlocked/development-capable;
- the operator HMI displayed `MAINTENANCE`;
- Cycle Start was pressed and held while the safety force was active;
- the repaired field guard switch now operates correctly;
- the technician disables the safety force but does not remove its installed force definition;
- the ordinary simulated input is cleared in LinuxCNC;
- the temporary physical jumper is removed;
- the accepted safety-program signature has not yet been regenerated/verified;
- the HMI maintenance banner is manually cleared;
- no post-maintenance physical function test has yet been run.

The production supervisor asks whether the machine can now be declared ready for normal production because all real field devices appear normal.

## Required analysis

Classify separately:

1. **software exceptional-state clearance** — what remains installed, enabled, disabled, unlocked, unsigned or otherwise outside the accepted production baseline;
2. **physical temporary-aid clearance** — what must be physically inspected rather than inferred from controller state;
3. **configuration identity** — what a signature/checksum can and cannot prove;
4. **physical validation** — which guard/final-element/process functions require actual post-maintenance testing;
5. **personnel-safety authority** — which independent system owns the protective decision;
6. **ordinary-control state** — what LinuxCNC may display/inhibit without becoming the safety authority;
7. **demand freshness** — whether the Cycle Start held during the exceptional state may become effective after safety permission returns.

## Adversarial traps

Reject each shortcut:

- `the force is disabled, therefore it is gone`;
- `the field input now reads correctly, therefore the safety application is production-ready`;
- `the signature matches, therefore the guard and final elements physically work`;
- `the maintenance banner cleared, therefore maintenance state is cleared`;
- `LinuxCNC simulation is off, therefore no other temporary state remains`;
- `safety reset succeeded, therefore held Cycle Start is fresh`;
- `the technician was authorized, therefore the bypassed condition was safe`.

## Expected reasoning boundary

A defensible production-readiness declaration requires explicit reconciliation of **all temporary state classes**, not merely the currently visible field values. The installed safety force must be handled according to the actual platform lifecycle; Rockwell provides a concrete example where safety forces must be removed, not merely disabled, before safety lock/signature. Physical jumpers require physical accounting. Configuration identity and physical function validation remain separate evidence classes. Held ordinary demand must be tested against the actual restart/freshness design and must not be silently treated as a new production request.

Do not assign a universal timeout, universal key-switch circuit, or universal restart algorithm. Those are design-specific.
