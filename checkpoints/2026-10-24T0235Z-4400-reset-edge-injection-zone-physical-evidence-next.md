# Active 4400 safety continuation — 2026-10-24T02:35Z reset-edge and hydraulic injection zones

**Newest active checkpoint. Supersedes** `checkpoints/2026-10-24T0151Z-4400-hydraulic-oem-handoff-physical-proof-next.md`. UTC session start recorded **2026-10-24T02:35:23.208Z** before substantive work. Required START_HERE/governance, safety course index/design, current 4400-HY-01, external feedback and lab state inspected. **1000/2000/F02 graduated; completed 3000 preserved. 4400 safety is primary.**

## Durable research, teaching and integration

1. [Rockwell MSR142RTP 440R-IN089A July 2022 original-source audit](../research/4400_MSR142_RESET_EDGE_POWERUP_FEEDBACK_WIRING_SOURCE_AUDIT_2026-10-24.md) and [ten-case technician card](../safety-course/4400_RESET_EDGE_POWER_RESTORATION_AND_FEEDBACK_TECHNICIAN_CARD_2026-10-24.md). **DOC-CONFIRMED** T reset lacks edge monitoring and can reenable at power-up when safety and reset circuits close; R monitored requires transition; 440R-xxxxxM negative-edge resets on button release; Y1–Y2 observes actuator NC contacts, not load holding; input cross-loop coverage depends on wiring. Pilz PNOZ X uses its own start terminology. **UNKNOWN** selected OpenPressBrake device/wiring. Cumulative design package **§11BA** and safety power/common intake extended.
2. [Parker 4400-B.1 / HSE injection injury / Enerpac source audit](../research/4400_HYDRAULIC_PINHOLE_INJECTION_HOSE_FAILURE_ISOLATION_SOURCE_AUDIT_2026-10-24.md) and [eight-case technician card](../safety-course/4400_HYDRAULIC_PINHOLE_LEAK_AND_PRESSURE_ZONE_TECHNICIAN_CARD_2026-10-24.md). **DOC-CONFIRMED** invisible pinhole jets, residual hose pressure after pump-off/check valves, no hand leak search or failed-hose patch, emergency medical care for suspected injection. **INFERENCE** selected-machine hazard transfer, no numeric safe pressure. Cumulative **§11BB**, selected-machine **IN-04b** hose/test-point/spray-zone intake added.
3. Safety index, publication ledger and `PROGRESS.md` updated. New files are **outside** original 85-file archive. **Untruncated Git tree audit**: 117 index relative links, 115 distinct targets, **0 missing**. All four new source/card paths confirmed on main.
4. No selected-machine tests, safety acceptance, blind scores, simulations or new LinuxCNC source tracing. No new lab runtime: `LAB_COMPUTE_LOG.md` unchanged. The old self-hosted-only `append-lesson-log.yml` run **39919548510 / job 120301190483** remains **QUEUED** on `[self-hosted,openpressbrake]`; queue time is not compute. **GitHub-hosted Actions compute 0, local lab compute 0.** Dormant `ubuntu-latest` workflows not invoked or modified.

## Exact open gates

- OpenPressBrake `IN-01..10/03a/04a/04b/10a`, `OPT/PHY` **UNKNOWN**; `VAL/PT NOT RUN`; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Independent physical Y1/Y2 stop/hold/energy/guard/restart proof absent; no personnel-exposed hazardous operation authorized. Experimental operation must be isolated/remote with all people outside danger zones and residual risk stated.
- `4400-HY-01` source-reading module **NOT GRADUATED**; fresh-AI documentary handoff **PREPARED / NOT RUN / NOT SCORED**. 2520–25F0 external safety competency evaluations remain OPEN.
- Original archive **6/85** exact historical documents still pending because original bytes unavailable; never reconstruct as exact release.
- No selected safety relay/reset suffix, Y1/Y2 hydraulic/pressure-zone/hose map, rated mechanical restraint, guard geometry or fresh local restart wiring. No numerical pressure, safe speed, stopping distance/time, PL/SIL/DC invented.

## Precise next-work selection

1. **Selected hardware intake first when available:** actual Y1/Y2 as-built hydraulic schematic and hose/pressure zones; valve/safety-controller exact codes, field supplies and reset edge/EDM wiring; independent final elements; accessible safe bleed/test ports, guard/escape/occupancy; load restraint; local deliberate start after safety reset. Qualify `IN-03a/04a/04b/10a` and `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/ARC` before drafting `VAL/PT` acceptance.
2. Independent 4400-HY-01 fresh-AI **paper** handoff using prepared evaluator contract without exposing hidden answers or self-scoring. Keep external gates OPEN.
3. If hardware and evaluator unavailable, rotate to the highest-value **new** safety failure path with original OEM/standards evidence, not another generic 3000 or redundant paper experiment.
4. No compute merely to stay busy. If justified, only bounded workflow targeting `[self-hosted,openpressbrake]`; never `ubuntu-latest` or any hosted Actions runner.
5. Immediately before ending, safely append actual UTC end, elapsed minutes and overlap to complete `LESSON_LOG.md` with fresh SHA; verify committed row. Keep recurring curriculum enabled.

**Previous canonical session ended 2026-10-24T01:53:23.962Z; this session started 2026-10-24T02:35:23.208Z (~41.99 minutes later), so no known overlap.** External concurrent work not independently established.
