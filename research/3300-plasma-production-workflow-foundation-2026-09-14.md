# 3300-P3 — QtPlasmaC production workflow foundation

Date: 2026-09-14

Status: **DOCUMENTATION/SOURCE FOUNDATION — production workflow pass started**

Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`

## Purpose

Separate the production-plasma layers that are often collapsed into 'the G-code': material recipe authority, CAM/postprocessor intent, QtPlasmaC filtering, synchronized process commands, realtime `plasmac.comp` authority and machine-state recovery.

## Material authority and provenance

QtPlasmaC's selected material carries process parameters including, depending on configuration:

- material thickness;
- kerf width;
- pierce height and delay;
- cut height;
- cut feed rate;
- cut amperage;
- cut voltage;
- puddle-jump height/delay;
- pause-at-end;
- gas pressure;
- cut mode.

The persistent material set is stored in the machine material configuration file. Some values are merely operator/display information unless corresponding power-source communication is configured: for example Cut Amps is visual-only without PowerMax communications, while gas pressure and cut mode are only active through that communications path.

**Boundary:** a material record is process intent/configuration. It is not proof that the physical plasma source accepted the setting, that the currently loaded consumables match it, or that the realtime cut has reached its requested state.

## G-code material selection handshake

Official QtPlasmaC documentation defines the common sequence:

```text
M190 Pn
M66 P3 L3 Q1
F#<_hal[plasmac.cut-feed-rate]>
```

Semantics:

- `M190 Pn` requests material number `n`;
- the following `M66 P3 ...` waits for QtPlasmaC's material-change acknowledgement surface;
- feed is then taken from the active material's `plasmac.cut-feed-rate` HAL value.

The wait matters. A CAM/post request to change material and the controller's confirmed active material are separate states.

`qtplasmac_gcode.py` also creates temporary material entries for supported embedded material definitions and emits the same material-change/wait pattern.

## CAM/postprocessor versus controller authority

The Plasma CNC Primer describes the ordinary chain as CAD -> CAM -> G-code -> controller. SheetCam, Fusion and other posts may own or influence:

- nesting/order;
- lead-ins and lead-outs;
- kerf-side geometry;
- hole/small-feature strategy;
- material-number selection;
- synchronized THC inhibit;
- feed reduction;
- torch-off/overcut timing.

QtPlasmaC then filters and validates the incoming program and `plasmac.comp` owns realtime process sequencing.

The resulting authority chain is:

`CAD geometry`
`-> CAM/process intent`
`-> postprocessor G-code/material commands`
`-> QtPlasmaC G-code filter/validation`
`-> LinuxCNC interpreter/trajectory`
`-> plasmac realtime process state`
`-> synchronized process outputs + Motion external offsets`
`-> physical machine/process feedback`

A defect in any layer must not be diagnosed as though all layers were the same controller.

## QtPlasmaC G-code filtering is active processing

Pinned `src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py` is not a transparent file pass-through. It:

- loads material information;
- identifies current material and cut type;
- rejects or warns on process-affecting constructs;
- prevents ordinary G92 behavior for standard QtPlasmaC workflow;
- tracks torch-enable state;
- tracks hole/overcut state;
- can generate temporary material selections;
- records pierce extents;
- modifies/restores velocity commands around special features;
- emits a marked filtered G-code file.

Run-from-line files take a separate path and are not simply re-filtered like an ordinary newly loaded source program.

## Z authority in normal production G-code

Official QtPlasmaC documentation states that standard plasma cut programs do not need Z motion. Standard QtPlasmaC filtering removes Z-axis references from the cut program, and QtPlasmaC/process logic owns probe/pierce/cut/retract Z behavior through the external-offset path documented in P1.

Therefore a postprocessor should not be taught to fight the realtime height controller by generating conventional cutting Z moves unless the configuration intentionally invokes a documented special/multi-tool exception.

## Synchronized THC inhibit

The plasma primer documents the conventional digital-output contract:

- `M62 P2` — disable THC, synchronized with motion;
- `M63 P2` — enable THC, synchronized with motion;
- immediate M64/M65 variants exist but are a different timing class.

This lets CAM/post intent bracket geometry such as holes while preserving exact path-event timing.

**Boundary:** the M-code expresses scheduled intent. `plasmac.comp` still owns whether THC is actually active because THC additionally depends on process state, Arc OK/voltage qualification, cut velocity, delay/stability, corner/void locks and fault state.

## Synchronized velocity reduction

QtPlasmaC uses `motion.analog-out-03` as a feed-reduction request. Documentation gives:

- `M67 E3 Q0` -> restore 100% requested cut velocity;
- `M67 E3 Q40` -> use 40% requested cut velocity.

Pinned `qtplasmac_gcode.py` tracks hole behavior and can append `M67 E3 Q0` when restoring normal velocity after special arc/hole processing.

**Boundary:** M67 is a trajectory-synchronized analog-output event. It is not itself the realtime THC algorithm. The P1 source then consumes the resulting feed-reduction/adaptive-feed state along with actual velocity for THC/corner-lock qualification.

## Torch inhibit / overcut surface

Pinned filter and run-from-line code recognize digital output P3 as the torch-enable scheduling surface:

- `M62 P3` represents synchronized torch disable in this workflow;
- `M63 P3` represents synchronized torch enable.

This supports strategies such as hole overcut where path motion may continue after plasma energy is removed.

Again, the scheduled output and physical torch state remain separate: `plasmac.comp` has its own `torch_enable`, `torch_on`, Arc OK and fault logic.

## Run-from-line and recovery are not ordinary restart

Pinned source includes dedicated `lib/python/plasmac/run_from_line.py`, while `plasmac.comp` separately contains paused-motion and cut-recovery state using X/Y external offsets.

The practical contract is therefore stronger than 'start interpreter at line N':

- the controller must reconstruct relevant modal/process context;
- material/process command state may need restoration;
- QtPlasmaC recovery may reposition relative to the interrupted kerf using external offsets;
- the physical source/process state still has to become valid before cutting resumes.

A later P3 pass should trace `run_from_line.py` end to end and preserve exactly which M-codes/material states it reconstructs.

## PowerMax RS485 boundary

The Plasma CNC Primer describes PowerMax RS485 integration as a non-realtime communications path used for settings such as amps, pressure and cut mode. It explicitly notes that the communications path is too slow to treat as an on-the-fly realtime process loop.

Thus:

`material desired amps/pressure/mode -> userspace/non-realtime PowerMax communication`

is separate from:

`realtime torch/Arc OK/THC/motion state`.

Communication health should be visible diagnostically, but successful RS485 telemetry is not a substitute for realtime Arc OK or independent safeguarding.

## Consumables and HMI state

QtPlasmaC exposes statistics, current material parameters, machine log and PowerMax statistics when available. Those are valuable production diagnostics, but none alone prove consumable correctness. Consumable identity/condition can remain an operator/process-maintenance fact unless the real power source exposes reliable machine-readable evidence.

Production playbook surfaces should therefore distinguish:

- selected material/recipe;
- commanded power-source settings;
- communications health;
- measured arc/process feedback;
- current realtime process state;
- consumable maintenance/statistics;
- recovery/run-from-line state.

## Adversarial review — 7/7 passed

1. **'M190 means the material is already active.'** Rejected: the documented sequence includes an acknowledgement wait before using the selected material feed.
2. **'The CAM material/tool entry is the physical process state.'** Rejected: it is upstream recipe intent; source acceptance, consumables and realtime process state remain separate.
3. **'M62 P2 turning THC off means Z external offset must immediately return to zero.'** Rejected: THC-enable scheduling and already-applied external offset cleanup are distinct contracts.
4. **'M67 E3 Q40 is a THC command.'** Rejected: it schedules feed reduction; THC consumes actual/requested velocity as one qualification input.
5. **'QtPlasmaC is only a GUI and the CAM file reaches LinuxCNC unchanged.'** Rejected: the pinned G-code filter performs material, process, feature and validation transformations.
6. **'Run From Line can be modeled as jumping the interpreter to the requested line.'** Rejected: QtPlasmaC has dedicated process reconstruction/recovery code and realtime cut-recovery state.
7. **'PowerMax RS485 can be the realtime cut-control loop because it sets amps and pressure.'** Rejected: official plasma documentation describes it as a non-realtime/relatively slow communication path.

## Remaining P3 work

1. trace `run_from_line.py` and QtPlasmaC handler reconstruction of material, torch/THC/feed-reduction state;
2. source-trace exact hole/overcut transformations in `qtplasmac_gcode.py` with example input/output;
3. inspect at least one current SheetCam/Fusion QtPlasmaC post to identify which layer emits M190, M62/M63 and M67 patterns;
4. inspect `pmx485` source/handler integration and communication-loss diagnostics;
5. connect material provenance and power-source communication failures back to the two/three P2 machine diaries.

## Lab decision

No lab yet. Documentation, pinned filter source and real field reports are currently yielding higher information gain. A lab should be frozen only if the remaining source trace leaves a timing/recovery ambiguity that executable evidence can resolve without duplicating existing LinuxCNC synchronized-output tests.
