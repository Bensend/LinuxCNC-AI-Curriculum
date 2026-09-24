# 25F0 — Professional hydraulic press-brake safety architecture trace

## Scope

This pass compares inspectable professional press-brake safety implementations before extracting reusable patterns. It deliberately does **not** invent a universal hydraulic truth table. Claims are bounded to the cited product families and evidence available on 2026-09-24.

## Architecture A — Fiessler AKAS-F + AKFH/AKFR hydraulic interface

**Evidence class:** `DOC-CONFIRMED` from Fiessler current press-brake product documentation; the named hydraulic interfaces are product-specific.

### Trace

1. **Protective demand / inputs.** AKAS provides optical point-of-operation protection. Fiessler states that valve release is also blocked for opening safety doors and E-stop actuation.
2. **Safety logic.** AKAS-F performs safety evaluation. AMS3 can supply motion direction/speed information from separate Y1/Y2 magnetic-tape sensors and can perform overtravel measurement in rapid traverse.
3. **Hydraulic interface.** AKFH (Hörbiger hydraulics) or AKFR (Rexroth hydraulics) interfaces between AKAS-F and the machine hydraulic controls.
4. **Feedback.** AKFH/R reads hydraulic-valve position transmitters and passes linked valve-state information to AKAS-F. AKAS-F checks valve operation before/while issuing the safe release.
5. **Final control authority.** AKFH/R enables valve controls through five safe potential-free normally-open contacts. Fiessler states that valve release is immediately blocked for optical-field interruption, guard-door opening, E-stop, valve switching error, AKFH/R error or AKAS-F error.
6. **Physical proposition.** This architecture establishes a safety-related *permission and monitored valve-switching chain*. The public product description does **not** by itself prove zero cylinder pressure, zero ram motion, gravity restraint, maintenance isolation, or a universal safe spool position.

### What the feedback proves — and does not prove

Valve-position transmitters can provide evidence that monitored valves reached the expected switching state. They do not, without additional machine-specific evidence, prove that downstream pressure is exhausted, that a load is mechanically held, that the beam is stationary, or that a second/common hydraulic path cannot move the beam.

Freeze: **VALVE POSITION EXPECTED != RAM SAFE STATE PROVED**.

## Architecture B — Bosch Rexroth pump-controlled press-brake drive with monitored safety block

**Evidence class:** `DOC-CONFIRMED` from Bosch Rexroth's 2024 system-solution release. Public evidence is less detailed than Architecture A, so the trace stops where the documentation stops.

### Trace

1. **Normal motion source.** A servo controller commands a highly dynamic servo motor driving a four-quadrant axial-piston pump; motor speed/torque control supplies the cylinder as required.
2. **Independent hydraulic safety element.** Bosch Rexroth states that the package includes a **safety block with end-position-monitored on/off valves**.
3. **Feedback.** The on/off valves have end-position monitoring. This provides a physical valve-state witness distinct from the normal servo motor/pump command path.
4. **Physical proposition boundary.** The published release confirms monitored hydraulic final elements but does not expose the complete safety-controller wiring, exact valve truth table, demand sequence, load-holding path, decompression behavior or maintenance-isolation method. Those remain `UNKNOWN` rather than being inferred from the normal servo-pump behavior.

### Architectural lesson

A pump-controlled drive does not make the normal servo command the personnel-safety boundary. The package still adds a separately monitored hydraulic safety block. This is strong evidence against the shortcut `SERVO PUMP COMMAND ZERO == HYDRAULIC SAFE STATE`.

Freeze: **SERVO PUMP ZERO COMMAND != HYDRAULIC SAFETY FUNCTION PROVED**.

## Architecture C — HAWE press-brake system family / EV2D safety-related valve shutdown

**Evidence class:** `DOC-CONFIRMED` from HAWE current press-brake application documentation and HAWE's EV2D release. This is a third comparison, not a substitute for a machine schematic.

HAWE identifies reliable holding of the press beam, short switching/overtravel behavior and safe monitoring of individual functions as press-brake requirements. Its EV2D press-brake amplifier implements safety-related valve shutdown and is offered as part of HAWE press-brake system solutions. HAWE also publishes ISO 13849 hydraulic functional-safety guidance using safety sub-functions rather than treating a complete hydraulic machine as one undifferentiated `safe` bit.

The reusable lesson is architectural: safe shutdown of valve actuation is one safety sub-function. Beam holding, physical cessation, stored-energy management and maintenance isolation remain separate propositions unless the actual machine circuit establishes otherwise.

## Cross-architecture comparison

| Question | Fiessler AKAS-F + AKFH/R | Bosch Rexroth pump-controlled package | HAWE family / EV2D |
|---|---|---|---|
| Normal motion control | machine-specific hydraulic control | servo motor + four-quadrant pump | product/system dependent |
| Independent safety path visible in evidence | AKAS-F + AKFH/R safe valve-enable chain | monitored hydraulic safety block | safety-related valve shutdown / hydraulic safety sub-functions |
| Physical feedback visible | hydraulic valve-position transmitters; Y1/Y2 motion sensing available via AMS3 | on/off valve end-position monitoring | safe monitoring is a stated requirement; exact machine feedback path not established here |
| Does normal controller alone own personnel safety? | No | No; separate safety block remains | No basis to assign that authority to ordinary machine control |
| Does feedback alone prove beam safe? | No | No | No |
| Maintenance isolation proven by this evidence? | No | No | No |

## Reusable safety decomposition

A press-brake design review should name these separately:

1. **Protective-device demand** — optical field, guard, E-stop or other safety input.
2. **Independent safety evaluation** — the logic allowed to authorize/remove hazardous motion.
3. **Controlled stopping** — what physically changes to arrest hazardous closing motion, with measured stopping behavior where required.
4. **Hydraulic supply/actuation inhibition** — which final elements remove or block the ability to generate hazardous motion.
5. **Valve/final-element feedback** — exactly what physical state each witness establishes.
6. **Load holding / gravity restraint** — what prevents hazardous descent after actuation is removed.
7. **Dump/decompression** — what removes trapped or accumulator pressure where exposure requires it.
8. **Maintenance restraint/isolation** — lockout, dissipation, mechanical restraint and verification appropriate to service work.

These functions may share hardware on a particular certified design, but they must not be collapsed conceptually.

## Fault-analysis seed matrix

This is a question matrix, not a claim that every architecture has the listed component.

| Fault | Required question | Unsafe shortcut rejected |
|---|---|---|
| valve stuck in motion-permitting state | What independent element prevents hazardous movement, and is the stuck state detected before the next demand? | `command off == valve safe` |
| valve feedback falsely indicates safe | Is the witness independent/diverse enough, and what physical proposition remains unproved? | `feedback healthy == beam safe` |
| broken safety input/channel | Is the break detected and does permission default safe? | `no command == safe` |
| common 24 V / pilot / hydraulic supply fault | Can one common failure defeat multiple nominally redundant channels? | `two channels == independent` |
| safety logic removes valve enable | What physically happens to cylinder flow/pressure/load? | `safety output off == ram stopped` |
| mains/control power loss and restoration | What prevents gravity descent and unexpected restart? | `power loss == energy removed` |
| trapped/accumulator pressure | How is it isolated/dumped/verified before exposure? | `pump off == pressure gone` |
| gravity-loaded beam | What physical holding/restraint survives the relevant faults? | `directional valve neutral == load held` |
| maintenance inside die space | What lockout/dissipation/mechanical restraint is used and verified? | `production safeguard == maintenance protection` |

## Human-factors consequence

Useful diagnostics should identify the actual failed layer — protective device, safety logic, valve-enable path, valve-position mismatch, motion/stopping-performance fault, or maintenance-isolation state. A generic `SAFETY FAULT` that encourages technicians to bridge a guard or bypass valve monitoring is an architecture/usability defect, not merely a training problem.

## Boundaries retained as UNKNOWN

- exact hydraulic spool truth tables for any target OpenPressBrake machine;
- whether a particular cylinder is gravity loaded and by how much;
- exact redundancy/diversity of any target machine valve group;
- pressure thresholds, stopping time/distance and safe-speed values;
- diagnostic coverage, CCF score, PL/SIL claim or proof-test interval;
- exact decompression and load-holding path;
- whether valve end-position feedback is sufficient for a particular SRS requirement;
- maintenance blocking/restraint hardware for a specific machine.

## Evidence anchors

- Fiessler Elektronik, current AKAS press-brake protection product documentation: AKAS-F, AMS3 and AKFH/AKFR valve-position monitoring and safe valve-enable interface. `DOC-CONFIRMED`.
- Bosch Rexroth, *Energy-efficient drives for press brakes*, 2024-10-22: pump-controlled servo drive plus safety block with end-position-monitored on/off valves. `DOC-CONFIRMED`.
- HAWE Hydraulik, current press-brake application page and 2022 EV2D release: beam holding/monitoring requirements and safety-related valve shutdown in a press-brake valve-control solution. `DOC-CONFIRMED`.
- HAWE Hydraulik, *Functional safety in accordance with ISO 13849 implemented in practice for hydraulic systems*: safety-function/sub-function decomposition and verification framing. `DOC-CONFIRMED`.

## Next work

Use these physical architecture boundaries to expand the press-brake fault matrix into SRS-linked validation cases. For each case identify the demand, failed component/path, expected independent response, physical witness, residual hazardous-energy proposition and rearm condition. Do not assign machine-specific pass values without machine/product evidence.
