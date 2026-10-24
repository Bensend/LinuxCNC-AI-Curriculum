# 4400 — Setup mode is not a blanket lockout/tagout exception
**2026-10-24 | OSHA regulation and interpretation source audit | NOT legal clearance for a selected machine**

## Exact question
Can a builder call a task "setup," turn on slow jog or a safety PLC, and therefore skip hazardous-energy isolation? **No.** Task classification, exposure, and effective alternative protection are separate decisions.

## Primary sources and retrieval scope
- **OSHA 29 CFR 1910.147(a)(2)(ii)**, regulatory text and its note: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 . Official OSHA indexed text reviewed; direct page open returned HTTP 403 in this session.
- **OSHA January 25, 2008 interpretation**, "Use of a PLC system as an alternative measure which provides effective protection for minor servicing activities": https://www.osha.gov/laws-regs/standardinterpretations/2008-01-25 . Official indexed full answer reviewed; direct open 403.
- **OSHA October 20, 2004 interpretation**, minor servicing and lockable control-circuit switch: https://www.osha.gov/laws-regs/standardinterpretations/2004-10-20 . Official indexed excerpt reviewed; direct open 403.
- **OSHA May 4, 2007 interpretation**, testing/positioning while energized: https://www.osha.gov/laws-regs/standardinterpretations/2007-05-04 . Official indexed text reviewed; direct open 403.
- **OSHA 2002 May 17 setup interpretation**: https://www.osha.gov/laws-regs/standardinterpretations/2002-05-17 . Official indexed text reviewed; direct open 403.
- **OSHA eTool minor-servicing explanation**: https://www.osha.gov/etools/lockout-tagout/hot-topics/relationship-subpart-o/minor-servicing-exception . Official indexed text reviewed; direct open 403.

## Regulation-versus-interpretation ledger
1. **DOC-CONFIRMED (official regulatory text, indexed):** The 1910.147 minor-servicing exception is limited to work during normal production that is **routine, repetitive, integral** and protected by effective alternative measures. Merely saying "routine setup" or "slow speed" is insufficient.
2. **DOC-CONFIRMED (OSHA 2002 letter, indexed):** Setup is servicing/maintenance for this analysis; production timing alone does not exempt it. Check every exception condition.
3. **DOC-CONFIRMED (OSHA 2008 letter, indexed):** A PLC-controlled circuit is not an energy-isolating device under 1910.147(b). A PLC-based alternative can be considered for qualifying minor servicing only after a case-specific hazard analysis proves effective protection. The interpretation does not approve an unspecified PLC or any press brake.
4. **DOC-CONFIRMED (OSHA 2004 letter, indexed):** A lockable control-circuit switch may be effective alternative protection in an eligible minor-servicing scenario when design, exclusive control and **all hazardous motion/energy** are addressed. It is not equivalent to a lockable energy-isolating device for tasks requiring LOTO.
5. **DOC-CONFIRMED (OSHA 2007 letter, indexed):** Where servicing requires testing/positioning with power, 1910.147(f)(1) addresses controlled temporary energization and requires employees removed from danger before testing/positioning. Do not relabel an ordinary occupied-zone jog as the same provision.
6. **INFERENCE:** A machine builder who makes legitimate setup impossible without an awkward bypass will induce foreseeable unsafe shortcuts. Prefer engineered access, fixtures, isolation points, clear mode selection and qualified stop/hold rather than a convenient unsafe bypass.
7. **UNKNOWN:** Whether any particular OpenPressBrake task meets an exception, the adopted jurisdictional rules, actual machine safeguards, and the independent stopping/holding response. No blanket exemption is claimed.

## Task-by-task discrimination
| Work task | Initial classification question | Default safety boundary |
|---|---|---|
| Routine operator adjustment without hazard entry | Can adjustment occur with guards intact and no exposure? | Keep guards in place; no special mode merely for convenience. |
| Repeated production tool adjustment with guard open | Does it meet every minor-servicing criterion and effective alternative protection? | If not demonstrated, treat as LOTO-covered servicing; mode label is not evidence. |
| Tooling replacement requiring access under gravity-loaded ram | What stored mechanical/hydraulic energy can descend even when drive inhibited? | Independent positive restraint and appropriate energy isolation; SLS/enabling cannot replace. |
| Electrical or hydraulic maintenance | Which sources and stored energies are exposed? | Qualified point-of-work isolation and verification; no jog-mode substitution. |
| Controlled test/positioning during servicing | Can people be removed and safeguarded before temporary energization? | Apply actual task-specific 1910.147(f)(1) sequence when applicable. |
| Two workers inside cell during "setup" | Does each person have effective protection and control? | No remote mode change/restart; occupancy and group exposure must be resolved. |

## Training pitfall
A safety-rated PLC or a three-position enabling switch is a component of a risk-reduction system, not an OSHA exception certificate. "Safe setup" does not equal "LOTO not needed." A maintenance task is not made a minor production adjustment by using a mode selector. Conversely, a properly analyzed eligible minor-servicing task may use effective alternative measures; avoid teaching an absolute rule that every adjustment always requires identical LOTO.

## Evidence required to advance
Create an activity-specific exposure and hazardous-energy map, qualify the exact regulatory exception (if asserted), independently verify protection against unexpected activation and stored energy, and document residual risks and mode transitions. Machine-level physical VAL/PT and independent legal applicability remain UNKNOWN/NOT RUN. No personnel-exposed operation authorized.
