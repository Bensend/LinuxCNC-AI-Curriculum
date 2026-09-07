# S02 — Watchdog Source and Design Guide

Status: SOURCE
Course level: 1000
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Session start: `2026-09-07T05:14:38Z`

## Objective

Distinguish LinuxCNC watchdog patterns by failure domain, execution context, timeout/re-arm semantics, and externally visible effect. A fresh AI must not collapse a software heartbeat supervisor, a software E-stop latch, HostMot2 firmware watchdog, or external hardware supervision into one generic concept of "the watchdog".

## Generic HAL watchdog — pinned source

Source: `src/hal/components/watchdog.c`.

`rtapi_app_main()` requires `num_inputs` in the range 1..32, exports `watchdog.input-N`, RW `watchdog.timeout-N`, `watchdog.ok-out`, and `watchdog.enable-in`, then exports two realtime HAL functions:

- `watchdog.process` — no floating-point requirement; intended for a fast thread.
- `watchdog.set-timeouts` — uses floating point to convert timeout seconds into integer seconds/nanoseconds and owns the re-arm edge logic; documentation recommends the servo thread.

### `process()` behavior

`process()` returns immediately if `enable-in` is false **or** `ok-out` is already false. While enabled and OK, each input is compared with its remembered prior value. A transition reloads that input's countdown from the configured timeout. No transition subtracts the invoking thread's `period` from the countdown. If any input reaches expiry, `fault=1` and `ok-out` is cleared.

Consequences:

1. Detection is based on **transitions**, not a required absolute logic level.
2. The timeout clock is the accumulated scheduled `period` values of `watchdog.process`, not an independent wall-clock timer.
3. Once `ok-out` is false, `process()` stops monitoring until the separate re-arm path succeeds.
4. A heartbeat that keeps toggling while producing logically wrong machine behavior can satisfy this watchdog. This is a liveness monitor, not a correctness monitor.

### `set_timeouts()` behavior and re-arm

Negative configured timeout values are clamped internally to zero. Changed float timeout values are converted to integer seconds/nanoseconds. Re-arm occurs only when all of the following are true:

- `ok-out` is currently false;
- `enable-in` is true;
- the remembered previous `enable-in` was false.

That rising edge reloads all countdowns and sets `ok-out` true. Therefore after a bite, merely restoring heartbeat transitions is insufficient; `enable-in` must first be observed false and then true by `set-timeouts`.

Important ordering implication: `set-timeouts` and `process` are independent HAL functions. Their configured thread placement/order affects exactly when a new enable edge and newly converted timeout become visible to `process`. At 1000 level the design rule is to follow the documented split — `process` in a suitably fast thread, `set-timeouts` in the servo thread — and reason from actual `addf` order for exact-cycle behavior.

## `estop_latch` — pinned source

Source: `src/hal/components/estop_latch.comp`.

The component starts Faulted: `ok_out=false`, `fault_out=true`. It reaches OK only when `ok_in=true`, `fault_in=false`, and `reset` has a rising edge. While OK, its `watchdog` output toggles each invocation. If `ok_in` becomes false or `fault_in` becomes true, it immediately returns to Faulted and the watchdog stops toggling.

This is a different design pattern from `watchdog(9)`:

- `estop_latch` **latches fault state and requires a reset edge**;
- its `watchdog` output is generated *from* its healthy state rather than supervising an incoming heartbeat;
- typical documentation wiring places `ok_out` on `iocontrol.0.emc-enable-in`, making it part of the LinuxCNC software E-stop chain;
- the toggling output can feed a downstream charge-pump/supervisor, but the physical effect depends entirely on that downstream implementation.

The source does not prove an external contactor opens, STO activates, hydraulic energy is removed, or any PL/SIL/category is achieved.

## Comparison matrix

| Pattern | Runs where | Detects | Fault output/state | Re-arm/recovery | Common-cause weakness | Does **not** prove |
|---|---|---|---|---|---|---|
| HAL `watchdog(9)` | LinuxCNC realtime HAL function(s) | Missing transitions on 1..32 software heartbeat inputs | `ok-out=false` | Explicit `enable-in` false→true observed by `set-timeouts` | Checker and heartbeat may share CPU/thread/software dependencies | Physical safe state, logical correctness, stopping time |
| `estop_latch(9)` | LinuxCNC realtime HAL function | `fault-in`, loss of `ok-in`; reset policy | `ok-out=false`, `fault-out=true`, heartbeat stops | Healthy inputs + reset rising edge | Software chain can share failure domain with controller | Safety-rated E-stop, energy isolation, STO |
| HostMot2 watchdog | FPGA firmware + HostMot2 host servicing | Missing normal HostMot2 write servicing | FPGA I/O pins disconnected from modules / high-Z; `has_bit` reports bite | Driver recovery clears `has_bit`; HM08 documents host path | Cannot detect a host that continues petting while commanding bad values; downstream high-Z may not be safe | Actual actuator safe state unless board/circuit is verified |
| External hardware supervisor | External electrical/safety hardware | Design-specific heartbeat/line/contact state | Design-specific inhibit/contact/STO/etc. | Design-specific | Common supply/wiring/relay architecture may defeat independence | Claimed PL/SIL/category without full validated design |

## Layered design reasoning

A robust control architecture may intentionally layer these patterns because they cover different failures. Example reasoning, not a safety certification:

`software state/fault latch -> software heartbeat -> hardware/FPGA liveness monitor -> downstream hardware inhibit`

Each arrow must be validated independently. Adding multiple watchdogs does not automatically add independence: two monitors driven from the same servo thread, same PC power rail, same network path, or same flawed enable logic can have a common-cause failure.

## Representative failure paths

### Heartbeat freezes

Prediction: while `enable-in=true` and `ok-out=true`, if an input stops changing long enough for its accumulated countdown to expire, `process()` clears `ok-out`. Subsequent heartbeat changes alone do not restore it. A false→true `enable-in` transition observed by `set-timeouts` is required.

Evidence: SOURCE-CONFIRMED by pinned `watchdog.c`; independently DOC-CONFIRMED by current `watchdog(9)` documentation. This prediction is suitable for a bounded HAL simulation experiment.

### `estop_latch` fault asserted

Prediction: `fault_in=true` forces `ok_out=false` and `fault_out=true`; the watchdog output becomes unchanging. Clearing the fault does not restore OK without a reset rising edge while the healthy-input conditions hold.

Evidence: SOURCE-CONFIRMED by pinned `estop_latch.comp`; independently DOC-CONFIRMED by current `estop_latch(9)` documentation.

### Host keeps servicing but software is wrong

A HostMot2 watchdog can continue to be petted while LinuxCNC repeatedly writes a logically dangerous but timely command. Therefore transport/host liveness is not command-validity supervision. Conversely, a software heartbeat may be healthy while a downstream board or cable has failed. This is why S02 teaches failure domains rather than a single watchdog abstraction.

## Documentation/community reconciliation

Current LinuxCNC `watchdog(9)` documentation matches the pinned source on transition monitoring, split fast-thread/servo-thread functions, timeout values, and false→true `enable-in` re-arm. Current `estop_latch(9)` documentation matches the pinned state machine and typical software E-stop wiring. HostMot2 documentation states that a bite disconnects I/O pins from module instances and makes them high-impedance inputs while internal module state can continue; this must not be translated into a physical-safe-state claim without board/circuit evidence.

Community material is useful primarily as a failure-mode lead for charge pumps, external E-stop chains, and hardware supervision. It is not used here to establish functional-safety performance.

## Experiment design — S02-012

Build a pure-HAL simulation around production `watchdog(9)` and a deterministic toggling heartbeat. Predeclare these gates:

1. With `enable-in=false`, `ok-out` remains false.
2. A false→true enable edge causes `set-timeouts` to arm the watchdog and `ok-out` becomes true.
3. Repeated input transitions inside the timeout preserve `ok-out=true`.
4. Freezing the heartbeat causes `ok-out=false` after the configured timeout budget.
5. Resuming the heartbeat alone does **not** re-arm.
6. Cycling enable false→true re-arms.
7. Capture thread periods and `addf` ordering so timing is interpreted in scheduler-cycle terms rather than claimed as physical stopping time.

If the production component can be loaded in the existing headless lab without a new build, run the experiment. If a harness problem blocks it, classify the harness before changing the behavioral prediction.

## Promotion queue

- Exact worst-case detection latency from `process`/`set-timeouts` thread periods, ordering, jitter and scheduler overruns: **2000 / HIGH**. Safe to promote because 1000-level teaching requires the qualitative timeout/re-arm mechanism, not a physical response-time guarantee.
- Common-cause quantitative diagnostic coverage for layered watchdogs: **2000/safety engineering / HIGH**. Requires system architecture assumptions beyond generic LinuxCNC source.
- External charge-pump circuit electrical fail-state, contactor/STO behavior, proof-test coverage and PL/SIL/category: **commissioning/safety / CRITICAL**. Physical/design-specific and explicitly outside software evidence.
- Combined Smart Serial remote watchdog + HostMot2 watchdog + `io_error` recovery ordering: **S03/S06/2000 / HIGH**. Does not overturn the distinctions established here.

## Exact next checkpoint

Implement/run S02-012 against pinned LinuxCNC. Reconcile the predeclared heartbeat-freeze and re-arm predictions against artifact evidence. Then create an adversarial exam that includes a misleading "two watchdogs means twice the safety" premise, a common-cause scenario, a timeout/order debugging problem, and a small HAL wiring modification. Graduate S02 only if the fresh-AI handoff keeps liveness detection, software fault latching, FPGA I/O fail behavior, and functional safety as separate claims.
