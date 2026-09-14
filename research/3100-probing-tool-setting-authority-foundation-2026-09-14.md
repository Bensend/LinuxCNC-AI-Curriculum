# 3100 Probing / Tool-Setting Authority Foundation

Date: 2026-09-14
Status: **SOURCE/DOC FOUNDATION COMPLETE — FIELD IMPLEMENTATION NEXT**
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

## Purpose

Advance 3100 beyond ATC sequencing while field/config evidence remains high-value. Establish the native LinuxCNC probing contract before inspecting production probe/tool-setter macros.

## Native probe input

LinuxCNC G38.x probing uses the HAL input `motion.probe-input` as the contact-state authority.

Pinned documentation defines the electrical/logical convention:

- TRUE = probe contact closed / touching;
- FALSE = probe contact open / not touching.

A real configuration may condition/debounce the physical sensor before that pin; the pin state is still what Motion sees as the probe witness.

## Four G38.x contracts

Pinned documentation explicitly distinguishes:

- `G38.2` — move toward the workpiece, stop on contact, **error if target contact is not achieved**;
- `G38.3` — move toward the workpiece, stop on contact, **no automatic error on failure**;
- `G38.4` — move away from the workpiece, stop on loss of contact, **error if target release is not achieved**;
- `G38.5` — move away from the workpiece, stop on loss of contact, **no automatic error on failure**.

This means `probe move finished` is not one universal semantic. The application must know whether contact or release was the target state and whether the selected G38 variant converts failure into program error.

## Probe-result state

After successful probing, parameters `#5061` through `#5069` contain the controlled-point coordinates at the instant the probe changed state, expressed in the **current work coordinate system**.

After unsuccessful probing, those parameters are instead set to the programmed destination. Parameter `#5070` is the explicit success witness:

- `1` = probe succeeded;
- `0` = probe failed.

Therefore preserve:

**#506x contains a number != probe succeeded.**

A macro that uses G38.3/G38.5 and consumes `#506x` without validating `#5070` can treat the commanded endpoint as though it were a measured surface.

## Coordinate-frame boundary

Probe results are recorded in the work coordinate frame active at the probe event. Pinned docs explicitly warn that conversion to machine coordinates requires the machine/work offset relationship.

This matters for tool setters and persistent tool-table updates:

- a tool setter may be physically fixed in machine coordinates;
- the G38 result is still reported in the active work frame;
- a macro must deliberately reconcile frames before writing an absolute tool-length quantity.

The pinned documentation's tool-height example cancels the active tool length with G49, probes, calculates the relevant offset, writes the tool-table entry with G10 L1, then reactivates tool length with G43. The separation is deliberate.

## Authority decomposition

A production VMC probing architecture should keep at least these states separate:

1. **probe hardware ready/healthy** — stylus/toolsetter physically available and electrical state plausible;
2. **probe input state** — current `motion.probe-input` level;
3. **probe motion request** — G38.x target and direction;
4. **probe event success** — `#5070` / corresponding task result;
5. **captured event coordinate** — `#5061..#5069` in the current work frame;
6. **measurement interpretation** — probe radius, stylus calibration, toolsetter reference height, compensation logic;
7. **persistent data update** — G10/tool-table/work-offset write;
8. **active compensation** — e.g. G43 after the table value is updated.

Do not collapse these into `probe done`.

## Failure/recovery implications

- For G38.2/G38.4, failure halts program execution with an error; recovery must not blindly continue into a table/offset update.
- For G38.3/G38.5, failure does not automatically abort, so the macro is responsible for checking success before trusting the result.
- A probe already in the wrong initial electrical state can invalidate the intended touch/release sequence; production macros should qualify initial state deliberately.
- A stale `#506x`-looking value is dangerous because an unsuccessful probe writes the commanded point there; `#5070` is the necessary discriminator.
- Updating the tool table and activating the new tool offset are separate transactions, just as physical M6 and G43 are separate in the ATC path.

## Adversarial verification

1. **`#5063` changed, therefore Z probing succeeded.** False; unsuccessful probing also leaves a programmed-point value in the probe-coordinate parameters.
2. **G38.3 is safer than G38.2 because it does not error.** Not generically; it shifts failure handling responsibility into the macro.
3. **A fixed machine toolsetter means `#5063` is automatically a machine-coordinate Z.** False; probe results are expressed in the current work frame.
4. **Writing G10 L1 automatically activates the new tool length.** No; active compensation remains separate.
5. **Debounced probe input proves stylus calibration.** No; signal validity and dimensional calibration are separate.
6. **Probe contact state and measurement success are interchangeable.** No; success depends on the requested transition occurring during the commanded move.
7. **A failed G38.3 can safely use the resulting #506x as a measurement if it is numerically plausible.** No; validate `#5070`.
8. **After an interrupted toolchange, tool setting can proceed based solely on logical tool number.** Not defensibly; physical tool identity/security should be reconciled first.

Result: **8/8 boundary checks passed.**

## Lab decision

No lab yet. Native semantics are explicit. The next information gain is a real production probing/tool-setting macro/config, especially one showing input qualification, double-touch strategy, calibration, failure paths and table/offset update handling.

## Next work

Inspect at least one real LinuxCNC VMC/mill probing or tool-setter implementation and trace:

`probe/toolsetter readiness -> initial-state check -> approach -> coarse touch -> retract -> fine touch -> #5070 qualification -> frame/calibration math -> G10/tool-table or work-offset update -> active compensation -> failure/recovery`.

Then compare that path with a second implementation or established GUI workflow before freezing the 3100 probing playbook.
