# Guard-lock escape-release recommissioning and restart authority study

Date: 2026-09-20
Lane: independent safety curriculum Lane B
Status: SOURCE / architecture study

## Why this lane

Current main is actively advancing accessible-cell scanner geometry/restart validation and hydraulic/gravity-axis physical witness work. This study deliberately uses a different protective-device family and different files: accessible guard locking, escape/emergency release, and the recommissioning boundary after a person uses a mechanical release to leave a hazard zone.

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by cited manufacturer material.
- **DOC-CONFIRMED** — supported by repository documentation derived from authoritative material.
- **TEST-CONFIRMED** — demonstrated by an executed test. None claimed here.
- **COMMUNITY-REPORTED** — community report, not used as design authority here.
- **INFERENCE** — engineering conclusion derived from source-confirmed behavior; requires application validation.
- **UNKNOWN** — OpenPressBrake-specific fact not established by evidence.

## Source trace

### Pilz PSENmlock: accessible guards and escape release

**SOURCE-CONFIRMED:** Pilz describes PSENmlock as safe interlocking plus safe guard locking, with an optional escape release for accessible gates/poorly visible areas. Its handle module can integrate an inside escape-release handle. Pilz also offers a locking insert for multiple personal locks to prevent restart.

Source: Pilz, `Safety locking device PSENmlock` product/application page, accessed 2026-09-20.
https://www.pilz.com/en-US/products/sensor-technology/safety-switches-with-guard-locking/psenmlock-safety-locking-devices

### Pilz: escape release changes safety-output state and requires recommissioning actions

**SOURCE-CONFIRMED:** The PSEN ml door-handle/escape-release operating manual states that operating the escape release from inside the danger zone mechanically unlocks the safety gate and drives safety outputs 12/22 low. Its recommissioning sequence requires restoring the escape-release mechanism, acknowledging the stop signal in the controller, and carrying out a functional test of the escape release by qualified personnel.

Source: Pilz, `PSEN ml sa 1.1/2.1/2.2, PSEN ml DHM Operating Manual`, 1005457-EN-05, section 4.9.1.
https://www.pilz.com/download/open/PSEN_ml_sa_DHM_Op_Man__1005457-EN-05.pdf

This is stronger than treating the inside release as merely a door handle. The release event crosses a safety-state boundary and the manufacturer explicitly calls for recommissioning behavior.

### SICK TR110 Lock: emergency release restoration is not normal operation

**SOURCE-CONFIRMED:** SICK's TR110 Lock operating instructions require a deliberate restoration sequence after emergency-release use: return the release mechanism using the prescribed mechanical action, reseal the emergency release, open and close the protective device, and then perform a functional test before normal operation.

Source: SICK, `TR110 Lock Operating Instructions`, document 8023119, section 8.2.1.
https://www.sick.com/media/docs/2/82/682/operating_instructions_tr110_lock_en_im0082682.pdf

**SOURCE-CONFIRMED:** SICK also describes the optional escape release as allowing unlocking from within the hazardous area, specifically for applications where the hazard area is not completely visible from outside.

Source: SICK, `TR110 Lock` product page, accessed 2026-09-20.
https://www.sick.com/cn/en/catalog/products/safety/safety-switches/tr110-lock/c/g461653

### Pilz: power-loss and unexpected-restart problem

**SOURCE-CONFIRMED:** Pilz safeguarding guidance notes that guard locking may be required where hazardous movement has a long stopping time, and that release behavior must account for power failure and the possibility of a person being inside the danger zone. Mechanical release functions exist specifically because a control-system unlock command may not be available in that condition.

Source: Pilz, `Safety Compendium`, Chapter 4 Safeguards.
https://www.pilz.com/mam/pilz/content/editors_mm/safety_compendium_en_2017_12_low.pdf

## Architecture freeze

Preserve these inequalities:

**GUARD CLOSED != GUARD LOCKED != HAZARD CEASED**

**ESCAPE RELEASE OPERATED != PERSON OUTSIDE HAZARD != AREA CLEAR**

**ESCAPE RELEASE MECHANICALLY RESTORED != SAFETY DEVICE REQUALIFIED**

**GUARD RECLOSED != FUNCTION TEST PASSED != SAFETY REARMED**

**SAFETY REARMED != FRESH ORDINARY START**

**HMI `GATE_CLOSED=TRUE` != ESCAPE-RELEASE RECOVERY COMPLETE**

**LINUXCNC READY != PERSONNEL-SAFETY AUTHORITY**

The LinuxCNC/FPGA layer may display gate, lock, release and diagnostic state, but it must not silently convert a restored gate bit into personnel-safety authority.

## Failure-path analysis

### 1. Person uses escape release while inside

Expected safety argument:

1. escape release must be operable from the hazard side as intended;
2. guard locking is mechanically defeated/released;
3. the safety architecture observes the guard/release state required by the device/application;
4. hazardous motion remains inhibited while the guard is open or the safety state is not requalified;
5. merely closing the guard must not be treated as a production start;
6. manufacturer-required recovery/recommissioning steps are completed;
7. personnel-clear determination remains separate from device restoration;
8. a fresh ordinary start request is required after safety readiness is restored.

Items 5-8 are **INFERENCE** at the complete-machine level unless the specific machine safety design and validation procedure confirms them.

### 2. Escape release restored but person remains inside

A mechanically restored release and closed gate do not prove the hazard zone is empty. On an accessible enclosure this is a retained-person problem, not a switch-state problem. Any area-clear, trapped-key, personal-lock, presence-sensing, reset-location or other protective measure required by the risk assessment remains independently necessary.

**INFERENCE:** the commissioning test should deliberately challenge a retained-person condition rather than infer personnel-clear from the gate/lock bits.

### 3. Release used during loss of control power

Mechanical escape exists partly because control-powered unlocking may be unavailable. Restoration of control power must not be assumed to restore production authority. Power-up behavior, guard/release state, safety-device diagnostics, final elements, reset/rearm and ordinary start remain separate layers.

### 4. Emergency/auxiliary release restored without required functional test

Manufacturer instructions above explicitly require post-release functional testing in the cited device families. Therefore a maintenance practice that merely resets/reseals the mechanism and resumes production has an evidence gap.

### 5. Stale ordinary command survives recovery

If LinuxCNC/HMI retains START, CYCLE, JOG or another motion request while the safety side is being restored, safety readiness must not turn that stale request into immediate hazardous motion. Exact OpenPressBrake implementation is **UNKNOWN**; this is a required validation question, not a claimed machine fact.

## Question-driven commissioning worksheet

Do not run these on a machine until the specific hazards, safe test state and responsible personnel are defined.

| Question | Evidence to observe | Classification before test |
|---|---|---|
| Can the inside escape release be operated without normal control power? | Physical release and gate behavior | UNKNOWN for OpenPressBrake |
| What safety state changes when escape release is used? | Device outputs, evaluator state, final-element response | UNKNOWN |
| Does closing the gate alone restore hazardous-motion authority? | Safety outputs and actual final elements, not only HMI | Must be validated |
| Can a person remain inside after gate reclosure? | Deliberate retained-person challenge in a controlled validation setup | UNKNOWN |
| What recovery does the exact device require? | OEM operating manual and machine validation record | UNKNOWN until device selected |
| Is a post-release functional test required and recorded? | Device-specific procedure/result | UNKNOWN |
| What happens after power is restored with release/gate in abnormal states? | Cold-start safety state and final-element state | UNKNOWN |
| Can a stale START/CYCLE/JOG request cause motion when safety becomes ready? | Actual command freshness and physical motion witness | UNKNOWN |
| After repair/replacement, is escape function itself tested? | Deliberate inside-release functional test | UNKNOWN |

## OpenPressBrake boundary

No claim is made that OpenPressBrake presently has a guard lock, accessible enclosure, escape release, emergency release, trapped key, scanner, personal-lock provision or any specific safety architecture. Those are **UNKNOWN** until the actual machine is surveyed and the risk assessment chooses the protective measures.

Do not invent:

- required guard-locking performance level/category/SIL;
- unlock timing or stopping time;
- guard geometry or retained-person visibility;
- escape-release hardware;
- final-element topology;
- reset location;
- power-to-lock vs power-to-release principle;
- hydraulic safe state.

## Reusable lesson

An escape release is a human-survival/recovery feature, not an alternate production door control. Its operation can intentionally break the normal guard-lock state. Returning the mechanism to its normal-looking position is therefore not sufficient evidence for production release. The recovery chain must preserve the distinction between mechanical restoration, device functional proof, personnel clearance, safety requalification, final-element readiness, and fresh ordinary start authority.

## Precise next Lane-B checkpoint

Seek an authoritative OEM or manufacturer validation/commissioning procedure that shows the complete sequence:

**person inside -> escape release operated -> guard unlocked/open -> safety demand/final elements respond -> person exits -> release mechanically restored -> retained-person/area-clear decision -> guard reclosed/relocked -> required functional test -> safety reset/requalification -> stale ordinary-command challenge -> separate fresh production start**.

Prefer a procedure with explicit power-loss behavior and deliberate fault/retained-person challenge. Do not duplicate the primary lane's current accessible-cell scanner geometry work; if the source collapses back into scanner-field validation, rotate to another guard-lock-specific evidence gap.