# BD69 — FPGA/Host Watchdog, Global-Enable, and Stale-Command Containment

Status: durable board-design curriculum lane

## Purpose

A controller is not fail-closed merely because every output has an inactive reset value. A machine can retain a hazardous ordinary-control command when the host stops updating, communications stall, FPGA logic stops making progress, a watchdog is serviced by the wrong authority, or an enable recovers before command freshness is re-established.

This lesson teaches the board-level authority chain required to make stale commands unable to survive a loss-of-control event.

Design flow:

`transition-closed output paths -> watchdog authority chain -> host/FPGA failure classes -> stale-command containment -> global-enable fanout -> LinuxCNC/HAL state mapping -> fault/recovery semantics -> verification matrix -> integration acceptance`

## Learning objectives

Students shall be able to:

1. separate command generation, command freshness, watchdog servicing, global output qualification, field-power availability, and independent personnel-safety authority;
2. trace a motion-producing output from LinuxCNC/HAL through FPGA state to the final electrical output stage;
3. prove that loss of host updates, loss of communications, FPGA reset/configuration, bad core power, or watchdog timeout forces ordinary motion-producing outputs inactive without depending on stale software state;
4. define recovery so output permission cannot reappear before fresh commands and all required qualifiers are re-established;
5. distinguish a watchdog status signal from the hardware authority that actually removes output permission;
6. construct a failure/recovery verification matrix instead of relying on a single nominal watchdog test; and
7. preserve the boundary between ordinary process-control containment and independent personnel-safety functions.

## 1. Authority is a chain, not one Boolean

Treat these as separate authorities:

- **command authority** — LinuxCNC/HAL or other application logic requests an ordinary machine action;
- **freshness authority** — the real-time control path proves that the command belongs to the current control epoch rather than an abandoned host/comms state;
- **watchdog authority** — a bounded-progress mechanism proves that the expected controller is still executing and communicating;
- **output-qualification authority** — independent hardware determines whether command-bearing stages are electrically permitted to actuate;
- **field-power authority** — machine wiring/contactors/switches determine whether actuator energy is actually available;
- **personnel-safety authority** — a separately engineered and validated safety system owns credited hazardous-energy safety functions.

Do not collapse these into a variable named `enable`.

## 2. Worked-example audit: current OpenPressBrake authority chain

The current OpenPressBrake board-integration specification requires an independent watchdog/output qualifier and states that machine outputs are inactive/disabled during configuration failure, watchdog timeout, or bad core power. It also states that the retained Pilz safety system remains authoritative and that local board gating receives no replacement-safety claim.

The current machine-specific integration contract defines the ordinary proportional-output hardware gate as the conjunction of:

- `PILZ_VALVE_ENABLE`;
- `WATCHDOG_OK`;
- `FPGA_CONFIGURED`; and
- `CORE_POWER_GOOD`.

Its direct hardware result is `PROP_OUTPUT_STAGE_ENABLE`, and a software-only path is explicitly forbidden.

The current FPGA resource map separately reserves `WATCHDOG_KICK`, `FPGA_RESET_STATUS`, `POWER_GOOD_IN`, and `GLOBAL_OUTPUT_ENABLE_STATUS`. Its notes explicitly say that `HARDWARE_OUTPUT_ENABLE` is a board-level fail-low permission fanout and is **not** an FPGA proportional-command resource.

The FPGA status checklist further records that LiteX-CNC owns the runtime watchdog while the external hardware output gate remains independent containment; `GLOBAL_OUTPUT_ENABLE` command ownership stays outside the FPGA while the FPGA receives status only. The same checklist keeps manufacturer timing/voltage/temperature, downstream fanout/unpowered-input behavior, and machine acceptance of the final process-control loss interval open.

### Student-facing readiness audit

For this lesson only:

- `docs/BOARD_INTEGRATION_SPEC.md` — **VERIFIED_FOR_LESSON** for architecture, authority boundaries, safe-state requirements, and ordinary-control versus safety separation.
- `hardware/REV1_BOARD_INTEGRATION.yaml` — **VERIFIED_FOR_LESSON** for the current machine-specific hardware-output-enable qualifier set and safe-state declarations.
- `hardware/blocks/fpga_core_ecp5_25/integration/retrofit_resource_map.yaml` — **VERIFIED_FOR_LESSON** for current FPGA-side watchdog/status resource ownership and its explicit statement that hardware output enable is outside proportional-command ownership.
- `hardware/blocks/fpga_core_ecp5_25/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** as a current status/open-gate example, **not** as proof that watchdog/global-enable qualification is complete.

Do not present the current OpenPressBrake watchdog/global-enable implementation as production-qualified. Its own checklist leaves electrical/fanout and application loss-interval gates open.

## 3. Failure classes students must distinguish

At minimum analyze:

| Failure | Command memory may still contain active value? | Required ordinary-control containment |
|---|---:|---|
| LinuxCNC application stops updating | yes | freshness/watchdog expires; output permission removed |
| host-to-FPGA transport stalls | yes | FPGA/runtime watchdog expires without relying on host cleanup |
| host reconnects after stale session | yes | old command epoch rejected; fresh command required before re-enable |
| FPGA logic hangs but configuration remains loaded | yes | independent watchdog removes output qualification |
| FPGA resets/reconfigures | unknown/default | output qualifier fail-low; command state rebuilt from inactive defaults |
| core power browns out | indeterminate | power-good/global qualification removes permission before invalid logic can actuate |
| watchdog circuit loses its own valid supply | indeterminate | output gate must fail toward ordinary OFF, not permissive |
| field power disappears and returns | command may remain active | return of field power alone must not resurrect stale actuation |
| safety-owned enable disappears | command may remain active | hardware path removes applicable permission independently of software |
| safety-owned enable returns | command may remain active | ordinary controller still must satisfy its own fresh-command/recovery policy |

The exact timeout values are application facts. Do not invent them. Record unresolved acceptance intervals as `TBD`/`VERIFY_AT_MACHINE` until engineering evidence closes them.

## 4. Stale-command containment

A robust design needs more than `watchdog_ok`.

Define a **control epoch** or equivalent freshness state. After any event that invalidates command continuity—watchdog timeout, host/comms loss, FPGA reset, brownout, configuration restart, explicit global inhibit—the previous motion-producing command state is stale.

A valid recovery sequence should require, as applicable:

1. power/configuration qualifiers valid;
2. watchdog path healthy;
3. host/FPGA communication re-established;
4. a new control epoch established;
5. fresh inactive/default command state accepted;
6. machine/application permissives re-evaluated;
7. output qualification restored only under the defined recovery policy; and
8. subsequent active commands accepted only as fresh commands from the current epoch.

Do not let a retained register value become active merely because `GLOBAL_OUTPUT_ENABLE` returned.

## 5. Watchdog servicing rules

The watchdog must prove the progress that matters.

Bad patterns include:

- a free-running FPGA counter kicks the watchdog even when host commands are frozen;
- a host thread services an external watchdog while the real-time command path is dead;
- a communications receive interrupt kicks the watchdog without proving valid command processing;
- watchdog status is observed in software but does not independently affect output permission;
- a watchdog timeout clears automatically while old active commands remain latched.

The kick source, timeout authority, hardware gate, and recovery rule must therefore be explicit in the board contract and LinuxCNC/FPGA integration contract.

## 6. Global-enable fanout

A global ordinary-output qualifier must be reviewed as a real electrical net, not a conceptual signal.

For every downstream consumer record:

- active polarity;
- local pull-up/pull-down/default state;
- source and sink voltage domains;
- unpowered-input behavior;
- fanout/input current;
- propagation and deassertion behavior;
- partial-power/backfeed risks;
- whether local channel defaults remain OFF when the global net is absent;
- whether a downstream stage can bypass the global gate; and
- whether recovery can expose a previously stored active command.

A clean FPGA status indication does not prove this electrical fanout.

## 7. LinuxCNC/HAL mapping

HAL should expose semantic state, not hide authority boundaries. A board integration should make it possible to diagnose at least:

- host command/request;
- communication/session freshness;
- runtime watchdog state;
- FPGA configured/reset state where useful;
- core power-good state where useful;
- external/global output-qualification status;
- channel command state;
- channel feedback/fault state where available; and
- the reason an output is inhibited.

Do not represent a safety-owned signal as though HAL were its authority. Monitoring and ordinary-control interlocking are not safety certification.

## 8. Recovery semantics

Specify whether recovery is automatic or requires an application-level reset/re-arm. That choice depends on the machine and risk analysis and must not be invented by the reusable block.

The reusable block should publish capabilities and defaults. The board/machine integration layer owns the machine-specific recovery policy.

At minimum, recovery must not:

- reuse a pre-timeout active command without freshness proof;
- allow field-power restoration alone to recreate motion;
- allow a rebooting host to inherit an old command epoch;
- allow the FPGA to bypass the independent hardware qualifier; or
- imply that ordinary watchdog/global-enable logic is personnel-safety authority.

## 9. Verification matrix

Students shall build a matrix with rows for each failure/recovery event and columns for:

- host state;
- communications/freshness state;
- FPGA state;
- watchdog state;
- power-good state;
- external/global qualifier state;
- local output-stage default;
- field power;
- expected actuator-facing result;
- observed status/HAL indication;
- maximum measured/accepted loss interval;
- recovery prerequisite; and
- evidence type.

Test transitions, not only static states. Examples include host freeze while active, cable/transport loss while active, watchdog-kick failure, FPGA reset while active, core brownout, qualifier loss/return, field-power loss/return, and reconnect with intentionally stale command data.

Executable timing or FPGA verification, when genuinely required, belongs only on the OpenPressBrake self-hosted runner labeled `[self-hosted, openpressbrake]`.

## 10. Catalog stress-test result

The current catalog exposes the correct high-level separation—runtime watchdog, external hardware output qualification, FPGA status-only observation, and independent safety authority—but the curriculum audit reveals a reusable-contract gap.

A release-consumable watchdog/global-enable contract should machine-readably publish:

- watchdog kick owner and what progress a kick proves;
- watchdog timeout range and evidence status;
- timeout polarity/default behavior;
- global-enable source ownership;
- all downstream consumers/fanout;
- electrical voltage/current/default-bias contract;
- partial-power/unpowered-input behavior;
- command-freshness invalidation events;
- stale-command clearing/epoch rule;
- recovery prerequisites;
- status/diagnostic signals and their power dependencies;
- maximum process-control loss interval and acceptance evidence; and
- explicit `ordinary_control_not_safety_rated: true` semantics.

Until those electrical and application acceptance gates are closed, classify the complete watchdog/global-enable qualification as **ENGINEERING_REVIEW_NEEDED**, not production-proven.

## 11. Transfer beyond a press brake

The same reasoning applies to:

- a mill spindle/axis command after Ethernet loss;
- a lathe spindle and chuck-related ordinary control after controller restart;
- a plasma torch command after communications loss;
- a router spindle/stepper enable after brownout;
- robot ordinary motion commands after controller/session restart; and
- custom automation valves/heaters/motors after PLC/PC reconnect.

The reusable watchdog and output-qualification concepts transfer. Machine-specific timeout, restart, actuator and safety requirements do not.

## 12. Lab deliverable

Given a qualified output block, an FPGA resource contract, and a machine connection definition, produce:

1. an authority-chain diagram;
2. a stale-command/freshness state machine;
3. a global-enable fanout table;
4. a LinuxCNC/HAL semantic mapping;
5. the failure/recovery verification matrix;
6. an unresolved-facts list using `TBD`/`VERIFY_AT_MACHINE`; and
7. a release decision using the curriculum readiness labels.

A passing answer must demonstrate that ordinary outputs become inactive on loss of valid control and cannot silently reactivate from stale state when a qualifier returns.

## Safety boundary

This lesson concerns ordinary controller fault containment. LinuxCNC, FPGA logic, runtime watchdogs, global output qualification, output drivers, HAL interlocks and diagnostic monitoring receive **no personnel-safety credit** unless a separate safety-rated design and validation explicitly establish such a claim. Independent safety-rated hazardous-energy control remains authoritative.

## Next checkpoint

BD70 — LinuxCNC/HAL Semantic Binding, Command Freshness, and Diagnostic Truthfulness:

`accepted authority chain -> FPGA semantic resources -> transport/session state -> HAL pins/signals -> command/feedback/fault ownership -> freshness/recovery semantics -> diagnostic truth table -> bench-observable acceptance contract`
