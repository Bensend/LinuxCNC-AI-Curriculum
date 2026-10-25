# 4400-VALVE-01 — Enable OFF is not physical stop: 12 PAPER technician cases
**2026-10-25 | NON-GRADUATED | PAPER ONLY | NOT SCORED**

Read [the original Parker DFplus/D1VW audit](../research/4400_PARKER_DFPLUS_POWER_DOWN_ZERO_LAP_D1VW_MONITORED_SPOOL_AND_PRESS_SCOPE_OEM_AUDIT_2026-10-25.md) before responding. The learning goal is to separate normal command, physical spool/port state, monitored position, independent safety control, gravity load holding, and service rearm. For every scenario write: OEM evidence; exact variant needed; false assumption; independent physical witness; HOLD/STOP decision; low-friction safer design; unresolved uncertainty.

1. HMI says servo valve enable OFF; operator assumes hydraulic flow must be zero.
2. DFplus zero-lap variant loses power; engineer treats zero-command neutral as the same as power-down.
3. An overlap-spool data sheet is used to justify the behavior of a zero-lap variant.
4. D1VW start-position sensor indicates the offset state; technician claims the elevated ram is independently supported.
5. A monitored end-position signal is used as if it meant start/neutral position.
6. An ordinary spool diagnostic wire is connected directly to a green “SAFE” HMI indicator.
7. A D1VW part number without its position-monitoring suffix is accepted as equivalent to a monitored valve.
8. A replacement has a manual override where the OEM's specified hydraulic-press variant used the no-override T option.
9. A press-brake design copies a hydraulic-power-press DIN EN ISO 16092-3 ordering note without checking machine-class scope.
10. Coils are de-energized but a proportional valve's spool sticks; operator proposes increasing LinuxCNC PID gain.
11. One Y1/Y2 valve reports spool offset; the opposite side drifts and both share a pilot/return line.
12. A service reset clears a fault, a foot pedal remains held and no new deliberate start is demanded.

## Empty selected-machine witness
| Required artifact | Current |
|---|---|
| As-built Y1/Y2 valve OEM, full ordering codes and spool symbols | UNKNOWN |
| Exact power-down port paths and ordinary enable/fault behavior | UNKNOWN |
| Independent safety-related final elements, diagnostic monitoring and failure analysis | UNKNOWN |
| Physical load-hold, relief, pilot, return, mechanical support and pressure-zone witness | UNKNOWN |
| Guard/reset/restart and qualified emergency rescue evidence | UNKNOWN |
| External independent novel scenario score | NOT RUN |
| G0/G1, G2, G3/G4 | HOLD / NOT RUN / NOT AUTHORIZED |

No energized test, hydraulic adjustment, manual override, pressure opening or people-exposed operation is authorized. **DOC-CONFIRMED** Parker original variant-specific statements; **INFERENCE** safety boundaries; **UNKNOWN** actual selected machine. No SOURCE-CONFIRMED new LinuxCNC code, TEST-CONFIRMED evidence or COMMUNITY-REPORTED claim.
