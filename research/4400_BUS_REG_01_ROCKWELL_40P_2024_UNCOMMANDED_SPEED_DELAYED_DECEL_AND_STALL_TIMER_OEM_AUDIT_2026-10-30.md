# 4400-BUS-REG-01 — DC-bus regulation can defeat the assumed command-to-stop-time relation
**2026-10-30 | original manufacturer PDF directly inspected | DOC-CONFIRMED / INFERENCE | NON-GRADUATED | NO MACHINE TEST**

## Narrow question and novelty audit
Can a normal VFD ramp-stop command, its configured deceleration time, or a fault timer be used as a personnel-access stop-time witness? **No.** The new exact mechanism is **drive bus-voltage regulation modifying output frequency / deceleration to prevent a DC-bus overvoltage trip**, potentially producing an uncommanded speed increase or extending physical stopping. The full canonical safety index and research plan were checked for `bus regulator`, `A117`, `uncommanded positive speed`, `overhauling load` and `Stall Fault Time`; no prior exact mechanism was indexed. This is distinct from [BR-01 resistor thermal/fire](4400_DYNAMIC_BRAKE_RESISTOR_STUCK_CHOPPER_FIRE_AND_STOP_BOUNDARY_OEM_AUDIT_2026-10-24.md), [DCB-01 shared bus/backfeed](4400_COMMON_DC_BUS_REGENERATION_REENERGIZATION_AND_ISOLATION_OEM_AUDIT_2026-10-24.md), [VFD-EXIT-01 process/drive command](../safety-course/4400_VFD_EXIT_01_PROCESS_EXIT_IS_NOT_DRIVE_SAFE_OFF_TECHNICIAN_CARD_2026-10-29.md) and [RST-01 deliberate restart](../safety-course/4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md). It does **not** reopen any graduated 1000–3000 module.

## Original source: exact product, publication, and passages
Directly inspected [Rockwell Automation PowerFlex 40P Adjustable Frequency AC Drive User Manual, Bulletin 22D, publication **22D-UM001F-EN-E**, September 2024, firmware revisions **1.xx–3.xx**](https://literature.rockwellautomation.com/idc/groups/literature/documents/um/22d-um001_-en-e.pdf). Printed pages and web PDF page indexes differ by one; printed page numbers below are from the manual footer.

1. **DOC-CONFIRMED, printed p.9, General Precautions:** the bus regulator prevents nuisance overvoltage faults during aggressive deceleration, overhauling or eccentric loads. It can cause **uncommanded positive speed changes** with fast positive/imbalanced input-voltage changes and **actual deceleration longer than commanded**. The warning says a stall fault is generated if the drive remains in that condition for one minute; it points to parameter A117 and notes a properly sized dynamic brake resistor as an alternative. This is a manufacturer **warning of possible behavior**, not an observed stop trace on any machine.
2. **DOC-CONFIRMED, printed p.83, A117 Bus Reg Mode:** 0=Disabled, 1=Enabled (**default**) on this PowerFlex 40P publication. It controls bus regulation during deceleration or rising DC-bus voltage. A117=1 is not a safety guarantee; A117=0 is not automatically a safe configuration either.
3. **DOC-CONFIRMED, printed p.84, A121 Stall Fault Time:** the stall timer is **configurable**, not invariably one minute: 0=60 s (**default**), 1=120 s, 2=240 s, 3=360 s, 4=480 s. The p.9 “one minute” warning describes the default case, not every possible as-installed fault latency. **A fault timer is not a validated physical stopping-time limit.**
4. **DOC-CONFIRMED, printed p.172, Positioning Mode notes:** A117 default enabled may cause positional overshoot if deceleration is too short; disabling it can improve precise positioning but deceleration must be tuned to avoid F5 OverVoltage faults. A082 dynamic brake resistor selection is separate and defaults disabled. **Do not recommend toggling A117 on an installed machine without drive/load design review and independent safety validation.**
5. **DOC-CONFIRMED, printed pp.56–57:** P037 ordinary stop modes and the ENBL jumper / I/O terminal 01 dedicated hardware enable are separate from the **optional** DriveGuard Safe-Off Series B, whose application requires suitable safety components. A normal ramp stop, hardware-enable coast, and selected safety-off option are not interchangeable; a component claim does not establish the machine's physical safe state.
6. **DOC-CONFIRMED, printed p.9:** after removing line power, the manufacturer requires capacitor discharge precautions and explicitly warns that a dark display is not evidence of a discharged DC bus. This is an *additional electrical maintenance hazard*, not a stop-time witness.

**Independent cross-model corroboration, restricted provenance:** Rockwell's [PowerFlex 750-Series AC Drives Reference Manual 750-RM002C-EN-P, February 2016, p.44](https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/750-rm002_-en-p.pdf) was available only as indexed manufacturer-PDF excerpts, not a fully opened immutable PDF (viewer exceeded size limit). Its indexed text describes the adjust-frequency regulator raising output frequency above command, delayed deceleration and model-specific 2–12 s fault observations, with P372/P373 rather than A117. **Do not transfer its 2–12 s figures, parameters or stop behavior to the 40P.** No second-model behavior is TEST-CONFIRMED.

## Causal chain and authority boundary
```
Normal CNC motion / spindle command (LinuxCNC, FPGA, fieldbus)
  -> VFD normal RUN/STOP and requested ramp time
  -> DC bus rises from decelerating or overhauling load
  -> enabled drive bus regulator may modify output frequency/ramp
  -> actual motion may persist longer or speed may rise
  -> eventual drive fault is a separate event, not a physical stop-time witness

Independent protective demand -> selected safety logic -> validated physical final elements
  -> hazard-specific actual stop/hold/standstill proof and guarded access authorization
Maintenance -> isolation of all feeds and stored energy -> qualified electrical verification
```
**INFERENCE:** a protective-door unlock timer derived only from LinuxCNC's commanded deceleration or the VFD's configured ramp can be nonconservative. A fault display or normal STOP acknowledgement cannot prove that a spindle, conveyor, axis or overhauling load has stopped. Physical deceleration and guard access must be validated for the selected load, speed, braking method, supply conditions and worst credible failure cases. For a gravity-driven axis, drive control alone is not a substitute for an independent holding arrangement.

## Adversarial failure and human-factors review
| Shortcut / failure | Why it fails | Practical safer design |
|---|---|---|
| Set guard release delay equal to programmed decel | Bus regulator can lengthen decel; load inertia and supply vary | Independently validated stop/standstill/access criterion and physical final-element witness |
| Trust a 60 s stall fault as a safe stop | A121 is configurable up to 480 s; fault is not immediate physical stopping | Do not use diagnostic fault timing as personnel-safety response |
| Disable A117 as a quick fix | Manufacturer warns of overvoltage trips; behavior depends on braking/load | Qualified drive application review, not an operator workaround |
| Add a brake resistor and claim safety | Resistor sizing, thermal/fire protection and drive behavior differ; BR-01 remains applicable | Independently assess braking, heat and protective stop/hold functions |
| Treat dark drive display as zero energy | Stored capacitors and possible backfeeds remain | Qualified isolation/verification, separate from motion stop |
| Make reset/guard use slow or confusing | Predictable incentive to defeat guard | Design clear stop/standstill indication, convenient correctly functioning guard and deliberate restart |

## Evidence ledger and explicit limits
- **DOC-CONFIRMED:** original Rockwell 40P September 2024 printed pp.9, 56–57, 83–84, 172; indexed-only separate 750 2016 p.44.
- **SOURCE-CONFIRMED:** none claimed for proprietary drive firmware; LinuxCNC ordinary control boundary is established in predecessor source work.
- **INFERENCE:** consequences for safety unlock/stop-time design and expected failure path, not a physical observation.
- **TEST-CONFIRMED:** none; no local or hosted compute, drive test, simulation or machine operation.
- **UNKNOWN:** actual drive make/model/firmware, A117/A121/A082, load inertia/overhaul, speed and deceleration, fault reaction, external brake, independent safety chain, physical stop time/distance, safe access and PL/SIL. No generic numerical stopping time or performance level inferred.

**Release:** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Independent 2520–25F0 competency evaluation OPEN. No personnel-exposed hazardous operation; isolated/remote experiments only after qualified physical isolation and separate authorization. A frozen lab is **not justified** to re-prove the documented OEM warning without a selected drive and concrete unresolved physical question.
