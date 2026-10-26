# 4400 ALARM-NOISE-01 — four-purpose warning / physical authority matrix (2026-10-26)
**Paper engineering integration, NOT a machine design approval.**

| Purpose | Legitimate evidence | Cannot establish | Authority and failure response | Change that reopens proof |
|---|---|---|---|---|
| Ordinary CNC cycle advisory | LinuxCNC/HMI command, buzzer wiring and tested actual notification | Space empty, guard closed, physical stop/hold, safe start | Normal control may announce; independent safety system still inhibits hazardous motion when required | New mode, relocated station, warning volume, background noise |
| Workplace emergency-action alarm (OSHA 1910.165 where applicable) | Emergency plan, distinctive/perceivable warning across affected people/areas, maintained system | CNC point-of-operation protection or maintenance isolation | Emergency planning/alert system; hazard-specific independent safeguarding remains | Evacuation route, layout, workforce hearing/accessibility, alarm tone or priority |
| Hearing-loss prevention (OSHA 1910.95 / NIOSH recommendation distinguished) | Qualified actual worker exposure assessment, controls and hearing program as applicable | Whether a particular alarm was heard, machine stopping | Occupational noise controls; do not defeat PPE to make an alarm audible | Noise source, shift/duration, enclosure, PPE, added louder horn |
| Personnel-safety stop/hold/guard/rearm | SRS, selected safety logic/final element, validated physical witness, qualified independent review | Inferred merely from alarm ON, OFF or silence | Independent safety-related control + physical energy removal/retention; LinuxCNC/FPGA normal outputs remain non-safety unless independently justified | Hardware, logic, Y1/Y2 hydraulic/guard geometry, maintenance or mode change |

## Counterexample and failure-path proof
An annunciator can be **electrically ON but inaudible**; an audible horn can coexist with an **unguarded occupied zone**; a stopped motor can coexist with an **unrestrained gravity-loaded ram**; a quieter warning can coexist with a **hearing-damaging workplace noise dose**. None of these implications is reversible. A failed buzzer must not disable an independent guard or permit a hazardous start, and a warning repair must not bypass reset/restart or LOTO.

## Minimal evidence transaction
`BND/HAZ` enumerate people and machine phases; `SRS` classify warning vs protective safety function; `DEP` include power, acoustics, hearing protection, sightlines and alert fatigue; `AUTH` normal annunciation vs independent stop/hold; `PHY/VAL` independent physical safe state and qualified signal-perception evidence; `HF` practical warning usability; `CHG/RR` mark affected evidence STALE after volume, acoustic enclosure, PPE, process or safety changes. No numerical acoustic acceptance criteria invented. Existing [Stage A A–G owner request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) remains first; conditional alarm-specific evidence only if installed.

**Evidence:** regulatory indexed OSHA, direct NIOSH and exact WERMA OEM **DOC-CONFIRMED** in [audit](../research/4400_ALARM_NOISE_01_OSHA_NIOSH_WERMA_PERCEPTIBILITY_AND_AUTHORITY_AUDIT_2026-10-26.md). Architecture separation **INFERENCE** pending selected design. Physical/evaluator **UNKNOWN/NOT RUN**. **G0/G1 HOLD**.
