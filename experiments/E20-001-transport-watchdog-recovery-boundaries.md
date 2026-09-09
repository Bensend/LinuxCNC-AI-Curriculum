# E20-001 — frozen transport/watchdog recovery-boundary experiment

Date frozen: 2026-09-10
Status: **FROZEN BEFORE IMPLEMENTATION**
Model target: LinuxCNC v2.9.10/current-lineage hm2_eth soft-error semantics plus a deliberately separate synthetic HostMot2-watchdog state.

This experiment does **not** emulate Ethernet physics, Mesa firmware, physical stopping performance, or 2.7-era fixed-200-ms timing. It tests whether the learner preserves the correct state/authority distinctions implied by current-lineage source.

## Source-pinned numeric contract

The deterministic fixture will use the v2.9.x default error-accumulator values:

- `packet-error-limit = 10`;
- `packet-error-increment = 2`;
- `packet-error-decrement = 1`;
- realtime sample period = **1 ms**;
- each normal phase = **100 cycles** unless a phase explicitly ends on a predeclared state transition.

The numeric defaults are source-backed configuration values, not a claim that every real installation leaves them unchanged.

## Model inputs and state

Inputs:

- `transaction_error` — synthetic current-cycle hm2_eth receive/confirmation failure;
- `io_error_clear_request` — synthetic external clear corresponding to HAL/userspace clearing `io_error` after saturation;
- `watchdog_bitten` — synthetic board-watchdog state, intentionally independent of the transport-error input;
- `state_revalidated` — synthetic machine-level state/homing/interlock revalidation witness;
- `reauthorize_request` — explicit machine-level request to permit motion after recovery.

State/outputs:

- `packet_error_current`;
- `packet_error_total`;
- `packet_error_level`;
- `packet_error_exceeded`;
- `io_error`;
- `needs_soft_reset`;
- `physical_io_authority`;
- `internal_generator_state` / `internal_generator_counter`;
- `transport_current_good`;
- `machine_motion_authorized`;
- phase and monotonically increasing sample tag.

Model rule: a transaction error applies `+2` to error level, saturating at 10; a clean transaction applies `-1`, floor 0, and clears the current-cycle packet-error flag. Reaching 10 asserts `io_error` and `packet_error_exceeded`. If level is saturated and an explicit clear request clears `io_error`, the model resets the accumulator before processing the following receive cycle, mirroring the v2.9.x recovery interaction. `needs_soft_reset` latches once a soft error occurs until the explicit modeled driver/board recovery step.

Watchdog/physical-I/O state is intentionally a distinct synthetic state machine. Internal generator state continues to advance even while `physical_io_authority == FALSE` during the watchdog-bite phase.

Machine motion authorization is latched false on any transport fault, `io_error`, watchdog bite, or loss of physical I/O authority. It may become true again **only** when transport/driver recovery is complete, physical I/O authority is restored, `state_revalidated == TRUE`, and an explicit `reauthorize_request == TRUE` occurs.

## Frozen phases

### P0 — clean baseline

Precondition: level 0, no error, watchdog clear, physical I/O authority true. Establish clean transport and a known initially authorized baseline. No diagnostic/fault state may assert.

### P1 — isolated soft packet error below limit

Inject exactly one transaction error. Expected same-cycle state:

- `packet_error_current = TRUE`;
- `packet_error_total` increments by 1;
- `packet_error_level = 2`;
- `needs_soft_reset = TRUE`;
- `io_error = FALSE`;
- motion authorization becomes FALSE.

This phase proves a soft packet error need not immediately equal hard `io_error` saturation.

### P2 — one clean cycle after P1

Inject a clean transaction immediately after P1. Expected first clean sample:

- `packet_error_current = FALSE`;
- `packet_error_level = 1`;
- `io_error = FALSE`;
- motion remains unauthorized.

This is the key adversarial discriminator: **current-cycle clean does not erase accumulated history or authorize motion.** Continue clean cycles until the level reaches zero, but do not reauthorize.

### P3 — repeated errors to saturation

From level zero, inject five consecutive transaction errors. With increment 2 and limit 10, the fifth error must produce:

- `packet_error_level = 10`;
- `packet_error_exceeded = TRUE`;
- `io_error = TRUE`;
- motion unauthorized.

No threshold may be retuned after execution.

### P4 — explicit `io_error` clear / driver recovery interaction

While saturated, issue `io_error_clear_request`; on the next modeled receive/recovery cycle, reset the saturated communication-error counter and process a clean transaction. Expected driver-side recovery evidence:

- level returns to 0 under the modeled source interaction;
- current packet error is false;
- `io_error` is false;
- `packet_error_exceeded` is false.

**Machine motion must remain unauthorized.** P4 exists to falsify the unsafe rule `io_error == FALSE -> motion allowed`.

### P5 — watchdog bite separate from current transport fault

Set `watchdog_bitten = TRUE` while presenting a clean current transport transaction. Expected:

- `physical_io_authority = FALSE`;
- internal generator counter continues changing;
- current packet error may remain false;
- motion unauthorized.

This phase demonstrates that a clean/current host transaction and changing internal generator state do not prove physical output-pin authority.

### P6 — board I/O authority restored, machine state not revalidated

Clear the watchdog and perform the modeled board/driver soft-reset completion so physical I/O authority returns true and `needs_soft_reset` clears. Keep `state_revalidated = FALSE`.

Expected: transport can be clean, `io_error` false, watchdog clear and physical I/O authority true while **motion remains unauthorized**.

### P7 — explicit state revalidation and reauthorization

Assert `state_revalidated = TRUE`, then assert `reauthorize_request = TRUE` only after all transport/driver/board conditions are good.

Expected: `machine_motion_authorized` becomes true only at this explicit final transition.

### P8 — adversarial relapse

After reauthorization, inject one fresh transport error. Expected: authorization revokes in the same modeled realtime cycle and does not remain true because of prior P7 validation.

## Frozen Gates A–J

| Gate | Acceptance requirement |
|---|---|
| A | One atomic realtime stream retains phase, all declared inputs/state/outputs and a monotonic sample tag; producer-side recorder-health evidence shows zero overruns before exact latency/state-transition claims are accepted. |
| B | P0 is clean and internally consistent: level 0, current error false, `io_error` false, watchdog clear, physical authority true. |
| C | P1's single error produces level exactly 2 and current packet error/soft-reset evidence without asserting saturated `io_error`; machine authorization revokes. |
| D | The first P2 clean cycle clears current-cycle `packet_error` while level remains exactly 1; motion remains unauthorized. This gate explicitly rejects equating `packet-error == FALSE` with an arbitrary clean history. |
| E | Starting from level zero, exactly five consecutive P3 errors reach level 10 and assert `io_error` / `packet_error_exceeded`; no post-hoc threshold tuning is allowed. |
| F | P4 driver recovery can clear the saturated error state, but machine authorization remains false. Clearing `io_error` alone is never scored as recovery authorization. |
| G | In P5, internal generator state advances while physical I/O authority is false; this must coexist with a clean current transport indication without being misclassified as proof of physical output activity. |
| H | P6 restores transport/driver/watchdog/physical-I/O conditions while state revalidation is false, and motion remains unauthorized. |
| I | P7 is the only recovery phase that may reauthorize motion, requiring explicit `state_revalidated` + explicit request; P8 must revoke that authorization on a new fault in the same modeled cycle. |
| J | Analysis explicitly labels watchdog/physical-I/O/state-revalidation signals as synthetic laboratory witnesses, keeps the source conclusion version-pinned, and makes no real-machine stopping, physical-safety, diagnostic-coverage or functional-safety claim. |

All ten gates are required. Gates remain **UNSCORED** until a separate authoritative execution is run after a valid non-authoritative preflight.

## Predeclared adversarial traps

The eventual exam must reject at least these claims:

1. `packet-error == FALSE` means the preceding window was fault-free.
2. `io_error == FALSE` means the watchdog never bit.
3. Ping/ordinary Ethernet reachability proves realtime hm2_eth health.
4. Internal stepgen/encoder movement proves physical output activity.
5. Clearing `io_error` authorizes automatic restart.
6. Watchdog reset alone re-establishes machine state.
7. The packet error accumulator and watchdog timer are the same mechanism.
8. A v2.9.10 model proves 2.7-era timing/recovery behavior.
9. A software-only fixture proves physical stopping behavior.
10. Prior revalidation remains valid through a newly observed transport fault.

## Implementation checkpoint

Build the smallest standalone realtime HAL component implementing the frozen model and place it before `sampler` in one 1 ms thread. Retain the exact model source, generated HAL/topology/thread ordering, atomic samples and producer overrun state. First execution is non-authoritative and may correct harness defects only; P0–P8, numeric defaults and Gates A–J are frozen and must not be tuned to fit output.
