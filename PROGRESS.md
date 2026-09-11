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

`LAB_COMPUTE_LOG.md` now includes PB-PREP-001 run 078's exact Actions timestamps: workflow `34569046910`, job `103167029904`, **70.17 min**. Exactly backfilled compute is now **264.14 min (4.40 h)**, with **83.49 min (1.39 h)** exactly backfilled for 2026-09-11 plus explicitly unbackfilled historical usage. Historical gaps and press-brake runs 073–077 still prevent a trustworthy full-project total.

## Dependency-safe 3600 / press-brake preparation

This work is **RESEARCH/SOURCE/EXPERIMENT preparation only** while F02 is blocked. It must not be interpreted as activating or graduating the 3600 specialization.

### PB-PREP-001 — frozen experiment closed INCONCLUSIVE

PB-PREP-001 studies ordinary software architecture for two duplicated-Y joints with independent feedback. P0/P1 construction work was accepted as harness validation only. Behavioral constants and P2–P7 cases were frozen before comparison.

Runs 067–075 are **HARNESS INVALID / compute only** and provide no A/B/C architecture verdict. Their repeated failures triggered the curriculum's three-similar-failure rule rather than blind retrying.

Run 076 flattened the fully generated candidate and passed static construction checks. Its retained `behavioral-rendered.sh` is SHA-256 bound as `7c185fb0af4b056d7e9406de164a79ae6eb30d06510a6b3ce77ed12d46c4a0e6`.

Run 077 timed out after retaining only a complete architecture-A trace, so it could not provide an A/B/C verdict. Run 078 then executed architecture B in isolation from the exact frozen retained render. Workflow `34569046910`, job `103167029904`, source commit `928377ad1a7c70af7032e08dc9b5d30e1d22b16d`, artifact `10188937382` retained a complete **12,000-row** B trace with zero recorder overruns.

Independent raw parsing found P6 had **2,052 rows**, exercised nonzero differential correction (`max(abs(corr_applied)) = 0.126316`), but contained **zero stock-PID saturation rows and zero downstream-final-saturation rows**. The experiment's pre-frozen discriminator explicitly required downstream-only final saturation in valid B/P6 evidence; absence forces **INCONCLUSIVE** and forbids strengthening P6 after seeing the result.

**PB-PREP-001 is therefore closed as INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION under the frozen contract unless a concrete provenance or recorder defect later invalidates retained B evidence.** Running architecture C cannot retroactively create the missing B/P6 discriminator and is not required merely to seek a preferred answer.

Durable audit: `experiments/PB-PREP-001-078-independent-audit.md`.

### Source / architecture findings

Pinned source `8bf4605ae81042248add031e94c77300406e0413` establishes:

- duplicated `trivkins` coordinates fan one Cartesian Y request to every Y-mapped kinematic joint;
- duplicate joints retain independent joint feedback and ordinary per-joint following-error state;
- forward Cartesian Y is reported from the principal/first mapped Y joint rather than averaging/comparing all duplicate Y joints, so Cartesian Y is **not** a Y1/Y2 squareness witness;
- homed LinuxCNC `extra joints` are outside coordinated kinematics, take command from `joint.N.posthome-cmd`, and ordinary motmod following error is explicitly made irrelevant for them after homing.

Therefore duplicated-Y joints and extra joints are not interchangeable tandem-ram architectures. Any 3600 design must explicitly assign common trajectory ownership, independent side truth/fault ownership, differential synchronization authority, and hydraulic-mode ownership.

### Public press-brake implementation/evolution evidence

The public Accurpress build diary now supplies an inspectable real HAL/INI/COMP evolution series rather than forum prose alone:

- April 2021 `accurpress.hal` is a hybrid MOTMOD/custom topology. Physical encoder feedback reaches PID/MOTMOD, but active Y command bypasses `joint.1.motor-pos-cmd`; the press state machine's nominal `brake-pos-fb` is actually driven by `simple_tp.current-pos`, i.e. planner command state rather than physical ram truth. Its addf order also gives the PID a previous-cycle planner command. This is durable evidence that signal names and loaded subsystems do not establish ownership; trace producers and execution order.
- May 2021 `bender.hal` removes MOTMOD/KINS, routes the physical encoder into the press component, and uses `simple_tp.current-pos` as the PID position command. Homing/jogging now become explicit responsibilities of the custom press component. Its addf order still creates one-period state-age boundaries (`press` before `hm2.read`, `hm2.write` before PID).
- April 2022 `bender_2022-04-25.hal` keeps the standalone custom architecture but changes realtime order to **hm2.read -> press -> simple_tp -> PID -> hm2.write**, giving the cycle logic and PID fresh feedback and publishing the same invocation's new controller output. Pressure/tonnage is wired into ordinary control, and the adjacent component contains executable overpressure state logic. Exact adjacent-day HAL/component pairing remains unproven because the HAL expects `press.overload` while the inspected component does not export that pin.
- A 2024 field report from the same builder says the retrofit is used regularly for bending while still mentioning a backstop-homing issue, giving longitudinal community evidence that the custom architecture reached useful operation but did not eliminate generic-motion maintenance burdens.

Durable artifacts:

- `research/press-brake-accurpress-public-config-ownership-audit-2026-09-11.md`
- `research/press-brake-accurpress-architecture-evolution-may-2021.md`
- `research/press-brake-accurpress-2022-stabilization-trace.md`

The current generic layered contract remains appropriate: press-cycle semantics, motion/joint ownership, Y1/Y2 differential synchronization/final allocation, machine-specific hydraulic decoding, electrical/drive interface and functional-safety boundary must be distinguished. Public files provide architecture evidence but no generic valve truth table, coil current, pressure limit or safety claim.

### Public tandem Y1/Y2 field evidence

The Ursviken Pullmax Optima build diary provides the strongest located public real-machine tandem evidence so far. By July 2026 the builder reported replacing hydraulic flow-divider behavior electronically in LinuxCNC/HAL and successfully bending steel with:

- one position PID for Y1;
- one position PID for Y2;
- a separate sync PID commanded to zero with Y1−Y2 as feedback;
- synchronization action that slows whichever side is ahead.

This supports the bounded field conclusion that separate common-side position loops plus a differential synchronization loop can work on a physical press. It does **not** reveal the exact final correction insertion point, command limiting/saturation path, ferror ownership or thread order. The builder said a configuration would be shared after loose ends were resolved, but no final downloadable Y1/Y2 config was found in the inspected diary pages, and a bounded GitHub code search for `pullmax_optima` found no public implementation.

Therefore the Ursviken result is classified **COMMUNITY-REPORTED FIELD SUCCESS / FINAL SOURCE UNAVAILABLE**, not source-confirmed architecture A/B/C evidence. It cannot rescue PB-PREP-001 from its frozen INCONCLUSIVE classification.

Durable artifact: `research/press-brake-ursviken-y1-y2-field-architecture-2026-09-11.md`.

## Exact next-work checkpoint

1. Preserve S02, E20, X01, and X02 as technically accepted / fresh-handoff pending. Do not self-score any prepared fresh-AI packet; **F02 remains blocked**.
2. Preserve PB-PREP-001 as **INCONCLUSIVE / no architecture recommendation**. Do not strengthen P6, alter its thresholds, or run architecture C merely to search for a preferred result.
3. Continue bounded 3600 research for a downloadable **tandem Y1/Y2** configuration. First check later Ursviken/Pullmax posts/attachments after the July 22 success report; if no source is public after a bounded search, record SOURCE UNAVAILABLE and move to a second independent tandem implementation rather than repeatedly searching one thread.
4. For any tandem source found, trace physical scale producers, common side commands, Y1−Y2 producer/sign, exact sync-correction insertion point, all downstream limits/muxes, final-side saturation witness, realtime addf order, per-side following-error ownership, and disable/fault behavior before copying gains.
5. Treat the Accurpress chronology as a 3600 architecture-evolution case study: April hybrid ambiguity -> May standalone ownership correction -> 2022 timing/pressure maturation -> 2024 regular-use report with persistent backstop-homing weakness.
6. Backfill exact Actions runtimes for remaining 073–077 gaps before restating a complete global laboratory-compute total.
7. Once the four genuinely information-separated prerequisite handoffs are valid, mark those modules fully graduated and activate **F02** according to the 2000-level dependency graph. Preserve blind-evaluation separation for delayed retention and the sealed benchmark.