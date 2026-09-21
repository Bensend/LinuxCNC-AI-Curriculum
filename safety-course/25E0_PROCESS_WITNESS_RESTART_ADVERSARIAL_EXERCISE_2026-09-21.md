# 25E0 adversarial exercise — process witness is not universal safe-state proof

Date: 2026-09-21

## Scenario

A vertical machine axis has a safety-rated drive function monitoring motor speed during an SS1 stop. The monitored speed falls below the configured shutdown threshold and STO becomes active. A brake-command output is also off. The ordinary CNC `cycle-start` input has remained physically asserted throughout the stop. No evidence has yet been supplied for brake holding torque, load motion after STO, or another stored-energy path.

An engineer proposes: `safe_speed_below_threshold && STO_active` should be mapped to `machine_safe`, and automatic production should resume whenever safety permission later returns because Cycle Start is already high.

## Required reasoning

1. Identify which facts are actually supported by the speed witness.
2. Identify at least four claims the speed witness does not establish.
3. Explain why STO can be an incomplete or even hazardous final action on a gravity-loaded axis without a validated retaining mechanism.
4. Explain why a continuously asserted ordinary Cycle Start is a separate demand-freshness problem even after the safety system validly rearms.
5. Propose a typed diagnostic/status model that preserves the independent safety boundary instead of creating one generic `machine_safe` bit.

## Evaluation key

A competent answer should separate at least these states:

- safety motion witness: configured speed/standstill criterion;
- safety torque state: STO or equivalent;
- retaining-element witness: brake/final element status where applicable;
- process/mechanical witness: actual load motion or other design-required evidence where applicable;
- stored-energy witness: pressure/energy state if relevant;
- safety reset/rearm state;
- ordinary controller production gate;
- ordinary demand freshness (`fresh_start_required`, edge/latched/held classification).

It must reject `speed threshold reached => every hazardous energy path safe` and reject `safety permission restored + held Cycle Start => automatically fresh start` unless the actual validated machine design explicitly establishes those semantics.

The exercise intentionally supplies no stopping distance, pressure threshold, brake torque, or machine-specific hydraulic truth table. Inventing one is a failure.
