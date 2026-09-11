# Accurpress press-brake — 2022 timing, pressure and field-status trace

Date: 2026-09-11
Status: **DEPENDENCY-SAFE 4600 COMMUNITY/CONFIG/SOURCE ANALYSIS**

## Objective

Continue the public Accurpress build diary far enough to determine whether the 2021 standalone custom-controller architecture persisted, whether its realtime ordering improved, and whether the proposed pressure-limit behavior became executable.

This follows:

- `research/press-brake-accurpress-public-config-ownership-audit-2026-09-11.md`
- `research/press-brake-accurpress-architecture-evolution-may-2021.md`

## Public evidence

Thread page 12:
https://forum.linuxcnc.org/30-cnc-machines/42100-pressbrake-cnc-control-setup-questions?start=110

Machine HAL posted 2022-04-25:
https://forum.linuxcnc.org/media/kunena/attachments/19921/bender_2022-04-25.hal

Reworked component posted 2022-04-26:
https://forum.linuxcnc.org/media/kunena/attachments/723/press_2022-04-25.comp

Later field-status report (2024):
https://forum.linuxcnc.org/30-cnc-machines/53456-retrofitting-a-small-bending-machine

The HAL identifies the machine as an Accurpress 7254 and says it was updated by Earl Weaver. The component is an adjacent-day forum attachment, not a proven exact release pair with the HAL. Treat cross-file conclusions accordingly.

## Architecture persistence

The 2022 HAL still uses the standalone custom-control architecture introduced in 2021:

- no MOTMOD/KINS;
- custom `press` realtime component;
- `simple_tp` trajectory planners for ram and two backgauge axes;
- HostMot2/hm2_eth Mesa interface;
- one PID per controlled axis;
- GUI/HAL signals for bend table, jogging, homing and enabling.

So the project did **not** revert to conventional MOTMOD ownership during this period. Generic homing/jogging remained inside the custom press component.

**Evidence class:** CONFIG-CONFIRMED.

## Realtime ordering was corrected into a coherent producer/consumer chain

The 2022 machine HAL adds realtime functions in this order:

```text
hm2_7i97.0.read
press
simple-tp.0.update
simple-tp.1.update
simple-tp.2.update
pid.0.do-pid-calcs
pid.1.do-pid-calcs
pid.2.do-pid-calcs
scale.0
scale.1
logic / lowpass / estop
hm2_7i97.0.write
```

LinuxCNC same-thread functions execute in `addf` order.

For the ram, the causal path in one thread invocation is therefore now:

```text
hardware encoder
   -> hm2.read
   -> press consumes fresh physical feedback and chooses target/speed
   -> simple_tp advances planned position
   -> PID compares planned position with fresh encoder feedback
   -> hm2.write publishes that invocation's new PID output
```

This removes both one-period age boundaries identified in the May 2021 file, where `press` ran before the hardware read and `hm2.write` ran before PID.

This is a strong example of why a build diary must be read chronologically. A static copy of the May file would preserve a timing issue that the later machine configuration corrected.

**Evidence class:** CONFIG-CONFIRMED ordering + DOC-CONFIRMED `addf` semantics.

## Ram command/feedback topology remained coherent

The active ram path is:

```text
press.axis.0.pos-cmd-out -> simple-tp.0.target-pos
press.axis.0.vel-cmd     -> simple-tp.0.maxvel
simple-tp.0.current-pos  -> pid.0.command
encoder.00.position      -> pid.0.feedback
encoder.00.position      -> press.axis.0.pos-fb-in
pid.0.output             -> pwmgen.00.value
```

This retains the important May 2021 corrections:

- planned **position** drives the position PID command;
- measured physical position drives PID feedback;
- measured physical position independently drives the press component's cycle/homing state.

Planner state and plant state are no longer conflated by the shown nets.

**Evidence class:** CONFIG-CONFIRMED; `simple_tp.current-pos` and PID semantics independently source-confirmed in the curriculum's pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

## Pressure/tonnage became part of executable ordinary control

The 2022 HAL acquires an analog pressure-transducer signal and scales it twice:

```text
analogin0 -> scale.0 / scale.1
GUI tonnage limit -> press.max-pressure
scaled tonnage -> GUI tonnage gauge + press.pressure
press.overload -> GUI overload light + Mesa SSR output
```

The adjacent component attachment defines `max_pressure` and `pressure` inputs and checks them before its state switch:

```c
if (pressure > max_pressure) {
    target = top_position;
    state = 9;
}
```

State 9 is explicitly labeled `pressure limit exceeded`. While pressure remains above the limit it commands upward return only when the `up` input is asserted; otherwise it commands zero ram velocity. Once pressure falls back to or below the threshold, it moves into the ordinary return state.

This is substantially stronger evidence than the April 2021 discussion, where overpressure handling was only proposed.

### Version-pair caveat

The April-25 HAL references `press.overload`, but the April-26 component attachment visible in the forum does not export an `overload` pin in its shown pin list. Therefore these two attachments are **not proven to be a build-clean matching pair**. Do not claim that the exact HAL/component combination compiles unchanged.

What is independently established is:

1. the April-25 machine HAL was wired for pressure/tonnage and expected an overload status;
2. the April-26 component contains executable max-pressure state-machine logic;
3. exact file-pair coherence is UNKNOWN without a retained same-version bundle.

This version mismatch is itself a curriculum lesson: forum attachments must be versioned as artifacts, not casually merged into a synthetic “latest configuration.”

## Homing remained a real field weakness

The 2022 thread continues debugging backstop index homing. The machine owner reports cases where the PID `index-enable` goes false but commanded position does not reset as expected, and later reports a rapid jerk after an index event plus incorrect home-offset behavior.

The component's homing state uses `axis.#.index-enable`, raw encoder feedback, per-axis home switch, search velocity and stored offset. This confirms that the custom component owns substantial homing semantics rather than delegating them to LinuxCNC MOTMOD.

The thread does not provide enough evidence here to declare the homing implementation correct. On the contrary, the field reports make homing/recovery a durable weakness requiring separate treatment.

**Evidence class:** SOURCE-CONFIRMED for component state logic; COMMUNITY-REPORTED for machine symptoms; correctness UNKNOWN.

## Field status years later

In an August 2024 LinuxCNC forum thread, the same machine owner states that the press brake retrofit is used regularly for bending and is otherwise working well, while still noting an issue with homing the backstop.

That is valuable longitudinal community evidence:

- the custom architecture was not merely a simulator that disappeared immediately;
- it reached useful field operation;
- the backstop-homing weakness persisted long enough to remain worth mentioning years later.

It is **not** evidence that the system satisfies functional-safety requirements, that every control path is optimal, or that tandem Y1/Y2 machines should copy the architecture.

**Evidence class:** COMMUNITY-REPORTED field status.

## Evolution table

| Stage | Command ownership | Physical feedback to press? | PID command semantics | Realtime order | Pressure handling | Known issue |
|---|---|---:|---|---|---|---|
| Apr 2021 merge | hybrid MOTMOD + custom | no; planner `current-pos` fed press feedback pin | planner `current-vel` into position feedback PID | read -> motion/PID -> write -> press/planner | analog acquisition only; proposal for limit | ownership/units/feedback ambiguity |
| May 2021 standalone | custom press + simple_tp | yes | planner position vs encoder position | press/planner -> read -> write -> PID | not yet shown as executable | one-period state-age boundaries; homing debug |
| Apr 2022 field config | custom press + simple_tp | yes | planner position vs encoder position | read -> press/planner -> PID -> write | wired pressure/tonnage + component overpressure logic | backstop/index homing remains problematic |
| Aug 2024 report | same retrofit in regular use | not re-audited | not re-audited | not re-audited | not re-audited | backstop homing still mentioned |

## Generalizable 4600 lessons

1. **Architecture evolution is evidence.** The important lesson is not merely that a custom component existed, but why its nets and scheduling changed after machine testing.
2. **Producer order belongs in the interface contract.** The 2021 and 2022 files have nearly the same conceptual blocks but materially different state-age semantics.
3. **Plant truth, planner truth and GUI truth must be named separately.** The project improved when physical encoder feedback was routed explicitly to both control and cycle logic.
4. **A standalone press component can work in the field, but generic motion services become its responsibility.** Homing became a persistent trouble surface.
5. **Pressure limiting is ordinary machine-control logic here, not a safety certification argument.** No public file makes the software pressure state a safety-rated protective function.
6. **Never synthesize a canonical config from attachments posted on different dates.** Preserve exact file provenance and call out mismatched pins or versions.
7. **This remains single-ram evidence.** It says nothing decisive about tandem Y1/Y2 synchronization authority or final-side allocation.

## Function/state guide for pressure limit

| Surface | Role | Evidence |
|---|---|---|
| `press.pressure` | scaled process-pressure/tonnage observation | HAL attachment + component pin |
| `press.max-pressure` | operator/configured ordinary process limit | HAL attachment + component pin |
| `if (pressure > max_pressure)` | pre-switch guard forcing pressure-limit state | component source |
| state 9 | inhibits downward motion; permits upward return according to pedal/status | component source |
| `press.overload` | expected status surface in Apr-25 HAL | HAL only in inspected pair; absent from Apr-26 component pin list |

## Adversarial verification

### Scenario A — same blocks, same behavior?

A reviewer compares the May 2021 and April 2022 HAL files, sees the same `press`, `simple_tp`, PID and HostMot2 blocks, and calls them architecturally equivalent.

**Reject.** The 2022 `addf` order moves the hardware read before the cycle/controller pipeline and the hardware write after PID, changing the age of both feedback and output by one thread invocation relative to May.

### Scenario B — “latest” files can be merged?

A reviewer combines the Apr-25 HAL with the Apr-26 component and treats that as the authoritative 2022 config because each is the newest attachment of its type.

**Reject.** The HAL expects `press.overload`; the inspected next-day component does not export that pin. Exact release pairing must be proven, not inferred from dates.

### Scenario C — pressure limit equals functional safety?

A reviewer says the component's state 9 proves tooling-overload protection is safety-rated.

**Reject.** The source proves ordinary realtime pressure-response logic only. Functional-safety performance, sensor architecture, diagnostic coverage, failure probabilities and applicable-machine safety requirements are outside this evidence.

## Precise next-work checkpoint

1. Search for and inspect a public **tandem Y1/Y2** LinuxCNC press-brake implementation with two independent linear scales. Prioritize actual HAL/COMP/source over conceptual forum posts.
2. If no downloadable tandem implementation is found after a bounded search, record that negative result rather than fabricating one from single-ram examples.
3. Preserve the Accurpress evolution series as a 4600 case study: April hybrid -> May standalone correction -> 2022 timing/pressure maturation -> 2024 regular-use report with lingering backstop homing issue.
4. Do not activate F02 until S02/E20/X01/X02 receive genuinely information-separated fresh-AI handoffs.
