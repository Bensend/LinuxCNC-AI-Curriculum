# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD49 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD49_CONFIGURATION_CHANGE_CONTROL_DETERMINISTIC_REGENERATION_AND_SEMANTIC_DIFF_REVIEW.md`.

BD49 teaches:

`locked configuration -> requested change -> semantic intent diff -> affected authority/resource set -> re-solve -> deterministic regeneration -> semantic output diff -> targeted verification -> promotion/release decision`

## BD49 hard student-material audit

Every repository file named to students as finished material by BD49 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD48_CONFIGURATION_SELECTION_CLOSURE_AMBIGUITY_RESOLUTION_AND_FAIL_CLOSED_BOARD_GENERATION.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/relay_contactor_driver/manifest.yaml` for the current one-coil reusable contract and resource declaration
- OpenPressBrake `hardware/blocks/relay_contactor_driver/REV1_BOARD_INTEGRATION_HANDOFF.md` for the current board-owned population, FPGA, connector, field-power, mapping, and current-envelope responsibilities
- OpenPressBrake `hardware/blocks/relay_contactor_driver/STATUS_CHECKLIST.md` for current `SIMULATION-READY` status and remaining qualification/release gates

The relay-driver material is bounded integration evidence, not proof that `relay_contactor_driver` is schematic-ready, production-proven, safety-rated, or `REV 1 READY`. BD49 itself was re-opened from current main after commit and checked against these inspected sources.

## Rules frozen by BD49

- latest files do not establish a known baseline;
- requested changes are classified by semantic intent before textual diff size;
- text-diff size does not measure engineering impact;
- unchanged files do not prove that their evidence remains applicable;
- board-only connector/pin/harness/FPGA mapping changes do not justify reusable-block redesign when published contracts remain satisfied;
- population changes require re-solving every shared resource whose equation includes population, grouping, simultaneity, or package allocation;
- old selection plus new intent is not a valid configuration;
- deterministic regeneration is necessary but does not prove engineering equivalence;
- same-looking schematic does not establish the same release identity when consumed authority/provenance differs;
- targeted regression follows changed semantic claims and dependency closure rather than minimal convenient testing;
- superseded baseline identity and negative evidence remain recoverable;
- ordinary-controller diff review does not establish independent personnel-safety validation;
- required executable verification uses only `[self-hosted, openpressbrake]`; unavailable authorized compute remains `BLOCKED/NOT_RUN`.

## Worked-example stress test

Current OpenPressBrake `relay_contactor_driver` is a one-coil primitive. Each populated instance consumes one FPGA command output and two FPGA diagnostic inputs. Shared field-power/branch protection, installed count, physical connector, FPGA ball assignment, machine mapping, simultaneous-load assumptions, and final published current/repetition envelope remain board/integration responsibilities.

BD49 uses this to show why an `N -> N+1` population change is not a one-row edit: GPIO demand changes from `N` command outputs plus `2N` diagnostic inputs to `N+1` plus `2(N+1)`, while field distribution, branch protection, connector allocation, simultaneous-load/thermal assumptions, and PCB current paths must also be reconsidered. None of that justifies forking the reusable primitive into a machine-count variant.

The current block remains `SIMULATION-READY`. Final controller current/repetition/simultaneity qualification, fault/abnormal checks, PCB constraints, shared-resource closure, board integration, and human release remain open.

## Catalog stress-test result

BD49 exposes a missing machine-readable **configuration-change and semantic-regeneration layer** above selection locks. It should connect authorized semantic intent changes to reverse dependencies, shared-resource re-solving, generated-output semantic diffs, evidence invalidation/preservation, targeted regression, candidate identity, and promotion/applicability decisions.

The relay-driver example adds an important integration requirement: per-instance resource demand is insufficient unless tooling can also identify board-owned resources whose closure depends on aggregate population, simultaneity, protection, connector, thermal, and current-path assumptions.

Proposed infrastructure remains `ENGINEERING_REVIEW_NEEDED`.

## Current repository reconciliation

At run start the board-design checkpoint ended at BD48. Curriculum main also contained concurrent safety-course work, which remained intact. OpenPressBrake had advanced to active relay-driver Rev1 board-integration work.

BD49 was committed as `fd123e042529b9768aac88d43453f339a6f96340` and re-opened from current main. Immediately before this checkpoint write, curriculum main had BD49 as its newest commit. OpenPressBrake current main was `c551aa6dd366058def9b60f18267f20c4f0bb3e1` (`relay driver: publish Rev1 board integration handoff`). OpenPressBrake was consumed read-only; no active engineering artifact was overwritten.

## Next exact work

Build BD50 on **generated-artifact equivalence, canonicalization, and reproducibility acceptance**:

`two candidate generations -> normalize non-semantic variation -> compare semantic model -> compare authority/provenance -> classify exact/equivalent/materially-different -> reproducibility evidence -> acceptance or investigation`

Stress byte-different but semantically identical generated netlists, visually identical schematics with different authority inputs, reordered BOM/resource output, tool-version changes that alter formatting but not connectivity, and a change that appears cosmetic but changes default/output authority or current-return semantics.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD49. No GitHub-hosted runner was used.

## Safety boundary

BD49 teaches configuration change control and semantic diff review for ordinary controller hardware/configuration. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. An ordinary status-monitor, watchdog, inhibit, STO request, or enable-interface remap remains ordinary-controller work unless a separately engineered and validated safety architecture establishes more.
