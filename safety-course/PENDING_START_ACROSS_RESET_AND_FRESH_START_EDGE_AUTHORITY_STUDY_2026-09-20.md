# Pending Start Across Reset and Fresh-Start Edge Authority Study

Date: 2026-09-20
Active curriculum: 4000 safety course

## Question

When a safety/fault reset is performed while an ordinary START/motion command is already asserted, what evidence shows that a fresh post-reset start event is required rather than allowing the stale command to become motion authority?

This is deliberately narrower than the general rule that reset and restart are different functions. The target is the stale-command failure mode itself.

## Authoritative manufacturer evidence

### Siemens SIRIUS 3RW30 / 3RW40 soft starters — pending START can restart after RESET

Source: Siemens, *SIRIUS 3RW30 / 3RW40 Equipment Manual*, 12/2024, section 4.4.1.4 Auto RESET.

Official source: https://support.industry.siemens.com/dl/files/095/38752095/att_1310811/v1/Manual_softstarter_3RW30_3RW40_en-US.pdf

Evidence classification: `DOC-CONFIRMED`.

Siemens warns that automatic reset must not be used where unexpected restart can cause injury or damage. Critically, it states that the start command, including a PLC-issued command, must be reset before RESET because the motor can restart automatically when a start command remains present after reset.

This is direct manufacturer evidence for the exact stale-command hazard:

**START ALREADY TRUE + RESET != FRESH START AUTHORITY.**

It also demonstrates why a level-sensitive ordinary command cannot simply be allowed to flow through a safety/fault recovery boundary.

### SICK UE440/UE470 — RESET must complete before a later START edge

Source: SICK, *UE440/UE470 Compact Safety Controller Operating Instructions*, chapter 4, configurable functions.

Official source: https://www.sick.com/media/docs/3/53/153/operating_instructions_ue440_ue470_compact_safety_controller_en_im0014153.pdf

Evidence classification: `DOC-CONFIRMED`.

For a configuration using internal restart interlock plus Reset and Start inputs, SICK specifies the sequence rather than accepting static input levels:

1. Reset must occur first.
2. Reset requires a LOW-HIGH-LOW signal progression.
3. Start may be activated no earlier than 100 ms after the negative edge of Reset.
4. Release occurs on the later LOW-HIGH Start edge for the documented rising-edge modes.

This is stronger than merely saying “use a separate start button.” It establishes temporal freshness: the start event must occur *after* reset completion. A START that was already high before reset cannot supply the required later LOW-HIGH transition.

## Cross-source synthesis

Evidence classification: `INFERENCE`, directly bounded by the two manufacturer examples above.

Siemens shows the failure mechanism: a pending level-sensitive start can turn reset into restart.

SICK shows a concrete countermeasure: ordered reset completion followed by a new start edge.

Together they justify a reusable curriculum architecture rule:

**SAFETY CONDITION RESTORED != RESET ACCEPTED != START INPUT HIGH != FRESH POST-RESET START EDGE != HAZARDOUS-MOTION AUTHORITY.**

A robust restart boundary therefore needs explicit state/history, not merely an AND gate such as:

`motion_enable = safety_ready AND start_command`

That expression permits a start command asserted before `safety_ready` to become effective as soon as readiness returns. Where unexpected restart is hazardous, the architecture instead needs to consume or invalidate pre-reset/pre-ready commands and require a post-reset event appropriate to the validated safety/control design.

## Practical validation pattern

Evidence classification: `INFERENCE` unless a specific machine/manufacturer procedure adopts it.

For a machine where fresh start is required, commissioning should challenge the exact stale-command path:

1. Establish ordinary running/readiness conditions.
2. Assert or maintain the ordinary START/motion request.
3. Cause the applicable safety/fault stop.
4. Restore the protective/fault condition while deliberately keeping the old START request asserted.
5. Perform the required safety reset/rearm.
6. Verify that hazardous motion does **not** resume from the stale request.
7. Remove the old START request if necessary to return the ordinary command interface to its neutral state.
8. Generate the required fresh START transition.
9. Verify that only this fresh event can authorize the ordinary cycle, subject to all other permissives and safety functions.

This test must observe the physical hazardous motion/final element appropriate to the machine; an HMI “ready” bit alone is not sufficient evidence.

## LinuxCNC / OpenPressBrake boundary

LinuxCNC or the normal FPGA may own ordinary cycle requests and can expose/log command history, but they must not be treated as the sole personnel-safety authority merely because they can implement edge detection.

The safety architecture determines when safety reset/rearm is valid. The ordinary control architecture must then avoid converting an old level-sensitive request into a new cycle after that safety boundary reopens.

Useful diagnostics should preserve provenance, for example:

- safety function active/cleared;
- safety reset required/accepted;
- ordinary START input current level;
- ordinary START edge accepted/rejected;
- stale-start inhibit active;
- fresh-start-required state;
- final-element/motion witness.

Do not collapse these into a generic `SAFE` or `READY` bit.

## Human-factors consequence

If operators routinely hold a cycle button, tape a pedal, leave a remote command asserted, or depend on a maintained PLC bit, that foreseeable behavior must be considered in restart validation. Requiring a fresh event only in documentation while the interface makes stale assertion easy is a weak design.

The safer behavior should be the easy behavior: after a protective stop/reset, the operator should receive a clear indication that a fresh ordinary start is required, and the control should reject stale requests deterministically rather than relying on the operator to remember to release them.

## What this does not prove

- It does not assign a PL/SIL to an OpenPressBrake implementation.
- It does not prove that every machine requires the same reset/start timing or edge semantics.
- It does not make LinuxCNC/HAL/normal FPGA logic safety-rated.
- It does not prove personnel clearance, final-element state, stopping distance, hydraulic state, brake holding capacity, or safe access.
- It does not establish that 100 ms is a universal timing requirement; that value belongs to the cited SICK controller behavior.

## Durable freezes

**RESET ACCEPTED != START AUTHORIZED.**

**START INPUT HIGH != FRESH START EVENT.**

**PRE-RESET START REQUEST != POST-RESET MOTION AUTHORITY.**

**SAFETY READY + STALE START != VALID RESTART.**

**FRESH START EVENT != PERSONNEL CLEAR != FINAL-ELEMENT PROOF.**

## Information-gain status

The cross-cutting stale-command/fresh-start evidence gap is materially closed at the manufacturer-documentation level: one authoritative source exposes the pending-command hazard and another exposes an ordered reset-then-new-start-edge architecture.

A future machine-specific acceptance procedure that deliberately holds START through reset and physically observes no motion would strengthen this to an integrated commissioning witness, but generic reset/restart searching should no longer be a priority unless it adds that physical acceptance evidence.
