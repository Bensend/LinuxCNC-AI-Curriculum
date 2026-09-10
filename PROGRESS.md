# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02**, **E20**, and **X01** are technically accepted at 2000 level and graduation-pending only deliberately information-separated fresh-AI handoffs. The current learner must not self-certify those handoffs.

**X02 — synchronized multi-surface diagnostics is the highest-priority unblocked technical module and remains SOURCE/CALL-FLOW active.** Pinned source tracing at `8bf4605ae81042248add031e94c77300406e0413` establishes the generation chain from realtime motion status through Task publication to Python `linuxcnc.stat().poll()`. `call-flows/X02-multi-surface-status-publication.md` records the source trace. `research/X02-nml-freshness-community-doc-crosscheck.md` now records the official-documentation and community cross-check.

F02 remains blocked by completion/acceptance of S02, E20 and X02. S02/E20/X01 graduation labels remain pending genuinely fresh handoffs, but independent technical work may continue where the dependency graph requires technical acceptance rather than fresh-handoff graduation.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10; BL-DEV-002 VALID 9/10; BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention and the end-of-1000 sealed benchmark remain information-separated obligations. Do not inspect evaluator-hidden answers from the learner role merely to satisfy cadence.

## X01 technical closure / fresh handoff pending

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Authoritative X01-002 workflow `34436256547`, job `102741829103`, retained artifact `10136342576`, passed frozen Gates A–J 10/10 after independent raw-artifact inspection. The frozen adversarial exam passed 20/20. The corrected X01 contract treats producer overrun + deterministic sampled payload discontinuity as recorder-loss evidence; contiguous `halsampler -t` tags alone are not a complete producer-loss oracle. `handoffs/X01-fresh-ai-recorder-integrity-transfer.md` remains prepared / UNSCORED.

Technical sufficiency: ACCEPTED at 2000 level; full GRADUATION pending fresh-AI handoff only.

## X02 source/call-flow and research checkpoint

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

Source tracing establishes:

- realtime `control.c` completes `update_status()`, increments `emcmotStatus->heartbeat`, and commits status coherence with `tail = head`;
- userspace `usrmotReadEmcmotStatus()` copies shared motion status and accepts only `head == tail`, retrying a split read at most three times;
- `emcMotionUpdate()` maps the completed motion heartbeat into `EMC_STAT.motion.heartbeat`;
- Task increments `task_beat`, maps it into `EMC_STAT.task.taskbeat`, updates aggregate status and publishes with `emcStatusBuffer->write(emcStatus)`;
- Python `linuxcnc.stat().poll()` peeks the RCS status channel and memcpy-copies the published `EMC_STAT` into its local object.

Official documentation independently identifies `taskbeat` as the Task main-loop heartbeat and says its rate is determined by `[TASK]CYCLE_TIME`; the Python interface is documented as polling the NML status channel. Current INI documentation describes TASK as communicating with UIs over NML and realtime motion over non-HAL shared memory. A 2021 community report of `peek()` sometimes returning no new status while polling is retained only as a field lead, not a timing guarantee.

Thus motion heartbeat and taskbeat are distinct generation witnesses owned by different loops. Python poll time is observer time, not realtime production time. A new Task generation can legitimately contain the same motion heartbeat; multiple motion generations can occur between Task/Python observations. Wall-clock nearest-neighbor alignment alone is insufficient evidence of same-cycle or causal correspondence.

X02 inherits X01's evidence-validity boundary: correlation is not trustworthy for intervals where recorder producer health, witness continuity, lifecycle, provenance, or thread order cannot establish usable coverage.

## Exact next-work checkpoint

1. Preserve S02, E20 and X01 as graduation-pending fresh-AI handoff; do not self-certify.
2. Continue X02 as highest-priority work.
3. Before freezing X02-001, select a software-only status value with an objectively traceable production path at the pinned revision. Trace that value from realtime/HAL production through motion status, Task/NML publication, and Python exposure.
4. Freeze X02-001 only after defining the deterministic fixture and predeclaring phases/rates/gates. Python must record `(observer monotonic time, taskbeat, motion heartbeat, selected status value)` while an independent X01-valid realtime/HAL recorder captures deterministic payload-cycle and recorder-health witnesses.
5. Deliberately exercise at least: repeated Python observations of one Task generation; Task-generation advance without assuming one-for-one motion advance; motion-generation skips between slower userspace observations; and invalid/uncertain recorder intervals.
6. Gates must use generation/witness relationships, never nearest-wall-clock matching as proof of simultaneity. Carry forward X01 invalidity rules: unresolved overrun, payload discontinuity, reader truncation, unknown topology/thread order, or provenance loss makes that interval unusable/uncertain for correlation.
7. F02 remains blocked pending S02 fresh handoff, E20 fresh handoff and accepted X02 contracts. Preserve delayed-retention/sealed-benchmark information separation.
