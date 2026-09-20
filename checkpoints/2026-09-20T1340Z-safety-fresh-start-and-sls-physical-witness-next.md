# 4000 safety continuation checkpoint — fresh-start and SLS physical witness

Date: 2026-09-20

## Completed this session

1. `safety-course/PENDING_START_ACROSS_RESET_AND_FRESH_START_EDGE_AUTHORITY_STUDY_2026-09-20.md`
   - Siemens directly exposes the stale/pending START hazard across RESET.
   - SICK UE440/UE470 provides ordered RESET completion followed by a later START rising edge.
   - Generic stale-start/reset searching is now information-gain limited unless a source adds a physical integrated acceptance witness.

2. `safety-course/SAFE_LIMITED_SPEED_PHYSICAL_OVERSPEED_ACCEPTANCE_WITNESS_STUDY_2026-09-20.md`
   - Siemens acceptance procedures deliberately challenge SLS with physical motion/overspeed and verify detection/stop response rather than trusting configuration/status alone.
   - Preserve: SLS configured != selected != active != physical speed limited != stop performance accepted.

`PROGRESS.md` was advanced for the stale-start/fresh-start branch. The SLS study is additionally preserved here as the newest branch result.

## Exact next work

Prefer a complete manufacturer **setup/service-mode acceptance chain** that combines several already-studied layers rather than another isolated status-bit study:

- explicit mode selection / mode exclusivity;
- guard/protective-device suspension only as permitted by the mode;
- three-position enabling device or equivalent hold-to-run authority where applicable;
- independently monitored SLS/SSM or other task-specific safe-motion function;
- deliberate physical challenge of the speed/stop boundary;
- release/abort behavior;
- exit from setup/service mode;
- reset/rearm;
- stale ordinary command rejection and fresh production START.

Good sources are integrated manufacturer robot/CNC/drive commissioning or acceptance procedures. Do not invent OpenPressBrake-specific speed limits, stopping distances, response times, PL/SIL, or hydraulic behavior.

If this integrated chain is source-limited, rotate to another physical safety-function witness. Avoid duplicating Lane-B guard-lock work and avoid generic scanner, EDM, STO, brake, safety-input, reset/restart, or SLS cataloging.

## Compute

No simulation/build/test compute was justified or run. No GitHub-hosted runner was used. Any future justified compute must target `[self-hosted, openpressbrake]` only.
