# 25F0 — Lathe/turning-center safety capstone delta

Session start UTC: 2026-09-23T23:35:07Z

## Purpose and evidence boundary

This file transfers the mill/VMC capstone contract to an enclosed CNC lathe/turning center. It records only the delta: what transfers unchanged, what changes because the physical hazard changes, and what is newly required. It is not a universal lathe circuit.

Evidence classes used here: **DOC-CONFIRMED**, **INFERENCE**, **UNKNOWN**.

Machine-specific chuck pressure/force thresholds, spindle stopping time, bar diameter/length/speed limits, tailstock force, enclosure containment capability, PLr/SIL targets, diagnostic coverage and proof-test intervals remain **UNKNOWN** unless established for the actual machine.

## Authoritative anchors

1. OSHA's lathe-chuck interpretation applies the general machine-guarding requirement to workholding hazards and notes that workholding projections/irregular shape/pinch points can require a fixed or movable guard or other effective protection. **DOC-CONFIRMED.** Source: OSHA, `Appropriate guarding of lathe chucks`, 1979-01-26, https://www.osha.gov/laws-regs/standardinterpretations/1979-01-26
2. Haas' current lathe safety guidance states that improperly clamped or oversized parts may be ejected with deadly force; rated chuck speed must not be exceeded; unsupported barstock must not extend outside the drawtube; hydraulic pressure must be set correctly; and marginally clamped/oversized work can require reduced spindle speed because an ejected part can penetrate the safety door. **DOC-CONFIRMED for that Haas family.** Source: Haas, `Lathe - Operators Manual - Safety`, accessed 2026-09-23, https://www.haascnc.com/service/service-content/guide-procedures/lathe---operators-manual---safety.html
3. The same Haas guidance warns that unsupported projecting bar can bend and whip, and tells operators to keep clear of the tailstock/workholding area whenever automatic motion is possible. **DOC-CONFIRMED.**
4. Haas' 2025 lathe manual exposes separate commands for chuck clamp/unclamp, turret rotation, tailstock advance/retract, spindle orientation/brake and auxiliary mechanisms. **DOC-CONFIRMED for that product family.** These establish distinct commanded mechanisms, not generic safety behavior. Source: Haas, `English - Lathe Operator’s Manual - NGC - 2025`.
5. Haas' current control documentation notes that lowering a programmed chuck-pressure setting does not immediately reduce gripping force while the chuck remains clamped; the chuck must stop, unclamp and reclamp for the lower setting to take effect. **DOC-CONFIRMED for that product family.** This is a useful warning against treating a requested pressure value as proof of physical gripping state.
6. Haas' lathe manual warns that a tailstock command can move away from and then back toward a workpiece and may cause the workpiece to drop, and that after a power interruption a servo tailstock may require re-reference because control position knowledge is incomplete. **DOC-CONFIRMED for that product family.**

## What transfers unchanged from the mill/VMC baseline

The following mill requirements transfer in principle without changing their safety proposition:

- **M-SF-06 reset/restart -> L-SF-08:** restoring a guard/safety input establishes eligibility only; it must not itself start hazardous spindle, axis, turret, chuck, tailstock, bar-feed or auxiliary motion.
- **M-SF-07 maintenance isolation -> L-SF-09:** production interlocks and ordinary CNC E-stop state are not maintenance energy isolation. Electrical, fluid, gravity/stored mechanical and other hazardous energy still require task-appropriate isolation, relief/restraint and verification.
- **Authority allocation:** ordinary LinuxCNC/HAL/FPGA may command, request, display and diagnose states, but is not credited as personnel-safety authority merely because it reacts quickly or reports a plausible state.
- **Validation principle:** status bits, command state and software sequence completion do not substitute for the physical proposition named in the SRS.
- **Human-factor principle:** setup, clearing and recovery must be engineered so the correct protected path is easier than bridging a guard or defeating an interlock.

## What transfers but must change

### Mill production enclosure access -> lathe production enclosure access

The generic interlock/restart logic transfers, but the enclosure has an additional critical proposition: containment of rotating workholding, workpiece and tool/projectile hazards within the intended operating envelope. Door-closed/interlock-healthy proves neither correct workholding nor enclosure containment capability.

**Freeze:** `DOOR INTERLOCK HEALTHY != WORKPIECE RETENTION PROVED`.

**Freeze:** `ENCLOSURE CLOSED != CONTAINMENT CAPABILITY PROVED`.

### Mill spindle coast -> lathe spindle/workholding kinetic state

Physical standstill/access timing still matters, but the rotating mass now includes chuck/workholding and workpiece. Workholding retention can degrade with speed and setup. A spindle-stop command is not proof that the chuck/workpiece is stationary or retained.

### Mill axis motion -> lathe axes/turret/tooling motion

X/Z and other configured axes transfer as ordinary motion hazards. Turret indexing adds a machine-specific crush/shear/collision mechanism and can move tooling through occupied space even when cutting interpolation is not active.

### Mill auxiliary fluid power -> chuck/tailstock/subspindle actuation

The generic supply-isolation/trapped-energy/load-restraint reasoning transfers, but lathe fluid power may directly own workpiece retention. Removing pressure indiscriminately can itself create the dangerous event by releasing the workpiece. The safe state must therefore be derived from the actual task and mechanism rather than equating `pressure off` with `safe`.

**Freeze:** `FLUID POWER REMOVED != WORKPIECE RETAINED`.

## New lathe-specific hazardous events and SRS clauses

### L-SF-01 — chuck/workholding retention

During any state in which loss of workholding can create a dangerous event, the safety design shall preserve the required physical retention or prevent the hazardous spindle/machine state. A command such as `chuck clamp`, a hydraulic solenoid state, pressure setpoint, or ordinary CNC indication is not by itself proof of adequate physical retention.

Validation must address the actual workholding architecture, intended workpiece envelope, credible loss-of-pressure/actuation faults, and the relationship between spindle state and clamp state. Required force/pressure thresholds remain **UNKNOWN** until justified for the machine/workholding combination.

**Freeze:** `CHUCK CLAMP COMMAND != WORKPIECE RETENTION PROVED`.

**Freeze:** `PRESSURE SETPOINT != GRIPPING FORCE PROVED`.

### L-SF-02 — workpiece/chuck ejection and containment

The intended operating envelope shall keep workholding/workpiece ejection risk within the machine's validated containment and workholding capability. Oversize, marginally clamped, excessive-speed, damaged-jaw and otherwise abnormal setups shall not be treated as safe merely because the door is interlocked.

Enclosure condition is part of this proposition: damaged windows/panels or an operating condition outside the validated envelope can invalidate containment assumptions.

### L-SF-03 — projecting bar / bar feeder

Where stock passes through the spindle/drawtube, unsupported projecting stock, rotating whip, feeder/indexing motion and unexpected stock advance shall be included in the hazard boundary. The design shall define the permissible stock/support/guarding envelope and prevent operation outside it as required by the machine design.

Bar length, diameter, spindle-speed limits, support geometry and feeder interlocks remain **UNKNOWN** until the specific machine/bar system is selected.

**Freeze:** `SPINDLE ENCLOSURE CLOSED != REAR BAR-STOCK HAZARD CONTROLLED`.

### L-SF-04 — turret/indexing motion

Protected access and recovery shall prevent hazardous turret indexing/unlock/rotation or other tool-station motion unless a separately justified setup mode and alternate protection apply. Ordinary program state or `axis stopped` indication does not establish that the turret mechanism cannot index.

### L-SF-05 — tailstock/subspindle/work-support motion

Where fitted, tailstock/subspindle/work-support motion shall be treated as a separate crush/pinch and workpiece-retention path. A safety demand must not create a secondary dangerous event by releasing support in a way that drops/ejects the workpiece. Power-loss/recovery and loss of position/reference knowledge must be included where applicable.

**Freeze:** `TORQUE/MOTION REMOVED != WORKPIECE SUPPORT PRESERVED`.

### L-SF-06 — setup/jog/manual recovery

The machine shall provide a deliberately bounded way to perform justified setup, chucking, probing, tool/turret setup and recovery tasks without turning guard defeat into the normal workflow. Any reduced-performance/manual mode must state its alternate protection, permitted mechanisms, exit behavior and restart boundary.

### L-SF-07 — entanglement/rotating-stock access

The safety architecture shall account for direct access to rotating chuck/workpiece/bar stock and entanglement hazards. Reduced spindle speed is not automatically an acceptable substitute for guarding; any alternate mode requires its own risk-derived specification and validation.

### L-SF-08 — reset/restart

Transferred from M-SF-06 and extended to chuck, turret, tailstock, subspindle, bar feeder and parts-handling mechanisms. Reset/rearm establishes eligibility only. A separate deliberate production action remains necessary.

### L-SF-09 — servicing/maintenance isolation

Transferred from M-SF-07. Chuck/turret/tailstock/bar-feeder stored energy and workpiece/support state must be considered in addition to electrical isolation. Service procedures must not cause uncontrolled workpiece release.

## Authority allocation delta

| Layer | Lathe-specific role | Must not be credited with |
|---|---|---|
| ordinary LinuxCNC/HAL/FPGA | spindle/chuck/turret/tailstock/bar-feed commands; cycle sequencing; UI/status | physical clamp force, containment, standstill, safe pressure, support retention or personnel-safety authority without qualifying architecture/evidence |
| monitoring/diagnostics | pressure/status display, clamp command/state, spindle speed, turret/tailstock/bar-feed status, discrepancy alarms | proof that the workpiece is actually retained or that a projectile will be contained |
| independent safety-related control | safety input evaluation, safe-state allocation, restart gating, safety final-element commands/diagnostics | propositions beyond its actual sensing/final elements |
| physical final elements | drive safety function/contactors, chuck actuator/valves, brakes, guard locks, tailstock/subspindle restraint, feeder safety devices | universal safe state merely from component presence |
| physical machine/guarding | enclosure, safety windows/panels, chuck/jaws/workholding, stock supports, mechanical restraints | correctness outside validated operating envelope |

## Adversarial failure paths

1. **Healthy door interlock + bad workholding:** door reports locked and spindle is permitted, but the part is marginally clamped. Software evidence is healthy while ejection risk remains.
2. **Clamp command + pressure fault:** ordinary control says `clamped`, but a leak/regulator/actuator fault means the physical retention proposition is not established.
3. **Safe spindle stop + unsupported rear bar:** front enclosure is closed and spindle logic is correct, but projecting stock can whip outside that enclosure.
4. **Guard demand + tailstock release:** stopping ordinary motion but removing work support can create a drop/ejection hazard.
5. **Axis stopped + turret mechanism available:** X/Z are stationary while an independent turret index/unlock path can still create hazardous motion.
6. **Power restoration + stale position knowledge:** ordinary state restoration occurs before a machine-specific tailstock/subspindle mechanism has re-established trustworthy position/reference state.

## Validation delta

| SRS | Representative stimulus/fault | Physical evidence required |
|---|---|---|
| L-SF-01 | clamp/unclamp sequence; credible pressure/actuation loss; restart | actual retention-safe behavior for specified architecture; no reliance on command bit alone |
| L-SF-02 | representative permitted workholding/process envelope; guard/enclosure inspection | enclosure/workholding condition and machine-specific containment evidence |
| L-SF-03 | bar-feed/index states; support/guard fault; restart | physical stock/support/feeder behavior and rear hazard-zone protection |
| L-SF-04 | access demand/fault during turret states | physical turret non-hazardous response and prevention of unexpected indexing |
| L-SF-05 | access/E-stop/power-loss/recovery with work support engaged | physical support/workpiece behavior; no hazardous release or unexpected motion |
| L-SF-06 | setup/recovery entry, exit, fault and power cycle | alternate protection remains bounded; production safeguards physically restored before production |
| L-SF-08 | guard restore, reset, power restore, fault recovery | no hazardous automatic restart of any mechanism |
| L-SF-09 | maintenance isolation exercise | all relevant energy isolated/relieved/restrained and isolation verified without uncontrolled workpiece release |

## Human-factors / foreseeable-defeat pass

- Frequent chucking and gauging tasks make door/interlock inconvenience especially defeat-prone. Put legitimate setup controls, lighting, visibility and recovery functions where they can be used with safeguards intact.
- Do not make nuisance clamp/pressure diagnostics a reason to bridge the workholding permissive. Give fault-specific diagnostics that distinguish command, pressure/sensor evidence and unresolved physical retention.
- Bar-feeder loading/recovery needs a deliberate protected workflow on both front and rear hazard zones; the front door alone is not a complete boundary.
- Turret crash recovery and chip/stringy-swarf clearing are predictable intervention tasks. Design recovery so safe manual actions are practical rather than requiring routine interlock defeat.
- Guards/windows/panels must be easy to restore correctly after maintenance; missing containment panels are not merely a cosmetic service issue.

## Residual UNKNOWN register

- actual chuck gripping force/pressure requirement and allowable loss behavior;
- rated chuck/jaw/workholding speed and the intended workpiece operating envelope;
- spindle/chuck/workpiece stopping time and access timing;
- enclosure/window containment capability and inspection/replacement criteria for the selected machine;
- bar diameter/length/speed/support and feeder-specific limits;
- turret energy sources, lock/unlock truth table and safe state;
- tailstock/subspindle force, gravity/support behavior and power-loss/recovery behavior;
- exact safety architecture and required PLr/SIL for each function;
- proof-test intervals and quantitative diagnostic coverage.

These values must not be borrowed from one manufacturer's example and generalized to another machine.

## Next transfer step

Transfer the same capstone contract to a robot/automated cell. Focus on whole-body access/occupancy, multiple simultaneous energy sources, safeguarded-space entry, reset visibility, enabling devices/setup modes, robot stop categories/safe motion where actually supported, peripheral machines and cell-level authority. Then return to the press-brake capstone with distinct gravity and fluid-power hazards.