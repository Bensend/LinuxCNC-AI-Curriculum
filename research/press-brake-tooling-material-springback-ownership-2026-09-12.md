# 3600 Press Brake — Tooling, Material, Bend-Allowance and Springback Ownership

Date: 2026-09-12
Status: DEPENDENCY-SAFE 3600 RESEARCH/SOURCE/DOCUMENTATION PASS

## Question

The existing 3600 integration outline separates imported geometry, BendStep/GaugePlan/TargetSet ownership, first-piece correction, pressure/crowning, and runtime authority. A remaining machine-domain question is where **tool geometry, material technology, bend allowance/deduction, nominal springback/overbend, and measured production correction** belong in that chain.

This pass asks what can be learned from public controller documentation and inspectable open-source sheet-metal calculation code without inventing a universal press-brake formula.

## Evidence inspected

### Commercial/controller documentation

- Cybelec VisiTouch MX User Manual V1.2 (May 2020), especially material technology and Bend Comp sections. Public PDF: https://cybelec.ch/wp-content/uploads/2020/12/UserManual_VisiTouch19_MX_V1x_EN.pdf
- Cybelec ModEva Pac product page: https://cybelec.ch/modeva-pac/
- Cybelec CybTouch 8P product page: https://cybelec.ch/cybtouch-8p/
- Delem DA-69T product page: https://www.delem.com/en/solutions/pressbrake-controls/da-60-series/da-69t

### Open-source calculation source

Pinned FreeCAD SheetMetal commit:

`db3f87556cf8930257b69096cabe00e660caa416`

Relevant files:

- `tools/README.md`
- `tools/calc-unfold.py`
- `SheetMetalNewUnfolder.py`
- `SheetMetalUnfoldCmd.py`

### Community evidence

- LinuxCNC forum, “For a full-fledged Press Brake GUI” (2026): https://forum.linuxcnc.org/41-guis/58222-for-a-full-fledged-press-brake-gui
- LinuxCNC forum, “Press Brake CNC Control & G-Code” (2017): https://www.forum.linuxcnc.org/30-cnc-machines/32171-press-brake-cnc-control-g-code

Community material is used only as field/workflow evidence, not as a formula oracle.

## Source findings

### 1. FreeCAD’s unfold calculation is geometric/material-model state, not machine motion state

`tools/calc-unfold.py` makes the boundary explicit. Its inputs are inner radius `r`, thickness `T`, mold-line distance `ML`, K-factor `K`, and bend angle. It computes neutral-axis offset `t = thickness * k_factor`, then bend allowance as the arc length of the neutral line:

```text
BA = 2*pi*(r + t)*(bend_angle/360)
```

It then derives leg/flange geometry from that bend allowance. There is no LinuxCNC axis command, hydraulic state, ram depth, force, crowning output, or physical feedback in this calculation.

`tools/README.md` likewise describes a flange/backgauge-style geometric relationship using mold-line distance plus a flange difference derived from unfold calculation, and it explicitly treats K-factor as an input whose value depends on material/bending conditions.

**Classification: SOURCE-CONFIRMED at the pinned FreeCAD commit.**

### 2. FreeCAD’s production unfolder carries bend geometry through a bend-allowance calculator

`SheetMetalNewUnfolder.py::unroll_cylinder()` obtains bend direction, physical bend radius, sheet thickness and bend angle from the model and calls `BendAllowanceCalculator.get_bend_allowance(...)`; the resulting bend allowance is then used to scale the flattened geometry. The calculator also normalizes K-factor standards: its `_convert_to_ansi_kfactor()` divides DIN-style K-factor by two before internal use.

This matters because even a seemingly simple `K` value has a **standard/provenance requirement**. A number without its convention is not a safe interchangeable process parameter.

**Classification: SOURCE-CONFIRMED at the pinned FreeCAD commit.**

## Commercial-controller findings

### 3. Material technology is richer than a single K-factor

The VisiTouch MX manual keeps material records and “bend technology materials” as explicit configuration. Its documented material technology includes at least:

- material identity;
- tensile strength/density data;
- an **Overbend Factor** used for nominal springback compensation;
- a **Correction Factor** used when mapping desired radius/material to die-width selection;
- bend-compensation modes/tables that may depend on material, thickness, punch radius and V width.

The manual’s springback example computes a nominal overbend from punch radius, thickness and an overbend factor. It separately describes die-width selection using a material correction factor and separately provides bend-compensation modes/tables.

Therefore these concepts are not one scalar “bend correction.” They serve different purposes and have different provenance.

**Classification: DOC-CONFIRMED for VisiTouch MX V1.2.**

### 4. Tooling selection is part of the nominal process model

The same VisiTouch manual describes punch/die assignment, preferred tools by machine/material/thickness combination, tool radius/geometry, and automatic tooling selection. ModEva Pac advertises automatic bend allowance plus hydraulic/mechanical crowning and pressure control. CybTouch 8P similarly lists bend allowance, punch-depth calculation, pressure/crowning calculation, angle correction and backgauge correction as distinct functions.

Delem DA-69T independently exposes product/tool memory, protractor correction, sensor bending/correction, thickness measurement/compensation, frame-deflection compensation and automatic process planning surfaces.

The independent product families therefore support the same ownership conclusion: **tool geometry, material technology, nominal calculation, sensed/measured correction and machine-axis execution are separate layers even when one commercial controller presents them in one UI.**

**Classification: DOC-CONFIRMED architecture/workflow evidence; implementation algorithms remain vendor-specific.**

## Community findings

A 2026 LinuxCNC press-brake GUI discussion reports a calibration workflow in which an angle is set slightly under target to leave first-piece adjustment room, followed by tweaking dimensions/bends and saving the job. An older LinuxCNC design discussion anticipated a library of tools plus widgets for tonnage and Y-stroke/angle calculations rather than treating raw axis positions as the operator’s primary programming surface.

These reports are consistent with the commercial-controller separation between nominal technology calculation and empirical production correction, but they do not establish formulas or tolerances.

**Classification: COMMUNITY-REPORTED.**

## Ownership contract

The 3600 playbook should preserve the following chain:

```text
PartGeometry / BendFeature
    + MaterialIdentity + MaterialRevision
    + ToolSetIdentity + ToolGeometryRevision
    + BendTechnologyRevision
        -> NominalBendModel
        -> NominalGeometryResult
        -> GaugePlan / nominal angle-radius intent
        -> machine-specific TargetCalculation
        -> TargetSet generation
        + EmpiricalCorrectionRevision
        -> Effective TargetSet
        -> ExecutionEpisode
        -> physical feedback / measured part result
```

Where:

### PartGeometry / BendFeature
Owns requested finished geometry and bend identity. It must not silently embed a machine-specific ram target.

### MaterialIdentity / MaterialRevision
Owns the selected material family/grade/technology record. Thickness belongs with measured/qualified material state, not merely the drawing label when production thickness compensation matters.

### ToolSetIdentity / ToolGeometryRevision
Owns punch/die IDs and geometry used by the nominal model. Changing a punch radius, die opening, orientation, holder/clamp stack, or equivalent geometry invalidates calculations that depend on it.

### BendTechnologyRevision
Owns the nominal process-model assumptions: K-factor convention/table, bend-deduction/allowance mode, nominal springback/overbend model, material-specific die/radius mapping, and similar technology data.

### NominalBendModel / NominalGeometryResult
Calculates geometric/process intent from part + material + tooling + technology. It is not yet realtime machine authority.

### Machine-specific TargetCalculation
Maps accepted geometric/process intent into machine coordinates/targets using machine calibration and kinematics. This is where machine geometry belongs; it should not overwrite the source bend intent.

### EmpiricalCorrectionRevision
Owns first-piece or qualified production offsets/corrections. It is deliberately separate from nominal material/tool technology so a measured local correction does not silently rewrite a general material model.

### Effective TargetSet
Is a generated, provenance-bound result. Any dependency revision change must create/invalidate the generation rather than silently mutating an already-authorized runtime target.

### ExecutionEpisode
Owns runtime authorization/command identity only. It must not become the database for tool/material technology.

## Invalid shortcuts / adversarial checks

The following are explicitly unsafe or architecturally unsound:

1. **“K = 0.4, therefore bend allowance is known.”** Invalid without K-factor convention, material/process context, radius/thickness and bend angle.
2. **“The DXF says 90 degrees, therefore command Y to the same stored depth every time.”** Invalid because finished angle intent, nominal springback model, tooling/material state, machine target calculation and empirical correction are separate.
3. **“First-piece angle correction should update the material’s global overbend factor automatically.”** Not justified. A local bend/job correction may reflect setup, thickness lot, tool wear, calibration or other causes. Promotion in scope requires evidence.
4. **“Changing the die does not matter if the requested finished angle is unchanged.”** Invalid. Public controller documentation explicitly uses die width/tooling in bend technology/compensation selection.
5. **“FreeCAD’s bend allowance tells LinuxCNC the ram depth.”** Invalid. The inspected source computes flattened sheet geometry; it does not model the target press’s ram/hydraulic process.
6. **“Commercial controllers calculate it, so there must be one universal formula worth copying.”** Invalid. VisiTouch itself exposes multiple bend-compensation modes plus material/tool tables, while open-source FreeCAD uses a geometric K-factor model for unfolding. These solve related but non-identical problems.
7. **“Measured angle feedback and nominal springback factor are the same state.”** Invalid. Delem exposes sensor bending/correction as a distinct interface, and Cybelec separates technology factors from production correction functions.

## Call/data-flow guide

A fresh implementation should be able to trace one BendStep as:

```text
requested bend geometry
 -> resolve material/thickness revision
 -> resolve punch/die/tool-stack revision
 -> resolve bend-technology revision
 -> compute nominal allowance/deduction/radius/springback intent
 -> choose/validate gauging surface and tooling feasibility
 -> machine-specific coordinate/target calculation
 -> apply explicitly scoped empirical correction
 -> mint new TargetSet generation with full dependency hashes/IDs
 -> operator/program accepts current generation
 -> mint ExecutionEpisode
 -> runtime ordinary-control authorization
 -> physical feedback + part measurement
 -> either accept bend or create a NEW correction revision/generation
```

No downstream step may silently rewrite an upstream dependency while retaining the same TargetSet generation.

## What this does NOT establish

This pass does **not** establish:

- a universal K-factor table;
- a universal springback formula;
- a universal punch-depth/Y target equation;
- actual target-machine tooling geometry or calibration;
- material-lot acceptance tolerances;
- closed-loop angle-sensor dynamics;
- required tonnage/pressure;
- safety-rated limits or safeguarding behavior.

Those remain machine/process-specific unless independently qualified.

## Information-gain decision

No new lab is justified for this question. The key ambiguity was ownership/provenance and the distinction between geometric unfolding, nominal bend technology, empirical correction and runtime motion. Public commercial documentation and inspectable open-source source code answer that boundary directly. A synthetic state fixture would mostly restate already-tested TargetSet-generation rules.

The next valuable domain question is narrower: **closed-loop/measured-angle bending**. Commercial controllers expose sensor-bending/correction interfaces, but this pass does not establish how a LinuxCNC implementation should represent angle-sensor freshness, generation, bend-phase validity, or correction authority. If F02 remains externally blocked, investigate that topic only if public implementation/source or sufficiently concrete controller documentation is available; otherwise record SOURCE UNAVAILABLE rather than inventing a loop.
