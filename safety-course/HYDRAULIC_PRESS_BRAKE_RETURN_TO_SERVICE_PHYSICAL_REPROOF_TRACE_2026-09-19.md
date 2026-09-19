# Hydraulic press-brake return-to-service / physical re-proof trace — 2026-09-19

## Question

After hydraulic service or a monitored-valve fault, what can authoritative machine evidence actually prove about the path from physical service isolation back toward production authority?

This study intentionally does **not** invent an OpenPressBrake hydraulic truth table, pressure threshold, stopping distance, proof interval, PL/SIL/category/DC value, or degraded-production mode.

## Evidence 1 — CINCINNATI 60 AUTOFORM OEM maintenance sequence

**Classification: DOC-CONFIRMED (OEM machine manual).**

Source: CINCINNATI INCORPORATED, `EM-501 (N-08/03)`, *60 AUTOFORM Series Press Brake Operation, Safety and Maintenance Manual*, official CINCINNATI PDF:
https://wwwassets.e-ci.com/PDF/Preinstallation/Press-Brakes/em-501-n-08-03-60-autoform-series-press-brake-operation-safety-and-maintenance-manual.pdf

The maintenance procedure gives an unusually useful physical sequence:

1. place the ram at closed dies or on support blocks;
2. stop the main drive;
3. turn off and padlock the main disconnect;
4. connect a pressure gauge to the main-manifold test port to check for trapped pressure, open the counterbalance-manifold bleed valves, then allow internally trapped pressure to bleed down;
5. after maintenance, remove the test gauges and verify the manual bleed valves are closed and locked;
6. only then remove the padlock, restore the main disconnect and start the main drive;
7. use a deliberate RAM UP command to raise the ram before removing supports.

This is direct machine-class evidence that `DRIVE OFF`, `MAIN DISCONNECT LOCKED`, `TRAPPED PRESSURE CHECKED/RELIEVED`, `RAM PHYSICALLY SUPPORTED`, `ENERGY RESTORED`, and `RAM MOTION COMMANDED` are distinct states/authorities.

The same OEM hydraulic component identification names a `#4 solenoid – safety dump valve` and a separate `dumping valve safety switch`. That establishes a machine implementation with a safety-related hydraulic final element plus an explicit switch witness. It does **not** by itself establish what every possible switch state proves about spool position, ram state, pressure, or safe access.

## Evidence 2 — physical pressure proof is plural and followed by re-check

**Classification: DOC-CONFIRMED (same OEM machine manual).**

For counterbalance pressure, CINCINNATI provides two test ports and explicitly requires both sides to be checked. The procedure then calls for cycling the ram a number of strokes and rechecking both counterbalance pressures after setting.

That gives a useful physical-proof pattern:

`SETTING/REPAIR COMPLETE != ONE PRESSURE OBSERVATION != BOTH REQUIRED SIDES CHECKED != BEHAVIOR AFTER CYCLING RECHECKED`.

Do not generalize the manual's numeric pressure or test setup to another press brake. The transferable lesson is the evidence structure: a physical hydraulic property can require multiple witnesses and a post-operation re-check rather than being inferred from a controller command or a single healthy channel.

## Evidence 3 — press-brake standard return-to-service obligation

A publicly indexed copy of EN 12622:2009 reports that machine instructions are to include tests/examinations needed after replacement of components that can affect safety functions, plus periodic maintenance/test/examination of the press brake and protective devices. It also reports recurring stopping-performance checks.

Source lead:
https://www.passeidireto.com/arquivo/80828619/en-12622-2009-safety-of-machine-tools-hydraulic-press-brakes

**Classification: COMMUNITY/SECONDARY TRANSCRIPTION — not promoted to authoritative DOC-CONFIRMED here.** The wording is useful as a source-tracing lead, but the repository should verify the applicable edition from an authoritative standards copy before using exact normative language. The underlying engineering rule is therefore kept bounded: safety-affecting replacement can create a revalidation obligation; the exact required tests remain machine/design/standard-edition specific.

## Reconciliation with existing monitored-valve evidence

Existing Lazer Safe evidence establishes individual press-brake valve command/monitor disagreement and production inhibit. This CINCINNATI trace adds a different missing layer: real service isolation, trapped-pressure handling, physical ram support, a safety dump valve with a switch witness, and multi-point hydraulic re-check after cycling.

The combined evidence supports the following architecture without claiming that the two machines use the same hydraulic circuit:

`MONITORED FINAL-ELEMENT FAULT`
`-> PRODUCTION INHIBIT`
`-> PHYSICAL SERVICE ISOLATION / RAM SUPPORT / STORED-PRESSURE CONTROL AS REQUIRED BY THE MACHINE`
`-> REPAIR OR ADJUSTMENT`
`-> PHYSICAL HYDRAULIC RE-PROOF REQUIRED BY THAT MACHINE/DESIGN`
`-> SAFETY FUNCTIONAL REVALIDATION`
`-> SAFETY REARM`
`-> SEPARATE FRESH ORDINARY START/CYCLE INTENT`

The arrows after repair are an **INFERENCE / design rule** until a same-machine source exposes the complete post-fault sequence. They must not be represented as a verbatim CINCINNATI or Lazer Safe sequence.

## Durable freezes

**FAULT CLEARED IN SOFTWARE != FAILED HYDRAULIC ELEMENT REPAIRED != STORED PRESSURE CONTROLLED != RAM/LOAD PHYSICALLY SECURED != REQUIRED HYDRAULIC PROPERTY RE-PROVED != SAFETY FUNCTION REVALIDATED != SAFETY REARMED != FRESH PRODUCTION START.**

**FINAL-ELEMENT SWITCH AGREEMENT != PHYSICAL PRESSURE PROOF != RAM/LOAD-SAFE PROOF.**

**ONE HEALTHY HYDRAULIC WITNESS != ALL REQUIRED PHYSICAL WITNESSES HEALTHY.** CINCINNATI's two-side counterbalance check is concrete machine evidence for plural physical witnesses, though it is not evidence that those particular pressure checks are themselves the safety-valve proof required on another machine.

## Commissioning / adversarial checks promoted into the course

For any retrofit whose safety case relies on a hydraulic final element, the validation plan must name the proposition each witness actually proves. At minimum challenge:

- command says safe but final-element switch does not agree;
- final-element switch agrees but the relevant physical pressure/motion/load witness does not;
- one required side/path passes while another is failed, stale or unknown;
- a repaired/replaced safety-affecting component is returned to service without the machine-specific required re-proof;
- safety authority returns while an old LinuxCNC `START`, `JOG`, `ENABLE` or cycle request remains asserted.

The expected safe design disposition is inhibit/hold-safe until the required evidence is restored; exact hydraulic reactions remain machine-specific.

## What remains UNKNOWN

Public evidence inspected in this session still does not expose a single modern press-brake implementation showing the entire chain:

`individual monitored valve disagreement -> exact physical ram/load-safe disposition -> latched fault -> component repair/replacement -> exact valve/restraint/stop-performance re-proof -> safety reset/rearm -> fresh production initiation`.

Also UNKNOWN for OpenPressBrake: required redundant hydraulic topology, exact switch/pressure/motion witnesses, proof thresholds, proof intervals, stopping performance, gravity-load behavior, and post-repair acceptance criteria. Those require the actual machine hydraulic design plus applicable authoritative standard/OEM evidence.

## Compute decision

No simulation or executable lab was justified. The unresolved question is documentary and machine-design specific; simulation would manufacture assumptions rather than resolve them. No GitHub-hosted or self-hosted compute was consumed.
