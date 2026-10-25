# 4400-CONFIG-01 — Safety signatures, changed standard logic, and the physical safety boundary
**Safety engineering learner module | 2026-10-25 | NON-GRADUATED | documentary study only**

## Competency
A technician or AI engineer must identify exactly what a controller safety signature covers, distinguish online/offline identity from physical safe state, review changes to normal LinuxCNC/FPGA control without transferring safety authority, and reject unauthorized restart after a service change. Prerequisites: 2520 hazard/SRS, 2530 E-stop, 2540 relay/final elements, 2570 drives, 2580 hydraulics, 2590 guards, 4400-EDM-01, 4400-IO-01.

## Evidence to study in order
1. [Original Rockwell/Siemens signature and download audit](../research/4400_ROCKWELL_SIEMENS_SAFETY_SIGNATURE_SCOPE_ONLINE_OFFLINE_REDOWNLOAD_AUDIT_2026-10-25.md).
2. [Original Rockwell safety-I/O replacement/SNN audit](../research/4400_ROCKWELL_SAFETY_IO_AUTO_REPLACEMENT_SNN_AND_FUNCTIONAL_RETEST_AUDIT_2026-10-25.md).
3. [4400-IO-01 diagnostic outcomes](4400_IO_01_FOUR_FAULT_STATE_SAFETY_CASE_AND_12_GATE_NO_ENERGY_REVIEW_2026-10-25.md).
4. [Selected-machine G0 request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md).

## The five separate truths
| Layer | Example witness | Not established by it |
|---|---|---|
| **Identity** | Exact controller serial/model, network address and selected machine ID | Accepted logic or correct wiring |
| **Configuration integrity** | Accepted safety signature matches online controller; I/O signature/config | Physical function, standard program, geometry |
| **Diagnostic health** | No safety fault and network connected | Contactors actually open, hydraulic valves isolate, Y1/Y2 held |
| **Physical safe state** | Qualified independent physical stop/hold/guard/pressure proof | A new motion command is authorized |
| **Fresh restart authorization** | Safe, visible manual reset/occupancy clear and **new** normal motion request under validated SRS | Any permission to bypass independent safety or physical isolation |

**Key DOC-CONFIRMED contrast:** Rockwell 5580 signature excludes the standard application. Siemens V20 separately requires confirming correct target F-CPU and matching accepted online/offline collective F-signatures. Rockwell permits specific safety I/O auto-configuration cases but explicitly retains functional test/authorization after replacement. A signature is a powerful configuration-integrity tool; it is **not** a physical safety certificate.

## Press-brake failure chain to reason through
An ordinary LinuxCNC/HAL change advances a motion command after E-stop reset. Safety logic remains signature-matched, but operator may be inside front tooling or behind backgauge. A replacement I/O device reconnects with correct SNN and reports healthy. A separate output backfeed or contaminated hydraulic valve leaves Y1/Y2 unsafe. The dangerous mistake is combining **signature MATCH + I/O READY + normal ENABLE** into permission to stroke. Instead, independent safety functions must inhibit the hazardous energy/motion until their own protective state is valid; operator reset must not itself issue a new stroke, and independent physical hold/guarding must be proven.

## Machine transfer
- **Press brake:** gravity Y1/Y2 holding, hydraulics, tooling/front/rear occupancy and rearm.
- **Mill/lathe:** spindle coastdown, door lock, chuck/workholding and automatic restart.
- **Robot/cell:** zone occupancy, unexpected auto-cycle after network reconnection and reset location.
- **Plasma/laser:** beam/arc isolation, extraction/fire hazard and automatic ignition.
- **Conveyor/feeder:** jam-clearing access and auto-restart after replacement.
These are distinct SRS designs. Do not copy press-brake hydraulic requirements into a mill or assert identical PL/SIL.

## Technician method (NO-ENERGY, paper first)
A. Identify selected machine/modes/personnel hazard; record accepted safety SRS and controller/software baseline. B. Compare **actual** controller identity, online/offline safety signatures, firmware, module suffixes, I/O config and normal-control change set; record mismatch rather than overriding it. C. Trace safety input -> safety logic -> output -> monitored final element -> physical stop/hold/guard/pressure; mark missing links UNKNOWN. D. Review changes in LinuxCNC/FPGA/HMI timing and reset/start behavior as dependencies, **even when safety signature matches**. E. Require qualified change impact assessment, separate physical validation and deliberate fresh command before any release. F. If replacement, use OEM-specific process and independent authorization; do not assume plug-and-play equals safe.

## Human-factor engineering
Maintain a printed service card showing exact part suffixes, approved replacement, accepted signature, current standard program revision, machine ID, change-impact owner and proof status. Provide visible diagnostics for mismatched firmware/SNN/OSSD settings and accessible guard replacement. Avoid “temporary bypass to get production back”; if service requires defeat, redesign the service workflow. A retained bypass or unlocked unsigned controller is a **HOLD** state.

## Practice and release
Use [16 unscored decision cases](4400_CONFIG_01_SIXTEEN_SIGNATURE_REPLACEMENT_TECHNICIAN_CASES_2026-10-25.md) and [12-gate documentary worksheet](4400_CONFIG_01_TWELVE_GATE_NO_ENERGY_CHANGE_RELEASE_REVIEW_2026-10-25.md). These are not blind evaluations, physical tests or signoff. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD for OpenPressBrake until restricted machine evidence and independent review exist. No personnel-exposed operation with unverified stop/hold/guard; any separately justified experiment must be isolated/remote with people outside danger zone.

## Claim discipline
**DOC-CONFIRMED:** Rockwell and Siemens model/version-specific statements in linked audits. **INFERENCE:** five-layer verification workflow, human-factor changes. **SOURCE-CONFIRMED LinuxCNC:** none newly inspected. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **UNKNOWN:** installed OpenPressBrake safety hardware and physical results, stop times, pressure values, diagnostic coverage, PL/SIL, independent score.
