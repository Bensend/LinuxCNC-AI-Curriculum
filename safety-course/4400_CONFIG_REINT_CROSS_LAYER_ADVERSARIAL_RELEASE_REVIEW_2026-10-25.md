# 4400-CONFIG/REINT — Cross-layer adversarial review: signed, connected, rearmed, still hazardous
**2026-10-25 | Source-grounded PAPER review | NOT RUN as independent evaluation | No physical release**

## Challenge to the implicit release argument
A proposed commissioning note says: “The safety PLC is signed, all I/O is connected, the operator pressed reset, and the LinuxCNC HMI says READY. The press brake is therefore safe to stroke.” This argument is **not valid**.

## Four concrete counterexamples and evidence owners
| Counterexample | Direct manufacturer evidence | Required missing evidence |
|---|---|---|
| A. Safety signature unchanged after standard logic or IP/slot change | Rockwell 5580 [safety signature scope](../research/4400_ROCKWELL_SIEMENS_SAFETY_SIGNATURE_SCOPE_ONLINE_OFFLINE_REDOWNLOAD_AUDIT_2026-10-25.md); Logix Designer v36+ settings exceptions | Correct machine/controller target, current ordinary program revision, change impact and physical SRS |
| B. Safety I/O auto-configures after replacement while protected device is being serviced | Rockwell [replacement OEM audit](../research/4400_ROCKWELL_SAFETY_IO_AUTO_REPLACEMENT_SNN_AND_FUNCTIONAL_RETEST_AUDIT_2026-10-25.md): do not rely on affected device during replacement | Independent exclusion/energy isolation, correct sensor/guard/wiring and qualified functional retest |
| C. Brief F-I/O supply dip automatically reintegrates despite manual acknowledgment selection | Siemens V20 S012 [REINT source audit](../research/4400_SIEMENS_V20_FIO_SHORT_POWER_LOSS_AUTO_REINTEGRATION_VS_COMM_FAULT_ACK_AUDIT_2026-10-25.md) | Verified startup protection, occupancy, no stale ordinary command, fresh authorized motion |
| D. Fault bit detects output cross-circuit but physical load remains ON | Rockwell 5034-OB8S/XT [OUT source audit](../research/4400_ROCKWELL_POINTMAX_SAFETY_OUTPUT_SA_BACKFEED_DETECTED_NOT_SAFE_OEM_AUDIT_2026-10-25.md) | Monitored final-element response, independent Y1/Y2 stop/hold, pressure/guard/rescue evidence |

**Vendor scope warning:** These are independent product-family examples. No evidence establishes that Siemens and Rockwell products coexist on OpenPressBrake. Combining the *failure concepts* is valid; combining their exact wiring, timing, firmware or diagnostic claims into a hypothetical installed architecture is not.

## Seven adversarial review gates (ALL NOT RUN)
1. **Identity:** is the actual machine, target safety controller, network address and approved baseline independently established?
2. **Code:** are ordinary LinuxCNC/HAL/FPGA/HMI changes evaluated even if safety signature matches?
3. **I/O:** are module suffix, SNN, electronic keying, sensor mode and replacement option verified against actual installation?
4. **Fault transitions:** are short power dip, long communication loss, channel fault, auto-reintegration, manual acknowledgment and fault-clear explicitly distinguished for the selected OEM?
5. **Physical safe state:** do independent final elements stop/hold Y1/Y2 and control gravity, trapped pressure, front/rear access and service rescue?
6. **Human factors:** can technician restore correct guard/module and clear faults without a bypass; are retained jumpers, hidden reset locations and stale motion requests addressed?
7. **Independent release:** are documentary G0, isolated G1/G2 and any people-exposed G3/G4 decisions separate, qualified, versioned and witnessed?

## Minimal falsification scenarios (paper only)
- Change only a standard motion timing parameter while signature remains equal. **Do not conclude unchanged machine safety.**
- Replace a networked module and watch it reconnect. **Do not conclude physical protective function validated.**
- Remove/restore supply faster than F-monitoring time in a Siemens V20 paper scenario. **Do not infer that manual ACK_NEC guarantees an operator reset.**
- Request OFF with a Rockwell named output backfeed condition. **Do not infer load OFF from detected fault.**

No numeric stopping distance, hydraulic pressure, SIL/PL, diagnostic coverage or software test outcome is assigned. No energized experiment authorized. If basic physical stop/hold/guard proof is missing, do not operate with people exposed; any separately approved experimental operation must be remote/isolated, people outside danger zone and residual risk explicitly assessed.

**Evidence classification:** OEM-specific statements DOC-CONFIRMED; combined cross-layer failure chain INFERENCE; OpenPressBrake machine and performance UNKNOWN; TEST-CONFIRMED none; SOURCE-CONFIRMED LinuxCNC new none; COMMUNITY-REPORTED none relied on. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.
