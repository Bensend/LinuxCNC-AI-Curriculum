# BD08 — Qualification Evidence, Verification Matrices, and Regression Triggers

## Purpose

A reusable hardware block is not qualified because its schematic looks reasonable, a script prints PASS, a CI job is green, or somebody once put it on a bench. Qualification is a chain of bounded claims tied to a particular design revision and evidence method.

This lesson teaches the block-engineering flow:

`requirement -> failure mode -> evidence needed -> analytical/manufacturer proof -> executable verification when justified -> bench test -> machine verification -> release status -> regression trigger`

The worked example is the current OpenPressBrake `differential_encoder` reusable primitive. It is useful because it has meaningful static, manufacturer, executable, FPGA-binding, and status evidence while still exposing genuine machine, board, abnormal-condition, PCB, and human-release gates.

## Hard student-material audit

The following OpenPressBrake files were opened and inspected in current `main` form before this lesson was written and are `VERIFIED_FOR_LESSON` for the bounded claims made below:

- `hardware/blocks/differential_encoder/engineering.yaml`
- `hardware/blocks/differential_encoder/manifest.yaml`
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md`
- `hardware/blocks/differential_encoder/design/REV1_PRODUCTION_CONNECTIVITY.md`
- `hardware/blocks/differential_encoder/design/PRODUCTION_BOM_REV1.yaml`
- `hardware/blocks/differential_encoder/design/REV1_RECEIVER_TIMING_CONTRACT.md`
- `hardware/blocks/differential_encoder/simulation/validate_production_receiver_rev1.py`
- `hardware/blocks/differential_encoder/simulation/rev1_datasheet_crosscheck.py`
- `hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json`

These files are verified as teaching evidence, not as proof that the encoder block is fully qualified. Current status explicitly leaves cable/reflection behavior, termination selection, protected encoder field power, board-level ESD/surge and miswire/hot-plug qualification, schematic visual review, PCB integration, final cost, synthesis/place-route/timing, board integration, and human release open.

No executable test was rerun for this lesson. The educational question is how to classify existing evidence and determine its validity boundary; rerunning unchanged tests would add no evidence.

## 1. Evidence must answer a named question

Do not start with a tool. Start with a claim.

A useful verification record answers:

1. What requirement or failure mode is being checked?
2. What exact design/revision does the evidence apply to?
3. What method is capable of answering the question?
4. What inputs, boundaries, assumptions, and configuration were used?
5. What acceptance criterion decides pass/fail?
6. What was actually observed or calculated?
7. What remains outside the evidence boundary?
8. What change invalidates or requires review of the result?

A green job without those answers is execution history, not a reusable engineering argument.

## 2. Evidence classes

Use explicit evidence classes instead of the word `tested`.

| Evidence class | Good for | Not sufficient for |
|---|---|---|
| proven reference | showing a topology/behavior has prior credible use | proving OpenPressBrake deltas or the new PCB |
| manufacturer/datasheet | device limits, pin behavior, timing/rating boundaries | cable, PCB, machine, installation, or system performance not covered by the device specification |
| calculation/static validation | arithmetic, exact structure, pin/net/BOM invariants | physical transient behavior, thermal behavior, signal integrity, assembly defects |
| simulation | answering a model-bounded electrical/logic question | proving omitted parasitics, unknown machine wiring, EMC, production workmanship, or physical safety behavior |
| synthesis/place-route/timing | actual FPGA implementation fit and timing for a pinned image/tool flow | field electrical integrity or machine behavior |
| bench test | physical behavior of the tested article/setup | a different PCB revision, cable, load, machine, environment, or untested fault |
| machine verification | installed machine/configuration facts and behavior | generic reusable-block qualification beyond the tested installation |
| human review/signoff | checking completeness, assumptions, schematic/layout intent and release decision | replacing objective electrical evidence |

The strongest package normally uses several classes because each answers a different question.

## 3. Worked example — what the encoder evidence actually proves

### 3.1 Exact connectivity and BOM structure

`validate_production_receiver_rev1.py` checks concrete structural invariants in the production netlist and BOM: three pair-protection devices return to `CHASSIS_PE`, the three optional 120-ohm terminations exist, local decoupling exists, the AM26LV32E pin-shell arity stays correct, and required production MPN/variant tokens remain present.

This is strong evidence against accidental connectivity/BOM drift. It does **not** prove that the PCB routes chassis current correctly, that a real ESD event is survived, that a cable is correctly terminated, or that the assembled hardware works.

Freeze:

`STATIC CONNECTIVITY PASS != PHYSICAL QUALIFICATION`

### 3.2 Manufacturer boundary calculations

`rev1_datasheet_crosscheck.py` calculates receiver supply power from 3.3 V and 17 mA, termination current/power at the 200 mV guaranteed sensitivity point, and a first-order 50-ohm/6-pF normal-operation pole sanity check. Its own comment calls the latter a normal-operation bandwidth sanity check.

The current timing contract separately records TI manufacturer switching limits: 26 ns maximum propagation delay, 6 ns maximum pulse/output skew, and 9 ns device-to-device skew where applicable. It deliberately refuses to turn the published typical 32 MHz characteristic into a guaranteed all-corners machine acceptance limit.

Freeze:

`DATASHEET DEVICE LIMIT != QUALIFIED SYSTEM LIMIT`

### 3.3 Bounded simulation

The status checklist records passing production-topology bounded ngspice endpoints and explicitly limits their meaning. The production-connectivity document says manufacturer-fidelity propagation delay, ESD/surge waveforms, cable reflections, PCB parasitics, and hot-plug/miswire qualification remain later gates.

That is the correct use of simulation: answer the question the model contains, then stop.

Freeze:

`MODEL PASS != OMITTED PHYSICS PASS`

### 3.4 FPGA binding evidence

`rev1_litexcnc_encoder_binding.json` binds six LiteX-CNC encoder instances to explicit semantic A/B/Z FPGA package balls and records the pinned reference revisions. This is valuable cross-domain evidence that the intended decoder instances consume the intended semantic receiver outputs.

It does not prove synthesis/place-and-route/timing closure. The current manifest still has LUT/register estimates `TBD`, and the status checkpoint explicitly says local self-hosted synthesis/place-route/timing evidence remains required before routed-fit claims advance.

Freeze:

`LOGICAL BINDING PASS != SYNTHESIS/P&R/TIMING PASS`

### 3.5 Machine evidence remains machine evidence

The reusable engineering contract deliberately keeps installed encoder identity, maximum edge rate, encoder supply current, cable type/length/impedance, remote termination, and shield convention under machine configuration / `VERIFY_AT_MACHINE`.

Those facts decide whether the populated 120-ohm or DNP variant is appropriate and may impose a much lower usable rate than the receiver device itself supports.

Freeze:

`REUSABLE RECEIVER QUALIFICATION != INSTALLED CHANNEL QUALIFICATION`

## 4. Build a requirement-to-evidence matrix

Every reusable block should be explainable through a matrix like this:

| Requirement / failure mode | Evidence required | Current encoder evidence | State | Regression trigger |
|---|---|---|---|---|
| production pins/nets/components match intended Rev1 topology | exact static connectivity/BOM validation + human review | structural validator + production connectivity/BOM | PARTIAL | topology, package, MPN, variant, protection-return change |
| receiver electrical input/timing envelope is understood | manufacturer authority + bounded calculations | TI-derived engineering/timing contract and cross-check | EVIDENCE PRESENT | receiver MPN/revision or operating-envelope change |
| bounded electrical endpoints behave in retained model | production-topology simulation | retained bounded ngspice evidence | EVIDENCE PRESENT | modeled topology/value/model-boundary change |
| configured cable/termination works at installed edge rate | machine facts + channel/SI evidence | none sufficient | OPEN / VERIFY_AT_MACHINE | encoder/cable/termination/rate change |
| field protection survives declared abnormal conditions | declared fault envelope + physical/appropriate qualification | not complete | OPEN | protection topology, PCB return path, declared environment change |
| FPGA decoder is bound to intended package pins | machine-readable cross-domain validator | six-instance binding exists | EVIDENCE PRESENT | image/module/pin-plan/instance change |
| actual FPGA image fits and closes timing | self-hosted synthesis/P&R/timing | not yet claimed | OPEN | HDL/config/tool/device/pin/timing change |
| protected encoder field supply supports installed encoders | board budget + protection design + machine current | not frozen | OPEN | encoder current/count/supply/protection change |
| finished schematic/layout matches intent | rendered review/ERC/layout review | incomplete | OPEN | capture/layout change |
| block released for board use | all required release gates + human signoff | not complete | OPEN | any invalidating design/evidence change |

`PARTIAL` is intentional. A static validator can prove the text/netlist structure while visual capture review remains open.

## 5. Regression triggers are part of the block contract

Evidence has a lifetime.

The current encoder engineering contract already contains useful recalculation triggers:

- instance-count change -> recalculate receiver current, GPIO/package count, FPGA fit, connector count, and field-supply budget;
- installed encoder/rate change -> recalculate timing/rate compatibility, field supply, and termination review;
- cable/remote termination change -> revisit termination variant and reflection/SI review;
- material PCB geometry or chassis-path change -> review pair routing, protection placement, and chassis transient return.

Extend this thinking to every block. A verification result without an invalidation rule encourages stale evidence to survive design changes.

A regression trigger can require one of four responses:

- **RERUN** — same method remains valid but inputs changed;
- **RECALCULATE** — analytical inputs changed;
- **REVIEW** — applicability must be reassessed before deciding whether a rerun is needed;
- **REQUALIFY** — physical or architectural change invalidates prior qualification.

## 6. CI is evidence transport, not evidence authority

CI can reliably execute validators and preserve logs. It cannot make an inappropriate test meaningful.

Before accepting a CI result, identify:

- the exact script/netlist/image that ran;
- the commit/revision it ran against;
- the acceptance criterion encoded by the test;
- whether the test model includes the failure mechanism being claimed;
- whether the runner/tool version matters;
- which release gate the result is allowed to close.

Never write `CI passes, therefore block qualified`.

Write something like:

`The Rev1 production-connectivity validator passed against commit X, proving the named structural invariants; board-level surge, cable SI, routed PCB, and human-release gates remain open.`

## 7. Question-driven executable verification

Executable work is justified when a concrete unresolved question cannot be answered more directly by authoritative documentation, inspection, or calculation.

Examples:

- Does the pinned FPGA image actually fit and close timing? -> synthesis/P&R/timing is justified.
- Does a changed nonlinear circuit meet a bounded electrical criterion? -> appropriate simulation may be justified.
- Is a resistor value correctly transcribed from the authoritative BOM into the production netlist? -> static inspection/validator is preferable to SPICE.
- What is the installed encoder cable length? -> simulation is useless; verify at the machine.

For this curriculum, executable verification must run only on the local OpenPressBrake panel PC through `[self-hosted, openpressbrake]`. Do not spend hosted Actions minutes. BD08 does not launch compute merely to demonstrate that compute exists.

## 8. Qualification status must be claim-specific

Avoid a single overloaded word such as `verified`.

Useful claim-specific states include:

- topology/connectivity verified;
- manufacturer boundary recorded;
- model-bounded simulation passed;
- FPGA semantic binding validated;
- synthesis/P&R/timing open;
- abnormal-condition qualification open;
- installed-machine configuration open;
- PCB/layout review open;
- release/signoff open.

The current encoder package is a good example: its manifest says `simulation-ready`, while the status checklist explicitly forbids describing it as `SCHEMATIC-READY`, fully qualified, or `REV 1 READY` until the corresponding open gates close.

## 9. Safety boundary

This lesson is about ordinary controller-board engineering evidence. The differential encoder explicitly receives no personnel-safety credit.

A process-control block may be thoroughly verified for its ordinary function and still have zero authority to claim personnel protection. Likewise, a normal-controller watchdog, FPGA fault detector, or diagnostic input is not promoted into an independent safety function merely because its verification package is good.

## Lab — build a defensible qualification ledger

Using the verified encoder artifacts listed at the start of BD08, produce a qualification ledger with one row per material requirement/failure mode.

For each row record:

1. requirement/failure mode;
2. owner: reusable block, board integration, connection definition, machine configuration, or independent safety system;
3. evidence class;
4. exact evidence artifact and revision/commit when available;
5. setup/input boundaries;
6. acceptance criterion;
7. observed/calculated result;
8. status: `PROVED_FOR_BOUND`, `PARTIAL`, `OPEN`, `VERIFY_AT_MACHINE`, or `NOT_APPLICABLE`;
9. exclusions — what the evidence does not prove;
10. regression trigger and response (`RERUN`, `RECALCULATE`, `REVIEW`, `REQUALIFY`).

Then perform three adversarial changes:

- change the installed encoder/cable termination facts;
- change the receiver MPN or a protection component;
- change the FPGA image/pin-plan revision.

For each change, identify exactly which evidence remains valid and which evidence must be recalculated, reviewed, rerun, or physically requalified. Do not simply mark the whole block `untested`.

### Lab pass criteria

A passing submission must:

- never use `tested`, `protected`, `validated`, `qualified`, or `CI passes` without naming the bounded claim;
- distinguish reusable-block evidence from board/machine evidence;
- preserve `VERIFY_AT_MACHINE` facts rather than inventing them;
- identify at least one case where static validation is stronger/more appropriate than simulation;
- identify at least one case where physical qualification is required;
- identify at least one case where synthesis/P&R/timing evidence is required;
- show how a design change invalidates only the affected evidence rather than indiscriminately discarding or retaining everything;
- preserve the ordinary-control versus independent personnel-safety boundary.

## Catalog stress-test result

The encoder package passes the BD08 teaching stress test unusually well because `engineering.yaml` already carries named validation items and recalculation triggers, while the status checklist explicitly distinguishes completed evidence from open qualification gates.

The remaining catalog weakness is not a contradiction but a granularity opportunity: `manifest.yaml` says `simulation-ready`, while several distinct evidence classes and release gates exist underneath that summary. Students must read the status/evidence package to know the exact proof boundary. Future catalog evolution should prefer machine-readable claim/evidence/regression relationships over increasingly broad one-word maturity labels.

No OpenPressBrake engineering file is changed by BD08 because the current evidence boundaries are already explicit and current board development is actively changing integration/renderer authority elsewhere.

## Durable freezes

- `TEST RAN != REQUIREMENT PROVED`.
- `CI GREEN != BLOCK QUALIFIED`.
- `STATIC CONNECTIVITY PASS != PHYSICAL QUALIFICATION`.
- `DATASHEET DEVICE LIMIT != QUALIFIED SYSTEM LIMIT`.
- `MODEL PASS != OMITTED PHYSICS PASS`.
- `LOGICAL BINDING PASS != SYNTHESIS/P&R/TIMING PASS`.
- `REUSABLE BLOCK QUALIFICATION != INSTALLED MACHINE QUALIFICATION`.
- `EVIDENCE WITHOUT REVISION APPLICABILITY OR REGRESSION TRIGGER BECOMES STALE EVIDENCE`.
- `ORDINARY-CONTROL VERIFICATION != PERSONNEL-SAFETY AUTHORITY`.

## Next lesson

BD09 should switch back to **BOARD INTEGRATION** and build the verification/bring-up plan for a complete controller slice:

`pre-power inspection -> resistance/short checks -> current-limited staged power -> rail verification -> FPGA/config identity -> one interface at a time -> fault/default-state challenge -> LinuxCNC/HAL mapping -> machine connection -> regression/commissioning record`

Before assigning any OpenPressBrake files in BD09, open them in their current form. Prefer a bounded slice whose power, FPGA binding, connection ownership, and block evidence can all be traced without claiming the full Rev1 board is released.
