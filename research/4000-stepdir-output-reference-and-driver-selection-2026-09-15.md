# 4000 Step/Dir output reference and driver selection — 2026-09-15

Status: SOURCE/DATASHEET-GROUNDED WORKING DESIGN INPUT

## Question

What electrical contract should the reusable controller use for high-speed STEP/DIR outputs, and what should happen on watchdog loss?

## Production reference: Mesa 7I76 / 7I96S

Mesa's current 7I76 documentation describes five STEP/DIR channels as buffered **5 V differential** pairs. Each signal is presented as complementary outputs and may directly drive RS-422 receivers. Mesa explicitly permits single-ended drives to use only one polarity while leaving the complement unconnected.

Mesa's 7I96S documentation gives a useful performance/reference envelope:
- five axes;
- up to 10 MHz step rates;
- buffered 5 V STEP/DIR outputs;
- 24 mA drive capability;
- differential mode on all STEP/DIR outputs.

This is strong field-proven evidence for choosing a 5-V differential base interface rather than making 3.3-V-only signaling the industrial base contract.

Mesa's 7I96 documentation also warns that FPGA startup I/O state must not itself be assumed safe: external circuitry must translate FPGA configuration/startup behavior into a safe machine-facing state.

Evidence: Mesa 7I76 manual; Mesa 7I96/7I96S manuals/product documentation, accessed 2026-09-15.

## Community implementation detail

Peter Wallace (Mesa) has repeatedly distinguished ordinary RS-422 receiver loads from optocoupled drive inputs. In a May 2026 LinuxCNC forum discussion he noted that ordinary 26LS31-class drivers are suitable where roughly 3-V loaded RS-422 levels are acceptable, while optocoupled drives expecting 5-V signaling call for a stronger 5-V-output solution such as ISL32174/ISL34172/MAX3042 or complementary ACT buffers.

This resolves an important ambiguity: "RS-422 compatible" and "works well with common 5-V optocoupled STEP/DIR servo/stepper inputs" are overlapping but not identical electrical requirements.

Evidence classification: COMMUNITY-REPORTED, consistent with Mesa production-interface behavior.

## Driver candidates

### MAX3042B
Analog Devices lists MAX3042 as a production quad 5-V RS-485/RS-422 transmitter family. MAX3042B/MAX3045B support up to 20 Mbps, have hot-swap input behavior and ±10-kV HBM output ESD protection. It is pin-compatible with older 26LS31/SN75174-class parts.

For our 10-MHz STEP edge contract, 20-Mbps-class switching provides appropriate digital bandwidth without selecting a marginal 3.3-V-only output stage.

### ISL32174E
Renesas lists ISL32174E as a production 3.0-to-5.5-V quad RS-422 transmitter with 32-Mbps capability and IEC 61000-4-2 ESD protection. It is a viable alternate, particularly if sourcing/availability is better.

### Why not freeze 26LS31
The older 26LS31 topology is proven for RS-422 but is not the preferred universal CNC-drive interface because its loaded output swing can be lower than what some optocoupled pulse inputs expect. The board should target the broader 5-V drive-input ecosystem.

## Working electrical decision

Use a **5-V differential STEP/DIR base interface** with six channels (12 logical signals, 24 field conductors). Six axes gives useful headroom over the common five-axis Mesa reference while remaining compact: three quad line-driver ICs implement six STEP + six DIR signals.

Preferred driver class: MAX3042B or equivalently qualified 5-V, >=20-Mbps quad differential transmitter. ISL32174E at 5 V is an approved alternate candidate pending final BOM review.

Working rate contract: **10 MHz maximum STEP transition rate per channel**. This matches current Mesa Ethernet motion-control practice and is below the selected driver-class data-rate capability. Final PCB timing/skew and LiteX-CNC stepgen verification are still required before schematic release.

## Single-ended compatibility

Do not add a second weak single-ended output stage. For drives accepting 5-V single-ended pulse inputs, expose STEP+/STEP- and DIR+/DIR- so the installer can use the required polarity and leave its complement open, following the Mesa pattern.

24-V pulse-command drives are a different electrical interface and require an adapter/variant. Do not silently claim the 5-V differential block supports them.

## Watchdog and startup contract

A watchdog must stop *pulse generation*, not merely report communications failure.

Required authority chain:

`LiteX-CNC stepgen request -> FPGA-local watchdog/authority -> hardware pulse gate -> 5-V differential driver -> drive`

The STEP path SHALL be forced to its inactive static state whenever global output authority is false. Direction may also be forced to a defined inactive state for deterministic diagnostics, but loss of authority must never create a STEP transition train.

Do not rely on line-driver tri-state alone as the safe state because downstream optocouplers/receivers differ in their open-input behavior. The preferred implementation is a default-inactive logic gate/level-shift stage that forces the transmitter data inputs static when FPGA authority is absent. Driver OE may additionally be controlled for power-up containment, but OE is not the sole pulse-inhibit mechanism.

On communication recovery, stale STEP commands SHALL NOT resume until the global explicit rearm contract is satisfied. This inherits the 4000 FPGA watchdog rule.

Power-loss behavior remains ordinary fault containment, not a safety-rated stop. External drive enable/STO and machine safety architecture remain separate authorities.

## Enable and fault boundary

STEP/DIR is command transport only. Drive ENABLE, READY/FAULT and safety-rated STO are separate signals/contracts:
- STEP/DIR command does not prove drive enabled;
- driver electrical activity does not prove motion;
- drive READY does not prove axis position;
- watchdog pulse inhibit is not STO.

General drive enable may use protected digital I/O or a future dedicated drive-interface block. Drive fault/ready returns through appropriate isolated inputs.

## PCB implementation notes for next schematic pass

- route each differential pair together and provide adjacent signal return/shield strategy at the connector;
- do not install source-side 120-ohm termination: termination belongs at the receiving end for a point-to-point RS-422-style link unless a selected drive specifies otherwise;
- add connector-edge transient protection only if capacitance is compatible with the 10-MHz edge requirement;
- verify transmitter short-circuit behavior, thermal loading, simultaneous switching and package decoupling;
- verify FPGA-to-5-V transmitter input thresholds or use explicit AHCT/level translation/gating;
- choose gate polarity so unconfigured FPGA, watchdog false and gate-power failure do not generate pulse trains.

## Evidence boundary

This pass freezes a working architecture, not final component values/layout. Before PCB release: verify exact transmitter ordering code/availability, VIH/VIL with the selected gate/translator, pulse-gate truth table through FPGA configuration and watchdog transitions, connector/TVS capacitance, simultaneous-switching current, and measured 10-MHz signal integrity on prototype hardware.

No simulation is justified yet; datasheet calculations and later bench measurements are higher-value evidence.
