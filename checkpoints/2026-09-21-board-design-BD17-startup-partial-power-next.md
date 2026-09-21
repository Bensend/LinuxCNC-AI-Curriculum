# Board-design curriculum checkpoint — BD17

Date: 2026-09-21  
Lane: independent LinuxCNC/OpenPressBrake board-design curriculum

## Completed

Created `hardware/4000-board-design/BD17_STARTUP_RESET_PARTIAL_POWER_AND_DEENERGIZED_STATE_CONTRACTS.md` at commit `cc7dd3ae633b5550384116108ce52f259111443f`.

BD17 teaches:

`power absent -> partial rails -> reset asserted -> configuration -> configured but inhibited -> enabled -> watchdog/fault -> brownout -> recovery -> power-down`

It extends BD04/BD05 by treating lifecycle and partial-power behavior as a reusable-block contract across inputs, outputs, and compute/control blocks rather than only an output fail-off question.

## Student-facing verification

Current artifacts opened directly during the run:

- OpenPressBrake `hardware/blocks/digital_output_24v/manifest.yaml`
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/blocks/digital_input_24v/manifest.yaml`
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/manifest.yaml`
- Curriculum `hardware/4000-board-design/BD04_DEFAULT_STATE_OUTPUT_AUTHORITY_WATCHDOG_AND_FAULT_CONTAINMENT.md`
- completed BD17 itself, re-opened from current `main` after creation

They are `VERIFIED_FOR_LESSON` only for the bounded claims used in BD17. They are not proof that the complete OpenPressBrake controller is released.

## Adversarial findings

1. Lifecycle behavior must distinguish survivability, signal validity, and output authority.
2. The current digital-output contract already contains useful `power_off_state`/`watchdog_state` requirements, and current first-machine status identifies field-side pull-down OFF authority, but every brownout/hot-plug/back-power sequence is not yet qualified.
3. The FPGA core has a strong fail-low ordinary-control pattern: hardware output authorization depends on power-good, reset, watchdog, and FPGA DONE and has no FPGA/software bypass.
4. The current digital-input contract is rich in normal electrical/transient behavior but lacks an equally explicit field-only/logic-only/ramp-down/signal-valid/back-power lifecycle matrix. This is a concrete catalog defect, not permission for the integrator to infer behavior from `isolated`.
5. Hot-plug must be reviewed as a partial-power transition including mating order, clamp paths, external powered devices, and signal validity.
6. Brownout recovery requires separate proof from steady reset/default behavior.
7. A future machine-readable lifecycle object should carry domains, default mechanism, reset/unconfigured state, enable ownership, watchdog response, partial-power behavior, unpowered-input limits, back-power paths, brownout/recovery, hot-plug assumptions, validity/authority criteria, evidence, and regression triggers.

## Durable freezes

- `NORMAL-OPERATION CONNECTIVITY != STARTUP/SHUTDOWN CONTRACT`.
- `SURVIVES PARTIAL POWER != SIGNAL VALID != OUTPUT AUTHORIZED`.
- `DECLARED DEFAULT STATE != QUALIFIED EVERY-SEQUENCE BEHAVIOR`.
- `SOFTWARE CANNOT BE THE ONLY AUTHORITY THAT DISABLES OUTPUTS BEFORE SOFTWARE/FPGA STATE IS VALID`.
- `GALVANIC ISOLATION AT ONE SIGNAL PATH != NO BACK-POWER PATHS ANYWHERE IN THE COMPLETE BLOCK/BOARD`.
- `FAIL-LOW DURING STEADY RESET != PROVED GLITCH-FREE BROWNOUT/RECOVERY`.
- `HOT-PLUG IS A PARTIAL-POWER STATE TRANSITION`.
- `LIFECYCLE/PARTIAL-POWER BEHAVIOR BELONGS IN THE REUSABLE BLOCK CONTRACT; CROSS-BLOCK SEQUENCING BELONGS TO BOARD INTEGRATION`.
- `ORDINARY-CONTROL FAIL-LOW BEHAVIOR != PERSONNEL-SAFETY AUTHORITY`.

## OpenPressBrake interaction

No OpenPressBrake engineering file was modified. Immediately before the checkpoint, OpenPressBrake `main` remained `4a4da2ee928706d09229cb9a8c4f6647ad722a4a` (`integration: audit Rev1 CORE low-voltage load contracts`). The active board-development lane is currently changing core/machine-power integration, so BD17 records the lifecycle-schema/catalog defect without racing that work.

No executable verification was justified. Missing partial-power/hot-plug/brownout evidence cannot be manufactured by rerunning an unchanged model. Future executable work remains restricted to `[self-hosted, openpressbrake]`.

## Exact next work — BD18

Build a **whole-board partial-power and back-power matrix** from current block and integration contracts.

Re-read current main in both repositories first. Open every student-facing artifact directly. Trace at least:

`machine 24V -> switched field domains -> core 5V -> 3V3/2V5/1V1 -> FPGA configuration/watchdog -> service USB/VBUS detect -> isolated I/O field supplies -> encoder/analog field supplies -> proportional power -> externally powered machine devices`

For each cross-domain signal, identify source, sink, powered/unpowered combinations, clamp/protection path, return, possible phantom-power path, signal-valid condition, output-authority consequence, and evidence status. Include fault-created combinations that normal startup never intends.

Treat missing block lifecycle contracts as explicit catalog defects rather than filling the matrix from intuition. Keep independent personnel-safety authority outside the ordinary controller. If executable verification is genuinely required, use only `[self-hosted, openpressbrake]`; otherwise leave physical cases open for bench/machine qualification.