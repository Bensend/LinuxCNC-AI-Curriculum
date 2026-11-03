# 2026-11-03 00:41Z — HM2-MODBUS-175 continuation checkpoint

**Priority and governance:** LinuxCNC internals first; 4000 implementation NON-GRADUATED, 3100/3200/3300/3400/3600 transfer. 1000/2000/F02/3000 remain GRADUATED/CLOSED. Independent personnel-safety authority, evaluator separation and OpenPressBrake G0/G1 HOLD unchanged. Hourly curriculum stays enabled.

## Newly source-confirmed (NOT RUN)

[HM2-MODBUS-175 audit](../research/4400_LINUXCNC_HM2_MODBUS_175_PARSE_ERROR_COUNTER_AND_HAL_DIAGNOSTIC_SOURCE_AUDIT_2026-11-03.md) pins LinuxCNC v2.9.10 and development 67437d8 hm2_modbus.c. This is Mesa PktUART Modbus RTU, distinct from hm2_eth transport and HostMot2 watchdog. Source shows: (A) successful normal reply clears private consecutive-error count but leaves HAL command.MM.errors stale; (B) CRC-valid wrong register/coil byte count calls set_error then breaks to parser return 0, so STATE_HANDLE_DATA immediately resets private count, preventing five repeated malformed replies from disabling command; (C) instance fault is cleared at handled-frame exit even when parse failed, and command error-code may remain zero for errors 1–4. Docs promise consecutive error count; upstream 7i96S INI/HAL/MBCCS confirms real setup and suspend/scale sequence. Runtime effect UNKNOWN.

[Disconnected guide](../guides/3100-3200-3300-3400-4000-linuxcnc-hm2-modbus-error-counter-commissioning-2026-11-03.md), [A–F oracle and pure model](../examples/4000_hm2_modbus_175/README.md), [development review-only patch](../examples/4000_hm2_modbus_175/development_counter_parse_review_only.patch) committed. Patch source snippets and unified hunk counts checked against pinned development; NOT APPLIED, BUILT OR TESTED. Model NOT EXECUTED. No new Actions, HAL, Mesa, Modbus, machine or evaluator run; hosted/self-hosted 0/0 min; lab/blind ledgers unchanged.

## Next highest-value actions

1. **Executable gate:** MOTION-144 remains the first executable priority **only after independently verified physical disconnection/isolation** of allowlisted [self-hosted, openpressbrake] runner. Never use GitHub-hosted Actions or a live machine for fault injection. No workflow dispatch without qualified isolation.
2. Once that prerequisite is satisfied and MOTION-144 addressed, run HM2-MODBUS-175 A–D against original and patched versions using a mock PktUART / disconnected setup, with correct Modbus CRC for byte-count-mismatch controls; capture per-servo-cycle HAL errors/disabled/error-code/fault and source version. Treat pure model assertions as MODEL only.
3. **If still blocked**, rotate to a distinct LinuxCNC source question, preferably actual PNCconf-generated HAL/INI correctness or motion realtime implementation after scanning PROGRESS, historical lab evidence and upstream tests. Do not repeat HM2-ETH-82 stale-sequence, WD-84 recovery, SSERIAL-54 scanning, or CYCLE-174. A bounded next HM2-MODBUS question, if justified, is exhaustive parser error return/pin accounting and command freshness under suspension; no compulsory product build.
4. Maintain source provenance, real config constraints, independent evaluator separation, and current file readiness. Do not reopen graduated levels.

**Evidence:** SOURCE/DOC-CONFIRMED conditional, predicted counters INFERENCE, TEST-CONFIRMED none; no compute runtime this session. Current repository branch main; verify final head and lesson log before closing.
