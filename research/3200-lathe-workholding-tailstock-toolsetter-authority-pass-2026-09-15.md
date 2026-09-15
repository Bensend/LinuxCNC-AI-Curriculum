# 3200 Lathe workholding / tailstock / toolsetter authority pass — 2026-09-15

## Scope

Breadth continuation from `checkpoints/3200-lathe-next-2026-09-14b.md`. This pass deliberately avoids reopening settled spindle-sync, G76, turret, CSS, and C-axis work. It targets the checkpoint's remaining chuck/collet/tailstock and lathe toolsetter authority gaps.

## 1. Hydraulic chuck / collet authority

LinuxCNC community implementations show that hydraulic chuck control is commonly built outside a native dedicated chuck transaction. A 2020 Takamatsu retrofit needed custom M10/M11-style behavior for a hydraulic chuck so a program could release the chuck, pull fresh bar stock with a gripper tool, and reclamp before continuing. LinuxCNC's suggested mechanism was user-defined/remapped M-code behavior rather than a built-in chuck cycle.

A later public `powerchuck` HAL component is stronger evidence about practical interlocks. Its author describes command inputs for chuck-in/chuck-out and cycle footpedal operation, with spindle brake and spindle-enable state used to prevent chuck actuation while the spindle is running; the author explicitly recommends feedback sensing where possible. This is useful field evidence, but it is not proof of a universal LinuxCNC chuck contract and the bounded public description does not establish a complete pressure/clamp-proof/restart transaction.

Separate community discussion about hydraulic-pressure control explicitly distinguishes desired chuck/tailstock pressure from mere valve command and raises the need to vary clamping force by program/material. That reinforces that a production workholding contract may need more than `open`/`close` bits.

### Durable workholding rule

`chuck close command != valve state != hydraulic pressure != jaw/collet clamped proof != workpiece retention != safe-to-spin authorization`.

For a production lathe, safe spindle authorization should be derived from the machine's actual workholding mechanism and available witnesses. A software command bit alone is not proof that the part is retained.

## 2. Tailstock authority and real machine diversity

A 2025 Feeler FTC-280 retrofit documents one OEM-style architecture where a hydraulic pump serves turret, tailstock, probe arm, parts catcher, and chuck. Its tailstock body is not simply an independent commanded W axis: the Z axis aligns with it, a hydraulic pin couples the tailstock to Z, and Z then drags the tailstock to the requested location. This is materially different from a servo/stepper quill.

Other LinuxCNC field examples do use a motorized tailstock as an axis. Community evidence also shows that choosing W as the tailstock coordinate can interact with trajectory features such as rigid tapping; one retrofit instead used another coordinate for a motorized quill because of those constraints.

A 2025 hydraulic-tailstock example uses two valves plus min/max proximity sensors and attempts the sequence `extend valve -> M66 wait for max witness -> valve off -> retract valve -> M66 wait for min witness -> valve off`. The report itself was troubleshooting an M66 behavior difference between program and MDI, so it should not be promoted as a proven production implementation. It is still useful evidence that physical end-state acknowledgement is the intended transaction rather than a blind dwell.

### Durable tailstock rule

Do not define one generic `tailstock axis` architecture. At least these classes exist:

1. independently positioned servo/stepper quill or body;
2. binary hydraulic extend/retract with end-state witnesses;
3. mechanically/hydraulically coupled body that borrows a machine axis for repositioning.

For each machine preserve separate ownership of `position request`, `coupling/clamp request`, `physical coupled/clamped witness`, `quill/body position witness`, `pressure/thrust readiness`, and `cycle continuation acknowledgement` where the hardware exposes them.

## 3. Lathe toolsetter: real four-face probe workflow

A long-running Cincinnati lathe tool-probe thread provides a concrete four-face toolsetter workflow. The later macro uses different approach directions for OD, ID, normal-Z and left-hand tools, performs a probe/backoff/reprobe sequence, applies calibrated fixed offsets from the trigger face to spindle centerline/reference geometry, and writes the measured X or Z geometry with `G10 L1 P#5400` for the current tool.

A 2023 revision of the same user's macro preserves this pattern and makes the four orientation classes explicit. This is strong field evidence for the geometry problem: a lathe setter is not just a single Z touch plate. Tool orientation determines which pad and approach direction are physically valid.

However, the shown community macros generally use `G38.2` directly and then consume `#5061/#5063`; they do not show the same explicit `#5070` validation discipline as the stronger pinned upstream `qt_auto_probe_tool.ngc` reference.

Pinned upstream LinuxCNC `qt_auto_probe_tool.ngc` performs initial safety checks, coarse `G38.2`, backoff, explicit `#5070` success check, fine `G38.2`, a second `#5070` check, calibrated offset calculation, `G10 L1` persistent tool-table update, then `G43` activation. Although this reference is mill-oriented, the probe-validity and persistence distinctions are generic interpreter semantics and therefore transfer to a lathe toolsetter implementation.

### Durable lathe toolsetter contract

A robust lathe setter should separate:

- expected tool identity and tool orientation/class;
- setter input initial state (not already tripped);
- valid approach direction and bounded travel;
- coarse contact event;
- release/backoff proof;
- fine contact event;
- `#5070` success validation for each required probe;
- calibrated pad geometry relative to spindle centerline / machine reference;
- calculated X/Z tool geometry;
- persistent tool-table write (`G10 L1` when persistence is intended);
- active-offset refresh/application as required by the running interpreter state;
- failure/retract/recovery state.

`probe coordinate != valid probe event != calibrated tool geometry != persistent tool-table value != active motion offset`.

## 4. Diameter/radius and reference-frame hazard

LinuxCNC lathe field history shows repeated operator confusion between G7 diameter mode and G8 radius mode and between work-coordinate touch-off and tool-table touch-off. Community guidance emphasizes that the reference tool establishes the work coordinate while other tool lengths/offsets are relative to that reference, and that the entered X value must match the active radius/diameter convention.

Therefore a production lathe toolsetter/HMI should expose or enforce the active G7/G8 convention and make it explicit whether an operation is changing the work coordinate system or persistent tool geometry. Silent mixing of those authorities is a commissioning and scrap hazard.

## 5. Failure/recovery conclusions

The public evidence is sufficient to freeze the following design constraints without a lab:

1. Chuck/collet actuation must not be inferred safe from command state alone.
2. Tailstock implementations are mechanically diverse; copy the actual mechanism, not a generic axis abstraction.
3. End-state sensors should acknowledge hydraulic tailstock motion when present; dwell-only completion is weaker evidence.
4. Lathe toolsetter geometry is orientation-specific and may require four directional contact faces.
5. Every required G38 contact should be treated as a transaction with explicit success validation before consuming probe coordinates.
6. Persistent tool-table update and active offset application are distinct state changes.
7. Already-tripped input, no-trip, wrong tool identity/orientation, wrong G7/G8 convention, stale calibration and interrupted probe motion are separate failure classes.

## Evidence quality / remaining gaps

Strongest evidence in this pass:

- pinned upstream LinuxCNC probe/remap semantics;
- multi-year field evolution of a real Cincinnati four-face lathe toolsetter macro;
- real Feeler hydraulic tailstock mechanical description;
- public powerchuck implementation description and hydraulic tailstock sensor sequence.

Remaining source-thin area: a fully inspectable production hydraulic chuck/collet implementation with independent clamp/pressure proof, spindle permissive, request generation, timeout and abort/restart reconciliation. Reopen only if such a configuration becomes available; do not manufacture a synthetic chuck lab merely to fill this gap.

## Promotion decision

This closes the highest-value remaining 3200 workholding/toolsetter breadth questions sufficiently for branch rotation. 3200 remains OPEN / PAUSED, not graduated.
