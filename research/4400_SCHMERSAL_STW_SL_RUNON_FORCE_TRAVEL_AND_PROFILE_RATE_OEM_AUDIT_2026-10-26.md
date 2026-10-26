# 4400 EDGE-01 — A safety edge only protects if its remaining deformation accommodates the stop

**Status:** original manufacturer-document inspection 2026-10-26; no physical test. **Exact source:** Schmersal STW-SL Safety Edges operating instructions, STW-SL-N-05/-06/-08, https://products.schmersal.com/media/documents/DOC_MAN_MEC_mrl-stw-sl_SEN_AIN_V2.pdf , PDF pp.2–4, §§2.3–2.5 and 3.1.

## DOC-CONFIRMED source facts
- §2.3: the STW-SL is a pressure-contact edge used at moving crushing/shearing points, requiring the specified downstream SRB303SQP-SS safety relay; the OEM says the edge is **not suitable for finger protection**. The integrated device is not automatically a universal safeguard.
- §2.4: the remaining run-on distance is **SV = SG − SB**, where SG is deformation to a specified reference force and SB is the travel needed to actuate the sensor. The manufacturer requires the machine's calculated stopping distance to be <= that run-on distance for the examined application and test conditions.
- §2.4 force/travel tables are profile-specific. The OEM's illustrative run-on distance at its first reference force is **2.71 mm for profile 05** (reference force 252 N) and **5 mm for profile 06** (252 N); profile 08 is **5.89 mm** at 252 N. These are catalog test-condition numbers, **not** an allowable person-contact distance for any machine.
- Technical data §2.4 gives response time with SRB303SQP-SS as <49 ms for 05 at test speed 90 mm/s; <50 ms for 06 at 100 mm/s; <790 ms for 08 at 8 mm/s. **These are at different actuation speeds and cannot be treated as direct equal-speed comparisons.**
- §2.5: safety classification is for the **edge plus specified relay**, up to PL d / Category 3, not the assembled machine. Manufacturer warns that series-wired components may reduce achievable PL because fault detection is restricted in some circumstances.
- §3.1: profile actuation angle, mounting, heat/chips and manipulation constraints; safety edge is not a climbing aid. The source forbids direct exposure to hot chips or heavy/sharp workpieces.

## Failure-path reasoning (INFERENCE)
Contact starts **before** electrical actuation. Then the safety-related chain and physical machine stopping require additional time/distance while contact force rises. A green relay indicator or the edge's ability to switch at one speed does not prove a person avoids harmful compression at the machine's actual worst-case velocity/load and contact geometry. A thicker rubber profile is not automatically safe; effective available run-on and force limits depend on the exact profile, mounting, direction and stopping behavior.

## Source inconsistency preserved
§2.4 refers to 'EN ISO 13586-2', whereas the manual technical-data line lists **EN ISO 13856-2**. Treat the former as a likely typographical error (**INFERENCE**), not verified normative clause text. The licensed complete standard was not reviewed. Do not copy the erroneous clause number into machine requirements.

## Required machine-specific evidence
Exact part/relay/variant, contact direction, effective force–travel curve and environmental conditions; qualified stop-time and travel proof at the worst relevant machine state; allowable force and residual risk; protection of fingers via separate measures; maintenance/cleaning and replaceability; final-element monitoring, energy isolation and restart. **No OpenPressBrake edge or Y1/Y2 stop/hold data exists in this audit.**

**Evidence ledger:** OEM statements DOC-CONFIRMED for cited products; architecture transfer INFERENCE; selected machine physical state/PL/SIL/stopping distance UNKNOWN; TEST-CONFIRMED none; LinuxCNC SOURCE-CONFIRMED new none; COMMUNITY-REPORTED none. **G0/G1 HOLD.**
