# T03 adversarial exam — NML command, status, and error boundaries

Status: **PASSED — 10/10 after T03-020 reconciliation**  
Pinned source basis: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Test whether an AI can reason about LinuxCNC command acknowledgement without collapsing command serial/order evidence, semantic controller result, queued operator reports, physical-machine outcome, or safety state into one claim.

## Q1 — echo-is-success fallacy

A client sends a command with serial 57 and later observes `stat.echo_serial_number == 57`. It reports “command 57 succeeded.” Is this valid?

### Required answer

No. The echoed serial proves the command reached the Task/status acknowledgement/order boundary. Pinned Task source publishes the command serial separately from aggregate DONE/ERROR derivation. The client must inspect a matching semantic result; physical and safety claims need still different evidence.

## Q2 — direct negative witness

T03-020 sent `AUTO_STEP` while Task was independently confirmed in ESTOP. The command advanced to serial 3 and status echoed 3, while matching aggregate status and `wait_complete()` were both `RCS_ERROR` and the error channel reported that `EMC_TASK_PLAN_STEP` could not execute until the machine was out of E-stop and turned on. What does this prove?

### Required answer

It proves, on the pinned fixture, that acknowledgement/echo and semantic success are separable: a rejected command can be serialised, echoed and semantically complete with ERROR. It does not prove transport behavior under loss, physical actuation, or safety behavior.

## Q3 — later-serial masking

A client saves serial 10, another producer quickly sends serial 11, and the first client then sees echo 11. Can it infer serial 10 succeeded because the echo passed 10?

### Required answer

No. A greater echoed serial establishes that the shared status boundary progressed beyond 10, not that command 10 semantically succeeded. Pinned `wait_complete()` semantics make later-serial behavior especially dangerous if used without preserving the matching result. Multi-producer clients need command ownership/correlation rules strong enough to prevent later traffic from erasing the evidence needed for the earlier command.

## Q4 — status snapshot versus command queue

The stock NML configuration marks `emcCommand` as `queue confirm_write serial` but does not mark `emcStatus` as a queue. What engineering distinction follows?

### Required answer

Command traffic and status observation have different buffer semantics. A client must not model `emcStatus` as a replayable event log containing one immutable result per command; it is an observed status surface. Exact saturation/drop/reconnect semantics require deeper libnml evidence and are outside the bounded T03 result.

## Q5 — error-channel atomization trap

A client polls `error_channel()` once, receives nothing, and declares the previous command successful. What is wrong?

### Required answer

The error channel is a separate queued reporting surface. An empty poll is not an atomic semantic-success acknowledgement for a command. Semantic DONE/ERROR belongs to the matching controller status evidence; operator-error messages are independent diagnostic evidence and can have separate timing/consumption behavior.

## Q6 — DONE means physical completion?

A command receives matching `RCS_DONE`. May the application assert that a hydraulic valve moved and the machine is safe?

### Required answer

No. `RCS_DONE` is controller semantic completion for the relevant command boundary. Physical actuation, feedback freshness, energy state and functional safety require independent machine/hardware evidence. NML status is not a safety-rated proof channel merely because a command completed successfully in software.

## Q7 — command producer interference

Two UI processes independently issue LinuxCNC commands and both use the global echo serial as their only correlation mechanism. Identify the architecture risk.

### Required answer

They are sharing an advancing command/status serial boundary. One producer can cause the observed echo to pass another producer's saved serial, making naive `echo >= mine` logic ambiguous and potentially masking the earlier command's matching ERROR. A robust integration must control command ownership/serialization or use a correlation design whose semantics are proven for the actual transport/client architecture.

## Q8 — source/documentation wording conflict

Documentation calls `echo_serial_number` the serial of the last command “completed.” An integrator reads “completed” as “succeeded.” How should the AI correct this?

### Required answer

For the pinned implementation, interpret “completed” as processed through the acknowledgement/result boundary, not necessarily successful. Pinned source assigns echo before aggregate status classification, and T03-020 directly observed an echoed command completing with `RCS_ERROR`. Source plus reproducible experiment controls the source-specific interpretation.

## Q9 — reconnect claim

A developer says, “Because local T03-020 proved serial echo works, reconnecting a remote NML client after a TCP interruption cannot lose or confuse command results.” Is that justified?

### Required answer

No. T03-020 used the local pinned fixture and did not test remote NML reconnect, queue saturation, transport loss, stale status after reconnect, or multi-client ordering. Those are promoted questions requiring targeted libnml/network experiments.

## Q10 — novel integration scenario

A custom HMI implements:

```text
send command
wait until echo_serial_number >= sent_serial
turn on green SUCCESS lamp
```

During ESTOP an operator presses AUTO STEP. The lamp turns green although the machine correctly refuses the step. Diagnose and repair the evidence model.

### Required answer

The HMI mistakes acknowledgement/order evidence for semantic success. It should preserve the sent serial, obtain the matching command result and require DONE rather than merely echo progression, handle ERROR as a failed command, and treat operator-error messages as additional diagnostics rather than the success oracle. If other command producers exist, ownership/correlation must prevent later serials from masking the result. The SUCCESS lamp must still not be described as proof of physical actuation or functional safety.

## Passing rubric

Pass requires all of the following:

1. Separate command serial/echo acknowledgement from semantic DONE/ERROR.
2. Explain why a later serial can mask an earlier result in naive client logic.
3. Distinguish queued command, status snapshot and queued error-report surfaces.
4. Refuse to infer physical or safety truth from NML completion alone.
5. Bound T03-020 to the pinned local fixture and promote remote/reconnect/saturation/multi-client questions.
6. Solve Q10 as an evidence/correlation design defect rather than a Task bug.

Any answer that equates `echo_serial_number >= sent_serial` with successful execution is a fail at 1000 level.

## Post-experiment grading

**Score: 10/10 — PASS.**

T03-020 supplied the exam's adversarial case directly: serial 3 was echoed as 3 while the matching aggregate result and `wait_complete()` were `RCS_ERROR`; the independent operator-error stream reported the ESTOP/machine-on prerequisite failure, and no recovery serial was issued until that evidence was preserved.

No correction to the core model was required. The principal correction is terminological: “echoed/completed” must not be used as a synonym for “succeeded.”