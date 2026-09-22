# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD34 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD34_FIELD_RETURN_REPAIR_RETROFIT_AND_AS_MAINTAINED_CONFIGURATION.md`

BD34 teaches:

`installed identity -> service finding -> repair/substitution/configuration change -> semantic impact -> post-service as-maintained identity -> affected evidence -> regression/functional verification -> installed-baseline update -> future field applicability`

## BD34 hard student-material audit

Every repository file named to students by BD34 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD33_PRODUCTION_ESCAPE_CONTAINMENT_NONCONFORMANCE_TRENDS_AND_CATALOG_FEEDBACK.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/blocks/digital_output_24v/manifest.yaml`

The newly created BD34 lesson was re-opened from current main after commit and checked against the inspected sources.

`ENGINEERING_REVIEW_NEEDED`:

- current OpenPressBrake `digital_output_24v` reusable non-isolated variant remains `SIMULATION-READY`;
- the Rev1 isolated board path is not yet `SCHEMATIC-READY`; exact KiCad mapping, structural validation, fault/abnormal qualification, PCB thermal/current evidence, integration and human release remain open;
- OpenPressBrake has no repository-wide immutable service-event/as-maintained configuration registry joined to release/as-built/installed identity;
- current engineering development is not evidence of a released serialized population, actual field repairs, retrofit history, approved service substitutions, or return-to-service authority.

No inspected file is used to claim complete OpenPressBrake production or field-service readiness.

## Rules frozen by BD34

- released, as-built, as-installed, and as-maintained identities are distinct;
- repair completion does not prove the old installed baseline remains true;
- post-repair PASS does not erase pre-repair negative evidence;
- unknown installed identity does not default to a release baseline;
- like-for-like electrical replacement does not complete lot traceability;
- physical drop-in does not establish qualification inheritance;
- same PCB does not establish the same FPGA/HAL controller configuration;
- programming success does not prove the correct programmed baseline;
- field wiring/jumper changes are configuration changes and remain at the correct ownership layer;
- service changes invalidate evidence by semantic impact, not convenience;
- machine operation does not prove all affected evidence current;
- a retrofit can fix its target issue while dependent evidence remains stale;
- current as-maintained identity must drive future installed-asset applicability;
- ordinary safety-status restoration is not personnel-safety revalidation.

## Current OpenPressBrake worked-example result

The current `digital_output_24v` manifest remains a useful bounded service-governance example because it keeps generic block interfaces separate from unresolved board channel current, inrush, duty, simultaneous-use assumptions, connector rating, PCB limits, and machine load facts.

The current status checklist also freezes the first-machine Rev1 isolation/return-domain rule: L7/L07 remains separate from L06/logic ground and no L07-to-L06 bridge is permitted. A hypothetical field jumper bonding those returns would therefore be a material architecture/configuration change requiring engineering disposition, not a harmless service shortcut and not a reason to rewrite the reusable primitive.

No OpenPressBrake production release, serial, installed machine configuration, field repair, or retrofit is asserted. OpenPressBrake remained read-only.

## Current repository reconciliation

Before BD34 was written, current main was re-read in both repositories. Curriculum main was `f220964783cddb7e4e799b335fb2b1cb1b4a2a3e`; its concurrent safety-lane work did not overlap the board-design lesson path. OpenPressBrake current hardware development had advanced through `cdd55c222baf3d0dd5f788290c4907dc6b8a860d` (`shared ADC: bound REF5020 reference error contribution`) with immediately adjacent machine-power and PCB-layout-gate work, so OpenPressBrake remained read-only.

BD34 was committed as `f9556fa6e22e0106efa941b8a6b9e48ea0e16f87` and re-opened from current main before this checkpoint update. Current curriculum main was re-read again immediately before this write and contained BD34 with no overlapping post-BD34 board-design change.

## Catalog stress-test result

BD34 exposes a concrete service/configuration infrastructure need: future tooling should represent an immutable service event that references pre-service installed identity, finding evidence, removed/installed parts, board/adapter revisions, FPGA/software/HAL identities, wiring/jumper/harness changes, engineering disposition, changed semantic facets, stale/preserved evidence, regression results, unresolved `VERIFY_AT_MACHINE` facts, and resulting as-maintained identity.

Raw machine service history must not be dumped into reusable block manifests. Only justified generic engineering consequences should flow back into reusable contracts.

This infrastructure need remains `ENGINEERING_REVIEW_NEEDED`; current OpenPressBrake evidence does not justify inventing releases, serials, assets, repairs, substitutions, or retrofit states.

## Next exact work

Build BD35 on **service-parts policy, approved-alternate envelopes, obsolescence, and lifecycle migration without corrupting reusable qualification**.

Teach:

`part lifecycle event -> consumed semantic facets -> alternate/equivalence evidence -> affected blocks/releases/installed assets -> new-build vs service-only decision -> qualification/regression -> service-parts baseline -> obsolescence migration -> field applicability`

The adversarial lab should include exact-MPN obsolescence, an approved alternate with a narrower qualified envelope, a package-compatible but electrically non-equivalent part, last-time-buy versus redesign, a service-only legacy part, mixed installed populations, FPGA/toolchain obsolescence, and an ordinary safety-status interface component migration that must not be promoted into personnel-safety authority.

Require students to preserve exact part and qualification identity, bind approved alternates to explicit applicability envelopes rather than family names, separate new-build and service-only policy, use `SHOW WHERE USED` plus current as-maintained installed identity, and propagate lifecycle redesign through semantic dependencies/evidence without silently rewriting historical releases.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD34. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD34 teaches service/configuration reconciliation for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, safety diagnostic coverage, stopping performance, final-element validation, or independent personnel-safety authority. Restoring an ordinary receiver for a safety-system status signal proves only the bounded ordinary electrical/status claim actually verified.