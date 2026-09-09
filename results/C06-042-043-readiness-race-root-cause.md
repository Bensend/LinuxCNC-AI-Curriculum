# C06 Observation-Harness Root Cause — C06-042 / C06-043

## Classification

**HARNESS ROOT CAUSE CONFIRMED; NON-AUTHORITATIVE.** Frozen C06-030 Gates A–H remain unchanged and were not scored by these diagnostics.

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## What C06-037/038 appeared to show

C06-037 and C06-038 both reached a userspace error:

```text
hal_stream_attach: Invalid argument
```

C06-038 attempted to correct an assumed early-attach race by waiting for these commands to return success:

```bash
halcmd show pin hm2_test.0.watchdog.has_bit
halcmd show param hm2_test.0.io_error
halcmd show pin sampler.0.pin.9
halcmd show pin sampler.0.enable
```

The harness redirected the output to `/dev/null` and interpreted command exit status as object existence.

## Why that readiness predicate was invalid

Pinned `halcmd(1)` documents `show` as a display command. It does not define a successful command exit as proof that a requested pattern matched an object. Runtime diagnostics then showed the practical consequence: `halcmd show ...` could complete successfully while the output contained no matching pin/parameter.

The retained C06-039 pre-attach snapshot showed only the transient userspace `halcmd` component in `show comp`, with no sampler pins/params yet, even though the old readiness predicate had already declared success. The `halrun` process itself was still alive. C06-042 reproduced the stronger failure case: its first attach failed and the failure snapshot had no sampler/HostMot2 objects and no sampler shared-memory key at all.

Therefore the previous predicate tested **“did `show` execute?”**, not **“does this HAL object exist?”**.

## Pinned halrun lifecycle

Pinned `scripts/halrun.in` starts realtime, runs its interactive `halcmd -kf` command interpreter, then after that interpreter exits it executes:

```text
halcmd stop
halcmd unload all
REALTIME stop
```

This matters because an attach attempted before command-stream initialization has completed can observe absent/partial stream state, while a later snapshot can also catch teardown. `hal_stream_attach: Invalid argument` was therefore downstream evidence; it did not identify the first failed precondition.

## Why C06-039 and C06-041 are now treated cautiously

C06-039's exact sampler attach did return 10 rows, and C06-041's fixture-only stage also returned 10 rows. But their readiness checks were still the invalid exit-status form. C06-041's second stage failed, and C06-042's nominal baseline failed before any topology mutation. These apparently contradictory outcomes are expected from a startup race whose timing changes between runs; they are **not** reliable evidence that a particular P0 net or HostMot2 topology invalidates a stream.

Consequently:

- C06-039 remains useful evidence that the exact stream shape is not inherently rejected, but it is **not** sufficient proof of a live-producer readiness barrier.
- C06-041's Stage-A/Stage-B contrast is **teardown/startup timing confounded** and must not be used to attribute causality to P0 topology.
- C06-042 falsifies a stable “specific P0 mutation corrupts the stream” interpretation because failure happened at the nominal baseline before the planned mutations.

## Correct readiness contract

C06-043 changed only the preflight observation barrier. It repeatedly captured full HAL listings and required the exact requested names to appear, while also requiring the `halrun` PID to remain alive:

```text
sampler.0.pin.9
sampler.0.enable
hm2_test.0.watchdog.has_bit
hm2_test.0.c06.fail-reads-remaining
hm2_test.0.io_error
sampler.0 realtime function
```

Only after those names were observed did it run userspace `halsampler`.

## C06-043 result

Workflow `34311305551`, source commit `ed1307af14d3f3d7a550109585b9ad4eb4843651`, against the accepted C06-036 fixture and complete static P0 topology:

```text
ready=1 halsampler_rc=0 parseable_rows=20 overruns=0
PREFLIGHT PASS: real object readiness + accepted fixture + full static P0 topology + exact sampler attached and retained data.
```

This confirms the corrected readiness contract and reconciles the prior apparent stream failures as harness startup races. It does not itself test P1–P6 fault behavior.

## Authoritative consequence

A new authoritative C06-030 run is justified only with:

1. the same accepted fixture;
2. frozen P0–P6 semantics and Gates A–H unchanged;
3. actual-name readiness proof, not `show` exit status;
4. live `halrun` proof;
5. at least 50 retained baseline realtime rows before P1 begins;
6. one atomic sampler stream for all decisive state.

`lab-jobs/044-c06-authoritative-real-readiness.sh` implements only that harness correction from the clean redesigned C06-037 base. Any result must still be reconciled against the frozen gates before C06 can advance.
