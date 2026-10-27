# 4400-AIR-CLEAN-01 — pinned LinuxCNC M62/M63 delayed-OFF trap in a hypothetical air-blast output
2026-10-27 | SOURCE-CONFIRMED at pinned revision; NO runtime, HAL or physical machine test.

## Precise question
Could an M63 request to turn OFF an ordinary digital output fail to take effect at the end of a program because no later motion occurs? **Yes, under the documented motion-synchronized semantics.** This is a normal output-sequencing property, not an independent safety-function failure. No assertion that OpenPressBrake uses M62–M65 for air.

## Direct original pinned inspection
Inspected original LinuxCNC/linuxcnc revision **062dc7c097693bb68e76192516cd92878dd5ecdf**, not only the existing [CHUCK-01 audit](4400_ROEHM_HAAS_CHUCK_CENTRIFUGAL_GRIP_PRESSURE_AND_LINUXCNC_DIO_SOURCE_AUDIT_2026-10-25.md).
- [docs/src/gcode/m-code.adoc, lines 433–465](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/docs/src/gcode/m-code.adoc#L433-L465): M62/M63 queued; the next motion command applies changes; without subsequent motion they do not happen. Repeated queued commands for the same output replace older queued settings. M64/M65 act immediately upon reception by motion and can break blending. The documentation requires appropriate motion.digital-out-NN HAL connections for effect.
- [src/emc/rs274ngc/interp_convert.cc, lines 4049–4088](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/rs274ngc/interp_convert.cc#L4049-L4088): Interp::convert_m dispatches M62 to SET_MOTION_OUTPUT_BIT, M63 to CLEAR_MOTION_OUTPUT_BIT, M64 to SET_AUX_OUTPUT_BIT, M65 to CLEAR_AUX_OUTPUT_BIT. This is the actual **SOURCE-CONFIRMED interpreter request** distinction. The inspected path does not prove actual HAL wiring or solenoid movement.
- This directly reuses, rather than duplicates, the 2026-10-25 [CHUCK-01 pinned trace](4400_ROEHM_HAAS_CHUCK_CENTRIFUGAL_GRIP_PRESSURE_AND_LINUXCNC_DIO_SOURCE_AUDIT_2026-10-25.md). Increment is the **air-cleaning OFF/restart safety transfer**, not a newly discovered M-code implementation.

## Minimal adversarial timeline (illustrative, NOT executed)
| Step | Ordinary program action | What the pinned docs establish | Safety boundary |
|---|---|---|---|
| 1 | M62 P0 | Queue ON for output 0 | No proof of air yet |
| 2 | G1 X... | Beginning of motion applies queued ON | Actual output/valve only if wired and working |
| 3 | M63 P0 | Queue OFF for output 0 | **Does not necessarily switch OFF yet** |
| 4 | End program with no further motion | Queued OFF has no subsequent motion to apply | A normal output may remain in its prior ON state; do not infer a physical state without HAL/actuator evidence |
| 5 | Operator opens guard for cleanup | M63 appeared in G-code | Program text is not proof of safe air, machine standstill, pressure removal, chip containment or guard authorization |

**SOURCE-CONFIRMED:** queued semantics and interpreter mapping at this revision. **INFERENCE:** if a normal digital output actually controls a cleaning-air valve and ON has been applied, an un-applied queued OFF could leave that normal command ON. Actual Task abort/end-of-program handling, remaps, HAL wiring, valve fail state and independent safety chain were **not** traced here, so do not claim universal persistence across every abort/end path. A later motion may apply the queued change. **TEST-CONFIRMED none**.

## Engineering consequence
For ordinary process sequencing, use an explicitly justified immediate OFF (M65) or separately verified normal shutdown logic where appropriate, while recognizing its non-motion-synchronized behavior and blending effects. **Never treat M65, M9, HAL OFF or an FPGA pin as an independent guard, pneumatic isolation, pressure-zero or fresh-restart proof.** Safety-related access still needs independent functions and physical witnesses; servicing needs actual energy isolation/bleed where applicable. Review unexpected power-up, stale commands, output faults, hose/valve leaks and mode transitions separately.

## Verification plan and stop
Document selected HAL pin/net/actuator, G-code/remap path and physical safe-state function before any selected-machine test. A software-only M62/M63 ordering lab would be redundant with directly documented/source-confirmed semantics unless a concrete version/config conflict appears. No GitHub-hosted or local runner compute used; no lab frozen. OpenPressBrake use of this output path UNKNOWN, G0/G1 HOLD.
