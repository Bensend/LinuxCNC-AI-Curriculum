# BD26 — Full-Board Qualification Planning and Evidence Closure

## Purpose

BD25 made complete-board release a composed claim whose dependencies must have current, applicable evidence. BD26 turns that release graph into an executable **verification campaign plan** without confusing commissioning success with release.

This lesson develops both linked skills:

1. **block engineering** — expose the qualification claims, fault/default cases, evidence classes, prerequisites, envelopes, and regression triggers that a reusable block contributes to a board campaign; and
2. **board integration** — derive and sequence board-, FPGA-, HAL-, machine-, and cross-block verification from the actual dependency/evidence graph, preserving unresolved claims until evidence really closes them.

The campaign flow is:

`release claim -> unresolved/current dependency graph -> verification questions -> prerequisite/risk ordering -> pre-power -> staged power -> default/partial-power/fault challenges -> interface evidence -> PCB/thermal -> FPGA implementation -> LinuxCNC/HAL -> machine facts -> residual-open-claim review -> release decision`

The OpenPressBrake repository is used only for bounded current governance/status examples. This lesson does not claim the current controller is production-qualified.

## Hard student-material audit

The following files were opened and inspected in their current `main` form during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD08_QUALIFICATION_EVIDENCE_VERIFICATION_MATRIX_AND_REGRESSION_TRIGGERS.md` — evidence classes, claim-specific qualification, and regression-trigger method.
- Curriculum `hardware/4000-board-design/BD09_STAGED_BOARD_BRINGUP_AND_COMMISSIONING_EVIDENCE.md` — staged energization/commissioning method and the distinction between commissioning and qualification.
- Curriculum `hardware/4000-board-design/BD25_DEPENDENCY_AWARE_QUALIFICATION_EVIDENCE_AND_RELEASE_STATE_COMPOSITION.md` — exact claim/revision/envelope binding, evidence lifecycle, composed release states, and causal blockers.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — exact BD26 work item and lane state before this lesson.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — integration-readiness versus full-qualification gates and concrete-evidence rule.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable block/adapter/board-integration ownership and safety boundary.
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — current isolated-output open gates and explicit separation of frozen topology from PCB/thermal/fault/release qualification.
- OpenPressBrake commit `99a95e45ea077c0ade1ee2c61517751845f82ae8`, specifically its new `hardware/blocks/digital_output_24v/integration/STISO620_SUPPLY_CURRENT_BOUND.md` evidence — a current example of a bounded datasheet/arithmetic result that explicitly does not prove PCB thermal performance.

Readiness is claim-scoped. In particular, the digital-output status is not student authority for a finished Rev1 implementation: the isolated path is not yet `SCHEMATIC-READY`, and exact production BOM/capture, validator, rendered connectivity, fault qualification, PCB thermal/current-path evidence, integration checks, and human signoff remain open.

---

## 1. Derive the campaign from release dependencies, not a generic checklist

Start with the exact release proposition and traverse required dependencies. For every dependency ask:

- What proposition must be true?
- Which semantic revision and release envelope are consumed?
- What evidence already exists and is it `CURRENT`?
- What evidence is missing, stale, partial, failed, or blocked by an unknown?
- What method can actually answer the unresolved question?
- What must be true before that method can be attempted safely and meaningfully?
- What design/evidence change invalidates the result?

A campaign item should therefore look like:

```yaml
id: VC.GENERIC.BOARD.PARTIAL_POWER_03
supports: QUAL.BOARD.PARTIAL_POWER@4
question: does field power present with logic power absent preserve the declared inactive output state without back-powering logic?
method: bench_test
prerequisites:
  - QUAL.BOARD.UNPOWERED_INSPECTION@2
  - QUAL.BOARD.STAGED_POWER@3
risk: controlled_abnormal_state
article: pcb_rev_x
stimulus: declared_field_only_power_case
witnesses:
  - physical_output_state
  - unpowered_logic_rail_voltage
acceptance: from_owned_contract
stop_conditions: from_test_plan
result: PENDING
```

Do not copy an arbitrary voltage/current/temperature into the plan merely because a similar board used it.

Freeze:

> **GENERIC CHECKLIST COMPLETED != RELEASE DEPENDENCY CLOSED**

---

## 2. Order work by prerequisites, risk, information value, and destructive potential

A good campaign finds cheap, high-information defects before expensive or hazardous tests.

A practical ordering heuristic is:

1. **authority and revision identity** — prove which design/article/image/configuration is under test;
2. **static/document review** — catch contradictions before touching hardware;
3. **unpowered inspection and design-derived continuity/resistance checks**;
4. **minimum-domain, current-limited staged power**;
5. **rail/default/reset/configuration-authority witnesses**;
6. **partial-power and back-power cases that can be safely bounded**;
7. **one interface at a time under benign representative conditions**;
8. **watchdog/command-loss/default-state challenges**;
9. **FPGA synthesis/place-route/timing evidence for the exact pinned image when required**;
10. **PCB current-path and thermal evidence under justified simultaneous-load cases**;
11. **LinuxCNC/HAL end-to-end semantic mapping with physical witnesses**;
12. **declared abnormal/fault cases using the appropriate evidence method**;
13. **machine verification for facts that cannot be established on the bench**;
14. **residual-open-claim review and release composition**.

This is not a universal fixed sequence. Dependency and safety prerequisites may move an item later. The reason for ordering must be explicit.

Freeze:

> **MOST DRAMATIC TEST FIRST != GOOD QUALIFICATION PLAN**

---

## 3. Separate campaign stages by what they can prove

### Pre-power evidence

Good for article identity, population/orientation, connector mapping, obvious assembly defects, intended domain separation, expected DNP options, and design-derived continuity questions.

It does not prove powered behavior.

### Staged-power evidence

Good for initial rail behavior, current anomalies, default states, enable sequencing, and detecting unintended rise on unpowered domains.

Current limiting protects the article during bring-up; it does not qualify production fault protection.

### Interface bench evidence

Good for a bounded physical stimulus-to-response chain on the tested article/configuration.

It does not automatically qualify other loads, cables, temperatures, PCB revisions, or machine installations.

### FPGA implementation evidence

Synthesis/place-and-route/timing can prove implementation fit/timing for the exact device, constraints, tool flow, pin plan, and image under test. A logical binding file or successful HAL observation is not a substitute.

### PCB current/thermal evidence

Must address actual copper, vias, connector/current path, simultaneous operating case, environment, and the heat sources relevant to the claim. Device dissipation arithmetic is an input, not the final board-temperature result.

### LinuxCNC/HAL evidence

Must preserve end-to-end semantic identity and use a physical or otherwise authoritative witness. Name resemblance is not mapping proof.

### Machine evidence

Establishes installed facts such as actual device identity, cable/load behavior, wiring, environment, or other physical configuration that the reusable/board design deliberately left `VERIFY_AT_MACHINE`.

Freeze:

> **EVIDENCE CLASSES COMPLEMENT; THEY DO NOT PROMOTE INTO ONE ANOTHER**

---

## 4. Current OpenPressBrake output example — a closed arithmetic question is not a closed board campaign

The current digital-output evidence gives a useful bounded example. The STISO620 supply-current pass closes a specific datasheet-backed DC current question for the frozen FLT2 direction and calculates the eight-output isolator-only process-side load. Its own limits explicitly exclude LDO quiescent current and other authorized consumers and explicitly refuse to turn the resulting dissipation arithmetic into an actual-PCB temperature claim.

The current block status therefore correctly leaves exact isolated-path production BOM/capture, structural board-contract checks, rendered connectivity, abnormal-condition qualification, simultaneous-channel corners, PCB thermal/copper qualification, board integration, and human release open.

A qualification campaign must preserve that shape:

```text
current datasheet current bound
        |
        +--> contributes to shared 5-V resource budget
        +--> contributes to regulator dissipation input
        |
        X  does not close actual PCB thermal claim
        X  does not close fault qualification
        X  does not close exact KiCad connectivity
        X  does not close complete-board release
```

This is the desired behavior of the catalog: newly closed evidence narrows the remaining campaign instead of turning the whole block green.

Freeze:

> **BOUND INPUT TO THERMAL ANALYSIS != PCB THERMAL QUALIFICATION**

---

## 5. Default, watchdog, partial-power, and fault challenges are separate questions

Do not combine all abnormal behavior under `fault test`.

At minimum distinguish:

- startup before logic/configuration authority exists;
- reset/unconfigured logic;
- watchdog/communications loss where claimed;
- command removal;
- field power present while logic is absent;
- logic present while field power is absent;
- brownout/ramp-down/recovery cases required by the contract;
- back-power paths;
- load short/open/miswire or other declared electrical faults;
- repetitive/thermal overload cases where the claimed envelope requires them.

Each needs an owned acceptance criterion and a safe test/analysis method. Do not inject a destructive fault merely because the word `fault` appears in a checklist.

For ordinary controller outputs, the physical field/output witness matters. A software bit going false is not proof that field energy disappeared.

---

## 6. A successful commissioning run may still end in NOT RELEASED

Consider four adversarial cases.

### Case A — stale reusable-block evidence

The assembled board powers, communicates, and operates the machine, but a consumed reusable output contract changed after its qualification evidence was recorded.

Result: commissioning can be `PASS`; release remains `BLOCKED_STALE_EVIDENCE` until the affected claim is revalidated.

### Case B — unrecorded machine fact

The machine appears to operate correctly, but a required cable/load/environment fact remains `VERIFY_AT_MACHINE` and the evidence envelope depends on it.

Result: operation is an observation, not a recorded bound. Release remains `BLOCKED_UNKNOWN_MACHINE_FACT`.

### Case C — FPGA runs but implementation evidence is stale

The expected HAL objects exist and the machine moves, but the FPGA pin/resource/timing evidence applies to an earlier image or pin plan.

Result: bring-up can succeed while `QUAL.BOARD.FPGA_IMAGE_TIMING` remains stale/open. Do not infer routed timing closure from machine motion.

### Case D — safety-status monitor works

The ordinary controller correctly reads status from an independent safety system.

Result: the electrical/status interface can pass its ordinary-control claim. It receives no authority to validate the independent personnel-safety function, stopping performance, PL/SIL/category, diagnostic coverage, or safety release.

Freeze:

> **COMMISSIONED AND WORKING != RELEASED**

---

## 7. Record residual open claims explicitly

At the end of each campaign stage, produce a residual ledger rather than a vague `remaining testing` note.

Example:

| Claim | State | Blocking reason | Next evidence | Owner |
|---|---|---|---|---|
| reusable output default state | CURRENT | — | none | block |
| board isolated-path connectivity | OPEN | exact capture/validator not closed | static validation + rendered review | board integration |
| PCB shared-rail thermal | OPEN | actual PCB/environment evidence absent | thermal qualification | PCB/integration |
| FPGA timing | STALE | image revision changed | self-hosted synthesis/P&R/timing | FPGA integration |
| installed cable/load fact | VERIFY_AT_MACHINE | not recorded | machine measurement/inspection | machine configuration |
| safety function | OUTSIDE_AUTHORITY | independent safety system | safety-course/process evidence | safety authority |

A release decision consumes this ledger. It must not delete inconvenient open rows because the machine ran.

---

## 8. Campaign evidence must preserve stop conditions and negative results

A qualification plan is not a script for manufacturing PASS results.

For physical tests record:

- article/revision identity;
- prerequisite state;
- setup and instruments where material;
- stimulus and envelope;
- expected witnesses;
- acceptance criteria;
- stop/abort conditions;
- actual observations;
- result;
- anomalies and failures;
- resulting defect/action item;
- invalidation/regression triggers.

A current FAIL is stronger engineering information than an old PASS that no longer applies. Do not overwrite or hide failed evidence after a design correction; supersede it and bind the new result to the corrected revision.

---

## 9. Use the cheapest evidence method capable of answering the question

Examples:

- exact net/component invariant -> static validator/inspection;
- datasheet maximum current -> manufacturer authority plus arithmetic;
- actual FPGA fit/timing -> synthesis/P&R/timing;
- installed cable length -> machine verification;
- actual PCB hot spot under simultaneous load -> physical thermal evidence or another justified physical method;
- unknown surge immunity of a real board -> appropriate physical qualification, not a nominal DC SPICE rerun;
- schematic intent versus rendered capture -> rendered review/ERC/connectivity comparison.

Simulation remains question-driven. It is not a ritual stage in every campaign.

Any genuinely needed executable engineering verification for this project must run only on `[self-hosted, openpressbrake]`. No hosted Actions fallback is allowed.

---

## 10. Release review is its own engineering step

After all planned execution, recompute the release proposition from current evidence. Ask:

1. Are all required dependencies known and on the intended semantic revisions?
2. Is every required evidence record current and applicable to the release envelope?
3. Are any failures unresolved?
4. Are any partial results being misrepresented as full-envelope proof?
5. Are PCB, FPGA, HAL, machine, and reusable evidence kept in their proper scopes?
6. Are all required `VERIFY_AT_MACHINE` facts actually recorded?
7. Did any late design correction stale earlier evidence?
8. Are safety-related ordinary-control claims still bounded outside independent safety authority?
9. Is human release/signoff required by governance and actually present?

Only then can the release state advance.

Freeze:

> **TEST CAMPAIGN FINISHED != RELEASE REVIEW PASSED**

---

## Lab — build and adversarially execute a release-oriented campaign plan

Create a fictional controller using at least:

- two reusable I/O block types;
- one shared power resource;
- one board-specific connection definition;
- one FPGA image/pin/resource plan;
- one LinuxCNC/HAL mapping;
- one machine-only cable/load fact;
- one ordinary status interface to an independent safety system.

Build the release dependency graph, attach a mixture of current, stale, missing, partial, and machine-scoped evidence, then derive the campaign. Do **not** start from a generic test checklist.

The campaign must include:

1. revision/authority identity;
2. pre-power/static checks;
3. staged power with values left `TBD_ENGINEERING` unless supplied by authority;
4. default/reset witnesses;
5. at least two meaningful partial-power/back-power cases;
6. interface-by-interface bench evidence;
7. FPGA implementation evidence where the release claim requires it;
8. PCB current/thermal evidence;
9. LinuxCNC/HAL end-to-end mapping with physical witness;
10. watchdog/command-loss challenge for an ordinary output;
11. machine verification for the unresolved physical fact;
12. residual-open-claim ledger;
13. final composed release review.

Then force all four adversarial cases from Section 6. The fictional machine may operate successfully. The student must still produce the correct blocked release state and shortest causal chain whenever a required dependency is stale, unknown, or outside the evidence envelope.

### Lab pass criteria

A passing submission must:

- derive tests from claims/dependencies rather than a stock checklist;
- order work by prerequisites, risk, information value, and destructive potential;
- distinguish commissioning, qualification, and release;
- keep reusable, board, PCB, FPGA, HAL, machine, and safety evidence in their proper scopes;
- refuse to invent current limits, fault stimuli, thermal limits, cable facts, or machine values;
- preserve negative and stale evidence rather than selecting convenient green artifacts;
- show why a running machine can remain not released;
- preserve the independent personnel-safety boundary;
- leave a causal residual ledger suitable for the next engineering run.

---

## Catalog stress-test result

The current OpenPressBrake governance can express many human-readable open gates, and the digital-output status is a positive example of refusing to promote a newly closed current calculation into PCB thermal or Rev1 qualification. The remaining catalog pressure exposed by BD26 is **campaign derivation and closure tracking**: a future machine-readable layer should be able to enumerate unresolved release claims, map each to an evidence method/prerequisites/owner, order or group executable work, ingest resulting evidence, and recompute the residual graph without duplicating the underlying electrical authority.

This run does not retrofit that layer into active OpenPressBrake engineering. It is recorded as `ENGINEERING_REVIEW_NEEDED` rather than invented around live block work.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable verification is justified by this lesson itself. The task is qualification-campaign methodology and current source review. No hosted runner is used.

## Durable freezes

- `GENERIC CHECKLIST COMPLETED != RELEASE DEPENDENCY CLOSED`.
- `MOST DRAMATIC TEST FIRST != GOOD QUALIFICATION PLAN`.
- `EVIDENCE CLASSES COMPLEMENT; THEY DO NOT PROMOTE INTO ONE ANOTHER`.
- `BOUND INPUT TO THERMAL ANALYSIS != PCB THERMAL QUALIFICATION`.
- `COMMISSIONED AND WORKING != RELEASED`.
- `TEST CAMPAIGN FINISHED != RELEASE REVIEW PASSED`.
- unresolved required machine facts remain `VERIFY_AT_MACHINE`; operation does not silently resolve them.
- ordinary LinuxCNC/FPGA safety-status monitoring does not acquire personnel-safety authority through successful board qualification.

## Next lesson

BD27 should teach **qualification finding disposition and regression closure** for board design: turn failures/anomalies into owned defects, distinguish block defect versus adapter versus board integration versus machine/configuration cause, revise the correct authority, use dependency/`SHOW WHERE USED` impact to select regressions, preserve superseded failed evidence, and prove that a local fix has not silently invalidated neighboring blocks or complete-board release claims.