# 3100 Mills / VMCs — breadth foundation

Date: 2026-09-14
Status: **BREADTH PASS STARTED — SPINDLE/TOOLCHANGE AUTHORITY BASELINE ESTABLISHED**
Pinned LinuxCNC revision for source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

## Why 3100 now

3800 reached bounded public-source stops for full completion-feedback saw/feed recovery, and its generic locking-indexer transaction is now source-closed for the breadth pass. Under `WORK_SELECTION_POLICY.md`, 3100 is the best breadth rotation because it is still genuinely underdeveloped while representing the largest conventional LinuxCNC machine class and supplying reusable spindle, probing, toolchange, lube/coolant and production-HMI knowledge.

## Track decomposition

The first 3100 pass will separate at least these authorities:

1. **coordinated XYZ(/ABC) machining motion**;
2. **spindle speed command and at-speed readiness**;
3. **spindle phase/index feedback for synchronized operations**;
4. **spindle orientation/lock state for ATC or spindle-position-dependent operations**;
5. **tool selection, physical tool transfer and logical tool identity**;
6. **tool length/diameter data and active offsets**;
7. **probe command, probe result and probing validity**;
8. **coolant/lube/chip-management state**;
9. **fixture/pallet/auxiliary mechanism state**;
10. **operator/job/HMI authority and restart/recovery state**.

Do not collapse these into a generic `machine ready` bit.

## M6 — logical and physical toolchange boundaries

Pinned LinuxCNC documentation establishes several VMC-critical distinctions:

- `T` selects a tool/pocket; `M6` requests the change to the selected tool;
- after M6, the selected tool should be in the spindle and the old tool returned to the magazine when applicable;
- the spindle is stopped;
- LinuxCNC may execute configured axis movement as part of M6;
- tool length offset is **not** automatically changed by M6; G43 is separate;
- the toolchanger physical sequence must be implemented through HAL/ClassicLadder/remap or equivalent machine logic.

Preserve:

**tool selected != tool physically transferred != tool identity acknowledged != tool length offset active.**

This immediately carries forward the 3400 lesson: interrupted M6 recovery must reconcile physical spindle/magazine state and LinuxCNC logical tool state rather than blindly retrying a sequence.

## M19 spindle orientation — first source/documented VMC contract

Pinned M19 documentation gives a strong explicit request/ack/fault transaction:

`M19 R angle Q timeout P mode`

LinuxCNC exposes:

- `spindle.N.orient-angle` — requested orientation;
- `spindle.N.orient-mode` — direction/index-reference mode;
- `spindle.N.orient` — orientation request;
- `spindle.N.is-oriented` — completion acknowledgement;
- `spindle.N.orient-fault` — nonzero fault code aborts orientation;
- `spindle.N.locked` — asserted after successful orientation;
- spindle brake is also asserted after successful orientation.

The M19 Q word is an explicit timeout: if `is-oriented` does not become true within Q seconds, an error occurs. This contrasts with the native 3800 locking-indexer TP path, whose inspected physical-witness wait had no local timeout.

Pinned Task source contains a dedicated `WAITING_FOR_SPINDLE_ORIENTED` execution state, and canonical code supplies separate `ORIENT_SPINDLE()` and `WAIT_SPINDLE_ORIENT_COMPLETE()` operations. Orientation therefore participates in Task execution as a real completion gate rather than being merely a fire-and-forget HAL bit.

### Encoder requirements

Pinned docs separate orientation modes:

- modes 0/1/2 require spindle quadrature position/direction;
- modes 3/4/5 additionally reference an index signal before final orientation.

Therefore a speed-only VFD feedback path is insufficient for encoder-based spindle orientation unless the drive itself performs the orientation and supplies the required acknowledgement/fault contract.

## At-speed, synchronization and orientation are different properties

The earlier 3200 source work already established separation between spindle command, spindle synchronization/index feedback and `at-speed` readiness. 3100 adds a fourth VMC-specific state: **orientation/lock**.

A VMC architecture must not substitute one for another:

- `at-speed` says the spindle is ready at commanded rotational speed;
- index/phase position enables spindle-synchronized motion such as rigid tapping;
- `is-oriented/locked` says an M19 orientation transaction completed;
- none of these alone proves a toolchanger drawbar, carousel, arm or pot is physically safe.

## Rigid tapping boundary

Pinned G-code documentation defines G33.1 as a distinct rigid-tapping operation, while G84 is the conventional tapping canned cycle intended for a floating chuck/dwell behavior. This distinction matters in 3100 because a machine advertised as `tapping capable` may mean materially different spindle/feedback requirements.

The initial playbook rule is:

**rigid tapping is a spindle-synchronized motion problem; M19 is a spindle orientation transaction; neither substitutes for the other.**

A full 3100 source trace should reuse the already-understood spindle-sync TP path from 3200 rather than duplicate it, concentrating instead on mill/VMC integration and failure/recovery behavior.

## Toolchange + orientation authority model

For an orient-dependent automatic toolchanger, a defensible generic sequence is not simply `M19 -> M6`. The machine-specific contract must prove the required physical states, for example:

`spindle stopped -> orientation request -> orientation ack/lock -> Z/toolchange position -> magazine/arm state -> drawbar release proof -> physical transfer -> drawbar clamp proof -> magazine/arm clear -> logical tool-changed ack -> restore machining state`.

The exact order depends on the real ATC and must come from field/config evidence. M19 only solves the spindle-orientation subtransaction.

## Failure questions for the next pass

A production VMC study needs explicit answers to:

- what happens if `orient-fault` arrives after orient request;
- what state remains after M19 Q timeout;
- whether spindle lock/brake is released automatically by M3/M4/M5 and how the physical drive follows;
- what a real ATC does if drawbar release/clamp proof disagrees;
- whether tool identity is updated before or after the physical transfer is truly secure;
- whether a failed toolchange can leave `tool-in-spindle`, pocket occupancy and physical spindle contents contradictory;
- whether machine OFF/E-stop/abort neutralizes pneumatics or merely stops the program sequence;
- how probing/tool-setting results are invalidated after probe faults or interrupted measurement;
- how lube pressure/level and spindle chiller/coolant faults gate production.

## First adversarial review

1. **M6 completed, therefore G43 for the new tool is active.** False; M6 and tool-length-offset activation are separate.
2. **Spindle `at-speed` is true, therefore ATC spindle orientation is proven.** False.
3. **M19 succeeded, therefore drawbar/tool clamp is proven.** False; M19 proves its configured orientation transaction only.
4. **A speed-only VFD signal is enough for LinuxCNC quadrature/index orientation modes.** False.
5. **M19 waits forever like the inspected locking-indexer transaction.** False; M19 Q supplies an explicit orientation timeout.
6. **Rigid tapping and spindle orientation are the same feedback problem.** False; rigid tapping is spindle-synchronized motion, while M19 is angular orientation/lock transaction.
7. **Logical tool identity after an interrupted ATC cycle can be trusted without physical reconciliation.** Not safely as a generic rule.
8. **A single `machine ready` bit should hide spindle, tool, lube and fixture witnesses.** Poor architecture; separate evidence/authority surfaces are required for diagnosis and recovery.

Result: **8/8 boundary review passed.**

## Lab decision

No lab is justified yet. Native documentation/source already resolves the initial M6/M19 authority boundaries. Real VMC configurations and commissioning histories have higher information value now.

## Exact next work

3100-V1:

1. inspect at least two materially different real LinuxCNC mill/VMC implementations, preferably one umbrella/carousel/arm ATC and one simpler pneumatic/fixed-rack changer;
2. preserve commissioning chronology and actual failures, especially spindle orientation, drawbar proof, pocket/tool identity and restart recovery;
3. source-trace `iocontrol` / Task toolchange acknowledgements only where needed to resolve those real implementations, reusing the 3200/3400 toolchange work rather than duplicating it;
4. then trace probing/tool-setting authority and lube/coolant/spindle-readiness integration;
5. freeze a lab only for a concrete nonduplicate uncertainty exposed by a real VMC configuration.
