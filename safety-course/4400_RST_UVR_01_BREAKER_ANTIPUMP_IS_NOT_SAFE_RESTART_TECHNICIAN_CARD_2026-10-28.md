# 4400-RST-UVR-01 — A breaker that will not “pump” can still be commanded closed
**2026-10-28 | one-pass technician/reviewer card | NOT a live-test procedure or machine release**

Read [original Schneider/ISO/IEC source-depth audit](../research/4400_RST_UVR_01_SCHNEIDER_MN_MX_DELAY_ANTIPUMP_REMOTE_RESET_SOURCE_ADDENDUM_2026-10-28.md) alongside [existing RST-01 power-return/reset/EDM module](4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md). This card adds **exact breaker/accessory failure-path distinctions** to that existing course, not a second reset curriculum or unscored exam.

## Five things that must not be conflated
| What a technician sees | What it can establish for the **named** OEM accessory | What it cannot establish |
|---|---|---|
| **MN undervoltage release installed** | The compatible breaker may trip when MN supply drops; selected NSXm model has a nondeterministic intermediate voltage band. | All dips cause immediate opening; all other supplies and stored energy are safe. |
| **MN time-delay unit** | Some transient dips are intentionally ignored for a configured interval (NSXm OEM allows up to 3 s). | The delay satisfies an E-stop/guard stopping requirement; the number applies to another machine. |
| **MX shunt-trip coil** | Powered trip request can open the selected breaker. | Loss of trip-coil supply alone will open it; MX is an MN substitute. |
| **Mechanical anti-pumping** | With a maintained opening demand, a maintained closing order cannot repeatedly cycle the selected MTZ breaker. | A *later* electrical closing edge is personnel-safe, or no new normal motion demand can be retained. |
| **RES/RAR reset, PF ready, MCH charged, XF close** | Reset/charge/ready/close are distinct stages of the selected breaker mechanism. | The guard is effective, the area is clear, hydraulic ram is held, or independent safety reset and new cycle start occurred. |

## Practical safe-state decision
A power fault or E-stop has occurred. Before a qualified person restores machine operation, identify the **exact installed breaker and option set**, its control supply and actual main-contact feedback, the independent safety relay/PLC and EDM, and the physical electrical/hydraulic/mechanical final elements. Ask separately: (1) did the breaker open; (2) was the hazardous energy path actually interrupted or load held; (3) is the protected area clear; (4) did the independent safety system deliberately rearm; (5) was a **new** ordinary machine-cycle command issued? **Any unknown answer that matters to personnel safety means HOLD.**

**Human factors:** show a clear “supply fault / breaker tripped / reset eligible / ready to close / safety reset required / new cycle start required” progression. Prefer accessible diagnosis and an unambiguous deliberate restart over a single “Reset Everything” button. Do not bypass a nuisance-trip MN delay, tie an MX coil to an unreliable HMI, bridge EDM, or use remote reset as maintenance isolation.

**Qualified validation only:** derive dip duration, stop time, load/guard state and restart acceptance from the *selected* machine's hazard assessment, SRS and OEM. No live voltage dipping or hazardous fault staging with people exposed; any later experimental operation requires remote isolation, people outside the danger zone, qualified controls and explicit residual risk. Do not infer a numeric PL, pressure or stopping distance.

**Evidence classification:** Schneider OEM specifics **DOC-CONFIRMED** for named families; ISO/IEC scope **DOC-CONFIRMED**; cross-machine architectural risks **INFERENCE**; selected OpenPressBrake MN/MX/RES/RAR/XF, Pilz/AKAS, Y1/Y2 and independent proof **UNKNOWN**; **TEST-CONFIRMED none**. Existing Stage A A–G intake, [blank RST-01 as-built witness](4400_POWER_RETURN_EDM_AS_BUILT_BLANK_WITNESS_2026-10-24.md) and external 2520–25F0 evaluator are still pending. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.**
