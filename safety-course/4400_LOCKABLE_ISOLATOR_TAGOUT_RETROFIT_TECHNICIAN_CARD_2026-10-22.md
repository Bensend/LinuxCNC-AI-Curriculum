# 4400 technician qualification — lockable isolation is not E-stop

**Purpose:** Transfer the OSHA 1910.147 isolation distinction to a low-budget machine retrofit without inventing machine-specific safety values. **Status:** LEARNER EXERCISE, NOT RUN. Source: `../research/4400_LOCKABLE_ISOLATION_TAGOUT_RETROFIT_EVIDENCE_2026-10-22.md` (staged pending publication).

## Scenario

A LinuxCNC-controlled press brake has a two-channel E-stop, safety relay and pump-contactor feedback. The main disconnect has no padlock hole; a mechanic ties a warning tag to the E-stop. The beam can still be moved by stored hydraulic pressure and gravity. A second worker will join servicing after lunch. A new panel-mounted rotary switch-disconnector is proposed for the retrofit.

## Learner tasks (do not assume unknown measurements)

1. Identify which described objects are **ordinary control**, **production safety control**, **actual energy-isolation candidates**, and **physical energy/load restraints**. State what each can and cannot prove.
2. Apply OSHA 1910.147(b), (c)(2), (c)(3), (d)(5–6), and (f)(3–4) to the facts. Distinguish a tagout system on a non-lockable isolator from a tag attached to a control E-stop.
3. Explain why (c)(2)(iii)'s major-repair/retrofit rule deserves review and why this scenario alone does not settle legal applicability.
4. Draw a task-specific energy boundary for the electric pump, hydraulic accumulator, trapped cylinder ports, gravity beam and auxiliary circuits. Leave pressure values, holding truth table, load-restraint capacity and stopping distance UNKNOWN.
5. Propose a worker-friendly lockout station and safe service access. Identify at least two predictable shortcuts the layout should prevent.
6. Show how a temporary powered positioning test invalidates prior isolation verification, and how each worker retains personal protection through the group-lock/shift transition.

## Acceptance rubric (independent review; not a hidden answer key)

Reject any response that: treats LinuxCNC E-stop or a lockable control button as maintenance isolation; equates a tag with a physical lock; ignores gravity/accumulators; invents a hydraulic truth table; claims a catalog part proves installed isolation; or authorizes people inside an unverified hazard zone. Require explicit UNKNOWNs, independent physical verification and a fresh re-isolation gate.

## Cumulative package

Use `BND/ENE/HAZ -> SF/PHY/SRS -> AUTH/DEP/ARC -> VAL/PT` with `HF/CHG/UNK/RR`. This card is a practical transfer exercise, not permission for live fault injection or exposed operation.
