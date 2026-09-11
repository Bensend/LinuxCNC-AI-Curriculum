# PB-BG-001 run 080 — operator-mode ownership/revocation result

Date: 2026-09-11
Frozen plan: `experiments/PB-BG-001-operator-mode-ownership-revocation-plan.md`
Harness: `lab-jobs/080-pb-bg-001-operator-mode.py`
Retained evidence: `results/PB-BG-001-080-invocation-evidence.csv`
Evidence SHA-256 (LF-normalized repository content): `7a9254d0d4337c2804e300cf403605e2104cc6a2de59290524f5fc419739f3e8`
Result: **TEST-CONFIRMED — frozen Gates A–J 10/10 PASS**

## Execution scope

This was intentionally the smallest deterministic software experiment allowed by the frozen contract. It did not run a motor model, hydraulic model, pressure model, collision model, or functional-safety model. That is a feature, not a missing test: the question was ownership/revocation semantics.

The run retained **47 invocation-level rows** across P0–P6. Every decision-relevant input, owner/state transition, fault reason, reference-valid witness, motion-request witness and auto-resume witness is represented directly in the retained CSV. There is no asynchronous recorder in this harness, so there is no producer/consumer FIFO-loss ambiguity; the invocation table is produced directly by the deterministic state transition execution.

## Pre-authoritative harness correction

An initial in-memory preflight exposed a diagnostic-state presentation bug: `fault_reason` remained populated after successful reconciliation even though the ownership/state transition had completed. This did not affect any frozen ownership gate, but it could mislead later readers about whether an old fault remained active.

The harness was corrected to clear the completed fault episode's diagnostic reason when `RECONCILE` completes, **before retaining the authoritative CSV**. The frozen contract, phases, test stimuli, ownership transitions, and Gates A–J were not changed. This is classified as a harness-output semantics correction rather than a post-result relaxation.

## Frozen gate score

| Gate | Requirement | Result |
|---|---|---|
| A | Maximum one owner each invocation | PASS |
| B | Typed positioning requires valid reference and valid target | PASS |
| C | Continuous jog persists without repeated target/command refresh | PASS |
| D | Ordinary release revokes jog | PASS |
| E | Authorization loss revokes active jog without release | PASS |
| F | Independent jog-stop revokes active jog | PASS |
| G | Feedback, drive and stall-suspect fault reasons remain distinguishable | PASS |
| H | Active-motion faults pass through FAULTED/RECONCILE; no direct interrupted-owner resume | PASS |
| I | `auto_resume_attempted` is false for every retained row | PASS |
| J | Adversarial simultaneous requests never create overlapping owners | PASS |

Score: **10/10 PASS**.

## Discriminating observations

### P0 — reference validity gates typed positioning

Row 1 rejects typed positioning while unreferenced. Homing then becomes the only motion owner and referenced idle is reached only after the explicit completion witness. This proves the abstract contract does not equate a request to home with a valid absolute coordinate frame.

### P1 — hold-to-jog is persistent ownership

Rows 4–6 demonstrate one `JOG_CONT_POS` acquisition, persistence during an invocation with **no repeated jog command**, then ordinary release to idle. This is the intended abstract analogue of the pinned LinuxCNC `EMCMOT_JOG_CONT` free-planner behavior rather than a GUI loop that repeatedly writes targets.

### P2 — authorization loss beats missing button release

The negative jog begins at row 7. Row 8 removes machine authorization while the jog remains logically held: the owner drops to `NONE` and state becomes `FAULTED` in that invocation. Row 9 restores authorization while the press remains held, but no owner reappears. Rows 10–11 reconcile explicitly. Only the later **new** jog request at row 12 acquires ownership.

This is the main adversarial result: stop/revocation does not depend on receiving the ordinary button-release event.

### P3 — independent jog-stop path

Rows 14–15 show `jog_stop_request` revoking an active jog without a UI-release stimulus. The result supports keeping ordinary operator-release semantics and an independent revocation input as separate concepts.

### P4 — fault provenance is not collapsed

The same active-jog surface was subjected separately to invalid feedback, drive fault, and an abstract stall-suspect input. Rows 17, 21 and 25 retain distinct reasons `FEEDBACK_INVALID`, `DRIVE_FAULT` and `STALL_SUSPECT`. The experiment intentionally does not infer the physical mechanism that generated a stall-suspect input.

### P5 — interrupted typed target does not replay

A referenced typed move acquires sole ownership at row 28. Authorization loss at row 29 revokes it. Authorization returning at row 30 does not resurrect the move; reconciliation follows, and row 33 remains idle. A new typed request at row 34 is required to reacquire ownership.

### P6 — conflicts fail closed and reference loss survives reconciliation

Both jog directions together and an invalid typed target produce no owner. A typed request or home request during an existing jog does not create a second owner. An adjacent authorization false→true transition does not auto-resume the held jog. Finally, reference validity is deliberately lost during recovery; reconciliation therefore ends at `UNREFERENCED`, and a subsequent typed position remains denied.

## Verification against pinned LinuxCNC source

The experiment's key semantic assumptions are source-grounded at LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`:

- `emcTaskIssueCommand()` maps the four jog NML commands to distinct jog interface functions.
- `taskintf.cc::emcJogCont()` publishes `EMCMOT_JOG_CONT`; `emcJogStop()` publishes `EMCMOT_JOG_ABORT`.
- `command.c` implements continuous free-mode jog as an enabled free trajectory planner targeted toward the jog limit; it persists after the start command.
- `EMCMOT_JOG_ABORT` disables that planner (or aborts the teleop-axis jog).
- loss of motion authorization/faults sets `emcmotInternal->enabling=0`; the servo-cycle `set_operating_mode()` disable transition clears free planners and aborts teleop jogging without requiring another UI release command.

Detailed source trace: `research/press-brake-backgauge-jog-revocation-source-trace-2026-09-11.md`.

## Adversarial interpretation

A PASS does **not** establish that a real backgauge is safe simply because software ownership is exclusive. The Ursviken field report demonstrates why this distinction matters: a wrong encoder reading can coexist with commanded motor effort and physical hard-stop contact. A production design therefore still needs separately engineered feedback plausibility/stall supervision, commissioning limits, drive/limit behavior, and physical safeguarding.

Nor does this result establish real stopping time or distance. The abstract rule 'same invocation owner drop' is a software-state property of this harness, not a claim about energized hardware response.

## Correction / sufficiency decision

No frozen gate requires correction. PB-BG-001 is **TEST-CONFIRMED for the abstract first-stage operator ownership/revocation contract**.

This is enough to advance 3600 preparation from 'how should manual jog/typed ownership behave?' to the next higher-information question. Do not spend more simulation compute merely adding motor dynamics to PB-BG-001.

## Exact next-work checkpoint

1. Preserve hold-to-jog as native LinuxCNC continuous jog + explicit stop, with independent authorization/fault revocation.
2. Trace **typed absolute backgauge positioning** to choose the clean LinuxCNC surface for first-stage X/R/Z manual entry: compare `JOG_ABS` versus MDI/trajectory positioning, especially homing/reference requirements, soft-limit behavior, completion witness, interruption and ownership implications. Do not choose based only on UI convenience.
3. Inspect any public Ursviken X/R/Z implementation/attachments that can reveal how post-home backgauge commands were actually owned; if final downloadable source remains unavailable after a bounded search, record SOURCE UNAVAILABLE and do not repeatedly search the same thread.
4. Carry the Ursviken stall event forward as a separate fault-supervision requirement; do not contaminate typed-position ownership with invented motor thresholds.
5. F02 remains blocked on genuinely information-separated S02/E20/X01/X02 handoffs; 3600 work remains preparation, not formal specialization graduation.
