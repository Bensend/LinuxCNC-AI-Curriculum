# 4000 LinuxCNC implementation handoff — G64 P/Q and CAD/CAM-generated paths
**2026-10-30 | Practical source-grounded review card | NOT a certified postprocessor or validated machine program**

Primary evidence: [G64 Q canonical/multi-turn source audit](../research/4400_LINUXCNC_G64_Q_NAIVECAM_MULTI_TURN_DXF_POST_SOURCE_AUDIT_2026-10-30.md); predecessor [G64 rapid-corner audit](../research/4400_PATH_BLEND_01_LINUXCNC_2910_G64_G0_CLEARANCE_AND_STOP_MODE_SOURCE_AUDIT_2026-10-28.md); [shared DXF/CAM discovery](../research/shared-dxf-cad-cam-discovery-2026-09-14.md).

## Separate the four contracts
1. **Source geometry:** DXF/SVG/CAD modelspace units, OCS/block transforms, bulge/arc/ellipse/spline approximation, closed loops, winding, part and feature IDs. This is geometric evidence, not bend/cut intent.
2. **CAM/nesting:** transforms and placements, kerf/tool compensation ownership, leads, holes, multi-turn helices, process sequencing, material/recipe references and collision assumptions. Preserve original and normalized geometry plus tolerance provenance.
3. **G-code interpreter/canonical:** modal G17/G18/G19, G20/G21, G90/G91, G61/G61.1/G64 P/Q, G2/G3 turn count P, tool offsets and any M62/M63 process synchronization. `G64 Q` may replace many G1s or a small-projection G17 arc **before** realtime TP. G0 does not go through the same naive-CAM G1 merger.
4. **Realtime/physical machine:** TP corner blending (P), following error, axis dynamics, machine envelope, real tool/stock, independent safety system. A preview or canonical command is not measured clearance or a protective stop.

## Review before accepting a CAM post
- Record **exact LinuxCNC revision** and explicit modal preamble, including units/plane/path-control. Do not rely on devel-only INI defaults or `G64 R` on v2.9.10.
- For every G2/G3 multi-turn or small-pitch helix, **preserve turn count and 3D pitch**. Evaluate the Q>0 shortcut against source; consider `Q0` for the feature and restore the chosen mode after. Do not assume this workaround is a machine-validation substitute.
- Compare original DXF/CAM feature topology with **canonical emitted motion types and endpoints**. Segment count and active line tags can change when Q merges G1 points. Compare at a specified tolerance in consistent units, and retain part/feature identity for diagnosis.
- Check M62/M63 or process-state boundaries explicitly; source shows canonical flush on motion-output commands, but does not establish torch/laser physical timing or protective behavior.
- Distinguish a verified rapid clearance plane from planned G0 corner blending; do not assume a Z-then-XY rapid visits the programmed corner under G64.
- Keep operator confirmation for ambiguous bend lines, gauging faces, thickness/K-factor and tool/material selection. Do not infer manufacturing intent from DXF color/dash/layer alone.
- For QtPlasmaC, separately verify M190/material and M3/M5/THC post semantics against the **installed** configuration; this card does not approve any generated plasma program.

## Source-grounded discriminators
- **Why can `G64 P0.005` simplify G1s without an explicit Q?** Stable interpreter sets omitted Q=P when P is supplied.
- **Why can an arc with P15 turns be replaced?** `arc_data_ijk` retains signed turn count; canonical `chord_deviation` uses only rotation sign and XY endpoint sweep in its Q decision.
- **Why might the GUI show a later line than the original CAM segment?** `flush_segments` emits one linear move with the last queued line/tag; exact UI behavior remains version/config dependent.
- **Why does `G0` not fix clearance?** It flushes naive-CAM points but is separately subject to TP G64 blending.
- **What is still unknown?** Physical path accuracy, actual cutter clearance, multi-turn reproduction on a selected machine, material/process timing, and functional safety.

## Minimal nonhazardous verification contract (only if justified)
Freeze two **software-only, physically isolated** canonical-output cases at the same LinuxCNC SHA: a G17 multi-turn helix with Q>0 and with Q0; compare canonical arc/line message types, end Z and turn metadata, not a screenshot alone. Optionally compare G18 and a G1/M62/G1 boundary. Precommit predictions and accept raw traces. No self-hosted runner dispatch until the local panel PC is proven isolated from machine actuation. **No runtime tests were conducted in this study.**

## Next implementation study
Trace an actual QtPlasmaC material/process post path (`M190`, `M3/M5`, THC inhibit) from official docs into the installed-style LinuxCNC configuration and source. Alternatively trace DXF bulge/INSERT normalization through an inspectable open-source parser. Pick only one unresolved, source-verifiable question; do not turn the curriculum into a compulsory CAM product.
