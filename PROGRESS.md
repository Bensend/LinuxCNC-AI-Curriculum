# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02, E20, X01, and X02 are technically accepted at 2000 level and graduation-pending only deliberately information-separated fresh-AI handoffs.** The current learner must not self-certify those handoffs.

**X02 — synchronized multi-surface diagnostics:** authoritative workflow `34465218660`, job `102832088115`, artifact `10147333312`, passed frozen Gates A–J **10/10** after independent recursive artifact inspection and direct parsing of the retained raw traces. The separately frozen adversarial exam passed **20/20**, including all critical traps. `handoffs/X02-fresh-ai-multi-surface-diagnostics-transfer.md` is PREPARED / UNSCORED.

**F02 remains blocked pending genuinely fresh handoff completion for S02, E20, X01, and X02.** Do not bypass the transfer requirement merely because the technical evidence is strong.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10; BL-DEV-002 VALID 9/10; BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention and the end-of-1000 sealed benchmark remain information-separated obligations. The current learner must not reveal evaluator-side hidden answers to accelerate them.

## D01 closure

Authoritative workflow `34375315740`, job `102546527680`, artifact `10113726545` passed unchanged frozen Gates A–J. Retained evidence had 2,200 contiguous atomic samples with zero producer overruns. `results/D01-006-authoritative-evidence-and-exam.md` records Gates 10/10 PASS and adversarial exam 20/20 PASS.

## S02 technical closure / handoff pending

Pinned source baseline: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`. Authoritative workflow `34395556653`, artifact `10121464851`, passed frozen Gates A–J 10/10; frozen exam 20/20. Fresh-AI handoff remains required.

## E20 technical closure / handoff pending

Independent authoritative workflow `34399792261`, artifact `10123146331`, passed frozen Gates A–J 10/10; frozen adversarial exam 20/20. Transport recovery, HostMot2 watchdog/physical-I/O authority and machine authorization remain explicitly separate. `evaluation/E20-fresh-ai-handoff-packet.md` is READY / NOT YET EVALUATED.

## X01 technical closure / fresh handoff pending

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Source inspection establishes `sampler.c::sample()` as a scheduled realtime producer that snapshots inputs and attempts `hal_stream_write()`. FIFO-full failure drops the recorder record and increments `sampler.N.overruns`. `sampler_usr.c::main()` is the userspace reader. The pinned exported `sampler.N.sample-num` pin is not the value source used by `halsampler -t`; `-t` prints the stream sequence returned by `hal_stream_read()`.

X01-001 reached the three-attempt ceiling and falsified the old stream-tag loss oracle. X01-002 materially redesigned the oracle to producer-overrun + deterministic payload-cycle discontinuity.

X01-002 preflight workflow `34428664862`, job `102719239856`, artifact `10133717168`, runtime 267 s = 4.45 min. First authoritative wrapper attempt `34432706789`, job `102731363601`, failed before LinuxCNC/P0 with a source-rewrite SyntaxError, runtime 8 s = 0.13 min. Corrected authoritative workflow `34436256547`, job `102741829103`, runtime 238 s = 3.97 min, artifact `10136342576`, passed frozen Gates A–J 10/10. P5 retained 10,000 contiguous deterministic rows with zero overruns. `exams/X01-adversarial-answers-and-score.md` records 20/20 PASS. `handoffs/X01-fresh-ai-recorder-integrity-transfer.md` remains PREPARED / UNSCORED.

**Technical sufficiency decision: ACCEPTED at 2000 level; full GRADUATION pending fresh-AI handoff only.**

## X02 technical closure / fresh handoff pending

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Source/call-flow work establishes the publication chain from completed realtime motion status through coherent Task shared-memory copying, Task `EMC_STAT` publication, the NML/RCS status channel, and Python `linuxcnc.stat().poll()`. Motion `heartbeat` and Task `taskbeat` are distinct producer-owned generation witnesses. Python monotonic time is observer time, not producer-generation time. `motion_type` is a state witness, not a generation identifier.

`experiments/X02-001-multi-surface-generation-correlation-plan.md` was frozen before execution in commit `903036d31e8c1e4d114cf43878c96a4e789744d7`.

Preflight attempt 1, workflow `34454522362`, job `102797694203`, artifact `10143051352`, was **HARNESS INVALID** because setup-order allowed samples before intended enable (`depth-before=11`). No behavioral verdict was taken.

Corrected preflight, workflow `34459587342`, job `102813964655`, source commit `08bfb98c411d6d51abb6c72a6992dcb94ea2d290`, artifact `10145085665`, was a valid non-authoritative preflight and passed frozen Gates A–J 10/10.

The separate unchanged authoritative wrapper ran from source commit `717fdd0179006d7b5ee27c6a32a5bd8b39816728` as workflow `34465218660`, job `102832088115`, artifact `10147333312`. Exact job runtime was 222 s = **3.70 min**. Independent recursive artifact inspection confirmed the complete raw evidence nested under `run-34465218660-1/x02-053-preflight-evidence/`; the earlier shallow listing concern was therefore resolved rather than treated as a retention defect.

Independent parsing found:

- exactly **20,000** realtime rows;
- `depth-before=0`;
- producer overruns before/after = **0/0**;
- zero stream-tag gaps and zero deterministic payload-cycle gaps;
- **7,046** Python observations with no backwards Task or motion-heartbeat movement;
- **4,908** P1 adjacent observations with increasing observer time and unchanged `taskbeat`;
- **522** adjacent observations showing Task/motion generation deltas are not one-for-one;
- **2,126** equal-`motion_type` adjacent cases while at least one generation witness advanced;
- **93** P3 slow-observer adjacent pairs that skipped more than one producer generation, with representative Task/motion deltas near `(47,51)`, `(47,50)`, `(46,49)`;
- identical ordered nonduplicate HAL/Python motion-state sequences `[0,1,0,2,0,1,0,2,0]` without claiming same-cycle timestamp identity.

`results/X02-001-authoritative-audit-and-sufficiency.md` records frozen Gates A–J **10/10 PASS** and the counterfactual sufficiency review. `exams/X02-adversarial-exam.md` was frozen before answers in commit `b46ddbb0aa0420053701a56aae360e32115187f9`; `exams/X02-adversarial-answers-and-score.md` records **20/20 PASS**. No central correction was required. The exam reinforces that slow-consumer heartbeat jumps are skipped observations—not proof of skipped realtime execution—and equal state is never freshness evidence.

`handoffs/X02-fresh-ai-multi-surface-diagnostics-transfer.md` is **PREPARED / UNSCORED**. It contains a novel layered-diagnostics scenario and must be evaluated by a genuinely information-separated learner/evaluator.

**Technical sufficiency decision: ACCEPTED at 2000 level; full GRADUATION pending fresh-AI handoff only.**

## Compute checkpoint

`LAB_COMPUTE_LOG.md` now includes exact job timestamps for all three X02-001 runs. Exactly backfilled compute is 135.07 min (2.25 h), with 21.07 min (0.35 h) exactly backfilled for 2026-09-10 plus explicitly unbackfilled historical usage.

**Later compute-ledger integration exists beyond this stale X02-era subtotal. Do not use the 135.07-minute figure as the current global total.** The press-brake harness series through 072 was separately reconciled at 193.97 min exact backfilled compute; 073 onward still require exact Actions-time integration before the global subtotal is restated here.

## Dependency-safe 4600 / press-brake preparation

This work is **RESEARCH/SOURCE/EXPERIMENT preparation only** while F02 is blocked. It must not be interpreted as activating or graduating the 4600 specialization.

### PB-PREP-001

PB-PREP-001 studies ordinary software architecture for two duplicated-Y joints with independent feedback. P0/P1 construction work was accepted as harness validation only. Behavioral constants and P2–P7 cases were frozen before comparison.

Runs 067–075 are **HARNESS INVALID / compute only** and provide no A/B/C architecture verdict. Their repeated failures triggered the curriculum's three-similar-failure rule rather than blind retrying.

Run 076 flattened the fully generated candidate and passed static construction checks. Its retained `behavioral-rendered.sh` is SHA-256 bound as `7c185fb0af4b056d7e9406de164a79ae6eb30d06510a6b3ce77ed12d46c4a0e6`.

Candidate 077 executes exactly that retained render as workflow `34557828294`, job `103134175120`, source commit `8d01d2dab5823ed0fcf43ef944b98f266343cb8a`. An independent raw-evidence audit was frozen while 077 was still executing, before seeing its behavioral result. A further audit-only temporal-alignment correction was frozen before results after source inspection showed `prepare -> PID -> finish -> sampler`, with synthetic plant state advanced inside `finish`; controller-law checks must therefore reconstruct the pre-update plant state rather than treating same-row post-update `y1/y2` as simultaneous controller inputs. No experiment parameter, threshold, gate, or classification rule changed.

The frozen discriminator remains: if a valid architecture-B P6 trace does not contain downstream final saturation while corresponding stock PID saturation is false, the result is **INCONCLUSIVE** and must not be retuned.

### Source / architecture findings

Pinned source `8bf4605ae81042248add031e94c77300406e0413` now establishes:

- duplicated `trivkins` coordinates fan one Cartesian Y request to every Y-mapped kinematic joint;
- duplicate joints retain independent joint feedback and ordinary per-joint following-error state;
- forward Cartesian Y is reported from the principal/first mapped Y joint rather than averaging/comparing all duplicate Y joints, so Cartesian Y is **not** a Y1/Y2 squareness witness;
- homed LinuxCNC `extra joints` are outside coordinated kinematics, take command from `joint.N.posthome-cmd`, and ordinary motmod following error is explicitly made irrelevant for them after homing.

Therefore duplicated-Y joints and extra joints are not interchangeable tandem-ram architectures. Any 4600 design must explicitly assign common trajectory ownership, independent side truth/fault ownership, differential synchronization authority, and hydraulic-mode ownership.

Community research across public Accurpress, proportional-valve retrofit, and Ursviken Pullmax work reinforces an architecture question rather than a generic hydraulic recipe: successful/evolving builds repeatedly separate motion ownership from press-cycle/hydraulic sequencing, and real manifolds may include nested valve-amplifier loops plus discrete routing/mode valves. These reports remain community evidence and do not establish machine-specific valve sequencing or safety suitability.

Durable current artifacts include:

- `research/press-brake-motion-ownership-extra-joints-vs-duplicated-y-2026-09-11.md`
- `research/press-brake-duplicated-y-command-feedback-source-trace-2026-09-11.md`
- `research/press-brake-community-architecture-evolution-2026-09-11.md`
- `research/press-brake-layered-interface-contract-draft-2026-09-11.md`
- `experiments/PB-PREP-001-077-independent-audit-freeze.md`
- `experiments/PB-PREP-001-077-audit-temporal-alignment-correction.md`

The layered draft deliberately separates press-cycle coordination, motmod/joint motion, Y1/Y2 synchronization/final ordinary allocation, machine-specific hydraulic decoding, nested electrical/drive interfaces, and an external functional-safety boundary. It deliberately supplies no generic valve truth table, coil current, pressure limit, or safety claim.

## Exact next-work checkpoint

1. Preserve S02, E20, X01, and X02 as technically accepted / fresh-handoff pending. Do not self-score any prepared fresh-AI packet; **F02 remains blocked**.
2. When PB-PREP-001 candidate 077 completes, download/inspect its retained raw evidence and independently score the already frozen provenance, topology, recorder, phase, disturbance, ferror, final-saturation, recovery/disable and architecture-specific gates. Apply the pre-frozen temporal-alignment correction for control-law reconstruction. Do not accept generated `analysis.txt` alone.
3. If 077 is construction/recorder invalid, take no behavioral verdict. If valid but B/P6 lacks the frozen downstream-only saturation witness, classify **INCONCLUSIVE**. Do not strengthen P6 or tune thresholds after seeing results.
4. Continue 4600 research by locating at least one downloadable public press-brake HAL/COMP/config set and mapping it against the layered ownership contract. Keep physical valve sequencing and functional safety machine-specific.
5. Backfill exact Actions runtimes for 073 onward before restating the global compute total in this file.
6. Once the four genuinely information-separated prerequisite handoffs are valid, mark those modules fully graduated and activate **F02** according to the 2000-level dependency graph. Preserve the blind-evaluation separation for delayed retention and the sealed benchmark.
