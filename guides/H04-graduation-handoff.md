# H04 graduation handoff — HAL execution ordering

Course level: LinuxCNC 1000 foundations

Pinned development revision: `8bf4605ae81042248add031e94c77300406e0413`

## What a fresh AI must know

An exported HAL realtime function does not execute cyclically merely because it exists. `addf` creates an ordered function-entry under a specific HAL thread. The target thread's `thread_task()` walks that list sequentially and directly calls each stored function pointer. This gives a meaningful within-one-thread execution order.

For ordinary HAL dataflow, a later function in the same cyclic pass can observe a value written by an earlier function. Accepted experiment 007 confirmed this with an order-sensitive two-function feedback network: A-before-B produced `B-A=1`; after stopped reconfiguration to B-before-A, the relationship reversed to `A-B=1`.

The ordering guarantee is local to one HAL thread. Each HAL thread has its own RTAPI task. Function positions in two different threads do not form one global list and H04 does not infer a deterministic total order between those tasks.

## Configuration and lifecycle facts

- `halcmd addf` defaults to append (`-1`) and can insert at explicit positive/negative positions supported by `hal_add_funct_to_thread()`.
- A non-reentrant function with `funct->users > 0` is rejected if scheduled again. Lab 007 observed the intended rc=1 diagnostic.
- Deleting a function entry decrements its user accounting through the entry-free path, permitting later re-add. Lab 007 exercised delete/re-add while dispatch was stopped.
- `hal start` / `hal stop` manipulate the shared `threads_running` dispatch gate. They are not per-thread task constructors/destructors.
- `thread_task()` reaches `rtapi_wait()` at the bottom of its loop regardless of whether cyclic function dispatch is enabled.
- In lab 007, threadbeat remained 19→19 while stopped and advanced to 39 after restart, supporting the dispatch-gate model.

## What not to invent

Do not use H04 to claim:

- cross-thread total ordering;
- cross-CPU signal memory visibility semantics;
- deadline, jitter, or physical realtime qualification;
- safe concurrent live `addf`/`delf` mutation while a dispatcher traverses the same list;
- functional-safety guarantees.

The live-mutation question is specifically promoted to 2000/HIGH because configuration mutation takes the HAL mutex while the dispatcher traversal traced at the pinned revision does not take that mutex, and no explicit stopped-thread guard was found in the add/delete path.

## Evidence map

- Intended/source model: `guides/H04-hal-execution-ordering.md`
- Field/community notes: `forum-findings/H04-execution-ordering-field-notes.md`
- Complete call path: `call-flows/H04-addf-to-thread-dispatch.md`
- Experiment: `lab-jobs/007-h04-execution-ordering.sh`
- Accepted result: `lab-results/H04-007-execution-ordering-accepted.md`
- Adversarial exam: `exams/H04-adversarial-exam.md`
- Passing key/correction pass: `exams/H04-adversarial-answer-key.md`

## Fresh-AI sufficiency test

A fresh AI using these artifacts should be able to:

1. distinguish export from cyclic scheduling;
2. reconstruct `addf -> hal_add_funct_to_thread -> thread->funct_list -> thread_task`;
3. predict same-thread producer/consumer behavior from list position;
4. explain why reversing list order can reverse same-cycle dataflow;
5. distinguish stop/start dispatch gating from RTAPI task lifetime;
6. diagnose duplicate non-reentrant scheduling;
7. describe stopped delete/re-add accounting;
8. refuse to infer cross-thread ordering or live-mutation safety from H04;
9. interpret the accepted 007 results without converting a non-realtime CI run into realtime qualification.

The adversarial answer key demonstrates all nine capabilities without an unresolved issue that threatens the 1000-level core conclusion.

## Graduation decision

**H04 GRADUATED at the 1000 level.**

The central within-thread execution-order model is source-confirmed and bounded-test-confirmed. Remaining concurrency/version depth is explicitly promoted and does not block the critical path.

## Next critical-path prerequisite

Proceed to **M03 — one servo-period source-level trace**. Use H04's local thread-order model as a prerequisite, but do not assume the exact motion/HostMot2 function ordering until M03 traces the actual configured servo-thread call chain and source paths.