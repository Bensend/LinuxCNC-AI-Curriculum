# 4400 MACH-ACCESS-01 — safe elevated maintenance and temporary floor openings

**Status:** NON-GRADUATED; **8 PUBLIC PAPER cases UNSCORED**, **10 documentary gates NOT RUN**. [Original regulatory/HSE source audit](../research/4400_MACH_ACCESS_01_ISO14122_OSHA_INTEGRAL_LADDER_HSE_MAINTENANCE_ACCESS_SCOPE_AUDIT_2026-10-27.md).

## Four-state practical workflow
A. **Plan access:** identify actual service tasks, ground-level alternatives, reach, two-hand work, load/tool handling and people in adjacent routes.
B. **Prepare:** qualified access structure inspection, independent machine energy isolation and ram support, physical barriers and alternate route before any cover removal.
C. **Open service:** keep the temporary opening barricaded and under named custody; do not infer safety from HMI idle or a closed guard switch.
D. **Restore:** reinstall every required grate, fastener and guard; independently inspect physical retention; reopen route only after signoff; fresh safety rearm and fresh normal motion command remain separate.

## Eight public scenarios (UNSCORED)
| ID | Situation | Required reasoning |
|---|---|---|
| MAC-P01 | Someone copies OSHA 1910.23 fixed-ladder dimensions onto a machine-integral ladder. | Section 1910.23(a)(2) scope exception; classify access and choose applicable standard/engineering review before numbers. |
| MAC-P02 | Builder says the exception permits welded scrap rungs. | Exclusion from one section is not exemption from safe access or qualified structural review. |
| MAC-P03 | Technician stands on hydraulic piping to reach a filter; LinuxCNC shows E-stop. | Provide designed access or move service point; E-stop does not establish footing or ram/energy safety. |
| MAC-P04 | Technician removes walkway grating and a second worker approaches. | Pre-install barrier and alternate route; named custody, not a warning sign alone. |
| MAC-P05 | Cover returned with missing bolts for convenience. | Keep route closed; restore retention and independently inspect. |
| MAC-P06 | Oil leak makes steps slippery while normal motion diagnostics remain green. | Repair/clean/inspect access independently of controller. |
| MAC-P07 | Remote HMI says guard closed while person is on platform near ram. | Guard state is not gravity support, pressure isolation or platform structural proof. |
| MAC-P08 | Platform relocated to improve access, old validation still PASS. | CHG: structural mounting, guard reach, fall exposure, escape, stop/hold dependencies and revalidation. |

## Ten documentary gates (NOT RUN)
| Gate | Required selected-machine evidence |
|---|---|
| MAC-G01 | Machine/mode/tasks, jurisdiction and integral/building/portable/mobile access classification |
| MAC-G02 | Ground-level service opportunities and need for elevation |
| MAC-G03 | As-built access structure/attachments, ratings and qualified design review |
| MAC-G04 | Footing/handholds/lighting/tools/contamination and access task review |
| MAC-G05 | Reach from platform into guards, tooling, Y1/Y2 and other hazards |
| MAC-G06 | Independent physical gravity hold, hydraulic/electrical isolation and stored-energy plan |
| MAC-G07 | Removable grating/hatch inventory, barrier and alternative-route controls |
| MAC-G08 | Physical reinstatement inspection, custody transfer and route reopening authorization |
| MAC-G09 | CHG for service points, structure, guards, loads and contractors |
| MAC-G10 | Qualified residual-risk review and independent evaluator; do not self-score |

**Three witnesses must remain separate:** physical access integrity; physical machine stop/hold and isolation; deliberate restoration/rearm. A guard switch can be closed with a floor opening still unprotected; a restored floor does not prove a ram is safe. **DOC-CONFIRMED** official eCFR/HSE mechanisms, ISO metadata only; **INFERENCE** this procedure; **UNKNOWN** selected OpenPressBrake configuration. No new SOURCE-CONFIRMED LinuxCNC, TEST-CONFIRMED or COMMUNITY-REPORTED evidence. No physical trial or compute. **G0/G1 HOLD; no personnel-exposed hazardous operation.**
