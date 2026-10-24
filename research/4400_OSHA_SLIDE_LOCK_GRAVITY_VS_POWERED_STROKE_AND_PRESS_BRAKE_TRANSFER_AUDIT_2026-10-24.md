# 4400 — OSHA slide-lock evidence: gravity restraint is not powered-stroke protection
**2026-10-24 | Original primary regulatory/directive source audit | SOURCE-READING / NOT MACHINE VALIDATION**

## Engineering question
What does a positively engaged mechanical slide lock actually protect, and what remains hazardous if a press is inadvertently energized? How can a press-brake retrofit use the method without borrowing inapplicable mechanical-power-press requirements?

## Primary source ledger and access quality
- **DOC-CONFIRMED, directly inspected original OSHA directive**: [CPL 02-01-043, September 14, 2007](https://www.osha.gov/enforcement/directives/cpl-02-01-043), §§ VII–VIII and Appendix §§ 3–8. This is enforcement policy and a performance-guideline appendix, not an OEM-specific certification.
- **DOC-CONFIRMED, official regulatory text indexed**: [29 CFR 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147), especially (b), (c)(4), (d)(5)–(6), (f)(1), (f)(3). Direct opening of the OSHA regulation was not available in the web reader; the official indexed text was examined.
- **DOC-CONFIRMED, official indexed interpretation only**: [OSHA April 22, 2005 hydraulic power-press die setting](https://www.osha.gov/laws-regs/standardinterpretations/2005-04-22), on temporary reenergization, gravity, leaks and die-release hazards. Direct page opening returned 403.
- **DOC-CONFIRMED, official indexed interpretation only**: [OSHA December 28, 2006 die setting](https://www.osha.gov/laws-regs/standardinterpretations/2006-12-28), on control circuits, physical isolation and slide drift. Direct page opening returned 403.
- **DOC-CONFIRMED, official indexed**: [OSHA 1910.217](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217), paragraph (a)(5) expressly excludes press brakes; [1910.212](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212) remains relevant to point-of-operation guarding. Do not transfer 1910.217(d)(9)(iv) as a press-brake-specific mandate.
- **DOC-CONFIRMED, OSHA eTool**: [temporary removal for testing/positioning](https://www.osha.gov/etools/lockout-tagout/tutorial/testing-machines), describes the (f)(1) sequence.

## Mechanisms and precise limits
1. **Gravity versus dynamic force — directly confirmed.** Directive §VII and Appendix §§1, 3.2, 4.1 distinguish gravity/deadweight and foreseeable settling inertia from a powered stroke. Slide locks/blocks usually address gravity, **not powered-stroke force**. A lock capable of holding the stationary ram is not automatically capable of resisting a hydraulically driven ram. Independently isolate or otherwise prevent dynamic hazardous energy under the task-specific energy-control requirements.
2. **A physical mechanical lock is not a software bit.** OSHA §1910.147(b) recognizes a physical block as an energy-isolating device when it prevents transmission/release of energy. A LinuxCNC stop, FPGA inhibit, safety PLC output image, valve command or 'slide locked' HMI icon is not the physical mechanism. The slide-lock interlock complements, rather than substitutes for, energy isolation where LOTO applies.
3. **Structural load path must be qualified.** Appendix §§3.2, 4.1: consider slide, upper tooling, attachments and foreseeable settling effects, mounting to press main structure, and supplier-rated maximum use. The appendix states **2.0 minimum safety factor** for its specific slide-lock performance-guideline system, conditioned on the complete guideline; this is NOT a generic press-brake design number or permission to rate an unknown bracket. Actual OpenPressBrake forces and design margins remain UNKNOWN.
4. **Engagement witness is separate from strength.** Directive §VIII.B.6 and Appendix §5 require redundant visual indication of engagement in the described guideline; one lamp/limit switch can be misleading. Visual engagement cannot by itself prove pin, frame, weld, fastener or bearing integrity. Inspect and qualify the load path, maintenance and change history.
5. **Personal control matters.** Appendix §6 and 1910.147(f)(3) require exposed workers to retain appropriate personal lockout control when LOTO applies. One supervisor's lock, a key-switch or a 'service' mode label cannot be silently treated as every worker's protection.
6. **Temporary positioning is a bounded exception, not general energized maintenance.** Under 1910.147(f)(1), clear tools/materials, remove people from machine area, remove locks using the applicable procedure, energize for testing/positioning, then deenergize, reapply isolation and verify before resuming hands-in work. The OSHA 2005 letter explicitly rejects using inch/two-hand mode as the default substitute for isolation throughout die-setting. A two-hand button may constrain deliberate commanded motion but does not restrain a ram after hose/cylinder failure.
7. **Mechanical integrity is a lifecycle function.** Appendix §§3.5, 8 require initial verification, periodic inspection/testing per supplier, and renewed testing after modification or significant dynamic-force exposure. A pin that once held is not permanently proven; wear, corrosion, bending, altered tooling mass, and anchor damage require review.
8. **Human factors.** Heavy, hidden, inconvenient, easily lost blocks invite omission. A permanently stored, captive, visibly engageable, labeled restraint with safe access, a simple personal-lock path and clear inspection cues reduces foreseeable defeat. Ergonomic improvement must not weaken rated capacity, physical restraint or independent stop.

## Cross-machine applicability gate
| Machine | Transferable principle | Not transferable without design evidence |
|---|---|---|
| Hydraulic press brake (OpenPressBrake target) | Gravity ram/tooling restraint plus independent hydraulic/electrical isolation, service transition and physical witness | 1910.217 mechanical-press mandate, a 2.0 factor as automatic approval, chosen pin diameter, ram load, engagement geometry, hydraulic safe-state truth table |
| Mechanical power press | 2007 directive directly discusses slide-lock alternative to 1910.217 blocks under defined enforcement conditions | Any claim that its appendix proves a particular installation |
| Vertical mill/lathe | Physical support of suspended head/chuck/fixture as applicable; LOTO for service | Press-specific slide-lock geometry or performance factor |
| Robot/gantry | Gravity axis mechanical restraint, individual exposure and restart separation | 'STO' or software disable as proof suspended axis cannot fall |
| Plasma/automated cell | Service isolation and guarding despite normal cycle stop | Treating every axis as a gravity-loaded ram |

## Adversarial failure-path questions
- A pin limit switch is ON but a pin has sheared: which independent physical observation falsifies the green lamp?
- A support is designed for deadweight, but a service technician leaves the pump energized: what prevents a powered ram stroke from exceeding the support?
- A second technician enters while the first holds the only lock: who controls reenergization?
- A block is removed for 'just one jog': what precise clear-zone, re-isolate and reverify sequence prevents hands-in work with energy restored?
- The ram tooling is replaced with heavier tooling: which load, mounting and mechanical-integrity assumptions become STALE?

## Open selected-machine facts / disposition
**UNKNOWN**: actual OpenPressBrake mechanical support type and rated load; load path and fasteners; independently verified engagement; hydraulic pressure zones and accumulator; Y1/Y2 stopping/holding; personal isolation and test-positioning procedures; inspection interval; guard/restart behavior. **TEST-CONFIRMED: none**. No actual machine operation, load test or exposure authorized. When physical proof is missing, personnel-exposed operation is HOLD; any experiment must be isolated/remote with personnel outside the hazard zone and residual risk recorded. No invented capacity, test force, timing, pressure, PL/SIL or stopping distance.

## Study-method finding
Record four separate propositions for each support: **(a) indicated engaged; (b) physically engaged; (c) structurally capable for the justified load case; (d) hazardous powered energy separately isolated**. None follows automatically from another. Treat missing evidence as UNKNOWN, not a PASS.

## Original-directive internal cross-reference anomaly
**DOC-CONFIRMED (direct original text):** Appendix §3.5.1 says initial testing should hold the maximum anticipated load "as defined in section 3.1"; but Appendix §3.1 is **Control Reliability**, while **§3.2** defines **Maximum Anticipated Load**. This appears to be an internal section-number error in the published directive. Preserve the verbatim location and reconcile meaning using the immediately adjacent definitions; do **not** silently rewrite the source or derive a test load from the mistaken reference. Any selected-machine acceptance criterion still requires qualified OEM/design evidence. This is a useful fresh-learner test of source-reading fidelity, not a reason to discard the rest of the directive.
