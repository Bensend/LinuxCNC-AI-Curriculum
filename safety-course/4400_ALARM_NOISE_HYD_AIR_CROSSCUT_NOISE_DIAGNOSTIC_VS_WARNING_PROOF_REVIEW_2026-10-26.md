# 4400 crosscut — hydraulic noise as diagnostic symptom and as warning-masking source
**2026-10-26 | adversarial paper architecture review, not new test/score**

## The shared physical variable is not shared safety authority
A machine can produce more sound **because** a hydraulic fluid or inlet problem is developing, at the same time that the increased sound makes a normal warning harder to perceive. This creates a plausible **common-cause human-exposure path** without implying that any selected machine exhibits it.

`hydraulic aeration / cavitation / inlet restriction` → `possible acoustic/vibration change and erratic normal motion` → (a) `ordinary controller deviation` and (b) `changed ambient warning reception`. Neither (a) nor (b) is proof of independent `Y1/Y2 stop + gravity hold + energy isolation + zone clear + fresh start`.

## Evidence boundaries
- **DOC-CONFIRMED direct OEM:** [Bosch Rexroth 2026](../research/4400_HYD_AIR_01_BOSCH_PARKER_CAVITATION_AERATION_AND_ERRATIC_ACTUATOR_OEM_AUDIT_2026-10-26.md) distinguishes vapor cavitation from air entry and describes noise as a nonunique symptom. [Parker T20 manual](../research/4400_HYD_AIR_01_BOSCH_PARKER_CAVITATION_AERATION_AND_ERRATIC_ACTUATOR_OEM_AUDIT_2026-10-26.md) documents air-associated erratic rotary actuator operation. [NIOSH/OSHA/WERMA audit](../research/4400_ALARM_NOISE_01_OSHA_NIOSH_WERMA_PERCEPTIBILITY_AND_AUTHORITY_AUDIT_2026-10-26.md) establishes warning reception and worker noise dose as separate from product dBA at 1 m.
- **INFERENCE:** the same developing hydraulic fault *could* both degrade ordinary motion behavior and mask an alarm. This requires an actual acoustic/hydraulic path to be established; no measured OpenPressBrake noise, masking level, hydraulic response or stopping consequence is known.
- **UNKNOWN:** whether the installed machine has the relevant hydraulic fault, alarm, acoustics, operating mode, hearing/PPE configuration or independent physical protection. No machine-specific pressure, dBA acceptance, stop distance or PL/SIL is inferred.

## Four adversarial claims to reject
| Claim | Why it fails | Qualified next evidence |
|---|---|---|
| "Pump noise is a reliable cavitation detector." | Aeration, seal leak, cold viscosity and mechanical causes overlap; noise is not a unique mechanism. | Selected pump OEM and qualified isolated suction/fluid diagnosis. |
| "The alarm is rated 90 dBA so workers will hear it." | Exact OEM rating is at 1 m; machine noise, distance, protection and hearing differ. | Worker-position/mode acoustic reception review. |
| "The sound stopped when oil warmed; no maintenance needed." | Cold-start inlet/viscosity condition can recur; disappearance is not root-cause proof. | OEM cold-start envelope, fluid/filter/level and maintenance history. |
| "The machine can warn people and continue because its HMI says healthy." | Warning/HMI does not detect people or prove independent physical stop/hold. | Safety SRS, selected final elements, qualified physical stop/hold/energy witness and fresh restart. |

## Low-friction safe pattern and change control
Keep the protective safety chain independent of the normal warning and ordinary PID. Make suction/filter/fluid checks accessible only through correctly isolated, load-supported maintenance, and make guards easy to reinstall. Reduce hydraulic noise at its cause rather than simply turning a buzzer louder; maintain distinct, perceivable alarms with multimodal accommodations. An acoustic enclosure, replacement pump, filter, fluid, buzzer, PPE, mode or warning-location change is a `CHG` event potentially staling both warning reception and hydraulic/safety evidence. Do not open pressurized fittings or operate an unsupported ram to collect a sound sample.

**Result:** a documentary **crosscut causal hypothesis**, no additional public paper cases, no new desk gates, no test, no evaluator, no compute. G0/G1 HOLD; personnel-exposed hazardous operation not authorized.
