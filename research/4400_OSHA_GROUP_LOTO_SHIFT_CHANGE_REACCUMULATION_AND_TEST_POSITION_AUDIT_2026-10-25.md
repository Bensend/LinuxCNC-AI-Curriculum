# 4400-LOTO-TEAM-01 — Group lockout, shift continuity, stored-energy reaccumulation and temporary testing

**Status:** safety-source investigation, non-graduated; 2026-10-25 UTC. **Scope:** US general-industry 29 CFR 1910.147 and OSHA interpretive guidance; not an OpenPressBrake as-built validation or a claim that the cited standard governs every jurisdiction/activity.

## Research question and method
When a press-brake hydraulic/electrical maintenance job crosses shifts or involves multiple trades, what actually preserves *each exposed worker's* control of hazardous energy? What happens if the team needs a short powered positioning test, or pressure can reaccumulate? Resolve from the regulation and OSHA's published interpretations **before** proposing a simulation.

Primary original-authority URLs, consulted via search-indexed official OSHA text on 2026-10-25; direct webpage opening returned HTTP 403 in this research environment, so cite the indexed OSHA text precisely and do **not** claim a full direct-page inspection:

1. 29 CFR 1910.147, especially (b), (c)(4), (d)(5)–(6), (e), (f)(1)–(4): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147
2. OSHA enforcement directive STD 01-05-019, group LOTO, Appendix C Types B/C/D: https://www.osha.gov/enforcement/directives/std-01-05-019
3. OSHA interpretation, 2023-07-27, group verification and right to verify: https://www.osha.gov/laws-regs/standardinterpretations/2023-07-27
4. OSHA interpretation, 1999-11-16, verification and each shift: https://www.osha.gov/laws-regs/standardinterpretations/1999-11-16
5. OSHA eTool group LOTO procedures: https://www.osha.gov/etools/lockout-tagout/hot-topics/group-lockout-tagout/procedures
6. OSHA Appendix A typical minimal procedure (explicitly nonmandatory): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147AppA

## Evidence ledger

| Claim | Classification | Authority and precise scope | Limit |
|---|---|---|---|
| A push button, selector or control-circuit device is **not** an energy-isolating device | **DOC-CONFIRMED (indexed official OSHA text)** | 1910.147(b) definition of energy-isolating device | LinuxCNC E-stop, HMI STOP and FPGA output are normal/control requests, not by themselves physical maintenance isolation. |
| Every exposed authorized worker attaches/removes their personal lock/tag to group lockbox or equivalent for their own exposure interval | **DOC-CONFIRMED** | 1910.147(f)(3)(ii)(D); OSHA eTool | A shared supervisor's padlock by itself is not a substitute for each worker's personal control. |
| A designated authorized worker coordinates group/crews and exposure status | **DOC-CONFIRMED** | 1910.147(f)(3)(ii)(A)–(C) | Coordinator does not erase individual protection. |
| Incoming shift requires an orderly transfer that maintains continuity of protection | **DOC-CONFIRMED** | 1910.147(f)(4) | Merely changing an HMI operator login is not transfer of locks or verification. |
| Group isolation verification is required; individual workers have the right/opportunity to personally verify but are **not universally required** to perform an independent walkdown if primary authorized worker has verified | **DOC-CONFIRMED, nuance** | OSHA 2023-07-27 interpretation and 1999-11-16 interpretation | Avoid falsely claiming OSHA demands every worker personally inspect every isolator. The primary worker must verify, not merely trust a box or briefing. |
| Effective isolation must be verified again for oncoming work shift, and pressure/other hazardous stored energy that may reaccumulate must be continuously/repeatedly verified as needed | **DOC-CONFIRMED** | OSHA 1999-11-16 interpretation; 1910.147(d)(5)(ii), (d)(6) | Verification frequency/measurement method is machine- and hazard-dependent; no fabricated interval or pressure. |
| Temporary power for positioning/testing is a *controlled interruption* of LOTO, not a casual maintenance bypass | **DOC-CONFIRMED** | 1910.147(f)(1)(i)–(v) | Clear tools/materials; remove people from area; remove locks/tags per removal rules; energize/test; deenergize and reapply LOTO before resuming maintenance. No one may remain exposed merely because an operator promises slow motion. |
| Mechanical ram restraint, hydraulic pressure-zone isolation and individual exposure controls are separate from drive STO or normal CNC stop | **INFERENCE** from stored-energy definition and independent physical mechanisms | Requires selected machine hydraulic drawing, pressure zones, load paths, certified support/isolator specifications and qualified witness | **UNKNOWN** selected machine. |

## Source tension resolved: 'each worker verifies' versus 'primary verifies'
A superficial reading of the older directive's examples may suggest every authorized employee *must* independently perform a physical isolation test. The 1999 interpretation explicitly permits the primary authorized worker to verify effective isolation and requires that each participant know their right to verify. The 2023 interpretation reiterates that other authorized workers **may, but need not**, verify individually when the primary has verified; those who elect to verify must be able to do so after attaching their own personal lock and before beginning work. **Do not replace this with either extreme** ('only supervisor matters' or 'everyone must repeat every test'). Verification must be effective and shift-current; an HMI indicator is not a physical isolation oracle.

## Failure-path analysis — selected-machine facts remain unknown
**Scenario A, shift handoff:** Crew A has locked electrical feeder and hydraulic isolator. Crew B assumes Crew A's lockbox status is sufficient, enters under elevated ram, and no one confirms new shift exposure/ram restraint. Failure is in continuity + verification, not in LinuxCNC motion trajectory. **Design response (INFERENCE):** retained job lock/master box across shifts, personal locks for every incoming exposed worker, named primary, shift-specific verification, physical ram restraint and hydraulic-zone proof.

**Scenario B, pressure reaccumulates:** Hydraulic zone is depressurized once; leakage/thermal or circuit interaction may later change pressure. The existence and direction of any such mechanism is **UNKNOWN** without the circuit. **Design response:** map each hazardous volume and its gauge/bleed path, define qualified re-verification based on actual hazard, keep mechanical restraint independent.

**Scenario C, quick powered alignment:** Technician removes only one personal lock to jog while another worker remains at tooling. This violates the required people-clear/lock-removal/reapplication sequence. **Design response:** a distinct, easy-to-follow, visible TEST/POSITION work authorization with independent personnel clearance and a return-to-LOTO verification before hands-on work resumes; never allow ordinary LinuxCNC/FPGA to grant personnel-safety authority.

**Scenario D, group contractor handoff:** Contractor uses different lockbox conventions; host/operator cannot identify who is exposed. 1910.147(f)(2) requires procedure exchange; (f)(3) requires group accountability. **Design response:** explicit cross-employer handoff and personal-control roster without sharing lock keys.

## Adversarial questions for an independent evaluator
1. A primary worker verified the machine this shift. Must each electrician independently walk every valve? Explain the right to verify, without overclaiming.
2. Can a lockbox still be locked while the ram remains mechanically unsupported or a pressure pocket remains charged?
3. Is 'servo enable off' sufficient for a hydraulic line break?
4. If a powered alignment is needed, what exact sequence separates maintenance from energized positioning and back again?
5. If incoming crew B sees crew A's completed checklist, what must still be addressed before B starts work?
6. Which statements require an actual selected-machine hydraulic drawing and measured physical evidence?

## Scope and uncertainty
**SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none used. **DOC-CONFIRMED:** official OSHA indexed text with direct-open 403 limitation. **INFERENCE:** human-friendly workflow, independent restraint and pressure-zone architecture. **UNKNOWN:** jurisdictional applicability of any exception, installed devices, Y1/Y2 stop/hold, trapped volumes, pressure, PL/SIL, qualified physical tests and external evaluation. No test, hosted runner or physical experiment performed; **G0/G1 HOLD**. No personnel-exposed operation authorized.
