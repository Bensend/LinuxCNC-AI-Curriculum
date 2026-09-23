# BD50 — Generated-Artifact Equivalence, Canonicalization, and Reproducibility Acceptance

## Purpose

BD49 established semantic change control. BD50 addresses a harder review problem:

`two candidate generations -> normalize non-semantic variation -> compare semantic model -> compare authority/provenance -> classify exact/equivalent/materially-different -> reproducibility evidence -> acceptance or investigation`

Generated files may differ byte-for-byte without differing electrically, and may look identical while consuming different authority. Students must prove equivalence rather than infer it from appearance, hashes, or a successful generator run.

## Student-material readiness audit

The following current files were opened and inspected during this run before being presented here:

- Curriculum `hardware/4000-board-design/BD49_CONFIGURATION_CHANGE_CONTROL_DETERMINISTIC_REGENERATION_AND_SEMANTIC_DIFF_REVIEW.md` — **VERIFIED_FOR_LESSON** for locked-baseline, semantic-diff, dependency, and targeted-regression rules.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — **VERIFIED_FOR_LESSON** for the current board-design handoff.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for formal readiness, evidence truthfulness, and the rule that the status checklist is authoritative human-readable block status.
- OpenPressBrake `hardware/blocks/analog_output/integration/REV1_BOARD_INTEGRATION_HANDOFF.md` — **VERIFIED_FOR_LESSON** for the bounded Rev1 board-consumption contract published 2026-09-23.
- OpenPressBrake `hardware/blocks/analog_output/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for the authoritative current human-readable status and unresolved qualification/configuration gates.
- OpenPressBrake `hardware/blocks/analog_output/manifest.yaml` — **ENGINEERING_REVIEW_NEEDED** as a complete student authority. It remains useful as inspected defect evidence, but it contains stale first-machine semantics that the status checklist explicitly says are superseded by `integration/REV1_COMMAND_PROFILE_OVERLAY.yaml`, and its machine-readable `status` wording does not cleanly match the authoritative checklist's explicit **NOT YET SIMULATION-READY OR SCHEMATIC-READY** state.

Therefore the manifest is **not** assigned as finished student material. The discrepancy is itself the catalog stress test for this lesson.

## Learning objectives

The student must be able to:

1. distinguish byte identity, canonical identity, semantic equivalence, and release equivalence;
2. define what generated variation is safe to normalize and what must remain visible;
3. compare connectivity, resources, defaults, returns, protection, and authority rather than screenshots;
4. prove reproducibility from pinned inputs/tooling instead of assuming it from repeated success;
5. detect stale or contradictory authority before declaring two generations equivalent;
6. preserve reusable-block versus board-specific connection ownership during comparison;
7. choose targeted regression when equivalence cannot be established statically; and
8. keep ordinary-controller equivalence separate from independent personnel-safety validation.

## 1. Four different equivalence questions

Treat these as separate claims:

### A. Byte identity

The files have identical bytes/digests.

Useful for immutable artifact identity, but it says nothing by itself about whether the artifact was generated from authorized engineering inputs.

### B. Canonical identity

After an explicitly approved normalization, the canonical forms are identical.

Examples of potentially non-semantic variation include deterministic ordering, generated timestamps, whitespace, or tool-generated UUIDs that are proven not to carry design meaning.

### C. Engineering-semantic equivalence

The two artifacts express the same electrical/logical design contract: connectivity, components/values, resources, defaults, return paths, protection, mapping, and unresolved facts.

### D. Release equivalence

The artifacts are semantically equivalent **and** consume equivalent authorized source/configuration/evidence identities for the intended population/use.

**BYTE IDENTICAL ≠ AUTHORIZED.**

**CANONICAL IDENTICAL ≠ RELEASE EQUIVALENT.**

## 2. Canonicalization must be deliberately bounded

A canonicalizer may normalize only fields proven not to carry engineering meaning for that artifact class.

Potentially safe examples, after tool-specific proof:

- ordering of independent BOM rows;
- ordering of independent resource-report rows;
- whitespace and formatting;
- generated timestamps excluded from engineering identity;
- tool-generated display coordinates that do not affect connectivity or PCB constraints.

Do **not** automatically normalize away:

- net names when names carry interface semantics;
- connector pin numbers;
- reference designators when BOM/assembly/service evidence depends on them;
- component values, MPNs, population options, or DNP state;
- FPGA pins, banks, clocks, constraints, or logical functions;
- default/reset/watchdog/output-authority fields;
- ground/return/chassis distinctions;
- safety-boundary annotations;
- unresolved `VERIFY_AT_MACHINE` facts;
- source authority, revision, digest, generator version, or evidence identity.

**NORMALIZABLE FORMAT ≠ NORMALIZABLE ENGINEERING MEANING.**

## 3. Build a semantic model before comparison

For generated board artifacts, extract or compare at least:

- functional instance population;
- block/adapter/connection-block identity and revision;
- electrical nets and endpoint membership;
- connector/pin/harness mapping;
- component MPN/value/package/population state;
- power-domain membership and current-return topology;
- protection elements and fault paths;
- FPGA pin/bank/clock/LUT/register/BRAM/PLL/bus allocation;
- startup/default/de-energized/watchdog state;
- LinuxCNC/HAL semantic mapping;
- unresolved physical-machine facts;
- consumed evidence and authority state; and
- safety-boundary ownership.

A rendered schematic is evidence for human review, not the canonical semantic model.

**VISUALLY IDENTICAL ≠ SEMANTICALLY IDENTICAL.**

## 4. Reproducibility acceptance requires pinned inputs

A reproducibility claim must record:

- exact configuration lock;
- exact reusable block/adapter/connection authorities;
- exact machine overlays and `VERIFY_AT_MACHINE` resolutions;
- generator/schema/tool versions;
- environment inputs that can affect output;
- canonicalization rules/version;
- raw output digests;
- canonical semantic digest; and
- differences intentionally excluded from semantic identity.

Two independent generations from the same pinned inputs should produce the same canonical semantic result. If they do not, stop and investigate nondeterminism.

**REPEATED SUCCESS ≠ REPRODUCIBILITY WITHOUT PINNED INPUTS.**

## 5. Classification

Classify a comparison as one of:

### `EXACT`

Raw artifacts are byte-identical and authority/provenance identity is unchanged.

### `CANONICALLY_EQUIVALENT`

Raw bytes differ, approved normalization removes only proven non-semantic variation, semantic model matches, and authority/provenance remains equivalent for the intended use.

### `SEMANTICALLY_EQUIVALENT_AUTHORITY_CHANGED`

Electrical/logical semantic model matches but source authority, evidence, generator/tool identity, or release lineage differs. This is **not automatically release-equivalent**. Review the authority change and evidence applicability.

### `MATERIALLY_DIFFERENT`

Any engineering-semantic facet differs or cannot be proven equal.

### `BLOCKED_AMBIGUOUS`

Required authority, machine fact, canonicalization rule, or semantic extraction is unresolved.

Unknowns fail closed.

## 6. Bounded OpenPressBrake example: analog-output authority drift

The current Rev1 analog-output handoff constrains first-machine board integration to one primitive instance, one shared DAC channel, one `DAC_REARM_PULSE` FPGA GPIO, and a Commander SK T4 **0..10 V** command profile with separate B5/B6 direction. Intentional negative T4 voltage is prohibited until installed parameter/configuration evidence authorizes otherwise. B4/wire 63 remains retained independent Pilz safety authority.

The authoritative current `analog_output/STATUS_CHECKLIST.md` says the reusable bipolar primitive remains broader, but the first-machine profile is `CONFIGURATION_PENDING`; it explicitly states that `REV1_COMMAND_PROFILE_OVERLAY.yaml` supersedes stale `+/-10 V` first-machine fields in `manifest.yaml`. The checklist also states that the block is **not yet SIMULATION-READY or SCHEMATIC-READY**.

The inspected manifest still contains first-machine-oriented fields such as `purpose: Provide the protected plus/minus 10 V command for the retained X-axis drive`, a first-machine `plusminus_10V` variant, and machine command/return fields. Its machine-readable `status` wording also does not directly reproduce the authoritative checklist state.

This is precisely why generated-artifact equivalence cannot be established by comparing one convenient manifest or by canonicalizing contradictory fields away. A generator that consumes the stale first-machine bipolar field and a generator that consumes the current 0..10-V Rev1 overlay could emit visually similar circuitry while carrying materially different machine-command authority.

For student use:

- the current handoff and checklist are valid bounded evidence;
- the manifest discrepancy is **ENGINEERING_REVIEW_NEEDED**;
- do not teach the manifest as the sole current first-machine authority;
- do not modify the reusable bipolar primitive merely to make the first-machine overlay easier to consume.

This is a catalog/authority-consumption defect, not proof that the reusable electrical topology itself is wrong.

## 7. Adversarial comparison exercises

### Case A — reordered BOM

Candidate B contains the same component identities, quantities, MPNs, values, packages, DNP state, and allocation, but rows are sorted differently.

Expected classification: `CANONICALLY_EQUIVALENT` only if row order has no downstream assembly/service meaning and authority/provenance is equivalent.

### Case B — regenerated netlist with new timestamps

Connectivity and all semantic component attributes match; only a generated timestamp differs.

Expected classification: potentially `CANONICALLY_EQUIVALENT`, but only under an approved canonicalization rule.

### Case C — identical schematic image, changed return semantics

A net previously identified as `FIELD_RETURN` is silently joined to logic ground or chassis while the rendered page still looks similar.

Expected classification: `MATERIALLY_DIFFERENT`.

**SAME DRAWING APPEARANCE ≠ SAME RETURN TOPOLOGY.**

### Case D — identical connectivity, different default authority

FPGA/HAL connectivity is unchanged but startup or watchdog behavior changes from fail-low/0-V to retained-last-command.

Expected classification: `MATERIALLY_DIFFERENT`.

### Case E — same electrical output, different authority inputs

Both generations produce a 0..10-V analog command, but one consumes a current approved machine overlay while the other derives the same value from an obsolete copied assumption.

Expected classification: `SEMANTICALLY_EQUIVALENT_AUTHORITY_CHANGED`, requiring investigation rather than automatic acceptance.

### Case F — tool-version formatting change

A KiCad or generator update changes ordering/formatting but extracted connectivity, attributes, constraints, resources, authority, and canonical semantic digest match.

Expected classification: `CANONICALLY_EQUIVALENT` after the new tool version and canonicalizer behavior are themselves reviewed.

## 8. Canonicalization cannot repair stale authority

Do not create normalization rules merely to make mismatched sources compare equal.

Examples of prohibited normalization:

- converting both `+/-10 V` and `0..10 V` to a generic `analog_voltage` token;
- collapsing `FIELD_RETURN`, `LOGIC_GND`, and chassis into `GROUND`;
- removing watchdog/default-state fields because they cause diffs;
- ignoring FPGA bank voltage because logical pin names match;
- dropping `VERIFY_AT_MACHINE` state because the generated schematic has no placeholder;
- discarding authority revision/digest because the electrical netlist matches.

**CANONICALIZATION MUST REMOVE NO ENGINEERING QUESTION.**

## 9. Evidence acceptance matrix

| Comparison result | Static acceptance | Required action |
|---|---|---|
| `EXACT` | possible | verify release/provenance identity is the intended baseline |
| `CANONICALLY_EQUIVALENT` | possible | retain raw + canonical digests and normalization evidence |
| `SEMANTICALLY_EQUIVALENT_AUTHORITY_CHANGED` | no automatic acceptance | review changed authority and evidence applicability |
| `MATERIALLY_DIFFERENT` | no | route changed semantic facets through BD49 targeted verification |
| `BLOCKED_AMBIGUOUS` | no | resolve authority/fact/tooling ambiguity; do not guess |

## 10. Reusable blocks versus connection blocks

Equivalence review must preserve ownership boundaries.

A board-specific connector/pin/silkscreen remap may materially change a board artifact while leaving the reusable electrical block semantically unchanged. Conversely, changing a reusable block's protection, default state, electrical envelope, or resource contract may leave connector mapping untouched while invalidating many board consumers.

Do not merge these layers merely to obtain one convenient comparison file.

## 11. When executable verification is required

Static semantic comparison is sufficient only for claims it can prove. If a materially changed facet requires simulation, FPGA synthesis/place-and-route, timing/resource checks, or regression execution, run that verification only on the local OpenPressBrake panel PC through `[self-hosted, openpressbrake]`.

If authorized local compute is unavailable, record the required gate as `BLOCKED/NOT_RUN`. Never substitute GitHub-hosted Actions minutes.

No executable verification was required to establish the document/authority inconsistency used in this lesson.

## 12. Safety boundary

Canonical equivalence of an ordinary controller artifact does not grant personnel-safety authority. Ordinary FPGA/LinuxCNC logic may monitor safety state, request STO/enable behavior, or implement ordinary watchdog/output inhibits, but equivalent ordinary-control artifacts remain ordinary-control artifacts unless a separately engineered and validated safety architecture establishes otherwise.

**ORDINARY-CONTROLLER EQUIVALENCE ≠ SAFETY VALIDATION.**

## Lab — prove or reject equivalence

Given two generated board candidates, produce an equivalence record containing:

1. exact raw artifact digests;
2. exact source/configuration/tool identities;
3. canonicalization rules used and justification for each;
4. extracted semantic models;
5. semantic diff;
6. authority/provenance diff;
7. classification from Section 5;
8. stale/unknown evidence discovered;
9. targeted verification required, if any; and
10. accept/investigate/reject decision with rationale.

The evaluator must reject any submission that treats byte equality, visual similarity, CI success, or canonicalization alone as proof of engineering/release equivalence.

## Catalog stress-test result

BD50 exposes two related infrastructure needs:

1. a machine-readable **canonical semantic model/digest** for generated board artifacts, with versioned normalization rules tied to artifact class; and
2. an **authority-consumption consistency check** that detects when manifests, overlays, status checklists, connection definitions, generated artifacts, or resource reports disagree about which semantic source is current.

The inspected `analog_output` files demonstrate why this is not theoretical. Current human-readable status explicitly supersedes stale first-machine manifest fields. Tooling that consumes the manifest without the overlay can silently regenerate the wrong machine-command authority.

Do not solve that by narrowing the reusable bipolar primitive. The proper correction is to make authority precedence and board-specific overlays machine-readable and fail closed.

These infrastructure items remain **ENGINEERING_REVIEW_NEEDED**.

## Durable rules frozen by BD50

- byte identity does not prove authorization;
- canonical identity does not prove release equivalence;
- visual identity does not prove semantic identity;
- normalizable formatting is not normalizable engineering meaning;
- repeated successful generation is not reproducibility without pinned inputs;
- authority/provenance changes remain visible even when connectivity is unchanged;
- unknown canonicalization or authority state fails closed;
- canonicalization must remove no engineering question;
- stale authority must be reconciled, not normalized away;
- reusable electrical capability remains separate from board/machine configuration overlays;
- ordinary-controller equivalence does not establish independent personnel-safety validation.

## Next exact work

Build BD51 on **semantic digest schemas, authority precedence, and fail-closed source reconciliation**:

`source artifacts -> authority precedence -> semantic extraction -> contradiction detection -> unresolved-fact handling -> canonical semantic digest -> generated-consumer lock -> stale-source rejection -> audit`

Use the analog-output discrepancy as a defect pattern, but only after re-opening its then-current files. Do not assume today's mismatch still exists.