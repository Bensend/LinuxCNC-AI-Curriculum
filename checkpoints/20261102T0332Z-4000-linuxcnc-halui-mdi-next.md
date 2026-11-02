# 2026-11-02 ~03:32Z — HALUI-MDI-145 panel transaction / Task completion checkpoint

**Active: 4000 LinuxCNC implementation; 3100/3200/3300/3400/3600 machine transfer. NON-GRADUATED. LinuxCNC FIRST.**

## Completed and provenance

- [HALUI-MDI-145 source investigation](../research/4400_LINUXCNC_HALUI_MDI_145_PANEL_TASK_ECHO_MODE_RESTORE_SOURCE_AUDIT_2026-11-02.md) traces stable v2.9.10 HALUI blob `6aa5187`, Task blob `7292a17`, development `06864e23559e` HALUI blob `c40e283`, official HALUI manuals, and the actual `halui_pyvcp` simulation INI/HAL.
- [Practical panel/MDI acceptance walkthrough](../guides/3100-3400-4000-linuxcnc-halui-mdi-panel-transaction-commissioning-2026-11-02.md) gives an existing upstream sim config, no-motion G4 replacement, eight discriminating cases and status instrumentation.
- Predecessors OT-SEC-01 (HALUI NML echo), PEDAL-02 (rising-edge run), ROS-45 (Python status) explicitly credited; incremental evidence is MDI-specific prior-mode restore, Task queue/global DONE, development early running pin and source-vs-doc MANUAL wording.
- **SOURCE/DOC-CONFIRMED:** echo is not execution; dev running pin asserts before mode switch/MDI submit; stable lacks this pin; Task checks homing and MDI mode; HALUI restores saved MANUAL/AUTO/MDI on global DONE. **INFERENCE:** A–H event sequences. **TEST-CONFIRMED none**; no new build, HAL, Task, GUI, simulation, physical machine, independent evaluator or Actions compute. Hosted/self-hosted 0/0 min; compute and feedback ledgers unchanged.

## Precise next work selection

1. **First preference when qualified isolated compute exists:** execute previously frozen [MOTION-144 fake-drive fault/re-enable](../research/4400_LINUXCNC_MOTION_144_AMP_FAULT_REENABLE_ONE_SERVO_ENABLE_PULSE_SOURCE_AUDIT_2026-11-02.md) A–F on a positively qualified **physically disconnected** runner labeled both `[self-hosted, openpressbrake]`. Capture per-servo internal enable/fault flags, `amp-enable-out`, function order, actual job start/end and exit status. Do not dispatch hosted runners or connect real actuators. Next ECAT-ENC-143 fake PDO if a harness can isolate driver.
2. If qualified compute remains unavailable, use the **existing upstream `halui_pyvcp` sim** only as a future qualified-run acceptance target; do not manufacture another unrun fixture. Rotate immediately to a distinct high-value LinuxCNC source/config topic (e.g. interpreter/Task MDI error-channel correlation or an undercovered machine configuration), **after** full PROGRESS/LESSON_LOG/lab predecessor check.
3. If HALUI testing becomes justified, execute guide cases A–H on both pinned versions; preserve raw NML serial/status and Task error records, not only a screenshot of the running pin. Distinguish command echo, queue, Task global DONE and actual operation effect. Inspect upstream tests/historical results before claiming new runtime verification.
4. Preserve graduated 1000/2000/F02/3000 levels, independent blind-evaluator separation and personnel-safety authority, OpenPressBrake G0/G1 HOLD and current hourly curriculum. No changes to safety-course gates.

**Readiness:** Two new substantive Markdown artifacts plus this checkpoint, PROGRESS and LESSON_LOG are to be committed and read back. All new relative links must resolve. No external compute was requested; no new lab runtime to log.
