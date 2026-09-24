# Hydraulic/final-element witness checkpoint — 2026-09-24T12:41Z

Status: cross-architecture final-element witness matrix completed with authoritative contactor, STO, monitored-hydraulic and restraint boundaries. Generic safety schematics remain NOT FROZEN. External/fresh 2520–25F0 competency gates remain open and uncontaminated.

Durable work this session:
- `research/ROCKWELL_EXACT_CHAIN_FAULT_AND_STO_COMPARISON_2026-09-24.md`
- `research/FINAL_ELEMENT_WITNESS_MATRIX_2026-09-24.md`

Hydraulic evidence now incorporated:
- Fiessler AKAS-F + AKFH/AKFR documents valve-position transmitter monitoring, linked feedback to safety control, and withdrawal/blocking of valve enable on protective-field, guard, E-stop, valve-switching and subsystem faults.
- Bosch Rexroth independently documents a servo-pump press-brake package with a separate safety block using end-position-monitored on/off valves. This supports the separation `NORMAL MOTION AUTHORITY != SAFETY FINAL-ELEMENT AUTHORITY`.
- HAWE EV2D provides a third architecture family with safety-relevant valve shutdown; downstream machine hydraulic safe state still requires selected circuit evidence.

New/retained freezes:
- `VALVE POSITION EXPECTED != RAM/BEAM SAFE STATE PROVED`.
- `SERVO PUMP ZERO COMMAND != HYDRAULIC SAFETY FUNCTION PROVED`.
- `SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED`.
- `DUMP COMMANDED != PRESSURE SAFE PROVED`.
- `NORMAL MOTION AUTHORITY != SAFETY FINAL-ELEMENT AUTHORITY`.
- `FINAL-ELEMENT ARCHITECTURE DETERMINES THE LEGITIMATE WITNESS`.

Bench decision: no lab frozen. The current questions are source/design questions, not executable uncertainties.

Exact next work:
1. Locate the actual safety-output implementation-spec template filename and reconcile the eight-field final-element witness contract from the new matrix into it; also update the selected-block qualification worksheet if any field is absent.
2. Deepen one monitored hydraulic architecture only as far as authoritative public component/system documentation permits: valve-position target, enable authority, feedback dependency, and residual hydraulic-energy boundary. Do not infer a machine truth table.
3. Add an adversarial commissioning/proof-test mini-case where valve feedback is healthy but beam motion/pressure evidence contradicts it; require the physical proposition to win over controller status.
4. Connect the final-element matrix back into the cumulative Safety Design Package IDs (`SRS`, `PHY`, `AUTH`, `DEP`, `ARC`, `VAL`) so learners cannot lose the witness/residual-energy distinction at handoff.
5. Preserve generic schematics as NOT FROZEN and use `[self-hosted, openpressbrake]` only if a concrete unresolved executable question appears.