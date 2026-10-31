# 4000-LC-SPINDLE-23 — G33.1 rigid-tap reversal is detected from spindle position direction

**Session continuation:** 2026-10-31T04:31:53Z. **Status:** SOURCE-CONFIRMED static, DOC-CONFIRMED as marked, NON-GRADUATED; no runtime or physical motion. Follows [SPINDLE-22](4400_LINUXCNC_SPINDLE_22_MULTISPINDLE_ATSPEED_INDEX_HANDSHAKE_SOURCE_AUDIT_2026-10-31.md).

## Specific question

Does G33.1 wait for a spindle-at-speed acknowledgement at each reversal, or use measured spindle position to detect reversal? What happens to synchronization at the final return-to-start?

## Pinned source

- LinuxCNC development [24e84c4506b41634240f7087f0295e361a954886 src/emc/tp/tp.c](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/tp/tp.c), blob 2b4024c9ab131f708cc22760300231878c9b0fdc, tpUpdateRigidTapState lines 3125–3190; tpSyncPositionMode lines 3673–3810; tpRunCycle lines 4289–4360.
- Stable [v2.9.10 src/emc/tp/tp.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c), blob 5768d6e6880569f72156ed9a761b5eee531c9fcf, same relevant rigid-tap state transitions around lines 2510–2585.
- [interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_convert.cc), blob 379b21eaba65840ce4160e7ea70df60c12fad9ff, G33.1 lines 5826–5854; [emccanon.cc](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/emccanon.cc), blob 5ad736c59e85495aa06573ebcad2d49d59145583, RIGID_TAP lines 1245–1286.
- [control.c](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/control.c), blob 7c9a35c237ba05326372294587c33d53aff1a6a9, spindle output calculation around 2010–2056; [official G33.1 docs](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/gcode/g-code.adoc), blob 46386681cce284fa0cc43e27192bee0aca208766, lines 1311–1332.

## Interpreter and command path

**SOURCE-CONFIRMED:** G33.1 validates the selected spindle is commanded to turn, clamps optional I retract-speed multiplier below 1 to 1, checks pitch/axis limits at K times I, then calls START_SPEED_FEED_SYNCH with pitch K and RIGID_TAP with scale I. Canonical RIGID_TAP enqueues EMC_TRAJ_RIGID_TAP with endpoint, velocity, acceleration, jerk and scale; it deliberately does not change the canonical final endpoint because the tapping move returns to its start.

## Reversal state machine

**SOURCE-CONFIRMED in both inspected revisions:**

1. RIGIDTAP_START stores the signed spindle revolution sample in function-static old_spindlepos and enters TAPPING.
2. At tapping progress >= reversal_target, the TP negates the commanded spindle speed and multiplies by retract scale I; state becomes REVERSING.
3. REVERSING waits for **new_spindlepos < old_spindlepos** (a negative signed revolution increment), not for an at-speed flag or a measured zero-speed dwell. It then computes the return trajectory, stores the reversal revolution origin and enters RETRACTION. Signed position accounts for the spindle direction setting.
4. At retract progress >= reversal_target, it negates the command again and divides by I, entering FINAL_REVERSAL.
5. FINAL_REVERSAL waits for **new_spindlepos > old_spindlepos** (positive signed increment), constructs the final move back to the original start, then explicitly sets tc->synchronized=0, target_vel=maxvel and state FINAL_PLACEMENT. The final placement is **not spindle-synchronized**.
6. tpSyncPositionMode tracks spindle position during TAPPING/RETRACTION and uses the saved reversal origin in RETRACTION/FINAL_REVERSAL; after FINAL_PLACEMENT the ordinary segment planner completes the return.

**Implementation implication (INFERENCE):** a single qualifying signed position change is sufficient for the state machine's reversal transition. It does not require a stable reverse speed or a separate drive-reversed acknowledgement. A noisy or incorrectly signed revolution signal could therefore make the state transition at the wrong time; actual susceptibility depends on encoder and drive integration and was **not tested**. Conversely, if the position never changes in the expected direction, this function has no internal reversal timeout; separate controller faults, operator abort or watchdog behavior are outside this narrow source path.

The final placement decouples axis motion from spindle revolutions. Do not assume a rigid tap remains phase-locked all the way to the original start point. The intended machine consequence and mechanical clearance require a machine-specific, controlled verification; do not infer tool collision or breakage from source alone.

## Spindle output boundary

control.c uses the signed spindle speed request, clamps to configured positive/negative limits, publishes speed-out and direction pins from the resulting sign. Therefore the TP's sign flip is a command to the spindle drive through HAL, **not** proof that the motor has reversed. The reversal-state test uses encoder revolution feedback rather than spindle command sign.

## Practical review and falsifiers (NOT RUN)

- Trace the spindle.N.speed-out/forward/reverse pins to the drive, including negative-speed capability, direction reversal latency, brake, at-speed and actual encoder polarity.
- Record spindle.N.revs over each reversal and compare with commanded speed sign and actual spindle direction; do not substitute a command echo for measured reversal.
- Inspect the axis motion and synchronization flag through FINAL_REVERSAL and FINAL_PLACEMENT. A spindle-revs trace with no signed reversal should not satisfy the REVERSING predicate in this source.
- Falsify by inspecting a different revision with an explicit at-speed or timeout gate inside the rigid-tap reversal transitions, or by an independently recorded controlled runtime trace inconsistent with this state machine.

**Evidence:** interpreter and TP transitions SOURCE-CONFIRMED; G33.1 I and XY prepositioning semantics DOC-CONFIRMED; mechanical behavior, measured reversal time, encoder noise, following error and machine safety UNKNOWN; TEST-CONFIRMED none. No workflow, simulation, physical operation, compute or evaluator. Existing independent personnel-safety authority and G0/G1 HOLD unchanged.

**Next:** determine whether upstream rigid-tap tests cover delayed/absent encoder reversal and FINAL_PLACEMENT; if not, checkpoint the source-only gap and rotate to homing/index sequencing rather than inventing physical test evidence.
