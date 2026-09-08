# T03-020 — NML acknowledgement versus semantic result

Status: **FROZEN BEFORE IMPLEMENTATION**  
Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Independently verify that LinuxCNC NML command acknowledgement/order, semantic Task acceptance, aggregate command completion/error, and operator error reporting are separate evidence streams.

The experiment must demonstrate both:

1. a valid command whose saved Python serial is echoed and whose requested controller state is independently observed; and
2. a source-confirmed state-inappropriate command whose NML write/echo succeeds but whose Task semantic result is ERROR with an independently captured operator error report.

## Source-derived predictions frozen before implementation

Pinned `emcmodule.cc` predicts that `emcSendCommand()` records the sent command serial and waits for `EMC_STAT.echo_serial_number` to reach that serial or later. Pinned `emcWaitCommandComplete()` predicts that a matching serial returns only when aggregate status is DONE or ERROR; a status serial greater than the saved serial returns DONE for the older command object's boundary.

Pinned `emctaskmain.cc` predicts that Task treats a command as new when command serial differs from status echo, then at cycle end publishes the command serial into top-level/task echo fields even if planning failed. Aggregate status becomes ERROR when `taskPlanError` is set.

Pinned Task state/mode dispatch predicts that `EMC_TASK_PLAN_STEP` is rejected while machine state is ESTOP/OFF/ESTOP_RESET with an operator error saying the command cannot be executed until the machine is out of E-stop and turned on. Pinned Python `command.auto(AUTO_STEP)` constructs exactly `EMC_TASK_PLAN_STEP`.

Therefore the negative-case frozen prediction is:

> `command.auto(AUTO_STEP)` while ESTOP will obtain a new Python command serial and Task will publish an echo at that serial, but the matching aggregate result will be ERROR and the error channel will report the state-inappropriate command. Echo alone must not be graded as success.

## Fixture

Use the stock pinned `tests/linuxcncrsh/linuxcncrsh-test.ini` simulation/RIP environment or an equivalently minimal stock fixture that exposes the normal `emcCommand`, `emcStatus`, and `emcError` channels. No physical hardware is involved.

Create distinct Python objects:

- `linuxcnc.command()`
- `linuxcnc.stat()`
- `linuxcnc.error_channel()`

Before each test case, drain already-pending error-channel messages and record a baseline status poll.

## Case 1 — healthy command

Starting from normal startup ESTOP state, send `command.state(linuxcnc.STATE_ESTOP_RESET)`.

Record, with monotonic timestamps:

- pre-send top-level/task status and Task state;
- Python command `serial` immediately after the send method returns;
- status `echo_serial_number` and task echo if exposed;
- `wait_complete()` return;
- Task state until ESTOP_RESET is independently observed;
- any error-channel tuples.

Then return the fixture to `STATE_ESTOP` and independently verify that state before Case 2.

## Case 2 — semantically rejected command

While independently confirmed in ESTOP, call:

```python
command.auto(linuxcnc.AUTO_STEP)
```

Record the same evidence fields plus every error-channel tuple observed for a bounded post-command interval.

Do not start a program and do not turn the simulated machine ON for the negative case.

## Frozen gates

### Gate A — provenance
PASS only if source/build provenance matches pinned LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`, the Python module resolves inside that pinned build, and the exact harness commit is recorded.

Ambiguous provenance is **HARNESS_INVALID**.

### Gate B — valid baseline and command identity
PASS only if Case 1 begins from independently observed ESTOP, `STATE_ESTOP_RESET` produces a new saved Python command serial, status echo reaches that serial or later, and Task state independently becomes ESTOP_RESET without an error-channel rejection attributable to the command.

### Gate C — valid command completion evidence
PASS only if Case 1 `wait_complete()` returns `RCS_DONE` for the saved command boundary and the independently polled requested Task state is observed. A matching echo alone cannot satisfy Gate C.

### Gate D — rejected command still acknowledged
PASS only if Case 2 begins from independently observed ESTOP, `AUTO_STEP` produces a new saved Python serial, and top-level status echo reaches that serial or later.

This gate deliberately establishes transport/acknowledgement only. It is **not** semantic success.

### Gate E — rejected command semantic failure
PASS only if, for the Case-2 command boundary, aggregate status is observed as `RCS_ERROR` and/or `wait_complete()` returns `RCS_ERROR` before any later command is issued. No later command may be sent until this gate's raw evidence is captured, preventing a greater serial from masking the matching ERROR case.

### Gate F — independent operator-error evidence
PASS only if the error channel independently yields an operator error attributable to the invalid `EMC_TASK_PLAN_STEP` state/mode condition. Text matching may normalize localization/punctuation but must preserve the semantic cause: the command cannot execute while E-stop/machine-off conditions prohibit it.

### Gate G — no false success / bounded recovery
PASS only if the harness explicitly reports that Case 2 had `echoed=true` and `semantic_success=false`, the machine remains in the expected non-running ESTOP state, and the controller can still process a subsequent benign recovery/status command after the negative evidence has been preserved.

## Adversarial checks

The harness must report and reject these invalid inferences:

1. `echo_serial_number >= command.serial => command semantically succeeded` — **FALSE** by design.
2. `command method returned => requested machine action completed` — **FALSE** without the command-specific status predicate.
3. `no error tuple on one poll => command succeeded` — **FALSE**; the error channel is a separate asynchronously consumed stream.
4. `wait_complete()==DONE => physical action is proven` — **FALSE**; the result is controller/NML aggregate evidence at this boundary.
5. `echo > saved serial` in a multi-producer system proves the old command's own semantic completion — **not established**; the pinned Python helper treats it as DONE, which is precisely why concurrency provenance matters.

## Raw evidence requirements

Preserve a machine-readable or CSV/JSON trace including at minimum:

- monotonic timestamp;
- case identifier;
- client saved serial;
- top-level echo serial;
- task echo serial if exposed;
- top-level `status`;
- task status;
- Task state/mode/exec/interp state;
- `wait_complete()` return and timestamp;
- every error-channel `(type,text)` tuple with timestamp;
- no hidden reduction that discards the matching ERROR sample before a later serial is sent.

## Failure classifications

- channel/startup/provenance failure: **HARNESS_INVALID**;
- Python API cannot expose enough matching serial/status evidence due harness design: **HARNESS_INVALID**, improve observability without weakening gates;
- rejected command's serial is echoed but aggregate ERROR/error report appear as predicted: candidate PASS, reconcile all gates;
- rejected command is echoed and reports DONE/no rejection under the pinned fixture: **SUBSTANTIVE MISMATCH**, investigate source/runtime assumptions before rerun;
- changing the negative command, acceptance semantics, or gates after seeing runtime output starts a new attempt family.

## Evidence boundary

A passing experiment verifies pinned LinuxCNC userspace NML/Task communication semantics in a software fixture. It does not verify remote-NML network loss behavior, realtime motion transport, physical actuation/feedback, or safety-rated behavior.
