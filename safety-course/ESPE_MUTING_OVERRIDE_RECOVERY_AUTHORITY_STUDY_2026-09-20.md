# ESPE Muting, Override, and Recovery Authority Study — 2026-09-20

## Lane and scope

Independent safety-curriculum Lane B. Selected after re-reading current progress/recent commits: the primary lane is advancing Cincinnati AUTOFORM counterbalance drift localization, component swapping, pressure recheck, and the still-open post-replacement retaining-function proof. This study intentionally uses different files and a different safety-function family.

This is an architecture/commissioning study, not an OpenPressBrake design prescription. Whether OpenPressBrake needs ESPE muting is **UNKNOWN**.

## Evidence labels

- **DOC-CONFIRMED** — directly supported by manufacturer documentation cited below.
- **SOURCE-CONFIRMED** — directly supported by inspectable source/configuration; none added in this pass.
- **TEST-CONFIRMED** — physically/executably demonstrated; none added in this pass.
- **COMMUNITY-REPORTED** — community report; none used as authority here.
- **INFERENCE** — engineering conclusion drawn from cited evidence, clearly separated from facts.
- **UNKNOWN** — machine/application fact requiring actual design data or measurement.

## Why this matters

Muting deliberately and temporarily suspends an electro-sensitive protective device (ESPE) so intended material can cross a protected boundary. That makes it a useful curriculum case for learning that a safety function can contain a deliberately reduced-protection state without turning ordinary LinuxCNC/HAL/FPGA logic into personnel-safety authority.

The recovery case is especially important. A jammed pallet/material load can leave an ESPE interrupted and one or more muting sensors active after the normal muting sequence faults. Professional implementations provide a constrained **override** path to clear that condition. Override is not a generic bypass, maintenance enable, or production start.

## Manufacturer evidence

### Pilz — muting purpose and sensor arrangement

**DOC-CONFIRMED:** Pilz describes muting as safe, automatic, temporary suspension of an ESPE during operation so material can be transported into/out of a danger zone. The muting cycle is indicated by a muting lamp. Special muting sensors are arranged so a person cannot activate them; sequential muting requires the sensors to change in a defined sequence, while cross muting requires the relevant sensors together.

Source: Pilz, “Muting: a simple explanation,” https://www.pilz.com/en-INT/lexicon/muting (retrieved 2026-09-20).

### SICK deTec4 — override is a bounded recovery state

**DOC-CONFIRMED:** SICK deTec4 documentation says `Override required` is reached only under defined conditions including a muting error/end, at least one muting signal active, and an interrupted ESPE. The operator initiates integrated override with a control switch; the OSSDs may then return ON while override is monitored. Override duration is bounded by total muting time and consecutive override use is limited; exceeding the permitted count leads to lockout.

Source: SICK deTec4 operating instructions 8021645, edition 2025-03-27, section 4.3.6, https://www.sick.com/media/docs/1/41/841/operating_instructions_detec4_safety_light_curtain_en_im0079841.pdf .

### SICK Flexi Classic Muting — visibility and repeated-override fault disposition

**DOC-CONFIRMED:** SICK Flexi Classic Muting defines override as manual initiation of muting after a muting-condition error to clear the system/restore an error-free state. Its warning requires the override control to be placed where the operator has a clear view of the entire hazardous area and requires muting components/sensors to be checked before override. If two successive muting cycles require override, the muting arrangement and sensors are to be examined and verified.

Source: SICK Flexi Classic Muting operating instructions 8012507/1NU8, 2024-09-09, section 5.5, https://www.sick.com/media/docs/6/26/926/Operating_instructions_Flexi_Classic_Muting_Modular_safety_controller_en_IM0026926.PDF .

### SICK Flexi Compact — personnel-clear boundary

**DOC-CONFIRMED:** SICK Flexi Compact explicitly warns that override gives restricted safety and says override is to be used only after visual inspection establishes that nobody is in the hazardous area and nobody can enter while override is being used. It also defines an override input sequence and limits repeated override cycles.

Source: SICK Flexi Compact operating instructions 8026634/8026636, Override function, https://www.sick.com/media/docs/9/79/279/operating_instructions_8026634_en_im0096279.pdf .

## Architecture freeze

Do not collapse these states:

**MATERIAL PRESENT != VALID MUTING REQUEST != VALID MUTING SENSOR SEQUENCE != ESPE TEMPORARILY MUTED != MUTING REMAINS VALID != MUTING ENDED != ESPE PROTECTIVE FUNCTION RESTORED**

and, for recovery:

**MUTING ERROR != OVERRIDE REQUIRED != HAZARDOUS AREA VISUALLY CLEAR != OVERRIDE INTENTIONALLY REQUESTED != OVERRIDE ACTIVE != MATERIAL CLEARED != NORMAL MUTING/ESPE STATE RESTORED != SAFETY REQUALIFICATION COMPLETE != FRESH ORDINARY PRODUCTION START**

Further freeze:

**LINUXCNC/HMI “MUTED” DISPLAY != SAFETY-EVALUATED MUTING STATE**

**OVERRIDE CONTROL ACTIVE != GENERIC SAFEGUARD BYPASS AUTHORITY**

**OVERRIDE COMPLETE != PERSONNEL CLEAR FOR ALL OTHER HAZARDS != PRODUCTION START**

## Practical safety boundary

**INFERENCE:** LinuxCNC/HAL/FPGA may request conveyor/material motion and may display safety diagnostics, but ordinary control must not be the sole authority deciding that a person-like intrusion is acceptable while the ESPE is suspended. The safety-related muting evaluator, its sensor geometry/sequence, ESPE state, override conditions, and required final safety outputs remain an independent safety-function boundary.

**INFERENCE:** A stuck muting sensor is dangerous not merely because it causes downtime but because a permanently plausible muting request could erode the intended person-versus-material discrimination. Sequence/concurrence/time monitoring and bounded override therefore belong in commissioning and maintenance evidence.

## Question-driven commissioning worksheet

The actual application must derive its timings, geometry, safety performance and acceptance limits from its risk assessment and device/OEM documentation. Do not copy example values from this study.

1. **Normal material pass:** prove the intended object initiates the documented sensor sequence and the ESPE is muted only for the intended transit interval.
2. **Person-like approach:** physically verify the chosen sensor geometry cannot be plausibly actuated by a person in the way the allowed material does. Use the application’s approved validation method; do not improvise hazardous exposure.
3. **Wrong sequence:** challenge an approved simulated out-of-sequence sensor condition and witness the documented safe/fault response.
4. **Concurrency/timing fault:** challenge the applicable sensor timing rule and witness muting refusal or fault rather than silently extended muting.
5. **Stuck sensor:** simulate/force an approved stuck-active sensor state and prove normal production cannot indefinitely retain muting authority.
6. **ESPE interrupted without valid muting:** prove the safety outputs/final elements respond as required.
7. **Override eligibility:** prove the override control cannot act as a general bypass when `Override required` conditions are absent.
8. **Override visibility/personnel-clear:** prove the recovery procedure gives the operator the required hazardous-area visibility and requires personnel-clear confirmation before override.
9. **Override boundedness:** prove override ends under the documented conditions and repeated abnormal recovery reaches the required inspection/lockout disposition rather than becoming routine production practice.
10. **Power loss/E-stop during muting:** verify the documented recovery sequence; do not assume a retained sensor state is fresh muting authority after restoration.
11. **Stale ordinary command:** hold or retain LinuxCNC conveyor/START/CYCLE state across a muting/override fault and prove restoration of the safety function does not silently convert stale ordinary state into unintended hazardous motion.
12. **Physical final element:** where the ESPE safety claim requires hazardous motion to stop, witness the actual relevant final element and physical machine behavior, not only an OSSD/HAL bit.
13. **Maintenance/replacement:** after changing a muting sensor, ESPE, mounting, wiring, safety evaluator or configuration, repeat the required geometry/sequence/function validation before production release.

## Failure-path table

| Fault/challenge | Evidence needed | What must not be inferred |
|---|---|---|
| One muting sensor stuck active | safety evaluator state + physical sensor state + fault/recovery disposition | `sensor active = valid material transit` |
| Wrong sensor order | documented rejection/fault response | `all sensors eventually active = valid muting` |
| ESPE interrupted with invalid muting | safety output + actual final-element/physical response | `muting-related input exists = ESPE may be ignored` |
| Jam leaves ESPE blocked | override-required state + area-clear procedure + bounded recovery | `jam = permission to bypass safeguard` |
| Repeated override | inspection/lockout disposition | `operator can keep overriding indefinitely` |
| Power restoration mid-cycle | documented requalification sequence | `retained sensor bits = fresh muting authority` |
| LinuxCNC command retained | stale-command rejection / separate fresh initiation | `safety recovery = start` |

## OpenPressBrake facts deliberately left UNKNOWN

- whether any production material-flow function needs ESPE muting at all;
- ESPE type/location and protective-field geometry;
- muting sensor count, technology, spacing, direction logic, sequence or timing;
- whether a person can enter or remain behind the ESPE;
- safety evaluator architecture and required PL/SIL/category/DC/CCF;
- muting lamp/indication requirements for the actual application;
- override hardware/location and whether override is permitted;
- final electrical/hydraulic/mechanical elements affected by the ESPE;
- stopping time/distance and safe-distance calculations;
- reset/restart/rearm sequence;
- any machine-specific timing or acceptance threshold.

## Compute decision

No simulation, synthesis, benchmark or executable test is justified by the unresolved question in this pass. The useful evidence is manufacturer documentation and architecture/failure-path analysis. Therefore no GitHub-hosted compute and no self-hosted runner compute was used.

## Precise next-work checkpoint

Prefer a complete professional implementation or commissioning example that exposes:

`material approach -> muting sensor geometry -> ordered/concurrent safety evaluation -> ESPE temporary suspension -> material transit -> muting termination -> ESPE restoration`

and the abnormal path:

`sequence/timing/sensor fault -> ESPE interrupted -> override required -> operator full-area visibility/personnel-clear -> deliberate bounded override -> material removal -> normal protective function restored -> abnormal-repeat inspection/lockout -> safety requalification -> stale ordinary-command challenge -> separate fresh production start`.

Highest-value addition would be an OEM/system example containing wiring/configuration plus a documented failed muting sequence and recovery test, not another generic definition of muting.