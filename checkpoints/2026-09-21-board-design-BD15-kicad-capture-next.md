# Board-design curriculum checkpoint — BD15

Date: 2026-09-21
Lane: independent LinuxCNC/OpenPressBrake board-design curriculum

## Completed

Created `hardware/4000-board-design/BD15_KICAD_CAPTURE_ERC_RENDERED_AUTHORITY.md` at commit `bd29808c9ec8c1a43fa337834d5567790859ee31`.

BD15 teaches:

`engineering authority -> reusable block sheet/instance -> board integration/shared resources -> board-specific connection binding -> hierarchical/global/local net ownership -> symbol/footprint authority -> generated/rendered schematic -> ERC -> visual review -> rendered-net validation -> release evidence`

## Student-facing verification

Current OpenPressBrake main artifacts opened directly before finalizing the lesson:

- `hardware/blocks/differential_encoder/design/REV1_PRODUCTION_CONNECTIVITY.md`
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md`
- `hardware/rev1_schematic/NETLIST_CONTRACT.yaml`
- `hardware/integration/REV1_BOARD_INTEGRATION_RECONCILIATION.yaml`

They are `VERIFIED_FOR_LESSON` only for the bounded claims used by BD15: exact encoder primitive connectivity, current incomplete encoder release state, inter-sheet semantic ownership, and explicit precedence/quarantine of stale board authority.

They are `INCOMPLETE_NOT_STUDENT_MATERIAL` if presented as proof that the complete OpenPressBrake schematic is released. The encoder checklist explicitly leaves auto-rendered schematic visual review, PCB integration, cable/termination selection, protected field power and final release open.

## Adversarial findings

1. Capture must behave like compilation from engineering authority, not a place to invent missing engineering.
2. Semantic interfaces are insufficient unless exact pin/net lowering exists.
3. Schematic hierarchy is representation and must not redefine reusable-block ownership.
4. Global labels can silently destroy domain separation; electrical identity must come from authority.
5. ERC proves only encoded CAD-rule consistency, not machine correctness, topology correctness, physical transient behavior, harness identity or safety validity.
6. Rendered-net validation should fail closed on unexplained objects, forbidden joins, missing pins, stale components and duplicate connection ownership.
7. Correct schematic electrical identity does not prove acceptable PCB current-return geometry.
8. Source revision must be retained with ERC/rendered validation so upstream authority changes invalidate stale capture evidence.

## Durable freezes

- `RENDERER REPRESENTS AUTHORITY; RENDERER DOES NOT INVENT ENGINEERING`.
- `SEMANTIC CONTRACT != EXACT PIN CONNECTIVITY`.
- `HIERARCHY != OWNERSHIP`.
- `SAME TEXT LABEL != PROVEN COMMON NET`.
- `OLDER COMPLETE-LOOKING AUTHORITY != CURRENT AUTHORITY`.
- `GENERATED SCHEMATIC != VERIFIED SCHEMATIC != RELEASED BOARD`.
- `ERC PASS != ENGINEERING CORRECTNESS`.
- `CORRECT SCHEMATIC NET != QUALIFIED PCB CURRENT PATH`.
- `UNKNOWN CONNECTOR/FOOTPRINT != PERMISSION TO INVENT ONE`.
- `ORDINARY CONTROL REPRESENTATION != PERSONNEL-SAFETY AUTHORITY`.

## OpenPressBrake interaction

No OpenPressBrake files were modified. Current integration work is active and the newest main commit is `eb2602cd0b1b5a7fd534b0c49e2c3ffd1f176d76` (`integration: define Commander SK configuration evidence gate`). That work reinforces rather than closes BD15's fail-closed capture rule: installed drive configuration and physical facts remain evidence gates rather than renderer decisions.

No executable verification was justified in this curriculum step, so no synthesis/simulation/ERC job was dispatched and no GitHub-hosted compute was used.

## Exact next work — BD16

Build **FPGA/resource aggregation and executable fit evidence**.

Start by re-reading current main in both repositories and current board-design governance/checkpoints. Open every student-facing OpenPressBrake resource artifact directly.

Teach:

`block resource contract -> board instance count -> semantic resource allocation -> FPGA package/bank/pin plan -> LUT/FF/BRAM/PLL/clock/bus aggregation -> arithmetic headroom -> real configured image -> synthesis -> place-and-route -> timing -> regression trigger -> release evidence`

Adversarially distinguish:

- declared GPIO/resource need from package-pin allocation;
- package-pin allocation from legal bank/IO-standard fit;
- arithmetic LUT/BRAM budget from synthesized utilization;
- synthesis success from place-and-route success;
- place-and-route success from timing closure;
- a historical image from the current board configuration;
- unused capacity from actually routable/clockable capacity.

If executable synthesis/place-and-route/timing is genuinely required, use only the OpenPressBrake panel runner labeled `[self-hosted, openpressbrake]`. If the curriculum lane cannot dispatch it, continue source/evidence review and record the blocker; never substitute GitHub-hosted compute.
