# 3100 — real toolsetter / probing + readiness audit — 2026-09-15

## Scope

Breadth-first 3100-V3 follow-up. Inspected a real public LinuxCNC mill configuration at pinned repository revision `SebastianMusser/LinuxCNC@5e4ec8160d8d9e2af0ad7d82e1d5fd93ec8f8cc5`, plus its field report, to test the course's toolsetter/probe authority model and begin production-readiness inspection.

Evidence labels follow `SOURCE_POLICY.md`.

## Real configuration: SebastianMusser/LinuxCNC

### Toolsetter macro execution path

`subroutines/toolsetter_wco.ngc` performs:

`M6 -> cancel G92/feed override/tool compensation -> G53 safe Z -> G53 toolsetter XY -> fast G38.2 Z- -> #5070 failure check -> retract -> optional slow G38.2 -> compute touch result -> G10 L2 current-WCO Z write -> move away -> operator dust-boot pause -> restore feed override`.

SOURCE-CONFIRMED observations:

- It is a real double-touch implementation when slow-probe feed is nonzero.
- The first G38.2 is followed by an explicit `#5070` failure branch that returns to the starting Z and exits.
- The optional second G38.2 is **not followed by a second explicit `#5070` check** before `#5063` is used for offset calculation. Because G38.2 itself is an error-on-failure probing mode, interpreter failure should prevent ordinary continuation, but the macro's explicit validity treatment is asymmetric.
- The macro writes a **work coordinate offset** with `G10 L2`, not a persistent tool-length entry with `G10 L1`. Its stated purpose is to make the newly loaded tool define Z=0 in the current WCO. This is therefore not evidence for a production persistent tool-table calibration workflow.
- It cancels G92 and G49 before measurement. That makes coordinate-state ownership explicit, but also means callers must understand that these modal states are deliberately changed.

### Probe/toolsetter electrical authority

`my_LinuxCNC_machine.hal` combines a 3D probe input and fixed toolsetter input through an OR gate, passes the result through `debounce`, and feeds the single result to `motion.probe-input`.

The repository field chronology is unusually useful: a July 2025 LinuxCNC forum report from the same machine/config described `probe tripped during non-probe movement` while manually testing the toolsetter. The posted configuration ORed probe + TLS directly. The author later reported the issue solved with debouncing. The pinned repository now contains `debounce cfg=1`, delay 3, with the OR result routed through the debounce output to `motion.probe-input`.

COMMUNITY-REPORTED + SOURCE-CONFIRMED chronology:

`separate physical probe/TLS inputs -> logical OR -> nuisance/false transition observed in commissioning -> debounce inserted -> combined debounced probe witness -> motion.probe-input`.

Important boundary: debouncing improves transition quality; it does **not** identify which of the two sensors caused the combined probe signal. A stuck/tripped 3D probe can therefore still affect a toolsetter cycle unless higher-level logic verifies the expected initial electrical state/source. The inspected toolsetter macro contains no source-specific initial-state qualification before its first G38.2.

### ATC physical proof already present

The same HAL exposes separate `toolclamped-in` and `toolreleased-in` signals on `motion.digital-in-10/11`. This is stronger physical acknowledgement than dwell-only drawbar assumptions, though a complete interrupted-M6 recovery trace was outside this pass.

### Spindle/VFD readiness

`custom.hal` connects a userspace `vfdmod` driver as:

`spindle speed command -> vfdmod.rpm-in`

`vfdmod.rpm-out -> spindle.0.speed-in`

`vfdmod.at-speed -> spindle.0.at-speed`

plus forward/reverse run commands.

SOURCE-CONFIRMED: this machine uses a real VFD-derived at-speed witness rather than simply forcing spindle-at-speed true. This is evidence that readiness status is available and actually connected to LinuxCNC spindle readiness. It does not by itself prove safety-rated spindle state, braking, orientation, or drive fault authority.

## Architecture lessons

1. **Probe electrical validity and probe coordinate validity are separate.** `#5070` answers whether the requested probe transition completed; it does not prove the sensor chain is healthy, source-selective, or fresh before the move.
2. **OR-combining probe devices trades wiring simplicity for source ambiguity.** Debounce fixes chatter/glitches, not identity.
3. **Double-touch is not automatically persistent tool calibration.** This real macro double-touches but writes the current WCO with `G10 L2`; a production tool-table workflow must be evaluated separately.
4. **A fixed toolsetter workflow needs explicit ownership of coordinate state.** Machine coordinates for approach, active WCO for result interpretation, G92 state, active tool compensation, and setter calibration are distinct.
5. **Readiness surface != safety authority.** A VFD at-speed signal can legitimately gate cutting motion while still not being a safety-rated witness.

## Adversarial checks

1. If the slow touch fails, may code blindly use a successful first-touch value? **Not normally through G38.2 interpreter failure, but the macro lacks a symmetric explicit second `#5070` branch; do not teach the explicit check as present.**
2. Does the debounce tell LinuxCNC whether the probe or TLS fired? **No.**
3. Does `G10 L2` establish a persistent tool-length table value? **No; it writes coordinate-system offsets.**
4. Does `vfdmod.at-speed` prove spindle orientation or STO? **No.**
5. Can a sensor be electrically stable but wrong/stuck? **Yes; debounce does not establish semantic validity.**

5/5 boundary checks pass.

## Evidence-gain / lab decision

No lab is justified yet. The strongest uncertainty exposed here is not native G38 semantics but machine-specific initial-state/source qualification when multiple probe devices share `motion.probe-input`. A synthetic test would add little until a production macro/config claims to distinguish those states.

## Next evidence target

Continue 3100 with one persistent tool-table calibration implementation (`G10 L1`/equivalent) that has explicit initial-state checks and failure recovery if inspectable. In parallel inspect lube/coolant/chiller/chip/fixture readiness from a real VMC. If no stronger implementation appears in a bounded search, checkpoint 3100 and rotate to underdeveloped 3900 rather than repeating generic probe searches.
