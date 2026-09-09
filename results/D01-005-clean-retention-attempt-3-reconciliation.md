# D01-005 — Clean retention attempt 3 artifact reconciliation

Status: **PREFLIGHT EVIDENCE-RETENTION PASS / AUTHORITATIVE RUN PERMITTED**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Workflow `34369209171`, artifact `10111283068`, completed successfully from curriculum commit `2a838e587affe812940a4f473f408498221f5917`.

## Independent artifact-level inspection

The downloaded artifact, rather than live runner assertions, was inspected. It contains the full nested evidence package beneath the uploaded run tree, including:

- `atomic.samples` (249,555 bytes; 2,200 rows),
- nonempty `observer.patch` (2,076 bytes),
- `linuxcnc-commit.txt` containing the pinned SHA,
- `d01.ini` and `d01.hal`,
- `topology.txt` and `thread.txt`,
- LinuxCNC stdout/stderr,
- empty `halsampler.stderr`,
- `recorder-health.txt` with `sampler-overruns=0`, and
- `inventory.txt` enumerating the retained package.

The retained summary witnesses reproduce the frozen numeric fixture without retuning: aligned Y commands/feedback settle at 10; low duplicate-only offset `0.020` produces duplicate ferror `-0.02` below limit `0.05`, no duplicate following-error fault, Cartesian Y 10 and motion enabled; high offset `0.200` produces principal ferror 0, duplicate ferror `-0.2`, duplicate fault true, Cartesian Y 10 and motion disabled.

## Offline stream checks

Fresh offline parsing of the retained `atomic.samples` found exactly 2,200 rows with integer sample indices 0 through 2199 and no discontinuity. The run's retained analysis reports phase-before-mutation witnesses (`p3-pre=23`, `p5-pre=23`), low hidden-divergence witnesses (`low-hidden=50`, `cart-low=50`), high-trip/principal-clean/disabled witnesses (`high-trip=57`, `principal-clean=57`, `disabled=57`), and duplicated-command witnesses (`cmddup=998`). Producer overruns are zero.

This resolves the only defect remaining after attempt 2: the evidence is now actually present in the published Actions artifact. No runtime threshold, topology, command path, observer placement, phase semantics, or frozen gate was changed.

## Decision

The clean evidence-retention lineage passes at its third and final materially similar attempt. D01-002 Gates A–J remain **UNSCORED for this preflight**, exactly as frozen. A separate independent workflow execution may now be used as the authoritative D01 run. It must use the unchanged P0–P8 semantics, offsets `0.020/0.200`, ferror limit `0.050`, topology, realtime observer and recorder ordering. Gates must be scored only from that authoritative run's retained artifact, not from live assertions.
