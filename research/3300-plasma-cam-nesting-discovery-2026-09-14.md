# 3300 Plasma — integrated CAM / nesting discovery

Date: 2026-09-14
Status: DISCOVERY / FUTURE-IMPLEMENTATION KNOWLEDGE

## Goal

Study enough open-source CAD, DXF, nesting and CAM architecture that a future LinuxCNC/QtPlasmaC UI project could let the operator import parts, nest them on sheet stock and generate QtPlasmaC-compatible G-code directly at the machine.

This is a curriculum research topic, not a requirement to build a production CAM package during 3300. Small bounded prototypes may be used only to teach the AI an architectural or geometry concept.

Shared foundation: `research/shared-dxf-cad-cam-discovery-2026-09-14.md`.

## Evidence and precedents

- LinuxCNC's plasma primer explicitly places CAM/postprocessing between CAD and plasma execution and discusses QtPlasmaC-compatible posts.
- Deepnest/deepnest-next is an open-source nesting family aimed at laser/plasma/other CNC and is a primary candidate for nesting-algorithm study.
- LinuxCNC community work has previously explored a LibreCAD -> Deepnest -> plasma-aware DXF-to-G-code -> QtPlasmaC pipeline and plasma enhancements to dxf2gcode.
- A February–March 2026 LinuxCNC forum project attempted CAD/CAM directly inside QtPlasmaC, including interactive nesting, one-degree part rotation, kerf calibration, image-to-DXF experiments and successful first cuts. The GitHub repository linked in that thread was no longer discoverable during this survey, so preserve the forum chronology as UX/architecture evidence rather than source-level authority unless a mirror is found.

## Study targets

1. DXF/SVG geometry import and cleanup.
2. Automatic and manual nesting, part quantities and rotation constraints.
3. Stock/sheet/remnant representation and part identity after transforms.
4. Internal/external contour classification and cut ordering.
5. Kerf compensation ownership and cut direction.
6. Lead-in/lead-out placement and pierce-point selection.
7. Small-hole processing, velocity reduction and overcut semantics.
8. Tabs/bridges where useful.
9. Material selection and recipe provenance.
10. QtPlasmaC post semantics including M190/material selection, M3/M5, THC inhibit and velocity reduction.
11. Preview and final inspectable G-code handoff to LinuxCNC.
12. Recovery/remnant bookkeeping without making CAM state part of realtime machine authority.

## Architecture to understand

Preferred future pattern to study:

`QtVCP/QtPlasmaC operator surface -> DXF geometry layer -> nesting engine -> plasma CAM/toolpath layer -> QtPlasmaC post -> preview/load`

The geometry, nesting and CAM layers should remain ordinary userspace planning. LinuxCNC realtime/process control remains authoritative once the generated program is loaded.

## Candidate learning prototypes

Only when they answer a specific question:

- nest several simple DXF parts and preserve part identity/transforms;
- classify internal/external contours and generate ordered cut paths;
- generate one QtPlasmaC-compatible G-code sample from a small nested sheet;
- compare material-authority strategies: CAM-generated temporary material versus selecting an existing QtPlasmaC material number;
- verify lead-in/kerf/hole handling against QtPlasmaC post requirements.

Do not continue from prototype to product during curriculum work.
