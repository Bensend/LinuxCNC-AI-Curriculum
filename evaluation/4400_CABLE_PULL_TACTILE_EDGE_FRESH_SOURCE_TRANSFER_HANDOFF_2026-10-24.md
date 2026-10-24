# 4400 — Independent fresh-source transfer handoff: cable-pull E-stop versus tactile safety edge

**Status:** PREPARED / NOT ADMINISTERED / NOT SCORED / NOT GRADUATED. No hidden answer is present in this learner-readable file. An independent evaluator must select and retain a **different** authoritative OEM source/variant from the course examples, keep it sealed, and administer the challenge to a genuinely fresh AI learner with the permitted resource set declared in advance. No physical tests or hazardous operations are authorized.

## Why this challenge exists

Two new 4400 source branches distinguish (a) a rope-pull emergency-stop actuator whose tension warning can coexist with ready safety outputs, from (b) a tactile edge whose first contact must be followed by enough qualified mechanical stopping/overtravel margin. The challenge tests **transfer of the safety-function decomposition**, not recall of Rockwell/Schmersal part numbers or paper scenario answers.

## Information separation

Evaluator must **not** expose the hidden OEM device manual, expected state table, final circuit design or scoring notes before the learner commits. Learner receives only the scenario, explicit allowed resources and blank response form. Do not score a learner who has already seen the source-specific resolution or a near-verbatim practice answer as blind. Do not put sealed answers in this public repository.

### Scenario A — retrofit perimeter stop

A long CNC stock feeder has a perimeter pull cable. After a winter temperature change the operator sees an intermittent tension warning, but the ordinary CNC interface continues to show READY. A replacement device from a different product family has arrived, with the same number of connector pins. The integrator proposes wiring the replacement's status output to the CNC controller and adding an HMI `Reset All` button. The actual stop/hold mechanism and reset sightline are not provided.

**Learner task:** Before claiming a safe retrofit, identify the missing product-specific signal truth table, actual cable actuation/reachability, diagnostic-versus-safety path, reset/restart and physical final-element witnesses. Propose a minimum maintainable architecture that makes correct operation easier than bypass. State what remains UNKNOWN and what would falsify the design.

### Scenario B — contact edge on a moving gantry

A machine's moving gantry has a rubber contact edge. A new rubber strip and a cheaper relay are proposed; the installer claims that the existing edge's PL label and relay LED guarantee protection. The gantry may have a retained move command after a stop. The physical speed, mass, residual stopping travel, profile deformation and allowable contact force have not been measured.

**Learner task:** Distinguish sensor physics/evaluator compatibility, contact-triggered response, overtravel/force, independent safety authority, restart prevention and selected-machine physical proof. State whether a tactile edge alone is demonstrably adequate and what evidence could change that conclusion.

## Immutable learner precommitment fields (one per scenario)

1. Primary diagnosis/design decision and confidence (0–100%).
2. Mechanism and complete hazard-to-final-element-to-physical-state path.
3. Specific OEM/manual/standards/source evidence required (without guessing numerical limits).
4. Top three failure modes and discriminating verification steps.
5. Reset/rearm/ordinary-start and occupancy separation.
6. Cheapest practical anti-bypass/maintainability improvement.
7. Clear operating restriction and residual risk while UNKNOWN.
8. Falsifier: what source or physical result would overturn the proposed architecture.
9. Elapsed solution time and actual resources consulted.

Record the learner's complete response and timestamp **before** revealing the evaluator-held source.

## Independent evaluator obligations

- Choose one OEM cable-pull device **not** identical to Rockwell Lifeline 4/5 or Schmersal ZQ 900, and one tactile-edge system **not** identical to Schmersal SE40/70/SE-304C or ASO SENTIR 8-8, with publicly inspectable exact editions.
- Freeze exact part suffix, wiring mode, reset behavior, fault indications, and installation constraints before learner exposure; record source URLs/editions privately.
- After learner precommit, reveal authoritative source and independently score using `evaluation/BLIND_FEEDBACK_PROTOCOL.md` five dimensions (prediction/diagnosis, mechanism, diagnostic efficiency, uncertainty/safety, confidence calibration), 0–2 each, /10.
- Explicitly flag invented stop distances, PL/SIL, pressure thresholds, safe forces, device signal meanings or unsupported machine-release claims. Do not award points for a merely polished safety warning without a causal trace.
- Distinguish **EVALUATION_INVALID** (ambiguous or wrong source oracle), **NON-BLIND/CONTAMINATED**, and valid scored attempts.
- Require a novel **third** source/device or a different machine class for later transfer retest. Schedule delayed retention separately; do not mark it achieved by the immediate transfer.
- Feed only aggregate scores/error classifications back to `evaluation/FEEDBACK_SCORE_LOG.md` after valid external scoring. No self-scoring from this handoff.

## Graduation and safety gates

Even a perfect external paper score would establish only *reasoning transfer*, not physical machine validation. The selected machine still requires exact `BND/HAZ/SF/SRS/ARC/DEP/PHY/VAL/PT/CHG`, independent final-element and stop/hold evidence, deliberate restart and any necessary maintenance isolation. No personnel-exposed hazardous operation if the minimum protection threshold is unproved. No local or GitHub-hosted compute is required to prepare this assessment.
