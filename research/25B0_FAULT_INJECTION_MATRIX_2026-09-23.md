# 25B0 — Machine-neutral fault-injection matrix and test-selection hierarchy

## Why this exists

Fault injection is useful only when it challenges a defined safety proposition. The matrix below is deliberately machine-neutral: application-specific timing, pressure, stopping distance, diagnostic coverage and integrity targets must come from the actual SRS/design/evidence.

## Matrix

| Layer | Representative fault | What analysis should predict | Useful observation | What a pass does **not** prove |
|---|---|---|---|---|
| power | safety 24 V lost/brownout | defined de-energized/passivated reaction and restart behavior | safety I/O state, outputs, final elements, restart inhibit | every partial-voltage trajectory or shared-supply CCF covered |
| wiring | one NC channel open | channel disagreement or safe demand as designed | channel state, diagnostic, safe output path | cross-short diagnostics or second-channel independence |
| wiring | channel-to-channel cross-short | detection only if architecture/test method supports it | diagnostic/fault state and reaction | mechanical independence or all routing CCFs |
| sensor | one channel frozen in plausible safe state | other channel/diagnostics must reveal fault if claimed | disagreement/timeout/fault | a common mechanical defeat affecting both sensors |
| sensor | both channels defeated by one actuator/tongue/target | architecture may have no electrical symptom | physical inspection / independent state evidence | cannot be rescued by observing two healthy bits |
| logic | safety task frozen/watchdog expires | controller-defined safe/passivated reaction | watchdog/fault and output transition | final element physically changed state |
| configuration | discrepancy/monitoring parameter corrupted or stale | altered detection/reaction timing; evidence becomes stale | configuration signature/version + timed behavior | previous validation remains valid |
| communication | safety network interrupted | timeout/passivation according to validated monitoring time | communication fault, safe command/output transition | contactor/valve/load reached safe physical state |
| communication | stale/wrong endpoint/config identity | safety protocol should reject where mechanism applies | identity/CRC/address diagnostic | field wiring and final-element correctness |
| output | semiconductor output stuck/shorted | downstream architecture/diagnostics must address if claimed | output command versus measured electrical state | hazardous energy actually removed |
| final element | contactor welds | redundant path and EDM should prevent unsafe restart if designed | aux feedback, second path, energy measurement | all weld combinations or contactor suitability |
| fluid final element | valve spool sticks | redundant/block/dump/load-hold measures act according to design | valve indication plus pressure/load behavior | indicated spool position proves pressure/load safe |
| physical state | spindle coasts longer than assumed | guard release must remain inhibited until validated criterion | independent speed/standstill evidence | future stopping time unchanged after wear/load changes |
| physical state | gravity load drifts despite command-off | load-holding/restraint must prevent hazardous descent | independent position/load observation | maintenance isolation exists |

## Latent-fault example

A two-contactor output has K1 and K2 in series. K1 welds during a cycle but its feedback contact is miswired so EDM still appears healthy. The machine stops because K2 opens. A simple test that asks only "did the machine stop after one injected fault?" passes. Later K2 welds. The latent K1 fault has removed the intended redundancy.

Lesson: the expected reaction to the first fault includes **detection and prevention of unsafe restart where the architecture requires it**, not merely successful stopping on the remaining channel.

Freeze: **FIRST FAULT TOLERATED != FIRST FAULT SAFELY DIAGNOSED.**

## Common-cause example

Two guard channels terminate on separate F-DI channels and pass every open-wire injection independently. Both sensor cables, however, share one exposed connector whose contamination can bridge both channels to the same supply. Sequential opens never challenge that dependency.

Lesson: channel-by-channel testing is not a substitute for dependency analysis.

Freeze: **TWO SINGLE-CHANNEL TESTS PASS != COMMON-CAUSE PATH TESTED.**

## Safe test-selection hierarchy

Use the lowest-risk method that can answer the question:

1. **Authoritative documentation/source inspection.** Resolve specified protocol, diagnostic, timing, replacement and failure-reaction behavior without energizing a hazard.
2. **Static engineering reasoning.** Schematics, fault trees, FMEA, dependency/CCF review and calculations using sourced parameters.
3. **Low-energy representative model.** Relay lamps, logic model, low-force actuator or equivalent when the question is interface/state behavior rather than machine physics.
4. **Isolated bench or simulation.** Appropriate for controller/configuration/network behavior when equivalence limits are explicit.
5. **Guarded/remote machine test.** Only when actual machine physics is the unresolved proposition (for example stopping time or real final-element behavior), with people outside the danger zone and an independently established way to contain an unexpected reaction.

Do not escalate simply because a higher tier is available.

## Adversarial cases for the next assessment

### A — Frozen plausible encoder
The safety controller sees a speed value frozen below a release threshold while the shaft remains moving. Determine whether the architecture has freshness/plausibility/independent-state evidence. Do not invent sensor diagnostics.

### B — Welded contactor plus misleading feedback
K1 power contacts weld while an incorrectly selected/miswired auxiliary indicates open. Determine whether K2, EDM architecture and restart behavior expose the latent fault. A stopped motor alone is insufficient evidence.

### C — Stuck hydraulic valve
The controller commands dump/block state and receives an electrical output-off indication. The spool sticks. Require pressure/load-state reasoning and any independent monitored valve/load-holding measures actually present; do not infer them.

### D — Corrupted parameter set
Program source is unchanged but discrepancy time or network monitoring time differs from the accepted configuration. Determine which response/fault-detection evidence is stale.

### E — Safety-network timeout
PROFIsafe or equivalent times out and remote outputs passivate. Trace the chain through the physical final element. `remote output safe` is not the final machine proposition.

## Lab freeze decision

None of these cases presently requires executable compute to teach the reasoning. A later lab should be frozen only around a concrete implementation whose undocumented or machine-physical behavior remains unresolved. Until then, source and engineering reasoning have higher information value and lower hazard.
