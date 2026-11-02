# TP-166 minimal G61/G61.1 trajectory comparison (NOT RUN)

Source: [TP-166](../../research/4400_LINUXCNC_TP_166_G61_G611_TANGENT_CONTINUITY_AND_INI_SOURCE_AUDIT_2026-11-02.md); [commissioning guide](../../guides/3100-3300-3400-3600-4000-linuxcnc-g61-exact-path-tangent-stop-commissioning-2026-11-02.md).

These three **standalone** G-code programs use identical 20 mm collinear paths, G21/G17/G90/G94/G40 and F600, differing only in the path mode. They are *not* a physical-machine script or a proof of a nonzero velocity. Run only in a qualified physically disconnected simulator. Record `[TRAJ] ARC_BLEND_ENABLE`, optimization depth, cycle time, limits, LinuxCNC SHA and junction velocity trace. The upstream `tests/interp/g6164` checks canonical emission, not realtime TP velocity. No experiment has been executed.

Expected source conditions: G61 EXACT can be promoted to TANGENT under enabled arc-blend and eligible geometry; G61.1 STOP blocks tangent promotion; G64 P0 Q0 remains CONTINUOUS. Do not assume every G61 trace is nonzero at X10 or that G61.1 is a safety stop. The same numeric path may be affected by the selected simulator acceleration and servo period.

Run A–H from the linked guide and retain raw evidence, exit codes and job metadata before claiming TEST-CONFIRMED.
