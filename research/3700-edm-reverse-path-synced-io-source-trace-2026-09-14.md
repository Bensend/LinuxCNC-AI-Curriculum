# 3700 — EDM reverse-path and synchronized-I/O source trace

Date: 2026-09-14
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: SOURCE / important process-boundary result

## Question

If an EDM gap controller uses negative `motion.adaptive-feed` to back up along the queued toolpath, what happens to synchronized M62/M63/M67 process outputs attached to trajectory segments?

## Reverse-path mechanics

Pinned TP source establishes:

- `tpSetRunDir()` refuses to change direction while TP is still moving;
- the adaptive-feed realtime path therefore forces effective adaptive scale to zero until the planner can accept the new direction;
- once reverse mode is active, each completed TC segment is handled with `tcqBackStep(&tp->queue)` rather than the normal forward `tcqPop()`;
- abort, after motion has stopped, clears the queue and resets `reverse_run=0`.

So reverse operation is genuine backward traversal through retained trajectory segments, not regeneration of a new forward program from a prior coordinate.

## Synchronized output ownership

`tpSetDout()` and `tpSetAout()` cache synchronized output changes in `tp->syncdio`. When the next TC is built, `tpSetupSyncedIO()` copies those changes into that TC's own `syncdio` record.

`tpToggleDIOs(tc)` then applies the values stored on the current TC: for each selected digital output it writes the stored ON or OFF value; analog outputs are similarly segment-associated. The header/source comments describe this as the operation performed when a TC becomes current/taken from the queue.

Crucially, the stored event is the **commanded value for that segment**, not an inverse or prior-state record. The reverse-run code changes queue traversal direction but the inspected synchronized-I/O code contains no reverse-specific inversion/reconstruction operation.

## Consequence for reverse traversal

The bounded source conclusion is:

> Reverse traversal can revisit trajectory segments that carry their originally attached synchronized output commands. Those commands are segment values, not automatic undo records. LinuxCNC's generic TP reverse mechanism does not establish a process-safe inverse chronology for M62/M63/M67 state.

For example, if forward program chronology is conceptually:

`segment A: M62 P0 (ON) -> segment B ... -> segment C: M63 P0 (OFF)`

backstepping through those TCs does not imply a mathematically synthesized inverse sequence such as "restore whatever state existed before A." A revisited segment can only carry the value originally attached to it. Process designers must not assume that adaptive reverse automatically reconstructs spark, flushing, wire, gas, or auxiliary state correctly.

This distinction matters even if repeated writes are idempotent electrically: **idempotent output writes are not equivalent to process-state rollback.**

## Abort boundary

`tpAbort()` explicitly calls `tpClearDIOs(tp)` for already cached/not-yet-attached synchronized I/O. Once the abort has stopped motion, TP clears the queue and resets reverse state. This is different from restoring arbitrary physical process outputs that were already applied earlier; generic trajectory abort is not a complete EDM process-state reconciliation mechanism.

## EDM architecture rule

If negative adaptive feed is used for short-circuit recovery, keep process authority outside the assumption that path rewind equals process rewind. Prefer one of these explicit strategies:

1. keep critical spark/wire/flushing state under an independent realtime process controller rather than trajectory-attached M62/M63 state;
2. define a deliberately reversible output contract and prove every synchronized event is safe when revisited;
3. suppress/reconcile process outputs before backing up and restore them under explicit state-machine authority after the gap recovers.

Do not infer a universal choice from generic LinuxCNC TP behavior.

## Adversarial review

1. Does negative adaptive feed merely run one TC backward? **No; completed reverse segments backstep through the retained queue.**
2. Does TP automatically synthesize inverse DIO commands when traversing backward? **No reverse-specific inversion was found.**
3. Are synchronized DIO events stored as prior-state snapshots? **No; they store commanded ON/OFF values for the TC.**
4. Is rewriting the same bit value electrically harmful by definition? **No; the concern is process chronology/authority, not necessarily electrical idempotence.**
5. Does abort clear pending cached synchronized events? **Yes.**
6. Does TP abort prove already-applied physical outputs return to a process-safe state? **No.**
7. Can EDM safely depend on reverse traversal without a separate spark/fluid/wire recovery contract? **Not established by generic TP source.**

Adversarial result: **7/7 bounded claims survive.**

## Lab decision

A generic reverse/DIO lab is **not required** to establish the architecture boundary: source already shows that reverse traversal and synchronized-output rollback are not equivalent. A future lab is justified only for a concrete proposed EDM output contract where exact transition timing/revisit behavior matters.

## Next work

The highest-value 3700 work is now real wire-EDM process authority: continue the Sodick/other public implementations for actual gap-voltage conditioning, spark enable, wire tension/break, dielectric/flushing readiness and pause/abort recovery. After that source path reaches a clean stop, rotate within 3700 to real grinder implementations rather than over-testing generic TP reversal.
