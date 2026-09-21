# BD02 — Proven Reference to Reusable Block Contract

Status: **DURABLE LESSON / VERIFIED EXAMPLE WITH OPEN RELEASE GATES**  
Lane: 4000 board-design curriculum  
Date: 2026-09-21

## Purpose

Teach the block-engineering flow:

`BLOCK REQUIREMENTS -> PROVEN REFERENCE -> DELTA TABLE -> CALCULATIONS -> PROTECTION/FAULT CONTAINMENT -> DEFAULT STATE -> MACHINE-READABLE RESOURCES -> VERIFICATION GATES`

The goal is not to copy a circuit blindly. The goal is to preserve a proven topology where it fits, identify every meaningful delta, calculate the changed envelope, expose integration consequences, and refuse to turn unknown machine facts into block constants.

## Student-facing current-file audit

Every OpenPressBrake file named below was opened from current `main` during this run.

| Artifact | Readiness for this lesson | Allowed use |
|---|---|---|
| `hardware/blocks/REFERENCE_BASELINE_POLICY.md` | **VERIFIED_FOR_LESSON** | Required method for reference selection, coverage classification, independent redraw, delta recording, and verification scope. |
| `hardware/blocks/differential_encoder/REFERENCE_REBASE.md` | **VERIFIED_FOR_LESSON** | Worked provenance/reference/delta example. It does not prove full block release. |
| `hardware/blocks/differential_encoder/engineering.yaml` | **VERIFIED_FOR_LESSON** | Worked machine-readable ownership, parameter, calculation, invariant, evidence and recalculation-trigger example. |
| `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md` | **VERIFIED_FOR_LESSON** | Worked example of evidence gates that remain open after a strong reference rebase. |

The current `analog_input` block was also inspected while selecting the example and is **INCOMPLETE_NOT_STUDENT_MATERIAL** for this lesson: its status says its machine-readable authorities still contain stale contradictory 120-ohm/5-V/direct-drive versus Rev31 100-ohm/REF5020/shared-driver assumptions. It must not be taught as a coherent finished block until that reconciliation is complete.

## 1. Start from requirements, not a favorite circuit

Write the reusable electrical requirement before selecting parts. For a differential incremental encoder receiver, the reusable requirement is a field-side differential A/B/Z receiver producing logic-level A/B/Z signals. It is not `Y1 scale`, `X axis`, `J17`, or a particular FPGA ball. Those are machine/board bindings.

Required contract questions include input/output electrical class, supply domain, normal envelope, abnormal/miswire envelope, protection boundary and return path, timing/accuracy requirement, startup/unpowered behavior, enable behavior, PCB constraints, shared-resource demand, configurable variants, evidence authority, and facts that must remain external to the block.

## 2. Reference hierarchy is an engineering control

The OpenPressBrake reference policy requires the closest inspectable proven topology first, then manufacturer cross-checking, independent project capture, and a delta table. Coverage is classified rather than exaggerated: `EXACT`, `ADAPTABLE`, `PARTIAL`, or `ABSENT`.

For the encoder example, the inspected reference rebase records a released LinuxCNC/LiteX-CNC-facing HUB75HAT encoder circuit using the AM26LV32 receiver family, a pinned LiteX-CNC encoder implementation for FPGA behavior, and manufacturer AM26LV32E authority. OpenPressBrake then records its own industrial-cabinet deltas instead of pretending the reference proves those deltas.

### Rule

**Reference provenance is not qualification.** A released reference proves useful prior art for the portion actually matched. Every changed voltage, protection network, environment, connector exposure, return path, timing assumption, or integration context creates its own verification obligation.

## 3. Delta table drives calculations

For each delta, write:

`reference behavior -> project change -> reason -> calculation/evidence -> remaining verification`

The encoder example changes a board-sized reference into a one-encoder reusable primitive, selects an exact production receiver/package, adds connector-edge pair protection to `CHASSIS_PE`, provides populated/DNP termination variants, leaves field power outside the primitive, and reuses the pinned LiteX-CNC decoder instead of inventing another one.

A student must be able to explain why each delta exists and which evidence does **not** transfer from the reference.

## 4. Calculations must expose integration consequences

A reusable block should publish formulas whose inputs belong to the block and board integration without freezing board-specific values inside the primitive. The current encoder knowledge package provides examples:

- maximum receiver 3.3-V contribution = `instances * 0.017 A`;
- FPGA GPIO demand = `instances * 3`;
- receiver package count = `instances`;
- installed-rate compatibility remains blocked until installed encoder rate and cable/termination facts exist.

The block therefore scales cleanly from one encoder to several without becoming a hidden fixed-size board subsystem.

### Derating worksheet

For any new block, the student must record at least: nominal, min and max supply; normal and abnormal current/voltage; component absolute maximum versus intended operating limit; power dissipation and thermal assumptions; timing/bandwidth/accuracy margins where applicable; tolerance contributors; and which values are datasheet facts, calculations, measurements, simulations, or unknowns.

A number without provenance is not an engineering margin.

## 5. Protection is a current-path problem

Do not document protection as `TVS present`. Trace the fault current from the external pin to its intended sink/return and ask what else shares that path. The encoder example deliberately returns connector-edge pair protection to `CHASSIS_PE`; the current files explicitly avoid turning that component choice into a board-level surge/ESD qualification claim.

For every protected interface, document protected conductor, stress class/question, clamp/protector, series impedance/current limiter where used, return destination, normal loading/capacitance penalty, downstream absolute-max relationship, fault containment boundary, and physical placement constraint.

If the intended return cannot be traced through the eventual PCB/connector/chassis architecture, protection is not finished.

## 6. Startup, default, disabled and de-energized states

Every block contract must state behavior for power absent, power ramp, FPGA unconfigured, ordinary enable absent, watchdog/output inhibit asserted, field power absent while logic power exists, logic power absent while field wiring is energized where applicable, and recovery after a fault or brownout.

The encoder example is intentionally modest: receiver enables are fixed active and the block is ordinary feedback only. It therefore cannot be used to teach that an ordinary FPGA output is a personnel-safety shutdown authority. For output blocks, later lessons must demand explicit hardware default/inhibit behavior and trace who owns output authority before configuration.

## 7. Machine-readable resource declaration

A reusable block must make board planning possible without reading prose and guessing. At minimum expose:

- logic I/O count and direction;
- voltage/domain requirements;
- per-instance current budget and startup/fault additions where relevant;
- bus/interface resource and address/chip-select needs;
- clock/PLL/timing needs;
- LUT/FF/BRAM/DSP estimates or measured synthesis evidence where FPGA logic is owned by the block;
- interrupt/DMA/CPU requirements where relevant;
- connector-side semantic signals, but not board-specific connector identities;
- placement/routing/return constraints;
- recalculation triggers when instance count or machine configuration changes.

Unknown FPGA implementation cost must remain unknown until synthesis or other justified evidence exists. Do not invent LUT/BRAM/timing numbers.

## 8. Adversarial lab — can another board use this block?

Choose a new machine context such as a lathe spindle encoder, plasma gantry encoder, router spindle index, or robot joint encoder. Using the verified encoder artifacts, produce:

1. reusable requirements that remain unchanged;
2. machine facts that must be newly measured or sourced;
3. board resource equations for `N` instances;
4. termination-selection evidence required before choosing populated versus DNP;
5. field-power requirements that belong outside the receiver primitive;
6. a protection-current-path sketch naming the intended return domain;
7. startup/default-state table;
8. explicit release gates still open.

Fail the exercise if the learner renames the reusable circuit after the machine, chooses termination from habit, invents installed cable/current/rate facts, assigns FPGA balls inside the primitive, or claims safety credit from ordinary encoder feedback.

## 9. Catalog stress-test findings

The verified encoder package is teachable because its machine-readable knowledge separates reusable ownership, board integration, machine configuration and evidence, and because its status checklist refuses to equate a completed reference rebase with full release.

The current analog-input conflict is the opposite lesson: contradictory machine-readable authorities make a block unsuitable as finished student material even when much of its engineering is strong. Curriculum must not paper over catalog inconsistency.

One catalog gap remains visible even in the good encoder example: resource planning is strong for GPIO and receiver current, but the FPGA behavioral resource cost is inherited from LiteX-CNC and is not expressed here as quantified LUT/FF/BRAM/timing evidence. That is acceptable for this lesson because no such numbers are claimed. A later FPGA-resource lesson must obtain real synthesis evidence on the permitted local runner before teaching quantitative FPGA fit.

## Safety boundary

This is ordinary controller-board engineering. Encoder feedback, FPGA watchdogs, output inhibits, status monitoring, and STO/enable interfaces do not become independent personnel-safety authority by being implemented carefully. Safety-rated architecture and validation remain a separate course/domain.

## Exit check

The learner passes BD02 only when a reviewer can reconstruct why the topology was chosen, what changed from the reference, what calculations support those changes, where protection current goes, what the block does before normal control exists, what board resources each instance consumes, and exactly which facts remain unresolved.

## Next checkpoint

BD03 should switch from block creation back to **board integration**: machine I/O decomposition -> block instance selection -> board-wide FPGA/bus/power budget -> unresolved-resource ledger. Re-open every student-facing current file. Prefer using the encoder primitive only as one input type while selecting other blocks by verified current readiness; do not let incomplete analog-input authority or actively changing OpenPressBrake files become silent finished examples. Quantitative FPGA fit must remain TBD until local `[self-hosted, openpressbrake]` synthesis evidence exists.