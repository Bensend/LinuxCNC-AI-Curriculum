# 3200 — Tailstock / workholding authority pass

Date: 2026-09-15
Pinned LinuxCNC revision for native behavior: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`

## Scope

Continue the 3200 breadth checkpoint into chuck/collet/tailstock/steady-rest style auxiliary workholding. The bounded search produced a concrete hydraulic-tailstock field implementation and upstream M66 regression evidence. This note freezes only evidence-backed behavior; it does not invent a universal lathe workholding component.

## Real hydraulic-tailstock implementation

LinuxCNC forum thread **“M66 keeps waiting”** describes a CNC lathe with:

- two hydraulic valves: tailstock extend and retract;
- two proximity sensors: minimum/retracted and maximum/extended;
- valve commands driven with immediate `M64/M65` digital outputs;
- physical position witnesses connected to `motion.digital-in-00` and `motion.digital-in-01`;
- intended G-code waits using `M66 ... Q10` before de-energizing one valve and commanding the opposite direction.

The commissioning failure is important: the sensors visibly changed in HAL, and the M66 command worked when issued from MDI, but the initial automatic test program remained waiting at the M66 line. Therefore `sensor visible in HAL` and `single MDI wait works` are useful observations, but they do not by themselves validate the entire automatic workholding transaction.

Source: https://forum.linuxcnc.org/20-g-code/56882-m66-keeps-waiting

## Native LinuxCNC wait semantics

Pinned upstream regression `tests/mdi-queue-length/test-ui.py` deliberately connects a test bit to `motion.digital-in-00`, issues `M66 P0 L3 Q30`, and uses that wait to block Motion while Task queues another MDI command. The same regression later uses L4 for a falling transition. This independently confirms that M66 is a real execution barrier around the synchronized digital-input surface, not merely a GUI convention.

Relevant native meaning retained for this curriculum:

- L3: wait for rising transition;
- L4: wait for falling transition;
- Q: bounded timeout rather than an indefinite physical-completion assumption.

## Authority decomposition

A production tailstock/chuck/collet transaction should keep these states separate:

1. **requested action** — extend/retract, clamp/unclamp, open/close;
2. **output command** — the HAL/field command actually issued;
3. **physical witness** — end-position, pressure, clamp, or other mechanism-specific feedback;
4. **completion acknowledgement** — the predicate that allows the G-code/cycle to continue;
5. **timeout/fault** — failure to reach the requested witness in bounded time;
6. **restart/recovery eligibility** — what may safely be commanded after abort, timeout, E-stop, or an ambiguous sensor combination.

Immediate M64/M65 command authority is not physical completion. A prox proving tailstock extension is also not automatically proof of adequate workpiece support force unless the machine architecture makes that implication valid.

## Failure combinations that must remain explicit

- neither end sensor active;
- both end sensors active;
- requested extension but only retract witness remains active;
- requested retract but only extension witness remains active;
- output command changes but no witness transition occurs before timeout;
- stale witness already in the desired state before a new request;
- abort/stop while a hydraulic valve remains commanded;
- position witness valid but pressure/clamp force unproven where force matters.

A level input and a transition request answer different questions. If a cycle requires evidence that a *new* physical action occurred, a stale already-true level must not be silently promoted into request-scoped completion without an explicit policy.

## Durable rule

**workholding command != mechanism position != clamp/support force != request-scoped completion != restart-safe state**

LinuxCNC provides useful generic command and wait surfaces, but the machine integration owns the physical completion predicate and recovery contract.

## Lab decision

No lab is justified. Upstream source/regression already establishes the M66 execution barrier, and the remaining uncertainties are machine-specific hydraulic/workholding semantics better answered by real implementations.

## Next evidence target

Continue 3200 into lathe toolsetter/probing, because current public workholding evidence is sufficient for a breadth contract but too thin to justify repetitive searching. Preserve a reopen condition for a downloadable chuck/collet/tailstock configuration with pressure/clamp proof and explicit abort recovery.
