# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane remains active alongside the safety curriculum. Durable lessons BD01 through BD09 are present. New this run:

- `BD09_STAGED_BOARD_BRINGUP_AND_COMMISSIONING_EVIDENCE.md`

BD09 returns to BOARD INTEGRATION and teaches:

`pre-power inspection -> resistance/short checks -> current-limited staged power -> rail verification -> FPGA/config identity -> one interface at a time -> default/fault challenge -> LinuxCNC/HAL mapping -> machine connection -> commissioning/regression record`.

## BD09 hard student-material audit

Every OpenPressBrake file assigned to students in BD09 was opened and inspected in current `main` form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims made in BD09:

- `hardware/blocks/differential_encoder/engineering.yaml`
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md`
- `hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json`
- `hardware/connections/REV1_ENCODER_CONNECTIONS.yaml`

The reusable encoder package provides a traceable electrical/semantic contract and six-instance FPGA binding. The connection definition explicitly binds the first machine's Y1/Y2/X endpoints to ENC1/ENC2/ENC3 and gives every electrical position a semantic disposition.

The physical commissioning boundary remains intentionally open. Exact connector family/MPN/footprint/mate, placement/orientation, harness compatibility, cable facts, termination selection, and protected encoder field supply are unresolved. `REV1_ENCODER_CONNECTIONS.yaml` remains `board_capture_ready: false`. Current encoder status also leaves abnormal-condition qualification, schematic visual review, PCB integration, synthesis/place-route/timing, board integration and human release open. BD09 therefore does not claim the OpenPressBrake board is ready for fabrication, energization, machine attachment, or production use.

## Catalog stress-test result

The catalog passes an important commissioning-architecture test: reusable receiver engineering, board-specific physical ownership, and FPGA semantic binding can be explained separately without silently moving machine facts into the reusable primitive.

The remaining gaps occur at exactly the expected board/machine boundary and are explicit rather than hidden. BD09 therefore freezes:

- `FIRST POWER SUCCESS != BOARD QUALIFICATION`.
- `FOOTPRINT PRESENT != VARIANT AUTHORIZED`.
- `CURRENT-LIMITED BENCH SURVIVAL != FAULT-PROTECTION QUALIFICATION`.
- `HAL NAME EXISTS != EXPECTED FPGA IMAGE IS LOADED`.
- `LOGICAL FPGA BINDING != ROUTED TIMING PROOF`.
- `SOFTWARE VALUE CHANGED != FIELD ELECTRICAL STATE PROVED`.
- `SEMANTIC PIN MAP COMPLETE != PHYSICAL HARNESS READY`.
- `COMMISSIONED ORDINARY CONTROL != PERSONNEL-SAFETY AUTHORITY`.

No OpenPressBrake engineering file was changed because the discovered gaps require real physical/integration evidence and current board engineering is active.

## Current repository reconciliation

Immediately before BD09, OpenPressBrake `main` had advanced to `e6f01dcc7872fe032cf186fdfc9c2515b4815e0e` (`integration: freeze Pilz valve-enable dual-consumer fanout`). The encoder student-facing files were opened from current main after that advancement. OpenPressBrake was re-read again after the lesson commit; no newer OpenPressBrake commit appeared and no overlapping encoder file was changed during the run.

LinuxCNC-AI-Curriculum advanced independently through safety-course work before BD09. BD09 was created as a new file. This checkpoint was re-fetched immediately before replacement so unrelated safety-lane changes were not overwritten.

## Carried catalog defect from BD06

The digital-input manifest reconciliation defect remains open unless a later OpenPressBrake change closes it: engineering/reference authority withdrew the old universal 500 pF / 6.5 pF parasitic release gate while the machine-readable manifest still carried legacy mandatory fields. Do not use that package as finished capture material until current main is re-inspected and the contradiction is actually resolved.

## Next exact work

Build BD10 as a BLOCK/INTEGRATION bridge on **LinuxCNC / HostMot2 / LiteX-CNC / HAL mapping contracts and end-to-end semantic identity**:

`machine function -> connection definition -> reusable block semantic interface -> FPGA package pin -> FPGA module instance -> transport/register identity -> LinuxCNC driver object -> HAL pin/parameter/function -> physical witness`.

Before naming any OpenPressBrake mapping artifact to students, open its current FPGA module/config, package-pin authority, real-image binding, LinuxCNC/LiteX-CNC mapping/config, and relevant block/connection files. Do not infer software readiness from a binding filename or from BD09. Prefer a bounded channel with an inspectable end-to-end path. If the repository lacks a current LinuxCNC/HAL-side artifact sufficient to close the chain, classify that as a catalog/integration defect and teach the missing-contract boundary rather than inventing HAL names.

The adversarial question is whether a board designer can change a reusable block instance count, FPGA allocation, or board-specific connector without relying on unwritten software mapping knowledge, and can identify exactly which generated/configuration artifacts must change together.

## Compute

No simulation, synthesis, benchmark, or executable verification was justified in BD09. No hosted compute was used.

## Safety boundary

BD09 concerns ordinary controller-board bring-up. The encoder example explicitly receives no personnel-safety credit. LinuxCNC, LiteX-CNC, FPGA logic, normal-controller watchdogs and diagnostics remain outside independent personnel-safety authority unless a separately safety-rated architecture and validation establishes otherwise.
