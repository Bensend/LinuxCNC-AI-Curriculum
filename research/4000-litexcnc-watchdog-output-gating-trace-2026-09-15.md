# 4000 LiteX-CNC watchdog/output-gating source trace — 2026-09-15

Pinned revision: `Peter-van-Tol/LiteX-CNC` `eee501c11d82862dce56d02aa57db4eb1fe5525f`.

## Watchdog mechanism

`src/litexcnc/firmware/watchdog.py` implements the watchdog in FPGA logic. When enabled, its timeout counter decrements every FPGA clock. While timeout remains nonzero, `has_bitten=0` and optional `enable_out=1`; at zero, `has_bitten=1` and `enable_out=0`. When the watchdog itself is disabled, `enable_out` is also forced low.

The MMIO contract exposes watchdog enable/time in a host-written storage word and a host-readable `watchdog_has_bitten` status. Board reset clears watchdog data.

This is stronger than a userspace-only communications timeout because stale host updates can directly cause FPGA-local authority removal.

## Output coupling

The PWM module provides a concrete example of watchdog ownership. In `src/litexcnc/firmware/modules/pwm.py`, board reset or `watchdog_has_bitten` causes FPGA logic to write the PWM enable register to zero. The PWM generator itself drives its output low whenever its enable is false.

Therefore, for this pinned module, watchdog expiry is not merely diagnostic: it actively removes PWM output authority and drives the PWM pin inactive.

Stepgen search evidence likewise shows stepgen enable coupled to `~watchdog.has_bitten`; this needs a full source trace before using exact stepgen reset/trajectory claims, but it establishes that watchdog gating is designed as a cross-module FPGA concern.

## 4000 implication

The reusable board should preserve this architectural property regardless of whether final firmware is HostMot2 or LiteX-derived:

**freshness failure must reach machine-facing output enable in FPGA/hardware without requiring a successful round trip through LinuxCNC userspace.**

For proportional-valve/current output specifically, the numeric current command and the independent watchdog/enable gate should remain separate so a stale nonzero command cannot retain coil authority after freshness is lost.

## Important safety boundary

LiteX-CNC documentation includes examples tying watchdog status into LinuxCNC E-stop logic. That is useful normal-control fault containment, but this curriculum does not treat the FPGA watchdog or HAL E-stop chain as independently safety-rated. A later safety-oriented hardware block must preserve external safety authority separately.

## Next comparison

Source-trace upstream HostMot2 watchdog/output-disable behavior at the pinned LinuxCNC revision and compare its recovery/rearm semantics with Lcnc and LiteX-CNC. That comparison should decide whether the new board should prioritize native HostMot2 compatibility or adopt a custom/LiteX protocol.
