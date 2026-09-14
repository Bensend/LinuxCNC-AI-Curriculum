# 3200 Lathe / Turning Center — tool identity, offsets and compensation boundaries

Date: 2026-09-14
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Track: 3200 — Lathes / Turning Centers
Status: **DOCUMENTATION + CODE-NOTES SOURCE FLOW CONFIRMED**

## Purpose

Define the LinuxCNC tool-identity model a lathe/turret HMI and machine-specific toolchanger must preserve. The immediate goal is to avoid three common conflations:

1. tool number versus physical turret pocket;
2. selected/prepared tool versus actually loaded tool;
3. tool geometry/length offsets versus cutter-radius/nose compensation selection.

## Lathe-specific documentation

Pinned `docs/src/lathe/lathe-user.adoc` establishes that lathes use the common LinuxCNC tool-table format and adds lathe-specific geometry semantics:

- the table may describe tools in a changer or manually changed tools;
- X and Z tool offsets are normal lathe tool-table quantities;
- tool nose radius/orientation matter for the control point and cutter compensation;
- X tool touch-off is normally referenced to spindle centerline (diameter or radius according to mode);
- Z tool offsets are normally referenced to a stable machine fixture/reference surface, while workpiece Z remains a separate coordinate-system offset;
- G43 applies the current tool offset;
- CSS uses machine X origin modified by the tool X offset, so tool-offset identity also affects surface-speed calculation.

This already shows why a lathe HMI must not reduce “current tool” to one integer. Tool identity has consequences for geometry, control point and spindle-speed calculation.

## Nonrandom turret versus random changer

Pinned `docs/src/code/code-notes.adoc` describes LinuxCNC's two changer abstractions.

### Nonrandom changer

Lathe tool turrets are explicitly listed as an example of a **nonrandom** changer. A tool has a stable home pocket. On change, LinuxCNC copies the selected tool information into internal pocket 0, which represents the spindle/current loaded position. It does not rewrite the tool's home pocket in the tool table.

For a conventional fixed-station lathe turret this is usually the correct abstraction: station/pocket identity is stable, and selecting station N does not mean the tool has migrated to a different storage pocket.

### Random changer

A random changer swaps the spindle/current pocket-0 entry with the requested storage pocket and persists the resulting pocket locations. That model is appropriate for mechanisms where tools actually exchange storage positions.

### 3200 implication

Do not set `RANDOM_TOOLCHANGER` merely because the physical mechanism is circular. “Carousel-shaped” does not imply LinuxCNC's random-pocket semantics. A fixed-station lathe turret can be physically circular while still being logically nonrandom.

## Tool number versus pocket / tooldata index

The code notes distinguish:

- **tool number**: the programmer/user identity requested by `Txxx`;
- **pocket number**: hardware changer/storage location;
- **internal tooldata index**: the sequential internal record identity used by parts of Task/interpreter state.

The documentation warns that legacy variables named `selected_pocket` and `current_pocket` can actually contain a tooldata index, not the physical pocket number implied by the name.

This naming mismatch is important for custom remaps/HMIs. A UI or component should use the documented external tool/pocket signals rather than assuming every field containing “pocket” is a hardware station number.

## `Txxx` selection/preparation flow

`Txxx` selects the requested **tool number** and causes LinuxCNC to locate the corresponding tooldata record/pocket. The Canon/Task/IO path then publishes preparation information to HAL:

```text
Txxx
 -> Interp::convert_tool_select()
 -> SELECT_TOOL()
 -> EMC_TOOL_PREPARE
 -> Task / IO
 -> iocontrol.0.tool-prep-pocket
 -> iocontrol.0.tool-prep-number
 -> iocontrol.0.tool-prepare
 -> external changer prepares request
 -> iocontrol.0.tool-prepared
```

Selection/preparation does **not** mean the tool is already loaded/current.

For a turret that does no separate pre-stage, prep may be deliberately looped back, but that implementation choice must not erase the conceptual distinction between selected target and completed physical change.

## `M6` loaded-tool flow

`M6` asks the machine to perform the change to the previously selected tool.

The documented flow is:

```text
M6
 -> Interp::convert_tool_change()
 -> CHANGE_TOOL()
 -> EMC_TOOL_LOAD
 -> Task / IO
 -> iocontrol.0.tool-change = true
 -> external turret transaction
 -> iocontrol.0.tool-changed = true only after completion
 -> load_tool()
 -> update pocket 0 / current tool state
 -> update #5400-#5413 current-tool parameters
```

For a nonrandom turret, the tool record is copied from its stable home pocket to pocket 0. This means the **current loaded tool identity changes only on accepted change completion**, not merely when the programmer selected a new T number or the GUI displayed a target.

That aligns with the public carousel failure examined separately, where GUI/request state and physical changer state could diverge.

## G43 tool offsets are a separate authority

Changing/identifying the loaded tool and applying its offsets are separate operations.

Pinned code notes show `G43` obtains the current tool's tool-length/axis offsets (or an explicitly specified H tool), sends them through `EMC_TRAJ_SET_OFFSET`, and Motion uses them for subsequent commanded motion.

The lathe user guide likewise describes loading a tool with `Tn M6` and applying its current offsets with `G43`.

Therefore these should remain separately visible in a diagnostic/HMI model:

```text
selected tool
prepared target
physically completed/current tool
active tool offset
```

They are related, but they are not interchangeable state variables.

## D word: cutter compensation, not a second generic turret selector

A useful LinuxCNC-specific correction to generic lathe expectations is that the D word is associated with cutter-radius/nose compensation (`G41/G42` family), not a universal separate “wear register number” implicitly paired with a T code.

Pinned code notes say that when cutter compensation is enabled:

- if a D-word tool number is supplied, the interpreter looks up that specified tool's table record for compensation data;
- without D, it uses pocket 0/current spindle tool data.

Thus a custom HMI importing conventions from other commercial controls must not assume that a compact code such as `T0101` inherently means “turret 1 + wear offset 1” under native LinuxCNC semantics. LinuxCNC's native model is tool-table centric: T selects a tool, G43 applies axis offsets, and G41/G42/D control cutter/nose-radius compensation.

If a project wants commercial-controller-style paired geometry/wear register semantics, that is a remap/application-layer feature that must be specified and tested rather than assumed from native T-word parsing.

## M61 warning

`M61 Qn` changes LinuxCNC's internal current-tool representation without physically moving the changer. This is useful for initialization/reconciliation, but it is also a sharp diagnostic boundary:

**M61 can establish software tool identity; it does not prove physical turret position.**

A lathe startup/recovery sequence that uses M61 should obtain whatever physical station/lock evidence the actual turret requires before treating the software identity as reconciled.

## Tool geometry / compensation data relevant to lathes

At 3200 level, preserve at least these distinct concepts:

- tool number / logical identity;
- stable turret pocket/station for nonrandom changers;
- X tool offset relative to spindle centerline;
- Z tool offset relative to the chosen stable tool reference;
- nose/tool radius/diameter data as applicable;
- tool orientation/front/back angle data when used;
- current work coordinate offset;
- active G43 tool offset state;
- active cutter/nose compensation state and D selection when used.

A tool-table editor can display these in one row, but control ownership remains distinct.

## Recovery and HMI rules

A robust lathe HMI should distinguish at minimum:

```text
Requested/selected tool: T...
Prepared target/pocket: ...
Current LinuxCNC tool in spindle/turret: ...
Physical turret station witness: ...
Turret locked/clamped completion: ...
Active G43 offset identity/value: ...
Cutter/nose compensation: G40/G41/G42 + D source
```

On mismatch, do not “fix” physical state by silently changing only the software tool number. Reconcile the mechanical station and software identity deliberately.

## Evidence classification

| Claim | Classification | Evidence |
|---|---|---|
| Fixed-station lathe turrets are an example of LinuxCNC nonrandom changers | DOCUMENTATION CONFIRMED | pinned `code-notes.adoc` |
| Nonrandom change copies tool data to pocket 0 rather than moving the home pocket | DOCUMENTATION/SOURCE-FLOW CONFIRMED | pinned code notes |
| T selection/preparation is distinct from M6 change completion | DOCUMENTATION/SOURCE-FLOW CONFIRMED | pinned code notes + iocontrol flow |
| G43 active offsets are distinct from current-tool identity | DOCUMENTATION/SOURCE-FLOW CONFIRMED | pinned code notes + lathe user guide |
| D word is used by native cutter compensation tool lookup | DOCUMENTATION/SOURCE-FLOW CONFIRMED | pinned code notes |
| M61 proves physical turret position | REJECTED | M61 intentionally changes software current-tool identity without physical changer motion |
| Circular turret geometry means RANDOM_TOOLCHANGER must be enabled | REJECTED | LinuxCNC explicitly lists lathe turrets as nonrandom examples |

## 3200 teaching rule

Teach a lathe tool system as **multiple reconciled identities**, not a single T number:

`program tool identity -> changer target -> physical station/completion -> LinuxCNC current tool -> active geometry offset -> active nose compensation`

Every transition should have a defined owner and witness.