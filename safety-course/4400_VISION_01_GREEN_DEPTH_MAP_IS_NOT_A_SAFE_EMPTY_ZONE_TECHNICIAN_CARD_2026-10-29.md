# 4400-VISION-01 — A green 3D picture is not a safe, empty work zone
**2026-10-29 | Practical technician field card | PAPER REVIEW ONLY / UNSCORED**

**Use with:** [Original SICK safeVisionary2 OEM source audit](../research/4400_VISION_01_SICK_SAFE_VISIONARY2_3D_DEPTH_TELEMETRY_VS_SAFETY_FIELD_AND_RESET_OEM_AUDIT_2026-10-29.md), 2520 safety-function definition, 2590 guards, existing scanner/light-curtain and restart lessons. This is a **new camera-specific mechanism**, not an independent evaluation or selected-machine installation instruction.

## Five-minute walk-through
A camera displays a detailed, apparently empty 3D scene on a LinuxCNC HMI. The operator can see machine tooling and a clear floor. **That display is ordinary monitoring.** It is not evidence that a person cannot be behind a fixture, below a field, outside the protective aperture, or still in the hazard after the field clears. A manufacturer safety-oriented 3D sensor may separately evaluate configured protective fields and drive qualified safety outputs, but its device rating does not automatically rate the machine.

**Keep the four layers distinct:** (1) HMI/AI point-cloud interpretation for convenience; (2) independent safety-related protective-field and reset/EDM evaluation; (3) physical stop, isolation and gravity-load holding elements; (4) qualified real-machine validation. LinuxCNC/FPGA may observe status and request ordinary stops, not grant its own personnel-safety permission.

## Technician scenarios — do not self-score as blind competency
1. **Green point cloud, blocked view.** A pallet hides the inside of a robot cell. The camera says clear. What physical guard/second protective field and test-object walk-through would establish the blind-zone boundary?
2. **False-trip shortcut.** A camera trips in sunlight or vibration. Someone proposes widening the contour tolerance and using the ordinary video feed as the safety backup. Which part of the OEM p.69 warning makes this unsafe? Fix environment/mounting and validate the detection boundary instead of bypassing it.
3. **Network shortcut.** A controller receives UDP depth data, or the camera's `safe mode` UDP stream. What additional end-to-end integrity, freshness, diagnostics, safe receiver, output and physical stopping proof is missing? Do not treat a checksum, Ethernet link LED or AI confidence as a safety certification.
4. **Nuisance-stop tuning.** An installer changes multiple sampling from 2 to 8. The SICK manual gives 89 ms and 293 ms **sensor response** respectively: **+204 ms**. Why must the selected safety distance be revisited using real machine stop time, and why can no generic distance be asserted?
5. **Rearm trap.** A worker steps out of the camera field but remains beside the hazard. The OSSD turns ON and a queued CNC command resumes. Require a field/guard design that prevents unseen occupancy, visible deliberate reset, separate new start and qualified final-element verification.

## Low-friction safe default
Start with fixed or easily reinstalled hinged guarding, simple independently monitored devices and a reset with full hazard visibility. Add 3D safety sensing only where an exact device/function, field geometry, receiver and physical validation make it useful. Do not solve inconvenient nuisance trips by weakening protection or switching to normal video/AI software.

**Release status:** This is an unscored teaching card. No camera has been selected for OpenPressBrake; no physical test, stopping distance, PL calculation or personnel-protective permission is established. **G0/G1 HOLD; no personnel-exposed hazardous operation.** Isolated/remote experimental work, if later approved, must keep people outside the danger zone and state residual risk.
