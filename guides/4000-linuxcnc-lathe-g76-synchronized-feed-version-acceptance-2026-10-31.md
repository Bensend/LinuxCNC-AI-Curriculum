# 4000 practical acceptance — G76/G33 spindle synchronization and axis-rate feasibility

Use [LATHE-35](../research/4400_LINUXCNC_LATHE_35_G76_G33_SYNC_FEED_FEASIBILITY_AND_OVERRUN_VERSION_SOURCE_AUDIT_2026-10-31.md) with **pinned** LinuxCNC source. This is a disconnected/software-only review specification, not a physical threading procedure.

## Static preflight worksheet

Given programmed spindle RPM S, pitch P in mm/rev, linear displacement vector Δ, and each axis maximum velocity in mm/min:

- path_length = sqrt(sum(Δ_linear_axis²))
- required_path_feed = abs(P) × S
- required_axis_feed_i = required_path_feed × abs(Δ_i) / path_length

For CSS, replace S with the highest RPM implied by the minimum radius and configured caps. For a G76 taper, use the effective taper pitch and its X/Z vector separately. Compare with **axis** maximums, not the GUI feed override slider. Do not assume G96 spindle limits, external INI getters, or installed version without evidence.

## Version and outcome matrix

| Version | Interpreter preflight | Runtime planner overrun | Evidence |
|---|---|---|---|
| v2.9.10 | no inspected check_spindle_sync_feed | no inspected tpSyncOverrun | pinned stable source |
| development 24e84c4 | axis-projected G33/G33.1/G76 check | 0.25 s / 2% / 99% ceiling-based detection; motion abort/error | pinned development source |
| installed unknown | **UNKNOWN** | **UNKNOWN** | record actual binary build SHA and effective INI/HAL |

## Minimal adversarial questions

1. Why can a G76 thread be wrong even when the planner completes a move? Explain pitch × RPM demand versus axis limit and position-sync following.
2. Why is an encoder index signal insufficient to guarantee pitch accuracy during the subsequent pass?
3. With P2 mm/rev, S900 RPM and a Z limit of 20 mm/s, calculate 30 mm/s demanded; identify the version-specific rejection mechanism.
4. Why can a G76 taper fail an X-axis rate check when the axial pass passes?
5. Why does the 0.25 s runtime window not guarantee a short spindle surge is caught?
6. Why does an unknown INI axis velocity limit make a development preflight verdict conditional?

## Bounded verification if isolated compute is positively available

Freeze a synthetic lathe INI with known Z axis maximum, fixed G97 spindle S, and G76 programs whose pitch × RPM is below versus above that limit. Use the interpreter harness for preflight and retain exact stdout/stderr/exit, pinned binary revision and INI getters. **Standalone interpreter getters may return zero**, which bypasses the new check; a standalone run without external axis limits is not a valid rejection oracle. For runtime, use disconnected LinuxCNC simulation with simulated spindle encoder and controlled speed, capture motion error and program status in a same-clock trace. Do not use real cutting hardware. Only isolated `[self-hosted, openpressbrake]` compute; no GitHub-hosted fallback. No test executed here.

**Acceptance boundary:** SOURCE-CONFIRMED static, TEST-CONFIRMED none, no claims of physical thread quality, axis stopping distance or safety integrity.
