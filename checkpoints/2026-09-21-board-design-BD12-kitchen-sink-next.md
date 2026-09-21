# Board-design curriculum checkpoint — BD12

Date: 2026-09-21
Lane: independent LinuxCNC/OpenPressBrake board-design curriculum

## Completed

Created `hardware/4000-board-design/BD12_FULL_BOARD_KITCHEN_SINK_INTEGRATION_REVIEW.md`.

BD12 is a BOARD INTEGRATION stress test:

`machine functions -> selected block instances -> canonical connection owners -> FPGA/pin/bus resources -> power/current/return domains -> output authority -> hidden-glue search -> partial-power matrix -> capture hierarchy -> unresolved-gate ledger`

The lesson explicitly distinguishes electrical net identity from physical current-path permission and teaches that schematic assembly, schematic release, PCB release and production qualification are separate maturity states.

## Student-facing verification

Before finalizing BD12, the current OpenPressBrake `main` versions of these artifacts were opened directly and inspected:

- `hardware/integration/REV1_BOARD_INTEGRATION_RECONCILIATION.yaml`
- `hardware/integration/REV1_FIELD_PIN_SEMANTIC_OWNERSHIP.yaml`
- `hardware/integration/REV1_POWER_DOMAIN_RENDERER_AUTHORITY.yaml`
- `hardware/integration/REV1_RETURN_DOMAIN_GROUNDING_AUTHORITY.yaml`
- `hardware/integration/REV1_OUTPUT_INHIBIT_AUTHORITY.yaml`
- `hardware/integration/REV1_SCHEMATIC_RELEASE_GATE_MATRIX.md`

They are `VERIFIED_FOR_LESSON` only for the bounded integration claims stated in BD12. The complete OpenPressBrake board is not presented as production-proven.

## Catalog stress-test findings

1. Whole-board FPGA resource aggregation remains distributed. A board-owned machine-readable ledger should eventually aggregate package pins/banks/I/O standards, buses, clocks, LUT/FF/BRAM/PLL evidence and synthesis status while preserving unknowns.
2. Electrical-net identity and PCB current-path permission must remain separate first-class concepts. The current Rev14/Rev1 `CTRL_0V` reconciliation demonstrates why a single electrical net does not authorize noisy load current through precision copper.
3. Partial-power/back-power behavior is not uniformly machine-readable across every reusable block.
4. Release-gate dependency edges should eventually be machine-readable so design changes can invalidate the correct board-level evidence.

No OpenPressBrake patch was made because return-domain and board-integration work is active. Current OpenPressBrake main was re-read immediately before the checkpoint and remained `8f0c5add116e2635b0c456258cc3a81ee3ff7088`.

No executable compute was justified; no GitHub-hosted compute was used.

## Durable freezes

- `MACHINE FUNCTION INVENTORY PRECEDES SCHEMATIC HIERARCHY`.
- `MOST COMPLETE-LOOKING FILE != HIGHEST-PRECEDENCE AUTHORITY`.
- `CONNECTOR EXISTS IN LEGACY DRAWING != CONNECTOR MAY BE INSTANTIATED`.
- `UNKNOWN RESOURCE COST IS A LEDGER ENTRY, NOT ZERO`.
- `SAME ELECTRICAL NET UPSTREAM != PERMISSION TO SHARE SENSITIVE PCB CURRENT PATH`.
- `ORDINARY HARDWARE INHIBIT != INDEPENDENT PERSONNEL-SAFETY AUTHORITY`.
- `MISSING CROSS-BLOCK KNOWLEDGE -> NAMED DEFECT OR RELEASE GATE`.
- `SCHEMATIC ASSEMBLY MAY PROCEED != SCHEMATIC RELEASED != PCB RELEASED != PRODUCTION PROVEN`.

## Exact next work — BD13

Return to BLOCK/CONNECTION methodology with a board-specific connection-mold qualification lesson. Teach how a connection mold is populated from a reusable methodology into one board instance without becoming a reusable electrical block.

Start from current main in both repositories. Inspect the current connection-definition contract/schema, board-design mold library, at least one strong current connection definition, and its owning reusable block/interface before naming student material.

BD13 should teach:

`machine endpoint evidence -> connection-mold fields -> connector electrical/mechanical requirements -> pin mapping -> power/return requirements -> functional/FPGA mapping -> placement/edge/orientation -> silkscreen/labels -> harness destination -> derating/creepage/clearance where applicable -> machine verification -> capture/PCB release state`

Adversarially test whether connector family, pinout, current/voltage/contact rating, mating part, conductor range, keying, placement, label, shield/chassis treatment and machine destination can be specified without leaking machine assumptions into reusable circuitry. If a connection definition is electrically complete but physically unresolved, teach it as incomplete rather than guessing a connector.
