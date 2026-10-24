# 4400 — Service transition integrity: temporary reenergization, group LOTO, reentry and restart
**2026-10-24 | Regulatory-source / failure-path audit | SOURCE-READING / NOT GRADUATED**

## Question and relationship to existing work
The 4400-SET-01 module establishes that 'setup mode' does not automatically create a LOTO exception. The new unresolved issue is **transition integrity**: how does a team preserve protection while alternating between hands-in maintenance, temporary powered positioning, and reentry? This is a *procedural/physical authority contract*, not a new safety-PLC program or a way to authorize machine operation.

## Original sources / provenance
- [OSHA 29 CFR 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147), (c)(4), (d)(5)–(6), (e)(1)–(3), (f)(1), (f)(2)–(4). **DOC-CONFIRMED via official indexed text; direct open 403.** Mandatory rule within its applicable scope.
- [OSHA eTool: Testing of Machines](https://www.osha.gov/etools/lockout-tagout/tutorial/testing-machines). **DOC-CONFIRMED official indexed explanation; direct open 403.** Five-step temporary energization sequence.
- [OSHA April 22, 2005 hydraulic power-press die-setting interpretation](https://www.osha.gov/laws-regs/standardinterpretations/2005-04-22). **DOC-CONFIRMED indexed official interpretation; direct open 403.** Inching is not a substitute for isolation outside the bounded test/position phase.
- [OSHA CPL 02-01-043 September 14, 2007](https://www.osha.gov/enforcement/directives/cpl-02-01-043), §§VIII.B.6 and Appendix §§5–8. **DOC-CONFIRMED directly inspected original.** Slide-lock physical witness, personal control, integrity, and interlock versus physical isolation.
- [OSHA October 21, 2024 alternative methods interpretation](https://www.osha.gov/laws-regs/standardinterpretations/2024-10-21). **DOC-CONFIRMED indexed official response; direct open 403.** A general ANSI alternative-method definition is not a blanket OSHA exception.
- [OSHA 1910.147 Appendix A](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147AppA). **DOC-CONFIRMED indexed, nonmandatory example**; specifically notes elevated machine members, hydraulic pressure and possible need for reenergization to remove blocking. Do not convert its example into a machine-specific procedure.

## State model: document the authority at each boundary
These are **human-controlled procedure states**, not a certified state machine or safety logic:

| Phase | Human access | Physical energy state / required evidence | Prohibited inference |
|---|---|---|---|
| A. Work isolated | Only qualified authorized personnel under selected procedure | Identified isolators locked; stored energy dissipated/restrained; support engaged/verified if required; personal locks and verification current | CNC OFF means isolation |
| B. Prepare test | Everyone removed from hazard, tools/material cleared; all exposed workers accounted for | Coordinated authorization and lock removal per actual procedure; protective measures for limited test | One worker's 'all clear' without others |
| C. Limited energized test/position | No person in hazard zone; test from protected position | Temporary energy only for necessary positioning/test; safeguards remain effective | Jog/SLS means hands-in access allowed |
| D. Test complete / re-isolate | Keep personnel outside hazard until isolation reverified | Deenergize, reapply all relevant locks, control stored energy and gravity, verify anew | Returning to prior HMI state restores old LOTO |
| E. Resume isolated work | Only after each affected worker's protection is restored | Each worker confirms personal control and fresh physical witnesses; changed geometry/support position checked | Old support indication/pressure reading is still valid |
| F. Final release | No maintenance worker exposed; all tools and supports managed | Inspect work area and equipment, employee accountability, authorized lock removal, notifications, guards restored, separate deliberate machine start | Reenergization or guard closure authorizes retained CNC cycle |

## Ten adversarial failure paths (all INFERENCE from cited rules; not observed machine faults)
1. **Stale all-clear:** A technician reenters between a radio check and energization. Require a defined personnel accountability boundary before any test.
2. **Shared lock without personal control:** Supervisor removes a lock while another technician remains exposed. Apply the applicable group lockout and personal-control procedure.
3. **Tool left in die space:** Limited test energizes with an unaccounted fixture. Clear materials and tools before transition.
4. **Reapply only electrical lock:** Hydraulic stored pressure or gravity remains unrestrained. Reverify *all* hazardous energy and mechanical supports before reentry.
5. **Position changed, support stale:** A formerly engaged pin is no longer aligned after repositioning. Re-establish physical engagement and structural load path evidence.
6. **Control reset masquerades as isolation:** Safety PLC returns 'healthy'; hydraulic line remains energized. Isolators and independent physical witnesses govern service exposure.
7. **Off-shift handoff:** Outgoing authorized employee removes personal lock without a defined transfer to incoming personnel. Apply 1910.147(f)(4) continuity procedure.
8. **Outside contractor disagreement:** Plant and contractor follow different energy maps. Exchange procedures under (f)(2), reconcile all sources before work.
9. **Repeated short jog temptation:** Operators leave guards open and rely on inch mode because lock/relock is inconvenient. Redesign tooling/access and transition ergonomics without reducing protection.
10. **Queued normal cycle after final release:** LinuxCNC retained a command; restoration of energy/guard must not create automatic motion. Independent restart gating and fresh deliberate command require machine-specific validation.

## Design and verification implications
A simple **two-sided service placard** can display the current physical state (ISOLATED / TESTING / REISOLATE BEFORE ENTRY), named accountable coordinator, personnel count, and energy-control checklist. This is a human-factor aid, **not** an energy isolator or proof of safety. A normal LinuxCNC HMI may show service status and block ordinary commands but cannot own personnel-safety authority. The actual independent safety system, physical isolators, restraints and qualified personnel control exposure.

## Cross-machine transfer and exclusions
For a press brake, support the elevated Y1/Y2 beam and independently isolate relevant electrical/hydraulic sources. For a mill, consider gravity head, spindle coast and tool-changing exposure. For a lathe, consider chuck/spindle and workholding. For robots, multiple entrants and gravity axes require special attention. For plasma, thermal/arc and moving gantry hazards remain. **Do not invent one universal procedure, energy map, minor-servicing eligibility or stopping distance.**

## Selected-machine release and research limits
OpenPressBrake actual safety PLC, Y1/Y2 final elements, mechanical restraint, electrical/hydraulic isolators, lockbox and group procedure, and guard/restart witness remain **UNKNOWN**. **TEST-CONFIRMED: none; physical VAL/PT NOT RUN; G0/G1 HOLD, G3/G4 NOT AUTHORIZED.** No energized personnel-exposed demonstration is permitted. A physical procedure must be prepared and approved by qualified personnel for the exact machine and task; this paper state model is not that procedure.

## 2024 OSHA interpretation nuance — effective protection during energized testing
**DOC-CONFIRMED official indexed October 21, 2024 letter, Question 1:** OSHA reiterates the five ordered steps and says effective protection must exist during all phases of testing/positioning, mentioning guarding techniques where removing employees from a danger area is not possible. The same response explicitly lists removing employees from hazardous areas before energization. **Interpretation:** do not treat the parenthetical as a blanket exception to the sequence, or as permission for a person to stand under a gravity-loaded ram. A selected task with claimed alternative protection needs qualified case-specific regulatory and physical review; absent that proof, the curriculum requires people outside the danger zone. **Question 2:** OSHA expressly answers **No** to automatically recognizing the ANSI B11.0-2020 / ANSI Z244.1-2016 definition of "Alternative Methods" as compliance with 1910.147. A consensus-standard design aid does not replace an applicable regulation. These are official indexed source statements; direct original page opening returned 403.
