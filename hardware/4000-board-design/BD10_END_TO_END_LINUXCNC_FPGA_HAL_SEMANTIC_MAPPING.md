# BD10 — End-to-End LinuxCNC / FPGA / HAL Semantic Mapping

## Purpose

A board is not integrated merely because a field signal reaches an FPGA pin, and it is not commissioned merely because a LinuxCNC value changes. This lesson teaches the BOARD INTEGRATION chain:

`machine function -> board-specific connection definition -> reusable block semantic interface -> FPGA package pin -> FPGA module instance -> transport/runtime identity -> LinuxCNC driver/HAL object -> physical witness`

The adversarial question is simple: **can the complete chain be reconstructed from durable authority without filling gaps from memory?** If not, the missing mapping is an integration/catalog defect.

## Hard student-material audit

The following current OpenPressBrake files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims made here:

- `hardware/blocks/differential_encoder/engineering.yaml`
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md`
- `hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json`
- `hardware/connections/REV1_ENCODER_CONNECTIONS.yaml`
- `hardware/blocks/fpga_core_ecp5_25/integration/rev31_litexcnc_rev1_proven_modules.json`
- `hardware/blocks/fpga_core_ecp5_25/integration/rev32_openpressbrake_litexcnc_binding.json`
- `hardware/blocks/fpga_core_ecp5_25/integration/rev30_litexcnc_rev1_image_contract.json`

These files are instruction-ready for teaching semantic ownership, physical package binding, module configuration, Etherbone transport intent, stale-authority detection, and open evidence gates. They are **not** evidence that the complete current OpenPressBrake field-to-HAL chain is production-qualified.

Important current limitations found by inspection:

1. `REV1_ENCODER_CONNECTIONS.yaml` still has unresolved connector family/MPN/footprint/mate, harness, placement, cable and termination facts; `board_capture_ready` is false.
2. The encoder status leaves cable/termination, protected +5 V field power, abnormal-condition qualification, schematic review, PCB integration and final release open.
3. `rev31_litexcnc_rev1_proven_modules.json` is explicitly a proven-module/provenance source. Its proportional entries are superseded by the MAX22216 rebase and must not be treated as current production proportional authority.
4. `rev32_openpressbrake_litexcnc_binding.json` explicitly says the production MAX22216 SPI transaction/register engine remains open and local synthesis/P&R/timing evidence is still required.
5. `rev30_litexcnc_rev1_image_contract.json` is older authority: its own runtime proportional topology and Rev27 physical-pin references predate the current Rev29/MAX22216 architecture. It is useful here only to teach revision/evidence boundaries, not as current proportional production authority.
6. The inspected current repository artifacts close the encoder chain through the configured LiteX-CNC `encoder_1`...`encoder_6` instances and Etherbone connection intent, but they do **not** durably freeze the exact current LinuxCNC driver-created HAL pin/parameter names for those encoder instances. Those names must not be invented from memory or naming resemblance.

Therefore the bounded encoder example is `VERIFIED_FOR_LESSON` through the FPGA module/transport-intent boundary. The exact driver/HAL-name segment is `ENGINEERING_REVIEW_NEEDED` / `INCOMPLETE_NOT_STUDENT_MATERIAL` until pinned driver/configuration evidence closes it.

## 1. Mapping is a chain of authorities

For every machine-facing function, build a row for each layer:

| Layer | Question | Authority class |
|---|---|---|
| machine endpoint | What physical device/function is this? | machine configuration / measured evidence |
| connection block | Which connector/pin/return/label owns it? | board-specific connection definition |
| reusable block | What electrical function and semantic interface consumes/produces it? | reusable block contract |
| FPGA package | Which semantic net reaches which package ball? | package/pin binding |
| FPGA module | Which configured module instance consumes/produces that pad? | FPGA image/module configuration |
| transport/runtime | How is that module exposed to the host? | runtime/transport contract |
| LinuxCNC driver | Which driver instance discovers/creates the host-side object? | pinned driver/config evidence |
| HAL | Which exact pin/parameter/function name and direction exist? | generated/runtime or pinned driver evidence |
| physical witness | What controlled stimulus/measurement proves the mapping? | bench/machine test evidence |

No layer is allowed to silently substitute for another.

Freeze:

`SEMANTIC CONTINUITY != NAME RESEMBLANCE`

## 2. Worked encoder chain — what current authority really proves

For the first installed Y1 encoder, current authority can establish this bounded chain:

`Y1 ATEK machine channel`

→ board-specific `J_Y1_SCALE` connection definition

→ differential pairs A/Abar, B/Bbar, Z/Zbar owned by reusable `differential_encoder/ENC1`

→ receiver single-ended semantic outputs `ENC1_A`, `ENC1_B`, `ENC1_Z`

→ ECP5 balls `A15`, `A14`, `B14`

→ LiteX-CNC configured instance `encoder_1` consuming A/B/Z

→ OpenPressBrake runtime connection intent using Etherbone

→ **exact LinuxCNC driver/HAL object name: NOT FROZEN BY THE INSPECTED CURRENT ARTIFACTS**

That final gap is not permission to guess `encoder.1`, `litexcnc.encoder.1`, or any other plausible string. A student must stop at the last proved boundary.

The same method applies to ENC2 and ENC3. ENC4–ENC6 are reusable logical capacity in the inspected binding; do not silently turn them into installed machine encoders.

Freeze:

`FPGA MODULE INSTANCE NAME != PROVED HAL PIN NAME`

## 3. Physical signal names and software names solve different problems

A good reusable block uses semantic electrical names such as `ENC1_A`; a board-specific connection definition uses physical/human names such as `Y1 ENCODER`; FPGA configuration may use `encoder_1`; LinuxCNC/HAL may expose a different driver-defined naming convention.

Do not force all layers to share one string merely to make tracing convenient. Instead preserve explicit translation edges.

A translation edge should state:

- source namespace and identifier;
- destination namespace and identifier;
- direction;
- owning artifact/revision;
- evidence state;
- whether the mapping is one-to-one, indexed, transformed, or aggregated.

This is more reusable than embedding `Y1` into the electrical primitive.

## 4. Transport is part of the chain

The inspected Rev31 module configuration specifies an Etherbone connection intent, including board address information. The newer Rev32 binding retains the pinned LiteX-CNC RGMII/Etherbone path while replacing the donor Colorlight platform with the independently recreated OpenPressBrake platform.

That proves architectural transport intent. It does not prove that a particular running LinuxCNC host reached the intended board, loaded the expected driver/configuration, or created the expected HAL objects.

At commissioning, record at minimum:

- board/image identity;
- host configuration identity;
- transport endpoint identity;
- driver/module identity and revision;
- discovered board/runtime identity when available;
- exact HAL objects actually created;
- controlled field stimulus and observed software response.

Freeze:

`ETHERNET REACHABLE != EXPECTED FPGA IMAGE/DRIVER MAPPING PROVED`

## 5. Detect stale authority before mapping

The current OpenPressBrake artifacts provide a strong example. Rev31 preserves valuable proven GPIO/encoder/stepgen provenance, but Rev32 explicitly rejects/transforms its obsolete six-PWM and per-channel proportional-driver GPIO topology before production parsing because the board moved to two MAX22216 devices on shared SPI.

A mapping exercise that simply reads Rev31 and maps `proportional_1` through `proportional_6` into HAL would resurrect a rejected architecture.

Likewise, Rev30 is useful historical/runtime-contract evidence but still names the older proportional resources and Rev27 physical pin contract. Newer Rev32 authority explicitly states the current MAX22216 boundary and its remaining SPI-engine work.

Freeze:

`OLDER COMPLETE-LOOKING CONFIG != CURRENT PRODUCTION AUTHORITY`

## 6. HAL direction is not field direction

Students must record direction separately at each layer. A machine encoder is physically an input to the controller. The receiver output is an FPGA input. A host-side HAL object may expose values, parameters, enables, reset/index controls, or functions whose HAL directions are defined by the driver—not by the field connector arrow.

Never infer HAL `in`/`out`/`io` from connector direction alone. Inspect the pinned driver or generated runtime objects.

## 7. Mapping outputs requires a physical witness

For an ordinary digital output, a complete mapping would not end at a HAL command bit. It must continue through:

`HAL command -> runtime register/module -> FPGA semantic output -> package ball -> isolation/driver -> board connection pin -> field voltage/current/load state`

and it must include default/watchdog/output-permission behavior from BD04.

A HAL bit going false does not prove the physical output de-energized. A physical measurement without image/driver identity does not prove the intended software channel controls it.

Freeze:

`HAL COMMAND STATE != PHYSICAL OUTPUT STATE`

## 8. Mapping inputs requires controlled stimulus

For an encoder, a useful witness progresses from electrical to logical:

1. apply a controlled differential stimulus at the intended connector/interface under a bounded bench setup;
2. verify the receiver output semantic net;
3. verify the intended FPGA module instance changes;
4. inspect the exact runtime-created HAL object after its name/direction is proved from current driver/config evidence;
5. verify quadrature/index behavior appropriate to the bounded test;
6. only after physical connector/cable/termination/supply gates close, repeat with the installed machine endpoint.

Do not use machine motion as the first mapping test merely to discover which software channel changes.

## 9. Machine-readable mapping should fail closed

A mature board project should eventually be able to validate a mapping record such as:

```text
machine_endpoint: Y1_ATEK
connection: J_Y1_SCALE
primitive_instance: differential_encoder/ENC1
semantic_fpga: [ENC1_A, ENC1_B, ENC1_Z]
package_balls: [A15, A14, B14]
fpga_module: encoder_1
transport: etherbone
linuxcnc_driver_object: TBD_CURRENT_DRIVER_EVIDENCE
hal_objects: TBD_CURRENT_DRIVER_EVIDENCE
physical_witness: TBD_BENCH_THEN_MACHINE
```

A validator should reject rather than auto-complete missing HAL names, connector identities, or machine facts.

## 10. Catalog stress-test result

The reusable-block/connection-block architecture survives the encoder trace well through the electrical and FPGA layers. Machine-specific Y1/Y2/X identity stays outside the reusable receiver, and FPGA package allocation stays outside the field connector mold.

The stress test exposes a real integration documentation gap: the inspected current artifacts do not provide a durable exact mapping from the current LiteX-CNC encoder module instances through the LinuxCNC driver to exact HAL pin/parameter/function names. That gap should be closed with pinned driver/configuration or captured runtime evidence, not by teaching remembered names.

**Catalog/integration action item:** add a machine-readable host-runtime/HAL binding artifact that pins the LiteX-CNC/LinuxCNC driver revision/configuration and records exact generated HAL objects for each supported module class. The artifact should reference, not duplicate, FPGA package and connection-block authority. It should be validated against a captured/generated runtime inventory where practical.

This run does not modify OpenPressBrake because current board engineering is active and the missing HAL mapping requires authoritative driver/runtime evidence rather than an inferred documentation patch.

## Lab — close one field-to-HAL trace without guessing

Using only current artifacts that you personally open and verify:

1. choose one ordinary-control machine endpoint;
2. identify its board-specific connection definition;
3. trace its reusable block semantic interface;
4. trace the semantic net to FPGA package pin;
5. identify the configured FPGA module instance;
6. identify transport/runtime authority;
7. locate pinned LinuxCNC/LiteX-CNC driver evidence for exact host/HAL naming;
8. if step 7 cannot be proved, mark the chain `BLOCKED_AT_HOST_RUNTIME_MAPPING` rather than inventing names;
9. define a controlled bench physical witness;
10. list every unresolved machine fact that blocks installed-machine commissioning;
11. list regression triggers for connector, FPGA image, module configuration, driver revision, HAL config, and machine endpoint changes.

### Lab pass criteria

A passing submission must:

- preserve reusable-block versus connection-block ownership;
- cite current authority for every translation edge;
- reject superseded configuration where newer authority exists;
- distinguish package-pin binding from synthesis/P&R/timing evidence;
- distinguish FPGA module instance from exact HAL object name;
- distinguish transport reachability from image/driver identity;
- use a physical witness rather than software observation alone;
- keep `VERIFY_AT_MACHINE` facts unresolved until measured;
- give no personnel-safety credit to the ordinary LinuxCNC/LiteX-CNC/FPGA chain.

## Durable freezes

- `SEMANTIC CONTINUITY != NAME RESEMBLANCE`.
- `FPGA MODULE INSTANCE NAME != PROVED HAL PIN NAME`.
- `ETHERNET REACHABLE != EXPECTED FPGA IMAGE/DRIVER MAPPING PROVED`.
- `OLDER COMPLETE-LOOKING CONFIG != CURRENT PRODUCTION AUTHORITY`.
- `HAL COMMAND STATE != PHYSICAL OUTPUT STATE`.
- `HOST/HAL MAPPING GAP -> RECORD DEFECT; DO NOT INVENT NAMES`.
- `ORDINARY LINUXCNC/FPGA CONTROL != PERSONNEL-SAFETY AUTHORITY`.

## Safety boundary

This lesson maps ordinary controller functions only. LinuxCNC, LiteX-CNC, FPGA modules, Etherbone, watchdogs and HAL logic may participate in normal control, diagnostics and ordinary output inhibition, but they are not represented as the independent personnel-safety authority. Retained or separately engineered safety-rated functions remain authoritative.