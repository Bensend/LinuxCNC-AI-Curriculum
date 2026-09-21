# BD09 — Staged Board Bring-Up and Commissioning Evidence

## Purpose

A controller board is not commissioned because it powers up, LinuxCNC can see it, or one field signal changes. Bring-up is a staged evidence process that prevents an early success from hiding a wrong rail, return, connector, FPGA image, default state, or machine assumption.

This lesson teaches the BOARD INTEGRATION flow:

`pre-power inspection -> resistance/short checks -> current-limited staged power -> rail verification -> FPGA/config identity -> one interface at a time -> default/fault challenge -> LinuxCNC/HAL mapping -> machine connection -> commissioning/regression record`

The bounded worked example is the current OpenPressBrake differential-encoder slice. It is useful because reusable receiver engineering, board-specific connector ownership, FPGA semantic binding, and open machine/release gates can be traced without pretending the complete Rev1 controller is released.

## Hard student-material audit

The following OpenPressBrake files were opened and inspected in current `main` form during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims made here:

- `hardware/blocks/differential_encoder/engineering.yaml`
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md`
- `hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json`
- `hardware/connections/REV1_ENCODER_CONNECTIONS.yaml`

The connection definition is intentionally incomplete physical hardware. Its electrical pin dispositions and ENC1/ENC2/ENC3 functional ownership are useful teaching evidence, but exact connector family/MPN/footprint/mate, placement/orientation, harness compatibility, conductor envelope, and termination-selection facts remain `VERIFY_AT_MACHINE`; `board_capture_ready` is false. It must not be used as a finished fabrication/capture example.

The encoder status likewise leaves protected +5-V field power, cable/termination selection, abnormal-condition qualification, schematic visual review, PCB integration, synthesis/place-route/timing, board integration, and human release open. Therefore BD09 describes a bring-up method, not a claim that OpenPressBrake Rev1 hardware is ready to energize.

## 1. Bring-up is an evidence ladder

Each stage earns permission to attempt the next stage. Do not jump from assembled board to machine connection.

1. **Identity** — prove which board revision, assembly variant, FPGA image, firmware/config, and machine configuration are under test.
2. **Unpowered inspection** — workmanship, polarity, population, connector orientation, assembly variants, obvious shorts, and expected isolation between domains.
3. **Unpowered electrical checks** — resistance/continuity checks chosen from the actual design. Do not invent a universal resistance threshold.
4. **Staged power** — energize the minimum justified domain first with an appropriate current limit derived from the design/test plan, not a guessed number.
5. **Rail and default-state proof** — verify rails and command/output defaults before enabling field interfaces.
6. **Digital identity/communications** — prove the expected FPGA/configuration is actually running.
7. **One interface at a time** — stimulate and observe one bounded signal chain while other machine hazards remain disconnected or otherwise controlled.
8. **Fault/default challenge** — remove command, reset logic, remove relevant power, or introduce another planned benign challenge and verify the expected state.
9. **LinuxCNC/HAL mapping** — prove software names and values correspond to the intended FPGA semantic channels.
10. **Machine connection** — connect only after unresolved machine facts needed by that interface are measured and accepted.
11. **Commissioning record** — preserve article identity, setup, observations, limits, failures, corrections, and regression triggers.

Freeze:

`FIRST POWER SUCCESS != BOARD QUALIFICATION`

## 2. Start with revision identity

Before measuring voltage, record:

- PCB revision and assembly serial/article ID;
- BOM/assembly variant;
- schematic/connectivity revision;
- FPGA device and image/config revision;
- LinuxCNC/LiteX-CNC configuration revision;
- board-specific connection-definition revision;
- machine/harness identity when attached;
- instrument identity where the measurement matters to acceptance.

Without this, a good measurement can become stale evidence with no reliable applicability boundary.

## 3. Pre-power inspection is design-specific

A useful inspection follows the actual power/domain graph rather than a generic checklist. Confirm expected polarity/orientation, DNP/populated variants, return-domain separation, connector pin numbering, protection placement, and any assembly option that changes behavior.

For the encoder slice, do not populate the 120-ohm termination merely because the footprint exists. The reusable contract deliberately makes termination selection a machine cable/end-topology fact. Likewise, do not assume encoder +5 V is available merely because the field connector reserves a 5-V semantic pin; protected encoder field supply is a board-integration gate still open in current status.

Freeze:

`FOOTPRINT PRESENT != VARIANT AUTHORIZED`

## 4. Resistance and short checks

Unpowered measurements answer bounded questions such as:

- Is a rail hard-shorted to its return?
- Are two domains that must remain separate accidentally continuous?
- Is chassis/PE incorrectly collapsed into a signal return?
- Does an expected resistor/termination path exist for the populated variant?

Acceptance values must come from the circuit and test plan. Semiconductor paths, capacitors, protection devices and parallel loads can make a generic ohms threshold meaningless.

Record the measurement direction, settling behavior when relevant, and exact nodes. `Looks about right` is not durable evidence.

## 5. Current-limited staged power

Do not energize every field domain at once merely because the final board eventually uses them together.

For each stage define:

- source domain and return;
- expected consumers;
- expected steady-state and startup behavior where known;
- current limit/ramp policy justified by the design and test equipment;
- rails/nodes to measure;
- stop criteria;
- domains intentionally left unpowered;
- possible back-power paths into those unpowered domains.

A current limit is a bring-up control, not proof that the design's production protection or fault coordination is correct.

Freeze:

`CURRENT-LIMITED BENCH SURVIVAL != FAULT-PROTECTION QUALIFICATION`

## 6. Prove rails before functions

Measure the rails at meaningful load points, not only at the bench-supply terminals. Verify polarity, magnitude against the design tolerance, unexpected rise on nominally unpowered domains, and relevant enable/default nodes.

For an interface crossing domains, repeat partial-power cases that are material to its architecture. A signal that behaves correctly with all rails present may back-power or float when one side is absent.

Do not turn this into arbitrary fault injection. Challenge only conditions the design/test plan can safely bound.

## 7. Prove FPGA/config identity before trusting names

The current encoder binding maps six LiteX-CNC encoder instances to explicit ENCn_A/B/Z semantic FPGA package balls. That is useful configuration authority, but the status explicitly says routed synthesis/place-route/timing evidence remains required before routed-fit claims advance.

At bring-up, prove the loaded image/configuration identity before interpreting a LinuxCNC/HAL value. Then trace:

`physical field pair -> receiver -> ENCn_A/B/Z semantic net -> FPGA package ball -> LiteX-CNC encoder instance -> LinuxCNC/HAL object`

Freeze:

`HAL NAME EXISTS != EXPECTED FPGA IMAGE IS LOADED`

and

`LOGICAL FPGA BINDING != ROUTED TIMING PROOF`.

## 8. Bring up one interface at a time

For an encoder channel, a bounded bench sequence can prove progressively more:

1. receiver rail and default state are sane;
2. controlled differential stimulus reaches the expected receiver output;
3. the expected semantic FPGA input changes;
4. the intended LiteX-CNC encoder instance observes A/B/Z behavior;
5. LinuxCNC/HAL exposes the intended channel behavior;
6. only after cable/termination/supply facts are known, the installed machine encoder is connected and checked over its required operating envelope.

Each step has a different witness. A HAL counter changing does not prove connector protection, cable termination, encoder supply quality, or physical machine position accuracy.

Freeze:

`SOFTWARE VALUE CHANGED != FIELD ELECTRICAL STATE PROVED`

## 9. Default and fault challenges

Before machine commissioning, challenge the ordinary-control states the block/board contract claims. Depending on the interface these can include FPGA reset/tri-state, command loss, field-side power loss, communications loss, or another explicitly designed condition.

For an encoder input, loss of input activity is not automatically a safe-machine state and receives no personnel-safety credit. The purpose is to characterize ordinary controller behavior and diagnostics.

For outputs, the physical output witness matters: a software command going false does not prove the field output de-energized.

## 10. Board-specific connection definitions are commissioning artifacts

The current Rev1 encoder connection file is valuable because it assigns Y1, Y2 and X connectors to ENC1/ENC2/ENC3 and explicitly owns every electrical pin disposition. It also demonstrates why connection definitions cannot be skipped: physical connector identity, mating hardware, placement, harness compatibility, cable facts and termination selection are still unresolved.

A commissioning procedure must therefore refuse machine attachment when the required physical connection facts are still `VERIFY_AT_MACHINE`.

Freeze:

`SEMANTIC PIN MAP COMPLETE != PHYSICAL HARNESS READY`

## 11. LinuxCNC/HAL commissioning is cross-domain tracing

Do not configure HAL by name resemblance alone. For every commissioned channel preserve a trace table:

| Layer | Required evidence |
|---|---|
| machine endpoint | measured/verified device and wiring identity |
| connection block | exact connector/pin/return/label/harness destination |
| reusable block | electrical function and semantic output/input |
| FPGA pin plan | semantic net to package pin |
| FPGA module | configured instance and behavior |
| LinuxCNC/HAL | exposed pin/parameter/function and direction |
| physical witness | stimulus or observed field behavior proving the mapping |

This same method transfers to mills, lathes, plasma tables, routers and robots; only the endpoint and reusable primitive change.

## 12. Commissioning evidence is not qualification evidence

A bring-up record can prove that a particular assembled article behaved correctly under a particular setup. It does not automatically prove:

- surge/ESD/EMC immunity;
- thermal performance over production limits;
- long-term reliability;
- all machine cable variants;
- FPGA timing closure unless actual synthesis/P&R/timing evidence exists;
- safety integrity or personnel-protection performance.

Preserve those as separate qualification gates.

## 13. Regression record

After successful commissioning, record what changes require which part of bring-up to repeat. Examples:

- FPGA image or package-pin plan change -> re-prove identity, binding, affected interfaces and required synthesis/P&R/timing evidence;
- receiver/protection/BOM change -> repeat affected electrical bring-up and qualification review;
- connector/harness change -> re-prove pinout, polarity, returns and machine endpoint;
- encoder/cable/termination change -> revisit termination selection, channel behavior and machine operating envelope;
- power-domain change -> repeat staged power, partial-power and affected interface checks.

A commissioning notebook without regression triggers becomes historical trivia rather than reusable evidence.

## Lab — write a staged commissioning card

Using only the four verified artifacts listed at the start of BD09, write a commissioning card for **one** encoder instance. Do not invent connector hardware, cable length/impedance, encoder current, termination choice, current limits, or machine speed.

The card must include:

1. article/revision identity fields;
2. unresolved facts that block machine attachment;
3. pre-power inspection points;
4. design-derived resistance/continuity questions without invented universal thresholds;
5. staged-power sequence with current-limit values marked `TBD_ENGINEERING` unless authoritative evidence supplies them;
6. rail/default-state witnesses;
7. FPGA/config identity witness;
8. the complete field-to-HAL trace;
9. one-interface-at-a-time stimulus/observation steps;
10. ordinary-control default/fault challenges;
11. explicit stop conditions and release blockers;
12. commissioning evidence record fields;
13. regression triggers.

### Lab pass criteria

A passing submission must:

- keep reusable block and board-specific connection ownership separate;
- refuse to guess every current `VERIFY_AT_MACHINE` fact;
- distinguish semantic pin mapping from physical connector readiness;
- distinguish LinuxCNC/HAL observation from a field electrical witness;
- distinguish first-power/commissioning success from qualification;
- preserve the FPGA logical-binding versus routed-timing distinction;
- preserve return/chassis boundaries;
- never award personnel-safety authority to the ordinary encoder/FPGA/LinuxCNC chain;
- make each successful stage a prerequisite for the next rather than energizing the whole machine at once.

## Catalog stress-test result

The encoder slice is explainable across reusable engineering, board-specific connection ownership and FPGA semantic binding without hidden logical ownership. That is a positive result for the block-catalog architecture.

The adversarial weakness is at the physical commissioning boundary: exact connector/harness identity, protected encoder field power, termination selection and installed cable/encoder facts remain unresolved. The catalog correctly exposes these as gates rather than silently embedding guesses in the reusable primitive. Therefore the correct curriculum response is to stop machine attachment at that boundary, not to fill the lesson with assumed values.

No OpenPressBrake engineering file is changed by BD09 because these are genuine physical/integration evidence gaps and current board engineering is active elsewhere.

## Durable freezes

- `FIRST POWER SUCCESS != BOARD QUALIFICATION`.
- `FOOTPRINT PRESENT != VARIANT AUTHORIZED`.
- `CURRENT-LIMITED BENCH SURVIVAL != FAULT-PROTECTION QUALIFICATION`.
- `HAL NAME EXISTS != EXPECTED FPGA IMAGE IS LOADED`.
- `LOGICAL FPGA BINDING != ROUTED TIMING PROOF`.
- `SOFTWARE VALUE CHANGED != FIELD ELECTRICAL STATE PROVED`.
- `SEMANTIC PIN MAP COMPLETE != PHYSICAL HARNESS READY`.
- `COMMISSIONED ORDINARY CONTROL != PERSONNEL-SAFETY AUTHORITY`.

## Safety boundary

This lesson commissions ordinary controller functions only. The encoder block explicitly receives no personnel-safety credit. LinuxCNC, LiteX-CNC, FPGA logic, normal-controller watchdogs and ordinary diagnostics must not be presented as the independent personnel-safety authority unless a separate safety-rated architecture and validation establishes that claim.
