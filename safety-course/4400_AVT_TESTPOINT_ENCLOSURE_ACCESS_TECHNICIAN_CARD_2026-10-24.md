# 4400 electrical enclosure: 14 adversarial technician scenarios (PAPER ONLY)
**2026-10-24 | No live work, no machine test, no independent competency score.**
Read [original source audit](../research/4400_AVT_TESTPOINT_NFPA_COMMITTEE_OSHA_POINT_OF_WORK_CONFLICT_AUDIT_2026-10-24.md). For each case identify HOLD/acceptable, what is proved, what remains unknown, the independent witness, and a human-factors improvement.

| ID | Situation | Correct boundary / teaching answer (NOT a blind oracle) |
|---|---|---|
| EV-01 | Main disconnect locked OFF; separate 120 V fan feed remains. | HOLD: every source and exposed conductor must be assessed and verified. |
| EV-02 | LinuxCNC HMI displays DC BUS 0 from normal FPGA ADC. | Diagnostic only; no qualified isolation proof. |
| EV-03 | Red presence lamps dark; active test button not pressed. | Darkness is not absence-of-voltage proof. |
| EV-04 | AVT green on incoming three-phase; regenerative DC bus downstream. | Only sensor point proved; bus still UNKNOWN. |
| EV-05 | Retrofit joins paired AVT sensor leads at one terminal. | OEM connection-check assumptions defeated; rewire/recommission. |
| EV-06 | New auxiliary supply added after prior AVT commissioning. | Change stales source map and commissioning; repeat OEM process. |
| EV-07 | AVT moved to VFD PWM motor output. | Product OEM warns against high-frequency application. |
| EV-08 | AVT caution flashes four times. | Sensor-lead verification failed; treat as potentially energized. |
| EV-09 | AVT caution flashes two times. | OEM reports voltage above threshold; do not enter. |
| EV-10 | Test-point seller claims universal NFPA compliance. | Earlier vendor statement conflicts with 2025 committee proposed response; get adopted standard/AHJ. |
| EV-11 | Vendor calls committee meeting minutes a formal interpretation. | Meeting proposed response is not independently established as formal interpretation. |
| EV-12 | Safety PLC removes motion enable, but service outlet stays live. | Safety stop != lockable all-source isolation. |
| EV-13 | Difficult cabinet diagnostics cause technicians to defeat door switch. | Improve protected external diagnostics and service workflow, not bypass. |
| EV-14 | Electrical zero verified but gravity ram unsupported, hydraulic pressure trapped. | Electrical proposition only; mechanical/fluid safe state still fails. |

**Transfer:** Repeat source mapping for a plasma torch supply, mill spindle VFD, robot regen drive and press-brake hydraulic pump. Do not invent voltage, arc incident energy, safe stop distance or PL/SIL. G3/G4 NOT AUTHORIZED without selected-machine physical proof.
