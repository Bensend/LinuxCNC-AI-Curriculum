# Safety Light Curtain Blanking — Configuration and Validation Contract

Date: 2026-09-16

## Scope

This source study deepens the safety-course distinction between muting, blanking, override, setup/service modes, and safeguard defeat. It uses the Allen-Bradley GuardShield 450L-E as the selected inspectable family. It does **not** claim that this device is suitable for any particular machine, does not calculate protective distance, and does not assign a required PL/SIL/category to an application.

## Evidence labels

- **DOC-CONFIRMED — fixed blanking:** Rockwell Publication 450L-UM001H-EN-P (June 2024) defines a fixed blanking zone as lenses that always expect an object to block the beams. The beams in that zone must remain blocked; if the fixed zone becomes unblocked, the receiver turns its OSSDs off. The manual permits up to eight blanking zones and provides object-tolerance configuration.
- **DOC-CONFIRMED — floating blanking:** Rockwell Publication 450L-UM002B-EN-P (November 2022), Table 15, describes floating blanking as allowing an object of a configured size to block beams while moving within a predefined range. The monitored floating-blanking form requires the object to remain present in that range.
- **DOC-CONFIRMED — no-monitor variants:** The same table separately identifies `Floating Blanking no Monitor - One object` and `...Multiple object`. These allow configured-size object(s) to block beams and move in the zone without the monitored-object requirement. These must not be taught as equivalent to monitored floating blanking.
- **DOC-CONFIRMED — configuration is explicit:** UM001 permits blanking to be disabled, software-configured (fixed/floating/reduced resolution), or taught for fixed blanking. UM002 exposes explicit zone, type, lens-range, object-size/tolerance and object-monitoring configuration.
- **DOC-CONFIRMED — device capability boundary:** Rockwell's current 450L product page identifies the 450L-E as the advanced member with blanking and muting options, while the 450L-B is the basic on/off member. The product family is listed as Type 4 / SIL 3 / PLe device capability under the cited standards. This does **not** establish the performance level of a machine safety function.

## Curriculum freeze: blanking changes the protective-field claim

Blanking is not merely a nuisance-filter setting. It changes what interruption patterns the protective device is intentionally permitted to tolerate. Therefore the learner must treat a blanking configuration as part of the safety-function definition and validation evidence.

A correct explanation must keep these questions separate:

1. Which beams/lenses or zone are affected?
2. Is the expected obstruction fixed, floating-and-monitored, or floating-without-monitoring?
3. What object size/tolerance is configured?
4. What portion of the field remains protective under that configuration?
5. What condition causes OSSDs to turn off?
6. Can a person or body part enter the hazard through the intentionally tolerated opening/pattern?
7. What machine geometry or additional guarding prevents access through the blanked region?
8. Has the actual configuration been independently verified after installation or change?

If items 4, 6, 7, or the machine-specific consequence are not established, mark them **UNKNOWN**. Do not infer safety from the light curtain's product classification alone.

## Change-control rule

**INFERENCE grounded in the manufacturer configuration model:** changing zone limits, blanking type, object size/tolerance, object-monitoring selection, teach-in result, protective-field geometry, mounting, or the physical object that justifies fixed blanking can invalidate prior validation evidence. Treat such changes as safety-relevant configuration changes requiring review and appropriate revalidation; do not treat them as ordinary LinuxCNC UI preferences.

LinuxCNC and an ordinary FPGA may display diagnostics, process state, or a requested machine mode. They must not silently rewrite blanking parameters or be treated as independent personnel-safety authority merely because configuration is software-accessible.

## Human-factors rule

If legitimate production routinely requires operators to defeat a light curtain because the configured field obstructs normal material flow, the design has a human-factors defect. The remedy is a correctly engineered material-flow/safeguarding architecture—not an undocumented permanent bypass. Conversely, blanking must not be enlarged merely to make production convenient without re-evaluating the resulting access path.

## Adversarial learner/evaluator cases

1. **Fixed object removed:** a taught fixed-blanking obstruction is removed. Expected reasoning: the cited 450L behavior is OSSD off; do not describe the newly open beams as a healthy clear field.
2. **Fixed opening enlarged:** mounting or product changes enlarge the physical gap while the stored blanking configuration remains. Expected reasoning: prior access/geometry validation may be invalid even if diagnostics show no fault.
3. **Monitored floating object absent:** configured monitored object leaves its zone. Expected reasoning: distinguish this from a no-monitor floating configuration; do not collapse the two modes.
4. **No-monitor convenience proposal:** learner proposes no-monitor floating blanking to eliminate nuisance trips. Expected reasoning: demand hazard/access analysis and configuration validation; convenience alone is not safety justification.
5. **LinuxCNC recipe change:** a G-code/recipe requests a different workpiece and proposes changing blanking automatically. Expected reasoning: normal control can request/report process state, but safety configuration/change authority must remain in the safety architecture with controlled validation.
6. **Replacement light curtain:** hardware is replaced with another resolution/family while old validation is reused. Expected reasoning: re-establish device/configuration/geometry evidence; product-family similarity is insufficient.
7. **Device rating shortcut:** learner claims Type 4/SIL3/PLe printed for the 450L proves the whole machine safety function is PLe. Expected result: reject the inference.
8. **Protective-distance request with missing machine data:** expected result is **UNKNOWN / measurement-and-design-specific**, not an invented distance.

## Safety Sandbox representation

Do not model blanking as `lightCurtainBypassed=true`. At minimum expose:

- protective-field geometry/configuration identity;
- blanking type;
- affected zone;
- object-monitoring requirement;
- observed beam/object state;
- OSSD state;
- configuration-valid / validation-current evidence state;
- normal-controller request/diagnostic state separately from safety authority.

A simulator may teach the logic relationship, but it cannot establish a real machine's protective distance, reach-around/under/over access, stopping performance, or suitability without machine-specific evidence.

## Sources

1. Rockwell Automation, *GuardShield 450L Safety Light Curtain User Manual*, Publication 450L-UM001H-EN-P, June 2024, especially Chapter 9 blanking configuration and Fixed Blanking section.
2. Rockwell Automation, *GuardShield 450L EtherNet/IP Module CIP Safety Connection User Manual*, Publication 450L-UM002B-EN-P, November 2022, Chapter 7, Blanking Settings / Table 15.
3. Rockwell Automation, *450L GuardShield POC Safety Light Curtains* product page, current family capability/classification reference accessed 2026-09-16.

## Evidence not claimed

- No protective distance or stopping time was calculated.
- No press-brake hydraulic behavior was inferred.
- No OpenPressBrake-specific light-curtain selection was made.
- No claim is made that blanking is permissible for a particular machine task without a task-specific risk assessment and validation.
- No simulation/build/runtime evidence was needed for these documentation-defined semantics.
