# 4400-SCAN-02 — Safety scanner geometry, reference contour, monitoring-case switching and response-time proof
**2026-10-25 | SICK S300 8010948/ZD76/2025-08-19 | DOC-CONFIRMED exact OEM | NON-GRADUATED**

## Independent source
Original SICK S300 operating instructions, 19 August 2025:
https://www.sick.com/media/docs/3/13/613/operating_instructions_s300_safety_laser_scanner_en_im0017613.pdf
Directly inspected printed pages **31–35, 38–43, 90, 94–96**. Product-specific numbers below are **not** selected-machine values.

## Four distinct physical/integration failure mechanisms
1. **Undetected near range and unsecured regions** — printed pp.31–34 §§4.3.2–4.3.2.1: installation can create areas scanner cannot detect; OEM suggests deflector plates, undercuts, integrated mounting or frames. S300 near range is **5 cm** ahead of the optics cover and needs exclusion or supplementary close-range protection. The exact 5 cm is S300-specific, not a universal scanner tolerance. **DOC-CONFIRMED**.
2. **Field clear does not mean person absent** — printed pp.88–90 §7.10: if a person can move from field into an unobserved hazard, restart interlock is required. **DOC-CONFIRMED**. **INFERENCE:** whole-body entry sensing and continuing occupancy sensing are different safety functions. A single entrance beam cannot assert that a hidden person left the cell.
3. **Monitoring-case selection has a temporal hazard** — printed pp.34–35 §4.3.3: switching late may activate the correct field only *after* a person has entered it. OEM requires switching advance for input delays, EFI input transport and external OSSD paths. The manual describes an additional **0.5 × slowest basic response time** for certain EFI-input conditions and **20 ms** for external OSSDs; these are **specified configuration examples**, not generic LinuxCNC or press-brake delays. **DOC-CONFIRMED**. No timing calculation is made for an unknown machine.
4. **Suggested fields and reference contour do not validate themselves** — printed pp.94–96 §§7.12.3–7.12.4: the CDS-suggested field is **not** a substitute for safety-distance calculation; tolerance is subtracted from the observed contour. For vertical applications, contour-as-reference monitors displacement/altered surroundings; too-small reference segments can fail to detect changes, and warning field 2 conflicts with contour-as-reference. **DOC-CONFIRMED**.

## Safety-distance boundary
Printed pp.38–43: the OEM distance analysis includes **actual machine stopping time**, sensor/controller response, mounting height, reaching over, measurement uncertainty, reflection and case-switch timing. Stopping time must come from machine documentation or measurement. The printed ISO 13855:2010 examples are **not** an approved current machine calculation, and this audit does not establish current standard edition applicability. An S300 vertical access-protection application is whole-body access detection; the manual expressly says the S300's finest **30 mm** resolution is unsuitable for applications requiring finger detection (printed p.44). Do not substitute a perimeter/access scanner for press-brake point-of-operation hand/finger protection.

## Practical safety design and human factors
Prefer physically captive edge barriers/deflectors that make uncovered spaces inaccessible; secure scanner mounts with visible witness marks; protect from accidental impacts; avoid awkward reset stations that encourage defeat; place qualified reset outside danger zone with full view. If full view cannot be obtained, redesign access/occupancy safeguards and the restart function rather than relying on a camera/HMI green icon as a safety-rated presence proof. Require documented field/contour maps and a clear change trigger for tools, stock, guards, sensor mounts, software configuration, and stopping behavior.

## Failure analysis / evidence to collect
| Scenario | What looks normal | Hidden hazard | Required evidence |
|---|---|---|---|
| Person crosses field and stands beyond | Field-clear status | Unobserved occupancy | Physical coverage/anti-restart design |
| Sensor recessed behind panel | Green OSSD | Near-range shadow | As-built geometry and exclusion barrier |
| Tooling added | Previous field map loaded | New occlusion or reach-over | Revised geometry and physical review |
| Case switched by ordinary controller late | New field selected eventually | Gap before hazard | Rated switching timing analysis |
| Vertical scanner shifts on bracket | Field still seems present | Moved aperture | OEM contour reference configuration and commissioning witness |
| CDS suggested field accepted | No configuration warning | Stale distance | Independent stop/response/geometry calculation |

## Claim ledger
**DOC-CONFIRMED:** specific S300 pages above. **SOURCE-CONFIRMED LinuxCNC:** none new. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **INFERENCE:** physical edge guards and independent occupancy/restart reduce shortcut incentives; ordinary FPGA is not personnel-safety authority. **UNKNOWN:** installed OpenPressBrake sensor, geometry, response/stopping time, pressure isolation, gravity holding, safety performance and independent evaluator. **G0/G1 HOLD**, no physical testing or personnel-exposed operation.
