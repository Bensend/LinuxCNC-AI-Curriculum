# Press-Brake Valve Monitoring vs Physical Stop Witness Boundary

Date: 2026-09-19

## Question

What does a professional press-brake safety controller actually prove when it monitors hydraulic holding/safety valves, and what still requires a physical motion/stopping witness?

## Authoritative evidence

Source: Lazer Safe, `PCSS-A Series Technical Manual`, LS-CS-M-046, Original Language Version 1.25, released 2024-09-12.

### Holding/safety valve state monitoring

Valve Monitoring Option 28 is specifically for press-brake **holding and safety valves**. The PCSS receives normally-closed monitor contacts for the valves. Its documented truth table distinguishes commanded solenoid state from monitor-contact state and declares a valve fault when the command/monitor combination disagrees in either switching direction.

Evidence classification: **DOC-CONFIRMED**.

This is individual switching-state evidence. It is not documentation of hydraulic pressure, leakage, static load retention, ram drift, or stopping distance.

### Physical stopping-performance witness

The same PCSS separately performs start-up stopping tests after power-up/reference. It creates simulated stop demands while the pressing beam is moving, records stopping distance and stopping time, blocks normal operation after a failed stopping test, and requires successful test completion before normal operation can begin.

The manual explicitly warns that press-brake safety/stopping performance has not yet been verified while those tests are being performed and requires precautions until they pass.

The PCSS can also trigger later stopping tests after relevant speed/travel changes, exceeded stopping-test limits, elapsed repetition time/24 hours, or transition from modes that bypassed the start-up test.

Evidence classification: **DOC-CONFIRMED**.

### Important architecture distinction

The same safety controller therefore contains two deliberately different evidence mechanisms:

1. **valve command/monitor agreement** — proves the monitored switching-state relationship expected by the configured valve-monitoring option;
2. **beam stopping test** — uses actual beam motion to prove the configured stopping-performance requirement.

They must not be collapsed into one proof.

## Durable safety rule

**VALVE COMMAND/MONITOR AGREEMENT != HYDRAULIC LOAD RETENTION PROVED != RAM PHYSICALLY STOPPED != STOPPING PERFORMANCE PROVED != PRODUCTION AUTHORITY.**

Conversely:

**STOPPING TEST PASS != INDIVIDUAL HOLDING-VALVE STATIC RETENTION PROOF.**

A controller can legitimately need both switching-state monitoring and a separate physical motion witness because they answer different failure questions.

## Failure-path implications

A monitored contact that follows its solenoid command can still leave physical hydraulic properties outside that observation boundary: internal leakage, insufficient retaining capability, pressure behavior, or other mechanical/hydraulic failures are not proven absent merely by electrical monitor agreement.

A stopping test proves the configured machine stopping response under the tested condition. It does not by itself isolate which hydraulic retaining element supplied that response, and therefore does not establish an unmasked individual holding-valve retention proof.

For OpenPressBrake curriculum architecture, ordinary LinuxCNC/HAL/FPGA status may display both kinds of evidence, but personnel-safety authority must not be inferred from ordinary software combining them. The independent safety architecture owns the required safety reaction and reauthorization chain.

## Post-service question: still UNKNOWN

The public PCSS technical manual documents holding/safety valve monitoring and the independent start-up/stopping-performance test machinery, but the source trace did **not** locate an authoritative statement that replacement/service of a monitored holding or safety valve itself automatically triggers the PCSS start-up test.

It also does not expose a procedure for:

`specific serviced holding valve -> companion retaining path deliberately prevented from masking it -> physical ram/load retention witness -> explicit pass/fail criterion -> repair disposition -> re-proof after service`.

Those machine/component-specific claims remain **UNKNOWN** and must not be invented.

## Practical commissioning lesson

When validating a press-brake safety architecture, explicitly identify the witness for each claimed physical property:

- electrical/position monitor for valve switching-state agreement;
- physical beam motion measurement for stopping performance;
- machine/OEM-defined physical retention test where static retaining capability is safety-relevant;
- pressure/energy witness where safe access depends on stored hydraulic energy being removed or controlled.

A convenient shared `SAFE` bit must never erase those evidence boundaries.

## Source provenance

- Lazer Safe PCSS-A Series Technical Manual LS-CS-M-046 v1.25, §§14.28 and 17.3, released 2024-09-12.
- Public current Lazer Safe support material states OEM embedded systems are customized to the machine manufacturer and directs users to the press-brake manufacturer/dealer for machine-specific operating information. This supports keeping replacement-trigger behavior UNKNOWN rather than extrapolating it from the generic PCSS manual.

No simulation or runtime compute was required for this study.