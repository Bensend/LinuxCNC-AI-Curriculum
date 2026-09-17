# Safety Post-Incident Change Revalidation Matrix

## Purpose

Use this worksheet after an incident, near miss, safety fault, maintenance repair, replacement, configuration edit, or retrofit change to decide **which prior safety claims have been invalidated and what evidence must be rebuilt before return to service**.

This is not a universal certification checklist and does not assign PL, SIL, diagnostic coverage, stopping distance, hydraulic pressure, timing, or proof-test intervals. Machine-specific values remain `UNKNOWN` until established by authoritative design evidence and/or measurement.

## Frozen rule

> A successful repair does not automatically restore the validity of every safety claim that existed before the repair. Revalidate the claims touched by the change, including interfaces and failure paths that the change can influence.

Evidence provenance must remain explicit: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

## 1. Change identity

| Field | Record |
|---|---|
| Machine / asset | |
| Incident / work-order reference | |
| Date / responsible person | |
| Baseline drawing/configuration/revision | |
| Post-change drawing/configuration/revision | |
| Exact parts changed | |
| Exact wiring changed | |
| Safety configuration / firmware changed | |
| Ordinary LinuxCNC / HAL / FPGA / HMI changed | |
| Hydraulic / pneumatic / mechanical changed | |
| Guard / interlock / protective-device changed | |
| Temporary test equipment, jumpers, forces, overrides used | |
| Remaining `UNKNOWN` items | |

## 2. Claim-invalidation matrix

Mark each row `NOT TOUCHED`, `REVIEW`, or `INVALIDATED`. `INVALIDATED` means prior evidence may not be reused until the required review/challenge is completed.

| Change class | Safety claims potentially invalidated | Minimum evidence to rebuild before release |
|---|---|---|
| E-stop / guard / light-curtain / enabling-device wiring | protective demand detection; channel independence; discrepancy behavior; reset/restart behavior | drawing + terminal identity review; wiring inspection; bounded physical demand challenge; fault/discrepancy challenge where applicable |
| Safety controller program/configuration/firmware | demand logic; mode logic; reset; restart inhibition; output authority; diagnostics | exact configuration identity; controlled review/diff; device/manufacturer compatibility evidence; physical safety-function challenges |
| Contactor / relay / drive STO interface | final-element removal of authority; EDM/final-element witness; welded/stuck failure detection | exact replacement/substitution basis; wiring inspection; output/feedback state challenge; failure-path challenge appropriate to architecture |
| Hydraulic safety valve / monitored valve / pressure-path component | hydraulic final-element state; hazardous-energy path; monitored feedback; ram-motion prevention claim | exact component/function evidence; hydraulic drawing review; physical challenge on actual machine; measured behavior where the safety claim depends on it |
| Proportional valve / ordinary directional valve / normal actuator command path | ordinary motion behavior; stale-command behavior; interaction with independent safety authority | command-path trace; watchdog/stale-command challenge; confirm independent safety path still dominates ordinary command |
| Drive parameters / servo configuration | stopping behavior; STO/SS1 interface assumptions; restart/rearm behavior; motion limits | parameter/config identity; manufacturer documentation; physical validation of affected functions; machine-specific stopping values remain `UNKNOWN` until measured |
| LinuxCNC / HAL / PLC-like ordinary logic | normal start/rearm; stale commands; mode requests; diagnostics; process sequencing | source/config diff; restart/stale-command adversarial tests; verify ordinary controller cannot acquire personnel-safety authority |
| FPGA / transport / I/O firmware | command freshness; watchdog; output defaults; diagnostic truthfulness | version identity; source/diff review; stale/communications-loss challenge; confirm independent safety authority is not replaced by FPGA state |
| Guard, gate, fence, access door, escape hardware | reach/access boundary; interlock actuation; defeat resistance; escape; restart access | physical inspection; access/reach review; interlock/locking challenge; reset visibility/reach review; no automatic hazardous restart |
| Mechanical blocking / restraint / counterbalance / brake | gravity/stored-energy control; restrained-motion assumptions | physical inspection; manufacturer/design evidence; bounded load/functional challenge appropriate to the machine; do not infer capacity |
| Accumulator / hydraulic plumbing / hose routing | stored/reaccumulating energy; isolation boundary; pressure witness validity | updated energy-path trace; isolation/discharge review; physical verification; sensor placement reviewed against the claim it is used to prove |
| Sensor / EDM / feedback wiring | proof of final-element state; disagreement diagnostics; evidence independence | sensor identity; wiring/path trace; force each relevant disagreement where safe; verify one common failure cannot falsely prove multiple channels safe |
| Power supply / common / grounding / cabinet distribution | independence; deenergized defaults; common-cause assumptions; diagnostic validity | schematic review; power-domain trace; loss/restoration challenge; inspect shared returns/supplies that could defeat both actuation and witness |
| HMI / diagnostic-only change | operator interpretation; reset/start separation; stale-state annunciation | verify HMI remains non-authoritative for safety; stale/unavailable state test; reset/start control path review |

## 3. Change-radius review

Do not stop at the replaced component. Trace outward until the safety claim boundary is reached.

`changed item -> input/demand -> safety logic -> safety output -> final element -> energy path -> hazardous physical effect`

Also trace the evidence path independently:

`physical/final-element state -> witness/sensor/aux contact -> safety diagnostics -> operator record/display`

For each shared element between the actuation path and evidence path, record whether a common failure could both defeat the function and falsely indicate success.

| Safety function / claim | Changed item can affect it? | Prior evidence still valid? | New evidence required | Provenance / result |
|---|---|---|---|---|
| Emergency stop | | | | |
| Guard / protective-device stop | | | | |
| Guard locking / access release | | | | |
| Reset / restart inhibition | | | | |
| Mode selection / enabling | | | | |
| Final-element monitoring / EDM | | | | |
| STO / drive torque authority | | | | |
| Hydraulic hazardous-energy control | | | | |
| Gravity / stored mechanical energy | | | | |
| Communications/watchdog containment | | | | |
| Power-loss/restoration behavior | | | | |
| Diagnostics / annunciation truthfulness | | | | |

## 4. Evidence hierarchy after a change

A configuration checksum proves configuration identity, not physical safety behavior. A safety output OFF proves an output state, not necessarily final-element state. EDM proves only what its physical witness actually observes. A pressure indication proves only the pressure at the measured point under the documented conditions. LinuxCNC/HAL/FPGA command state is ordinary-control evidence unless the actual architecture establishes otherwise.

Use the strongest evidence needed for the claim:

1. exact controlled configuration/drawing/part identity;
2. authoritative manufacturer/source documentation;
3. inspection of installation and energy path;
4. direct final-element or energy-path witness;
5. bounded physical challenge of the affected safety function;
6. fault-path challenge where the safety claim depends on detection/tolerance of that fault.

Never promote a weaker observation into a stronger claim merely because the stronger observation is inconvenient to obtain.

## 5. Post-incident preservation versus repair

Before changing evidence, preserve incident state when it can be done without delaying personnel protection, emergency response, isolation, blocking, restraint, or other necessary hazard control. Reference `SAFETY_INCIDENT_EVIDENCE_PRESERVATION_FIRST_RESPONSE_CARD.md` and `SAFETY_INCIDENT_RECONSTRUCTION_EVIDENCE_CONFIDENCE_WORKSHEET.md`.

Record any repair action that destroys or changes evidence. The post-repair condition must not be silently substituted for the pre-incident condition.

## 6. Return-to-service gate

Do not release merely because normal production motion works.

Release requires all of the following to be positively resolved for the affected change radius:

- exact installed identity and controlled configuration are known;
- temporary jumpers, software forces, test fixtures and diagnostic overrides are removed or formally accounted for;
- guards and protective devices are restored and functional;
- affected safety functions have been challenged at the physical layer required by their claims;
- reset, safety reset, ordinary-controller rearm and START remain correctly separated;
- stale commands cannot resume hazardous motion merely because safety/control/power returns;
- affected final-element feedback and diagnostic witnesses are credible and not simply copied command state;
- stored/reaccumulating electrical, hydraulic, pneumatic, gravity and mechanical energy paths are accounted for;
- unresolved safety-relevant `UNKNOWN` items either block release or are bounded by an explicitly justified safe limitation;
- evidence and configuration records are updated to match the machine actually being released.

If a defect affects safe operation, the machine remains **OUT OF SERVICE** until the affected safety claim is restored and supported by evidence.

## 7. Evidence basis

### `SOURCE-CONFIRMED`

- OSHA 29 CFR 1910.147 defines servicing/maintenance to include modifying machinery and requires hazardous-energy control where covered. It also requires newly installed, replaced, major-repaired, renovated, or modified equipment to have energy-isolating devices designed to accept lockout devices where applicable.
- OSHA machine-guarding guidance states that maintenance release includes inspection to ensure guards and other safety devices are in place and functional, checking the area before energization/startup, and notification of affected employees. It also states that training is needed when new or altered safeguards are put into service.
- OSHA guidance warns that a safeguard that interferes with the job may be overridden or disregarded; defeat resistance and usability therefore belong in change review rather than being treated only as operator-discipline issues.

### `DOC-CONFIRMED`

- Pilz machinery-safety validation guidance treats validation as confirmation that protective measures are correctly implemented and the safety system is functional. Its published validation model distinguishes previously validated/minor changes from complex/significant changes, supporting a change-radius approach rather than assuming every modification requires either zero validation or an identical full-machine test scope.

### `INFERENCE`

- The matrix's exact `NOT TOUCHED / REVIEW / INVALIDATED` workflow and evidence tiers are curriculum engineering structure, not quoted regulatory language.
- Revalidation scope should expand when a changed component participates in several safety functions or shares common-cause dependencies. It may remain bounded when evidence establishes that other safety claims are genuinely outside the change radius.

### `UNKNOWN`

- Required PL/SIL/category/DC for a particular OpenPressBrake build.
- Exact safe stopping distance/time.
- Exact hydraulic safe-state truth table and pressure thresholds.
- Exact proof-test interval.
- Whether a particular machine change constitutes a legally significant/substantial modification in a specific jurisdiction.

Those questions require the actual machine, risk assessment, applicable jurisdiction/product standard, authoritative component documentation, and/or measurement.

## 8. Curriculum takeaway

The practical maintenance question is not simply **“does the machine run after the repair?”** It is:

> **Which safety claims depended on what changed, what prior evidence became stale, and what direct evidence now proves those claims again?**

That question keeps ordinary LinuxCNC/FPGA functionality, diagnostic convenience, and production pressure from silently substituting for personnel-safety validation.