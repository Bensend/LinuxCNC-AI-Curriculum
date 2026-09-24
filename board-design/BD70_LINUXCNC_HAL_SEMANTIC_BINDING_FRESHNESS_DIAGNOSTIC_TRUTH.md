# BD70 — LinuxCNC/HAL Semantic Binding, Command Freshness, and Diagnostic Truthfulness

Status: durable board-design curriculum lane

## Purpose

A controller is not integrated merely because LinuxCNC can see pins and move values through HAL. A board can have electrically correct hardware, a valid FPGA image, and syntactically valid HAL while still lying about what a signal means, hiding the authority that actually inhibits an output, reusing stale commands after a transport/session break, or presenting a diagnostic as though it proved actuator state.

This lesson teaches the semantic binding layer between reusable hardware resources, board-specific FPGA resources, transport/session state, LinuxCNC/HAL, and bench-observable machine behavior.

Design flow:

`accepted authority chain -> FPGA semantic resources -> transport/session state -> HAL pins/signals -> command/feedback/fault ownership -> freshness/recovery semantics -> diagnostic truth table -> bench-observable acceptance contract`

## Learning objectives

Students shall be able to:

1. distinguish physical FPGA resources, firmware module semantics, HAL-facing semantics, machine/application names, and physical actuator state;
2. build an end-to-end semantic binding table without inventing HAL names that are not established by inspected software or generated configuration;
3. classify command, request, status, feedback, fault, inhibit, and measured-state signals by authority and evidence;
4. prevent stale command resurrection across host/transport/session/watchdog/reset events;
5. design diagnostics that say only what their evidence proves;
6. identify obsolete or provenance-only configuration that must not be treated as current runtime authority;
7. define bench-observable acceptance tests for semantic mappings; and
8. preserve the boundary between ordinary control/diagnostics and independent personnel-safety authority.

## 1. The semantic stack

Treat these layers separately:

1. **machine intent** — what the machine function is supposed to do;
2. **connection definition** — the board-specific connector/contact/harness destination;
3. **reusable block interface** — the electrical function and semantic contract owned by a reusable block;
4. **FPGA physical resource** — package ball and electrical direction/domain;
5. **FPGA firmware resource** — GPIO, encoder, step generator, watchdog, SPI engine, or another implemented function;
6. **transport/session state** — whether the host is communicating with the intended live control image/session;
7. **HAL-facing object** — the LinuxCNC pin/parameter/function actually exported by the loaded driver/module;
8. **HAL signal/application binding** — how machine logic connects that object to commands, status, interlocks, and diagnostics;
9. **physical observation** — what can actually be measured at the connector, output stage, sensor, or actuator.

A name match between two layers is not proof that the semantics match.

## 2. Hard rule: do not invent HAL names

A board resource named `encoder_1`, `DI1`, or `GLOBAL_OUTPUT_ENABLE_STATUS` does not by itself prove the exact HAL pin name exposed by a particular LiteX-CNC/LinuxCNC build.

Before teaching or releasing an exact HAL name, inspect the current generated configuration and the current driver/module source or a captured runtime pin list at the pinned revision. If that evidence has not been inspected, record the HAL name as `TBD_FROM_GENERATED_RUNTIME` rather than guessing.

This rule matters because names can change through generator conventions, module indexing, prefixes, version changes, or board-specific adapters while the underlying electrical resource remains unchanged.

## 3. Worked-example audit: OpenPressBrake FPGA/LiteX-CNC handoff

The current OpenPressBrake resource map reserves semantic resources for ordinary control and diagnostics, including watchdog/status resources and machine I/O. It also explicitly keeps the hardware output-enable permission outside FPGA proportional-command ownership.

The current LiteX-CNC binding preserves a pinned upstream LiteX-CNC reference but records an important provenance boundary: the older proven module configuration contains a superseded discrete proportional-output model. The current board binding removes/rebases those obsolete proportional resources before parsing and instead binds the present shared-SPI/two-device proportional-driver physical contract. It explicitly says GPIO exposure is not the final production proportional-control implementation; a production transaction/register engine is still required.

That is a valuable teaching example: a file may remain useful provenance while being **DEPRECATED_OR_SUPERSEDED for one semantic subset**. Students must not copy an old PWM/HAL mapping merely because it exists in a historically proven configuration.

### Student-facing readiness audit

For this lesson only:

- `hardware/blocks/fpga_core_ecp5_25/integration/retrofit_resource_map.yaml` — **VERIFIED_FOR_LESSON** for current board-level FPGA resource ownership, shared-resource accounting, watchdog/status resource reservation, and the explicit external hardware-output-enable boundary.
- `hardware/blocks/fpga_core_ecp5_25/integration/rev32_openpressbrake_litexcnc_binding.json` — **VERIFIED_FOR_LESSON** for current binding/provenance rules and the explicit MAX22216 rebase/open production-engine item; it is not proof of final HAL names or complete proportional runtime behavior.
- `hardware/blocks/fpga_core_ecp5_25/integration/rev31_litexcnc_rev1_proven_modules.json` — **VERIFIED_FOR_LESSON only as bounded historical/proven module provenance** for GPIO/encoder/stepgen structure; **DEPRECATED_OR_SUPERSEDED** as present proportional-output runtime authority.
- `hardware/blocks/fpga_core_ecp5_25/STATUS_CHECKLIST.md` — **ENGINEERING_REVIEW_NEEDED** as a completely current resource summary because human-readable resource counts still include pre-MAX22216 figures while the current machine-readable resource map reports the rebased unique GPIO totals. It remains useful for bounded open-gate/safety-boundary teaching where consistent with current authority.
- `board-design/BD69_FPGA_HOST_WATCHDOG_GLOBAL_ENABLE_STALE_COMMAND_CONTAINMENT.md` — **VERIFIED_FOR_LESSON** as the prerequisite authority/freshness method.

No exact LinuxCNC HAL pin spelling is asserted by this lesson because current inspected OpenPressBrake artifacts establish FPGA/LiteX-CNC semantic resources and binding provenance, but do not themselves prove the exact runtime HAL namespace to be released.

## 4. Build a semantic binding table

For every machine-relevant signal, record at least:

| Field | Required question |
|---|---|
| semantic ID | What stable meaning is being bound? |
| machine function | What machine behavior consumes or produces it? |
| connection endpoint | Which board-specific connector/contact/harness endpoint owns the field interface? |
| reusable block | Which reusable electrical function owns conditioning/drive/protection? |
| FPGA physical resource | Which ball/resource is used, if applicable? |
| firmware module | GPIO/encoder/stepgen/SPI/custom engine/etc.? |
| direction | Command toward field, observation toward host, or bidirectional protocol? |
| HAL object | Exact runtime object, or `TBD_FROM_GENERATED_RUNTIME` until proved? |
| authority class | command/request/status/feedback/fault/inhibit/measured state? |
| freshness dependency | Can stale host/session data make this value unsafe or misleading? |
| default/inhibit state | What happens before valid runtime control exists? |
| diagnostic claim | What may an operator infer from this value? |
| evidence | source/config/runtime/bench/machine evidence and revision |

Do not allow one column to silently stand in for another.

## 5. Command is not feedback

Use precise words.

- **command/request**: what software or FPGA logic asks for;
- **enable/permissive**: whether another authority permits a command path;
- **status**: a reported internal or external state with a defined observation point;
- **feedback**: an independent observation of the controlled quantity or stage;
- **fault**: a detector reports a defined abnormal condition;
- **measured state**: a sensor measurement with stated accuracy/update/evidence;
- **actuator state**: what the physical actuator is actually doing.

Examples of invalid diagnostic inflation:

- `DO_COMMAND = 1` displayed as `VALVE ON` without output/field feedback;
- watchdog healthy displayed as `MACHINE SAFE`;
- global-enable status displayed as proof that every downstream driver is energized and healthy;
- SPI transaction success displayed as proof of coil current when no current feedback establishes it;
- encoder count activity displayed as proof that commanded motion direction and scaling are correct.

Diagnostics must be truthful at the observation point they actually possess.

## 6. Freshness belongs in the semantic contract

BD69 established that loss of valid control invalidates the old command epoch. BD70 carries that rule into the LinuxCNC/HAL binding.

For every motion- or energy-producing command, identify:

- the host value;
- the transport/session carrying it;
- the FPGA/register state receiving it;
- the event that marks it stale;
- the mechanism that prevents stale state from reaching an enabled output;
- the recovery event that establishes a fresh epoch; and
- whether an explicit inactive/default command must be observed before active commands are accepted.

At minimum consider host process restart, transport disconnect/reconnect, watchdog timeout, FPGA reset/reconfiguration, core-power fault, explicit output inhibit, and field-power loss/return.

Do not infer a timeout or recovery policy from generic protocol behavior. Machine-specific acceptance values remain `TBD`/`VERIFY_AT_MACHINE` until evidence closes them.

## 7. Transport connected is not command fresh

A live Ethernet/fieldbus/USB session can coexist with stale application state. Likewise, a reconnect can succeed before machine/application state has been safely re-established.

The integration contract therefore needs separate semantics for, as applicable:

- transport link present;
- device/session identity valid;
- runtime image/configuration identity valid;
- command stream current;
- watchdog/progress current;
- output qualification present;
- machine application armed/permitted; and
- independent safety-system state monitored, without claiming safety authority.

Do not collapse all of these into `connected` or `ready`.

## 8. Diagnostic truth table

For each operator-visible or HAL-visible diagnostic, create a truth table with:

- diagnostic name;
- physical/logical observation point;
- source authority;
- update/freshness condition;
- valid power dependencies;
- what `TRUE` proves;
- what `FALSE` proves;
- what neither state can prove;
- stale/unknown representation;
- bench stimulus; and
- expected physical observation.

If the diagnostic becomes meaningless when its sensing domain is unpowered, it must not silently report a normal false/zero state as though that were valid negative evidence. Use an explicit unknown/not-valid concept at the application layer where needed.

## 9. Negative semantic tests

A release review should deliberately reject at least these cases:

1. a HAL command renamed as physical feedback;
2. a safety-owned monitored signal presented as though LinuxCNC owns the safety function;
3. an old provenance configuration treated as current runtime authority after a hardware rebase;
4. an exact HAL pin name guessed from an FPGA resource name;
5. transport reconnection restoring an old active command without a fresh-command policy;
6. a diagnostic reporting healthy while its sensing/power domain is invalid;
7. a global status bit used as proof of every local channel state;
8. two HAL writers or firmware owners for one semantic command;
9. a board-specific machine name leaked back into the reusable block contract; and
10. a physical field endpoint omitted from the binding because software names appear self-consistent.

## 10. Bench-observable acceptance contract

Before calling a semantic binding accepted, test from both ends.

For an output path:

`HAL/application stimulus -> runtime command observation -> FPGA/driver observation -> connector/output measurement -> inhibit/fault stimulus -> confirmed inactive result -> recovery with fresh command`

For an input/feedback path:

`known physical stimulus -> connector observation -> conditioning output -> FPGA resource -> runtime/HAL observation -> stale/power-invalid behavior`

Record expected and observed polarity, scaling, units, default state, update behavior, invalid-state representation, and evidence timestamp/revision.

A loopback test can prove mapping continuity but does not automatically prove field electrical compatibility, actuator behavior, sensor accuracy, or safety integrity.

## 11. Catalog stress-test result

The current OpenPressBrake catalog is strong at physical FPGA resource accounting and explicit ownership boundaries, but the curriculum audit exposes two release-consumable gaps.

First, the catalog needs a machine-readable **semantic binding manifest** that joins stable semantic IDs across connection definition, reusable block, FPGA physical resource, firmware module, generated runtime/HAL object, authority class, freshness dependency, diagnostic claim, and evidence revision. This should be generated or reconciled against the actual runtime namespace rather than hand-invented.

Second, provenance artifacts need explicit **subset validity**. A historical module configuration may remain `VERIFIED_FOR_LESSON` for encoder/stepgen provenance while being `DEPRECATED_OR_SUPERSEDED` for proportional-output authority. A single file-level `current/old` flag is too coarse when a hardware rebase changes only part of its semantics.

The current FPGA status checklist also contains pre-rebase human-readable resource totals while the current resource map publishes the MAX22216/shared-SPI rebased totals. Treat that as **ENGINEERING_REVIEW_NEEDED** evidence-index/status reconciliation work. Do not copy stale totals into new board decisions.

No OpenPressBrake catalog file is modified in this lesson because current main is actively advancing block resource contracts; the curriculum consumes the newest state read-only rather than racing active engineering work.

## 12. Transfer beyond a press brake

The same semantic discipline applies to:

- a mill spindle command versus VFD run feedback;
- a lathe spindle-speed request versus measured spindle encoder speed;
- a plasma torch command versus arc-ok feedback;
- a router vacuum/spindle request versus contactor or process feedback;
- a robot joint command versus encoder/drive status; and
- custom automation heater/valve commands versus measured temperature/pressure/position.

Reusable block semantics transfer. Machine naming, scaling, recovery policy, acceptable loss interval, and safety functions remain machine-specific.

## 13. Lab deliverable

Given a board connection definition, qualified reusable blocks, FPGA resource contract, generated firmware configuration, and LinuxCNC runtime environment, produce:

1. the end-to-end semantic binding table;
2. a command/feedback/authority classification for every machine-relevant signal;
3. exact HAL names only where source/generated/runtime evidence proves them;
4. a command-freshness/recovery map;
5. a diagnostic truth table;
6. at least five negative semantic tests;
7. a bench-observable acceptance matrix; and
8. an unresolved-facts list using `TBD`, `VERIFY_AT_MACHINE`, or `TBD_FROM_GENERATED_RUNTIME`.

A passing answer must prove that software names, FPGA resources, electrical endpoints, and diagnostic claims describe the same real signal path without hiding stale-command or authority boundaries.

## Safety boundary

LinuxCNC/HAL, LiteX-CNC, FPGA logic, runtime watchdogs, diagnostic displays, ordinary output gating, and monitored safety status receive **no personnel-safety credit** unless a separate safety-rated design and validation explicitly establish that claim. The independent safety system remains authoritative for credited hazardous-energy safety functions.

## Next checkpoint

BD71 — Bench Bring-Up as Evidence: Semantic I/O Checkout, Fault Injection, and Commissioning Records:

`accepted semantic binding -> powered-domain checkout -> known input stimuli -> inhibited output observation -> staged output energization -> fault/inhibit injection -> freshness/recovery test -> evidence record -> commissioning gate`
