# Open Safety Obligation / Containment Handoff Record

Use this compact record whenever a `FIND-*`, stale `PROP-*`, incomplete `VAL-*`, active containment, or unresolved safety-critical `UNKNOWN` must survive an ordinary controller/HMI restart, power cycle, shift change, maintenance ownership transfer, or work-order closure.

This is a **safety lifecycle record**, not an ordinary LinuxCNC/HMI alarm latch. The normal controller may display or consume a summary, but clearing/restarting LinuxCNC, HAL, FPGA logic, HMI state, or a maintenance ticket does not constitute acceptance.

## Identity

- `OBL-ID:` OBL-____
- `state:` OPEN | CONTAINED | READY_FOR_REPROOF | AWAITING_ACCEPTANCE | ACCEPTED_CLOSED | REDESIGN_REQUIRED | DECOMMISSIONED
- `created_utc:`
- `source_finding:` FIND-____ | N/A
- `affected_safety_functions:` SF-____
- `affected_propositions:` PROP-____
- `stale_or_missing_evidence:` EVID-____
- `required_validation:` VAL-____
- `implicated_dependencies:` DEP-____

## Containment and authority

- `containment_required:`
- `operation_permitted_while_open:`
- `personnel_exposure_permitted:` YES | NO | CONDITIONAL | UNKNOWN
- `residual_risk_or_unknown:`
- `containment_owner_role:`
- `acceptance_authority_role:`

If a safety-critical proposition is failed or `UNKNOWN`, an ordinary READY/RUN indication, alarm clear, reboot, reset, or fresh CNC command does not remove this obligation.

## Persistence contract

The following must remain recoverable independently of volatile ordinary-control state until accepted closure:

1. `OBL-ID` and current state;
2. linked `FIND-*`, `PROP-*`, `EVID-*`, `DEP-*`, and `VAL-*` identities;
3. active containment and whether exposed operation is permitted;
4. remaining re-proof/acceptance obligations;
5. owner/acceptance authority roles and last handoff;
6. unresolved safety-critical `UNKNOWN`s;
7. closure evidence and acceptance identity once closed.

Events that **must not silently clear** an open obligation:

- LinuxCNC/HMI/FPGA restart;
- loss and restoration of ordinary controller power;
- clearing ordinary alarms/fault displays;
- safety-device diagnostics returning healthy;
- maintenance ticket/work order closure;
- shift/personnel handoff;
- restoration of field power or communication;
- replacement/repair without the declared physical re-proof and acceptance.

If the persistence mechanism itself is unavailable or its integrity is `UNKNOWN`, do not infer that no obligations exist. Recover from the authoritative maintenance/safety record before permitting personnel exposure that depends on those propositions.

## Handoff

- `handoff_utc:`
- `from_role:`
- `to_role:`
- `containment_physically_verified_at_handoff:` YES | NO | UNKNOWN
- `open_validation_items_reviewed:` YES | NO
- `next_required_action:`
- `handoff_evidence:` EVID-____

A signature or ticket transfer records ownership transfer; it does not prove the machine's physical safe state.

## Re-proof / closure

- `new_evidence:` EVID-____
- `physical_propositions_reproved:` PROP-____
- `configuration_identity_checked:`
- `forces_simulations_exceptional_modes_cleared:`
- `acceptance_authority:`
- `accepted_utc:`
- `remaining_unknowns:`
- `closure_state:`

After accepted closure, normal reset/rearm and a fresh ordinary start demand remain separate actions when the architecture requires them.

## Required UI boundary

A normal HMI may show `SAFETY OBLIGATION OPEN`, `CONTAINED`, or `ACCEPTANCE REQUIRED`, but the display is not the authority. On restart, absence of a reconstructed authoritative obligation state must not be translated into `SAFE`, `ACCEPTED`, or `READY FOR PERSONNEL EXPOSURE`.

Freeze:

**VOLATILE STATE LOST != SAFETY OBLIGATION CLEARED**  
**HMI READY != ACCEPTED SAFETY BASELINE CURRENT**  
**WORK ORDER CLOSED != SAFETY ACCEPTANCE COMPLETE**  
**DIAGNOSTICS HEALTHY != PHYSICAL RE-PROOF COMPLETE**
