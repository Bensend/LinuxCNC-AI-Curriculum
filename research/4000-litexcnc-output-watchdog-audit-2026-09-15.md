# 4000 LiteX-CNC output watchdog audit — 2026-09-15

Status: SOURCE

Purpose: resolve the firmware-selection condition that watchdog/reset behavior must be checked across output-producing modules rather than inferred from PWM alone.

## GPIO

Pinned upstream LiteX-CNC `gpio.py` defines a configured per-output `safe_state`. The GPIO output CSR resets to that safe-state bitmap. More importantly, synchronous firmware logic watches `MMIO.reset` OR `watchdog_has_bitten`; when either is true it device-writes the GPIO output register back to the configured safe-state bitmap. Physical pads are combinationally driven from that register.

Result: GPIO has explicit FPGA-local watchdog/reset reconciliation to configured safe states.

## PWM

Previously traced source shows reset OR watchdog bite device-writes `pwm_enable` to zero.

Result: PWM has explicit FPGA-local disable on watchdog/reset.

## Stepgen

Pinned `stepgen.py` connects each step generator's reset to the MMIO reset and its enable to `~watchdog.has_bitten`.

Result: a watchdog bite disables step generation in FPGA logic. This is stronger than relying on the host to command zero velocity after communication loss.

## Encoder

Encoder is input/measurement state rather than an actuator. Its counter reset is tied to MMIO reset; watchdog does not need to force a physical output safe state. Feedback freshness remains a separate transport concern.

## Conclusion

The inspected standard output modules—GPIO, PWM and stepgen—all contain FPGA-local watchdog/reset behavior. This substantially strengthens LiteX-CNC as the working firmware baseline.

However, the project SHALL still impose one common output-authority contract on **new custom modules**: the proportional-current/valve module must take the same FPGA-local watchdog/reset authority explicitly. It must not rely on the host driver to send zero current after a timeout.

Recommended custom-module rule:

`physical_output_enable = module_enable AND global_output_authority AND NOT watchdog_bitten AND NOT local_fault`

with command value held diagnostically if useful, but the physical drive path independently disabled or forced to its defined safe state.

## Remaining firmware hardening gap

Output-side watchdog behavior is now strong enough for the working selection. The larger remaining weakness is **input/feedback freshness**: the inspected generic LiteX-CNC read loop still processes the read buffer after a board read call without visibly checking the failure return, and source contains a TODO acknowledging this. Before final firmware freeze, expose/read a valid/fresh generation state and do not update process feedback as current-cycle-valid after a failed Etherbone transaction.

No lab required yet; this is source-resolved. Later transport hardware testing should verify watchdog bite timing and physical output transitions across GPIO, stepgen, PWM and the custom valve-current module.
