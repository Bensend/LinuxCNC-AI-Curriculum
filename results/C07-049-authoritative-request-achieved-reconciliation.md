# C07-049 — Authoritative Request-vs-Achieved-State Sequencing Reconciliation

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Classification: **AUTHORITATIVE TEST-CONFIRMED PASS** for frozen C07-047 Gates A–J.

## Run identity

- Frozen plan: `experiments/C07-047-request-achieved-state-sequencing-plan.md`
- Full preflight accepted first: C07-048 workflow `34318296679`, job `102359108023`
- Authoritative curriculum commit: `5688cde544fc2ebf46ebe3a0749d155cc36ed98b`
- Authoritative workflow: `34318656849`
- Job: `102360226472`
- Artifact: `10091082214`
- Artifact digest: `sha256:25a569a8ef09e90560c1037e7b38b27e3ce017f437671bdaaed655a836a6c8cd`
- Job start/end: `2026-09-09T06:21:01Z` / `2026-09-09T06:24:10Z`
- Exact job runtime: 189 s = **3.15 min**
- Inner authoritative lab start/finish: `06:21:03Z` / `06:24:06Z`
- Inner exit: `0`

## Integrity relationship to preflight

C07-049 did not rewrite the passed P0–P8 implementation after seeing C07-048 output. The authoritative wrapper explicitly executed `lab-jobs/048-c07-full-sequencer-preflight.sh` byte-for-byte as a **new independent LinuxCNC execution**, then applied a separately precommitted Gate A–J analyzer against that run's retained trace and provenance.

The helper retained its internal `PRECHECK`/non-authoritative wording, while the outer C07-049 job declared authority before execution and independently scored the already-frozen Gates A–J. Frozen phase semantics, request counts, prerequisite seam, sequencer policy, and safety boundary were not weakened.

Crucially, C07-049 copied the complete evidence into `lab-results/c07-049-authoritative-evidence/` before the workflow artifact/result commit, so the authoritative raw trace, analyzer, harness, wrapper, frozen plan, test INI/HAL, LinuxCNC stdout/stderr, source hashes, object/topology evidence, and SHA256 inventory are durable rather than stdout-only.

## Gate reconciliation

### Gate A — Provenance / topology: PASS

Pinned production HALUI/Task/Motion file hashes were retained; the exact test configuration and harness are retained; required real HAL objects were observed; no production source was modified. The harness directly controls the unlinked `motion.enable` HAL input and does not introduce a competing writer.

### Gate B — Observation integrity: PASS

The single monotonic userspace sequencer/observer retained contiguous sequence numbers and monotonic timestamps and published every decisive phase marker before its mutation. The sequencer's own transition decisions use the status values acquired by that process and are followed by explicit post-transition observations, so state advancement is not reconstructed from unrelated asynchronous streams.

### Gate C — Baseline: PASS

P0 was out of E-stop, machine OFF, request low, and cycle permission false.

### Gate D — Blocked request proves request != achieved state: PASS

P2 contained exactly one actual machine-ON rising edge while `motion.enable=false`. Across P2/P3, achieved `halui.machine.is-on` stayed false, state never became `ON_CONFIRMED`, and cycle permission stayed false. P3 emitted no retry.

### Gate E — Restoring prerequisite is not implicit retry: PASS

P4 restored `motion.enable=true` with zero new machine-ON edge. Achieved ON and cycle permission remained false.

### Gate F — Explicit retry waits for achieved state: PASS

P5 contained exactly one fresh machine-ON edge. No confirmed/cycle state preceded observed `halui.machine.is-on=true`; only after returned achieved status appeared did the sequencer enter `ON_CONFIRMED` and grant its lab cycle permission.

### Gate G — Active fault interrupts state: PASS

P6 published its phase before driving `motion.enable=false`. Once achieved machine-ON status was observed false, the sequencer entered `RECOVERY_REQUIRED` and revoked cycle permission in the **same sequencer evaluation tick**. It did not preserve its prior active logical state from request history.

### Gate H — No automatic restart: PASS

P7 restored `motion.enable` but provided no fresh authorization or request. The sequencer reached/stayed recovery-wait state, achieved machine ON remained false, and cycle permission remained false.

### Gate I — Guarded explicit recovery: PASS

P8 required a fresh post-fault authorization and exactly one fresh request edge. Return to `ON_CONFIRMED` / cycle permission followed observed achieved `machine.is-on=true`; it did not precede it.

### Gate J — Safety-language boundary: PASS

The authoritative job explicitly states that this is ordinary Task/HAL sequencing state-integrity evidence, **not functional-safety evidence**. Real-machine restart additionally requires machine-specific verification of physical state, stored/available energy, E-stop architecture, actuators/drives/valves, interlocks and applicable safety requirements.

## Prediction reconciliation

The frozen prediction matched the independent execution:

```text
blocked request -> no achieved ON
prerequisite restoration alone -> no implicit retry / no ON
fresh request with prerequisite restored -> achieved ON can follow
sequencer activation -> only after returned achieved status
active prerequisite loss -> achieved ON falls and permission is revoked
fault-input restoration alone -> no automatic restart
fresh post-fault authorization + request + achieved status -> guarded recovery
```

The experiment therefore independently verifies the central C07 teaching at the pinned revision: **a command/request edge is not an achieved-state fact, and restart authorization is a separate higher-level policy state that must not be silently inherited across a fault.**

## Evidence limits

This fixture does not prove:

- physical actuator/drive/valve state;
- independent physical position;
- stored-energy state;
- external E-stop relay behavior;
- a safety-rated restart interlock;
- that every LinuxCNC version has identical HALUI/Task/Motion timing/edge behavior.

## Decision

**C07-047 accepted as TEST-CONFIRMED evidence; Gates A–J PASS.** Do not rerun C07-047 absent a newly discovered concrete defect. Advance C07 to adversarial exam, corrections, fresh-AI handoff, promotion/counterfactual audit, and 1000-level graduation decision.
