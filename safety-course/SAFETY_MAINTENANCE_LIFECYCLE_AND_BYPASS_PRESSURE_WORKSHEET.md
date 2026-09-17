# Safety Maintenance Lifecycle and Bypass-Pressure Worksheet

Status: ACTIVE CURRICULUM ARTIFACT  
Date: 2026-09-17

## Purpose

Join configuration-baseline control, periodic latent-failure challenge, anomaly/trend review, repair/replacement equivalence, scoped revalidation, and human-factors defeat resistance into one repeatable machine-maintenance lifecycle.

This worksheet is intentionally qualitative. It does **not** invent universal test intervals, nuisance-trip counts, stopping distances, pressure limits, PL/SIL/DC, diagnostic coverage, or machine-specific hydraulic truth tables.

## Evidence labels

Use `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, or `UNKNOWN` on substantive claims. A safety-critical `UNKNOWN` that affects the proposed operating state remains `UNKNOWN — NOT CLEARED` until evidence closes it.

## Frozen lifecycle

`validated baseline -> periodic challenge/inspection -> anomaly or change trigger -> preserve evidence/restrict affected state -> root-cause investigation -> controlled repair/replacement -> scoped revalidation -> new validated baseline`

A reset, power cycle, software restart, successful production cycle, or later passing challenge does not erase an earlier safety discrepancy.

## Gate 1 — identify the validated baseline

Record:

- machine/configuration identifier and revision;
- electrical and fluid-power drawing revisions;
- safety-controller application/signature/CRC where applicable;
- safety-I/O and protective-device identities/configurations;
- final contactor, valve, brake, drive-safe-function and feedback/EDM identities;
- LinuxCNC/HAL and FPGA/firmware identity where these affect ordinary control, monitoring, command freshness, diagnostics, or interface assumptions;
- physical guard/interlock arrangement;
- known stored-energy/gravity controls;
- commissioning/validation evidence establishing this combination.

A matching software CRC proves configuration identity only within its documented scope. It does not prove unchanged field wiring, plumbing, mechanics, guard geometry, final-element behavior, or physical hazardous-energy result.

## Gate 2 — periodic challenge and latent-failure discovery

Challenge the safety functions at the interval established by the machine-specific safety design, manufacturer requirements, risk assessment, or maintenance plan. Do not invent an interval here.

Separate observations by layer:

| Layer | What to preserve |
|---|---|
| Demand/input | protective-device state and actual demand |
| Safety logic | evaluated state, discrepancy/fault state, safety output request |
| Final element | contactor/valve/brake/drive-safe-function state |
| Feedback | EDM/auxiliary/position/pressure or other designed witness |
| Physical hazard | actual controlled energy/motion result where the validation method requires it |
| Restart | reset, rearm, deliberate start and stale-command behavior |
| Configuration | identities/signatures/revisions relevant to the test |

A diagnostic bit is not automatically an independent physical witness.

## Gate 3 — anomaly / nuisance-trip / bypass-pressure trigger

Treat each of these as evidence, not merely lost production:

- failed challenge that later passes;
- intermittent channel discrepancy;
- unexplained safety trip;
- repeated need to realign, reset, power-cycle or reseat a safety-related device;
- worsening contactor/valve/guard/sensor behavior;
- repeated operator or maintenance requests to defeat, mute, widen, mask, jumper, force, or remove a safeguard;
- a safeguard that makes an expected operating/setup/maintenance task unnecessarily difficult;
- configuration or replacement mismatch;
- evidence of actual manipulation.

### Human-factors rule

OSHA machine-guarding guidance states that a safeguard that interferes with doing the job quickly and comfortably may be overridden or disregarded. Pilz likewise identifies convenience, time/performance pressure, poor ergonomics and simplified operating modes as manipulation incentives, and recommends finding the incentive, improving the protection concept, and reviewing whether the incentive was actually reduced.

Therefore repeated bypass pressure is an **engineering input**. The corrective objective is not merely stronger warnings or a harder-to-find jumper. Improve the legitimate safe workflow while preserving the required risk reduction.

## Gate 4 — distinguish a protective demand from a nuisance symptom

Before suppressing anything, answer:

1. Did a real person/object/hazard condition enter the protective device's designed demand condition?
2. Did the protective device itself disagree/fault, or did downstream safety logic/final-element feedback disagree?
3. Did ordinary LinuxCNC/HAL/FPGA control create a legitimate operating conflict that exposed a bad workflow rather than a bad safeguard?
4. Was the event caused by contamination, alignment, vibration, wiring, power quality, connector damage, hydraulic/pneumatic behavior, environmental conditions, configuration, timing, or an actual final-element fault?
5. Did reset/power-cycle only clear evidence without explaining the physical cause?
6. Is the proposed 'fix' changing a safety setting, muting condition, mode, diagnostic, timing parameter, guard geometry, or protective-device location? If yes, treat it as a safety-function change requiring appropriate revalidation, not routine troubleshooting.

Do not classify a trip as nuisance solely because production could have continued if the protection had not acted.

## Gate 5 — root-cause trace

Use this trace before corrective action:

`symptom -> demand/input evidence -> safety-logic evidence -> final-element/EDM evidence -> physical-energy witness -> recurrence context -> likely failure family -> independent check -> corrective action`

Check common-cause families explicitly:

- shared 24-V or return/reference fault;
- shared connector/cable route;
- environmental contamination/temperature/vibration;
- one configuration change affecting multiple channels;
- common network/communications dependency;
- common hydraulic/pneumatic contamination or pressure source;
- shared feedback/witness path that can make multiple channels agree falsely;
- one ordinary-control software object both requesting a mode and masking/synthesizing feedback.

If evidence cannot distinguish competing safety-critical causes, preserve `UNKNOWN — NOT CLEARED`; do not widen a setting to make the symptom disappear.

## Gate 6 — choose a controlled corrective action

Prefer, in order appropriate to the actual evidence:

- repair the defective device/wiring/mechanics/plumbing;
- correct installation/alignment/environmental cause;
- replace a component using the replacement-equivalence worksheet;
- improve guard access, ergonomics, visibility, material handling, lubrication/service access, or legitimate setup workflow so correct safeguard use is easier;
- provide an engineered operating/setup/service mode where the risk assessment supports it, with independent safety constraints rather than a raw bypass;
- redesign the protection concept when the existing concept predictably drives defeat.

Do **not** default to:

- masking a safety fault in LinuxCNC/HAL/PLC/HMI;
- increasing discrepancy/EDM/muting windows without design evidence;
- defeating a guard switch or light curtain;
- converting manual reset into automatic restart;
- treating an ordinary FPGA watchdog as personnel-safety authority;
- disabling feedback because it causes trips;
- leaving a maintenance jumper, force or diagnostic configuration installed for production.

For servicing/maintenance involving bypass/removal of a guard or exposure to unexpected energization/stored energy, apply the applicable hazardous-energy-control procedure. Ordinary control-system OFF commands are not substitutes for physical energy control where lockout/tagout or equivalent hazardous-energy control is required.

## Gate 7 — repair/replacement equivalence

For every changed part, configuration, wire, hose, fitting, guard, sensor position, safety parameter, drive setting or control interface, record:

- what changed;
- why it changed;
- safety functions touched;
- fail state and final-element behavior;
- feedback/EDM compatibility;
- electrical/fluid/mechanical ratings and protection coordination relevant to the safety function;
- configuration identity and compatibility;
- common-cause dependencies introduced/removed;
- restart/reset/rearm behavior affected;
- physical hazard-control result requiring re-proof.

'Engineering replacement', successor model, same connector, same voltage/current, or restored backup is candidate evidence, not automatic equivalence proof.

## Gate 8 — scoped revalidation

Revalidate every safety claim touched directly or indirectly by the change. Include adjacent functions when they share:

- input channels;
- safety logic/configuration;
- final elements;
- feedback/EDM;
- power/returns;
- communications;
- guard geometry or protective field;
- hydraulic/pneumatic energy paths;
- restart/mode-selection logic;
- common physical witness.

A narrow part swap can require wider revalidation if it changes a shared dependency.

Where safe and applicable, prove both:

1. **control chain:** protective demand -> safety logic -> final element -> feedback/EDM -> reset/restart behavior; and
2. **physical hazard chain:** hazardous energy source -> controlling/isolation element -> actuator/hazard result.

Do not infer the second from the first.

## Gate 9 — establish the new validated baseline

Close the maintenance event only when:

- temporary jumpers, forces, lifted wires, test plugs, external supplies, diagnostic firmware/configuration, temporary hoses and bypasses are reconciled;
- guards and protective devices are restored and usable without avoidable friction;
- machine drawings/configuration records reflect the installed state;
- required revalidation has passed;
- safety-critical UNKNOWN items affecting the intended operating state are closed or the affected state remains restricted;
- restart after reset, power restoration, controller reboot and communications recovery cannot turn stale ordinary-control commands into unintended hazardous authority;
- the machine is either released to its defined operating state or unmistakably left OUT OF SERVICE.

The new baseline supersedes the old one only after the evidence package is complete.

## Adversarial review prompts

- The light curtain trips twice a week but always resets. What evidence proves it is nuisance rather than detecting a real intrusion, alignment loss or common power fault?
- A mechanic installs a jumper only while clearing jams because the guarded access is awkward. Is the jumper the root cause, or evidence that the safe maintenance/setup path is badly engineered?
- A replacement contactor has the same coil voltage and power rating but different auxiliary-contact behavior. Which EDM and restart claims must be reopened?
- Two safety channels fail together only on hot afternoons. Which common-cause families should be investigated before changing discrepancy timing?
- A new LinuxCNC configuration removes an annoying warning while the independent safety chain still trips correctly. What diagnostic evidence was lost, and could that loss hide degradation without being safety authority itself?
- A later periodic test passes after a power cycle. Why does the earlier failed challenge remain in the trend record?

## Cross-machine transfer

Apply the same lifecycle while preserving machine-specific hazards:

- **press brake:** ram/gravity/hydraulic energy, foot controls, front/rear guarding, laser/AOPD, valve monitoring;
- **plasma/laser:** torch/beam process energy, gantry motion, fume/fire hazards, access guarding;
- **mill/lathe:** spindle, axes, chuck/workholding, enclosure/interlocks;
- **robot/cell:** access/occupancy, mode/enabling devices, multiple energy sources and restart zones;
- **automated feeder/saw:** stored material energy, clamp/feed/cut authorities and remote restart.

Never copy machine-specific thresholds or safety performance claims across classes without evidence.

## Evidence basis for this synthesis

- **DOC-CONFIRMED:** OSHA machine-guarding guidance says safeguards should create no interference and notes that interference with quick/comfortable work may lead to override/disregard; it also recommends safe lubrication without removing safeguards where possible.
- **DOC-CONFIRMED:** OSHA 29 CFR 1910.147 covers servicing/maintenance where unexpected energization/startup or stored-energy release can injure and requires documented hazardous-energy-control procedures in applicable cases; bypass/removal of a guard during normal production servicing is specifically relevant to its application provisions.
- **DOC-CONFIRMED:** Pilz manipulation-protection guidance identifies speed, convenience, performance pressure, poor ergonomics and operating-mode simplification as motives, and recommends identifying the manipulation incentive, optimizing the protection concept and checking effectiveness.
- **INFERENCE:** repeated bypass pressure should therefore be tracked alongside periodic safety anomalies as a maintainability/design signal, while the actual safety response remains determined by the machine-specific risk assessment and validated safety architecture.

## OpenPressBrake boundary

LinuxCNC, HAL, ordinary PLC logic and the normal FPGA may request normal actions and provide diagnostics. They must not become the sole personnel-safety authority merely because nuisance trips or maintenance workflow are inconvenient. Physical safety authority, final elements and hazardous-energy controls remain distinct and must be validated independently.
