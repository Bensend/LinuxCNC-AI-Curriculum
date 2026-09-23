# 25C0 — Human-factors checklist for machine playbooks and adversarial review

## Required checklist

Every machine-specific safety playbook should answer these questions for normal production, setup, recovery/jam clearing, cleaning, inspection and maintenance. `N/A` requires a reason; `UNKNOWN` is preferable to invented behavior.

### Task and access
- What legitimate task brings a person near/inside the hazard boundary?
- How often is the task expected and how much friction does the safeguard add?
- Can the task be moved outside the hazard boundary by tooling, remote adjustment, better workholding, viewing, lighting or process redesign?
- Does the task require guard opening/removal, and can restoration be captive/hinged/keyed so correct reassembly is easier than abandonment?

### Incentive and foreseeable defeat
- What does the user gain by defeating the safeguard: time, visibility, access, preserved machine state, easier diagnosis, fewer nuisance trips?
- What bypass can be performed with readily available objects/tools or normal machine-use tools?
- Does coding/tamper resistance address that bypass without leaving the incentive untouched?
- Are repeated bypasses, spare actuators, taped sensors, bridges, removed guards or repeated indiscriminate resets treated as design feedback?

### Diagnostics and recovery
- Does the HMI distinguish the actual blocking cause rather than displaying generic `SAFETY FAULT`?
- Can ordinary LinuxCNC show safety status/diagnostics without gaining authority to clear the safety function?
- Is the recovery sequence obvious, bounded and shorter than an improvised bypass?
- Does reset/rearm remain separate from motion start?
- Can the resetter observe the protected space where required, and is pass-through/hidden occupancy addressed?

### Setup and alternative modes
- Is there a legitimate restricted setup/recovery mode when production safeguarding cannot support the necessary task?
- What hazardous functions remain permitted, at what independently justified restrictions, and through what safety-related controls?
- Does an enabling/hold-to-run device merely permit the restricted function rather than becoming unrestricted motion authority?
- Can ordinary software mode selection silently weaken the personnel-safety boundary? If yes, redesign the authority boundary.

### Maintenance
- Is hazardous energy isolated/restraint established independently of production interlocks?
- Are guards/interlocks easy to reinstall and realign after service?
- Are fasteners captive or otherwise difficult to lose where practical?
- Are connectors keyed/labeled and diagnostics useful enough that technicians need not bridge channels to troubleshoot?
- Does replacement/change control require revalidation of affected safety evidence?

### Nuisance-trip response
- What physical or configuration cause produced the trip?
- Is contamination, misalignment, vibration, timing, cable routing, process variation or component degradation plausible?
- Does the proposed fix preserve the original safety requirement?
- If a timing/threshold is widened, what evidence shows the safety function still meets its response requirement?

## Low-cost design patterns

Prefer inexpensive friction removal before exotic hardware: hinged guards; captive fasteners; clear panels; task lighting; mirrors/cameras where suitable; external adjustment points; keyed connectors; clear status indicators; local diagnostic text; deliberate visible reset stations; accessible isolation points; designed cleaning access; and restricted setup/recovery modes when justified. None of these substitutes for the required safety integrity or physical safe state; they reduce pressure to defeat it.

## Adversarial cases

### 1 — The nuisance light curtain
A material tail intermittently breaks a light curtain and stops production. The supervisor asks to increase muting time until trips disappear. Learner must diagnose whether muting is even the correct function, identify what safety requirement/timing evidence would become stale, and seek a process/sensor-layout fix before weakening the safeguard. Do not invent a safe muting time.

### 2 — Blind reset around the corner
A cell gate can be reset from an HMI that cannot see the whole protected space. Production likes the location because it is near the next operation. Learner must separate gate closure, reset/rearm, occupancy knowledge and motion start; moving reset or adding presence/visibility measures is an engineering question, not an operator-training substitute.

### 3 — Guard never came back after maintenance
A bolted cover requires awkward alignment and loose hardware. After repeated service it is left off and its switch is tied back. Learner must address why restoration is burdensome: hinge/captive hardware/locating features/service access plus appropriate defeat resistance, while retaining maintenance isolation.

### 4 — Setup mode becomes production mode
A three-position enabling device and reduced-motion setup mode make alignment practical. Operators discover setup mode also makes short production runs easier and leave the selector there. Learner must address mode authorization, function restriction, indication and incentive; `tell them not to` is insufficient.

### 5 — Generic safety fault
A machine stops several times per shift with only `Safety fault`. Technicians bridge inputs to determine whether the guard, EDM or drive is responsible. Learner must design useful diagnostics that observe safety state without giving ordinary LinuxCNC authority to override it.

### 6 — Production target versus interlock
A coded interlock is difficult to spoof, but opening the guard loses process state and forces a five-minute restart after a routine inspection. A spare coded actuator appears on the machine. Learner must recognize that stronger coding alone did not remove the defeat incentive and redesign inspection/recovery workflow while preserving the hazard boundary.

## Critical evaluation failures

- blaming operators without identifying the legitimate task/incentive;
- weakening timing, muting, interlock or reset behavior solely to remove nuisance trips;
- using training/procedure as the only control where a practical engineering measure exists;
- making LinuxCNC/ordinary PLC/HMI the sole personnel-safety authority;
- treating high coding as proof that defeat is impossible;
- treating a closed guard or clear field as proof no person remains inside;
- treating production interlocks as maintenance energy isolation;
- inventing stopping times, safe speeds, pressure thresholds or integrity ratings.

## Provenance

The defeat-incentive and lifecycle principles are DOC-CONFIRMED from ISO 14119-oriented Pilz/Schmersal guidance cited in the 25C0 entry artifact. The checklist and adversarial cases are INFERENCE: engineering applications of those principles that require machine-specific validation before use as a final design.
