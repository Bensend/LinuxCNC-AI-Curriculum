# LinuxCNC `iocontrol` E-stop Call Flow — Safety-Course Source Trace

Date: 2026-09-15
Pinned LinuxCNC revision: `d1a9d7d04cc274bfb5082caee6accc2489607418`

This closes the first R-SAFE-01 source question left by `research/linuxcnc-safety-patterns.md`: what `iocontrol.0.user-request-enable`, `user-enable-out`, and `emc-enable-in` actually mean in current source.

## HAL direction is authority-significant

`Task::iocontrol_hal_init()` creates:

- `iocontrol.0.user-enable-out` as **HAL_OUT**;
- `iocontrol.0.emc-enable-in` as **HAL_IN**;
- `iocontrol.0.user-request-enable` as **HAL_OUT**.

Therefore LinuxCNC owns the two `user-*` signals, while the HAL graph/external machine logic owns `emc-enable-in`. The source initializes `user-enable-out=false` and `user-request-enable=false`.

This makes a useful conceptual split:

`LinuxCNC requests/announces enable -> external/HAL chain decides what comes back -> emc-enable-in reports whether LinuxCNC may leave E-stop state`

That feedback loop can include ordinary HAL logic, an external safety-chain status contact, watchdog status, or combinations. The presence of the loop does not itself make the loop safety-rated.

## ESTOP_ON

`Task::emcAuxEstopOn()`:

1. sets `user_enable_out = 0`;
2. sets `user_request_enable = 0`;
3. calls `hal_init_pins()`, which returns the ordinary iocontrol outputs to startup values.

The code comment says it is asserting an E-stop "to the outside world (thru HAL)."

**SOURCE-CONFIRMED consequence:** LinuxCNC can withdraw its own enable request. This is ordinary control authority and should be wired so withdrawing the request tends toward machine inhibition. It is not evidence that LinuxCNC is the independent personnel-safety channel.

## ESTOP_OFF request

`Task::emcAuxEstopOff()`:

1. sets `user_enable_out = 1`;
2. sets `user_request_enable = 1` specifically to generate a rising edge for an optional HAL latch;
3. sets the internal `emcioStatus.aux.estop = 0` at that point.

The periodic `Task::run()` then reads `emc_enable_in`. If it is false, it sets `emcioStatus.aux.estop = 1`. If it is true, it clears the status and, if `user_request_enable` is still true, returns that output to zero.

Thus `user_request_enable` is intentionally a **pulse-like reset request**, not a sustained safety permission. The actual external/HAL return path is `emc_enable_in`.

## Interaction with `estop_latch`

At the same pinned revision, `estop_latch.comp` recommends:

- external fault/E-stop -> `fault-in`;
- `iocontrol.0.user-request-enable` -> `reset`;
- `ok-out` -> `iocontrol.0.emc-enable-in`.

The latch requires a rising reset edge while its fault conditions are healthy. This pairs directly with `emcAuxEstopOff()` generating the rising `user-request-enable` request and `Task::run()` later dropping it back to zero once `emc-enable-in` is healthy.

The upstream HostMot2 stepper example uses the same structure and feeds HostMot2 watchdog `has_bit` into `estop-latch.0.fault-in`.

## Safety-course state model

Do not teach the GUI's "E-stop reset" action as direct hazardous-energy authorization. Source supports this more precise sequence:

1. user/software asks LinuxCNC to leave E-stop;
2. LinuxCNC raises its ordinary enable/reset request outputs;
3. HAL/external logic evaluates its prerequisites;
4. `emc-enable-in` must be returned true for the periodic task status to remain out of E-stop;
5. the one-shot reset request is then dropped.

For a machine with independent safety hardware, the external safety system must retain its own reset/restart rules. LinuxCNC's request may participate in coordination, but it must not bypass a required physical/manual safety reset or make an unsafe external chain appear healthy.

## Adversarial cases

### External chain remains faulted

LinuxCNC issues ESTOP_OFF and pulses `user-request-enable`, but `emc-enable-in` remains false. The next periodic `Task::run()` reports E-stop again. This is the desired ordinary-control feedback behavior.

### Reset is held or stale

The source deliberately makes `user-request-enable` transient after `emc-enable-in` is healthy. `estop_latch` itself requires a rising edge. This avoids a permanently high software reset acting as a continuously asserted latch-reset command. A safety-rated reset channel, where required, still needs its own evaluated behavior.

### HAL falsely returns healthy

If a HAL bug/configuration error drives `emc-enable-in=true`, LinuxCNC will accept that input as healthy. There is no source evidence here of redundant validation of that Boolean. Therefore `emc-enable-in` is a machine-control interface, not proof of independent safety integrity.

### LinuxCNC process freezes after enable

The `iocontrol` Boolean values alone do not guarantee they will transition on a process freeze. This is why a hardware/FPGA watchdog can add valuable fault containment. The HostMot2 watchdog's documented high-impedance pin behavior must still be converted by field circuitry into deterministic inactive commands, and the watchdog remains separate from safety-rated authority.

## Frozen teaching rule

Use four distinct words in future modules:

- **request** — LinuxCNC asks for enable/reset;
- **permission** — external/ordinary control prerequisites return healthy;
- **safety authorization** — an independently justified safety system permits hazardous operation;
- **actuation** — physical output hardware can actually energize the hazard.

Never collapse these into one `machine-enabled` Boolean in a safety architecture diagram.

## Evidence classification

- `SOURCE-CONFIRMED`: HAL pin directions and startup values in `Task::iocontrol_hal_init()` / `hal_init_pins()`.
- `SOURCE-CONFIRMED`: ESTOP_ON clears ordinary enable/reset outputs.
- `SOURCE-CONFIRMED`: ESTOP_OFF raises `user-enable-out` and produces a reset-request edge.
- `SOURCE-CONFIRMED`: periodic `Task::run()` derives E-stop status from `emc-enable-in` and clears the reset-request pulse after healthy feedback.
- `SOURCE-CONFIRMED`: `estop_latch` is compatible with this pulse/feedback structure.
- `INFERENCE`: external safety-rated authority must not be inferred from the Boolean handshake; that conclusion follows from the absence of a safety claim/redundant safety mechanism in this ordinary software path and the curriculum's independent-safety boundary.

No lab is justified for this call flow: the relevant behavior is explicit in pinned source. A later lab may be useful only if a concrete timing/recovery uncertainty remains after the external safety-chain architecture is defined.
