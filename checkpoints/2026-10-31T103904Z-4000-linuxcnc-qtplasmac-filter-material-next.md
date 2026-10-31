# 2026-10-31T103904Z — QtPlasmaC G-code filter geometry and material handoff checkpoint

**Active:** 4000 LinuxCNC-first NON-GRADUATED; 1000/2000/F02/3000 remain CLOSED. Owner priority LinuxCNC internals and machine-specific transfer; safety is cross-cutting, independent personnel-safety authority and evaluation separation unchanged. Read START_HERE, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, blind feedback protocol/score, LAB_COMPUTE_LOG, prior VMC/CAM checkpoint and CAM-38/PLASMA-32. No due independently isolated blind evaluation became executable; score log unchanged.

## Completed new source work
1. [PLASMA-39](../research/4400_LINUXCNC_PLASMA_39_QTPLASMAC_HOLE_FILTER_COORDINATE_STATE_SOURCE_AUDIT_2026-10-31.md): stable v2.9.10 and pinned development `qtplasmac_gcode.py` both have duplicate X/X predicate skipping Y-only moves; G91 arcs can be counted twice; zero X or Y suppresses full-circle `isHole`; G90.1 J branch calls `get_axis_value('J')` with missing required argument. These are conditional static source findings, not runtime failures.
2. [PLASMA-40](../research/4400_LINUXCNC_PLASMA_40_QTPLASMAC_MAGIC_MATERIAL_JH_PERCENT_CROSS_UNIT_SOURCE_AUDIT_2026-10-31.md): `jh` is **percentage** per official docs and plasmac.comp, but stable cross-unit magic comment stores `ph/unitMultiplier` and development stores `jh/unitMultiplier`; neither preserves percentage. Inch machine with G21, ph=3.1 mm, jh=150% yields stable ~0.004805%, development ~5.9055% (expected 150%). Actual GUI clamp and physical behavior UNKNOWN. QtPlasmaC post requires explicit spindle/tool and material synchronization contracts.
3. [Disconnected acceptance guide](../guides/4000-linuxcnc-qtplasmac-cam-filter-coordinate-material-acceptance-2026-10-31.md): four geometry fixtures, cross-unit magic material fixture, post skeleton, A–F evidence gates. **None executed.**

**Provenance:** LinuxCNC stable tag `v2.9.10` filter blob `4cdae156b94b607bd2514b1573baabc83f396f23`; development commit `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` filter blob `aeff3b6103f8c17a1e845b0f835f9ec9f30210b5`; official qtplasmac.adoc, plasmac.comp and upstream simulation INI inspected. Novelty checked against prior PLASMA-32 (M62/TP timing) and CAM-38 (OpenBuilds DXF), not duplicated.

## Evidence / compute
SOURCE-CONFIRMED static and DOC-CONFIRMED percentage/modes; INFERENCE for generated numeric values and Python exception; TEST-CONFIRMED none. No build, workflow, simulation, physical machine operation, independent evaluator or new authoritative job runtime. GitHub-hosted/self-hosted Actions 0/0 minutes; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Runner isolation UNKNOWN; no dispatch.

## Exact next work
1. On a **positively isolated** `[self-hosted, openpressbrake]` LinuxCNC simulation only, reproduce **one** highest-value discriminator: G90.1 J filter exception or inch/G21 magic jh percentage. Preserve original/filtered G-code, machine INI, material file, stdout/stderr, exact job timestamps and failure category. Never GitHub-hosted runner or physical torch.
2. If compute remains unavailable, trace **LinuxCNC Task/GUI filter error propagation** (how a Python filter exception surfaces to the operator, and whether partially filtered output can be loaded), or rotate to under-covered LinuxCNC robotics/kinematics or real router configs if that adds more information. Avoid redundant filter bug cataloguing.
3. Before upstream patch proposal, review a minimal change for all four PLASMA-39 cases together; fixing only the duplicated X predicate can leave incremental double-update. For PLASMA-40, treat `jh` as dimensionless and check both unit directions, zero sentinel and GUI limits. Keep new work NON-GRADUATED until independent verification.

**Publication checks:** read back new documents, verify internal links and append complete LESSON_LOG after preserving prior blob. Hourly task remains enabled.
