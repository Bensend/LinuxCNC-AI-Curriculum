# Professional hydraulic press / vertical-axis safety trace — pressure removal, flow blocking, load holding, restraint

Session start recorded before substantive work: **2026-09-17T18:36:26Z UTC**.

## Purpose

This trace closes a recurring conceptual error in press and vertical-axis safety work: **remove pressure**, **prevent flow**, **hold the load**, and **physically restrain the load** are different engineering objectives. A machine may require more than one of them, and evidence for one must not be silently promoted into proof of another.

Claim labels used here: `DOC-CONFIRMED`, `INFERENCE`, `UNKNOWN`.

## Authoritative implementation evidence

### HAWE press-brake system evidence

`DOC-CONFIRMED` — HAWE describes modern CNC press-brake hydraulics as requiring reliable holding of the press beam, short switching time/overtravel, and safe monitoring of individual functions. Its press-brake application page identifies **holding up the press beam** as an explicit function, not merely pressure generation or normal servo positioning.

Source: HAWE Hydraulik, *Press brakes* application page, current page accessed 2026-09-17: https://www.hawe.com/applications/manufacturing-efficiency/press-brakes/

`DOC-CONFIRMED` — HAWE ePRAX modular regulates each press-beam cylinder with its own controlled servomotor/drive and can use temporarily stored hydraulic energy for return motion. The system is described as certified for hydraulic press brakes under DIN EN 12622. This is important because a stopped motor command does not imply that stored hydraulic energy has disappeared.

Source: HAWE Hydraulik, *ePRAX modular — press controls*, current page accessed 2026-09-17: https://www.hawe.com/de-at/produkte/produktfinder/integrierte%2Bloesungen/pressensteuerungen/eprax-modular%2B-%2Bpressensteuerungen/downloads/

`DOC-CONFIRMED` — HAWE SAKB is a press-brake hydraulic control architecture consisting of a central control block plus two separate suction/anti-cavitation valves, again explicitly intended for press brakes and certified according to DIN EN 12622.

Source: HAWE Hydraulik, *SAKB — control for CNC press brakes*, current documentation page accessed 2026-09-17: https://www.hawe.com/en-us/products/product-finder/integrated%2Bsolutions/control%2Bfor%2Bpress%2Bbrakes/sakb%2B-%2Bcontrol%2Bfor%2Bpress%2Bbrakes/

### Bosch Rexroth hydraulic safety evidence

`DOC-CONFIRMED` — Bosch Rexroth's standardized STOM hydraulic STO manifolds are intended as area shut-off devices for machines including presses. Rexroth describes the manifolds as implementing hydraulic functional safety to ISO 13849, with a shut-off function and decompression capability. This is useful evidence that hydraulic safety can require a deliberate **isolate/decompress** function rather than relying on the normal directional/proportional command becoming zero.

Source: Bosch Rexroth, *Functional safety out of the box — STO manifolds STOM*, 2024-10-22: https://www.boschrexroth.com/en/de/company/press/sto-manifolds-27520.html

`DOC-CONFIRMED` — Bosch Rexroth cylinder-mounted load-lowering/check-and-metering valves are designed to lock or meter oil flow following hose failure and are mounted at or near cylinder ports specifically to protect suspended loads. This is direct evidence that **load retention can require a local hydraulic element at the actuator**, and that upstream command or pump state alone is not equivalent to holding the load.

Source: Bosch Rexroth Oil Control, *Check and Metering Valves* catalog: https://apps.boschrexroth.com/products/compact-hydraulics/ch-catalog/pdf/Check_and_metering.pdf

## Four separate safety objectives

| Objective | Physical question | Evidence that can support it | What does **not** prove it by itself |
|---|---|---|---|
| Remove pressure | Has hazardous pressure in the relevant volume been reduced to the task-defined safe state? | Correctly located pressure witness; verified dump/decompression path; task-specific direct check | Pump OFF; valve command zero; HMI pressure value from an unverified sensing point |
| Prevent flow | Can fluid still enter/leave the hazardous actuator volume through any credible path? | Closed/isolation element at the correct boundary; valve-position proof where applicable; plumbing trace | Zero command; stopped servo pump; upstream contactor OFF |
| Hold the load | If pressure supply or a hose/path fails, is the gravity/external load prevented from dangerous motion? | Appropriate load-holding/check/blocking architecture close to actuator; validated physical challenge; redundant architecture where required by the machine risk design | Pressure removed everywhere; STO alone; normal servo position loop; LinuxCNC position unchanged |
| Physically restrain the load | If hydraulic/electrical control is lost or intentionally released for maintenance, is a mechanical restraint carrying/preventing the hazardous load? | Rated maintenance block/pin/prop or other machine-specific mechanical restraint, correctly installed and physically verified | Hydraulic gauge = 0; safety PLC safe indication; load-holding valve status alone |

## Failure-path reasoning

### Case A — pump stopped, vertical load still supported hydraulically

`INFERENCE` — Pump motor OFF can remove the source of new hydraulic power while the cylinder remains pressurized because of trapped oil, a closed valve, accumulator energy, gravity load, or a load-holding element. Therefore pump OFF is useful source-state evidence but not pressure-absence evidence.

Required proof remains machine-specific: plumbing, valve state, pressure witness location, accumulator path, and load path.

### Case B — dump/decompression opens

`INFERENCE` — A verified dump path may reduce pressure in the volume connected to it while a pilot-operated check, counterbalance/load-holding valve, closed directional element, hose isolation, or separate cylinder chamber retains pressure elsewhere. Therefore `dump valve open` must be mapped to the exact hydraulic volumes it can actually depressurize.

### Case C — load-holding valve closes

`INFERENCE` — A correctly selected and installed load-holding element can intentionally preserve pressure to prevent gravity motion. In that state, `pressure remains` is not automatically a fault; it may be the mechanism preventing hazardous descent. Maintenance that requires opening that trapped volume then needs a separate load-transfer/restraint plan before pressure is released.

### Case D — mechanical maintenance restraint installed

`INFERENCE` — A maintenance block changes the safety objective from relying on fluid power to relying on a physical load path. Correct verification therefore includes installation/engagement and capacity/applicability evidence, not merely a controller input saying `BLOCK_INSTALLED`.

## OpenPressBrake boundary

The present OpenPressBrake controller may command proportional valves, pumps, contactors and normal motion, and may display hydraulic/safety diagnostics. Those functions remain **ordinary control/diagnostics** unless a separate validated safety architecture explicitly assigns them a safety role.

Do not infer any OpenPressBrake machine hydraulic truth table from the generic references above. The existing press brake's actual cylinder arrangement, suction/fill valves, load-holding/blocking elements, dump path, accumulator state, pressure-witness locations, maintenance restraint and feedback topology remain `UNKNOWN` until traced from its schematics/manuals and physically verified.

For personnel exposure beneath or within a gravity/crush hazard, an unresolved load path is a minimum-safe-to-operate blocker. Experimental operation with that uncertainty must keep people outside the danger zone and use isolated/remote methods appropriate to the residual hazard.

## Commissioning / validation transfer worksheet

For each hazardous vertical or press axis, record:

1. **Hazardous load:** what mass/force can move and in which direction?
2. **Normal drive source:** pump, servo pump, accumulator, gravity, external process force.
3. **Pressure volumes:** which cylinder chambers/lines can retain energy?
4. **Flow-prevention elements:** identify actual valves and their de-energized/fault states.
5. **Load-holding elements:** identify what prevents descent if the upstream hose/source fails.
6. **Decompression path:** identify exactly which volumes are relieved and which are intentionally trapped.
7. **Feedback:** distinguish coil command, spool/valve-position proof, pressure proof and actual load/motion proof.
8. **Mechanical restraint:** identify maintenance block/pin/prop, installation method and physical witness.
9. **Challenge tests:** challenge source removal, safety demand, relevant valve feedback, pressure witness and load retention without placing personnel in the danger zone.
10. **Restart/rearm:** prove restoration of hydraulic/safety conditions does not itself initiate hazardous motion.

## Adversarial review questions

- Can one hose rupture bypass the claimed holding function?
- Can one common return/manifold crack defeat two nominally redundant valve channels?
- Can a pressure sensor be isolated from the trapped hazardous volume while still reading zero?
- Can a valve coil be OFF while the spool remains mechanically stuck?
- Can a spool be in the commanded safe position while gravity still moves the load through another path?
- Does removing trapped pressure also remove the only thing holding the load?
- Can maintenance personnel remove the mechanical block before another physical holding mechanism has actually taken the load?
- Is the correct restraint so awkward to use that bypassing it is predictably easier than using it?

## Result

The curriculum now freezes a four-objective hydraulic safety model:

**source removal / pressure control → flow isolation → load holding → physical restraint**

These may overlap in a particular machine, but they must never be assumed equivalent. The next high-value step is an installed-machine hydraulic schematic trace that labels every relevant press-brake volume, final element, feedback path and gravity/load path against this model. Until that evidence exists, machine-specific valve truth tables, pressure thresholds, stopping distances and performance-level claims remain `UNKNOWN`.
