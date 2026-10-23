# 4400 technician card — Muting, tool changes and the false comfort of 'slow'

**Status:** LEARNER-FACING / DOCUMENTARY. Companion: `../research/4400_AKAS5M_MUTING_SLOW_SPEED_SAFETY_AUTHORITY_2026-10-23.md`. Model-specific source: Fiessler AKAS-5M operating instructions doc 1581 (2024-02-15), pp. 4–5, 9–11, 24–26, 42–43. https://www.fiessler.de/default-wAssets/docs/download/AKAS/bdh-akas-5-original-engl-doc1581-v1.0.pdf

## Field scenario (no hazardous operation required)

An operator needs to form a box. The front light beams would detect its flange, so the box-bending function is selected. The HMI shows `Laser: OK`, `Ram command: slow`, `OSSD: ON`. A technician replaces the upper tool, then presses the ordinary start pedal. A second technician says, 'It is only slow; the guard still protects fingers.'

**Challenge:** Identify the distinct propositions those three indications can and cannot establish. Decide whether the machine is eligible for operation with a person at the point of operation. No physical test is authorized by this exercise.

## Five-question proof gate

| Question | Required witness | If absent |
|---|---|---|
| Which receiver elements still protect the actual hand/part geometry in this selected mode? | Selected-manual mode diagram + as-built tool/receiver geometry + competent physical reach assessment | **UNKNOWN / no exposed-person operation** |
| Who independently enforces the permitted speed and transition, and is actual speed observed? | Selected safety-related controller, independent sensors/diagnostics and validated machine-specific acceptance | Do not credit LinuxCNC command or HMI as safety proof |
| Can the safety outputs actually stop hazardous ram motion and keep gravity/external load restrained? | Selected final-element and independent physical stop/hold witnesses | OSSD ON/OFF and valve indication insufficient |
| Is the mode truly cancelled after tool/setup changes and is a deliberate reset separated from ordinary start? | Validated mode-change/rearm transaction, reset-fault and retained-start tests | Treat dependent evidence STALE |
| Can maintenance expose stored hydraulic/electrical/mechanical energy? | Independent isolating mechanism, stored-energy disposition and verification | Production muting/interlock not a substitute for isolation |

## Adversarial cases for desk review

1. **False premise:** 'The manufacturer's <10 mm/s condition means any ram moving at 9 mm/s is finger-safe.' Refute using hazard geometry, actual force and model-specific requirements.
2. **Contradiction:** safety controller reports slow, independent motion witness shows fast. Which evidence wins? What becomes stale?
3. **Field masking:** box mode disables front receiver elements; a hand enters the now-unprotected zone. Why is OSSD ON not proof of protection?
4. **Tool replacement:** same recipe and same laser status, but tool height/reach geometry changes. Which BND/PHY/SRS/VAL/PT/CHG IDs must be reviewed?
5. **Shortcut incentive:** repeated nuisance trips during small-part forming. Propose one mechanical/ergonomic and one safety-architecture improvement that makes correct use easier than bypassing.
6. **Mode rearm:** ordinary start is held during a return from setup mode. Why is 'reset accepted' not 'safe to move'?
7. **Applicability:** someone proposes tandem use based on a generic AKAS product page. What does the AKAS-5M manual say, and what remains unknown for a different model?

**Foot-control trap:** the 2024 AKAS-5M integration checklist specifically calls for a three-position safety foot switch in its documented foot-operated mode. A generic two-state LinuxCNC input or a convenient HMI jog button is not automatically equivalent. Exact pedal, selected safety-related controller, release/rearm behavior and machine-specific hazards must be validated before operation.

## Minimal traceability transaction

Create `BND` (task/geometry), `ENE` (hydraulic/gravity), `HAZ` (hand/part pinch), `SF` (mode-specific prevention/stop), `PHY` (no hazardous closing motion / guarded zone), `SRS` (qualified mode/transition), `AUTH` (independent safety owner), `DEP` (sensor, wiring, tool geometry, valve), `HF` (defeat incentive), `ARC` (selected compatible architecture), `VAL` (independent contradiction), `PT` (inspection), `CHG` (tool/mode change), `UNK` (measurements), `RR` (residual risk). Mark `VAL/PT` **NOT RUN** and machine release **BLOCKED** until real selected-machine evidence exists.

## Evaluator boundary

This is a learner-facing reasoning card, not a hidden-answer challenge or a scored blind evaluation. A separate evaluator must keep any future novel machine case and expected answer sealed until learner precommitment. No 2520–25F0 external gate is closed here.
