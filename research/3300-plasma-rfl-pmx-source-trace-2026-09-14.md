# 3300-P3 continuation — Run From Line and PowerMax RS485 source trace

Date: 2026-09-14

Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`

Status: **SOURCE-CONFIRMED PRODUCTION/RECOVERY CONTRACT ADVANCED**

## 1. Run From Line is explicit state reconstruction

Pinned source: `lib/python/plasmac/run_from_line.py`.

`run_from_line_get()` scans both the selected-line tail and all lines before the selected line. It reconstructs state from the prefix rather than assuming the interpreter and plasma process can safely begin from arbitrary text position.

State collected from the prefix includes:

- units (`G20` / `G21`);
- cutter-compensation state (`G40`, `G41.1`, `G42.1`);
- path-control state (`G61`, `G61.1`, `G64...`);
- linear distance mode (`G90` / `G91`);
- arc distance mode (`G90.1` / `G91.1`);
- latest motion type and X/Y position;
- current material request (`M190...` or embedded temporary-material definition) plus its `M66 P3` acknowledgement wait;
- relevant parameter definitions beginning with `#`;
- spindle/torch-start state (`M03` / `M05`);
- torch enable/disable scheduling state on digital output P3 (`M62/M63/M64/M65 P3`);
- THC enable/disable scheduling state on P2 (`M62/M63/M64/M65 P2`);
- velocity-reduction state on analog output E3 (`M67/M68 E3 Q...`);
- current cut-feed expression using `#<_hal[plasmac.cut-feed-rate]>`;
- whether the requested restart point is inside a subroutine.

The source refuses the normal RFL construction when cutter compensation is active or the selected point is inside an open subroutine context.

## 2. RFL preamble construction

`run_from_line_set()` builds a new RFL program. The preamble re-emits collected state before appending the requested tail.

Important reconstruction steps include:

1. restore saved parameters;
2. restore units, compensation/path-control and distance modes;
3. emit `M52 P1`;
4. restore torch-enable state P3;
5. restore THC state P2;
6. restore E3 velocity state;
7. move Z near the machine maximum with a machine-coordinate `G53 G00 Z...` expression appropriate to current units;
8. restore material request and its material-change wait if present;
9. restore the material-derived feed expression if present;
10. create a safe/reconstructed XY entry and restart torch/spindle command in relation to the selected first motion, optionally with a lead-in;
11. append the selected-line tail while suppressing a duplicated first M03 where the reconstructed start has already emitted it.

This is strong source evidence that Run From Line is **state synthesis**, not merely interpreter line seeking.

## 3. RFL authority boundary

Even after the generated RFL preamble restores G-code/process command context, it does not itself prove physical plasma state.

The handoff remains:

`historical G-code prefix`
`-> run_from_line.py reconstructed modal/process intent`
`-> generated rfl.ngc`
`-> interpreter/motion`
`-> plasmac realtime pierce/Arc OK/THC state`
`-> physical plasma feedback`.

The runtime still has to establish a new valid realtime cutting episode. Reconstructed `M62/M63`, `M67`, material and M03 state are command provenance, not physical witnesses.

## 4. RFL and external-offset cut recovery are separate tools

`run_from_line.py` reconstructs program context before execution. `plasmac.comp` separately contains realtime paused-motion and `CUT_RECOVERY_ON/OFF` states that use X/Y external offsets around an interrupted kerf.

Do not collapse them:

- Run From Line = regenerate/re-enter program with recovered modal/process command context;
- cut recovery = realtime machine-relative positioning/reconciliation during an interrupted job.

A production HMI should expose which recovery class is active.

---

## 5. PowerMax RS485 component is explicitly userspace/non-realtime

Pinned source: `src/hal/user_comps/pmx485.py`.

The component is a Python HAL userspace component using a serial port at 19200 baud, 8 data bits, even parity, one stop bit and a 0.1 s serial timeout.

Its HAL interface separates desired settings from reported values:

Inputs:

- `pmx485.mode_set`;
- `pmx485.current_set`;
- `pmx485.pressure_set`;
- `pmx485.enable`.

Outputs:

- reported `mode`, `current`, `pressure`;
- `fault`;
- connection `status`;
- current/pressure min/max limits;
- accumulated arc-on time.

This confirms a command-vs-feedback distinction even inside the non-realtime PowerMax communications layer.

## 6. PowerMax remote/local ownership

Enabling communications triggers `open_machine()` which writes remote mode, desired current and desired pressure. Disabling invokes `close_machine()` which writes zeros for mode/current/pressure before closing communications and clearing status.

The userspace component therefore owns **remote-setting authority** while enabled, but it is not the realtime torch-state owner.

The Plasma CNC Primer separately warns that the slow communications path is not suited to changing these settings on the fly during cutting.

## 7. PowerMax communication-health logic

The main loop alternates writes/reads and obtains:

- mode;
- current;
- pressure;
- fault code;
- low/high arc-time registers.

`pmx485.status` becomes true only when the expected set of reads/writes succeeds for the cycle. Failed transactions increment `errorCount`.

After more than three accumulated bad communication iterations, the source:

1. clears status;
2. marks the session not started;
3. calls `close_machine()`;
4. closes the serial port;
5. sleeps briefly and permits the outer enable logic to attempt reconnection.

An exception path also attempts to return the PowerMax to local/closed state.

**Important bounded claim:** this is communication-loss handling for remote parameter control. It is not evidence that `pmx485.status` is a functional-safety permissive or that a communications fault independently removes plasma energy. Torch and Arc OK authority remain in the realtime plasma/wired process path.

## 8. Command acknowledgement semantics

A write is accepted by `write_register()` only when the received reply exactly echoes the transmitted write packet. Reads require packet structure and LRC validation.

The component then copies successfully written desired values into the feedback pin surface, or reads current register values when no change is pending.

Therefore:

`*_set request -> Modbus ASCII transaction -> validated reply/read -> HAL reported setting/status`

is the appropriate communication evidence chain.

Do not interpret GUI desired amps/pressure as proof that the PowerMax accepted them unless the communications/reporting layer is healthy.

## 9. Diagnostics surfaces to preserve

A production QtPlasmaC HMI/playbook should keep distinct:

- selected material number and recipe source;
- desired PowerMax mode/current/pressure;
- reported PowerMax mode/current/pressure;
- PMX connection `status`;
- PMX fault code;
- allowed min/max ranges;
- realtime `plasmac` state;
- realtime Torch On / Arc OK / arc voltage;
- THC enabled versus active;
- Run-From-Line/recovery state.

This prevents a common failure of diagnosing a communications/configuration defect as a realtime plasma fault, or vice versa.

## Adversarial review — 8/8 passed

1. **'Run From Line just starts interpreting at the selected source line.'** Rejected: source explicitly reconstructs prefix modal/process state and generates a new file.
2. **'RFL can safely start in active cutter compensation or an arbitrary subroutine.'** Rejected: the source returns an error for these contexts.
3. **'RFL restoring M03 proves an arc already exists.'** Rejected: it restores command intent; realtime Arc OK still must be established.
4. **'Cut recovery and Run From Line are the same recovery mechanism.'** Rejected: one reconstructs a program; the other uses realtime external offsets.
5. **'PowerMax RS485 is realtime because it has HAL pins.'** Rejected: it is a Python userspace serial component.
6. **'Writing desired amperage is proof the source accepted it.'** Rejected: the component validates protocol replies/reads and exposes separate set/reporting surfaces.
7. **'Loss of pmx485 status is the machine safety stop.'** Rejected: source only proves remote-communications recovery/localization; realtime energy/safeguarding authority is separate.
8. **'PowerMax comms failure is unrecoverable without restarting LinuxCNC.'** Rejected: the loop closes the failed session and can retry while enable remains requested.

## Promotion / next-work effect

P3 no longer needs a generic 'what does Run From Line restore?' search or a generic 'is pmx485 realtime?' search.

Highest-value P3 continuation is now:

1. exact `qtplasmac_gcode.py` hole/overcut transformation and representative before/after examples;
2. current CAM post inspection to identify which layer emits M190/P2/P3/E3 patterns;
3. real `pmx485` field failure/recovery history, especially serial adapter reliability and whether production users explicitly gate cycle start on PMX status;
4. reconcile those findings into the cross-layer diagnostics playbook.

No lab was launched; this source trace directly resolves the present uncertainty.
