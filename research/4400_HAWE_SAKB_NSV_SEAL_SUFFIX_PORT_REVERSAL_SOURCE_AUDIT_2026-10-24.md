# 4400 — HAWE SAKB / NSV seal suffix and pressure/suction port reversal audit (2026-10-24)

**Status:** original manufacturer-document source trace, **not** a selected-machine hydraulic circuit or a safe operating/test procedure. No physical experiments.

## Question

If a SAKB press-brake manifold reports that its monitored valves are in their expected positions, does that prove the two separate anti-cavitation valves are closed, leak-tight, or that the beam is held? Could a technician safely identify pressure and suction ports merely from the letters A and B?

**No.** Two original HAWE manufacturer data sheets establish several easily confused product boundaries.

## Primary source provenance

- **HAWE D 6335**, *Control system for CNC press brakes type SAKB*, **08-2025 rev 1.1**, 26 pages, generated 2025-08-26; manufacturer-hosted https://productfinder.hawe.com/downloads/D6335-en.pdf . Relevant printed pp. 4–5 and 9.
- **HAWE D 6368**, *Anti-cavitation valve type NSV*, **06-2026 rev 1.3**, 27 pages, generated 2026-07-10; manufacturer-hosted https://productfinder.hawe.com/downloads/D6368-en.pdf . Relevant printed pp. 4–8.
- **HAWE D 6340**, *ePRAX modular*, **07-2026 rev 1.4**, manufacturer-hosted https://productfinder.hawe.com/downloads/D6340-en.pdf . Used only for a **cross-family contrast**, not to assert identical components.
- Companion prior course audit: `research/4400_HAWE_SAKB_FIVE_MONITORED_VALVES_VS_NSV_SOURCE_SCOPE_2026-10-23.md`.

## Narrow source claims

| ID | OEM fact | Evidence | Label | What it cannot prove |
|---|---|---|---|---|
| NS-01 | SAKB uses a **central hydraulic control block** with **two separately available** NSV anti-cavitation valves mounted at cylinder bases. | D 6335 pp. 4–5 | DOC-CONFIRMED | SAKB's manifold position monitoring automatically covers both NSVs. |
| NS-02 | D 6335's SAKB `S` monitoring option enumerates **two proportional directional valves, two holding valves and one 4/2-way directional valve**. | D 6335 p. 9 | DOC-CONFIRMED | NSV feedback or physical beam holding. |
| NS-03 | D 6335 specifically names NSV model examples ending **`L`** (e.g. `NSV060BA03L`) as compatible separate valves. | D 6335 p. 5 | DOC-CONFIRMED | That an `L` variant is leak-tight or monitors its own closure. |
| NS-04 | D 6368 defines the NSV **`L` suffix** as **without seal, with leakage flow**; the **no-suffix** variant is cataloged as with seal and zero leakage. | D 6368 p. 6 | DOC-CONFIRMED | Zero leakage under every installed failure/contamination/temperature condition. |
| NS-05 | The described NSV basic state is **normally open**; pilot/control pressure is needed to **close** it. | D 6368 p. 4 | DOC-CONFIRMED | Pump-off/coil-off makes the NSV closed and the beam safely held. |
| NS-06 | D 6368 `050` circuit symbol maps **A = suction/tank, B = pressure**; `060` reverses this: **A = pressure, B = suction/tank**. | D 6368 pp. 5, 7 | DOC-CONFIRMED | A pressure-zone map based only on the letter `A` or `B` without full exact part code. |
| NS-07 | `BA` is on-cylinder flange mounting, `BE` is in-cylinder cartridge form; size and port configuration are separate option dimensions. | D 6368 p. 6 | DOC-CONFIRMED | Physical port access, sensing or service procedures identical between installations. |
| NS-08 | D 6368 publishes pilot-pressure guide values calculated without some load/friction contributions. | D 6368 p. 8 | DOC-CONFIRMED | A selected machine's closing/opening threshold or pilot-safety truth table. |
| NS-09 | The ePRAX modular D 6340 describes **integrated normally-closed** anti-cavitation valves, contrasting SAKB's **separate normally-open** NSVs. | D 6340 p. 4; D 6335 pp. 4–5; D 6368 p. 4 | DOC-CONFIRMED | Same manufacturer's label `anti-cavitation valve` means same default state, pilot logic, or installation. |
| NS-10 | Independent physical beam stop/holding and pressure-zone witnesses must not be replaced by manifold `S` feedback, an NSV model-name guess or one gauge. | Derived from NS-01..09 | INFERENCE | Machine validation without as-built drawings and controlled physical evidence. |

### Why `L` matters

An operator may interpret a component as a load-holding check valve merely because it is called a valve and its surrounding SAKB reports `safe`. The **exact OEM suffix** says the `L` variant has a **designed leakage flow**. This is a catalog characteristic, not a measured drift speed or proof of dangerous movement in a particular system. It is nonetheless enough to **reject any claim that an `L` NSV alone guarantees a leak-tight physical hold**. The whole circuit, other valves, load, pressure, pilot path and mechanical restraint must be evaluated.

### Why `A/B` matters

In D 6368 the pressure/suction assignment reverses between `050` and `060`. A service drawing or gauge hookup copied from another NSV suffix can observe the **wrong energy zone**. A zero indication at a misidentified port does not establish safe pressure elsewhere. **Do not** attach instruments, remove fittings, or conduct valve/pilot experiments to resolve this without a qualified, isolated, machine-specific procedure.

### Four-state reasoning boundary

- **Ordinary command:** LinuxCNC/normal FPGA may request pump and proportional-valve behavior and show status.
- **Safety-related control:** separately validated safety functions may monitor selected valves and command independent final elements; SAKB's `S` enumerated coverage does **not** include a claim about both separate NSVs.
- **Physical holding/stop:** actual Y1/Y2 load, fluid volumes, valves, mechanical restraint and motion require independent witnesses.
- **Maintenance isolation:** exact installed NSV port coding, pilot lines, trapped volumes and residual gravity/accumulator energy require qualified physical verification; no single status bit establishes isolation.

## Adversarial fault paths

1. `SAKB S all five monitored valves safe` while a separate `NSV...L` has leakage: no logical contradiction; physical beam state remains to be witnessed.
2. NSV pilot pressure lost and an NSV is assumed to close: manufacturer documents **normally open**, so the assumption is reversed for the cited family.
3. A technician copies `A=pressure` from a `060` installation to a `050` installation: OEM port meanings reverse, so the instrument may be on suction rather than pressure.
4. A newer ePRAX integrated anti-cavitation design is substituted for SAKB's separate NSV without change control: product family, safe state and sensing boundaries differ; no drop-in equivalence.
5. A catalog's `zero leakage` description for a sealed NSV is treated as measured load-holding proof: installed contamination, seals, pilot, cylinder and other leak paths are not thereby eliminated.

## Exact evidence intake for selected machine

Obtain a complete, photographed **Y1/Y2** manifold/NSV model and **all suffixes**; OEM edition and drawing identity; actual A/B/F port topology and separate pressure zones; physical location of NSV(s), monitoring switches and safety I/O; load-holding circuit and mechanical ram restraint; pilot supply/loss response; pressure-test-point labels and calibrated physical motion/pressure witnesses; local deliberate restart and guard occupancy. `IN-03a/IN-04a/IN-10a UNKNOWN` until verified. Do not invent leakage speed, pressure threshold, PL/SIL/DC, valve truth table or stop time/distance.

**Disposition:** all claims product-scoped `DOC-CONFIRMED` or explicitly `INFERENCE`; selected OpenPressBrake component installation `UNKNOWN`; physical `TEST-CONFIRMED` **none**. `VAL/PT NOT RUN`, no personnel-exposed operation authorized. R&D operation only isolated/remote with all persons outside danger zones and residual risk recorded.
