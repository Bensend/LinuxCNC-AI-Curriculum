# 4400 SET-FLUID-01 — Slow jog is not a safety-related hydraulic speed limit
**2026-10-28; exact official fluid-technology source addendum to existing SET-01; NON-GRADUATED.** No machine-specific safe speed or PL claimed.

## Predecessor and new question
Existing [SET-01 setup/enabling/SLS/LOTO module](../safety-course/4400_SET_01_SETUP_MODE_ENABLING_SLS_AND_LOTO_BOUNDARY_MODULE_2026-10-24.md) and [original OEM mode audit](4400_SETUP_ENABLING_SWITCH_SLS_MODE_TRANSITION_OEM_AUDIT_2026-10-24.md) already distinguish guarded production, deliberate setup selection, hold-to-run/enabling, independently limited motion and maintenance isolation. **New distinct mechanism:** in a hydraulic system, an ordinary proportional flow command or adjustable speed setting is not the same thing as a safety-related **physical flow limit with fault detection and higher-level stop**. How can the builder make guard-open setup usable without making normal LinuxCNC/FPGA the safety authority?

## Direct original safety-body source
[DGUV/IFA Fachbereich AKTUELL FBHM-058, *Reduced speed for fluid power control systems*, English translation of German issue **2019-10-11**, 7-page original PDF](https://publikationen.dguv.de/widgets/pdf/download/article/3546). Direct original PDF text inspected pp.1–3 and pp.6–7. **DOC-CONFIRMED 2019 historical design examples and source scope**, not an installed OpenPressBrake implementation. This document explicitly says its examples are *not mandatory designs*, that the required safety level is application-specific, and that its schematic figures show **only the hydraulic** parts; electrical valve control still requires assessment. It cites earlier 2015/2016 Part 1 editions, so its example category/PL possibilities cannot be transferred uncritically to current Part 1:2023 or a selected press brake.

## Narrow original source findings
- **Setup mode is a system property:** the source describes other modes disabled, continuous enabling/two-hand/hold-to-run and reduced risk when protective devices are open. A reduced speed **alone** is not sufficient to authorize personnel exposure. The applicable machine Type-C standard/edition and risk assessment must establish any speed criterion; the document lists illustrative ranges across different machines, **not** an OpenPressBrake safe-speed setting.
- **Fixed physical restriction:** the hydraulic examples use a **fixed orifice/fixed throttle** to limit flow when the normal high-speed bypass valve is not energized. The source warns that vertical-axis loads and different cylinder dimensions alter resulting speed even with the same restriction; actual velocity must be independently established over the selected load/temperature/pressure envelope.
- **Single-channel example:** an ordinary work-speed valve can bypass the restriction; its position is **monitored** so a stuck-open bypass must inhibit initiation or invoke a higher-level stop, accounting for reaction time and overrun. The source presents this as an example with category/PL possibilities conditional on components, diagnostics and architecture—not a universal circuit.
- **Two-channel example:** independent switching paths prevent leaving reduced speed, with monitored directional valves and a separate stop arrangement. The source gives a conditional high-category example; do not transplant its illustrated PL or hydraulic truth table to a different machine.
- **Critical source caution:** the document says **ordinary flow-control valves or controllable pumps normally do not satisfy the reduced-speed safety requirement**. It also warns about external/gravity forces, possible need for leakage-free stop valves, and heating during extended throttled operation. This is a **2019 source-specific engineering warning**, not a blanket statement that every variable-displacement or safety-rated speed architecture is invalid.

## Practical authority separation and failure path (INFERENCE)
**Normal control:** LinuxCNC/FPGA requests trajectory and speed; proportional valve driver produces normal motion. **Safety-related control:** independent selected mode/enabling/guard logic commands a physically justified reduced-flow path and independent higher-level stop, monitors required valve positions and faults, prevents unexpected restart. **Physical mechanisms:** selected fixed restriction and final isolation/load-holding elements; independent motion/stop/hold measurements validate actual machine behavior. **Monitoring:** HMI may display the selected mode and actual speed but is not safety authority.

A foreseeable shortcut is “set LinuxCNC jog override to 5% and open the guard.” If a normal proportional output sticks high, a shared hydraulic bypass remains open, a pilot pressure changes, or a heavy vertical load accelerates the ram, the ordinary percentage does not guarantee a safe physical speed. **These are review scenarios, not observed OpenPressBrake faults.** No hypothetical machine-specific numeric stop distance, flow coefficient or pressure truth table is supplied.

## Human factors: safer setup must be easier
A convenient, purpose-built **guard-open setup station** with a visible independent mode indicator, hold-to-run/enabling control, protected restart and accessible diagnostics reduces pressure to jumper the guard. The design should allow normal tool adjustment and maintenance with minimal disassembly *without* eliminating the necessary physical barrier or independent speed/stop function. If a safe setup mode cannot be established, use isolated/remote commissioning with people outside the danger zone; do not permit exposed slow jog.

## Proposed linked evidence — not an executable test
| ID | Required selected evidence | False substitute |
|---|---|---|
| **SRS-SETFLUID-01** | Hazard/mode, applicable standard, independent maximum speed/stop/hold criteria and enabling/restart requirements | “5% jog” |
| **ARC-SETFLUID-02** | As-built hydraulic restriction/bypass/pilot, safety valve monitoring and higher-level stop independent of normal controller | Normal analog zero command |
| **DEP-SETFLUID-03** | Worst-case gravity/load/cylinder/thermal and common-cause assumptions; selected diagnostics | One no-load demo |
| **PHY-SETFLUID-04** | Independent motion/stop/hold witness across justified conditions, safe test fixture and guard/access | HMI speed readout |
| **CHG-SETFLUID-05** | Revalidation after valve/orifice/firmware/mode/guard replacement or adjustment | Reusing old setting |

**UNKNOWN:** selected OpenPressBrake hydraulic flow architecture, any safety-rated reduced-speed setup mode, actual Pilz/AKAS configuration, Y1/Y2 physical stop/hold, applicable speed criteria and independent evaluator. **TEST-CONFIRMED none**. No live setup, fault injection, simulation, workflow or GitHub-hosted/self-hosted compute. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD**. This extends SET-01 without reopening closed levels or generating a new public unscored exam bank.

## Reopen
Qualified restricted [Stage A IN-01..10](../safety-course/4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) with as-built hydraulics, qualified SRS and independent physical/evaluator witness; otherwise rotate to a different 4400 safety gap. Do not copy DGUV's illustrative speed/PL values to a machine-specific configuration.
