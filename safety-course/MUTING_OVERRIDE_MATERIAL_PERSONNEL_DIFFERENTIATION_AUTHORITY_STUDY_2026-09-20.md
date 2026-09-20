# Muting / Override / Material-Personnel Differentiation Authority Study

Date: 2026-09-20
Lane: independent safety curriculum Lane B
Status: durable source study; no OpenPressBrake implementation assumed

## Why this branch

Current primary-lane durable work is concentrated on enabling-device acceptance and ABB/Siemens post-replacement safety revalidation. This study intentionally uses different files and a different protective-function family: conveyor/material-transfer muting and exceptional override of electro-sensitive protective equipment (ESPE).

The subject is useful beyond conveyors because it teaches a general architecture lesson for OpenPressBrake and other machines: **temporarily suppressing one protective function is not equivalent to suppressing safety authority**. A permitted bypass needs independent qualification, bounded conditions, human/material discrimination, fault handling, and explicit recovery.

## Provenance labels

- **DOC-CONFIRMED** — stated by authoritative manufacturer documentation.
- **SOURCE-CONFIRMED** — supported by a manufacturer application/reference page.
- **TEST-CONFIRMED** — reserved for executed physical tests; none in this study.
- **COMMUNITY-REPORTED** — none used here.
- **INFERENCE** — architecture conclusion derived from confirmed evidence and labeled as such.
- **UNKNOWN** — machine-specific fact not established by evidence.

## Evidence

### Rockwell 450L GuardShield manual — muting-dependent override

**DOC-CONFIRMED:** Rockwell Publication 450L-UM001H-EN-P (June 2024) says an error in the muting sequence does not permit muting; if the light curtain is interrupted, its OSSD outputs switch off. It documents Muting Dependent Override (MDO) as a temporary means to reactivate outputs to clear stranded material. Installation of MDO is subject to application risk assessment; the control may require a spring-loaded keyswitch, is to be located where the dangerous area is visible, and automatically ends when its maximum duration expires or when the light curtain is no longer interrupted, whichever occurs first. The manual also states that muting-function reset is manual.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/450l-um001_-en-p.pdf

### Rockwell GuardLogix muting instructions — sequence and anti-person bypass

**DOC-CONFIRMED:** Rockwell TSAM/TSSM/FSBM safety instructions describe muting as temporary automatic disabling of a light-curtain protective function so material can pass. Muting sensors and the light curtain must follow the specified sequence. Rockwell explicitly warns that muting sensors must be arranged so a person cannot activate the same sequence as the material and enter while a hazardous condition exists.

**DOC-CONFIRMED:** The FSBM instruction documents that an invalid input sequence de-energizes its safety output and raises fault/clear-area state. Its override is temporary and requires a hold-to-run device from a position where the operator can see the hazard/light-curtain field. It also treats muting-lamp status as safety-relevant to whether muting remains enabled.

Sources:
- https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-00/contents-ditamap/instruction-set/safety-instructions/two-sensor-asymmetrical-muting--tsam-.html
- https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/safety-instructions/fsbm.html

### SICK Flexi Soft — exceptional override conditions

**DOC-CONFIRMED:** SICK Flexi Soft Safety Designer documentation describes Override as a means to remove transported objects stranded in the protective field after events such as power failure, emergency stop, or muting error. It warns that override can release the muting function even though no valid muting sequence occurred and the protective equipment may indicate a dangerous state. SICK requires visual inspection of the hazardous area, no person in the hazardous area, and prevention of access while override is active. The documented implementation requires a deliberate valid override input transition and limits override cycles.

Source: https://www.sick.com/media/docs/3/83/083/operating_instructions_flexi_soft_in_the_safety_designer_configuration_software_en_im0081083.pdf

### Pilz — muting is human/material differentiation, not generic bypass

**SOURCE-CONFIRMED:** Pilz describes muting as safe, automatic, temporary bypass of an ESPE for material transport. Muting sensors must be arranged so personnel cannot activate the muting sensors; personnel entering the protected zone must cause immediate shutdown of hazardous movement.

Source: https://www.pilz.com/es-ES/lexicon/muting

## Architecture freezes

1. **LIGHT CURTAIN MUTED != SAFETY SYSTEM BYPASSED.** Only the defined protective function is temporarily suppressed under qualified conditions.
2. **MATERIAL PRESENT != VALID MUTING SEQUENCE.** Sensor order/timing/direction and protective-field state matter.
3. **MUTING SENSOR ACTIVE != PERSON EXCLUDED.** Physical sensor arrangement must prevent a person from reproducing the permitted material sequence.
4. **MUTING ERROR != OVERRIDE AUTHORIZED.** Override is a separate exceptional authority with its own prerequisites.
5. **OVERRIDE REQUESTED != AREA CLEAR.** SICK explicitly requires visual hazard-area inspection and absence of people before override.
6. **OVERRIDE ACTIVE != UNBOUNDED MOTION AUTHORITY.** Manufacturer implementations bound override by hold-to-run behavior, visibility and/or time/cycle limits.
7. **FAULT CLEARED != MUTING CYCLE REQUALIFIED != PRODUCTION RESTART AUTHORIZED.** Reset, new valid muting sequence and ordinary machine start are distinct authorities.
8. **LINUXCNC/HAL/FPGA `mute=true` != PERSONNEL-SAFETY AUTHORITY.** Ordinary control may request or display state, but a safety-rated muting architecture must own the protective-function suppression and fault disposition.

## Failure-path / commissioning worksheet

A future machine-specific validation should deliberately challenge, where applicable:

| Challenge | Required observation | Evidence state |
|---|---|---|
| Person interrupts ESPE without valid material sequence | protective function remains effective; hazardous motion receives safety demand | architecture requirement; physical result UNKNOWN |
| Correct material follows valid sensor sequence | muting occurs only for intended transfer window | configuration/application specific; UNKNOWN |
| Wrong sensor order/direction | muting rejected; safe/fault disposition occurs | DOC-CONFIRMED concept; machine result UNKNOWN |
| Sensor stuck active | no indefinite permissive muting | implementation-specific; UNKNOWN |
| Material strands in field after muting fault/power event | normal sequence does not silently become valid | DOC-CONFIRMED concept |
| Override attempted without required prerequisites | override rejected | DOC-CONFIRMED concept |
| Override held beyond permitted bound | override terminates per configured/manufacturer rule | DOC-CONFIRMED concept; machine value UNKNOWN |
| Person attempts entry while override is active | architecture prevents/controls access; test only under a validated safe test method | safety requirement; physical method UNKNOWN |
| Override control cannot see hazard | commissioning failure; do not accept | DOC-CONFIRMED |
| Reset after fault | reset does not silently substitute for a valid new material/muting cycle or ordinary start | architecture freeze |
| Stale LinuxCNC conveyor/motion command survives recovery | safety requalification must not be treated as ordinary motion authority | INFERENCE; machine implementation UNKNOWN |
| Muting lamp/status diagnostic fails where used as safety input | muting disabled/faulted according to validated design | DOC-CONFIRMED for Rockwell FSBM concept |

## OpenPressBrake boundary

No claim is made that OpenPressBrake needs muting. The reusable lesson is the authority model for any maintenance/setup/protective-device suppression feature: ordinary LinuxCNC or FPGA logic must not turn a safety-device bypass request into personnel-safety permission. If OpenPressBrake ever has a legitimate protective-function suppression mode, it needs its own hazard analysis, independent safety implementation, bounded conditions, physical acceptance tests, recovery/rearm behavior, and fresh ordinary command policy.

## Explicit UNKNOWNs

No OpenPressBrake muting application, sensor count, sensor geometry, light-curtain placement, timing, override duration, conveyor speed, PL/SIL/category/DC/CCF, stopping time, safety distance, hydraulic behavior, or final-element topology is established here.

## Compute disposition

No simulation, synthesis, benchmark or executable test answers the unresolved physical questions in this study. No compute was run and no GitHub-hosted runner was used.

## Next evidence target

Seek one complete manufacturer/OEM commissioning or validation procedure that physically challenges: **valid material pass -> person-like/invalid sequence rejection -> stranded-material condition -> deliberate bounded override from a hazard-visible station -> override termination -> new complete muting cycle -> safety reset/requalification -> separate ordinary restart**. Prefer a procedure with explicit fault insertion and actual final-element/machine-response observation. If bounded search only repeats muting definitions/configuration tables, mark this branch information-gain limited and rotate.