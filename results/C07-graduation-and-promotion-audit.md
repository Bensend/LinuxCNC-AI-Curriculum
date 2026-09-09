# C07 — 1000-level Graduation / Promotion Audit

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Course-level scope

C07 1000-level competency is ordinary LinuxCNC machine-state sequencing: distinguish request from achieved state, follow the HALUI/NML/Task/Motion request and returned-status paths, understand representative blocked/invalid transitions and Task abort effects, design a bounded status-driven sequencer, interrupt active state on achieved-state loss, consume stale authorization across recovery, and preserve the boundary between software state integrity and physical/functional safety.

It does not require a safety-rated machine restart controller, exhaustive version comparison, or hardware-specific fault/reset behavior.

## Minimum graduation evidence floor

- [x] **Core mechanism identified and traced from actual source** — HALUI rising-edge request -> NML Task state command -> Task -> Motion enable command -> realtime prerequisite/fault handling -> motion enable status -> Task derived state -> HALUI returned status.
- [x] **Behaviorally significant path traced end-to-end** — machine ON request and achieved-status return documented in `call-flows/C07-halui-task-state-request-status.md`.
- [x] **Independent verification beyond source rereading** — C07-049 authoritative software execution, frozen Gates A–J PASS.
- [x] **Representative failure/invalid-input path** — `motion.enable=false` rejects machine enable; active enable loss revokes achieved state.
- [x] **Predeclared prediction checked** — C07-047 frozen before implementation; C07-048 preflight then separate C07-049 authoritative execution matched prediction.
- [x] **Fresh-AI novel course-level scenario** — amplifier-fault transfer scenario passed without relying on the exact experiment injection seam.
- [x] **No promoted item can overturn a central teaching** — audited below.
- [x] **No promoted item invalidates a downstream prerequisite** — audited below.
- [x] **No promoted item invalidates the evidence chain** — authoritative claim remains revision/topology scoped.
- [x] **No promoted item materially changes the stated safety boundary** — all safety-specific uncertainties are explicitly outside ordinary state-integrity proof.
- [x] **Every promoted item explains why promotion is safe** — table below.

## Graduation evidence checklist

- [x] Current level/scope explicit.
- [x] Official HALUI/homing/config documentation reviewed.
- [x] Community failure/restart cases reviewed as investigation leads rather than normative truth.
- [x] Source inventory/function guide sufficient for current level.
- [x] Significant functions/symbols traced.
- [x] Request and returned-status call flow documented.
- [x] Claims reconciled with source and runtime evidence.
- [x] Reproducible independent experiment accepted.
- [x] No unresolved repeated experiment-failure family remains; C07 topology/full preflights passed before authority.
- [x] Failure modes/prediction documented.
- [x] Frozen adversarial exam passed 16/16 = 10/10.
- [x] No central exam correction required; retrieval cues reinforced.
- [x] Fresh-AI novel scenario passed.
- [x] Promotion/uncertainty queue updated below.
- [x] Counterfactual promotion test passed.

## Higher-level promotion / uncertainty queue

| Item / question | Current evidence | Why unresolved / deferred | Consequence if wrong | Destination | Priority | Blocks current graduation? | Why promotion is safe |
|---|---|---|---|---|---|---|---|
| Full cross-version equivalence of HALUI -> Task -> Motion sequencing | Pinned C07 source/test plus current-master HALUI edge spot-check | Only HALUI edge helper was spot-checked on current master; full call path not diffed/executed cross-version | Integrators targeting another revision may need different exact behavior/timing assumptions | 2000 | medium | No | Central 1000 teaching is explicitly pinned/version-scoped; another version behaving differently does not invalidate the pinned evidence or the general need to observe achieved state. |
| Exact userspace latency/distribution from request edge to HALUI returned status under load | Ordered C07 userspace trace demonstrates policy ordering, not timing guarantee | Requires dedicated timing/latency experiment and workload characterization | Could affect timeout/UI design, not request-vs-achieved identity | 2000 | medium | No | C07 teaches status gating without promising a fixed response deadline. |
| Bounded automatic retry policies | C07 intentionally tests no-hidden-retry policy | Retry policy is application-specific and can obscure command-edge vs authorization semantics at 1000 level | A poor retry policy can cause unwanted state requests | 2000 | medium | No | Current core rule remains that any retry is a new explicit policy action and cannot be inferred from prerequisite restoration. |
| Homing/re-homing policy after specific drive/E-stop/power-loss scenarios | Source confirms `volatile_home` configuration sensitivity and returned homed state | Physical encoder/drive retention and machine mechanics are hardware-specific | Wrong assumption can invalidate position after a disturbance | 2000 / hardware-specific | high | No | 1000 teaching explicitly forbids treating controller homed state as independent physical truth; machine-specific validation is already outside the claim. |
| Physical safe restart / functional-safety architecture | Only ordinary LinuxCNC/HAL state-integrity evidence | Requires machine risk assessment, external circuitry, actuator/energy analysis and applicable standards | Safety-critical | 2000+ machine-specific / safety engineering | high | No | It is not silently assumed; C07's central boundary is precisely that software sequencing evidence does not establish safe physical restart. |
| Multi-cause fault prioritization and recovery diagnostics | Source shows multiple causes can revoke Motion enabling; novel handoff transfers to amplifier fault | Detailed prioritization/diagnostic UX belongs with C08 diagnostics and later architecture work | Poor diagnosis may cause confusing recovery or mask root cause | C08 / 2000 | medium | No | C07 requires active permission to follow achieved state regardless of cause; diagnosis of which cause fired does not alter that state-integrity rule. |

## Counterfactual promotion test

Question: if every promoted item turned out differently from the current expectation, would a central C07 claim become wrong, a downstream prerequisite become unreliable, the accepted evidence chain become invalid, or the stated safety/reliability boundary materially change?

**Answer: NO**, under the explicit scopes above.

- If a later LinuxCNC revision changes edge/timing details, pinned C07 evidence remains valid and version-specific verification remains required.
- If HALUI status latency is much larger or more variable, a sequencer still must wait for achieved state rather than infer it from its request.
- If a project later chooses bounded automatic retry, each retry still requires an explicit policy decision/new request and must remain status-gated.
- If a particular machine preserves or loses home differently, C07 already teaches observation/configuration sensitivity and rejects universal physical-position claims.
- If safety analysis demands stricter restart behavior, that strengthens rather than contradicts C07's explicit boundary that ordinary Task/HAL sequencing is not functional-safety certification.
- If detailed diagnostics identify a different initiating fault, the active state still must not be preserved from stale request history after achieved ON disappears.

Therefore none of the promoted items is being used to hide an unresolved premise essential to 1000-level C07.

## Sufficiency decision

C07 has source-level request/return tracing, a real blocked-transition failure seam, a predeclared and independently executed P0–P8 experiment with retained evidence and frozen Gates A–J passing, a frozen adversarial exam passing 10/10, and a novel transfer scenario that generalizes beyond `motion.enable` to another Motion fault cause. Remaining uncertainties are version-, timing-, retry-policy-, hardware-, diagnostic- or functional-safety-specific and are explicitly bounded.

**Decision: C07 GRADUATED at 1000 level.**

The next critical-path module is **C08 — diagnostics and trace capture**. Its first 1000-level lesson should inventory what a generic capstone needs to retain to distinguish command/request, achieved state, realtime fault cause, Task/NML error/status, and timing/phase context without assuming one trace surface is authoritative for every layer.
