# Board-design curriculum checkpoint — BD78 complete

Date: 2026-09-24

Durable lane now includes `board-design/BD78_CATALOG_GAP_ESCALATION_NEW_BLOCK_AUTHORIZATION.md`.

## Current freeze

BD78 converts a failed/held BD77 selection into a controlled architectural decision. A missing catalog match does not itself authorize new circuitry. Classify the need as existing block, existing variant, block-contract defect, reusable adapter, board-connection-only, new primitive, or hold pending evidence/machine fact.

New primitive/variant/adapter authorization requires current catalog/near-match inspection, anti-duplication and Where Used review, a technology-neutral reusable requirement charter, explicit power/return/resource/protection/default/fault obligations, evidence and qualification plans, cost ownership, provenance, unresolved facts, and safety boundary.

Current OpenPressBrake main inspected for BD78: `a0e974c985162f2577dd194a022f055bd3b978e1`. OpenPressBrake remained read-only because active board/block engineering is advancing there. No executable verification was justified; no hosted compute was used.

## Catalog stress-test defect

The block library needs a machine-readable gap/new-block authorization registry joined to selection records, exact contract revisions, nearest existing blocks, semantic/envelope deltas, reverse Where Used, unresolved facts, authorization state, engineering/evidence plans, and downstream status. This is not yet safe to patch as an isolated catalog edit while active engineering is moving.

## Exact next work

BD79 — New-Block Engineering Charter to Qualified Baseline.

Take an authorized hypothetical primitive/variant/adapter through:

`reusable charter -> proven-reference/topology search -> electrical calculations/derating -> protection/default/fault design -> FPGA/bus/power/return contract -> exact connectivity -> question-driven verification plan -> status/evidence package -> baseline integration handoff`

Use a verified current OpenPressBrake block as the worked evidence model, but do not imply production qualification. Re-open every student-facing file in current form. Re-read current main in both repositories before any overlapping write. Keep simulation/synthesis/other executable verification on `[self-hosted, openpressbrake]` only when a concrete question genuinely requires it.