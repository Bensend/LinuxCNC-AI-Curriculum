# Maintenance energy isolation, stored-energy and return-to-service authority study

Date: 2026-09-18
Lane: independent safety curriculum Lane B

## Why this branch

The primary lane is currently advancing press-brake redundant hydraulic restraint / final-element physical-witness evidence. This Lane-B branch intentionally does **not** define press-brake valve truth tables, redundant restraint circuits, pressure thresholds, stopping performance, or gravity-axis proof. It instead studies the separate servicing/maintenance boundary: when production safeguards and ordinary control are insufficient, how hazardous energy is physically isolated, stored energy is controlled, isolation is verified, and authority is deliberately returned after work.

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by an authoritative regulation/source.
- **DOC-CONFIRMED** — directly supported by manufacturer/OEM documentation.
- **TEST-CONFIRMED** — demonstrated by an identified executable or physical test.
- **COMMUNITY-REPORTED** — reported by practitioners but not independently verified here.
- **INFERENCE** — engineering conclusion derived from confirmed evidence; not itself source text.
- **UNKNOWN** — machine-specific fact not established by available evidence.

## Authoritative source trace

### OSHA 29 CFR 1910.147 — control of hazardous energy

**SOURCE-CONFIRMED:** OSHA 29 CFR 1910.147 applies to servicing/maintenance where unexpected energization/startup or release of stored energy can injure workers. The standard requires an energy-control program and, before covered servicing, isolation from energy sources and rendering the equipment inoperative.

Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

**SOURCE-CONFIRMED:** The required application sequence distinguishes ordinary shutdown from physical energy isolation. After orderly shutdown, all needed energy-isolating devices are physically located and operated, lockout/tagout devices are applied, hazardous stored/residual energy is relieved/disconnected/restrained/otherwise rendered safe, and isolation/deenergization is verified before work begins.

**SOURCE-CONFIRMED:** If stored energy can reaccumulate to a hazardous level, verification of isolation continues until servicing is complete or reaccumulation is no longer possible.

**SOURCE-CONFIRMED:** Release from lockout/tagout is also a deliberate sequence: inspect the machine/work area, ensure employees are safely positioned or removed, remove locks/tags under the prescribed authority, restore energy, and notify affected employees. Removing isolation is therefore not equivalent to commanding machine operation.

### OSHA Appendix A — concrete stored-energy examples

**SOURCE-CONFIRMED:** OSHA's typical minimal lockout procedure explicitly names capacitors, springs, elevated machine members, rotating flywheels, hydraulic systems and pressurized fluids/gases as examples of stored/residual energy and gives grounding, repositioning, blocking and bleeding down as example control methods.

Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147AppA

**SOURCE-CONFIRMED:** Appendix A verifies isolation by checking that personnel are not exposed and then operating normal controls or otherwise testing that equipment will not operate; controls are returned to neutral/off afterward. On restoration, it separately calls for checking personnel, verifying controls are neutral, removing lockout, reenergizing, and notifying affected employees.

### OSHA interpretation — control switch is not energy isolation

**SOURCE-CONFIRMED:** OSHA's 1994 interpretation concerning an agitator explains that locking a starter/control switch OFF generally does not isolate transmission/load energy and may not protect against control-circuit failure or other activation. It distinguishes control energy from the energy-isolating device and requires stored/residual energy to be rendered safe.

Source: https://www.osha.gov/laws-regs/standardinterpretations/1994-03-03

## Architecture result

Freeze these states as distinct:

`LINUXCNC STOPPED != SAFETY OUTPUT SAFE != ENERGY-ISOLATING DEVICE OPEN/SAFE != LOCKOUT APPLIED != STORED/RESIDUAL ENERGY CONTROLLED != REACCUMULATION PREVENTED != ISOLATION VERIFIED != PERSON MAY SERVICE`.

And on return:

`SERVICE COMPLETE != MACHINE INTACT/CLEAR != PERSONNEL CLEAR != LOCKOUT REMOVED != ENERGY RESTORED != SAFETY SYSTEM REARMED != FRESH ORDINARY START AUTHORITY`.

**INFERENCE:** LinuxCNC, HAL, an ordinary FPGA watchdog, drive-enable command, STO request, E-stop status bit, or HMI `OFF` indication cannot by themselves be treated as the servicing energy-isolation boundary. They may participate in orderly shutdown or diagnostics, but covered maintenance requires the applicable hazardous-energy sources and stored-energy paths to be dealt with at the physical isolation/control layer.

**INFERENCE:** This also prevents a common conceptual collapse in press-brake teaching. A ram that is commanded stopped, a hydraulic valve that is commanded safe, a motor with STO asserted, a pump contactor that is open, a pressure gauge reading low, and a mechanically blocked/effectively restrained gravity load are different evidence claims. Which are required depends on the actual task and machine hazards.

## Question-driven commissioning / maintenance worksheet

For each real machine, answer with evidence rather than assumptions:

| Question | Required evidence class |
|---|---|
| What servicing task exposes a person to what hazard? | machine/OEM procedure + task observation |
| What energy sources can create that hazard? | electrical/hydraulic/pneumatic/mechanical/gravity/thermal inventory |
| Which devices are true energy-isolating devices versus control devices? | schematic/manual + physical identification |
| What stored/residual energy remains after normal shutdown? | machine documentation + measured/physical verification where appropriate |
| Can energy reaccumulate while work continues? | circuit/physical analysis + verification plan |
| What blocking/restraint/bleed/discharge method renders each relevant stored-energy path safe? | OEM/procedure evidence; do not invent |
| How is isolation verified before exposure? | task-specific documented test |
| Does attempted normal operation prove every relevant energy source isolated? | no; enumerate what that test does and does not witness |
| Who owns each lock and how are group/shift changes handled? | site procedure |
| What must be inspected/restored before locks are removed? | service/return-to-service procedure |
| Can safety reset/rearm occur while a personal lock remains applied? | architecture-specific; record UNKNOWN until established |
| After energy restoration, what deliberate safety rearm and fresh ordinary START are required? | machine safety/control documentation + commissioning test |

## Failure-path challenges

1. LinuxCNC/HMI says OFF, but the physical energy-isolating device remains closed.
2. Main electrical isolation is open, but an elevated member can descend under gravity.
3. Pump power is isolated, but trapped hydraulic pressure remains.
4. A pressure path is bled, then pressure can reaccumulate because another source/path was missed.
5. A control switch is locked OFF while load/transmission energy remains available.
6. A service technician proves `START` does nothing but fails to verify another independent energy source.
7. Blocking/restraint is removed before personnel/tools are clear because control power is still off.
8. Energy is restored with ordinary LinuxCNC `START/JOG/CYCLE` already asserted.
9. Safety reset is treated as permission to restart immediately after lock removal.
10. A shift/personnel change loses continuity of personal protection.
11. A machine is left incomplete/bypassed between service sessions without unmistakable out-of-service status.
12. A diagnostic/HMI indication disagrees with the physical isolator, restraint, bleed or stored-energy witness; physical verification governs the servicing decision.

## OpenPressBrake boundary

**UNKNOWN:** exact electrical isolation points; hydraulic isolation/bleed architecture; accumulator presence/state; ram blocking/restraint method; gravity-load safe-service position; pressure thresholds; valve truth tables; residual/reaccumulating pressure behavior; safe access procedure; required lockout points; and return-to-service test sequence.

Do not infer any of those from generic hydraulic practice or from the primary lane's EN 12622 example circuit.

## Curriculum teaching rule

Production functional-safety architecture and maintenance hazardous-energy control are related but not interchangeable. Teach both:

- During production/setup, independent safety functions can command and monitor risk-reduction functions without giving LinuxCNC personnel-safety authority.
- During covered servicing/maintenance, identify and physically control the hazardous energy relevant to the task, including stored/residual/reaccumulating energy, and verify isolation before exposure.
- A tag or `OUT OF SERVICE` state communicates machine status; it does not replace physical energy control where exposure requires isolation/restraint.
- Restoration of energy, safety rearm, and production START are separate transitions.

## Compute

No executable verification was justified for this evidence trace. No GitHub-hosted or self-hosted runner compute was consumed.

## Precise next work

Find a professional hydraulic press/press-brake OEM service or commissioning procedure that exposes the complete maintenance chain `normal shutdown -> electrical/hydraulic/mechanical energy isolation -> stored-energy bleed/restraint -> isolation verification -> service -> physical inspection/personnel clear -> removal of isolation -> energy restoration -> safety functional check/rearm -> separate fresh production START`. Prefer a source that explicitly handles gravity load plus trapped/reaccumulating hydraulic energy. Preserve UNKNOWN wherever public documentation stops.