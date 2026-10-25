# 4400-FILT-01 — Filter bypass, alarm memory and cold-start common-cause safety
**2026-10-25 | 4000 safety extension | 14 PAPER CASES / NOT SCORED | NON-GRADUATED**

## Competency
Distinguish **filter element cleanliness**, **actual oil path**, **bypass position**, **differential-pressure indication**, **indicator memory/reset**, **cold-start thermal lockout**, **valve contamination**, and **independent physical Y1/Y2 stop/hold**. Read the [original Parker/HYDAC source audit](../research/4400_PARKER_HYDAC_FILTER_BYPASS_COLD_START_INDICATOR_RESET_AND_VALVE_CONTAMINATION_OEM_AUDIT_2026-10-25.md). Do not turn an ordinary filter alarm into personnel-safety authority.

## Failure-path teaching
A filter bypass may preserve flow while admitting unfiltered fluid downstream. A blocked/no-bypass design may protect sensitive valves from unfiltered oil **but requires different element strength and sizing**; it is not automatically safer. A differential-pressure switch may be independent of actual bypass hardware. Automatic reset erases the active alarm when pressure differential falls; a manual-reset visual indicator preserves an event until reset. Optional cold-temperature lockout deliberately suppresses one alarm path. All these are **DOC-CONFIRMED exact OEM mechanisms**; whether they threaten a selected press-brake holding valve is an **INFERENCE** requiring a real hydraulic fault analysis.

**Human factors:** make filter service possible from an isolated, supported, depressurized and accessible service zone. Put a maintenance-history latch/log and filter part/revision where technicians can see it. Do not make nuisance-alarm defeat the fastest way to finish setup: use properly sized OEM-approved filtration, clear cold-start state, and sensible diagnostics. Keep the independent stop/hold safety boundary separate.

**Additional OEM failure-path corroboration:** Parker's original Series 6 MMV-IPC 1997 troubleshooting chart explicitly records continued flow after solenoid coils are de-energized due to a sticking main spool/contamination (exact source in linked audit). **DOC-CONFIRMED for that ordinary mobile valve only**. It demonstrates why a LinuxCNC/HAL coil-off indication cannot independently establish physical no-flow, but it is **not** evidence that an installed OpenPressBrake valve has this failure. Do not troubleshoot by actuating manual overrides in this curriculum.

## Fourteen unscored PAPER decisions
For each, record (a) exact source claim, (b) what the indicator actually witnesses, (c) unsafe assumption, (d) missing as-built/physical evidence, (e) safe HOLD/maintenance action, (f) low-friction redesign.
1. Electric ΔP alarm clears when the pump stops; technician concludes the element cleaned itself.
2. A BM manual-reset red pin remains extended after filter replacement.
3. An automatic-reset visual B indicator returns green after warmup.
4. Thermal lockout is active on a cold morning; HMI shows no filter alarm.
5. A return-line filter is sized using average pump flow but a cylinder multiplies peak return flow.
6. A filter bypass sends unfiltered oil downstream of a safety-related hydraulic valve.
7. A proposed bypass-to-tank conversion lacks a revised return/pressure/flow diagram.
8. A technician proposes plugging the bypass without changing the element's collapse rating.
9. A differential-pressure switch is incorrectly treated as a direct bypass-spool position sensor.
10. A generic replacement indicator is fitted to a different manufacturer's housing.
11. An NO contact is assumed NC because the HMI alarm is active-low.
12. A valve becomes erratic after filter service; technician wants to compensate in the ordinary LinuxCNC PID.
13. A maintenance dashboard says “oil filter OK,” but no fluid cleanliness or service record exists.
14. Two Y1/Y2 valves share one contaminated fluid supply; reviewer assumes failures are independent.

## Blank restricted-machine evidence card
| Requested evidence | State |
|---|---|
| Installed filter/housing/element/bypass type, suffix, location and circuit route | UNKNOWN |
| Indicator exact model, reset/thermal behavior, wiring and HMI history | UNKNOWN |
| Maximum flow, temperature/viscosity and fluid cleanliness/maintenance evidence | UNKNOWN |
| Safety-related hydraulic final elements and contamination/common-cause fault analysis | UNKNOWN |
| Independent Y1/Y2 physical stop/hold, mechanical restraint, qualified release criteria | UNKNOWN |
| Independent fresh evaluation | NOT RUN |
| G0/G1, G2, G3/G4 | HOLD / NOT RUN / NOT AUTHORIZED |

**No live pressure, forced bypass, deliberate contamination, service-line opening or people-exposed test.** This module is source-grounded preparation, not a passed exam, physical proof, or selected machine certification. **SOURCE-CONFIRMED none new; TEST-CONFIRMED none; COMMUNITY-REPORTED none; DOC-CONFIRMED** original Parker/HYDAC; **INFERENCE** contamination/common-cause transfer; **UNKNOWN** selected hardware and outcomes.
