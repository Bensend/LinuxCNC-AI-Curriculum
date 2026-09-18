# Hydraulic Safety Function Objective and Feedback Trace — 2026-09-18

Session start: 2026-09-18T00:36:46Z

## Purpose

Continue the 4000 safety-course hydraulic/fall-protection branch without inventing an OpenPressBrake hydraulic truth table. This trace reconciles current manufacturer evidence around monitored hydraulic safety functions and separates command, valve-state proof, fluid-state proof, and load-state proof.

## Evidence ledger

### HAWE press-brake application evidence

**DOC-CONFIRMED:** HAWE describes reliable holding of the press beam, minimum switching time/overtravel, and safe monitoring of individual functions as press-brake requirements. Its ePRAX modular system controls each ram cylinder with its own servomotor/drive controller, integrates anti-cavitation valves, and can use temporarily stored hydraulic energy for return stroke. The product is described as certified for press-brake application to DIN EN 12622.

Sources:
- https://www.hawe.com/applications/manufacturing-efficiency/press-brakes/
- https://www.hawe.com/en-us/products/product-finder/integrated%2Bsolutions/control%2Bfor%2Bpress%2Bbrakes/eprax-modular%2B-%2Bcontrol%2Bfor%2Bpress%2Bbrakes/downloads/
- HAWE B 6340 operating instructions, 02-2026.

**DOC-CONFIRMED:** HAWE defines switching-position monitoring as monitoring the valve switching element, commonly with proximity sensors or displacement transducers, and names a press safety valve as a typical application.

Source: https://www.hawe.com/nl-nl/fluid-lexicon/detail/switching-position-monitoring/

### Bosch Rexroth hydraulic STO evidence

**DOC-CONFIRMED:** Bosch Rexroth's standardized STOM architecture separates at least three hydraulic safety objectives: STO uses two-channel position-monitored blocking between P1 and P2; SDE provides controlled downstream decompression through dual bypass paths; SLS provides a controlled limited-flow behavior. Rexroth identifies presses among intended applications and describes the manifolds as area shut-off devices.

Sources:
- https://www.boschrexroth.com/en/de/company/press/sto-manifolds-27520.html
- https://www.boschrexroth.com/en/us/blog/ih/safety-solved-how-sto-manifolds-deliver-critical-machine-protection-without-the-engineering-headaches-us/

Manufacturer timing, pressure, category and performance-level statements are retained as manufacturer-specific evidence and are **not** imported as OpenPressBrake design values.

## Reconciled physical chain

The course shall reason about hydraulic safety functions through this chain:

**safety demand -> safety output -> actuator/coil state -> actual valve-element state -> hydraulic path state -> local pressure/flow state -> actuator/load state -> remaining stored/gravity energy**

Each arrow is a possible evidence boundary. Evidence at one boundary does not silently prove every downstream boundary.

### Claim limits

| Observation | What it can support | What it does not by itself prove |
|---|---|---|
| safety output OFF | controller demanded removal | coil de-energized, valve moved, flow blocked, pressure gone, load held |
| coil current absent | electrical actuator not energized | spool/poppet position or hydraulic path state |
| monitored valve position in safe state | monitored switching element reached documented position | downstream pressure absent, every parallel path blocked, ram mechanically restrained |
| upstream path blocked | source path is closed as documented | trapped downstream pressure discharged |
| decompression path proven | bounded volume has a documented discharge path | gravity load retained or mechanically blocked |
| pressure witness near zero | pressure at that witness location is near zero | all chambers/accumulators are discharged or load cannot fall |
| ram stationary | no observed motion during observation | durable load holding, fault tolerance, maintenance-safe isolation |
| mechanical restraint engaged and physically verified | restrained degree of freedom is mechanically blocked within its validated scope | unrelated electrical/hydraulic hazards absent |

## Important architecture distinction

Rexroth's separation of blocking and decompression is strong evidence against treating `hydraulic safe` as one generic state. A function can intentionally block a source while pressure remains trapped downstream. Conversely, decompression can remove pressure while failing to provide the load-holding objective required for a gravity-loaded vertical axis.

HAWE's press-brake material reinforces a second distinction: a press can intentionally contain stored hydraulic energy as part of normal operation. Therefore pump stopped, motor STO, or proportional command zero cannot be used as a generic stored-energy proof.

## Monitoring boundary

Valve-position monitoring is valuable physical feedback because it crosses the command-to-mechanism boundary. It still remains **valve-element evidence**, not automatically fluid-state or load-state evidence. A credible validation therefore needs witnesses selected for the safety objective:

- source isolation objective -> actual redundant blocking-element feedback where provided;
- decompression objective -> valve feedback plus pressure witness at the volume claimed to be decompressed;
- load-holding objective -> load-side blocking architecture plus actual load-motion/retention challenge appropriate to the machine;
- maintenance restraint objective -> independently verified physical restraint/isolation, not merely a safety-controller status bit.

## LinuxCNC/OpenPressBrake boundary

**INFERENCE:** LinuxCNC/HAL and the ordinary FPGA may request normal hydraulic behavior, display diagnostic state, and consume safety permissives. They must not become the sole personnel-safety authority simply because they can observe valve or pressure feedback.

**UNKNOWN for the actual OpenPressBrake machine:** cylinder chamber topology, prefill/suction path, redundant blocking/dump elements, accumulator sources, pressure-witness locations, valve-position feedback, maintenance restraint, and the exact independent safety-controller-to-final-element mapping. These remain machine-evidence requirements.

No generic HAWE or Rexroth valve state is to be copied into the machine truth table.

## Commissioning questions produced by this trace

1. Which exact hazardous motion/energy is each hydraulic safety function intended to control?
2. Which physical element is the final element for that function?
3. Is its actual state monitored, or only its electrical command?
4. Which hydraulic volume is claimed isolated or decompressed, and where is that state witnessed?
5. Can an accumulator, gravity load, prefill path, cross-port path, leakage path, or parallel valve defeat the claimed physical result?
6. What proves the ram/load result rather than merely the valve result?
7. After restoration, what independent reset/rearm and fresh ordinary START are required?
8. For maintenance, what additional physical isolation/blocking/restraint is required beyond operational functional safety?

## Minimum-operate rule

If the safety case for a gravity-loaded hydraulic axis stops at controller output, coil state, or valve-position feedback and does not establish the required physical load result, the relevant personnel-exposed operating condition is not validated. If a minimum safe operating threshold cannot be demonstrated, do not operate with people exposed; experimental work must be isolated/remote with people outside the danger zone.

## Compute decision

No compute was justified. The unresolved questions are physical topology/evidence questions, not simulation questions. No GitHub-hosted or self-hosted runner time was consumed.

## Next evidence target

Find an inspectable professional press/vertical-axis implementation that exposes a monitored blocking/fall-protection valve together with its pressure/load witnesses and reset/re-enable chain. Build a bounded truth table:

**demand -> commanded valve state -> monitored valve state -> hydraulic objective -> pressure/flow witness -> physical load result -> remaining energy -> reset/rearm -> fresh ordinary START**.

If public evidence stops before pressure/load proof, preserve that boundary as UNKNOWN and rotate to another open safety module rather than inventing the missing machine behavior.
