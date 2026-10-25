# 4400-DUST-04 — M8/M9 interpreter queue and remap are normal control, not LEV safety timing
**2026-10-25 | SOURCE-CONFIRMED LinuxCNC `062dc7c097693bb68e76192516cd92878dd5ecdf` | no runtime**

## End-to-end source trace
- `docs/src/gcode/m-code.adoc:202–215`: documented M7 mist, M8 flood, M9 both off. The manual explicitly allows HAL wiring to *any* output, but does not certify such wiring for personnel safety.
- `src/emc/rs274ngc/interp_convert.cc:4340–4353`: M-code group 8 checks `STEP_REMAPPED_IN_BLOCK`; remapped M8/M9 can follow a different configured path. Ordinary M8 calls `enqueue_FLOOD_ON()` and updates `settings->flood`; M9 enqueues mist and flood OFF and updates settings. The interpreter's `settings->flood` is **software state**, not fan/flow proof.
- `src/emc/rs274ngc/interp_queue.cc:131–150`: if the canonical queue is empty, flood ON/OFF calls `FLOOD_ON/OFF()` immediately; otherwise it appends a `QFLOOD_ON/QFLOOD_OFF` event. `interp_queue.cc:502–508` later issues the queued canonical command. Therefore even normal request timing depends on queue context, and should not be equated with immediate physical airflow.
- `src/emc/task/emccanon.cc:3340–3343`: `FLOOD_ON()` constructs `EMC_COOLANT_FLOOD_ON` command.
- `src/emc/task/emctaskmain.cc:2151–2156`: Task dispatches to `emcCoolantFloodOn/Off()`.
- `src/emc/task/taskclass.cc:437–448`: normal HAL `iocontrol.0.coolant-flood` and status change. No fan/capture/collector feedback in this path.
- `src/emc/task/emctask.cc:331–366`: development Task state changes can force ordinary flood OFF; 2.9 implementation differs, as traced separately in [DUST-02](4400_LINUXCNC_2_9_VS_DEVELOPMENT_COOLANT_REQUEST_AND_ESTOP_VERSION_BOUNDARY_2026-10-25.md).

## Failure analysis and safe engineering interpretation
A program executes M8 and immediately begins a dusty cut; `settings->flood=true` and later HAL output TRUE are not proof that fan has spun up, local blast gate opened, hood is positioned, duct is intact or extraction is adequate. A queue-dependent request and remap are *ordinary sequencing mechanisms*, not a protective response time. An M9 or Task abort can also alter a shared shop collector if wired without ownership separation.

**INFERENCE:** use qualified selected LEV readiness/capture evidence and a separately justified cutting inhibit, physical guarding and collector fire protection. Do not create a magic delay from these source paths; lead/lag times, material-specific capture and response need site evidence. A protective stop cannot be delegated to queued G-code.

## Evidence
**SOURCE-CONFIRMED:** exact pinned interpreter remap, M8/M9 queue, canonical command, Task HAL path. **DOC-CONFIRMED:** LinuxCNC M-code reference. **TEST-CONFIRMED:** none. **UNKNOWN:** any selected HAL wiring, remap, collector state, actual latency, physical airflow, safety integrity and machine-specific restart. No lab justified: source answers the queue/remap distinction; actual capture/stop requires qualified physical evidence. No hosted/local compute dispatched.
