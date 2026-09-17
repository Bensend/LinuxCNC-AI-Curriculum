# OpenPressBrake Proportional-Command Change-Impact Application

Date: 2026-09-17
Status: DURABLE CROSS-BOUNDARY SAFETY APPLICATION

## Question

If an ordinary OpenPressBrake proportional-valve command path changes — HAL mapping, transport field, FPGA register/I/O map, freshness/watchdog behavior, ADC/current-loop mapping, or output polarity/default — what safety evidence must be reopened even though the proportional driver is **not** the personnel-safety authority?

This applies `CHANGE_BOUNDARY_ESCAPE_AND_REVALIDATION_SCOPE_WORKSHEET_2026-09-17.md` to the repository's existing `hardware/4300-proportional-current-driver-block.md` contract.

## 1. Existing source-confirmed ordinary-control chain

`SOURCE-CONFIRMED` from the repository contract:

`LinuxCNC current request -> transport generation/freshness -> FPGA watchdog + channel enable -> FPGA current loop -> gate driver -> low-side N-MOSFET -> coil`

Feedback:

`coil current -> Kelvin shunt -> current-sense amplifier -> ADC -> FPGA current loop/diagnostics -> LinuxCNC`

Independent electrical containment:

`hardware overcurrent comparator -> gate disable/latch`

The same contract explicitly separates current request, measured current, spool displacement, hydraulic response, ram motion, and machine safety authority. Therefore none of those downstream physical states may be inferred from the current command alone.

## 2. Safety authority boundary

`SOURCE-CONFIRMED`: the proportional-current block is ordinary actuator control and its watchdog/overcurrent containment is not the personnel-safety authority.

`UNKNOWN`: this curriculum repository does not establish the final machine-specific hydraulic safety architecture, safety-valve truth table, ram/gravity holding mechanism, required stopping behavior, pressure thresholds, or achieved PL/SIL/DC for the target press brake.

Therefore this application does **not** claim that zero proportional current equals a safe ram state.

Required architectural separation:

`ordinary request/current loop` **must remain subordinate to** `independent safety authority -> safety final element(s) -> physical hazardous-energy control`.

## 3. Change case A — HAL command remap/scaling only

Potential escape paths:

- wrong channel receives a valid nonzero command;
- sign/scaling change causes unexpected valve request;
- retained/queued request survives safety demand;
- reset/rearm sequence restores actuator request without a new deliberate command;
- HMI displays one command while another field is transmitted.

Revalidation scope:

- `R1 interface`: command identity, channel mapping, scaling, zero/default, held/stale command, demand-clear-reset-rearm sequence;
- `R2 safety-function` only if HAL also participates in safety reset/mode/permissive/shared feedback dependencies;
- `R3 physical hazard path` if the change affects a physical behavior used by a safety requirement or if safe operation depends on a measured actuator response.

Do not reopen independent safety-controller logic merely because HAL changed **if** independence is positively demonstrated. Do reopen the interface/restart proof that shows ordinary motion cannot become effective merely because safety readiness returns.

## 4. Change case B — transport/register/I/O-map change

This is higher risk than a display-only change because it can alter channel identity, default state, validity, and freshness.

Mandatory tests/evidence:

1. establish producer/consumer field identity end to end;
2. prove each channel's command reaches only the intended current-loop channel;
3. prove invalid/missing generation or stale age removes ordinary gate authority;
4. prove restored communication does not replay a pre-fault nonzero request;
5. prove output defaults remain inactive across FPGA reset/configuration/startup;
6. prove feedback/ADC channel mapping still corresponds to the driven channel;
7. independently verify that safety demand still removes hazardous actuator authority through the actual independent safety path.

Scope: `R1` is mandatory; `R2`/`R3` reopen wherever the mapping crosses a safety/shared dependency or alters the physical path relied upon by a safety function.

## 5. Change case C — watchdog/freshness behavior

A watchdog change can escape the ordinary-control boundary through restart behavior even if the independent safety system never changes.

Adversarial sequence:

`nonzero current command -> communications lost -> watchdog removes ordinary gate authority -> safety demand may occur -> communications recover -> safety reset/rearm -> ?`

Required result:

- stale command does not silently regain authority;
- stale current-loop integrator state does not create the first post-rearm PWM burst;
- explicit ordinary-control rearm/fresh command is required according to the hardware contract;
- safety reset remains distinct from ordinary actuator restart.

`SOURCE-CONFIRMED`: the existing block contract already requires watchdog expiry or stale current feedback to force gate authority OFF, and restoration of Ethernet traffic must not automatically replay a stale nonzero request.

`INFERENCE`: changing that implementation requires revalidation of stale-command/rearm behavior even though the watchdog itself is not safety-rated authority.

## 6. Change case D — ADC/current-feedback map or loop change

Potential escape paths:

- current from channel A is interpreted as channel B;
- stale ADC sample remains marked valid;
- loop integrates stale feedback;
- polarity/gain change drives current away from intended command;
- saturation or fault handling leaves retained integrator state;
- diagnostic display appears healthy while actual current path differs.

Required evidence:

- channel-by-channel stimulus/correspondence;
- VALID/FRESH generation behavior;
- disable/fault/watchdog integrator reconciliation;
- current command versus independently observed current;
- fault path behavior.

Measured current remains evidence only of coil-current behavior. It is not proof of spool position, hydraulic state, or safe ram condition.

## 7. Change case E — output polarity/default/gate-enable change

This reaches the physical electrical actuator path directly.

Mandatory scope includes:

- reset/power-up/configuration default;
- FPGA unconfigured state;
- watchdog state;
- gate-driver UVLO/floating-input behavior;
- hardware overcurrent inhibit behavior;
- explicit rearm;
- real coil-current observation under a bounded test.

This is at least `R1` plus actuator-path physical validation. If the proportional output participates in any machine safety function, the relevant `R2/R3/R4` scope is determined by that actual design; do not invent it here.

## 8. Cross-boundary commissioning sequence

For a changed proportional command path, use this order:

1. **De-energized correspondence** — field/channel identities, register map, connector/coil mapping, safety/ordinary boundary.
2. **Logic without hazardous actuator energy where practical** — command generation, freshness, watchdog, stale/rearm, reset separation.
3. **Bounded electrical actuator test** — intended channel current, feedback correspondence, fault/disable behavior.
4. **Independent safety demand** — verify the safety system still reaches its actual final elements independently of LinuxCNC/normal FPGA command state.
5. **Physical machine validation only to the extent required by the real machine safety design** — no invented hydraulic truth table, stopping distance, pressure, or holding claim.
6. **Power-cycle/comms-recovery test** — no stale command, no automatic hazardous restart.
7. **Return-to-service reconciliation** — remove test forces/jumpers/tools, restore baseline, record remaining UNKNOWNs.

## 9. Key failure-path insight

The ordinary proportional driver can be correctly designed and still create a dangerous **restart request** if stale or remapped commands become effective when independent safety authority returns. Conversely, a perfectly functioning independent safety system does not prove that the ordinary command path will behave correctly after reset.

So commissioning must prove two different properties:

- **Safety authority:** a safety demand independently controls the hazard through the designed safety final elements.
- **Normal-control recovery:** restoration of safety readiness does not itself resurrect an old or malformed ordinary actuator request.

Neither proof substitutes for the other.

## 10. Evidence status / open UNKNOWNs

`SOURCE-CONFIRMED`:
- ordinary command/current-feedback chain and watchdog/rearm requirements from `hardware/4300-proportional-current-driver-block.md`;
- hardware overcurrent containment is independent of the software current loop;
- machine safety authority is external to the proportional block.

`DOC-CONFIRMED`:
- current GuardLogix guidance requires impact analysis/revalidation of affected safety elements and warns that standard-routine timing/tag mapping can affect a safety application;
- Siemens acceptance guidance requires renewed acceptance testing after safety-function changes and treats recorded measurements as typical, not worst-case limits.

`UNKNOWN` until target-machine evidence exists:
- hydraulic safety-valve arrangement and truth table;
- gravity/ram holding path;
- exact independent safety-controller outputs/final elements;
- stopping distance/time and safe-speed/pressure limits;
- required/achieved PL/SIL/DC;
- whether any proportional channel participates in a safety-related control function on the final machine.

## 11. Compute decision

No simulation/build/synthesis is justified for this pass. The question is dependency/revalidation scope, and repository/source evidence is sufficient. No GitHub-hosted Actions minutes or self-hosted runtime were consumed.

## 12. Precise next work

Next, trace a **shared-power/common-connector change** across the OpenPressBrake architecture. The objective is to determine where ordinary and independent safety circuits can acquire a common-cause failure through 24-V distribution, returns, connectors, protection, or shared field wiring, and to turn that into concrete schematic-review rules without pretending shared power automatically violates a safety category.
