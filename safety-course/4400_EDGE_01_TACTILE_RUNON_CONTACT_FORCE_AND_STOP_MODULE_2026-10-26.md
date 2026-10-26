# 4400 EDGE-01 — Pressure-sensitive edges and bumpers: contact is the beginning, not the end, of stopping

**Status:** safety-course practical deepening, NOT GRADUATED, no selected-machine validation. Complements MAT-01 but **does not substitute** for the physical coverage/occupancy lesson. Prerequisites: 2520 hazard-to-safety-function, 2570 safe motion, 2590 guarding, 25F0 machine capstones.

## Two noninterchangeable protective propositions
**Floor mat:** senses sufficient load on an effective floor area, potentially helping prevent access/restart; does not inherently absorb the moving machine's collision energy.
**Safety edge / bumper:** senses contact against a moving edge and supplies finite deformation before a reference contact force is exceeded; its response may arrive **after** initial physical contact. It cannot be assumed to prevent all contact injuries, especially fingers or shearing points.

## The four distances / times to separate
1. Travel to **first contact**: no sensor actuation yet.
2. Contact travel to **sensor switching** (SB or actuation distance).
3. Additional travel during **safety output/final-element/physical stopping**, at relevant speed, load, mode and fault state.
4. Remaining allowable **deformation/run-on** before reference force or hazardous pinch is exceeded.

Schmersal STW-SL original instructions give SV = SG − SB and require stopping distance <= available run-on under relevant conditions. The same OEM explicitly states STW-SL is not for finger protection. Mayser SB original tables show actuation response time varying sharply with approach speed even for one bumper variant. **DOC-CONFIRMED manufacturer examples; no numerical value is transferred to an actual machine.**

## Adversarial cases
- A slow, heavy moving door contacts an arm; controller output goes off quickly **after** edge switching, but the edge has already compressed. Prove remaining travel/force margin rather than asserting 'relay stopped'.
- A larger bumper is substituted; electrical response and mechanical force–travel characteristics change. Previous physical validation becomes STALE.
- Two safety edges are series wired. Schmersal warns certain restricted fault-detection conditions can lower achievable PL. A controller green light does not prove individual fault coverage.
- An STW-SL edge is offered for finger protection despite explicit OEM prohibition. Reject and choose a different protective architecture.
- A press-brake backgauge or automated robot transfer edge is considered. Only a machine-specific risk assessment can determine whether contact protection is appropriate; it must not replace press-brake point-of-operation safeguards or independent Y1/Y2 gravity restraint.

## Human factors
Make guards and contact devices easy to clean, inspect and reinstall. Prevent edges being used as climbing handles, obstructed by swarf or crushed by workpieces. Reduce nuisance trips by fixing alignment/geometry, not bypassing safety. When dangerous contact cannot be tolerated, choose noncontact guarding, reduced-risk motion or physical separation rather than a softer bumper alone.

## Verification and release
Qualified desk review: exact variant/relay, contact orientation and body-part scope, force–travel/actuation envelope, system response chain, measured worst-case stop, final-element diagnostics, replacement and reset behavior, environmental damage and alternative exposure paths. Physical validation is a separate G0/G1 gate; no person should be exposed to an unvalidated hazard. Ordinary LinuxCNC/FPGA may request stops/diagnose but is not safety authority.

## Evidence
- [Schmersal original audit](../research/4400_SCHMERSAL_STW_SL_RUNON_FORCE_TRAVEL_AND_PROFILE_RATE_OEM_AUDIT_2026-10-26.md) and OEM PDF https://products.schmersal.com/media/documents/DOC_MAN_MEC_mrl-stw-sl_SEN_AIN_V2.pdf
- [Mayser original audit](../research/4400_MAYSER_BUMPER_APPROACH_SPEED_RESPONSE_AND_OVERTRAVEL_OEM_AUDIT_2026-10-26.md) and OEM PDF https://www.mayser.com/media/2662/download/PI-SB_EN.pdf?v=5
- All manufacturer examples DOC-CONFIRMED for their products; integration INFERENCE; actual machine stop/force/distance/PL/SIL UNKNOWN. No TEST-CONFIRMED or new LinuxCNC SOURCE-CONFIRMED. **G0/G1 HOLD; evaluator NOT RUN.**
