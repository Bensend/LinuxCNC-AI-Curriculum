# Lost Personnel-Key and Administrative Safety-State Recovery

Date: 2026-09-16

## Purpose

This module addresses an exceptional but important whole-body-access failure path: a personnel token/key is lost, the safe personnel list becomes indeterminate, a safety controller is replaced/rebooted, or authorized personnel invoke an administrative list reset.

The central rule is:

**`administrative_state_recovered` is not `physical_space_proven_empty`.**

An operator database, RFID credential, safe-list record, HMI indication, controller reboot, or authorized key-list reset may repair an accounting problem. None of those events by itself proves that no person remains in the safeguarded space.

Keep these concepts separate:

`credential_validity` -> `personnel_accounting_state` -> `physical_space_clearance_evidence` -> `safety_reset_eligibility` -> `safety_permission` -> `ordinary_rearm` -> `start_request`.

## Evidence ledger

### DOC-CONFIRMED — Pilz Key-in-pocket uses personal RFID identity plus a safe list

Pilz describes Key-in-pocket as using individually programmed RFID keys. A person's Security ID is stored in a safe list when that person authenticates for entry. To return the plant to productive operation, all persons must leave and sign out; their IDs are removed, and an empty list is part of the release condition.

Source: Pilz, `Protection against unauthorised machine restart`, accessed 2026-09-16.

### DOC-CONFIRMED — lost transponder keys can be blocked/reprogrammed

Pilz explicitly lists simple blocking and reprogramming when a transponder key is lost. Therefore a lost credential is not necessarily a permanent hardware dead-end; there is an administrative credential-recovery path.

Source: Pilz access-management / Key-in-pocket product information, accessed 2026-09-16.

### DOC-CONFIRMED — authorized personnel can perform a key-list reset

Pilz explicitly documents a `key list reset` in which authorized personnel can delete the safe list. This is strong evidence that exceptional administrative recovery exists and must be treated as a distinct safety-significant operation rather than ordinary logout.

Source: Pilz, `Protection against unauthorised machine restart`, accessed 2026-09-16.

### DOC-CONFIRMED — blind-spot confirmation remains a separate restart condition

Pilz states that where a plant has no overall view, a blind-spot check is used and the last person can be required to acknowledge difficult-to-see areas before restart. This supports the course rule that clearing or repairing the personnel list is not automatically equivalent to proving the physical zone empty.

Source: Pilz, `Protection against unauthorised machine restart`, accessed 2026-09-16.

### INFERENCE — exceptional recovery should fail closed until independent clearance evidence is re-established

Because normal release relies on all entered persons being removed from the safe list through the defined exit/logout process, loss or corruption of that accounting state destroys part of the normal evidence chain. A conservative architecture therefore treats an indeterminate accounting state as blocking restart until the defined exceptional recovery procedure establishes the required physical clearance evidence and reset conditions.

This is an architecture inference, not a claim about every commercial product's internal implementation.

## Failure-state model

Do not collapse all abnormal cases into `key_fault`.

Track at least:

- `credential_lost_or_suspect`
- `credential_revoked`
- `personnel_list_valid`
- `personnel_list_nonempty`
- `accounting_state_indeterminate`
- `administrative_recovery_authorized`
- `administrative_recovery_complete`
- `physical_clearance_evidence_valid`
- `blind_spot_check_required`
- `blind_spot_check_complete`
- `safety_reset_required`
- `ordinary_rearm_required`

A safe HMI may summarize these for the operator, but the curriculum must preserve the distinctions in architecture and validation.

## Lost-key recovery contract

When a key/token is reported lost while its person may still be represented as inside:

1. Do not infer that the person left merely because the physical token cannot be found.
2. Revoke/block the lost credential according to the selected system's supported procedure so a found or duplicated token cannot silently regain authority.
3. Preserve restart inhibition while personnel accounting or physical occupancy is indeterminate.
4. Establish the application-specific exceptional clearance procedure. This may include personnel contact/accounting, controlled inspection, blind-spot confirmation, presence-sensing evidence, trapped-key/accounting checks, or other validated measures.
5. Only after the physical clearance evidence required by the safety concept is valid may the exceptional administrative list state be reconciled/reset.
6. Require the defined safety reset/restart sequence; do not let administrative recovery itself issue a machine start.
7. Require ordinary LinuxCNC/FPGA rearm separately and discard stale pre-existing jog/cycle/start commands.

The exact ordering of steps 4–5 is implementation-specific; the non-negotiable curriculum point is that deleting a database/list record cannot substitute for physical clearance evidence.

## Controller reboot/replacement and lost state

A reboot is not evidence of occupancy state.

If the safety architecture guarantees preservation and integrity of the safe list across the relevant reboot, that claim must be documented and validated for the selected system. If the list is erased, corrupted, restored from an uncertain backup, or otherwise becomes indeterminate, the design must not silently reinterpret `unknown` as `empty`.

Controller replacement is a stronger change-control event. Prior validation evidence must be reviewed against firmware/configuration identity, safe-list behavior, credential database restoration, reader identities, I/O mapping, restart semantics, and any blind-spot-check logic.

No universal persistence behavior is assumed here.

## Duplicate, spare, and replacement credentials

A replacement credential creates two separate questions:

- **Security/authorization:** can the lost credential still authenticate?
- **Safety/accounting:** does the personnel accounting state still correctly represent who may be inside?

Reissuing a credential can solve the first while leaving the second unresolved. The course must reject `new key issued -> safe list fixed -> restart allowed` unless the physical/accounting evidence chain is explicitly restored.

Spare/master credentials are a defeat path if they can bypass personal accounting. Their permissions, custody, auditability, and effect on restart prevention must be included in validation/change control.

## Administrative key-list reset threat model

Treat key-list reset as an exceptional safety-significant recovery action.

Adversarial cases:

1. A supervisor clears the list because one employee lost a token, without checking whether that employee is still inside.
2. A maintenance HMI exposes `CLEAR ALL` beside ordinary reset controls.
3. A remote support session performs list reset without visibility/accounting of the safeguarded space.
4. Controller replacement boots with an empty list even though the pre-replacement list was nonempty or unknown.
5. A backup restores stale personnel state from before a later entry.
6. A duplicate/replacement token is issued while the original remains usable.
7. A commissioning master token can sign out another person's record without the exceptional recovery procedure.
8. A key-list reset is logged as `space clear`, conflating administration with physical evidence.
9. Network reconnection replays a previously queued list-reset command.
10. Blind-spot confirmation is skipped because the administrative list now reads empty.

## Human-factors rule

Exceptional recovery must be usable enough that personnel do not predictably bypass it, but convenience must not turn it into an ordinary production shortcut.

A practical design should make the normal personal sign-out path easy, make lost-key blocking/replacement straightforward for authorized staff, and make the exceptional list-reset path conspicuous and deliberate. If routine operations frequently require administrative list reset, investigate the workflow/device design rather than normalizing the exception.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC and the ordinary FPGA may:

- display personnel-accounting status supplied by the safety architecture;
- inhibit ordinary commands when safety permission is absent;
- log lost-key/recovery events;
- discard stale commands after recovery;
- require ordinary rearm after safety permission returns.

They must not be taught as sole authority to erase safety personnel state, declare a safeguarded space empty, or convert an administrative recovery action directly into personnel-safety permission.

## Validation questions

For the selected real implementation, require evidence for:

- What exactly happens when a token is lost while signed in?
- Can the lost token be blocked immediately, and how is revocation propagated to every reader?
- What survives controller power loss/reboot?
- What happens after controller replacement or configuration restore?
- Who can invoke key-list reset, through what interface, and is the action logged?
- What physical clearance evidence is required before/after exceptional reset?
- Can reset be issued remotely or retained across reconnect/reboot?
- Can a duplicate/master/spare credential bypass individual accounting?
- Is a separate safety reset required after exceptional recovery?
- Are stale ordinary start/jog/cycle commands discarded before rearm?
- What changes invalidate prior validation evidence?

## Evidence labels and unknowns

Use only: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

Remain `UNKNOWN` until implementation evidence exists:

- exact persistence semantics of a selected controller/version;
- exact authorization model for key-list reset;
- exact credential-revocation propagation time;
- required inspection/blind-spot procedure for a specific machine;
- whether a specific scanner/camera/personnel system proves the relevant space clear;
- PL/SIL/category or diagnostic-coverage claims for a complete architecture;
- any press-brake-specific safe state, stopping distance, hydraulic state, pressure threshold, or clearance timing.

## Practical minimum

If personnel accounting becomes indeterminate and the safeguarded space can contain a person, **do not restore hazardous operation merely by clearing or reconstructing the administrative list**. Keep restart inhibited until the defined physical clearance/recovery evidence is established. If that evidence cannot be established, keep people outside the hazard through appropriate isolation/remote methods and do not operate with personnel exposed.

## Next independent evidence branch

Study **safety-event logging, audit trails, and evidence integrity**: distinguish diagnostic/history logs from safety authority; define what should be recorded for bypasses, lost credentials, exceptional resets, guard/EDM faults, safety resets and configuration changes; analyze clock loss, log gaps, tampering, reboot and stale-event ordering without treating a log as proof that the physical safe state occurred.