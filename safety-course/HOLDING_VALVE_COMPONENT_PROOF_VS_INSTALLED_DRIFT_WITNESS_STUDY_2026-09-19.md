# Holding-valve component proof vs installed drift witness study

Date: 2026-09-19

## Why this follow-on exists

The preceding study found a professional off-machine individual holding-valve test. The remaining question was whether professional maintenance practice also preserves an installed physical load/motion witness rather than treating the bench result as sufficient.

## Authoritative professional evidence

Terex Utilities Tech Tip 227, *Inspection Forms* (released 2025-10-22, v1.0), lists `Holding Valves / Locks (Drift Test)` as an inspection item. Terex's 2026 factory workshop description likewise identifies both `Verify holding valve settings` and `Cylinder drift testing` as distinct hands-on tasks in its professional technician training.

Sources:

- https://www.terex.com/docs/librariesprovider7/tech-tips/techtip_227.pdf
- https://www.terex.com/utilities/en/support/training/workshops

These sources are not press-brake procedures and supply no OpenPressBrake threshold.

## Evidence classification

### DOC-CONFIRMED

- Professional hydraulic maintenance practice can treat holding-valve setting verification and installed cylinder drift testing as distinct tasks.
- A current Terex inspection form explicitly associates holding valves/locks with a drift test.

### INFERENCE

- This supports the curriculum's witness separation: component setting/reset proof and installed load-motion behavior answer different questions and neither should silently substitute for the other.
- The installed drift witness can expose behavior that an isolated component test cannot, such as installation/circuit/cylinder effects, but it does not by itself identify which element caused drift.

### TEST-CONFIRMED

None for OpenPressBrake.

### UNKNOWN

All press-brake-specific drift limits, load, ram position, duration, instrumentation, temperature, pressure state, allowable motion, valve isolation method, failed-test disposition, and relation to stopping-performance testing.

## Durable freeze

`INDIVIDUAL HOLDING-VALVE SETTING/RESET PASS != INSTALLED CYLINDER/LOAD DRIFT PASS != DYNAMIC STOPPING PERFORMANCE PASS != PRODUCTION AUTHORITY`

and

`INSTALLED DRIFT FAIL != FAILED COMPONENT IDENTIFIED`.

## Curriculum architecture

For a multi-retaining-element gravity-loaded machine, teach the evidence stack as separate questions:

1. Was the load independently restrained for service?
2. Was the serviced retaining component itself proved by its approved component procedure?
3. After reassembly, does the installed machine physically retain the load within its OEM criterion?
4. Are dynamic stopping performance and protective-device response valid where required?
5. Have faults been dispositioned and safety authority deliberately restored before a fresh ordinary start?

The Terex sources support the existence and separation of questions 2 and 3 in professional hydraulic practice. They do not answer the press-brake-specific implementation of either.

## Compute

No compute justified or used.

## Next

Continue the primary source search for a press-brake OEM/manifold procedure that supplies the missing machine-specific values and connects valve service to installed ram/load retention, failure disposition, dynamic stopping re-proof where applicable, rearm, and fresh production start.
