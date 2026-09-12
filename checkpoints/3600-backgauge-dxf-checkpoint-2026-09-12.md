# 3600 press-brake checkpoint — backgauge ownership through DXF metadata boundary

Date: 2026-09-12

## Closed preparation questions

The current backgauge preparation branch has enough evidence to stop expanding low-value simulation:

- manual/jog ownership and authorization revocation — PB-BG-001 test-confirmed;
- extra-joint typed-position ownership — PB-BG-002 test-confirmed;
- homing/reference and post-home command source boundary — source-confirmed;
- current-episode `at_position` semantics — PB-BG-003 test-confirmed after rejecting run 083 as harness-invalid and accepting corrected run 084;
- public final bend-program/backgauge sequencer source — bounded search completed, SOURCE UNAVAILABLE;
- bend-program vs extra-joint target ownership — documented as an application-layer contract;
- open-source bend-geometry/sequence concepts — FreeCAD SheetMetal and BenDFM inspected;
- FreeCAD unfold/DXF boundary — bend geometry can be separated, but richer per-bend metadata is not guaranteed to survive as per-entity DXF semantics.

## PB-BG-003 authoritative evidence

Corrected workflow `34664404337`, job `103473294403`, retained 28 rows and passed frozen Gates A–J 10/10 under independent raw audit. It proves only application episode/state semantics.

Run `34664318311` remains HARNESS INVALID because distinct invalidation witnesses were collapsed into one health bit. It is not counted as behavioral evidence.

## Current architecture boundary

For the studied extra-joint backgauge pattern:

`bend recipe -> BendStep -> GaugePlan -> TargetSet generation -> independent per-mechanism planner/controller -> joint.N.posthome-cmd`

Completion flows back as a coherent current-generation result. Numeric target equality alone is never recipe-step identity.

Do not treat ordinary extra joints as coordinated G-code axes unless a different architecture is explicitly chosen and traced.

## DXF/import boundary

The first DXF-assisted implementation should be deliberately modest:

- discover candidate bend lines from source/layer metadata;
- retain source provenance;
- assign stable internal bend IDs;
- preserve UNKNOWN angle/direction/radius when not trustworthy;
- let the human confirm candidate bends and sequence;
- pass accepted BendSteps to a separate gauge-planning layer.

Do not start with automatic collision-free sequencing, automatic tooling or automatic finger selection.

## Highest-priority global blocker

The 2000 level remains technically complete except for the **genuinely information-separated F02 fresh-AI handoff** at `handoffs/F02-fresh-ai-compound-fault-transfer.md`. The current learner must not score it.

A correctly routed external PASS with no required corrections should graduate F02 and close the 2000 series unless it reveals a material defect.

## Exact next 3600 task if F02 is still externally blocked

Build a minimal **metadata-only importer contract/test fixture**, not a machine-motion lab. Use synthetic DXF-like entities plus optional sidecar metadata to verify:

1. cut/bend separation;
2. duplicate coincident bend-line diagnostics;
3. distinct collinear bend identity;
4. stable internal IDs independent of entity ordering;
5. UNKNOWN preservation rather than silent defaults;
6. reimport/revision invalidation of stale BendStep references.

Before coding the fixture, decide only the minimal source-neutral entity/provenance fields required by the normalized `ImportedPart` / `BendFeature` model. No target calculation or machine command should be part of that fixture.
