# PLASMA-248 — QtPlasmaC THC velocity anti-dive and external-offset authority
Date: 2026-11-06 UTC. Track 3300, NON-GRADUATED. Evidence: LinuxCNC v2.9.10 source inspection; no runtime tests.

## Source provenance
LinuxCNC/linuxcnc tag `v2.9.10`, `src/hal/components/plasmac.comp`, immutable Git blob `8f22cf1789b8adb49fe0a8d7e7cd5bd33444bf6c`.
Source URL: https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/plasmac.comp
Documentation (version-scoped): https://linuxcnc.org/docs/2.9/html/en/plasma/qtplasmac.html
Claims below are source-confirmed *within this component*, not verified against a real machine HAL/INI.

## Data and authority flow
- Input `arc_voltage_in` → optional exponential lowpass → absolute-value, offset, scale, 0.001 V rounding → `arc_voltage_out` (lines 734–742). Input units/scaling must be calibrated; `arc_ok_in` is separate and mode-dependent.
- `current_velocity` is documented as `motion.current-vel`; source multiplies by 60 to obtain `current_feed_rate` (lines 49–52, 549). `requested_feed_rate` is a separate derived demand, **not** necessarily current XY velocity.
- In cut mode, `thc_active` requires THC enabled, a valid mode-dependent target/arc condition, and **both** corner and void locks clear (lines 581–585). An enabled THC toggle does not imply active Z correction.
- Velocity anti-dive: when `cornerlock_enable` and current velocity ×60 falls below `requested_feed_rate * cornerlock_threshold * 0.01`, `cornerlock_is_locked` is asserted. Once locked it is cleared only when velocity ×60 **exceeds 99%** of requested feed (lines 1625–1634; another mode-specific branch at 1752–1762). This is **hysteresis**, not a symmetric comparator. Threshold 60% and velocity 70% does not release a lock inherited from 50%.
- The first cut-phase target acquisition holds corner lock until current velocity exceeds 99.9% requested (lines 1578–1583). This is a distinct startup gate.
- Void anti-dive compares absolute successive processed arc-voltage changes against `voidlock_slope * voidlock_on_cycles * fperiod`; lock/unlock uses cycle counters (lines 1636–1658). Do not conflate void slope with the velocity gate.
- The component outputs `z_offset_counts`, `z_offset_enable`, and `offset_scale`, explicitly documented for `axis.z.eoffset-counts`, `axis.z.eoffset-enable`, and `axis.*.eoffset-scale` (lines 170, 199–200). Cut-height and probing state transitions use `offset_move` and feedback `z_offset_current` (lines 436–445, 1386–1406, 1520–1549). The source defines a *candidate* external-offset command chain, not proof of a deployed HAL connection.
- `offset_scale = units_per_mm * fperiod / res` (line 502): offset-count scale depends on servo period and configured resolution. A copied HAL pin value with wrong units/period can mis-scale Z.

## Worked source-prediction exercise (not executed)
Assume requested feed 1000 mm/min, VAD threshold 60%, VAD enabled and active cut mode. At 550 mm/min lock asserts. At 700 mm/min it remains locked. At 990 mm/min exact comparison is strict `>`, so still locked; at 995 mm/min it clears. This deliberately tests hysteresis. For startup target acquisition, 999 mm/min does not satisfy `> 999`; 1000 does.

## Diagnostic walkthrough
1. Identify actual INI `HALFILE` and `POSTGUI_HALFILE` chain and `addf` ordering, then verify the exact `plasmac.current-velocity`, `plasmac.feed-upm`, `plasmac.arc-voltage-in`, `plasmac.z-offset-counts`, `plasmac.z-offset-enable`, `plasmac.offset-scale`, and `axis.z.eoffset-*` connections.
2. Log in a *single servo-cycle sample* the current/requested feed, cornerlock threshold, corner/void lock, THC enabled/active, voltage raw/processed, target voltage, Z offset command/feedback and motion state. A GUI screenshot alone cannot prove synchronous values.
3. Test in a simulation with no torch and no physical motion: ramp 50→70→99→100% velocity while holding requested feed constant; assert the predicted latch/release boundaries. Separate test: disable cornerlock and vary arc voltage while checking voidlock.
4. Confirm Z eoffset scaling/limits against INI units and motion external-offset configuration before any hardware use. Never treat software THC inhibition as personnel-safety authority.

## Evidence ledger / unresolved dependencies
SOURCE-CONFIRMED: component pin names, voltage transform, VAD hysteresis, startup gate, void slope formula, THC-active conjunction, eoffset output intent.
DOC-CONFIRMED: VAD and THC controls described in QtPlasmaC v2.9 docs.
OPEN: actual selected QtPlasmaC HAL/INI inclusion chain, exact motion external-offset implementation, signal publication order, mode-2 distinctions, source-versus-running-version compatibility, and live calibration/THCAD input.
NO TEST: no simulator, runner, machine, arc, or physical torch used.

## Next evidence
PLASMA-249: inspect a complete tag-pinned QtPlasmaC simulation configuration and `axis.z.eoffset-*` motion source; build a HAL wiring table with actual `addf` order. Only if evidence is adequate, create a bounded self-hosted-only simulation oracle. Otherwise rotate to 4000 HostMot2/FPGA. Preserve existing graduation, blind feedback, independent safety and physical-machine gates.
