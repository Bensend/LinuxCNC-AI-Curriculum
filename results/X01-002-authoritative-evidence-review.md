# X01-002 authoritative evidence review

## Identity

- Module: X01 — recorder perturbation and long-duration retention, 2000 level
- Frozen contract: `experiments/X01-002-sampler-retention-redesign.md`
- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Authoritative workflow: `34436256547`
- Job: `102741829103`
- Source commit: `e2f25c5f873d9683e36430142de5cad3fc9350a8`
- Retained artifact: `10136342576`
- Artifact digest: `sha256:b7a8d68eaae7633bdd5a890519b70fdd7f5abf7b1eaa27a332b9d7ac7bc74960`
- Job start/end: `2026-09-10T04:12:20Z` / `2026-09-10T04:16:18Z`
- Exact job runtime: 238 s = 3.97 min
- Inner lab start/finish: `04:12:23Z` / `04:16:11Z`
- Result: **AUTHORITATIVE PASS; frozen Gates A–J PASS 10/10**

The green workflow status was not used as the oracle. Artifact `10136342576` was downloaded and its raw X01 evidence was independently inspected.

## Raw evidence audit

### P0 — provenance/topology

The artifact retains the pinned LinuxCNC commit, predeclared model, HAL configurations, source component, thread snapshots, sampler/source pin inventories and evidence inventory. `linuxcnc-commit.txt` contains exactly:

```text
8bf4605ae81042248add031e94c77300406e0413
```

The frozen model records a 1 ms servo period, 2,000-record baseline, FIFO depth 64 for forced starvation, X01-002 P0–P5/Gates A–J, and the predeclared P5 count of 10,000.

### P1 — healthy baseline

Independent raw-trace inspection:

- exactly 2,000 retained rows;
- stream tags `0..1999`, unit-contiguous;
- deterministic payload counter starts at 18 and ends at 2017, unit-contiguous;
- `baseline-health.txt`: `overruns=0`, `full=FALSE`;
- source counter continued beyond the retained window as expected (`2044`).

### P2 — bounded stop/drain

- stop boundary: source counter `373`, remaining FIFO depth `354`;
- exactly 354 rows were then retained;
- terminal retained deterministic payload counter = `370`;
- difference from stopped source counter = 3 cycles, inside the frozen `0..3` scheduler/observation tolerance;
- after drain: `curr-depth=0`, `overruns=0`, `full=FALSE`.

This validates the bounded stop-then-drain lifecycle without pretending independent `halcmd getp` reads are atomic with the realtime function.

### P3 — forced recorder loss

Before drain:

- `curr-depth=64`, `full=TRUE`;
- producer overruns = `192`;
- deterministic source counter = `282`.

After the bounded read:

- producer overruns = `206`;
- source counter = `473`;
- 220 retained data rows;
- zero consumer `overrun` marker lines;
- zero `-t` tag gaps;
- **one deterministic payload discontinuity**.

Independent parsing located the payload jump after retained row/tag 62: deterministic source payload **79 -> 286**, a +207-cycle jump, while the stream tags remain consecutive. This is exactly the X01-002 discriminator: recorder records were dropped during FIFO saturation, yet the deterministic realtime producer continued to advance. The observation does **not** justify claiming a control-loop cycle skip.

### P4 — recorder-width timing observation

Both bounded timing captures retained 2,000 rows with zero producer overruns.

- narrow: `servo-thread.time=251`, `servo-thread.tmax=2855`;
- wide: `servo-thread.time=400`, `servo-thread.tmax=3196`.

These are quantitative observations from this cloud/readonly fixture only. They do not prove zero perturbation, a causal width cost of a particular amount, or production-machine deadline safety.

### P5 — predeclared sustained proof

`sustained-contract.txt` confirms `predeclared-sustained-samples=10000`.

Independent raw-trace inspection found:

- exactly 10,000 retained rows;
- stream tags `0..9999`, unit-contiguous;
- deterministic payload begins `19,20,21` and ends `10016,10017,10018`, unit-contiguous throughout;
- zero consumer overrun markers;
- `sustained-health.txt`: `overruns=0`, `full=FALSE`.

This passes the bounded sustained-publication requirement chosen before the authoritative run. It is a 10,000-cycle software retention proof, not a claim of indefinite or power-loss-safe logging.

## Frozen Gates A–J

| Gate | Result | Evidence |
|---|---|---|
| A provenance/topology retained | PASS | pinned SHA, predeclared model, HAL/thread/pin/source evidence retained |
| B healthy baseline exact/contiguous/no overrun | PASS | 2,000 rows, tags and deterministic payload contiguous, producer overruns 0 |
| C bounded stop/drain integrity | PASS | drained exactly 354 residual rows; terminal payload within frozen 3-cycle boundary; FIFO ends empty |
| D forced FIFO saturation demonstrated | PASS | depth 64/full TRUE and producer overruns >0 |
| E loss visible in correct X01-002 oracle | PASS | deterministic payload gap 79->286 while producer overrun counter is nonzero |
| F source/control execution not conflated with recorder loss | PASS | source counter advances 282->473 through loss window; conclusion remains recorder-loss-only |
| G stream-tag behavior characterized without false requirement | PASS | retained `-t` tags remain contiguous; no claim that this disproves dropped producer records |
| H bounded recorder timing/width evidence retained | PASS | 2,000-row narrow/wide captures, zero overruns, thread time/tmax retained |
| I sustained proof predeclared and passed | PASS | frozen 10,000-row count, contiguous stream/payload, zero producer overruns |
| J inference/scope boundary preserved | PASS | no control-loop-skip, hardware, indefinite-retention, or production deadline claim is inferred |

Score: **10/10**.

## Prediction reconciliation

The original X01-001 prediction that FIFO loss would necessarily produce a later `halsampler -t` discontinuity was falsified during the first lineage. X01-002 correctly froze the repaired prediction before this authoritative run: producer overrun plus a deterministic sampled payload discontinuity is the loss oracle, while `-t` is only ordering evidence for successfully retained stream records. The authoritative result matched that redesigned prediction.

## Source reconciliation

Pinned `src/hal/components/sampler.c::sample()` snapshots configured pins and calls `hal_stream_write()`. If that write fails, its own comment states the FIFO is full/data is lost, and the component increments `sampler.N.overruns`, sets `full`, and reports max depth. The realtime function does not increment the exported `sampler.N.sample-num` pin in the inspected path.

Pinned `src/hal/components/sampler_usr.c::main()` attaches to the HAL stream, waits for readability, receives `this_sample` from `hal_stream_read()`, performs a continuity check on that returned number, and prints `this_sample-1` for `-t`.

The authoritative P3 result is therefore important version-specific evidence: although the userspace continuity checker is real, this particular producer-full/drop behavior did not create a discontinuity in the sequence returned for successfully retained records. Teaching `-t` alone as a complete producer-loss oracle would be wrong for this tested revision/model.

## Failure-path / adversarial conclusions

1. **Clean-looking `-t` tags do not prove recorder integrity.** Producer health and an independent deterministic payload/timing witness are required for the stronger claim.
2. **Producer overrun does not prove missed control cycles.** It proves a recorder write failed; underlying execution must be established independently.
3. **Killing the userspace reader is a different failure from FIFO producer loss.** Stop production, preserve boundary evidence, and boundedly drain when terminal evidence matters.
4. **A 10,000-row clean run is bounded evidence.** It does not establish infinite retention, filesystem durability, power-loss behavior, or safety-rated logging.
5. **Width/timing numbers are environment-specific observations.** Do not convert the cloud fixture's `time/tmax` into a production deadline guarantee.

## Graduation state

The laboratory portion of X01 is technically accepted. X01 still requires the curriculum's adversarial-exam/corrections and genuinely fresh-AI handoff requirements before the module can be labeled graduated. X02 requires **accepted X01 recorder perturbation evidence**; the authoritative technical evidence needed for that dependency now exists, but repository state should preserve whether the graph interprets “accepted” as technical acceptance or full graduation.

## Precise next work

Freeze an X01 adversarial exam against the corrected source/experiment model before answering it. It must include at least: a misleading clean-`-t` premise, the pinned `sample-num`/implicit-stream version trap, a producer-full failure-path trace, and a small configuration/code task that preserves recorder-health evidence. Then incorporate any corrections. Prepare a fresh-AI handoff package without self-certifying it.
