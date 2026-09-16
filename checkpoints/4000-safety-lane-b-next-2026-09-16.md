# 4000 Safety Lane B Checkpoint — 2026-09-16

Status: ACTIVE

## Durable state

Independent lane added `safety-course/DIAGNOSTIC_BLIND_SPOTS_LATENT_FAULT_ACCUMULATION_WORKSHEET.md` at commit `2c9b46f4a2347e6f696051d1e0cdd135042b62c0`.

Frozen rule: **`no diagnostic fault` is not proof that the physical safety path is healthy. A diagnostic is evidence only for the path it actually stimulates and observes.**

The worksheet separates continuously detected faults, state-change/demand diagnostics, startup/restart challenges, deliberate proof tests, and potentially latent faults. It forces a latent-first-fault/second-fault analysis and a full `test request -> physical stimulus -> sensing element -> electrical channel -> diagnostic logic -> independent observation -> decision` trace.

## Parallel-work reconciliation

Before selection, current `main` showed primary safety work at `d0071a58f0d565116099ad1fdb178c3647b39d03`, immediately after `safety-course/ENERGY_ISOLATION_VERIFICATION_WITNESS_DESIGN.md`. The primary checkpoint's precise next work is temporary re-energization for testing/positioning during maintenance, including the OSHA 1910.147(f)(1) sequence, clearing personnel/tools, bounded re-energization, deenergization/reapplication of controls, stale jog/remote commands, changed stored/gravity energy, group coordination, and repeated-cycle adversarial cases.

Lane B therefore did not create or modify temporary re-energization, lockout sequence, maintenance positioning, energy-isolation witness, or primary-checkpoint artifacts. It followed the existing Lane-B checkpoint and created a new latent-fault diagnostics file.

After the Lane-B artifact commit, `main` was re-read. `2c9b46f4a2347e6f696051d1e0cdd135042b62c0` was head with parent `d0071a58f0d565116099ad1fdb178c3647b39d03`; no overlapping primary-lane file changed during the run.

## Evidence frozen

- `SOURCE-CONFIRMED`: OSHA 29 CFR 1910.147(c)(1) requires procedures, training, and periodic inspections as part of the energy-control program.
- `SOURCE-CONFIRMED`: 1910.147(c)(4)(ii)(D) requires requirements for testing to determine/verify effectiveness of energy-control measures; (d)(6) requires verification of isolation/deenergization before work.
- `SOURCE-CONFIRMED`: 1910.147(d)(5)(ii) requires continued verification where hazardous stored energy can reaccumulate, illustrating that a prior safe observation may not remain fresh indefinitely.
- `SOURCE-CONFIRMED`: OSHA enforcement guidance treats periodic inspection as an essential check on continued procedure effectiveness/utilization and requires correction of deficiencies.
- `SOURCE-CONFIRMED`: OSHA's 2008 PLC interpretation warns against treating ordinary PLC control as hazardous-energy protection for servicing absent the narrow, case-specific minor-servicing effective-protection demonstration.
- `INFERENCE`: a component stuck in the state currently expected can remain latent if diagnostics never cause and independently observe the state change that would expose it.
- `INFERENCE`: redundant channels can both pass a common inadequate diagnostic; agreement does not establish independence.
- `UNKNOWN`: OpenPressBrake diagnostic coverage, proof-test intervals, stopping distances, hydraulic truth tables, safe speeds/pressures, and other physical acceptance values remain unknown until justified by device documentation, engineering analysis, and/or physical test.

LinuxCNC/HAL, ordinary FPGA logic, HMI and network diagnostics remain useful normal-control/diagnostic participants, not independent personnel-safety authority.

No executable verification was justified, so no compute was consumed.

## Precise next independent work

If still independent of the primary lane, build a **proof-test stimulus and observability matrix**.

For representative cross-machine safety-significant sensors and final elements, require:
1. the exact failure mode/question being challenged;
2. the minimum physical stimulus needed to expose it;
3. the independent observation/witness needed to support the claim;
4. which software-only/same-path observations are insufficient;
5. safe test preconditions and personnel/hazard boundary;
6. stale-state/session/configuration invalidation rules;
7. bounded pass conclusions and explicit claims the test cannot prove;
8. handling for tests that cannot safely be automated at startup;
9. common-cause cases where redundant channels receive one inadequate stimulus;
10. `UNKNOWN` machine-specific acceptance values rather than invented intervals, diagnostic percentages, pressure/speed thresholds, stopping distances, or hydraulic behavior.

Keep this independent of the primary lane's temporary re-energization/maintenance-positioning lesson. If the primary lane occupies proof-test stimulus/observability before the next run, switch to a distinct **fault-reset causal-clearance / recurring-fault escalation** study using different files and evidence artifacts.