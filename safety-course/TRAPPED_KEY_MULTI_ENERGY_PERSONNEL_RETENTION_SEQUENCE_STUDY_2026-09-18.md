# Trapped-key multi-energy personnel-retention sequence study — 2026-09-18

## Purpose

Independent Lane-B study of a professional mechanical safety architecture that ties hazardous-energy isolation, access permission, personnel retention and restart prevention together without making ordinary LinuxCNC/FPGA state the personnel-safety authority.

This is deliberately independent of the primary lane's active gravity-axis brake-proof/failure-disposition work and does not modify those artifacts.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly supported by cited manufacturer material.
- **DOC-CONFIRMED** — behavior directly stated by an authoritative document in this evidence package.
- **TEST-CONFIRMED** — demonstrated by controlled test. None in this study.
- **COMMUNITY-REPORTED** — community observation not independently verified. None relied upon here.
- **INFERENCE** — engineering conclusion derived from cited evidence; not a machine-specific fact.
- **UNKNOWN** — requires actual machine design, validation or measurement.

## Authoritative evidence

### Fortress entry-looper / multi-person access sequence

**SOURCE-CONFIRMED:** Fortress Safety's steel-processing entry-looper application describes a key-operated switch that isolates machine power, transfer of the isolation key to a key-exchange device, release of access keys, and access locks that release personnel keys. Personnel keep their keys until the work is complete; the access key remains trapped until the personnel key is returned. Restart requires reversing the sequence.

Source: Fortress Safety, *Entry Looper in Steel Processing*: https://fortress-safety.com/application/entry-looper-in-steel-processing/

### Fortress trapped-key architecture and multiple energy sources

**SOURCE-CONFIRMED:** Fortress describes trapped-key energy-control devices for electrical, pneumatic and hydraulic sources. For multiple hazardous-energy sources, the associated keys can be required at a key-exchange device before downstream access keys are released. At an access lock, a personnel key can be forced out before access and retained by the person; until it is returned, the access key remains trapped and the access lock cannot reset.

Source: Fortress Safety, *Understanding Trapped Key Systems*: https://fortress-safety.com/news/understanding-trapped-key-systems/

**SOURCE-CONFIRMED:** Fortress's Alfred brochure gives a concrete two-energy example: fluid-power valves and electrical power are isolated by separate trapped-key devices, and the sequential key exchange prevents access until both sources are isolated.

Source: Fortress Safety, *Interlocks for Hazardous Environments — Alfred brochure*: https://fortress-safety.com/wp-content/uploads/2021/07/EN-Alfred-Brochure-August-2021-v1.1-Digital-Version.pdf

### Stored energy and a machine-specific professional example

**SOURCE-CONFIRMED:** Fortress's internal-rubber-mixer example identifies electrical motor isolation, compressed-air isolation/discharge, hydraulic accumulator draining and a mechanical scotch pin for a floating weight. It states that keys are released when the associated energy/power sources are reduced to zero; where stored energy exists, a time delay can prevent key release until energy dissipates. It also explicitly notes that removing hydraulic energy from the ram creates a hazard requiring the ram to be held and locked before entry.

Source: Fortress Safety, *Example of a Trapped Key Interlock System in the Control of Multiple Energy Sources* (Nov. 2020): https://fortress-safety.com/wp-content/uploads/2022/03/Fortress-Article-Example-of-a-Trapped-Key-Interlock-System-in-the-Control-of-Multiple-Energy-Sources-November-2020.pdf

### Electronic personnel-retention comparison

**SOURCE-CONFIRMED:** Pilz's PSS 4000 key-in-pocket maintenance safeguarding stores each authenticated person's security ID in a safe list. Restart is not enabled until every person has signed out and the safe list is empty. Pilz describes the function as protection against unauthorized/unplanned restart while personnel remain in the danger zone.

Source: Pilz, *System release PSS 4000 1.25 — Key-in-pocket solution*: https://www.pilz.com/en-US/company/news/articles/238605

## Boundary freeze

**INFERENCE:** The curriculum must keep these states distinct:

**ENERGY SOURCE COMMANDED OFF != ENERGY SOURCE PHYSICALLY ISOLATED != STORED ENERGY CONTROLLED != ACCESS KEY RELEASED != GUARD OPEN PERMITTED != PERSONNEL KEY RETAINED != PERSONNEL CLEAR != ALL KEYS RETURNED != SAFETY SEQUENCE RESET != ORDINARY START AUTHORITY.**

A key sequence can encode an interdependency between physical isolation, access and restart prevention, but possession/return of a key is not universal proof that every hazard is absent. The actual energy-control device and retained/stored-energy disposition still require machine-specific proof.

## Architecture lessons

1. **Personnel-retention authority is independent of ordinary control.** **SOURCE-CONFIRMED/INFERENCE:** Both the mechanical personnel-key example and Pilz's safety-controller safe list prevent restart based on retained-person state. LinuxCNC/HAL/ordinary FPGA may display or consume this state, but should not be the sole memory/authority for bodily-entry personnel retention.
2. **Multiple energy sources need composition before access.** **SOURCE-CONFIRMED:** A key exchange can require keys from multiple energy-control devices before access keys are available. This is a concrete architecture for preventing an electrical-only isolation from being mistaken for complete machine isolation.
3. **Energy removal can create a new hazard.** **SOURCE-CONFIRMED:** The rubber-mixer example explicitly says removing hydraulic energy from the ram creates a hazard and therefore requires mechanical holding/locking. `POWER OFF` is not automatically `MECHANICALLY SAFE`.
4. **Stored energy is its own state.** **SOURCE-CONFIRMED/INFERENCE:** Time delay, discharge, blocking or other validated means may be required before access. The correct method and threshold are machine-specific; no generic delay proves OpenPressBrake safe.
5. **A personnel key is a proactive restart inhibit, not an E-stop.** **SOURCE-CONFIRMED/INFERENCE:** Its job in these examples is to keep the access/reset sequence incomplete while a person retains the key. It does not replace emergency stopping, escape release, or physical hazard control.
6. **All-person return is different from guard closure.** **SOURCE-CONFIRMED:** In multi-person access, an access lock cannot reset merely because a door is closed if personnel keys remain out. This directly supports the existing curriculum distinction `ACCESS CLEAR != PERSONNEL CLEAR`.
7. **Sequence restoration is not ordinary START.** **INFERENCE:** Reassembling the trapped-key chain should restore the prerequisites for safety release; it should not be treated as fresh production-motion intent. Ordinary START/JOG/ENABLE remains separate.
8. **Key uniqueness/configuration is safety-relevant.** **INFERENCE:** A duplicated/wrong key capable of satisfying the wrong lock can defeat the encoded sequence; commissioning and maintenance therefore need key identity/control checks, not merely a functional door-open test.

## Failure-path worksheet

| Challenge | Dangerous false assumption | Required evidence/question |
|---|---|---|
| Electrical isolator key released | all hazardous energy is controlled | What hydraulic, pneumatic, gravity, stored or alternate electrical sources remain? |
| Hydraulic source removed | ram/load is safe | Does removal create an unsupported gravity/load hazard requiring blocking/restraint? |
| Timer expires | energy is definitely zero | What does the actual application validate the delay against; is direct state sensing required? |
| One energy key reaches exchange | access is now safe | Does the exchange require every required energy-source key before releasing access keys? |
| Guard closes with person inside | restart is possible | Is a personnel key still retained, or does a safe personnel list remain nonempty? |
| Personnel key returned by wrong person | area is clear | What administrative/technical control ties retention/return to the people actually inside? |
| Duplicate/wrong-system key fits | key identity is irrelevant | Are key codes/uniqueness controlled across adjacent systems and replacements? |
| Access key mechanically available | hazard is absent | Which physical isolation/discharge/retaining elements caused that key to become available? |
| Power cycle occurs during access | ordinary startup logic can reset | Does the physical/safety retention state survive independently of LinuxCNC/PLC startup state? |
| Last personnel key returned | machine may move immediately | What safety reset/rearm and fresh ordinary START are separately required? |
| Isolation sequence bypassed for maintenance | tags/HMI warning are enough | Is the machine physically controlled against every relevant hazard and unmistakably out of service? |
| Escape route blocked | restart prevention protects trapped person | Is independent escape/emergency egress provided where bodily entry requires it? |

## Question-driven commissioning/validation plan

No simulation is needed to answer these questions; they require document review and later physical machine validation.

1. Identify every hazardous-energy source and every source that can remain after ordinary control power is removed.
2. Trace the physical element that isolates, dissipates, blocks or restrains each source.
3. For each key release, record exactly which physical state it witnesses and which states it does **not** witness.
4. Challenge one missing energy-source key at a time: access keys must not become available where the validated sequence requires all sources controlled.
5. Challenge one retained personnel key at a time: the sequence must not return to restart-ready while any required personnel key is out.
6. Challenge guard closure while a personnel key remains retained; guard closure alone must not prove personnel clear.
7. Challenge power loss/restoration while access is open/personnel key retained; ordinary controller reboot must not recreate production authority.
8. Challenge wrong/duplicate/spare keys according to the installed key-management plan.
9. Verify stored-energy and gravity/load controls by the machine-specific validated method rather than by assuming a generic timer or OFF indication is sufficient.
10. After all personnel are clear and the safety sequence is restored, verify that a separate fresh ordinary START is required before hazardous production motion.

## OpenPressBrake UNKNOWNs

Do **not** infer from this study:

- that OpenPressBrake will use a trapped-key system;
- the number or type of hazardous-energy sources on the target press brake;
- the hydraulic isolation/dump/blocking arrangement;
- whether a mechanical ram support is required or how it would be designed;
- safe pressure, discharge time, stopping distance, retained load or force;
- the number of personnel/access keys or gates;
- any key coding scheme;
- any PL/SIL/category/DC claim;
- any validated maintenance or entry procedure.

These remain **UNKNOWN** until the real machine architecture and required measurements/validation exist.

## Practical curriculum rule

**INFERENCE:** For bodily-entry maintenance, teach the chain as:

`ORDINARY STOP -> CONTROL EVERY REQUIRED ENERGY SOURCE -> CONTROL STORED/GRAVITY ENERGY -> SAFETY SEQUENCE PERMITS ACCESS -> EACH PERSON RETAINS RESTART-INHIBIT AUTHORITY -> ALL PEOPLE EXIT -> ALL PERSONNEL RETENTION CLEARED -> SAFEGUARDS/ENERGY CONTROLS RESTORED IN VALIDATED ORDER -> SAFETY RELEASE/REARM -> FRESH ORDINARY START.`

Do not shorten this to `E-STOP -> OPEN DOOR -> WORK -> CLOSE DOOR -> START`.

## Compute decision

No executable verification is justified. This is a source-tracing and architecture/failure-path task, so no GitHub Actions workflow was run and no hosted or self-hosted compute was consumed.

## Precise next independent work

Find a professional multi-energy machine implementation with a full schematic or sequence exposing **electrical isolation + fluid-power isolation + stored-energy disposition + access key exchange + multi-person retention + escape/recovery + separate restart**, then map every key to the physical state it actually witnesses. Prefer an implementation that exposes a failure or wrong-sequence case. If the primary lane moves onto that exact package, rotate Lane B to key-duplication/wrong-key common-cause analysis or escape-release/restart-inhibit interaction rather than touching gravity-axis brake-proof artifacts.