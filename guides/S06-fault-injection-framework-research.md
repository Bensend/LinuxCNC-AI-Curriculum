# S06 — fault injection framework: research and architecture kickoff

- Module: S06 — fault injection framework
- Course level: 1000
- Status: RESEARCH / SOURCE started
- Prerequisites: S01–S05 graduated
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Learning objective

A fresh AI engineer should be able to choose the correct fault-injection layer, inject one bounded fault without silently replacing the mechanism under test, define an independent oracle and healthy control case before execution, verify recovery, classify invalid harnesses separately from product behavior, and preserve the experiment's safety/non-claim boundary.

S06 is not a catalog of random faults. It is a reusable experiment-design framework for later LinuxCNC modules and capstones.

## Documentation pass

Current official LinuxCNC documentation provides several useful laboratory primitives:

- `halrun` sets up a realtime HAL environment, executes HAL commands/files, and tears the environment down when finished: https://linuxcnc.org/docs/devel/html/en/man/man1/halrun.1.html
- `halcmd` manipulates HAL objects and can execute command files: https://linuxcnc.org/docs/devel/html/en/man/man1/halcmd.1.html
- `streamer` + `halstreamer` can feed typed sample sequences from non-realtime data into realtime HAL pins through a FIFO: https://www.linuxcnc.org/docs/master/html/es/man/man9/streamer.9.html
- `sampler` + `halsampler` can capture realtime HAL values into a FIFO for non-realtime analysis: https://www.linuxcnc.org/docs/master/html/ru/man/man9/sampler.9.html
- the HAL tutorial explicitly presents `halrun` as a way to construct working HAL systems for configuration and tuning: https://linuxcnc.org/docs/html/hal/tutorial.html

These are laboratory mechanisms, not proof that injected behavior is identical to a specific physical fault.

## Community pass

A fresh targeted search for a canonical LinuxCNC "fault injection framework" did not produce a strong upstream/community reference that should be treated as authoritative. That absence is itself useful: S06 should build from LinuxCNC's documented HAL/test primitives and the curriculum's accepted experiments rather than inventing a community-standard framework that is not evidenced.

Existing LinuxCNC community safety discussions from S01/S05 remain relevant only as a boundary: ordinary HAL logic and software fault injection are not equivalent to validation of a safety-rated function or physical fault coverage.

## Source pass — reusable injection primitives

### `src/hal/components/mux2.comp`

Pinned source semantics are minimal and useful for transparent fault routing:

- `sel=FALSE` publishes `in0`;
- `sel=TRUE` publishes `in1`.

S04 successfully used a `mux2` feedback path to switch from live feedback to a held synthetic value without modifying production motion code. This makes `mux2` a good fault-selection primitive when both the healthy and injected values are explicitly observable.

### `src/hal/components/sample_hold.comp`

Pinned source updates `out` from `in` only while `hold` is false. When `hold` is true, the previous output remains unchanged. This is a direct discrete-value freeze primitive, although its pins are `s32`; float feedback freezes therefore need an equivalent float-capable construction such as `mux2` plus an explicit held value or a purpose-built test component.

### `streamer` / `halstreamer`

Documented architecture supplies a realtime output component from a non-realtime FIFO. It is suitable for deterministic precomputed sequences such as jumps, ramps, dropouts represented by sentinel/validity channels, and time-aligned multi-value stimulus. S06 must still distinguish a streamed synthetic sequence from device/transport behavior.

### `sampler` / `halsampler`

Documented architecture captures values in realtime and exports them through a FIFO for non-realtime analysis. This is preferable to repeated userspace `halcmd getp` when same-cycle timing and ordering are part of the oracle.

## Inventory of already accepted curriculum injection patterns

### S03 — HostMot2 LLIO fault beneath HAL

`lab-jobs/013-s03-hostmot2-stale-state.sh` modified only the test fixture (`hm2_test`) to expose mutable LLIO backing state and write capture, then asserted `llio.io_error`. Production HostMot2 host code remained untouched. This is the model for faults that belong below HAL: modify the test double at the hardware abstraction boundary, not the production mechanism whose behavior is being tested.

### S04 — feedback freeze at HAL wiring boundary

`lab-jobs/014-s04-feedback-freeze-single-runtime.sh` used a live/held feedback selector and realtime comparison/sampling while keeping production motion code unchanged. A stationary frozen control was executed in the same runtime before the moving freeze. This is the model for value-path faults: keep the control path intact, inject at one explicit signal boundary, and include a case where the fault should *not* cause the target response.

### S05 — synthetic disagreement and timing assumptions

`lab-jobs/015-s05-disagreement-voter-persistence.sh` drove synthetic HAL inputs through stock production components and froze numerical/persistence acceptance gates before execution. Its deterministic one-cycle skew calculation demonstrates that fault models must include data age/order, not just value corruption.

## Fault-injection layer taxonomy

Every S06/later experiment should identify one primary injection layer before implementation:

1. **HAL value layer** — stuck-at, jump, bias, sign, scale, bounded noise, synthetic validity bit.
2. **Publication/freshness layer** — freeze, delayed update, sequence discontinuity, stale-but-plausible value.
3. **Realtime scheduling/order layer** — intentional one-cycle age skew or changed function order in a test fixture.
4. **Motion feedback interface** — command/feedback decoupling without replacing production motion logic.
5. **HostMot2 LLIO layer** — read/write failure, mutable register image, `io_error`, malformed/invalid fixture data.
6. **Transport layer** — packet loss/delay/reorder only when the actual transport/test harness is preserved sufficiently to support that claim.
7. **Lifecycle/state layer** — restart, recovery, retained state, teardown, reinitialization.

A fault injected at one layer must not be relabeled as evidence about a lower or higher physical layer without independent justification.

## Framework contract for every experiment

Before running, record these fields:

| Field | Required content |
|---|---|
| Mechanism under test | Production function/path that must remain unmodified |
| Injection point | Exact pin/function/test-double boundary |
| Fault model | What is changed, for how long, and at what timing |
| Healthy control | Case proving the harness can behave normally |
| Adversarial control | Case where the injected condition should *not* trigger the target response when logically appropriate |
| Oracle | Observable independent of merely rereading the injected variable |
| Ordering | Relevant realtime function order and sampling point |
| Recovery criterion | What must resume/clear after fault removal |
| Harness-invalid criteria | Startup/topology/timing failures that cannot count against LinuxCNC behavior |
| Product-failure criteria | Predicted behavior that fails despite a valid harness |
| Non-claims | Hardware/safety/version conclusions not established |
| Attempt family | Count materially similar attempts and apply the three-attempt safeguard |

## Oracle hierarchy

Prefer, in order:

1. target subsystem's externally visible state plus an independent realtime capture;
2. production status/fault outputs paired with input/output evidence;
3. test-double side effects only when the behavior under test is specifically at that abstraction boundary;
4. userspace polling only for slow/static behavior where cycle alignment is irrelevant.

Avoid circular oracles. Example: changing a synthetic fault pin and then proving only that the same fault pin changed is not evidence that the subsystem responded.

## Control-case rule

Every fault experiment should include a healthy baseline. When the lesson concerns *detection limits*, also include an adversarial control where the fault exists but the detection predicate should remain false. S04's stationary frozen case and S05's equal wrong common-mode case are templates.

## Recovery rule

Fault removal is not evidence of resynchronization. Define exactly what recovery means at the tested layer: renewed HAL publication, resumed LLIO writes, cleared diagnostic, restored enable, new sequence number, or a deliberate re-home/reinitialize requirement. Do not infer physical actuator state or safety simply because software communication resumes.

## Initial S06 experiment candidate

Build one small HAL-only fixture that demonstrates the framework rather than another subsystem-specific fault:

- healthy source: deterministic ramp/sequence;
- injection selector: `mux2` between healthy value and held/jumped value;
- explicit validity/fault-control pins;
- realtime `sampler` after the observer;
- predeclared cases: healthy baseline, stuck value, single-cycle jump, delayed publication/skew, fault removal/recovery;
- require the experiment artifact to identify which observations prove *injection happened* versus which prove *downstream detection happened*.

The point is not to invent a universal detector. The point is to TEST-CONFIRM that the framework produces reproducible, non-circular injections and evidence traces that later modules can reuse.

## Open questions before experiment freeze

1. Should the first framework fixture use only stock components, or one tiny test-only component that emits value + monotonic sequence together? Prefer stock components unless sequence/freshness evidence cannot be expressed cleanly.
2. Can `streamer` provide a deterministic enough sequence in the hosted userspace realtime lab without making scheduler timing itself the test? If uncertain, use a realtime ramp/counter source and `sampler` first.
3. What minimum artifact schema should every future lab runner preserve automatically (exit code, stdout/stderr, metadata, machine-readable gate summary, raw sampled trace)?
4. Which existing lab-runner limitations should be promoted to framework tooling rather than rediscovered per module?

## Exact next work

Finish the S06 source inventory for `streamer`/`sampler` and the repository lab runner, define the machine-readable result schema, then freeze experiment S06-016 before implementation. The first experiment must include at least one deliberately invalid/circular oracle example in the adversarial analysis so a fresh AI can recognize why it is unacceptable.