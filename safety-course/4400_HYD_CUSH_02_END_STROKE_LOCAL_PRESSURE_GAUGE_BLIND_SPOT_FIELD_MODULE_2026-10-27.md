# 4400 HYD-CUSH-02 — Cushion-pocket pressure is not always a port-gauge pressure
**Public technician field module / NON-GRADUATED**, 2026-10-27. Read [manufacturer audit](../research/4400_HYD_CUSH_02_AGGRESSIVE_HYDRAULICS_INTERNAL_CUSHION_PRESSURE_VS_PORT_GAUGE_AUDIT_2026-10-27.md). Six **UNSCORED paper scenarios** and eight **NOT RUN documentary gates**. No energized pressure tests.

## Lesson
A cylinder cushion may restrict the exiting oil in a *local internal pocket* as the piston approaches end of travel. Aggressive Hydraulics documents an exact design example where local rod-side pressure exceeds cap-side supply pressure, and an ordinary port gauge/external relief cannot directly observe/limit that pocket in the described arrangement. The example does **not** prove every cushion is built that way. A cushioning function that reduces normal impact is not an independent safety-rated stopping function.

### Six paper scenarios — UNSCORED
1. The supply gauge never exceeds its set limit. The cushion-piston drawing shows an internal check/ring/orifice pocket. Which pressure remains unproved and what physical drawing would clarify the sensor boundary?
2. A machine has a stable commanded deceleration but a rod-end seal repeatedly fails near end stroke. List competing mechanisms (including local cushion pressure, contamination, misalignment) without declaring one proven.
3. An operator adjusts a needle cushion to speed a cycle. Identify changed flow, transient pressure, deceleration, head/rod loads, safety-stop evidence and maintenance access that must be reviewed.
4. A replacement cylinder has the same external dimensions and ports but a different cushion. Explain why a matching HMI axis configuration and pump pressure do not qualify it.
5. A designer points to a manifold relief and says all pressures are protected. Trace the possible isolated internal pocket and what would establish actual relief communication.
6. A press brake holds Y1/Y2 at a safe position after E-stop, but the end cushion is unverified. Explain why successful ordinary cushioning, safe stopping, gravity restraint and service pressure isolation are **four separate propositions**.

### Eight documentary gates — NOT RUN
| Gate | Required record | HOLD trigger |
|---|---|---|
| CUSH-G1 | Selected cylinder model/revision and manufacturer section view | Cushion existence/type UNKNOWN |
| CUSH-G2 | Internal cushion orifice, ring, check and bypass topology | Pocket untraced |
| CUSH-G3 | Chamber/pocket design and transient-pressure ratings | Pump rating substituted |
| CUSH-G4 | Verified pressure sensor and relief communication to each volume | Port gauge assumed universal |
| CUSH-G5 | Load/inertia/speed and temperature/viscosity envelope | Dynamic pressure assumed from static ratio |
| CUSH-G6 | Contamination/adjuster lock and accessible service procedure | Easy untracked adjustment/bypass |
| CUSH-G7 | Independent safety stop/hold/guard/rearm witnesses | Ordinary cushion credited as safety function |
| CUSH-G8 | Change record and qualified validation plan | New cylinder/needle accepted without revalidation |

## Human factors and transfer
Prefer nonadjustable correctly engineered cushioning where appropriate; if adjustment is needed, make settings inspectable, documented and tamper-evident rather than hard to service. Provide simple access for filter service and leak inspection. Do not make the safe procedure so cumbersome that technicians defeat guards or pressure isolation. Never deliberately deadhead, obstruct or overpressurize a cylinder for teaching.

## Evidence and release
DOC-CONFIRMED manufacturer design-specific behavior; INFERENCE for other machines; UNKNOWN installed OpenPressBrake cylinder/cushion. TEST-CONFIRMED none, evaluator NOT RUN. **G0/G1 HOLD; no personnel-exposed hazardous operation.**
