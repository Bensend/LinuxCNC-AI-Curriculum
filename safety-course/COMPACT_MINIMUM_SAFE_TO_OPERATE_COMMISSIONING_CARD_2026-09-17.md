# Compact minimum-safe-to-operate commissioning card

Date: 2026-09-17

Purpose: a qualitative pre-energization / return-to-service gate for LinuxCNC-class machine retrofits. This card does **not** assign PL, SIL, stopping distance, pressure threshold, diagnostic coverage, or machine-specific timing values.

Use the machine risk assessment, applicable standards, manufacturer instructions, validated safety design, and installed-machine measurements to supply machine-specific acceptance criteria.

## A. Hazard boundary

- [ ] Hazardous motions and stored-energy sources relevant to the intended operating mode are identified.
- [ ] Personnel exposure zones are identified, including rear/side/service access and gravity/load paths.
- [ ] The intended safeguard span is explicit. Do not assume `protective-device span = E-stop span`.
- [ ] Maintenance/LOTO boundary is explicit and is not replaced by an HMI, LinuxCNC state, FPGA watchdog, STO indication, or safety-controller `SAFE` bit.

**Fail gate:** if a credible hazardous motion/energy path has no established protective or isolation strategy, do not operate with people exposed. Experimental operation must be isolated/remote with people outside the danger zone.

## B. Safety authority boundary

- [ ] Personnel-safety authority is not assigned solely to ordinary LinuxCNC/HAL/FPGA/HMI software.
- [ ] Ordinary control may receive safety status and perform process-friendly stopping/diagnostics, but failure of ordinary control cannot silently cancel the required independent final safety action.
- [ ] Final safety elements are identified physically: e.g. contactors, drive STO/safe-motion inputs, hydraulic/pneumatic safety valves, brakes, restraints, or other machine-specific elements.
- [ ] What remains energized after each safety function is explicitly understood.

## C. MODE INTEGRITY

- [ ] Every safety-relevant operating/setup/service mode has a defined hazard envelope and permitted functions.
- [ ] Mode selection is safely evaluated where the safety architecture relies on mode selection.
- [ ] Invalid/contradictory selector combinations fail to a defined safe/restricted state.
- [ ] Selecting a mode does not itself start hazardous motion.
- [ ] Mode indication is not accepted as proof that the physical machine has reached the required safe state.

## D. FEEDBACK INTEGRITY

- [ ] EDM/final-element feedback corresponds to the actual credited final element.
- [ ] Redundant final elements do not share an unexamined wiring, supply, return, connector, configuration, or sensing failure that can falsely prove both healthy.
- [ ] Feedback proves only its documented state; contactor auxiliary feedback does not prove all hazardous energy absent, and valve-spool feedback does not prove every downstream volume depressurized.
- [ ] Feedback disagreement prevents automatic rearm/restart and produces a useful diagnostic.

## E. Demand-to-final-element challenge

For each E-stop, guard/interlock, light curtain/protective field, safe-mode demand, and other credited protective device:

- [ ] Physically challenge the device.
- [ ] Confirm safety logic recognizes the demand.
- [ ] Confirm the intended final element changes state.
- [ ] Confirm the actual hazardous-motion/energy result required by the design.
- [ ] Confirm any selective-stop span matches the documented hazard boundary.
- [ ] Confirm reset/restoration does not itself restart hazardous motion.
- [ ] Confirm a deliberate, separate start/rearm action is required where intended.

## F. Stored energy and load retention

- [ ] Electrical removal is not assumed to remove hydraulic, pneumatic, spring, gravity, flywheel, thermal, capacitor, or process energy.
- [ ] Vertical/gravity loads have an established safe holding/blocking/restraint strategy.
- [ ] `pressure = 0` is not assumed universally safe; some hazards require retained pressure/load holding rather than dumping.
- [ ] Verification observes the actual relevant energy/load boundary, not merely a command or remote status bit.

## G. Reset, restart and stale-command behavior

- [ ] Safety reset acknowledges/restores safety readiness only; it is not START.
- [ ] Ordinary LinuxCNC/FPGA output authority has an explicit rearm contract after watchdog, communication, safety or power-loss events.
- [ ] Stale motion/output commands, stale integrators and stale HMI status cannot silently resume after safety restoration or communication recovery.
- [ ] Power restoration does not cause automatic hazardous restart.

## H. Human-factors / bypass-pressure review

- [ ] Guards and protective devices are practical to use correctly during normal work.
- [ ] Setup, loading, clearing, lubrication and routine service can be performed without predictable pressure to defeat safeguards.
- [ ] Any recurring request for bypass, wider mute/timing window, disabled feedback or hidden alarm is treated as engineering evidence requiring root-cause review.
- [ ] Temporary bypass/service credentials are controlled, time-bounded, restored and independently checked.

## I. Documentation and change control

- [ ] Installed device identity, firmware/configuration, wiring revision and applicable manufacturer-document revision are recorded.
- [ ] Safety logic/configuration signature or equivalent identity is recorded where available.
- [ ] Physical field installation matches the validated documentation.
- [ ] Changes are impact-assessed; revalidation scope follows the actual affected safety functions and physical paths rather than the file type that changed.

## J. Minimum operate decision

**CLEAR FOR INTENDED VALIDATED MODE** only when every safety-critical item applicable to that mode is established by appropriate evidence.

**RESTRICTED / REMOTE TEST ONLY** when unresolved items can be bounded by isolation and keeping people outside the danger zone.

**DO NOT OPERATE WITH PEOPLE EXPOSED** when a safety-critical hazard path, final element, feedback path, physical stopping/holding result, or restart behavior remains materially UNKNOWN.

## Evidence labels

Record each important conclusion as `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, or `UNKNOWN`. A controller status indication is not promoted to physical proof merely because it is safety-related.
