# 2540 — Machine final elements: contactor, drive STO, and fluid-power paths

Session start: 2026-09-23T02:35:00Z

## Purpose

A safety relay/controller output is not the physical safe state. This lesson follows three deliberately different final-element paths and requires the learner to keep five propositions separate:

`command state -> diagnostic witness -> final-element state -> hazardous-energy state -> physical safe-state proposition`

Do not transfer evidence from one proposition to another without an explicit justified link.

## Path A — safety logic -> contactor -> motor power

Typical abstract chain:

`SF request -> safety output -> contactor coil -> main contacts -> motor electrical supply -> machine motion/energy`

A contactor auxiliary NC used for feedback can be a useful diagnostic witness only when its relationship to the main contacts is documented. Siemens describes a mirror contact under IEC 60947-4-1 as an auxiliary NC contact that cannot be closed simultaneously with an NO main contact. Its safety-application guidance states that correct feedback monitoring requires mirror contacts and that this permits detection of covered main-contact faults before restart.

That still does **not** prove shaft standstill, brake engagement, gravity-load holding, pressure exhaustion, personnel clearance, or electrical isolation at every hazardous point.

### Failure traces

1. **Welded main contact** — ordinary auxiliary feedback may lie if its mechanical relationship is not guaranteed. A documented mirror contact provides a stronger covered proposition: the NC feedback cannot indicate the corresponding open-state relationship while the NO main contact remains closed under the covered condition.
2. **Wrong contactor/utilization selection** — adequate carry current does not establish ability to interrupt the actual AC/DC, inductive, motor, transformer, solenoid, or other load. The final element must be selected for the real switching duty.
3. **Suppression change** — a changed coil suppressor can change release dynamics. Treat it as part of the validated final-element implementation, not harmless wiring detail.
4. **Common power/common actuator** — two logic channels converging on one unanalysed contactor or common upstream/downstream energy path are not automatically two independent physical interruption paths.
5. **Replacement drift** — same coil voltage/package/contact count does not establish mirror-contact behavior, utilization category, reliability data, or validated release behavior.

### Evidence boundary

A healthy feedback circuit can support a proposition about the contactor state it is designed to witness. Machine stopping time and the actual hazardous-motion state require machine-level evidence where relevant.

## Path B — safety logic -> certified drive STO -> torque-producing switching inhibited

Rockwell's current PowerFlex 755T safety documentation describes STO as removing power from the gate-firing circuits so the output power devices cannot turn on to generate AC power to the motor. It explicitly warns that STO only disables motor torque: suspended loads, pump/fan back-pressure, inertia, stored energy, or external mechanical forces can still cause rotation. The documentation also states that STO does not provide electrical safety and dangerous voltage can remain.

Therefore the chain is not:

`STO active -> machine safe`

It is closer to:

`STO request -> safety path accepted -> torque-producing switching inhibited -> drive-generated motor torque proposition -> machine-specific consequences`

Those consequences may require additional safety functions such as braking, monitored standstill, mechanical restraint, isolation, or other measures depending on the hazard analysis.

### Failure/maintenance traces

- A status bit that says STO is active is not itself proof of shaft standstill.
- A drive's certified STO capability does not transfer its PL/SIL to the complete machine function.
- STO does not substitute for electrical isolation for electrical work.
- A gravity-loaded axis can move after torque removal; the safe-state proposition must address the load physics.
- Safety configuration/bypass state matters. A maintenance or commissioning change that permits torque invalidates assumptions that depended on STO being active.

## Path C — safety logic -> fluid-power final element -> pressure/flow state

A fluid-power path has different physics. A command to a valve, and even a valve-position witness, do not automatically prove the downstream hazardous-energy state.

SMC's VP/VG safety residual-pressure-release family documents main-valve position detection as a way to detect inconsistency between input signals and valve operation. Its redundant configuration uses two residual-pressure-release valves so the other can release residual pressure if one fails. SMC explicitly warns that the product is a component of a safety system and cannot alone guarantee safety of the equipment as a whole.

Its newer VPX400 family combines dual residual-pressure release, soft start-up, and main-valve inconsistency detection. Published exhaust-flow values are component characteristics, not proof that an arbitrary machine volume has reached a safe pressure within a required time.

### Failure traces

- **Valve commanded to exhaust, spool witness agrees, pressure trapped elsewhere** — diagnostic witness passes while the physical safe-state proposition can remain false.
- **Common manifold/blockage/contamination** — nominally redundant valve channels may share a physical dependency.
- **Gravity load** — exhausting pressure can itself create hazardous motion unless load holding/blocking is independently addressed.
- **Stored accumulator or trapped volume** — upstream isolation or valve state does not establish downstream energy removal.
- **Replacement valve** — matching port size and voltage does not establish safety architecture, monitored position behavior, exhaust capacity, failure behavior, or timing.

Machine-specific pressure thresholds, valve truth tables, exhaust time, load-holding behavior, and required redundancy remain `UNKNOWN` until derived from the actual SRS/design and validated.

## Direct switching versus logic feeding a separately engineered final element

A safety relay may directly switch a load only when the device documentation and the complete safety-function design support that exact use. The decision must account for at least:

- actual load type and utilization/switching category;
- AC versus DC interruption;
- resistive versus inductive behavior and inrush;
- switching frequency/use profile and reliability assumptions;
- required contact/output protection and suppression;
- effect of suppression on release/fault behavior;
- output fault behavior and required diagnostics;
- whether feedback/EDM observes the proposition that matters;
- whether the switched element is itself the final energy-removal element or only commands another one;
- machine-level physical proof after the final element acts.

When those conditions are not established, treat the safety relay as safety logic/control feeding a separately engineered final element rather than assuming its output contacts are universally suitable power interrupters.

## Cross-path comparison

| Layer | Contactor path | Drive STO path | Fluid-power path |
|---|---|---|---|
| command | de-energize/operate contactor | assert STO | command safety valve state |
| possible diagnostic witness | documented mirror/feedback contact | safety-function status/drive diagnostics | monitored main-valve position |
| final-element proposition | covered main contacts open | torque-producing switching inhibited | covered valve element reached monitored state |
| hazardous-energy proposition | motor supply interrupted at defined point | drive-generated torque disabled; other energy may remain | pressure/flow changed only as plumbing and physics establish |
| physical safe-state proof | machine-specific motion/energy proof | standstill/load restraint/etc. if required | pressure/load/trapped-energy proof if required |

## Mapping to the 2520 validation methodology

For each safety function, validation must separately identify:

1. **Design verification** — component suitability, switching category, architecture, dependencies, documented safety capability.
2. **Functional validation** — requested safety action produces the intended final-element command/state.
3. **Fault/diagnostic validation** — covered welded contact, discrepancy, channel, feedback, bypass/configuration and common-cause cases are detected/reacted to as claimed.
4. **Physical-process proof** — actual hazardous motion/pressure/energy reaches the required safe-state proposition within any required machine-specific limits.
5. **Recovery/restart validation** — fault clearance/reset does not itself authorize hazardous restart.
6. **Maintenance/change revalidation** — replacement contactor, suppressor, drive parameter/safety configuration, valve, plumbing, brake, load mechanics, or wiring changes trigger impact analysis and the required revalidation.

## Adversarial cases

- Both safety outputs drop; contactor auxiliary says open; shaft is still coasting. **Do not call standstill proved.**
- STO reports active on a suspended vertical axis. **Do not call the load held.**
- Two monitored exhaust valves indicate expected position but an isolated branch retains pressure. **Do not call residual energy removed.**
- A technician replaces a contactor with the same current rating but without documented mirror-contact behavior. **Prior EDM proposition is stale.**
- A technician adds a stronger coil suppressor to reduce transients. **Release-time evidence is stale until impact is resolved.**
- A safety relay output is rated 6 A resistive and is proposed for a DC solenoid drawing far less than 6 A. **Current magnitude alone is insufficient switching evidence.**

## New freezes

- **FINAL-ELEMENT COMMAND != FINAL-ELEMENT STATE.**
- **FINAL-ELEMENT STATE != HAZARDOUS-ENERGY STATE.**
- **HAZARDOUS-ENERGY STATE != PHYSICAL SAFE-STATE PROPOSITION UNLESS THE SRS DEFINES AND VALIDATION PROVES THE LINK.**
- **MIRROR/EDM FEEDBACK != SHAFT STANDSTILL OR COMPLETE ENERGY REMOVAL.**
- **STO ACTIVE != ELECTRICAL ISOLATION, STANDSTILL, OR GRAVITY-LOAD RESTRAINT.**
- **VALVE POSITION FEEDBACK != DOWNSTREAM SAFE PRESSURE.**
- **OUTPUT CURRENT RATING != PERMISSION TO SWITCH AN ARBITRARY LOAD.**
- **MAINTENANCE-EQUIVALENT LOOKING PART != VALIDATED SAFETY-EQUIVALENT PART.**

## Provenance / evidence classification

- Siemens, *Contactors in safety applications*, Entry-ID 109807687 V1.1 (2023): mirror-contact/feedback-circuit behavior — `DOC-CONFIRMED`.
- Rockwell Automation, PowerFlex 755T Safe Stop Functional Safety and PowerFlex 755 Integrated Safety STO documentation (current web/manual evidence inspected 2026-09-23): STO gate-firing/torque boundary, residual/external motion and electrical-safety warnings — `DOC-CONFIRMED`.
- SMC VP/VG and VPX400 safety exhaust product documentation (current web evidence inspected 2026-09-23): monitored valve position, redundant exhaust architecture, component/system boundary — `DOC-CONFIRMED`.
- Cross-layer proposition separation and validation mapping — `INFERENCE`, derived conservatively from the documented component boundaries and the existing 2520 methodology.
- Any machine-specific stop time, safe pressure, valve truth table, load-holding behavior, required PL/SIL, diagnostic coverage or architecture not explicitly established for a named design — `UNKNOWN`.

## Compute decision

No simulation/build/synthesis/benchmark/test was needed. The unresolved questions here are design- and machine-specific physical propositions; generic compute would not resolve them. No GitHub-hosted compute is justified.