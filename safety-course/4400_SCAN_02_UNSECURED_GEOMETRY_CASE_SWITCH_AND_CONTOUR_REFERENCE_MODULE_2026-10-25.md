# 4400-SCAN-02 — Scanner coverage is physical geometry plus time, not a green indicator
**4000 safety engineering | 2026-10-25 | NON-GRADUATED | no machine release**

## Outcome
Explain why **entry detection**, **continuous occupancy**, **hazard-point finger protection**, **contour displacement detection**, and **timely field selection** are separate functions. Read [original SICK S300 2025 audit](../research/4400_SICK_S300_2025_UNSECURED_NEAR_FIELD_CONTOUR_AND_MONITOR_CASE_TIMING_AUDIT_2026-10-25.md) after 2590 and SCAN-01.

## Source-grounded discriminators
- **Near range:** S300 §4.3.2.1 defines a **5 cm** near region needing exclusion or supplementary protection. Other unobserved areas require physical deflectors, undercuts, integration or framing. The number is not transferable to other models. **DOC-CONFIRMED**.
- **Monitoring-case switching:** §4.3.3 warns that a person may be inside the newly activated field before late selection. Additional input/EFI/OSSD delays must be accounted for; the exact OEM examples are not a substitute for machine-specific calculations. **DOC-CONFIRMED**.
- **Vertical field geometry:** §§4.3.5 and 7.12.4 require contour-as-reference in the specified vertical application. A reference segment smaller than configured resolution can miss displacement; field auto-suggestion is not a safety-distance calculation. **DOC-CONFIRMED**.
- **Point-of-operation mismatch:** §4.3.6 says S300 minimum 30 mm resolution is unsuitable when finger detection is required. A whole-body entry scanner must not be presented as press-brake finger protection. **DOC-CONFIRMED**.
- **Stopping distance:** the OEM analysis requires actual machine stopping time, scanner/controller response, mounting, reflection/reach supplements and timing. Without the as-built geometry and measured/documented stopping time, a number is **UNKNOWN**.

## Two adversarial paths
**Hidden person:** field interrupted on entry -> person steps into blind area -> field clear -> permissive appears -> restart risk. Protect with independent rated restart interlock, full-view reset and/or appropriately validated continued-presence detection plus physical access controls. **Do not claim that reset proves the zone empty.**

**Late field selection:** normal controller commands larger field only as axis approaches hazard -> input/EFI/OSSD propagation -> person enters region before protective field is active. Define safety-rated monitoring-case authority and worst-case timing in the safety requirements. Do not invent a delay budget for OpenPressBrake.

## Practical build pattern
Choose easy-to-install captive edge barriers, protected mounts, accessible optics cleaning, clearly marked scan-plane and field boundaries, simple outside-zone reset location with visibility, and change-control triggers for tools, fixtures, guard positions and field sets. Reject a configuration that works only when operators ignore nuisance stops or use a bypass.

## Evidence/transfer
**DOC-CONFIRMED** exact S300 2025 pp.31–35/38–44/94–96. **INFERENCE** architecture and human factors. **SOURCE-CONFIRMED new LinuxCNC:** none; **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none; **UNKNOWN** OpenPressBrake installed scanner, reach/occlusion map, stopping time, Y1/Y2 gravity hold, hydraulic isolation, guard arrangement, PL/SIL and independent score. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD**. Public scenarios are not scored. This module cannot authorize exposed operation.
