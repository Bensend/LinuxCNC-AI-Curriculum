# 4400 TOOL-RET-01 — Keep the tool captive before the operator enters
**26 October 2026 | Public technician module | 12 PAPER scenarios UNSCORED | 12 documentary gates NOT RUN | NOT a commissioning procedure**

## Learning objective
Distinguish **punch/die retention**, **ram stop/hold**, **energy isolation**, **tool-handling support**, **guard access**, and **fresh restart**. A motion-disabled press can still drop a tool; a captive tool does not prove safe ram or stored-energy isolation. Use the [WILA/Wilson/OSHA source audit](../research/4400_TOOL_RET_01_WILA_FORCE_LOCKED_SELF_LOCKING_SAFETY_CLICK_E2M_AND_LOTO_SOURCE_AUDIT_2026-10-26.md) and existing 2580 hydraulic, 2590 guarding, 4400 RAM-RESTRAINT/LOTO modules.

## Physical safety chain to draw on paper
`operator requests change` → `identify all exposed hazards` → `select task-appropriate independent safe-state and energy isolation/protection` → `mechanically secure ram and tool` → `inspect approved retention/roll-out controls` → `perform supported handling` → `restore guard and selected-machine evidence` → `deliberate fresh start`.

This is a conceptual review sequence, **not permission** to enter the die space, loosen a clamp, disconnect hydraulics, test a fault or perform a live changeover. Qualified machine-specific instructions and independent approval govern actual work.

## Twelve adversarial technician cases (all UNSCORED)
| Case | Presented situation | Required reasoning, not an answer key |
|---|---|---|
| TOOL-P01 | Ram is stopped and LinuxCNC ESTOP shows active; upper punch retention is undocumented. | Separate motion inhibition from tool gravity retention; HOLD access. |
| TOOL-P02 | A WILA hydraulic force-locked holder is assumed safe because the hydraulic pump is off. | Identify exact product, retained-pressure dependency and mechanical capture; no generic fail state. |
| TOOL-P03 | A WILA pneumatic self-locking holder loses shop air. | Distinguish actuation medium from engaged wedge mechanism; exact OEM fault behavior still requires evidence. |
| TOOL-P04 | A 16 kg punch is assigned to a 12.5 kg Safety-Click claim. | Reject transfer of product-specific limit; select approved retention and lifting method. |
| TOOL-P05 | A tool cart allows a heavy die to roll out through a removed E2M end guard. | Identify independent roll-out hazard and easy-to-restore stop/guard. |
| TOOL-P06 | Smart Tool Locator LED shows a tool position but clamp sensor is missing. | Position indicator is not physical clamp retention. |
| TOOL-P07 | A mixed row contains one aftermarket straight tang among Safety-Click tools. | Each segment's compatibility/retention must be established, not averaged. |
| TOOL-P08 | Technician uses setup mode and foot pedal as the only protection while hands are beneath an unsupported punch. | Ordinary mode is not isolation or independent physical restraint; stop work. |
| TOOL-P09 | Production manager calls a major die change “minor servicing” because it takes two minutes. | Apply actual 1910.147 criteria and effective alternative protection, not duration or marketing. |
| TOOL-P10 | One clamp plate is loose but adjacent segments look secure. | Require selected OEM fastening/retention evidence for each segment. |
| TOOL-P11 | Power is restored while the pedal remains depressed after a tool change. | Separate reset, tool secure, guard clear and a new intentional start. |
| TOOL-P12 | A new quick-change clamp is fitted without updating the machine hazard analysis. | Trigger CHG, invalidate tool retention/energy/access/restart proofs, requalify. |

## Twelve documentary verification gates (all NOT RUN)
| Gate | Required private evidence |
|---|---|
| TOOL-G01 | Selected press and as-built tool-holder upper/lower product and revision identified |
| TOOL-G02 | Exact selected manufacturer installation/maintenance manual and compatible tooling/adapter list |
| TOOL-G03 | Mechanical punch capture/retainer design and physical gravity proposition |
| TOOL-G04 | Pressure/air/electric loss behavior documented for selected clamp; stored-energy zones identified |
| TOOL-G05 | Heavy tooling weight/length/handling/support/roll-out stop and guard details |
| TOOL-G06 | Segmented clamp engagement, wear/adjustment and error/loose-part detection method |
| TOOL-G07 | Independent Y1/Y2 ram restraint and physical stop/hold evidence, distinct from clamp |
| TOOL-G08 | Task-specific 1910.147 exposure and isolation/qualified effective alternative assessment |
| TOOL-G09 | Guard/access coverage and operator/helper sightlines during setup |
| TOOL-G10 | Normal controller/FPGA vs safety controller vs final element authority diagram |
| TOOL-G11 | Fresh rearm/start after restoration and fault; held/stuck pedal challenge |
| TOOL-G12 | Qualified inspection, change-control, no-exposure validation plan and independent signoff |

## Easy-safe-workflow design review
Ask the operator to explain where a tool rests before unclamping, how the last segment is retained, whether the end stop must be removed for a normal change, where removed guards are stored, and how a helper knows the machine is safe. Design changes should favor captive geometry, support carts, positive stops, accessible inspection and simple guarded reinstallation over extra warning labels or a hidden override. Document the predictable bypass incentive and redesign it.

## Transfer across machines
A mill ATC spindle tool, lathe chuck/workholding jaw, robot gripper and press-brake upper punch all have distinct **payload-retention** hazards, but the same logical separation applies: `ordinary axis stopped` does not prove `payload captive`. Do not transplant the WILA mechanism, weight limit or OSHA task exception to those machines.

## Release/evaluator boundary
The twelve cases are public practice and cannot count as blind competency. An independent evaluator must construct an unseen case and score an immutable precommit without leaking the answer; see [evaluator handoff](../evaluation/4400_TOOL_RET_01_INDEPENDENT_UNSEEN_TOOL_DROP_AND_CHANGEOVER_HANDOFF_2026-10-26.md). The selected-machine Stage B card remains conditional. No physical test, measured pressure, inferred PL/SIL, simulated result or lab compute. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** No personnel-exposed hazardous operation while minimum safe-to-operate evidence is missing.