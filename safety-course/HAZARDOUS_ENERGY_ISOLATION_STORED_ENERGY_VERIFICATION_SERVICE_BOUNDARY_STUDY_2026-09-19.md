# Hazardous-energy isolation / stored-energy verification / service boundary study

Date: 2026-09-19
Lane: independent safety curriculum Lane B

## Question

For maintenance, jam clearing, hydraulic/electrical service, or other work that exposes a person to unexpected machine energization or stored energy, what must be established beyond an E-stop, LinuxCNC MACHINE OFF, STO, safety-output OFF, or a warning tag?

## Evidence classification

### SOURCE-CONFIRMED — OSHA 29 CFR 1910.147

OSHA 29 CFR 1910.147 covers servicing and maintenance where unexpected energization/startup or release of stored energy could injure employees. Its application sequence requires identifying and operating the needed energy-isolating devices, applying lockout/tagout devices, rendering potentially hazardous stored or residual energy safe, and verifying isolation/deenergization before work begins.

The standard separately requires continued verification where stored energy can reaccumulate to a hazardous level. Before restoration, the work area is inspected, employees are safely positioned or removed, and affected employees are notified after lockout/tagout removal and before startup.

Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

### SOURCE-CONFIRMED — OSHA Appendix A minimal procedure

OSHA's nonmandatory Appendix A gives concrete examples of stored/residual energy: capacitors, springs, elevated machine members, rotating flywheels, hydraulic systems, and pneumatic/fluid pressure. It gives dissipation/restraint examples including grounding, repositioning, blocking, and bleeding down. It then requires isolation verification, for example by attempting normal controls or testing, followed by returning operating controls to neutral/off.

Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147AppA

### SOURCE-CONFIRMED — OSHA control-circuit prohibition / verification guidance

OSHA's lockout/tagout eTool emphasizes that hazardous-energy control is not established merely by a control-circuit command. Stored energy must be relieved, disconnected, restrained, or otherwise rendered safe. Verification may require a deliberate start attempt, voltage measurement, or other energy-specific instrumentation; more than one verification method can be necessary where multiple energy types exist.

Source: https://www.osha.gov/etools/lockout-tagout/hot-topics/energy-control-program/energy-control-circuitry-prohibition

### SOURCE-CONFIRMED — reaccumulation is a continuing condition, not a one-time check

OSHA interpretation guidance states that when hazardous energy can reaccumulate, verification of isolation must continue until servicing is complete or the possibility no longer exists. Its enforcement guidance gives bleeder-valve/depressurization verification as an example for process/fluid systems.

Sources:
- https://www.osha.gov/laws-regs/standardinterpretations/2002-01-29
- https://www.osha.gov/enforcement/directives/std-01-05-019

## Architecture boundary

For curriculum purposes, keep these states distinct:

1. ordinary LinuxCNC/FPGA motion command removed;
2. safety demand asserted / safety outputs OFF;
3. energy-isolating devices physically operated;
4. isolating devices secured against unintended restoration;
5. stored/residual electrical, hydraulic, pneumatic, gravitational, spring, thermal, or other hazardous energy controlled;
6. isolation/deenergization independently verified using methods appropriate to each energy source;
7. reaccumulation remains controlled/verified for the duration of exposure;
8. mechanical blocking/restraint remains effective where gravity or stored mechanical energy requires it;
9. service work is complete and machine components are operationally intact;
10. people/tools are clear and isolation devices are removed under the applicable procedure;
11. safety functions and affected physical final elements are revalidated where service could have altered them;
12. machine-specific production authority is deliberately restored.

Passing an earlier state does not prove a later one.

## Frozen curriculum boundaries

**LINUXCNC MACHINE OFF != SAFETY OUTPUT OFF != ENERGY ISOLATED != STORED ENERGY CONTROLLED != ZERO/SAFE ENERGY VERIFIED != REACCUMULATION PREVENTED != SAFE TO SERVICE.**

**E-STOP ACTIVE != LOCKOUT.** An E-stop is an operational protective function; it is not evidence that every hazardous energy source has been physically isolated and secured for servicing.

**STO ACTIVE != ELECTRICAL ISOLATION.** STO may remove torque-producing authority from a drive, but this study does not treat it as proof that hazardous electrical energy, DC-link energy, external supplies, gravity, hydraulic pressure, or other energy is absent.

**PRESSURE GAUGE LOW != ALL HYDRAULIC ENERGY SAFE.** A displayed or measured pressure can be one witness, but trapped branches, accumulators, gravity-loaded cylinders, check valves, blocked volumes, or reaccumulation require the actual machine's energy-control procedure and physical verification.

**TAG PRESENT != ENERGY CONTROLLED.** A warning communicates status; it does not substitute for isolation, restraint, blocking, bleed-down, or verification.

**ONE-TIME ZERO-ENERGY CHECK != CONTINUING SAFE CONDITION** where hazardous energy can reaccumulate.

## OpenPressBrake/LinuxCNC application

The ordinary LinuxCNC/FPGA control layer may report machine state, command shutdown, or display diagnostics, but personnel-service authority must not depend solely on a software state bit, fieldbus state, GUI indicator, or FPGA output command. The service boundary must follow the physical energy paths.

A press-brake-oriented energy inventory should explicitly ask about at least:

- incoming electrical power and auxiliary/control supplies;
- drive DC links or capacitive storage where present;
- hydraulic pump power;
- accumulators and trapped hydraulic volumes;
- gravity/elevated ram or other moving members;
- springs/counterbalance devices or other stored mechanical energy;
- pneumatic supplies/receivers if present;
- externally supplied peripherals or backfeed paths.

This is an inventory prompt, not a claim that every OpenPressBrake machine contains every item.

## Failure-path / commissioning worksheet

Challenge the procedure with these questions:

| Challenge | Required observation / disposition |
|---|---|
| E-stop pressed but main energy sources remain connected | Do not equate operational stop with service isolation. |
| LinuxCNC MACHINE OFF / FPGA outputs inactive | Verify physical energy isolation independently. |
| Electrical disconnect locked but hydraulic accumulator/trapped branch remains charged | Stored-energy control is incomplete. |
| Hydraulic gauge reaches low/zero but elevated ram remains capable of gravity motion | Mechanical/gravity hazard remains; use machine-specific blocking/restraint procedure. |
| Bleed-down succeeds, then pressure can reaccumulate | Continue verification/control through the service exposure. |
| Multiple electrical supplies/backfeed paths exist | Each hazardous source must be identified and controlled; one disconnect indication is insufficient. |
| Service requires temporary reenergization for test/reposition | Follow the applicable controlled reenergization sequence; do not leave the machine casually energized between service steps. |
| Service is complete but a guard, block, hose, wire, valve, sensor, or safety device was disturbed | Inspect operational integrity and perform affected safety-function/final-element revalidation before production authority. |
| Stale START/JOG/CYCLE remains asserted when energy is restored | Ordinary command freshness/restart policy remains separate from removal of service isolation. |

## Provenance discipline

- `SOURCE-CONFIRMED`: OSHA requirements/guidance cited above.
- `DOC-CONFIRMED`: reserve for a specific machine/OEM service manual applying these principles to its actual energy paths.
- `TEST-CONFIRMED`: reserve for an actual machine test performed under a controlled validation plan.
- `COMMUNITY-REPORTED`: none used in this study.
- `INFERENCE`: the OpenPressBrake architecture decomposition and energy-inventory prompts are engineering applications of the source-confirmed principles, not claims about a particular machine.
- `UNKNOWN`: exact OpenPressBrake energy sources, isolation points, accumulator/trapped-volume behavior, blocking method, discharge times, safe pressure/voltage criteria, verification instruments, reaccumulation intervals, and return-to-service test sequence until the actual machine is documented/measured.

## Compute decision

No simulation or executable verification is justified. The unresolved facts are physical machine energy paths and service procedures; synthetic compute cannot establish them. No GitHub-hosted runner or self-hosted runner compute was consumed.

## Precise next Lane-B checkpoint

Seek a complete professional machine/OEM maintenance implementation exposing:

`shutdown -> every physical energy-isolating device -> lockout -> stored/residual-energy dissipation or restraint -> energy-specific verification -> reaccumulation monitoring where applicable -> service exposure -> controlled restoration -> affected safety-function/final-element re-proof -> deliberate production reauthorization`.

Prefer an industrial hydraulic machine or press/press-brake manual that visibly combines electrical isolation, hydraulic pressure/accumulator control, gravity-member blocking, and a return-to-service test. Preserve exact machine-specific thresholds as machine-specific evidence; do not transfer them to OpenPressBrake without measurement or applicable OEM documentation.