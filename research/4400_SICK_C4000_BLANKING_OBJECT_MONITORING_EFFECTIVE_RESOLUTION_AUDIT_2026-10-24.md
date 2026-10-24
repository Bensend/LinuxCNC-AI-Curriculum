# 4400 — Light-curtain blanking: object monitoring, effective resolution and the false-clear trap
**2026-10-24 | Original manufacturer manual inspected | SOURCE-READING / PAPER ONLY / NOT MACHINE VALIDATION**

## Engineering question
Can a retrofit preserve a light curtain's green/OSSD-ready indication while changing its actual ability to detect a hand or reach-through? **Yes, in a manufacturer-documented configurable product family.** The relevant proposition is not simply whether the OSSD is green; it is *which locations and object sizes are still detected under the exact active configuration, and what other barriers close the remaining openings*. Do not confuse fixed blanking, floating blanking, reduced resolution, muting, bypass, or a press-brake point-of-operation laser. Their semantics and scope differ.

## Primary source and provenance
Original **SICK C4000 Standard/Advanced operating instructions, 8009861/YT64/2016-02-25**, original 120-page PDF opened and section text inspected: §§2.2, 4.1, 4.8–4.11, 5.1, 7.3, 8.1. Official manufacturer PDF:
https://www.sick.com/media/docs/5/45/945/operating_instructions_c4000_standard_and_c4000_advanced_safety_light_curtains_en_im0011945.pdf

**DOC-CONFIRMED, product/edition limited:** C4000 *Advanced*, not every C4000 Standard, offers configurable blanking (§4.8 p.26). This 2016 edition does not establish the behavior of a current deTec4, Rockwell 450L, a different C4000 revision or an installed OpenPressBrake sensor. Verify type plate and actual revision before transferring any feature or numerical example.

## Causal signal and protection matrix
| Feature in this OEM edition | Documented behavior | Critical unsafe assumption to reject |
|---|---|---|
| Fixed blanking (§4.8.1 pp.28–29) | Permanently positioned obstruction occupies a configured region; **its removal demands a stop**. That region is no longer protective field. Optional position tolerance and size tolerance have different consequences. | “Object-present monitoring proves there is no gap beside the object.” The manual calls for separate guarding of openings. |
| Floating blanking with **complete** object monitoring (§4.8.2 p.31) | Moving object must cover configured area within selected tolerance; otherwise sensor changes to red. | “A moving object can be replaced with any size/shape without review.” |
| Floating blanking with **partial** object monitoring (§4.8.2 p.31) | The area **does not need to be covered by an object**. A cleared aperture can therefore coexist with the permitted protective status under that configuration. | “Green proves the blanked object is still physically in place.” |
| Fixed blanking with increased size tolerance (§4.8.1 p.29) | A bounded material feed region on one side can enter the field; special restrictions and separate risk analysis apply. | “A conveyor slot automatically detects a reaching hand.” |
| Reduced resolution (§4.9 p.36) | Selected beam interruptions are tolerated; effective resolution increases. OEM example: **14 mm physical, one-beam reduction -> 22 mm effective**. | “The 14 mm nameplate alone is the tested minimum object sensitivity.” |
| Size tolerance with floating blanking (§4.8.3 p.32) | At the edges of a blanked area, effective resolution can degrade; OEM example **14 mm physical, -2 beams -> 22 mm effective**. | “Fixed and floating tolerances are identical or preserve the original separation distance.” |
| Restart interlock (§4.1 pp.19–21) | Where a person can stand behind the curtain, restart-interlock allocation matters. Device reset and machine restart are separate when both interlocks are used. | “Field clear / OSSD on authorizes a new cycle.” |

**Important precision:** In this SICK edition, *fixed blanking positional tolerance* is explicitly said **not** to change effective resolution, whereas *size tolerance* can change edge resolution. Do not generalize that every tolerance always changes the same quantity. Some blanking/reduced-resolution combinations are forbidden (§4.11 p.38); verify exact allowed combination.

## Physical hole and human factors
The OEM states that blanking creates a **hole in the protective field**, which must be mechanically protected or included in minimum-distance design (§4.8 p.27). A fixture, roller, support, pallet, bent flange or reconfigured die can leave a finger-accessible space *beside* the intended object. A green output can then be logically correct for the programmed field yet inadequate for the hazard. A removable bracket/fixture can make the gap larger. Easy-to-use, quick-release but positively retained hard guards around required slots, protected cable routing, and an accessible configuration label are practical design improvements; do not force operators to choose between normal work and nuisance trips.

## Inspection and change control
SICK §7.3.3 p.64 requires daily checking with the **test rod for the effective resolution**, along the entire hazardous area and each protected sub-area when blanking divides the field. The OEM example uses a 22 mm rod for a 14 mm physical curtain operated at 22 mm effective resolution. That is a **product-specific example**, not an OpenPressBrake acceptance rod. Configuration changes require qualified re-check (§2.4 p.11, §7.3.2 p.63), and cleaning requires checking alignment and reach-around (§9 p.66).

**CHG trigger:** fixture/tool/die/stock geometry, blanking map, object-monitoring mode, tolerance, reduced-resolution setting, protective-field location, scanner/curtain replacement, cascading/receiver configuration, hard guard, or changed machine stopping behavior. Preserve old evidence as STALE for affected zones; do not declare it invalid for unrelated unaffected functions without reviewing dependency.

## Adversarial counterexamples (INFERENCE; NOT PHYSICAL TESTS)
1. Fixture removed from **monitored fixed** blanking: sensor should withdraw permission per this OEM; still verify downstream physical stop.
2. Fixture removed from **partial-monitoring floating** region: permission **may remain** because occupancy is not required; separate hard guard is the real protection proposition.
3. Nominal 14 mm nameplate, reduced resolution configured: wrong test rod and stale separation-distance calculation can falsely pass a field check.
4. Stock flange rises beside the blanked object: a hand can approach through the new slot without interrupting remaining beams.
5. Correct test rod interrupts one sub-area but not another: a single “red” demonstration does not prove complete coverage.
6. Safety PLC receives OSSD correctly, yet ram coasts or falls: optical detection is not physical stop/hold proof.
7. Object monitoring demands red when object absent, but machine resets and starts on field return: safe restart still fails.

## Evidence and limits
- **DOC-CONFIRMED:** the exact 2016 SICK manual statements above; original PDF inspected.
- **INFERENCE:** the generic fault chains and proposed design-for-use changes.
- **UNKNOWN:** actual selected OpenPressBrake optical hardware, software configuration, zone geometry, effective resolution, test rod, safety PLC mapping, stop/hold/restart, PL/SIL and measured stopping distance.
- **TEST-CONFIRMED:** NONE. **SOURCE-CONFIRMED LinuxCNC implementation:** none claimed; normal LinuxCNC/FPGA may display status but does not own personnel-safety permission.
- No simulation is justified: this question is settled for the *manual's product behavior* by authoritative evidence; selected geometry and actual stopping are physical-validation questions, not synthetic-compute questions.

## Non-negotiable physical gate
No exposed-person operation based on this document. Obtain as-built optical configuration and actual physical coverage, independent safety-rated path to final elements, machine-specific stopping/holding, rear/side access and deliberate restart. If those cannot establish the minimum safe-to-operate threshold, keep personnel outside the danger zone; experimental work, if any, must be isolated/remote with residual risks identified.
