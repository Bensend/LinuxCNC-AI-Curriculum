# Press-brake semantic-state -> hydraulic-decoder evidence audit

Date: 2026-09-11
Active course numbering: **3600 — Press Brakes**
Status: **dependency-safe research/source preparation while F02 is blocked**
LinuxCNC pinned baseline for LinuxCNC implementation conclusions elsewhere in this track: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Test the proposed 3600 architecture boundary:

`semantic press state -> abstract hydraulic/process mode -> machine-specific decoder -> final ordinary actuator authorization`

Specifically look for public executable evidence of a nontrivial hydraulic mode such as decompression / pressure dump and for explicit behavior when ordinary machine enable or a process fault changes mid-state.

This is a bounded source-quality audit. Do **not** synthesize a valve truth table from prose or machine drawings that are not public executable configuration.

## Sources inspected

1. Ursviken/Pullmax Optima build diary, page 3, especially posts #342788 and #342870:
   - https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage?start=20
2. Ursviken/Pullmax Optima build diary, page 4, later physical-test reports #342918, #347886, #347942:
   - https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage?start=30
3. 2018 hydraulic press-brake project and inline `pressbrake` component skeleton:
   - https://forum.linuxcnc.org/30-cnc-machines/35266-hydraulic-press-brake-control
4. Accurpress chronology already preserved in:
   - `research/press-brake-accurpress-public-config-ownership-audit-2026-09-11.md`
   - `research/press-brake-accurpress-architecture-evolution-may-2021.md`
   - `research/press-brake-accurpress-2022-stabilization-trace.md`
5. Ursviken tandem evidence already preserved in:
   - `research/press-brake-ursviken-y1-y2-field-architecture-2026-09-11.md`

## Result first: the full layered decoder remains SOURCE UNAVAILABLE

The strongest public architecture proposal is the February 2026 Ursviken/Pullmax design. The builder explicitly recognized that one component had been placed too high in the control loop: it was reading GUI outputs, opening spool valves, and commanding `joint.nn.posthome-cmd`, but then could not naturally support ram homing. The proposed correction was to split responsibilities:

- `press-state`: generic press-brake state machine;
- `pullmax-optima`: machine-specific component between joint command and the position PID command, with visibility of command polarity (and likely pedal state) so it can select the machine's spool-valve combinations;
- PIDs remain responsible for proportional-valve commands.

**Evidence class:** `COMMUNITY-REPORTED DESIGN EVOLUTION`.

Two days later the builder proposed an explicit generic interface from the state machine to the machine-specific hardware decoder:

- `y_cmd_pos`;
- `y_cmd_vel`;
- `y_cmd_tonnage`;
- decoded `pedal_is_dn`;
- `motion_type_cmd` enumerating semantic hydraulic modes.

The proposed `motion_type_cmd` values include distinct commands for:

- fast/medium/slow upward motion;
- **pressure dump (`-1`)**;
- halt (`0`);
- dwell (`1`);
- slow/medium/fast downward motion;
- homing slow up/down.

The builder also proposed a per-machine valid-state list in the INI because different hydraulic manifolds support different physical modes.

**Evidence class:** `COMMUNITY-REPORTED INTERFACE CONTRACT`, not executable-source confirmation.

A bounded search still did not locate a public downloadable `press-state.comp`, final `pullmax_optima.comp`, complete HAL/INI set, or later repository containing the decoder implementation. The thread later reports successful real bending on 22 July 2026, but that report describes the Y1/Y2 position/synchronization topology, not the exact hydraulic-mode decoder. Therefore the exact mapping:

`motion_type_cmd -> spool-valve coils / servo-valve sign / relief command / authorization gates`

remains **UNKNOWN / FINAL SOURCE UNAVAILABLE**.

Do not repeat this same source search absent new attachments/repository evidence.

## Why the distinction matters

A semantic value such as `motion_type_cmd = -1` proves only that the proposed interface has a name for pressure dump. It does **not** establish:

1. which physical coils must energize or de-energize;
2. whether servo valves must be centered, reversed, or otherwise biased;
3. what proportional-relief command is appropriate;
4. whether an output-enable gate is before or after the decoder;
5. whether a valve command is mechanically achieved;
6. how long decompression should remain active;
7. what feedback proves pressure has actually fallen;
8. what happens if pedal, machine-enable, field I/O, pressure feedback, or Y1/Y2 synchronization becomes invalid during that state.

Those are separate implementation and machine-safety questions.

## Cross-project comparison

### A. 2018 two-cylinder project — monolithic concept, incomplete executable behavior

The public inline `pressbrake` component declares inputs for E-stop, light curtain, safety door, left/right glass scales, left/right stepper encoder feedback and oil pressure; it declares left/right stepper commands and hydraulic-pump output. However its shown realtime state machine contains only `INIT` and `SELECT`, with `SELECT` immediately returning to `INIT`.

Therefore pin declarations do not establish synchronization, hydraulic decoding, fault response, or safeguarding behavior.

**Evidence class:** `COMMUNITY SOURCE-SKELETON`.

The later field history from the same project is nevertheless valuable: the stepper-driven spool valve could be physically kicked during a hydraulic pressure-relief event and lose position. This demonstrates a real command-vs-actual divergence surface at an intermediate actuator.

### B. Accurpress 2022 — executable press-cycle and pressure response, but no separate hydraulic decoder layer

The retained Accurpress files give inspectable executable ordinary-control evidence:

`physical ram feedback -> press state component -> simple_tp target -> PID -> analog PWM/valve command`

and a pressure-limit branch that forces a pressure-exceeded state and inhibits continued downward motion.

This is executable source/config evidence, but it does **not** instantiate the proposed generic `semantic mode -> machine-specific decoder` split. The machine has a different hydraulic architecture centered on a proportional valve, so it should not be used to invent the Ursviken six-spool truth table.

**Evidence class:** `CONFIG/SOURCE-CONFIRMED` for that machine only.

### C. Ursviken 2026 — strongest layered contract, strongest hydraulic-mode vocabulary, missing final source

The Ursviken diary supplies the clearest reason for the split:

- six discrete spool coils must be coordinated with two servo valves and a proportional tonnage valve;
- wrong coordination can dead-head the pump;
- fast gravity-down and slow powered bend use different valve groups;
- decompression is a distinct hydraulic mode;
- the builder discovered that putting all of this above the joint/motion layer interfered with homing and created spaghetti ownership.

The resulting proposed boundary is architecturally strong, and later physical bending shows the overall project became functional. But without the retained final decoder/HAL, exact executed hydraulic semantics remain unverified.

## Command-vs-actual divergence inventory

A 3600 implementation must inventory stateful intermediate actuators, not just ram position.

| Surface | Command witness | Actual/process witness | Divergence risk | Earliest useful detector |
|---|---|---|---|---|
| Y1/Y2 ram position | joint/PID command | independent physical linear scales | cylinder lag, hydraulic asymmetry | realtime side feedback / differential error |
| servo-valve drive | PWM/H-bridge command | usually no public spool-position feedback in inspected Ursviken evidence | deadband, sticking, electrical fault, valve dynamics | process response; direct spool sensor if fitted |
| discrete spool valve | relay/coil command | no position proof shown | stuck spool, failed coil, wrong hydraulic routing | coil current/aux feedback if available; otherwise process witness |
| proportional tonnage relief | PWM/current request | pressure transducer/process pressure | solenoid/valve non-response, saturation | pressure feedback / bounded pressure-rise expectation |
| stepper-driven spool valve (2018 design) | step position command | stepper encoder / mechanical valve position | **field-reported hydraulic kick caused lost actuator position** | actuator encoder disagreement before ram error grows |
| hydraulic pressure dump | abstract `motion_type_cmd=-1` in proposed contract | falling measured pressure | decoder error, valve non-response, trapped pressure | pressure sensor with explicit timeout/qualification |

### General rule

**Outer ram feedback cannot prove every intermediate hydraulic actuator followed its command.**

Where a stateful actuator can diverge and that divergence matters before ram-position error becomes large, give it an independent witness or explicitly classify the remaining observability gap.

## Reconstructed generic call-flow contract

The evidence supports this **INFERENCE / review contract**, not a claim that an existing public configuration implements every block:

```text
operator/program request
        |
        v
press-state semantic state machine
  - validates cycle preconditions
  - owns approach / bend / dwell / return semantics
  - emits desired Y position, velocity, tonnage
  - emits abstract hydraulic mode
        |
        +----------------------+
        |                      |
        v                      v
LinuxCNC joint/motion       machine-specific hydraulic decoder
position ownership          - validates supported mode
/PID synchronization        - chooses discrete spool combination
        |                   - chooses servo-valve direction policy
        |                   - chooses tonnage/relief policy
        |                      |
        +----------+-----------+
                   v
           ordinary authorization gate
           - machine enabled?
           - required field I/O healthy?
           - fast Y1/Y2/process faults clear?
                   |
                   v
             final hardware commands
                   |
                   v
          hydraulic/mechanical plant
                   |
        +----------+-----------+
        |                      |
        v                      v
independent Y1/Y2 scales   pressure / actuator witnesses
        |                      |
        +----------+-----------+
                   v
          fault/state feedback path
```

### Scheduling implication

For a realtime implementation, decoder inputs and authorization/fault inputs must have explicit same-thread ordering. A correct truth table can still be unsafe as ordinary control if the hardware write publishes a previous-period authorization or if a newly detected fault is not applied until after outputs are written.

This scheduling statement is a generic LinuxCNC/HAL design consequence established by the curriculum's H04 and later realtime work; no final Ursviken `addf` order is publicly available to audit.

## Mid-state enable/fault contract

For every non-idle press state, a future executable decoder review should answer all of the following:

1. What semantic state owns the operation?
2. What abstract hydraulic mode is requested?
3. Which physical output combination does that mode decode to on this exact machine?
4. Which output(s) can store mechanical/hydraulic state independent of command?
5. What feedback proves the expected effect occurred?
6. What happens in the **same control cycle or defined bounded latency** if ordinary machine enable becomes false?
7. What happens if pedal authorization is released?
8. What happens on Y1/Y2 mismatch or following error?
9. What happens if requested valve/relief command saturates?
10. What happens if pressure does not move in the expected direction?
11. Is decompression an explicit state with a completion witness, or merely an assumed side effect of another command?
12. What diagnostic reason is retained after outputs are inhibited?
13. What state reconciliation is required before re-enable?

Functional safety remains a separate layer; answering these ordinary-control questions does not establish safety performance level or category.

## Adversarial tests

### Trap 1 — “The interface has `pressure dump`, therefore decompression is implemented.”

**Reject.** The public evidence defines the semantic value but does not expose the final Pullmax decoder that maps it to real coils/valves or prove pressure-decay completion.

### Trap 2 — “If both ram scales track correctly, valve state is known.”

**Reject.** The 2018 field report demonstrates a stepper-driven spool actuator can lose position under hydraulic disturbance. An outer plant output can lag the earliest actuator fault.

### Trap 3 — “An E-stop/light-curtain pin in a component proves those safeguards act.”

**Reject.** The 2018 source skeleton declares such pins but does not consume them in meaningful executable logic. Declaration is not execution, and ordinary LinuxCNC software is not presumed safety-rated.

### Trap 4 — “Copy the Accurpress pressure-limit state into the Pullmax decoder.”

**Reject.** The Accurpress evidence proves behavior for its proportional-valve architecture. The Pullmax has multiple discrete spool modes plus servo valves and a separate tonnage valve. Machine-specific hydraulic decoding is exactly why the interface boundary exists.

### Trap 5 — “Disable can simply zero the position command.”

**Reject.** A hydraulic mode may require a controlled pressure-release/decompression path rather than treating every interruption as a new position target. The exact response is machine-specific and must be derived from the real hydraulic/electrical design and safety analysis, not guessed by the generic curriculum.

## Sufficiency decision

This pass did **not** find the desired public executable `press-state -> abstract mode -> Pullmax decoder -> outputs` implementation. That is a valid bounded negative result, not permission to reconstruct one from prose.

It does strengthen the 3600 review method:

- treat semantic process mode separately from final valve state;
- demand exact source/HAL before claiming a decoder truth table;
- require explicit authorization placement and same-thread ordering;
- inventory stateful intermediate actuators and command-vs-actual witnesses;
- model decompression as an explicit process/hydraulic behavior that needs a completion witness when machine architecture requires it;
- keep functional safety separate from ordinary realtime control.

## Precise next-work checkpoint

1. **Do not repeat the Ursviken final-source search** until new public attachments/repository evidence appears.
2. Search one independent public LinuxCNC hydraulic-machine implementation for an **executable mode decoder or output-interlock state machine**. It may be non-press-brake only if clearly labeled adjacent architecture evidence.
3. Prefer examples with at least one nontrivial mode transition and a physical/process completion witness, not merely output relays.
4. Trace exact source/HAL ordering: input acquisition -> semantic/mode state -> decoder/interlock -> authorization -> hardware write -> feedback/fault witness.
5. Compare that executable pattern against the 3600 press-brake contract without copying machine-specific valve combinations.
6. Preserve S02/E20/X01/X02 information separation; F02 remains blocked. PB-PREP-001 remains INCONCLUSIVE / no architecture recommendation.
