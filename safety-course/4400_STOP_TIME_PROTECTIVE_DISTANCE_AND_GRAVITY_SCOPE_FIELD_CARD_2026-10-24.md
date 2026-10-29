# 4400 technician field card — Stop time is not the whole safe state
**2026-10-24 | Learner-facing, open-book reasoning exercise | NOT a machine operating procedure.**

Read the [source and edition reconciliation](../research/4400_ISO13855_2024_SEPARATION_DISTANCE_SCOPE_STOP_TIME_AND_GRAVITY_EXCEPTION_2026-10-24.md) and the [selected-machine intake gate](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md). Use the ISO 13855:2024 ANSI publisher scope and preview, SICK 2021 ANSI example and Pilz overrun service material cited there. Do not assume access to the paid normative clauses. **No hidden answers or external competency score here.**

## Objective
For a new machine, separate (A) *time-and-geometry protection against a person reaching normal hazardous motion*, (B) *protection from mechanical failure, gravity and process emissions*, and (C) *maintenance isolation and deliberate restart*. Show how a credible physical witness, not a green UI indication, would support each.

## Ten paper-only challenges
For each case, fill in `HAZ / SF / source edition / physical proposition / missing evidence / status / least-friction safer design`. Mark `UNKNOWN` rather than selecting a number.

1. A press-brake front optical device stops Y1 on a controller screen. Y2 is not instrumented; the beam has a gravity load. Can a single measured software stop time release front access?
2. A light curtain is positioned from an old manufacturer's 2010-edition formula. The designer says the 2024 edition is “the same.” Which evidence would qualify that transfer?
3. A safety technician repeats a stop ten times on a cold, unloaded press. Operators later use a different die and load. What is and is not established by the ten results?
4. A calculated distance protects an operator's hand during powered bending, but a hose failure could drop the ram. Which protection must be independent of approach-distance arithmetic?
5. An enclosure has a light curtain at the door and a blind space behind it. The curtain clears while a person remains inside. What must prevent restart?
6. A lathe spindle takes longer to coast after a guard command than its software reports. Which physical event must end the timing window, and how should an outlier be treated?
7. A plasma cutter stops its gantry promptly but continues emitting harmful fumes or radiant energy. Does the same separation calculation close these hazards?
8. A portable two-hand pendant can be moved close to the pinch point without tools. What scope/geometry concern does the 2024 publisher description raise?
9. A foot-operated single control is present. The builder labels it a two-hand protective device and copies an older two-hand distance. Which source and device-class questions must be resolved?
10. A machine has a verified measured stop and a well-placed guard, but the guard is painful to remove for routine tool change, so it is often bypassed. What human-factors design change is needed without abandoning the protective function?

## 2026-10-29 source-depth reminder — moving danger point and 2024 distance terms

The [existing research addendum](../research/4400_ISO13855_2024_SEPARATION_DISTANCE_SCOPE_STOP_TIME_AND_GRAVITY_EXCEPTION_2026-10-24.md) now quotes the *scope* of Pilz's 2024-edition **manufacturer explainer**, not an inspected normative clause. Ask whether the hazardous point moves **toward** the approaching person during the protective response; distinguish fixed approach distance, `D_DS` device reach supplement, `Z` application/measurement/wear allowance and `S_M` danger-point displacement in the manufacturer's dynamic example. Require an independently evidenced hazard trajectory, not just LinuxCNC commanded position or a green stop bit. The Pilz page's highest-of-ten measured-time example is not proof of all modes/loads or a universal pass criterion. **No numerical separation distance, physical stop/hold or selected OpenPressBrake release follows.**

## Record template (copy once per distinct movement and approach path)
| Field | Entry |
|---|---|
| `SD-CASE` / revision / machine and mode | UNKNOWN |
| Hazardous movement and accessible path | UNKNOWN |
| Applicable standard edition / type-C / jurisdiction | UNKNOWN |
| Device variant, detection/actuation geometry, reach-over/under/around, inside occupancy | UNKNOWN |
| Total safety response path and independent physical stop witness | UNKNOWN |
| Measured repetitions, conditions, raw traces, worst credible result, calibration/uncertainty | NOT RUN |
| Gravity/mechanical failure/emission/maintenance energy outside distance argument | UNKNOWN |
| Independent reset, escape and deliberate fresh start | UNKNOWN |
| Operator friction/bypass route and safer usability change | UNKNOWN |
| `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART`, `VAL/PT` and release | NOT RUN / HOLD |

## Adversarial peer review
Ask another engineer to attack at least these four statements: “ten repeats prove a worst-case stop”; “one healthy safety relay proves both ram ends”; “guard distance prevents a dropped load”; “a clear presence sensor authorizes restart.” Record evidence that would falsify each claim and the independent physical observation needed. **Do not self-grade the 2520–25F0 external safety competency assessments.**

## Minimum safe-to-operate boundary
If the selected machine lacks an independently justified stopping/holding/access/restart arrangement for people exposed to its hazards, it must not operate with people exposed. Any necessary experimental work requires a separately reviewed, isolated/remote test arrangement, people outside the danger zone, qualified energy control, and plainly documented residual risk. No generic test script, PL/SIL, distance, stop time, pressure threshold or permission to energize is supplied.
