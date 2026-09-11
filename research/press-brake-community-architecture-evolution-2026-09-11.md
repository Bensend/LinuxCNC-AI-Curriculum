# Press-brake community architecture evolution — control ownership and hydraulic decomposition

Date: 2026-09-11

Status: **COMMUNITY RESEARCH RECONCILED WITH SOURCE QUESTIONS; not a machine design prescription**

Purpose: compare several public LinuxCNC press-brake discussions for repeated architecture/failure themes. Community reports are retained as leads and field experience, not upgraded to source/test truth merely because experienced users reported them.

## Case 1 — Accurpress conversion, 2022 report of earlier field retrofit

Thread: https://forum.linuxcnc.org/show-your-stuff/45716-vertical-press-brake-interface-and-comp

The builder described an Accurpress retrofit with the ram under full PID, two backgauge axes, +/-10 V commands through Mesa hardware, and jog/manual, semi-auto and auto modes. The notable architecture history is the important part:

- initial design used a large custom “do it all” component/state machine for the ram/process;
- after many iterations, the builder reported the response as rough/jerky;
- the later field version instead put all three motion axes under LinuxCNC MOTION and used G-code/sequences around that motion layer;
- the builder explicitly recommended reusing MOTION rather than reimplementing it.

Classification: **COMMUNITY-REPORTED**.

Transferable hypothesis: a press-state layer should not casually replace trajectory/joint-control responsibilities already implemented and observable in motmod. This hypothesis is strengthened by the pinned-source ownership work but remains architecture guidance, not a universal rule.

## Case 2 — proportional-valve retrofit investigation, 2023

Thread: https://www.forum.linuxcnc.org/10-advanced-configuration/48633-linuxcnc-press-brake-retrofit-with-servo-proportional-valves

The initial assumption was close to “one proportional valve plus one linear encoder can be treated as an axis.” Physical inspection revealed a more complicated manifold with multiple valves and an existing Bosch proportional-valve control board.

Community analysis distinguished several possible layers:

- a true proportional valve may already have a local valve-position servo loop with LVDT feedback in its amplifier;
- the machine-level command may therefore target the valve amplifier rather than directly close the spool-position loop in LinuxCNC;
- other valves may implement flow selection, hydraulic routing, load holding or other machine functions rather than being redundant versions of the proportional valve;
- without the hydraulic circuit and board documentation, assuming each coil's role from appearance alone is unsafe and technically weak.

Classification: **COMMUNITY-REPORTED**.

Transferable research rule: before simulating or tuning “the hydraulic axis,” identify the nested control boundaries. At minimum distinguish:

```text
LinuxCNC position / velocity command
    -> machine-level electrical command
        -> possible valve-amplifier current/spool-position loop
            -> proportional/servo valve hydraulic flow
                + discrete spool/load/route valves
                    -> cylinder/beam mechanics
                        -> linear-scale position feedback
```

A simulation that collapses all these layers into one generic proportional gain may still teach software control structure, but it cannot be presented as a verified model of a real press.

## Case 3 — Ursviken Pullmax Optima 130, 2025–2026 evolving retrofit

Thread: https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage

Reported physical/control structure includes:

- Y1/Y2 left/right ram sides;
- separate ram servo valves;
- multiple discrete spool valves whose combination selects hydraulic modes such as fast/slow/up/down/dwell/decompression;
- proportional relief/tonnage command;
- X/R and independent Z1/Z2 backgauge mechanisms.

The design history is more useful than any one snapshot:

1. The builder first considered a Glade+HAL application without motmod, then moved toward full LinuxCNC to reuse homing and motion facilities rather than reimplement them.
2. The `extra joints` feature was proposed for mechanisms needing LinuxCNC homing but externally supplied post-home position commands.
3. The builder built a custom `pullmax` component that combined GUI commands, hydraulic spool sequencing and `posthome-cmd` position generation.
4. During ram-homing work, the builder concluded that component was too high in the control loop: it could not naturally know when spool valves needed to be sequenced during motion-owned homing without adding increasingly tangled state observation.
5. The proposed redesign split a press-state state machine from a machine-specific hydraulic interface nearer the PID/motor-command boundary.

Classification: **COMMUNITY-REPORTED**.

The same thread also reports a concrete hydraulic failure mode: incorrect valve combination can dead-head the pump and stall the large pump motor. That report is machine-specific and not a universal sequence, but it demonstrates why valve-state errors are not merely a tracking-quality problem.

## Case 4 — earlier open-source/design discussions, 2020–2021

Threads:

- https://forum.linuxcnc.org/51-ot-posts/40271-linuxcnc-press-brake-open-source
- https://forum.linuxcnc.org/38-general-linuxcnc-questions/41811-press-brake

These discussions contain many conceptual ideas but relatively little retained, verified implementation evidence. They are useful mainly as evidence of recurring desired scope: backgauge positioning, Y/dual-Y control, angle/tool geometry, staged complexity and operator workflow. They should not be cited as proof of a control architecture.

Classification: **COMMUNITY-LEAD ONLY**.

## Cross-case pattern

Across the stronger field reports, the repeated architectural problem is **ownership**, not merely PID tuning.

The press controller has at least four separable responsibilities:

1. **Motion ownership** — generate and supervise the commanded geometric trajectory/joint positions.
2. **Synchronization ownership** — compare Y1/Y2 independent truth and allocate differential authority.
3. **Hydraulic-mode ownership** — select machine-specific spool/flow/pressure modes so the physical circuit is in a valid state for the requested motion.
4. **Press-cycle/state ownership** — pedal semantics, approach/change point, bending/dwell/decompression/return sequence, operator mode and recovery.

A fifth, separate boundary is **functional safety**, which must not be equated with any ordinary HAL state machine or software interlock.

The community evolution suggests that monolithic components become difficult when they simultaneously own all four responsibilities, especially when LinuxCNC homing/motion still owns part of the trajectory. This is consistent with, but not alone sufficient to prove, a layered 4600 architecture.

## Reconciliation with pinned LinuxCNC source

Two source-confirmed facts constrain how community designs should be interpreted:

- duplicated `trivkins` coordinates fan a common Cartesian command to multiple kinematic joints while preserving ordinary per-joint feedback/ferror state;
- homed `extra joints` transfer motor command ownership to `joint.N.posthome-cmd` and ordinary motmod following error is explicitly not relevant to those homed extra joints.

Therefore “use extra joints” and “use MOTION for the ram” are not equivalent statements. A 4600 architecture must name the exact ownership and observability consequences of either choice.

Related source artifacts:

- `research/press-brake-motion-ownership-extra-joints-vs-duplicated-y-2026-09-11.md`
- `research/press-brake-duplicated-y-command-feedback-source-trace-2026-09-11.md`

## Adversarial architecture questions spawned

1. If the press-state component says “slow down,” which layer owns translating that request into geometric velocity, servo/proportional command, and discrete hydraulic routing?
2. During homing, which component is authoritative for requested direction, and how does the hydraulic-mode layer know that direction without duplicating/mirroring motion state incorrectly?
3. If a proportional-valve amplifier already closes an LVDT/current/spool loop, what should LinuxCNC command and what should it measure? Do not model a nested valve servo as if LinuxCNC directly controls raw spool physics unless evidence says so.
4. If a spool-sequence error can dead-head a pump, what independent validity/interlock evidence is required before motion command is admitted? This is distinct from axis following error.
5. Can a machine-specific hydraulic decoder be separated behind a generic press-state interface without hiding critical feedback or fault semantics?
6. Which functions must remain operational when ordinary CNC motion is disabled, and which of those belong to a separate safety-oriented system rather than LinuxCNC?
7. For Y1/Y2, does the chosen topology retain two independent feedback/ferror truths after homing, or has one/both sides moved behind external control that must re-create those diagnostic/fault functions?

## Current 4600 working architecture hypothesis

This is an **INFERENCE TO TEST**, not yet a design recommendation:

```text
operator / bend program
        |
press-cycle state machine
        |   desired motion state, bend target, pressure/tonnage intent
        +--------------------+
        |                    |
LinuxCNC motion/joint layer  machine-specific hydraulic-mode decoder
        |                    |
common Y / independent       spool/route/pressure mode validity
Y1/Y2 command+truth          |
        |                    |
Y1/Y2 synchronization / final actuator allocation
        |
machine-specific electrical/valve interfaces
        |
physical hydraulics and independent safety system
```

The exact placement of the synchronization block relative to stock PID is still being tested by PB-PREP-001 A/B/C. The hydraulic decoder must not be treated as a generic proportional-valve model; its machine-specific modes and failure behavior require physical documentation.

## What this research rules out

It rules out these unjustified simplifications for the eventual playbook:

- “a press brake ram is just a normal servo axis” without documenting hydraulic mode/pressure layers;
- “all the valves are just speed outputs” without a hydraulic schematic or other evidence;
- “a custom state component should own everything” merely because HAL makes that possible;
- “extra joints and duplicated coordinates are equivalent ways to create Y1/Y2”;
- “software sequencing is functional safety.”

## Next-work checkpoint

- Score the already-running PB-PREP-001 077 candidate from raw artifacts under the precommitted independent audit; no duplicate run and no tuning after result.
- Continue 4600 community mining with configs/source attachments, not prose alone: locate at least one downloadable press-brake HAL/COMP/config set and trace how motion ownership and hydraulic sequencing are actually wired.
- Build a machine-agnostic interface inventory for `press-state <-> motion/synchronization <-> hydraulic decoder`, marking which signals are commands, observations, validity/fault witnesses and safety-external signals.
- Defer real valve sequence/current/pressure values to machine-specific evidence; generic curriculum simulations remain dimensionless unless a public machine dataset supports stronger claims.
