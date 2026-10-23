# 4400 safety — Accumulator family exceptions, pressure-zone witnesses and release authority

**Status:** public-source documentary research and a generic engineering teaching contract; **NOT a machine-specific design, test result, or permission for exposed operation.** 2026-10-22 UTC. Primary curriculum: 4400 safety / 2580 transfer. No hardware lab justified.

## Question and result

Does one manufacturer's accumulator guidance establish a universal accumulator safety-valve, discharge, or pressure-verification arrangement? **No.** HAWE's D 7969 diaphragm-accumulator documentation and D 7571 miniature-accumulator documentation make *different product-family statements*. Both retain a fluid-side pressure-release/monitoring concern for servicing. The machine's actual pressure-zone topology and physical safe-state witnesses remain unproved by either manual.

### Primary source comparison — exact editions and pages

| Source | Document-confirmed, product-scoped statement | Explicit non-claim / transfer restriction |
|---|---|---|
| HAWE **D 7969**, *Diaphragm accumulator type AC*, **06-2022, rev 1.10**, printed **p.31/41**, §5.1.1; https://productfinder.hawe.com/downloads/D7969-en.pdf | Describes a fluid-side release facility with drain valve and monitoring gauge for servicing; states this accumulator requires its own component-approved safety valve and warns about pressure before removal. | Do **not** transfer its dedicated safety-valve requirement or its numeric overpressure statement unqualified to every miniature accumulator, or assert that a particular installed accumulator has these fittings. |
| HAWE **D 7571**, *Hydraulic miniature accumulators type AC*, **03-2024, rev 1.1**, printed **p.11/20**, §5.1.1; https://productfinder.hawe.com/downloads/D7571-en.pdf | Also describes fluid-side pressure release and a monitoring gauge for servicing; describes possible drain screw or actuation of a suitable directional seated valve, while cautioning about consumer-generated pressure. | A documented product-specific discharge option is **not** an approved generic LOTO method or a guarantee that a selected machine's downstream chambers depressurize. Do not direct technicians to actuate valves with people exposed. |
| HAWE **D 7571**, printed **p.18/20**, §6.1 | States that for the described miniature accumulators a separate specially component-approved accumulator safety valve is not necessary where the system pressure-limiting valve is sufficient; adds a separate pressure-limiting provision if a local section can exceed the specified maximum due to amplification. | This is the **manufacturer's scoped statement**, not an independently adjudicated legal interpretation of PED 2014/68/EU or a universal design exception. Installed type, pressure path and product limits must be established. |
| HAWE **D 7571**, printed **p.18/20**, application examples | Lists emergency actuation after loss of pump-side pressure as a *possible* accumulator application. | Not evidence that any selected machine uses that application, has a verified safe cycle, or may move with people exposed. |
| HAWE **D 7969**, printed **p.32/41**, §5.3.1, and HAWE **D 7571**, printed **p.12/20**, §5.3.1 | Each describes installing suitable shut-off, drain and safety valves and mentions a safety-block assembly as a practical grouping. | The words **safety block** do not establish that an installed block is a safety-rated motion-control system, maintenance isolator, or adequate ram restraint. |
| HAWE **B 5488**, *General operating and assembly instructions*, **10-2024, rev 3.1**, printed **pp.8, 17, 19/26**; https://downloads.hawe.com/5/4/B5488-en.pdf | Warns about pressurized systems/accumulators, directs depressurization and protection against unintended restart, and notes complex commissioning may need simultaneous measurements at multiple points. | General component instructions are not a complete machine schematic, validated safe-state proposition, or permission to substitute one convenient gauge for all pressure zones. |

The source text at D 7571 pp.11 and 18 and D 7969 p.31 was **visually inspected in the original manufacturer PDFs**, not inferred from snippets. The reference to ISO 4413 in the HAWE manuals is the manufacturer's characterization; the standard's underlying clauses were **not** independently inspected. All manufacturer statements above are **DOC-CONFIRMED** for the stated revisions. No SOURCE-CONFIRMED or TEST-CONFIRMED accumulator behavior is claimed.

## Four different jobs often hidden behind the word "safety"

1. **Overpressure limitation** — pressure-relief/protection against exceeding the selected component's permitted envelope. It does not necessarily discharge a trapped volume for servicing.
2. **Protective stopping / motion prevention** — independent safety-related demand, qualified output/final elements, physical response and rearm inhibition; exact architecture and stop/hold acceptance are machine-specific.
3. **Maintenance energy isolation and verification** — lockable isolating mechanisms where required, controlled discharge, protection from reaccumulation, personal energy-control arrangements and verification of *each relevant exposed energy zone*.
4. **Gravity/external-load restraint** — a separately supported physical load path when necessary; neither low fluid pressure nor valve feedback alone proves this.

**Freeze:** OVERPRESSURE RELIEF != MAINTENANCE DEPRESSURIZATION != PROTECTIVE STOP != LOAD RESTRAINT.

## Pressure-zone topology: what a gauge actually witnesses

Use this **abstract graph as a questioning aid only**, not as a press-brake hydraulic truth table:

- `Z-PUMP`: pump/supply-side section; pressure tap `G-P` may be here.
- `Z-ACC`: fluid side of accumulator; gauge `G-A` may be here; compressed gas remains a separate stored-energy domain.
- `Z-PILOT`: pilot supply and return paths that can affect valve position independently of pump command.
- `Z-LOAD-A` / `Z-LOAD-B`: distinct actuator chambers/ports; check valves, isolation valves, manifolds, regeneration paths and leakage can separate these from other zones.
- `Z-MECH`: suspended/gravity/external mechanical load path; not a hydraulic pressure reading.

**A gauge is evidence only for the actual fluid volume hydraulically connected to its verified tap at the time of measurement.** This is an **INFERENCE from measurement topology**, not an assertion of any installed topology. A closed isolation valve can leave a zero-indicating pump-side gauge while the accumulator or actuator volume on its other side remains charged; conversely, a low accumulator-side reading does not prove every isolated actuator chamber is depressurized. Even a verified zero hydraulic-side reading does not prove the gas side of a charged accumulator is safe for disassembly. Sensor range, calibration, blocked taps, failed gauges, temperature and pressure reaccumulation must be considered.

### Minimum pressure-witness map for an engineering package

| Record | Required evidence | Status until selected machine exists |
|---|---|---|
| `ENE-*` zone inventory | Pump, accumulator fluid/gas, pilot, load-side chambers, gravity/external loads; exact actual presence and interfaces | UNKNOWN |
| `ARC-*` isolation/discharge paths | Every valve, check valve, relief path and test point with exact part/port, normal and fault states | UNKNOWN |
| `PHY-*` proposition | What must physically be true for protective stop, maintenance entry and restart; each proposition independent | UNKNOWN |
| `DEP-*` common dependencies | Shared pilot pressure, electrical supplies, manifold, gauge/sensor target, feedback supply, operator override, maintenance changes | UNKNOWN |
| `VAL-*` physical witnesses | Instrument location/identity/calibration, simultaneous/sequence evidence where required, independent ram/load observation, contradiction disposition | NOT RUN |
| `PT-*` service witness | Accessible labeled points, gauge validity, reaccumulation monitoring where credible, approved restraint/isolation verification | NOT RUN |
| `HF-*` usability | Can technician see/verify the relevant zones and restore guards without improvised hoses or defeating safeguards? | OPEN |

## Adversarial contradiction and disposition

**Hypothetical case:** An independent safety controller reports expected monitored-valve feedback. A gauge on the supply side reads low. A separate instrument connected to an identified, isolated accumulator/load-side port indicates pressure or an independent motion witness shows load movement. No pressure values or machine plumbing are stipulated.

The only defensible conclusion is that the **broader machine `PHY-*` safe-state proposition is NOT ESTABLISHED**. Preserve the narrow feedback/port-specific evidence, open `DEP/VAL/UNK` records for sensor topology and common-cause faults, and block personnel-exposed release/rearm. If a material device, port or configuration change occurred, create `CHG-*` and mark downstream validation `STALE`. Do not average contradictory witnesses into a reassuring HMI green light. Diagnose with qualified personnel under a separately justified isolated/remote plan, with people outside the danger zone.

## Practical low-friction safeguard design

For a real machine, favor clearly marked lockable isolation points, documented accumulator/gauge port maps, accessible manufacturer-approved test ports, readable zone labels, captive or hinged inspection guards, guarded remote observation and controlled override/restoration. These are **INFERENCE/design recommendations**, not proof that any selected product meets a required integrity level. If correct verification requires removing a guard and leaning into the ram envelope, redesign the access/measurement arrangement rather than treating predictable bypass as operator misconduct.

## Transfer limits

- **Press brake:** independent ram/beam holding and gravity path remain central; no hydraulic truth table or stopping distance is inferred.
- **Mill/toolchanger:** tool clamp and retention need their own physical proposition; a hydraulic pressure switch may not establish tool retention.
- **Robot/gripper:** pressure and valve state do not alone prove retained payload or personnel exclusion.
- **Pneumatic feeder:** exhausted supply may coexist with trapped downstream volumes and unexpected repressurization.

**No physical experiment, simulator, Actions workflow, or local-runner compute was needed or executed.** Next evidence gain is a public-safe *selected* accumulator family, hydraulic connectivity map and a machine-specific independent witness plan. No personnel-exposed hazardous operation is authorized.
