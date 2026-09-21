# 4000 safety checkpoint — physical-change adversarial review and temporary commissioning state

UTC checkpoint: 2026-09-21T01:38:00Z

## Durable advance

Adversarial review of the physical-change return-to-service procedure found seven real loopholes and closed them in a companion engineering review: new/altered hazards must be checked before merely replaying old tests; retained evidence needs positive dependency traceability; temporary bypass/test state must be positively restored; validation tests need their own safe test-state boundary; a later favorable run does not erase an unexplained failure; maintainability/defeat resistance is part of human-factors review; and production release needs an exact production-state boundary.

Rotated into 25C0/human-factors evidence rather than continuing the source-limited all-in-one press-brake acceptance search.

FANUC source evidence adds a concrete pattern: simulated I/O used during startup can trigger a Production Check alarm that blocks automatic operation, with a separate visible team indication. Rockwell GuardLogix evidence adds a complementary boundary: safety I/O forces must be removed, not merely disabled, before safety locking/signature, yet standard-tag forces can still exist independently of safety-lock state. Therefore a valid safety signature does not prove ordinary commissioning state has been cleared.

Durable freezes:

- **OLD TEST SUITE PASSED != NEW/ALTERED HAZARD COVERED**.
- **VALIDATION PASSED WITH TEST SETUP != PRODUCTION CONFIGURATION RESTORED**.
- **LATER PASS != EARLIER UNEXPLAINED FAILURE CLOSED**.
- **PRODUCTION MODE SELECTED != TEMPORARY TEST STATE CLEARED**.
- **SAFETY APPLICATION LOCKED/SIGNED != STANDARD-CONTROL FORCES ABSENT**.
- **FORCE DISABLED != FORCE REMOVED**.
- **VALID SAFETY SIGNATURE != ORDINARY PRODUCTION CONFIGURATION RESTORED**.

Added a 25C0 adversarial shift-handoff exercise for a hidden simulated ordinary input.

## Parallel-work reconciliation

Newest Lane-B Cincinnati setup-mode checkpoint was read before substantive work. This lane did not duplicate its tooling/setup-mode study; instead it used that evidence only to preserve the distinction between operating mode and temporary commissioning state.

## Exact next work

1. Continue the temporary-state branch only for authoritative evidence on persistence/clearing of forces, overrides, test modes, or bypasses across reset/reboot/mode changes and on production-release interlocks; avoid generic force tutorials.
2. Prefer a machine/OEM or safety-controller procedure that explicitly verifies removal of temporary commissioning state during handoff/return-to-service.
3. Then adversarially connect this to 25C0 human factors: exceptional-state visibility, keyed/fool-resistant restoration, handoff, and preventing production pressure from normalizing bypass.
4. Keep ordinary LinuxCNC/HAL/FPGA production inhibits distinct from independent personnel-safety authority.
5. Do not invent OpenPressBrake override facilities, safety performance levels, or release criteria.

## Compute

No executable verification was justified. No GitHub-hosted runner was used and no self-hosted compute was consumed.
