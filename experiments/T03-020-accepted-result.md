# T03-020 — accepted result

Status: **TEST-CONFIRMED / ACCEPTED**  
Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Harness/source commit: `0877652c3fe82722d99d81616c07a864ac3ae418`  
Workflow run: `34182846956`  
Authoritative job: `101925247534`  
Lab exit: `0`  
Lab UTC: `2026-09-08T03:14:59Z` to `2026-09-08T03:18:25Z` in preserved result metadata

## Frozen prediction

Before implementation, T03-020 predicted that `command.auto(AUTO_STEP)` while independently confirmed in ESTOP would still receive a new command serial and be echoed by Task, but the matching semantic result would be `RCS_ERROR` and the separate error channel would report that the state-inappropriate command could not execute.

The prediction was tested without modifying frozen Gates A-G.

## Authoritative observations

The accepted workflow artifact and repository result record:

```text
gate-A=PASS
case1-base-serial=0 case1-serial=1 case1-echo-after-send=1
case1-wait-complete=1
gate-B=PASS
gate-C=PASS
case2-pre-serial=2 case2-serial=3 case2-echo-after-send=3
gate-D=PASS
case2-wait-complete=3 matching-status=3 matching-echo=3
gate-E=PASS
case2-error=(11, 'command (EMC_TASK_PLAN_STEP) cannot be executed until the machine is out of E-stop and turned on')
gate-F=PASS
case2-echoed=true
case2-semantic_success=false
gate-G=PASS
trace-rows=213 error-events=1
T03-020 overall=PASS
```

The raw CSV preserves the decisive sequence before recovery:

```text
0.110895,case2,pre-send,2,2,1,1,1,2,1,,,
0.131051,case2,send-return,3,3,3,1,1,2,1,,,
0.141141,case2,wait-complete,3,3,3,1,1,2,1,3,,
0.141167,case2,error-channel,3,3,3,1,1,2,1,,11,command (EMC_TASK_PLAN_STEP) cannot be executed until the machine is out of E-stop and turned on
...
2.146310,case2,pre-recovery,3,3,3,1,1,2,1,,,
2.186629,recovery,wait-complete,4,4,1,2,1,2,1,1,,
```

Here the pinned constants reported by the harness were `RCS_DONE=1`, `RCS_ERROR=3`, `STATE_ESTOP=1`, and `AUTO_STEP=3`.

## Gate reconciliation

### Gate A — PASS

The job cloned and checked out pinned upstream `8bf4605ae81042248add031e94c77300406e0413`, built the pinned runtime, and reported the LinuxCNC Python module from that RIP tree. Harness source commit was `0877652c3fe82722d99d81616c07a864ac3ae418`.

### Gate B — PASS

Case 1 began from ESTOP, generated new serial `1`, status echo reached `1`, and the requested ESTOP_RESET state was observed without an attributable operator rejection.

### Gate C — PASS

Case 1 `wait_complete()` returned `1 == RCS_DONE`, in addition to the independent state observation. Echo alone was not used as the completion oracle.

### Gate D — PASS

After restoring and independently confirming ESTOP, Case 2 advanced the saved command serial from `2` to `3`; Task/status echoed `3`. This proves the command reached the acknowledgement/order boundary but nothing more.

### Gate E — PASS

Before any later serial, the matching serial-3 aggregate status was `3 == RCS_ERROR` and `wait_complete()` returned `3 == RCS_ERROR`.

### Gate F — PASS

The independent error channel emitted one attributable operator-error tuple stating that `EMC_TASK_PLAN_STEP` could not execute until the machine was out of E-stop and turned on.

### Gate G — PASS

The harness explicitly recorded `echoed=true` and `semantic_success=false`; the negative evidence remained preserved through `pre-recovery` at serial 3. Only afterward did a benign recovery command advance to serial 4 and complete with `RCS_DONE`.

## Source reconciliation

Pinned `src/emc/usr_intf/axis/extensions/emcmodule.cc` explains the client behavior: `emcSendCommand()` writes the command, saves its serial, and returns after the status echo reaches that serial or later. `emcWaitCommandComplete()` is a separate predicate: matching serial returns only `DONE` or `ERROR`; a greater serial is treated as DONE for the older saved boundary.

Pinned `src/emc/task/emctaskmain.cc` explains the receiver behavior: each Task cycle publishes the current command's serial into both Task and top-level `echo_serial_number`, then derives aggregate `RCS_STATUS` independently from plan/execute/subordinate errors and execution/interpreter state. A planning error can therefore coexist with an echoed serial.

The test is a direct runtime witness of exactly that branch separation.

## Documentation correction / terminology

Current Python-interface documentation describes `echo_serial_number` as the serial of the last command that was "completed." T03-020 shows why `completed` must not be read as **succeeded**. At this boundary an invalid command can be processed/acknowledged, echoed, and complete with `RCS_ERROR`.

For engineering use, the safer vocabulary is:

- **echoed / acknowledged command boundary** — serial/order evidence;
- **matching aggregate result** — DONE/ERROR controller semantic evidence;
- **operator error channel** — independent diagnostic/report evidence;
- **physical/safety outcome** — requires separate evidence outside NML acknowledgement.

## Failure-path lesson

A client that grades `echo_serial_number >= command.serial` as command success will falsely accept the Case-2 command. A client that also checks a matching `RCS_ERROR` result correctly rejects it. A client that relies on one empty error-channel poll is also unsound because the error channel is separately queued/consumed.

## Evidence boundary

T03-020 verifies this command/status/error separation for the pinned LinuxCNC userspace NML/Task path in the software fixture. It does **not** establish remote-NML loss/reconnect behavior, exact queue saturation/drop semantics, multi-client ordering correctness, realtime motion completion, physical actuation, feedback freshness, or safety-rated behavior.

Those deeper transport/concurrency questions are promotion candidates rather than implied conclusions of this test.
