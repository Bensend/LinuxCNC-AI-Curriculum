# 4400-BLOCK-01 — Mechanical ram supports, powered-stroke isolation and service-access engineering
**Learner-facing 4000 safety module; 2026-10-25. Status: SOURCE/DOCUMENTARY STUDY, NON-GRADUATED.** Prerequisites: 2520 hazard/SRS, 2530 E-stop, 2540 final elements, 2580 hydraulic energy, 2590 guarding, 4400-HOLD-01 and 4400-EDM-01. Primary original evidence: [Cincinnati/OSHA source audit](../research/4400_CINCINNATI_OSHA_RAM_BLOCK_STATIC_VS_POWERED_STROKE_AND_PRESS_BRAKE_SCOPE_AUDIT_2026-10-25.md).

## Learning objective
Given an unfamiliar press-brake maintenance proposal, separate **static ram deadweight support**, **prevention of powered stroke**, **trapped hydraulic pressure**, **tooling/structure**, **personnel access**, **rescue** and **deliberate restart** into independent engineering propositions. Reject a proposal that proves only an indicator, only a controller command, or only a support's nameplate.

## Mechanism, not a parts list
```text
NORMAL CONTROL                  SAFETY-RELATED CONTROL               PHYSICAL ENERGY/RESTRAINT
LinuxCNC/FPGA, servo PID  ---> diagnostic requests only          [independent energy isolators]
HMI "ram safe" / jog          separate safety input -> logic ->    [qualified hydraulic final elements]
not personnel authority       monitored outputs + EDM             [positively engaged rated supports]
                              separate fresh reset               [actual ram/bed/tool load path]
                                                                      |
                                                         independent physical safe-state witness
```
No arrow from LinuxCNC or its ordinary FPGA is sufficient to **authorize personnel access**. An independent safety output being OFF is not proof of a mechanically stable beam. A support switch being ON is not proof that the support is correctly rated, seated or effective for the actual loading.

## Machine/lifecycle map
| Task | Exposure | Minimum distinct propositions |
|---|---|---|
| Normal bending | hands near tooling; rising sheet; rear/side access | qualified point-of-operation guarding and independent protective stop; supports generally not engaged in production |
| Tool setup/change | hands between tools; falling punch; gravity-loaded beam | work-specific LOTO, independent beam support, tool retention, support placement and safe access |
| Service under raised ram | whole-body crush zone | qualified load path, all-source isolation, stored-pressure control, independent verification and reaccumulation monitoring |
| Temporary positioning | movement needed to place support | clear people/tools, authorized temporary reenergization, controlled positioning, **re-isolation and re-verification** before access |
| Entrapment rescue | person already in danger zone | qualified rescue plan, supported load, independent energy assessment; ordinary rearm not a rescue method |
| Restart after service | residual block/lock, retained jog, guards restored | remove supports only in an authorized safe sequence, independent rearm, **new** ordinary motion request, clear people |

## Standards scope and the 10%-capacity trap
**DOC-CONFIRMED, limited:** Cincinnati BASEFORM 90–175 Section 9 EM-558 (N-07-14) states its own ram supports must withstand at least 10% of its machine capacity without damaging bed or ram. The manual's instruction is **not** a general 10%-of-tonnage rule, not a powered-stroke rating, not a load calculation for another machine and not a replacement for exact OEM instructions.

**DOC-CONFIRMED:** OSHA 1910.217(a)(5) excludes press brakes from its mechanical-power-press requirements. Thus §1910.217(d)(9)(iv) is not a universal press-brake-specific mandate, even though mechanical blocking remains a sound hazard-control consideration and 1910.147 applies when its servicing/exposure criteria are met. OSHA's 2007 slide-lock directive emphasizes that deadweight-rated supports generally are **not** designed to resist powered stroke. OSHA's 2005/2006 hydraulic-power-press letters reject two-hand/inch controls as replacements for hazardous-energy isolation.

## A six-proposition acceptance argument
- **BLOCK-PHY-1 / static:** documented ram/tool/accessory load and actual center-of-gravity/eccentricity, approved support count/placement and bearing surface, buckling/slip/overturning/load-path acceptance. No guessed tonnage percentage.
- **BLOCK-PHY-2 / powered:** power/pressure supply isolation and independent final-element behavior prevent powered force reaching a support unless the support has separately been designed and validated for that load case. A rated static support cannot be presumed powered-load safe.
- **BLOCK-PHY-3 / Y1/Y2:** actual independent cylinder and beam geometry, uneven load, potential twisting and lateral forces addressed. Two identical blocks can still share a weak bed or be placed badly.
- **BLOCK-PHY-4 / fluid:** every pressure zone that can move the ram or injure during service identified; pilot, relief, accumulator and trapped cylinder-side energy accounted for. Upstream gauge zero is insufficient.
- **BLOCK-PHY-5 / access:** supports can be installed, inspected, retained and removed without placing a person in the danger zone or routinely defeating safeguards. Correct installation is the **easy** path.
- **BLOCK-PHY-6 / restart:** physical supports and locks remain controlled through service, rescue, handoff and restart; reset cannot directly command motion; stale controller requests are cleared and a new deliberate start is required.

Each proposition needs **separate** evidence. If any central proposition is UNKNOWN, do not approve people-exposed maintenance. This is a design/commissioning decision, not a blanket claim that every machine must use the same number of blocks.

## Fault and change review
| Fault / change | Why a green indicator can mislead | Correct evidence owner |
|---|---|---|
| Support inserted on a tool rather than approved beam/bed point | support switch sees insertion, tool slips or fractures | mechanical designer / qualified witness |
| One-side support on two-cylinder beam | one support contact, opposite end drops or twists | structural/load engineer |
| New heavy upper tooling | old support static load calculation stale | tool/machine engineer, CHG record |
| Hydraulic relief or pilot change | new load path may release pressure despite OFF coil | hydraulic designer, PHY/HOLD |
| Support interlock shorted/defeated | PLC reports support installed; physical support absent | independent safety designer and physical witness |
| Restored power while worker present | control reset or retained start becomes hazardous | safety control designer + independent rearm verification |
| Emergency lowering screw left open | hydraulic hold invalid even if support still present | qualified rescue/service restoration witness |
| Supports make service impossible | predictable bypass/removal incentive | operator/maintainer human-factors redesign |

## No-energy documentary gate (NOT RUN)
1. Identify machine and task; classify people-exposure zone and applicable machine standard/edition.
2. Obtain as-built beam/cylinder/tooling load path and signed support engineering basis.
3. Obtain exact support/block/slide-lock model, static/dynamic load limits and permitted installation points.
4. Trace all powered motion and stored energy sources independently of LinuxCNC/FPGA.
5. Show physical isolators, personal locks and reaccumulation verification plan.
6. Trace each hydraulic chamber/pilot/return/accumulator and independent load-hold function.
7. Prove how support is inserted/removed without entering an unprotected danger zone.
8. Review asymmetric Y1/Y2 and shared structural/common-cause failures.
9. Review rescue with no power, no hydraulic command and person entrapped.
10. Review operator/maintainer usability and bypass incentive; redesign inconvenient safeguards.
11. Trace stop -> support -> isolation -> service -> clear -> rearm -> **fresh** motion.
12. Mark each gate DOCUMENTARY PASS/HOLD/UNKNOWN; physical VAL/PT remains NOT RUN until independently qualified.

**No bench or machine fault injection is specified here.** A qualified physical plan requires actual machine documents, load calculations, independent test instruments, exclusion barriers and accepted stop/hold criteria.

## Adversarial learner check (unscored)
A retrofit adds two inexpensive steel posts and a PLC input labelled `RAM_SUPPORTS_OK`. It stops the hydraulic pump when either post is present and displays green when both are sensed. The supplier quotes Cincinnati's "10% of machine capacity" line and OSHA 1910.217(d)(9)(iv). Is a technician allowed between dies?

**Expected reasoning method, not a hidden answer:** classify each citation's scope; distinguish posts' static rating from powered stroke, actual Y1/Y2 load, structure, hydraulic trapped energy and LOTO; ask for physical evidence rather than assuming the PLC input is protective; identify how service access and fresh rearm are managed. Do not assign a numerical load or safety rating.

## Graduation/transfer gate
Learner can independently diagnose a **new** machine-specific scenario, cite the exact OEM scope, preserve six separate physical propositions, and correctly hold release when evidence is missing. Independent information-separated evaluator and selected-machine physical validation are **NOT RUN**. **No TEST-CONFIRMED or selected-machine safe-to-operate claim.**

## Practical minimum
When independent stop/hold/isolation, guards, physical support and restart are not demonstrated, **do not operate with people exposed to the hazard**. Any future experimental work must be isolated/remote with people outside the danger zone and residual risks explicitly managed by qualified personnel. No normal LinuxCNC/FPGA authority substitution.

## Second-source design challenge: OSHA slide-lock appendix **2.0** versus Cincinnati support-block **10%**
The [2007 OSHA CPL 02-01-043 appendix](https://www.osha.gov/enforcement/directives/cpl-02-01-043) describes a **slide-lock** performance guideline: maximum anticipated load includes slide/tool/accessory deadweight and reasonably foreseeable settling inertia; a slide-lock system is secured to the main structure and has a **minimum design safety factor of 2.0 relative to that anticipated load** when the other guideline assumptions are met. It also describes a personally securable lock, control-reliable interlock/monitoring, two independent visual engagement indications, and initial/periodic tests including after modification or significant dynamic exposure. These are **DOC-CONFIRMED original indexed** guideline statements, **not** an inspected OpenPressBrake design or an automatic universal press-brake legal requirement.

**Do not conflate denominators:** Cincinnati's **10% of forming capacity** is a different, product-specific support-block criterion. The OSHA appendix **2.0 × maximum anticipated slide-lock load** uses deadweight/settling load, not nominal press tonnage. Neither proves a support survives a powered stroke. Learner must identify the device family and load definition before applying any number; **no machine-specific rating is computed here**. A green engagement indicator is still not an independent structural witness, and a personally lockable slide lock does not eliminate other LOTO energy sources.
