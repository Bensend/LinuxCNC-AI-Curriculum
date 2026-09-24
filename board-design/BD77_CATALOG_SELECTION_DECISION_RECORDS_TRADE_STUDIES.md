# BD77 — Catalog Selection Decision Records and Design-Space Trade Studies

Status: durable board-design curriculum lane

## Purpose

BD77 teaches selection of reusable hardware blocks from machine requirements without choosing by familiarity, first-machine precedent, apparent part capability, or lowest component price.

Design flow:

`machine requirement -> mandatory-contract filter -> evidence/maturity filter -> resource/power/connector trade study -> board-specific adaptation cost -> risk/unknown comparison -> selection decision record -> connection/resource plan`

Central rules:

**SELECT FROM THE REQUIREMENT, NOT FROM THE FAVORITE CIRCUIT.**

**A CANDIDATE THAT FAILS A MANDATORY CONTRACT IS NOT SAVED BY A HIGHER SCORE ELSEWHERE.**

**UNKNOWN EVIDENCE IS A DECISION RISK, NOT ZERO COST.**

## Learning objectives

Students shall be able to:

1. turn machine I/O intent into a mandatory reusable-block contract before naming a candidate;
2. distinguish reusable electrical-function requirements from board-specific connection requirements;
3. eliminate candidates that fail mandatory function, envelope, default-state, fault, isolation, resource, or safety-boundary requirements;
4. compare remaining candidates using evidence maturity, FPGA/shared-resource demand, rail demand, connector consequences, thermal/PCB burden, cost, and unresolved facts;
5. distinguish device capability from a declared and evidenced board/block rating;
6. prevent `TBD` and `VERIFY_AT_MACHINE` facts from becoming invented selection inputs;
7. record rejected alternatives and the evidence that would change the decision;
8. produce an auditable selection decision record (SDR) that feeds connection/resource planning; and
9. preserve independent personnel-safety authority.

## 1. Freeze the need before looking at candidates

Write a requirement record first:

`requirement_id | function | quantity | electrical_envelope | normal/default/deenergized_state | diagnostics | fault_behavior | isolation/domain_boundary | timing/bandwidth | resource_constraints | connector/harness_constraints | environment/duty | evidence_required | safety_authority | unresolved_physical_facts`

Do not populate an unknown physical-machine value from a convenient block rating. If actual load current, inrush, inductance, harness, connector, ambient, or configuration is not evidenced, keep it `VERIFY_AT_MACHINE/TBD` and state whether that unknown prevents selection or only prevents final qualification.

A requirement may deliberately be technology-neutral. “Provide one ordinary-control voltage-free SPDT contact” is not the same requirement as “provide one protected 24-V high-side output.” The first statement permits a relay/contact technology; the second requires an energized semiconductor field-output function. Do not score unlike functions as though they were interchangeable.

## 2. Mandatory-contract filter comes before scoring

For each candidate classify every mandatory requirement:

- `PASS_EVIDENCED`
- `PASS_CONDITIONAL` — only if a named unresolved condition closes
- `FAIL`
- `UNKNOWN_REVIEW_REQUIRED`

A `FAIL` eliminates the candidate. `UNKNOWN_REVIEW_REQUIRED` is fail-closed for a release selection unless the decision record explicitly remains provisional.

Mandatory filters commonly include semantic function, direction, voltage/current class, return/domain ownership, deterministic default state, required diagnostics, protection/fault behavior, isolation, FPGA/bus compatibility, timing, required connector semantics, and safety-authority boundary.

Do not use weighted scoring to let low cost compensate for a missing required return path, wrong default state, incompatible voltage class, missing diagnostic, or unresolved personnel-safety boundary.

## 3. Evidence/maturity filter

After functional fit, ask what is actually proven. OpenPressBrake status levels distinguish NOT READY, BEHAVIORAL ONLY, SIMULATION-READY, SCHEMATIC-READY, and REV 1 READY. `BASELINE / READY FOR INTEGRATION` is a separate development gate, not production qualification.

Record:

`candidate_id | current_status | baseline_integration_gate | exact_evidence_revision | applicable_envelope | missing_evidence | student_readiness | selection_effect`

A mature candidate may deserve lower integration risk, but maturity cannot override a functional mismatch. Conversely, an electrically promising but NOT READY candidate may be retained as `ENGINEERING_REQUIRED_BEFORE_SELECTION`, not silently treated as a qualified catalog option.

## 4. Trade study dimensions

Only after mandatory filtering compare surviving candidates. Use engineering dimensions rather than one synthetic score when possible:

- FPGA GPIO, differential pairs, ADC/DAC, SPI/I2C/chip-selects, LUT/BRAM/PLL and bank-voltage effects;
- shared-resource/package packing and bus ownership;
- continuous, startup/inrush and transient rail demand with return-domain ownership;
- connector positions, voltage/current class, wire/harness implications, isolation/chassis/shield needs;
- PCB area, copper/current class, creepage/clearance, thermal and placement burden;
- default/off-state authority, watchdog/inhibit behavior and diagnostic observability;
- reusable-block evidence maturity and required new engineering;
- board-specific adapter/connection-block work;
- BOM/assembly cost with missing prices explicitly unknown;
- unresolved physical facts and regression/qualification burden.

Never convert an unknown to zero to make arithmetic convenient.

## 5. Reusable block versus connection block

The selected reusable block owns the electrical function and reusable contract. The board-specific connection block owns connector family and pinout, machine/harness destination, physical location, labels/silkscreen, board logical/FPGA mapping, and machine overlay.

A candidate should not be rejected merely because it does not contain a machine-specific connector. That is normally connection-block work. Conversely, a connection block may not repair a reusable primitive whose electrical envelope, default behavior, protection, or isolation is wrong.

## 6. Current OpenPressBrake worked example

OpenPressBrake current main inspected for this lesson: `0ea6b60e883821ffc022e53e85ff63aa17634f48`.

Student-facing sources opened and inspected in current form during this run:

- `hardware/blocks/README.md` — **VERIFIED_FOR_LESSON** for primitive/shared-resource decomposition, request-to-board assembly order, connector/function separation, evidence hierarchy, and explicit TBD policy.
- `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for maturity terminology, integration-versus-qualification separation, evidence truthfulness, and material-change maintenance.
- `hardware/blocks/digital_output_24v/manifest.yaml` — **VERIFIED_FOR_LESSON** for the current protected high-side primitive contract, isolation/return domains, FPGA/shared-resource demand, deterministic OFF authority, diagnostics, unresolved board envelope, and non-safety role.
- `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for current evidence maturity and open CAD/connector/thermal/qualification gates.
- `hardware/blocks/dry_contact_relay_output/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for the distinct voltage-free SPDT function, current NOT READY state, 24-V coil power handoff, open physical/CAD/machine gates, and non-safety role.
- `board-design/BD76_CATALOG_CONSUMER_COMPATIBILITY_SEMVER_MULTI_MACHINE_ROLLOUT.md` — **VERIFIED_FOR_LESSON** as the prerequisite contract/consumer compatibility method.

`hardware/blocks/catalog.yaml` was also opened during the audit but is **ENGINEERING_REVIEW_NEEDED** as a student selection authority: several entries still carry broad concept/provisional summaries and TBDs that are less current than the block-local manifests/status files. It is not assigned as a finished selection source in this lesson.

These classifications are bounded to the teaching claims above and do not confer production qualification.

## 7. Adversarial example — two things both called “output”

The current `digital_output_24v` primitive is a protected 24-V high-side machine output. It exposes `OUTPUT_24V` plus `LOAD_RETURN`, requires `OUTPUT_COMMAND`, reports overload and overtemperature, uses separate logic/process domains, and requires one command GPIO plus two diagnostic inputs per primitive. Its Rev1 isolated path preserves deterministic OFF authority on the field side. The actual board channel current, inrush, inductive envelope, connector ampacity, copper and thermal limits remain unresolved.

The current `dry_contact_relay_output` is a different function: an ordinary-control voltage-free SPDT `COM/NO/NC` contact driven by a 24-V relay coil. Its status truthfully remains NOT READY even though electrical connectivity and component identities are substantially frozen; KiCad mapping, rendered schematic/ERC, PCB copper/creepage, first-machine load mapping, bench evidence and final qualification remain open.

Therefore:

- a requirement for a voltage-free changeover contact eliminates the high-side semiconductor output on mandatory function before cost scoring;
- a requirement for a protected 24-V sourced output with overload/overtemperature diagnostics eliminates the simple relay-contact primitive on mandatory semantics;
- a generic requirement that merely says “ordinary controller output” is insufficient to select either one and must be decomposed further.

This is the intended stress test: if the catalog or machine decomposition cannot express the difference without tribal knowledge, the contract is defective.

## 8. Selection Decision Record (SDR)

Every nontrivial selection shall leave:

`decision_id | requirement_ids | candidate_ids | candidate_revisions | mandatory_filter_results | evidence_status | resource_delta | power_return_delta | connector_connection_delta | pcb_thermal_delta | cost_basis | unresolved_fact_ids | rejected_candidates_and_reasons | selected_candidate | selection_state | evidence_that_would_reopen | downstream_connection_ids | downstream_resource_plan_ids | safety_boundary`

Allowed selection states:

- `SELECTED_FOR_BASELINE_INTEGRATION`
- `PROVISIONAL_PENDING_EVIDENCE`
- `ENGINEERING_REQUIRED_BEFORE_SELECTION`
- `NO_CATALOG_CANDIDATE_FITS`

Do not write `SELECTED` when the decisive machine fact is still unknown.

## 9. Rejected alternatives are engineering assets

Record why each candidate lost. A rejected alternative may become preferred if requirements, availability, cost, evidence, or board constraints change. Preserve the exact reason and reopening condition rather than writing “not chosen.”

Example:

`candidate B rejected: mandatory diagnostic semantics absent; reopen only if requirement is changed by its owner or candidate contract adds evidenced diagnostics.`

That statement is more reusable than a subjective ranking.

## 10. Catalog stress-test result

The audit exposed a selection-tooling defect: the repository has strong block-local manifests/status files, but the top-level catalog is not sufficiently authoritative to serve as a current selection database by itself. A selector must not trust a stale summary over the current block contract/status.

Required future machine-readable addition:

`candidate_id | contract_revision | maturity_revision | semantic_function_ids | supported_envelope | default_state | diagnostics | protection | isolation_domains | resource_vector | power_vector | connector_requirements | shared_resources | cost_evidence | unresolved_fact_ids | qualification_evidence_ids | supersession_state`

The selector should join this to machine requirement IDs, connection-block constraints, the BD74–BD76 dependency/consumer graph, and reverse `Where Used`. It should flag stale summary data rather than silently choosing from it.

This is a catalog defect/action item, not a reason to copy block-local truth manually into lessons forever.

## 11. Multi-machine transfer

Exercise the same method on hypothetical mill, lathe, plasma, router, robot, press-brake, and custom-automation requirements. Use only stated hypothetical requirements; do not invent facts about real machines.

The same primitive may win on one board and lose on another because of isolation, connector, diagnostics, rail, resource, thermal, or evidence constraints. That does not make the reusable block machine-specific.

## 12. Safety boundary

Selection of an ordinary LinuxCNC/FPGA block cannot grant personnel-safety authority. A cheaper or more mature ordinary output does not replace an independent safety-rated output, relay/PLC, STO path, guard function, or validated safety architecture.

If a requirement is safety-authoritative, ordinary catalog candidates fail the mandatory safety-authority filter unless a separate safety-rated design and validation explicitly supports that role. The board-design curriculum records this boundary and refers the safety function to the independent safety design lane.

## 13. Lab deliverable

Given three hypothetical machine-output requirements and at least three catalog candidate records, produce:

1. requirement records before candidate selection;
2. mandatory-contract filter matrix;
3. evidence/maturity matrix;
4. resource/power/connector/PCB trade study for survivors;
5. explicit `TBD`/`VERIFY_AT_MACHINE` register;
6. one SDR per requirement, including rejected alternatives and reopening conditions;
7. board-specific connection/resource-plan handoff for the selected candidate; and
8. safety-authority statement.

At least one case must end `ENGINEERING_REQUIRED_BEFORE_SELECTION` or `NO_CATALOG_CANDIDATE_FITS`. A student may not force a winner merely to finish the worksheet.

## 14. Exit criteria

BD77 is complete when a student can prove why a reusable block was selected, rejected, or held pending evidence; can keep board-specific connection work outside the reusable primitive; can quantify resource/power/integration consequences without inventing missing values; and can leave an auditable decision that another engineer can reopen when requirements or evidence change.

Next curriculum step: **BD78 — Catalog Gap Escalation and New-Block Authorization**: when no qualified candidate fits, convert the failed selection record into a justified new-block/variant engineering charter without duplicating an existing primitive or leaking one machine's connector/harness assumptions into the reusable design.