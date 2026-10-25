# 4400-OVERRIDE-01 — A safety-curtain override can restore OSSDs, share a reset control, and reset its event counter
**2026-10-25 | original OEM document | DOC-CONFIRMED exact product | NON-GRADUATED**

## Unresolved engineering question
Does an override count limit itself prevent recurring unsafe bypass? Can a safety output become ON during a manual material-clearance override without a distinct reset, and does power cycling preserve the override history? This is a separate failure mechanism from blanking teach-in, timer-only guard unlock and ordinary diagnostic outputs.

## Primary source and edition
Original **SICK deTec4 HG Operating Instructions 8023856/1SWC/2026-02-05**, official manufacturer PDF https://www.sick.com/media/docs/5/75/275/operating_instructions_detec4_hg_en_im0082275.pdf ; directly inspected printed pp.49–51 (§4.3.6.4 muting override) and pp.68–70 (§4.3.7.4 Smart Box Detection Override). All facts below are **DOC-CONFIRMED** only for the cited exact product/feature and configuration. No evidence SICK is installed on OpenPressBrake.

## Distinct OEM mechanisms
1. **Muting override after a condition error (printed pp.49–50):** the manufacturer describes override as manual triggering of muting after an error, with the protective device bypassed for material clearance. An error with active muting signal and interrupted field can place the system in override-required status with OSSDs OFF; valid operator override makes OSSDs **ON**. This is not proof that hazardous machine motion is authorized or stopped.
2. **Reset can be combined with override (p.49):** an input may be configured for combined reset/override. The OEM says that on exiting override no additional reset sequence is required **if OSSDs may remain active**. The presence of a reset button does not prove it is an independent, fresh-start protective authorization.
3. **Override event counter is not lifetime evidence (pp.49–50):** the OEM limits consecutive overrides (SP2 plug configuration example: 5) but resets the count after a clean cycle, at system startup, or when certain muting states are reset. This is a product-specific anti-repetition/availability behavior, **not** a safety-validated permanent audit of all override use. Never propose cycling power as an operational bypass workaround.
4. **Smart Box Detection Override (printed pp.68–70):** the OEM warns that the protective field is **not monitored** during this override, so persons/body parts may go undetected. The manufacturer requires the control switch to be outside the hazard and the operator to oversee the whole hazard area. Triggering the specified override can turn OSSDs **ON**; on exit, a separate reset may not be required if OSSDs stay active. The event counter similarly resets on startup or after an error-free cycle.
5. **Configuration variant and auto-calibration trap (pp.49–51,69):** automatic protective-field-width calibration with a blocked field at first switch-on can delay or compromise termination of override/muting-end behavior. The OEM prescribes manual field-width setting for this condition. Do not generalize this to other curtains or invent timing thresholds.
6. **OEM use context:** the manual's muting illustrations concern material conveying, not an authorized press-brake hands-in-die mode. Never copy conveyor muting logic into a press brake without a new machine-specific SRS, hazard geometry, protective alternatives and physical validation.

## Four different propositions
| Event | May be supported by OEM | Does NOT establish |
|---|---|---|
| Override-required indication | product entered defined fault/material-interruption state | person-free danger zone or safe restart |
| Authorized override accepted | product's bypass/recovery state is active | field monitoring of personnel or hydraulic stop |
| OSSD ON | device output is enabled under selected conditions | independent safety-chain rearm or fresh LinuxCNC cycle |
| Override count below limit | counter has not exceeded this product's current consecutive limit | lifetime bypass history, physical protection or safe operation |

## Engineering and human-factors consequence (INFERENCE)
An easily accessed shared reset/override control can confuse operators and undermine separation between clearing a jam, acknowledging a fault, and deliberately authorizing motion. Prefer clear physically distinct controls and roles where risk assessment demands it; place authorized recovery controls outside the hazard with full visibility; maintain independent occupancy/access protection and no stale motion request. Make jam clearance possible without defeating safeguards: accessible removable tooling, captive guards, clear fault guidance, qualified energy isolation and mechanical load restraint. Ordinary LinuxCNC/FPGA/HMI may log state but must not decide personnel-safety override or rearm. Recurrent nuisance trips should trigger root-cause correction rather than routine override use.

## Failure-path / provenance
- **DOC-CONFIRMED:** exact SICK manual p.49 OSSD ON after muting override, possible combined reset/override, count reset on startup; pp.68–70 Smart Box Detection Override not monitored, OSSD ON and counter reset.
- **INFERENCE:** system-level design for independent fresh start, counter/history treatment, alternate access protection and safer workflows.
- **UNKNOWN:** selected machine hardware, configuration, person detection, guard layout, physical stop/hold, hydraulic pressure, safe control, selected PL/SIL, stopping distance, and independent evaluator.
- **SOURCE-CONFIRMED LinuxCNC:** no new source claim. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on.

## Physical boundary and information-gain stop
Manufacturer evidence answers the exact OEM behavior; no synthetic lab is justified. Selected OpenPressBrake G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No people-exposed operation or live override demonstration. Any experimental commissioning requires isolated/remote conditions, people outside the danger zone, qualified plan, physical stopping/holding and residual-risk evidence. No GitHub-hosted or local compute used.
