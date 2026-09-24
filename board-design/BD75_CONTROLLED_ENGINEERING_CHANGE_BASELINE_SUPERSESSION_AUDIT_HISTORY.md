# BD75 — Controlled Engineering Change, Review Ownership, Baseline Supersession, and Auditable Release History

Status: durable board-design curriculum lane

## Purpose

BD74 established how a material change propagates through a release graph and how to select justified regression. BD75 turns that analysis into a controlled engineering-change workflow that preserves technical evidence, ownership, old baselines, and release history.

Design flow:

`accepted release graph + change event -> impact owner assignment -> proposed engineering change -> affected evidence/regression plan -> review/approval -> regression evidence attachment -> old-baseline supersession -> new immutable release baseline -> auditable history`

Central rules:

**APPROVAL IS NOT TECHNICAL EVIDENCE.**

**A NEW BASELINE SUPERSEDES AN OLD BASELINE; IT DOES NOT REWRITE HISTORY.**

**ROLLBACK IS A NEW CONTROLLED CHANGE, NOT TIME TRAVEL.**

## Learning objectives

Students shall be able to:

1. freeze a release baseline by exact revision and declared scope;
2. create a change record from stable semantic IDs rather than file names alone;
3. assign technical, integration, physical-machine, verification, and release ownership;
4. separate approval authority from evidence authority;
5. distinguish reusable-block changes from board-specific connection/overlay changes and calculate their different blast radii;
6. attach regression evidence to the exact changed subject and dependency set;
7. preserve `TBD` and `VERIFY_AT_MACHINE` facts with explicit owners rather than approving them away;
8. supersede an old baseline while preserving its evidence and release disposition;
9. perform rollback through a new reviewed change event; and
10. preserve the independent personnel-safety boundary through ordinary controller change control.

## 1. Freeze the baseline before changing it

A controlled change starts from an immutable baseline record. At minimum capture:

`baseline_id | source_revision | declared_scope | block_revisions | connection_revisions | resource_revision | power_revision | CAD_revision | firmware_runtime_revision | commissioning_evidence_ids | qualification_claim_ids | open_gate_ids | release_disposition`

A branch name such as `main` is not a baseline identifier. The baseline must remain reconstructable after later commits.

If the current board is not production-qualified, record the actual bounded disposition. Do not promote it merely because change control exists.

## 2. Change record

Each material change receives a stable change ID and records:

`change_id | originating_requirement_or_defect | changed_semantic_ids | old_authority | proposed_new_authority | change_class | reason | requested_scope | affected_dependency_ids | open_questions | owner_ids | status`

Recommended states:

- `PROPOSED`
- `IMPACT_REVIEW`
- `APPROVED_FOR_IMPLEMENTATION`
- `IMPLEMENTED_AWAITING_REGRESSION`
- `REGRESSION_INCOMPLETE`
- `TECHNICALLY_ACCEPTED`
- `RELEASED_IN_NEW_BASELINE`
- `REJECTED`
- `SUPERSEDED_BY_CHANGE`

`APPROVED_FOR_IMPLEMENTATION` means the team agrees to make the change. It does not mean the resulting design has passed verification.

## 3. Ownership matrix

Do not use one generic `owner` field for every responsibility. A defensible change record distinguishes:

- `requirement_owner` — authority for what the machine or board must do;
- `block_owner` — reusable electrical/function contract;
- `connection_owner` — board-specific connector/harness/machine overlay;
- `resource_owner` — FPGA/bus/power/shared-resource allocation;
- `implementation_owner` — CAD/firmware/runtime implementation;
- `verification_owner` — evidence method and result;
- `physical_fact_owner` — person/process responsible for obtaining machine measurements or installed configuration;
- `safety_authority_owner` — independent safety-system authority where applicable; and
- `release_owner` — accepts the bounded release disposition after technical evidence exists.

One person may hold several roles, but the roles remain semantically separate.

## 4. Approval is not evidence

A review signature can prove that a review occurred. It cannot prove electrical margin, transient survival, FPGA timing, connector fit, watchdog behavior, command scaling, or machine response.

For every affected claim record:

`claim_id | required_evidence_type | prior_evidence_state | regression_required | new_evidence_id | evidence_subject_revision | reviewer | result`

Examples:

- approving a changed FPGA binding does not replace synthesis/place-and-route/timing evidence when those claims are affected;
- approving a connector selection does not prove mating fit or pad-number correctness;
- approving a 0..10-V command overlay does not prove the installed drive parameterization;
- approving an ordinary output-inhibit design does not confer personnel-safety credit.

## 5. Reusable block change versus board overlay change

This is a required review split.

### Reusable block change

Changing a reusable primitive's topology, electrical envelope, supply requirement, default behavior, protection, diagnostics, or resource contract may affect every board that consumes the changed property. The change record must support reverse `Where Used` lookup and review all consumers.

### Board-specific connection or overlay change

Changing a connector pin, machine command envelope, harness destination, physical placement, or machine-specific scaling normally affects only boards/instances that consume that connection/overlay. Do not narrow or mutate the reusable primitive merely to make one machine's change easier.

A board overlay may be more restrictive than reusable capability. Downstream board/runtime/commissioning authority must consume the restriction explicitly.

## 6. Unresolved physical facts cannot be approved closed

`TBD` and `VERIFY_AT_MACHINE` are legitimate controlled states.

For each unresolved physical fact record:

`fact_id | required_measurement_or_source | physical_fact_owner | affected_claim_ids | release_gate | current_state | evidence_when_obtained`

A release review may narrow scope around an unresolved fact when technically defensible. It may not convert absence of evidence into a measured value.

When the fact is obtained, treat it as a `PHYSICAL_FACT_CHANGE` or closure event, propagate it through dependencies, and run the affected regression set.

## 7. Implementation and regression gate

Implementation is complete only when the changed semantic authority and all required downstream artifacts agree.

Before technical acceptance:

1. re-read the implemented authority at its exact revision;
2. compare it with the approved change intent;
3. recompute the affected dependency/staleness graph;
4. verify that every required regression has evidence against the implemented revision;
5. document unaffected evidence boundaries rather than silently carrying old evidence forward;
6. confirm unresolved gates remain explicit; and
7. confirm ordinary-control changes have not crossed the independent safety boundary.

If implementation differs materially from the approved proposal, update the change record and repeat impact review. Do not approve one design and silently release another.

## 8. Supersession semantics

A new baseline record must identify both its predecessor and the change set that produced it:

`new_baseline_id | predecessor_baseline_id | included_change_ids | exact_source_revision | credited_evidence_ids | open_gate_ids | release_disposition | release_date | release_owner`

The predecessor becomes `SUPERSEDED` for future work but remains historically valid for the scope and evidence that existed at that time. Never edit old evidence so it appears to have tested the new design.

A superseded baseline may still be useful for forensic comparison, field support, or identifying when a defect entered the design.

## 9. Rollback semantics

Rollback is not restoring historical truth by deleting the new history. Create a new change event that proposes restoration of an older technical state.

Then ask:

- do current components, machine facts, firmware, dependencies, and safety interfaces still match the old state?
- did later changes create dependencies that make literal restoration invalid?
- which evidence from the old baseline is still applicable to the present subject and envelope?
- what regression is required after restoration?

The resulting baseline has a new identity even if its circuit resembles an older one.

## 10. Safety boundary

This board-design lane does not replace the independent safety course.

A LinuxCNC/FPGA/HAL/watchdog/ordinary-output change may monitor safety status, inhibit normal outputs, or interface to STO/enable mechanisms. Change approval and regression in this lane do not make those functions the independent personnel-safety authority.

If a proposed ordinary-control change touches a retained safety-owned interface, the change record must preserve the external authority boundary and require the appropriate independent safety review rather than absorbing that authority into the controller.

## 11. Current OpenPressBrake worked example

OpenPressBrake main inspected for this lesson: `c668851b8db322682d08eedce6436eff5b1f4cbe`.

The following student-facing sources were opened and inspected in their current form during this run:

- `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for material-change maintenance, evidence truthfulness, baseline-versus-qualification separation, and the rule that CI proves only the checks it runs.
- `hardware/blocks/analog_output/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for current analog-output maturity, the first-machine command-profile correction, open physical/configuration/qualification gates, and explicit safety boundary.
- `hardware/blocks/analog_output/integration/REV1_COMMAND_PROFILE_OVERLAY.yaml` — **VERIFIED_FOR_LESSON** for the first-machine `0..10 V` T4 authority, `CONFIGURATION_PENDING` state, separate B5/B6 direction ownership, and retained Pilz B4 authority.
- `hardware/blocks/analog_output/integration/REV1_RESOURCE_CONTRACT.yaml` — **VERIFIED_FOR_LESSON** for current resource ownership, unresolved `DAC_FAULT` / `TPS26611_SGOOD` controller binding, and explicit `VERIFY_AT_MACHINE` gates.
- `hardware/REV1_BOARD_INTEGRATION.yaml` — **VERIFIED_FOR_LESSON** for current board-level integration authority and as a live stale-downstream example because `x_axis_analog.range_v` still records `[-10,10]` while the newer first-machine overlay permits only `0..10 V` pending configuration evidence.
- `board-design/BD73_WHOLE_BOARD_KITCHEN_SINK_RELEASE_REVIEW.md` — **VERIFIED_FOR_LESSON** as the prerequisite whole-board contradiction/gate-register method.
- `board-design/BD74_RELEASE_GRAPH_STALENESS_CHANGE_CONTROL_REGRESSION.md` — **VERIFIED_FOR_LESSON** as the prerequisite dependency/staleness/regression method.

These sources are verified only for the bounded teaching claims above. They do not establish that the OpenPressBrake board is production-proven.

## 12. Worked controlled change A — machine command-envelope correction

Model the current Commander SK correction as a board/machine-overlay change, not a reusable analog-block redesign.

Proposed change semantics:

- reusable primitive capability remains `[-10,+10] V`;
- first-machine T4 authority is `0..10 V` pending installed configuration evidence;
- B5/B6 retain ordinary direction ownership;
- B4 remains retained independent Pilz authority;
- board/runtime fields that still imply negative T4 command are stale dependents.

Ownership should therefore separate reusable analog block ownership from first-machine connection/configuration ownership. The installed Commander SK parameter record belongs to a physical-machine/configuration evidence owner, not to the reusable block designer by assumption.

Technical acceptance requires propagation into the board/runtime authority and the justified regression/commissioning evidence. A review signature alone cannot close the missing installed-drive configuration record.

## 13. Worked controlled change B — future diagnostic binding closure

Current authority requires `DAC_FAULT` and `TPS26611_SGOOD` but deliberately leaves their controller binding unresolved and forbids treating unresolved resource cost as zero.

When engineering selects a real binding, open a `RESOURCE_BINDING_CHANGE` rather than editing a resource count silently. Review FPGA/shared-bus allocation, electrical compatibility, CAD connectivity, firmware/HAL semantics, diagnostic power validity, fault-injection evidence, and release claims that require both diagnostics.

If the binding changes reusable block interface semantics, run `Where Used` across every consumer. If it is purely a Rev1 board-specific route that preserves the reusable contract, constrain the blast radius accordingly.

## 14. Catalog stress-test result

BD75 sharpens the catalog infrastructure defect exposed by BD74. A dependency graph alone is insufficient; the catalog also needs immutable baseline/change records and role-specific ownership.

A useful machine-readable change-control schema should support:

`baseline_id | predecessor_id | change_id | semantic_ids | change_class | proposal_revision | implementation_revision | owner_roles | affected_claim_ids | stale_evidence_ids | regression_plan_ids | new_evidence_ids | unresolved_fact_ids | approval_state | technical_acceptance_state | release_disposition | supersedes | rollback_of`

A validator should be able to answer:

- what exact baseline was changed?
- who owns the requirement, implementation, verification, physical fact, and release decision?
- was implementation actually the design that was reviewed?
- which evidence was rerun and against what revision?
- which old evidence remains valid and why?
- which boards consume a changed reusable-block semantic?
- did a machine-specific overlay improperly mutate a reusable block?
- did a TBD disappear because somebody approved it rather than measured it?
- was an old baseline preserved rather than rewritten?
- did an ordinary-control change acquire unsupported safety authority?

This is a catalog/tooling requirement, not permission to hide change history in commit messages or lesson prose.

OpenPressBrake remains read-only for this lesson because current main is actively advancing block power/resource engineering. The curriculum consumes current authority without racing those edits.

## 15. Lab deliverable

Given a frozen baseline plus one reusable-block change and one board-specific overlay change, produce:

1. an immutable baseline record with exact revisions and bounded release disposition;
2. two change records using stable semantic IDs;
3. an ownership matrix separating requirement, block, connection, resource, implementation, verification, physical-fact, safety, and release roles;
4. a `Where Used` report for the reusable-block change;
5. a constrained blast-radius report for the board-specific change;
6. a stale-evidence and minimum-regression plan for each change;
7. an unresolved physical-fact register with named ownership;
8. technical-acceptance records that distinguish approval from evidence;
9. a new baseline record that supersedes, but does not rewrite, the old baseline; and
10. a rollback exercise implemented as a new controlled change.

A passing submission must preserve historical evidence, must not approve away a TBD, and must show at least one old evidence item retained with a reviewed isolation boundary and one old evidence item marked stale.

## 16. Exit criteria

BD75 is complete when the student can demonstrate an auditable chain from an immutable old baseline through proposal, impact review, implementation, regression evidence, technical acceptance, release, supersession, and possible rollback without confusing approval with proof or board-specific facts with reusable-block authority.

The next curriculum step should apply the same discipline to multi-board/catalog reuse: consumer compatibility, semantic-versioning policy, migration windows, deprecation, and controlled rollout across several machine classes.