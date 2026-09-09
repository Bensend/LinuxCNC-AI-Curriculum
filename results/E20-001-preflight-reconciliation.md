# E20-001 preflight reconciliation

Date: 2026-09-09
Classification: **NON-AUTHORITATIVE PREFLIGHT PASS**
Frozen experiment: `experiments/E20-001-transport-watchdog-recovery-boundaries.md`
Lab job: `lab-jobs/025-e20-transport-watchdog-preflight.sh`
Workflow: `34397554426`, attempt 1
GitHub job: `102620888697`
Artifact: `10122285082`
LinuxCNC target: `v2.9.10`, resolved SHA `86cdca76fa2a36274c432caa21952b23c267989a`

## Classification rule

This run validates the deterministic fixture, atomic recorder, phase sequencing and durable evidence package before an independent authoritative execution. It does **not** score frozen Gates A–J. No threshold, phase or gate was changed after observing the run.

## Independent artifact inspection

The downloaded workflow artifact was unpacked independently of the workflow success status. The retained package includes `atomic.samples`, `e20_model.comp`, `e20.hal`, `predeclared-model.txt`, topology/thread inventories, LinuxCNC revision evidence, build/runtime logs, analysis, and producer-side recorder health.

Producer health reports `sampler-overruns=0`; `halsampler.stderr` is empty. The retained trace contains 1,100 samples with monotonically contiguous sample tags and all P0–P8 phases represented.

Observed retained phase counts were P0=280, P1=1, P2=100, P3=5, P4=100, P5=100, P6=100, P7=100, P8=314. P0 begins before recorder enable, so its retained count being lower than the fixture's 300-cycle phase length is expected and does not alter any discriminator.

## Frozen-predicate verification

- P1: exactly one isolated transport error is retained; current-error asserts, cumulative total increments, level becomes 2, `io_error` remains false, and motion authorization is revoked.
- P2: on the first clean sample the current error clears and level decays by exactly one to 1; authorization remains revoked even as the level later drains to zero.
- P3: five consecutive errors produce levels 2,4,6,8,10. `io_error` and the exceeded indication assert at the fifth error, not before, while authorization remains revoked.
- P4: the explicit driver-level clear returns current/level/exceeded/`io_error` to clean state but does not restore machine authorization.
- P5: current transport is clean while the synthetic watchdog is bitten; physical-I/O authority is false, the internal generator counter continues increasing, and motion remains unauthorized.
- P6: modeled driver/board soft-reset completion clears `needs_soft_reset`, physical-I/O authority is restored and transport remains clean, but `state_revalidated` is still false and motion remains unauthorized. This is intentional: the driver/board reset latch and machine-state revalidation are different layers.
- P7: only explicit state revalidation plus reauthorization request restores authorization under otherwise-clean conditions.
- P8: a new transport error independently revokes authorization again.

The P6 distinction was rechecked against the retained component source rather than inferred from output: `needs_soft_reset` models driver/board recovery and is intentionally cleared in P6; `state_revalidated` remains a separate false signal until P7. Therefore the apparent `needs_soft_reset=0` before revalidation is not a hidden gate relaxation.

## Evidence boundary

The fixture is a deterministic software model grounded in the pinned hm2_eth/HostMot2 source analysis. Its synthetic watchdog, physical-I/O and state-revalidation witnesses are not claims that LinuxCNC or Mesa hardware exports those exact signals. The preflight does not establish Ethernet physics, exact Mesa-output timing, functional safety, or automatic machine-state validity after transport/watchdog recovery.

## Decision

**PREFLIGHT PASS.** The evidence-retention and runtime harness are fit for one separate authoritative run using the unchanged frozen numeric contract (`limit=10`, increment `2`, decrement `1`), unchanged P0–P8 semantics and unchanged Gates A–J. The authoritative result must be scored only from its independently retained artifact; workflow success alone is insufficient.
