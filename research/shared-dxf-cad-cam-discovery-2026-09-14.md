# Shared DXF / CAD / CAM open-source discovery

Date: 2026-09-14
Status: DISCOVERY / CROSS-TRACK RESEARCH TARGET

## Purpose

Build practical AI familiarity with open-source CAD/CAM software and libraries that read, write, manipulate, display, unfold, nest and convert DXF geometry. This is shared enabling knowledge for:

- 3300 plasma nesting and QtPlasmaC-oriented G-code generation;
- 3400 router/woodworking CAM and nesting research;
- 3600 press-brake DXF-assisted bend-program work;
- future LinuxCNC UI/CAM integration research.

The goal is not to build a production CAD/CAM system inside the curriculum. The goal is to understand proven open-source implementations, APIs, geometry models and process/post boundaries deeply enough that a later implementation project can reuse them. Small bounded prototypes are allowed only when they answer a specific learning question.

## Priority discovery targets

### ezdxf

Study as the primary programmatic DXF ingestion/manipulation library: entities, layers, linetypes, BLOCK/INSERT transforms, units, polylines/bulges, splines, contour extraction, cleanup, round-trip preservation and malformed/legacy DXF handling.

### FreeCAD + SheetMetal + CAM

Study DXF import/export, Python/headless automation, SheetMetal unfold/bend-mark representation, K-factor/material data, CAM jobs/operations/tool controllers and LinuxCNC postprocessing. Determine what bend semantics survive a DXF export and what requires richer model data.

### LibreCAD

Study mature 2D DXF editing, layer/linetype conventions, blocks, round-trip preservation and how real drawings use DXF metadata to communicate manufacturing intent.

### SolveSpace

Study constrained/parametric geometry and compact DXF export architecture.

### CadZinho

Study a lightweight DXF-native CAD architecture with scripting/custom-tool support and G-code export.

### ivaCAM / dxf2gcode / similar open CAM

Study DXF/SVG-to-G-code operation models, profiles, pockets, drilling, contour ordering, compensation, lead-ins and LinuxCNC-compatible post behavior. Evaluate maturity and geometry robustness rather than assuming any one project is canonical.

### Deepnest / deepnest-next / related nesting engines

Study irregular 2D nesting, spacing, rotations, common-line opportunities, hole/island handling, part identity and transforms. Prefer callable/offline engine boundaries over GUI automation.

## Shared DXF concepts the AI must learn

1. DXF version and units.
2. Modelspace versus paperspace.
3. WCS/OCS/UCS and entity transforms.
4. LINE, ARC, CIRCLE, POLYLINE/LWPOLYLINE, SPLINE and ELLIPSE handling.
5. Polyline bulge representation.
6. Closed-contour detection and tolerance policy.
7. BLOCK/INSERT transforms and attributes.
8. Layers, line types, colors and naming conventions as metadata carriers.
9. Cleanup of duplicates, gaps, tiny segments and self-intersections.
10. Stable part/feature identity across import, normalize, nest, unfold and re-export.
11. Preserve UNKNOWN metadata rather than silently discarding it.
12. Separate geometric evidence from manufacturing semantics.
13. Round-trip testing: read -> normalize/edit -> write -> re-read -> compare.

## Plasma-specific learning goals

The user's plasma table should eventually be able to take part geometry through nesting and QtPlasmaC-compatible G-code generation from the LinuxCNC-side workflow. 3300 should study how to achieve that without making a production implementation part of curriculum graduation.

Study:

- DXF/SVG import and contour cleanup;
- automatic and manual nesting on sheet stock;
- part quantity, rotation constraints, remnants and sheet inventory concepts;
- inside/outside contour classification and cut ordering;
- kerf compensation ownership and direction;
- lead-in/lead-out placement;
- pierce points and pierce sequencing;
- small-hole treatment, velocity reduction and overcut where appropriate;
- tabs/bridges where used;
- material/recipe selection and how QtPlasmaC M190/material authority interacts with the CAM post;
- M3/M5, THC inhibit, velocity reduction and other QtPlasmaC post semantics;
- preview and final G-code handoff to LinuxCNC;
- preservation of part/nest identity for recovery and remnant tracking.

LinuxCNC's current plasma primer explicitly treats CAM/postprocessing as the bridge into QtPlasmaC, while a 2026 LinuxCNC community effort attempted an integrated QtPlasmaC CAD/CAM/nesting workflow. That forum project is useful as a design/UX case study, but its linked repository was no longer discoverable during this survey, so do not treat it as inspectable source evidence unless a surviving mirror is found.

Deepnest is a strong current nesting candidate because the maintained community fork explicitly targets laser/plasma/other CNC and supports DXF through conversion. Also preserve the older LinuxCNC community line of investigation combining LibreCAD -> Deepnest -> DXF-to-G-code -> QtPlasmaC, including work on plasma-specific dxf2gcode enhancements.

## Router/woodworking-specific learning goals

Study geometry import/cleanup, nesting, profile/pocket/drill feature creation, tabs, tool libraries, feeds/speeds, LinuxCNC posts, preview handoff and future drill-bank/aggregate/vacuum metadata.

## Press-brake-specific learning goals

Study outer flat contours, internal cutouts, bend/fold lines, bend direction indicators, angle labels/metadata, layer/linetype/color conventions, material/thickness/K-factor provenance, bend identity, gauging geometry and transforms between folded model, flat pattern and DXF coordinates.

Never infer that a dashed line or a particular layer is automatically a bend. DXF geometry is evidence; bend semantics require a documented convention, a richer source model or human confirmation when ambiguous.

## Prototype policy

Permitted learning experiments include:

- parse and round-trip synthetic DXF with ezdxf;
- inspect FreeCAD SheetMetal DXF bend marks programmatically;
- run a small nesting engine on a few 2D parts and preserve transforms/identity;
- generate one minimal LinuxCNC/QtPlasmaC-oriented G-code file from a nested part set;
- compare generated contour order, kerf/lead-in and material-selection semantics against QtPlasmaC expectations.

Stop each prototype when its learning question is answered. Do not expand it into the production CAM/nesting application inside the curriculum.
