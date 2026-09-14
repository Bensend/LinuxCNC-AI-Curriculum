# 3400 — FENJA/Groot router ATC source audit

Date: 2026-09-14
Status: **REAL CONFIG SOURCE TRACE**
Public machine repository: `GuiHue/myfenjalinuxcnc`
Pinned inspected revision: `16af9ade9484e9f6897b19bd6453ab4bbe79c0ac`
LinuxCNC semantic comparator: course-pinned `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`

## Purpose

Deepen one of the real-router targets already identified by the 3400 breadth survey. The objective is to reconstruct the authority/witness chain around drawbar actuation, rack transfer, tool identity and tool-length measurement rather than treating M6 as one indivisible operation.

## Machine/config surfaces inspected

- `hallib/atc.hal`
- `macros/rack_change.ngc`
- `hallib/io.hal`
- probe/toolchange integration exposed elsewhere in the repository

The configuration uses a Mesa 7i76E, WJ200 VFD, ATC-capable spindle, pneumatic drawbar, rack changer/tool sensor and probing infrastructure.

## 1. Drawbar authority is explicitly shared but arbitrated

`hallib/atc.hal` documents two drawbar command sources:

1. a manual pushbutton on the Z assembly;
2. an automatic request from the M6 remap through a motion digital output.

The config explicitly states that the spindle must stop before drawbar actuation and uses the VFD's `is-running` state as the machine-control witness (`spindle-running`).

The manual button does not directly command the drawbar. It first passes through LUT logic that only permits the manual toggle when spindle-running is false. A second LUT combines the held manual request, automatic request and spindle-running state to produce `drawbar_open`.

### Source-grounded authority flow

`manual button -> spindle-running qualification -> held manual request`

`automatic M6 request -------------------------------> arbitration LUT`

`spindle-running ------------------------------------> arbitration LUT -> drawbar_open`

This is stronger than a simple G-code output because manual and automatic authorities converge before the physical actuator command.

### Boundary

The VFD running bit is an ordinary process/control witness. Nothing in this configuration makes it a safety-rated standstill monitor. The curriculum must preserve the distinction between a useful ATC permissive and independent safeguarding.

## 2. Rack transfer uses machine-coordinate geometry and staged state changes

`macros/rack_change.ngc` performs the M6 remap using custom INI geometry and machine-coordinate moves. The macro separates:

- selected tool and tool-in-spindle;
- source/destination pocket;
- rack pocket versus manual-change fallback;
- safe Z clearance;
- XY rack approach/escape geometry;
- drawbar release/clamp command;
- drawbar sensor state;
- tool-present sensor state;
- logical LinuxCNC tool-state update;
- subsequent tool measurement.

Important ordering for a rack pickup is broadly:

`safe Z -> rack preposition -> staged pocket approach -> spindle-stopped dwell -> drawbar open -> inspect drawbar-open witness -> move into transfer geometry -> drawbar close -> inspect clamp witness -> inspect tool-present witness -> escape rack -> M61 logical tool update -> tool measurement`

The exact geometry is machine-specific, but the separation of **motion, clamp command, clamp witness, tool witness, logical identity, and measured length** is transferable.

## 3. Logical tool identity is deliberately updated after physical pickup checks

The rack path reaches `M61 Q#<newtool>` after the code has:

- closed the drawbar;
- sampled the drawbar state expecting locked/closed;
- sampled the tool sensor expecting a tool present;
- moved away from the rack.

This is a useful provenance discipline: LinuxCNC's logical `tool in spindle` state should not lead the physical transfer without a reason.

The macro still cannot prove retention force or taper cleanliness merely from a binary tool sensor. Preserve that as a physical limitation.

## 4. Tool-length state is separate from M6 state

After tool acquisition the macro proceeds to the fixed tool sensor for measurement. The repository also maps a physical input to `motion.probe-input` and contains G38-based probing macros.

Therefore the machine has at least three distinct post-request states:

1. tool logically selected/requested;
2. tool physically present/clamped;
3. tool length measured/valid for cutting.

Do not collapse these into `M6 done`.

## 5. Pneumatic availability is separately observable

`hallib/io.hal` maps a Festo sensor on the 6-bar air line as an `airpressure` signal. This supports the 3400 breadth-model requirement that ATC pneumatics have a distinct readiness witness.

The bounded inspection here does not yet establish whether every automatic M6 path gates on that signal or how loss of pressure mid-cycle is reconciled. That is a concrete next source question rather than an assumption.

## 6. Important source-vs-comment discrepancy: `M66 L0` is an immediate sample

Several places in `rack_change.ngc` use comments such as:

- check if release was OK "within permissible time";
- report a "Timeout" if the expected drawbar/tool state is absent.

The actual command is `M66 P... L0` after a short G4 dwell.

Upstream LinuxCNC examples explicitly document `M66 ... L0` as an **immediate** input read / queue-busting synchronization. For example, the upstream external-offset `queuebuster.ngc` comments `l0=immediate`.

Thus the actual mechanism is:

`command actuator -> fixed dwell -> immediate input snapshot -> branch on #5399`

not:

`command actuator -> wait for requested edge/state until timeout`.

This is not necessarily an implementation failure: a fixed settling time followed by a snapshot may be deliberate. But the comments should not be interpreted as evidence of a bounded transition-wait contract.

### Engineering consequence

For a robust production ATC, distinguish:

- **settle then sample**;
- **wait for transition with timeout**;
- **continuously supervise state while motion proceeds**.

These provide different fault detection and diagnostic information.

## 7. Recovery remains the important open problem

The macro contains many explicit abort/return paths for wrong clamp/tool sensor state, but the bounded pass has not yet proven a complete reconciliation model after interruption in every physical intermediate state.

Questions for the next pass include:

- what state remains if execution stops with drawbar open at the rack;
- whether `M64/M65` process outputs are reconciled on interpreter abort;
- how logical tool/pocket state is repaired if pickup physically succeeds but M61 is never reached;
- how an operator recovers when a tool is in neither the expected rack pocket nor the spindle;
- whether low air pressure before or during transfer inhibits/reconciles the cycle;
- whether spindle/VFD faults can make the standstill witness stale or unavailable.

These are higher-value than inventing a synthetic ATC simulation at this stage.

## 8. Comparison with AXYZ 4008 field sequence

The older AXYZ 4008 router build diary independently exposes an OEM ATC sequence that checks:

- air-supply pressure;
- spindle zero speed;
- ATC door/dust-foot actuation;
- Z clearance;
- carousel homing/positioning;
- pullstud/drawbar release and purge air.

This corroborates the FENJA lesson that router toolchange is a multi-authority machine sequence, while showing materially different storage mechanics and dust-foot coupling. Do not treat either one as universal.

## Adversarial review — 9/9

1. Can the manual drawbar pushbutton directly bypass the spindle-running condition? **Not in the inspected HAL path; it is explicitly gated.**
2. Does VFD `is-running = false` prove safety-rated zero speed? **No.**
3. Does `M64` drawbar-open command prove the drawbar opened? **No; the macro separately samples a drawbar sensor.**
4. Does the drawbar-closed sensor prove a tool is present? **No; the macro separately samples the tool sensor.**
5. Does tool-present prove the tool length is valid? **No; fixed-sensor measurement is a separate phase.**
6. Does `M66 L0` wait for a transition with timeout? **No; it is an immediate sample.**
7. Do the macro's “Timeout” comments therefore prove a real timeout mechanism? **No.**
8. Does successful M61 establish the physical rack pocket really contains/does not contain the corresponding tool afterward? **Only as software state; full physical inventory provenance is not independently sensed here.**
9. Is interrupted-M6 recovery fully source-proven by this pass? **No; it is the most important next ATC question.**

## Promotion / next work

The 3400 track should now prioritize:

1. complete FENJA M6 abort/recovery and air-pressure qualification trace;
2. a materially different production router implementation with vacuum-table authority and/or dust-collector feedback;
3. spindle/VFD readiness/fault behavior around ATC;
4. gantry homing/squaring comparison;
5. only then a fault-injection experiment if source/config evidence leaves a nonduplicate question about interrupted toolchange state.

No lab was launched in this pass because the real configuration still offers higher information gain.
