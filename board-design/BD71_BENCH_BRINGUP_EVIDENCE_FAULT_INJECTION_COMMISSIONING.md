# BD71 — Bench Bring-Up as Evidence: Semantic I/O Checkout, Fault Injection, and Commissioning Records

Status: durable board-design curriculum lane

## Purpose

A board is not commissioned because it powers up, LinuxCNC shows changing values, or every channel appears to work once. Bring-up is an evidence-producing engineering activity. It must establish that the physical board, reusable block contracts, board-specific connections, FPGA resources, runtime semantics, default states, fault containment, and recovery behavior all describe the same system.

Design flow:

`accepted semantic binding -> powered-domain checkout -> known input stimuli -> inhibited output observation -> staged output energization -> fault/inhibit injection -> freshness/recovery test -> evidence record -> commissioning gate`

The central rule is:

**A successful actuation is not commissioning evidence unless the expected inactive, invalid, faulted, and recovery states were also tested.**

## Learning objectives

Students shall be able to:

1. turn block and board contracts into a staged bench bring-up plan;
2. separate inspection, unpowered checks, logic-power checks, field-power checks, inhibited-output checks, and energized functional tests;
3. prove input polarity and mapping with known physical stimuli rather than software-name consistency;
4. prove output defaults and inhibit behavior before permitting actuator energy;
5. inject ordinary-control faults without confusing them with personnel-safety validation;
6. test stale-command containment and explicit recovery after watchdog, reset, power, or transport events;
7. record expected versus observed behavior with instrument, revision, configuration, and evidence provenance;
8. stop commissioning when an observation contradicts the authority chain; and
9. distinguish bench-qualified evidence from machine verification and production qualification.

## 1. Bring-up starts before power

Before energizing a new board, freeze the exact artifact under test: board revision, BOM revision, schematic/netlist revision, FPGA image/configuration identity, software/runtime revision, connection-definition revision, and applicable block-contract revisions.

Record unresolved facts. `TBD`, `VERIFY_AT_MACHINE`, and `TBD_FROM_GENERATED_RUNTIME` are not inconveniences to erase during bring-up. They are stop conditions whenever the missing fact affects the proposed test's electrical safety, expected result, or interpretation.

Perform an unpowered review first:

- inspect orientation, assembly, obvious shorts, unpopulated options, jumpers, fuses and connector keying;
- verify expected resistance/isolation relationships between power domains and typed returns;
- confirm that distinct domains have not been accidentally shorted;
- identify measurement references before connecting instruments;
- confirm field connectors against the current board-specific connection authority; and
- establish which outputs must remain inhibited during initial power-up.

Do not use continuity measurements to infer an isolation or surge rating that the measurement cannot prove.

## 2. Evidence ladder

Use increasing authority and energy deliberately.

| Stage | Energy permitted | Primary evidence |
|---|---|---|
| A — inspection/unpowered | none | assembly, continuity/isolation sanity, connector identity |
| B — core/logic power | controller low-energy rails only | rail voltage, reset/config state, current draw, diagnostics validity |
| C — field interface observation | field/sensor supplies as justified, outputs inhibited | input thresholds/polarity, encoder/sensor observation, domain behavior |
| D — inhibited output command | command may change; actuator-facing enable remains denied | command propagation without field actuation, default/inhibit authority |
| E — staged energized output | only one bounded path at a time where practical | connector/output electrical behavior and feedback |
| F — fault/recovery | bounded energized state as test requires | containment, stale-command clearing, diagnostic truth, recovery |
| G — machine commissioning | only after bench gates and machine prerequisites | harness/actuator behavior, scaling, direction, timing, machine-specific acceptance |

Skipping directly to Stage E because software appears correct defeats the purpose of staged commissioning.

## 3. Current OpenPressBrake worked-example audit

Current OpenPressBrake main inspected for this lesson: `102a4065e577da37f1a8873184ed11923a2b23cb`.

### Student-facing readiness audit

The following files were opened and inspected in their current form during this lesson run:

- `hardware/REV1_BOARD_INTEGRATION.yaml` — **VERIFIED_FOR_LESSON** for current machine-specific ordinary-control I/O assignments, power-domain separation, hardware output-enable qualifiers, safe-state declarations, retained independent safety ownership, and explicit pre-release physical gates. It is not evidence that the physical board has passed bench commissioning.
- `hardware/REV1_CONNECTOR_MAP.yaml` — **VERIFIED_FOR_LESSON** for frozen electrical pinout intent and unresolved physical/mechanical gates. Its own status is `electrical_pinout_frozen_mechanical_parts_and_coordinates_tbd`; therefore it must not be used to invent connector manufacturer, footprint, mating condition, or coordinates.
- `hardware/blocks/digital_input_24v/manifest.yaml` — **VERIFIED_FOR_LESSON** for the reusable ISO1212 input semantic/electrical contract, logic-side resource demand, typed field return, FPGA-side output, protection envelope, and declared open/TBD items.
- `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for the block's current `SIMULATION-READY` maturity boundary and exact open release gates. It explicitly forbids describing the block as schematic-ready or Rev-1-ready while those gates remain open.
- `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for the distinction between integration baseline, schematic readiness, Rev-1 readiness, and evidence truthfulness.
- `board-design/BD70_LINUXCNC_HAL_SEMANTIC_BINDING_FRESHNESS_DIAGNOSTIC_TRUTH.md` — **VERIFIED_FOR_LESSON** after current-main re-open as the prerequisite semantic/freshness method.

These sources support a bring-up method. They do **not** establish that the current OpenPressBrake controller is production-proven.

### Positive example: one ordinary digital input

Use an ordinary ISO1212-backed machine input as a bounded teaching path. The reusable block converts a protected industrial field input into a deterministic 3.3-V FPGA logic result. The board contract assigns individual machine signals to connector pins and FPGA resources. The bench test must therefore prove the path from a known physical stimulus to the physical receiver output/FPGA observation and then to the runtime semantic observation.

Do not begin by toggling a machine wire of uncertain source behavior. On the bench, use a current-limited, electrically appropriate stimulus within the declared block envelope and a known return reference. Exact test voltage/current values must come from the current electrical contract and test plan; do not invent machine-specific source impedance or harness behavior.

The evidence record must include at least:

- semantic signal ID/name;
- connector/contact under test;
- reusable block instance/channel;
- stimulus source and return reference;
- expected OFF and ON interpretation;
- measured connector voltage where appropriate;
- FPGA/runtime observation;
- polarity result;
- power-validity state;
- observed invalid/unpowered behavior; and
- pass/fail with evidence reference.

A changing HAL bit alone proves neither the connector pin nor the field electrical envelope.

### Positive example: output authority before output energy

The board integration contract declares ordinary output safe states inactive and proportional output permission as the hardware conjunction of `PILZ_VALVE_ENABLE`, `WATCHDOG_OK`, `FPGA_CONFIGURED`, and `CORE_POWER_GOOD`, with a software-only path forbidden.

Bring-up must therefore demonstrate the negative case before energized actuation: while the applicable hardware permission is denied, issue or observe a bounded software/FPGA command and confirm that the actuator-facing output remains inactive. Only after this passes may the test advance to a staged energized-output test.

The retained Pilz path remains the independent safety authority. This bench exercise validates ordinary-control containment and wiring; it does not certify the Pilz system or grant LinuxCNC/FPGA personnel-safety credit.

## 4. Input checkout matrix

For each input class, define four observations:

1. **electrical stimulus** — what physical condition is deliberately applied;
2. **conditioned state** — what the reusable block should produce;
3. **runtime semantic state** — what the current generated/runtime mapping reports;
4. **invalid-state behavior** — what happens when the sensing/logic domain is absent or invalid.

Test both polarities/states and transitions. For encoders or analog sensors also test scaling/direction/units where evidence supports doing so. Do not infer sensor accuracy from mapping continuity.

A useful failure is a mismatch that localizes the problem. For example, correct receiver output but wrong runtime state points downstream of the receiver; wrong receiver output with correct connector stimulus points into the electrical path. Record that distinction instead of changing software until the symptom disappears.

## 5. Output checkout matrix

For every energy-producing output, separate these observations:

- software/application command;
- FPGA/firmware command state;
- hardware qualifier/inhibit state;
- driver input state;
- driver/output-stage state where observable;
- connector voltage/current or other electrical result;
- independent field feedback if one exists; and
- actual actuator motion/energy only when the test has reached that stage.

Test at minimum:

- command inactive, qualifier denied;
- command active, qualifier denied;
- command inactive, qualifier present;
- command active, qualifier present only after prerequisites pass;
- qualifier removed while command is active;
- field power removed/returned;
- core/logic reset or reconfiguration where the contract requires it; and
- recovery without stale-command resurrection.

Never label a command observation as actuator feedback.

## 6. Fault injection is contract verification

Fault injection is question-driven. Inject only a fault whose expected containment and recovery behavior is defined and whose test can be performed without creating an uncontrolled hazard.

Ordinary-control examples include:

- watchdog/progress timeout;
- transport/session loss;
- FPGA reset/reconfiguration;
- core-power-good removal;
- hardware output-enable removal;
- field-power loss and restoration;
- sensor/input power invalidation; and
- open-circuit or bounded simulated field conditions when the interface contract supports them.

For each injection record:

`precondition -> injected fault -> expected immediate containment -> expected diagnostic -> expected stale-state handling -> allowed recovery trigger -> observed result`.

Do not inject destructive overvoltage, surge, short-circuit, thermal, or machine-motion faults merely because the block claims a survival envelope. Those require a specific qualified setup and evidence plan.

## 7. Freshness and recovery test

BD69 and BD70 established that a pre-fault active command cannot silently become valid again merely because transport, field power, watchdog, or a global qualifier returns.

A commissioning record for an energy-producing command must therefore answer:

1. Was an active command present before the fault?
2. Which event invalidated the command epoch?
3. Did the actuator-facing output become inactive as required?
4. Did restoration of the failed prerequisite alone leave the output inactive?
5. What explicit fresh command/re-arm/recovery event was required?
6. Was a neutral/inactive command required before reactivation?
7. Did diagnostics distinguish connected/healthy from command-fresh and output-permitted?

If the implementation does not yet define these semantics, classify the test **BLOCKED_BY_CONTRACT**, not pass-by-observation.

## 8. Commissioning evidence record

A durable record should contain:

- test ID and semantic requirement ID;
- date/time and operator/reviewer;
- board serial/revision and assembly deviations;
- schematic/BOM/netlist/connection-definition revisions;
- FPGA bitstream/configuration identity;
- LinuxCNC/LiteX-CNC/runtime revision and generated configuration identity;
- instrument IDs and relevant setup/range;
- supply settings/current limits;
- wiring/fixture identity;
- exact preconditions;
- expected result written before the observation;
- measured/observed result with units;
- diagnostic/runtime observations;
- photos/captures/log references where useful;
- pass/fail/block classification;
- anomalies and corrective action; and
- retest linkage after a change.

A corrected failure must not erase the original evidence. Preserve the failed observation, change, and retest so the evidence chain remains auditable.

## 9. Promotion gates

Use explicit gates rather than a single `tested` flag.

- `ASSEMBLY_INSPECTED`
- `UNPOWERED_DOMAIN_CHECK_PASSED`
- `CORE_POWER_CHECK_PASSED`
- `INPUT_PATHS_SEMANTICALLY_CHECKED`
- `OUTPUT_DEFAULTS_AND_INHIBITS_CHECKED`
- `STAGED_OUTPUT_ELECTRICAL_CHECKED`
- `FAULT_CONTAINMENT_CHECKED`
- `FRESHNESS_RECOVERY_CHECKED`
- `BENCH_COMMISSIONING_ACCEPTED`
- `MACHINE_VERIFICATION_ACCEPTED`

A board may pass bench commissioning while machine-specific harness, load, timing, thermal, mechanical, or acceptance facts remain `VERIFY_AT_MACHINE`. Bench acceptance is not production qualification.

## 10. Stop conditions

Stop the current bring-up step when:

- a connector/mechanical fact needed for safe hookup is still unresolved;
- measured domain continuity contradicts the intended isolation/return architecture;
- supply current materially exceeds the evidence-backed expectation;
- a supposedly inhibited output energizes;
- a diagnostic claims validity while its observation domain is unpowered/invalid;
- a field pin maps to a different semantic function than the current authority says;
- an old command reappears after a freshness-invalidating event;
- a safety-owned function appears to have been moved into ordinary LinuxCNC/FPGA authority;
- test equipment reference/grounding would collapse an intended isolated domain; or
- the test requires a machine fact that is still `VERIFY_AT_MACHINE/TBD`.

A stop condition creates an engineering defect/action item. It is not permission to bypass the gate.

## 11. Catalog stress-test result

Teaching bring-up exposes a catalog defect that static electrical/resource contracts alone cannot close: there is not yet a common machine-readable **commissioning contract** joining semantic IDs to bench stimuli, expected observation points, required power domains, default/inhibit expectations, fault injections, freshness-invalidating events, recovery prerequisites, evidence records, and qualification level.

Add this as a catalog/tooling requirement rather than embedding unwritten bench knowledge in one board's lesson. A future commissioning manifest should be able to answer:

- What can be safely tested before field power?
- Which measurement reference is valid?
- What observation proves only mapping, and what proves electrical behavior?
- Which inhibit must be demonstrated before output energy is allowed?
- Which faults must be injected for this resource class?
- Which recovery events require a fresh command epoch?
- Which facts remain machine-only?
- What evidence promotes a channel or board to the next gate?

The current `digital_input_24v` block illustrates why this matters. Its manifest carries rich electrical/resource information and its checklist truthfully remains `SIMULATION-READY`, but neither artifact is a complete bench-commissioning procedure. The curriculum must not silently invent the missing procedure and then present it as block qualification.

OpenPressBrake remains read-only in this lesson because current main is actively advancing block resource/power closure. The curriculum records the catalog requirement without racing that work.

## 12. Transfer beyond a press brake

The same evidence ladder applies to:

- mill limit/probe inputs and spindle/VFD outputs;
- lathe spindle encoder, chuck/clamp monitoring and drive commands;
- plasma arc-ok/torch-height inputs and torch command;
- router spindle/vacuum/contactors;
- robot joint drives, brakes and encoder feedback; and
- custom automation valves, heaters, pumps and sensors.

Reusable block tests transfer. Machine harness identity, actuator direction, scaling, load current, acceptable timing and independent safety validation remain machine-specific.

## 13. Lab deliverable

Given an accepted semantic binding, current board connection definitions, reusable block contracts, board integration contract and generated/runtime configuration, produce:

1. a staged bring-up plan from unpowered inspection through bounded energized tests;
2. an input checkout matrix;
3. an output authority/default/inhibit checkout matrix;
4. at least five bounded ordinary-control fault-injection cases;
5. a stale-command/freshness recovery test;
6. a commissioning evidence-record template populated for at least one input and one output path;
7. explicit stop conditions and unresolved facts; and
8. a promotion decision using the commissioning gates above.

A passing answer must show not only that a channel can work, but that its inactive, invalid, inhibited, faulted and recovery behavior matches the current authority chain.

## Safety boundary

This curriculum validates ordinary controller hardware and integration. LinuxCNC, HAL, FPGA logic, watchdogs, output inhibits, diagnostics, and monitored Pilz/SICK/AKAS states receive no personnel-safety credit from these bench tests. Independent safety functions require their own safety-rated design, validation and commissioning process.

## Next checkpoint

BD72 — Qualification Evidence Packages, Traceability, and Release Promotion:

`commissioning evidence -> requirement/evidence traceability -> unresolved-fact disposition -> block-versus-board qualification boundary -> regression obligations -> release review -> qualified baseline without overclaiming`
