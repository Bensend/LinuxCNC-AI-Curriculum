# Safety Curriculum Lane B checkpoint — replacement equivalence — 2026-09-16

## Parallel-lane check

Before selecting work, Lane B read the required curriculum entry/order/policy/progress material, current safety checkpoint and recent commits. Primary safety work is presently advancing complete professional/OEM safety wiring references, cross-machine safe-motion/cell references, and the unresolved press-brake electrical-to-hydraulic hazardous-energy mapping. Lane B did not modify those artifacts.

Current primary checkpoint: `checkpoints/session-2026-09-16-safety-wiring.md`.

## Durable work completed

Created:

- `safety-course/SAFETY_REPLACEMENT_PART_EQUIVALENCE_SUBSTITUTION_WORKSHEET.md`

Commit: `2967f2dcb62fa3a3bbba94411d607534fbf6e9c2`

## Frozen rule

`same voltage/current/connector/shape` does not establish safety equivalence. Replacement acceptance follows the safety function and all dependencies actually relied upon by the machine.

The worksheet separates:

1. exact replacement;
2. manufacturer-approved successor;
3. engineered equivalent; and
4. merely similar / fit-compatible substitute.

It forces comparison of safety role, output/contact architecture, feedback/EDM, reset semantics, test-pulse/OSSD behavior, configuration/firmware identity, wiring, mechanical actuation, environmental constraints, hydraulic/pneumatic function where applicable, calibration, diagnostics and required revalidation.

A safety-relevant `UNKNOWN` that can defeat the function blocks an equivalence claim.

## Evidence provenance

- `SOURCE-CONFIRMED`: OSHA treats a press as an integrated mechanical/electrical/hydraulic/pneumatic/tooling/safeguarding system and calls for damaged or incorrectly operating parts to be repaired/replaced before use.
- `SOURCE-CONFIRMED`: OSHA maintenance guidance requires hazardous-energy control when safeguards are removed and inspection that guards/safety devices are restored and functional before return to service.
- `SOURCE-CONFIRMED`: OSHA interlock guidance states that restoring an interlocked guard should not itself automatically restart the machine.
- `INFERENCE`: therefore replacement suitability must be evaluated against the affected safety-function dependencies and physically revalidated to the justified extent; superficial fit is insufficient.
- `UNKNOWN`: no OpenPressBrake-specific safety-component substitution, hydraulic valve truth table, stopping distance, pressure threshold, PL/SIL/category, or response-time value was asserted.

## Compute

None. This was source/documentation and architecture work. No GitHub-hosted runner was used and no hosted Actions minutes were consumed.

## Re-read-main conflict check

After the worksheet commit, `main` was re-read. HEAD was the Lane-B worksheet commit and the immediately preceding primary-lane checkpoint remained `8206f889...`; no overlapping primary file changed during the write. No reconciliation was required.

## Precise next independent work

Build `safety-course/SAFETY_SPARE_PARTS_OBSOLESCENCE_LIFECYCLE_WORKSHEET.md` covering:

- approved spare identity and revision control;
- manufacturer discontinuance and successor qualification;
- storage aging/environment and shelf-life evidence where applicable;
- firmware/configuration/device-identity dependencies;
- cannibalized/used parts and lost provenance;
- counterfeit or unknown-source components;
- periodic inventory/document reconciliation;
- what prior evidence survives when a long-stored spare is installed;
- what physical safety function must be re-challenged before return to service.

Keep this independent of the primary lane's OEM wiring/hydraulic reference tracing. Do not invent generic shelf-life intervals or machine-specific safety values.