# BD17 — Startup, Reset, Partial-Power, and De-Energized-State Contracts

**Lane:** independent LinuxCNC/OpenPressBrake board-design curriculum  
**Track:** BLOCK ENGINEERING with BOARD INTEGRATION stress testing  
**Design-flow position:** reusable block behavior -> cross-domain startup lifecycle -> board output authority -> commissioning evidence

## Purpose

BD04 established local output defaults and watchdog authority. BD05 traced board power/return domains. BD17 now asks the adversarial lifecycle question across block classes:

`power absent -> partial rails -> reset asserted -> configuration -> configured but inhibited -> enabled -> watchdog/fault -> brownout -> recovery -> power-down`

A reusable block is incomplete if an integrator must guess what it does while only some of its rails or external interfaces are powered. The contract must describe not only normal operation, but also unpowered-input behavior, startup defaults, reset behavior, enable ownership, back-power risks, brownout behavior, recovery requirements, and what physical state is expected before explicit command authority exists.

Core rule:

**NORMAL-OPERATION CONNECTIVITY IS NOT A STARTUP/SHUTDOWN CONTRACT.**

## Learning outcomes

By the end of BD17, the student can:

1. build a lifecycle/state matrix for a reusable block;
2. distinguish local electrical default state from board-level output authorization;
3. identify partial-power and back-power paths across field, logic, isolation, USB/service, and FPGA domains;
4. separate `expected by topology`, `datasheet-backed`, `structurally proved`, `bench proved`, and `still unknown` behavior;
5. require explicit reset, enable, pull/bias, and recovery ownership;
6. distinguish an input's electrical survivability from the validity of its reported logic state;
7. trace whether any machine load can energize before explicit authorization;
8. preserve ordinary-control fault containment without claiming personnel-safety authority;
9. recognize missing lifecycle metadata as a reusable-catalog defect rather than board-integrator tribal knowledge.

## Student-facing source audit

The following CURRENT OpenPressBrake `main` artifacts were opened directly during this run. They are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- `hardware/blocks/digital_output_24v/manifest.yaml` — reusable output semantic interfaces, declared `power_off_state`, `watchdog_state`, field/logic rails, and the requirement that command loss resolve OFF at system integration.
- `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — current distinction between the simulation-ready non-isolated primitive and the first-machine isolated path, including field-side deterministic OFF authority and open qualification/capture gates.
- `hardware/blocks/digital_input_24v/manifest.yaml` — current isolated-input electrical contract, field/logic domains, output-enable implementation choice, field transient envelope, and FPGA-side interface.
- `hardware/blocks/fpga_core_ecp5_25/manifest.yaml` — current watchdog/supervisor architecture, asynchronous global-output-enable equation, core power sequencing intent, USB self-powered/VBUS-detect boundary, and explicit no-safety-credit boundary.
- `hardware/4000-board-design/BD04_DEFAULT_STATE_OUTPUT_AUTHORITY_WATCHDOG_AND_FAULT_CONTAINMENT.md` in this curriculum — reopened to ensure BD17 extends rather than duplicates the earlier output-only lesson.

These files are not evidence that the complete OpenPressBrake controller is released. The output status still leaves exact first-machine isolated connectivity, abnormal-condition qualification, PCB thermal/current-path qualification, and final release open. The FPGA core still contains open dynamic power/startup and physical-interface qualification work.

## 1. Treat lifecycle states as part of the block contract

For every block, define behavior at least for:

| State | Questions the contract must answer |
|---|---|
| all power absent | Are field pins passive? Are outputs guaranteed de-energized? |
| field/external power only | Can an unpowered logic pin be back-powered? Can an output assert? |
| logic power only | What happens at field pins? Are external unpowered devices driven? |
| rails ramping | Which nodes can be undefined? Which hardware defaults dominate? |
| reset asserted | What is driven, high-Z, or physically inhibited? |
| FPGA unconfigured | What physical pulls/gates prevent accidental actuation? |
| configured but inhibited | Can software-visible commands exist without field authority? |
| enabled | What conditions must all be true before energy reaches a load? |
| watchdog timeout | Which physical node changes and what downstream state follows? |
| brownout | Which supervisor/gate acts first? Can outputs chatter or briefly reassert? |
| recovery | Is explicit reauthorization required or does the function automatically resume? |
| power-down | Which domain falls first, and can stored/external energy back-feed another domain? |
| connector hot-plug | What unpowered-input, clamp, inrush, transient, and return paths exist? |

Do not fill a cell with `safe` or `off` unless the physical mechanism and evidence class are identified.

## 2. Three separate claims: survivability, validity, authority

Partial-power review becomes clearer if three questions are kept separate:

1. **Survivability** — can the hardware tolerate this powered/unpowered combination without damage or violating an absolute maximum?
2. **Validity** — is the signal/state meaningful in this condition?
3. **Authority** — can this condition cause machine energy to be commanded or enabled?

An isolated digital input may survive field voltage while the FPGA side is unpowered, yet its FPGA-side logic state is not meaningful until the logic domain is valid. Conversely, a powered FPGA signal may be logically valid while a field-side output domain is absent; that does not mean the load is authorized or energized.

Freeze:

**SURVIVES PARTIAL POWER != SIGNAL VALID != OUTPUT AUTHORIZED.**

## 3. OpenPressBrake output example: local OFF versus complete lifecycle proof

The current `digital_output_24v` manifest declares `power_off_state: output_off` and `watchdog_state: output_off`. It also says command loss or watchdog expiry must resolve to output OFF at system integration. That is a useful reusable requirement, but it does not by itself prove every first-machine partial-power combination.

Current first-machine status provides stronger architecture evidence: the isolated L7/L07 output path retains a field-side IPS1025H input pull-down as deterministic OFF authority, keeps the switched field-side `SWITCHED_IO_5V` supply on the same L07 domain, and forbids an L07-to-L06 logic-ground bridge.

This gives a good design pattern:

`upstream command absent/undefined -> isolation path cannot be treated as authority -> field-side physical pull-down -> switch input inactive`

But the status also keeps exact rendered first-machine connectivity, abnormal-condition qualification, and thermal/current-path release open. Therefore students may say **the architecture intentionally provides a local OFF mechanism**; they may not say **every brownout/hot-plug/back-power case is production-qualified**.

**DECLARED DEFAULT STATE != QUALIFIED EVERY-SEQUENCE BEHAVIOR.**

## 4. FPGA core example: authorization must fail low before software can help

The current FPGA-core manifest contains a strong board-level ordinary-control pattern. Its external hardware watchdog/supervisor requires outputs disabled during reset, configuration failure, brownout, or watchdog timeout. `GLOBAL_OUTPUT_ENABLE` is an asynchronous hardware equation:

`(PG_1V1 & PG_2V5 & PG_3V3) & (CORE_3V3_RESET_N & WATCHDOG_OK_N & FPGA_DONE)`

The output has a physical pull-down and no FPGA/software bypass.

This matters because an FPGA cannot be trusted to execute a firmware-defined inhibit while it is unconfigured, held in reset, or below a valid rail threshold. The authorization path must already have a defined physical state.

Freeze:

**SOFTWARE CANNOT BE THE ONLY AUTHORITY THAT DISABLES OUTPUTS BEFORE SOFTWARE/FPGA STATE IS VALID.**

The same manifest also keeps power startup current and final dynamic qualification open. The equation is strong structural authority; it is not a substitute for proving regulator ramp, supervisor thresholds, propagation, chatter immunity, or every brownout waveform on the assembled board.

## 5. Input blocks need lifecycle contracts too

The current isolated `digital_input_24v` manifest is detailed about field voltage, isolation, thresholds, transient envelope, EMC capacitance, logic supply, and FPGA-side signal ownership. It freezes `output_enable: tied_to_3V3` for the selected receiver topology.

However, the inspected manifest does not provide the same explicit lifecycle matrix that BD17 requires for questions such as:

- field input energized while logic 3V3 is absent;
- logic 3V3 present while the field side is unpowered;
- exact FPGA-side output behavior during 3V3 ramp/down;
- whether any output pin can source current into an unpowered FPGA bank;
- when `INPUT_STATE` becomes valid after logic power returns;
- whether hot-plug or field transients can inject into another unpowered domain beyond the declared isolation/EMC path.

Do not infer those answers merely from the word `isolated` or from normal-operation pin descriptions.

This is a catalog stress-test finding: **input blocks need explicit lifecycle/partial-power metadata even when they cannot directly energize a machine load.** Until backed by datasheet/circuit/bench evidence, these behaviors remain `ENGINEERING_REVIEW_NEEDED`, not student assumptions.

## 6. Back-power audit method

For each state in which one domain is powered and another is not, trace every conductive path crossing the boundary:

- IC input/output protection structures;
- isolator I/O and enable pins;
- pull-ups/pull-downs to a rail that may be absent;
- series resistors and level shifters;
- TVS/clamp structures;
- USB VBUS detect/service paths;
- FPGA I/O banks and configuration pins;
- status/diagnostic outputs;
- analog-input clamps;
- communication transceivers;
- external machine devices that remain powered;
- stored energy in bulk capacitors or inductive loads.

Record the possible source, path, sink, limiting impedance, maximum current/voltage, device unpowered-input specification, and evidence. A schematic net name such as `3V3` does not prove that another unpowered rail cannot be lifted through an I/O path.

**GALVANIC ISOLATION AT ONE SIGNAL PATH != NO BACK-POWER PATHS ANYWHERE IN THE COMPLETE BLOCK/BOARD.**

## 7. Reset and configuration are physical states, not software events

For FPGA/MCU-controlled hardware, explicitly separate:

- power-good threshold reached;
- reset asserted;
- reset released;
- configuration loading;
- configuration failed;
- configuration complete;
- gateware alive but watchdog not yet valid;
- host/LinuxCNC communication established;
- ordinary output authorization granted.

A block that says only `default low in firmware` has not defined behavior before firmware owns the pin.

For each command/enable pin identify:

- external pull/bias;
- internal pull assumptions, if relied upon;
- high-Z behavior;
- power-domain source of the pull;
- whether the pull still exists during partial power;
- whether an isolator/transceiver can invert or float the downstream node;
- what physical element finally prevents load energy.

## 8. Brownout and recovery need separate requirements

A good fail-low design can still behave badly during a slow or oscillating supply collapse. Review:

- supervisor thresholds and hysteresis;
- regulator UVLO/PG behavior;
- reset assertion/deassertion thresholds;
- watchdog state as its own rail collapses;
- combinational gate supply validity;
- FPGA DONE/configuration behavior;
- downstream enable propagation;
- load-driver UVLO behavior;
- whether a recovering rail automatically re-enables a previously commanded output.

The preferred ordinary-control policy is usually that recovery re-establishes valid rails/configuration/watchdog first and then requires current control authority before a load can energize. Do not claim that policy is implemented unless the whole chain proves it.

**FAIL-LOW DURING STEADY RESET != PROVED GLITCH-FREE BROWNOUT/RECOVERY.**

## 9. Hot-plug is a partial-power event

Treat connector insertion/removal as a state transition, not merely a mechanical event. Depending on the interface, ask:

- which contact mates first/last;
- whether signal arrives before return;
- whether field power arrives before local logic;
- cable capacitance/inrush;
- inductive disconnect energy;
- ESD/EFT exposure;
- clamp-current return path;
- whether external power can feed an unpowered board;
- whether the reported signal is valid during contact bounce;
- whether connector sequencing is actually guaranteed by the selected hardware.

If connector identity or mating sequence is not yet frozen, preserve this as a board/connection qualification gate rather than inventing an insertion sequence.

## 10. Required machine-readable lifecycle object

The catalog stress test suggests that lifecycle behavior should become first-class machine-readable block data rather than prose scattered across manifests and status files. A useful future object would contain, per block/variant:

- domains/rails and externally powered interfaces;
- local default-state mechanism;
- reset state;
- unconfigured-controller state;
- enable ownership and polarity;
- watchdog response;
- field-only behavior;
- logic-only behavior;
- unpowered-input tolerance/reference;
- known back-power paths and limits;
- brownout behavior/unknowns;
- recovery/restart policy;
- hot-plug assumptions;
- signal-valid criteria;
- physical-output-authority criteria;
- evidence references and maturity;
- regression triggers.

This object belongs to the reusable electrical block where behavior is intrinsic. Board integration then composes multiple lifecycle contracts and owns sequencing/authorization that crosses block boundaries.

Do not copy machine-specific J-numbers, connector destinations, or package-pin assignments into this reusable object.

## 11. Board-level lifecycle composition

Once each block has a local lifecycle contract, board integration must compose them. Build a matrix with rows for board states and columns for blocks/domains. At minimum include:

`24V machine source | switched field power | core 5V | core 3V3/2V5/1V1 | FPGA configured | watchdog valid | GLOBAL_OUTPUT_ENABLE | output field-side rail | command path | physical load state`

Then challenge combinations that normal startup does not intend but faults can create:

- field power present, core absent;
- core present, field power absent;
- one core regulator failed;
- FPGA DONE absent;
- watchdog invalid with FPGA still driving commands;
- service USB connected while main power is absent;
- machine input energized into an unpowered controller;
- one isolated field-side supply absent while logic remains active;
- brownout recovery while LinuxCNC retains a prior command.

Every impossible state must be impossible because of topology/authority, not because the startup script “should never do that.”

## 12. Adversarial lab

Choose one input, one output/driver, and one compute/control block. Produce:

1. a rail/domain diagram;
2. a lifecycle matrix covering all states in Section 1;
3. a back-power path audit for every powered/unpowered domain pair;
4. a reset/configuration/default-bias trace;
5. a physical output-authority equation where applicable;
6. a signal-valid criterion for each input/status output;
7. a brownout/recovery sequence with unknowns explicitly marked;
8. a hot-plug qualification list;
9. an evidence table classifying each cell as datasheet-backed, calculated, structural, simulated, bench-tested, machine-verified, inferred, or unknown;
10. a catalog-defect list for every answer that required unwritten knowledge.

A passing submission may contain `TBD`, `VERIFY_AT_MACHINE`, and `ENGINEERING_REVIEW_NEEDED`. It may not convert absence of evidence into a deterministic claim.

## 13. Catalog stress-test result

The current OpenPressBrake catalog already carries several strong pieces of lifecycle information: the digital-output manifest declares power-off/watchdog OFF requirements; the first-machine output status identifies a physical field-side pull-down; and the FPGA core freezes a fail-low hardware output-enable equation that depends on rails, reset, watchdog, and FPGA DONE.

The adversarial gap is consistency. The inspected digital-input manifest is rich in normal electrical/transient behavior but does not expose an equally explicit field-only/logic-only/ramp-down/signal-valid/back-power contract. Similar review should eventually be applied to analog inputs, encoders, RS-485, proportional drivers, service interfaces, and shared-resource blocks.

Therefore the durable catalog improvement is not “add another board-specific enable.” It is:

**MAKE LIFECYCLE/PARTIAL-POWER BEHAVIOR A REUSABLE BLOCK CONTRACT WITH EVIDENCE AND UNKNOWN STATES.**

No OpenPressBrake engineering file is changed by BD17 because the active board-development lane is currently changing core/machine-power integration, and a schema/catalog change would overlap that work. The curriculum records the defect without racing current engineering.

## 14. Safety boundary

Default-low outputs, watchdogs, hardware enables, supervisors, isolation, brownout handling, and back-power containment are important ordinary-control engineering. They do not become personnel-safety functions merely because they are hardware-enforced.

The independent Pilz/AKAS/SICK safety system remains authoritative for personnel protection on the OpenPressBrake example. BD17 asks whether the ordinary controller behaves deterministically and contains faults; it does not assign safety credit to FPGA/LinuxCNC control.

## 15. Compute policy

No executable simulation or FPGA run is needed for this lesson. The current source artifacts already expose both positive lifecycle contracts and missing lifecycle metadata. Running an unchanged model would not prove the missing partial-power/hot-plug/brownout cases.

When future executable verification is genuinely required, it must run only on `[self-hosted, openpressbrake]`. Missing physical evidence remains an open qualification gate rather than a reason to use hosted compute.

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

## Next lesson

BD18 should return to board integration and build a **whole-board partial-power and back-power matrix** from multiple block lifecycle contracts. It should trace machine 24 V, switched field domains, core 5 V, core subrails, service USB/VBUS detection, encoder/analog field supplies, proportional power, isolated I/O supplies, external powered sensors/drives, and all cross-domain signal paths. The goal is to prove that no unintended board state silently bypasses output authority or damages an unpowered domain, while preserving unresolved physical cases as qualification gates.