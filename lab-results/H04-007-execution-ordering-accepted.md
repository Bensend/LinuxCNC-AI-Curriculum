# H04 lab 007 accepted result — HAL execution ordering

Pinned LinuxCNC revision under test: `8bf4605ae81042248add031e94c77300406e0413`

Curriculum SHA: `f15451ee92f7f5d82310f6f182b20cdf10b51418`

GitHub Actions run: `34024102367`

Job: `101461896527`

Artifact: `linuxcnc-lab-007-h04-execution-ordering-34024102367-1`

Artifact digest: `sha256:909a80e44cdafd944c8d7753da8bf8917b6b2c4e160e7f324deb804db74f349c`

Lab UTC window: `2026-09-06T09:14:59Z` to `2026-09-06T09:19:17Z`

Exit code: `0`

## Freshness / identity

Artifact metadata names `lab-jobs/007-h04-execution-ordering.sh`, records the intended curriculum SHA `f15451ee92f7f5d82310f6f182b20cdf10b51418`, and records workflow run `34024102367` attempt 1. The LinuxCNC checkout log reaches pinned revision `8bf4605ae...`.

## Acceptance-gate reconciliation

### 1. Phase-1 configured order

`show thread` reported:

1. `sum2.0`
2. `sum2.1`

The script's parsed line check also recorded `phase1-lines: sum2.0=4 sum2.1=5`, confirming A-before-B in the same HAL thread.

**PASS.**

### 2. Non-reentrant duplicate rejection

Attempting to add `sum2.0` a second time returned `duplicate-add-rc=1`. Stderr contained the expected LinuxCNC diagnostic:

`HAL: ERROR: function 'sum2.0' may only be added to one thread`

followed by `addf failed`.

This stderr is expected negative-test output, not a harness failure.

**PASS.**

### 3. Phase-1 same-cycle dataflow

With `sum2.0` before `sum2.1`, the order-sensitive feedback network reached:

- `A=37`
- `B=38`
- `B-A=1.000000`

This is the predeclared directional relationship for A-before-B and therefore verifies actual sequential dataflow, rather than merely trusting displayed list order.

**PASS. TEST-CONFIRMED for this pinned software/host.**

### 4. `hal stop` dispatch gate

While stopped, the threadbeat observations were:

- first = `19`
- second = `19`

The periodic task remained part of the configured thread model, but cyclic dispatch did not advance the completed-pass counter while the shared HAL run gate was clear.

**PASS. TEST-CONFIRMED for this pinned software/host.**

### 5. Delete and re-add while stopped

The experiment deleted `sum2.1` and successfully re-added it at position `+1`. This exercises the source-traced `funct->users` decrement/reuse path after deletion without making any claim about concurrent live list mutation.

**PASS.**

### 6. Phase-2 configured order

After the stopped reconfiguration, `show thread` reported:

1. `sum2.1`
2. `sum2.0`

The parsed line check recorded `phase2-lines: sum2.0=5 sum2.1=4`, confirming B-before-A.

**PASS.**

### 7. Phase-2 same-cycle dataflow

After restart with reversed ordering, the network reached:

- `A=77`
- `B=76`
- `A-B=1.000000`
- `threadbeat=39`

Reversing only the intra-thread function order reversed the one-cycle relationship exactly as predicted. Threadbeat also advanced after restart.

**PASS. TEST-CONFIRMED for this pinned software/host.**

### 8. Completion marker

`H04 HAL execution-order observation completed successfully.` was present and the artifact exit code was 0.

**PASS.**

## Accepted H04 runtime claims

For this pinned LinuxCNC revision and non-realtime CI host:

1. Functions scheduled in one HAL thread execute in the configured list order strongly enough for a later function in the same pass to observe a value written by an earlier function.
2. Reversing the order of two order-sensitive functions reverses the observed same-cycle dataflow relationship.
3. A non-reentrant exported function cannot simultaneously be added again while already in use by a thread; deletion releases the user accounting sufficiently for later re-add in the tested stopped configuration.
4. `hal stop` suppresses cyclic function dispatch/threadbeat advancement without implying destruction of the periodic RTAPI task; restart resumes cyclic dispatch.

## Claims explicitly NOT promoted

- No cross-thread total ordering is inferred.
- No cross-CPU memory-ordering guarantee is inferred.
- No deadline, latency, jitter, or physical-machine realtime qualification is inferred from this POSIX non-realtime runner.
- No safety certification or fail-safe property is inferred.
- No claim is made that `addf`/`delf` mutation while cyclic dispatch is active is race-free or supported. That question remains 2000/HIGH.

## Evidence status

H04's central 1000-level within-thread ordering model now has both pinned-source support and an order-sensitive bounded runtime experiment. The tested subset is promoted to `TEST-CONFIRMED` with the boundaries above.