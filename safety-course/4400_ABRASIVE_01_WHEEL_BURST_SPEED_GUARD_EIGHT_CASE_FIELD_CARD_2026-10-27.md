# 4400-ABRASIVE-01 — Wheel-burst physical containment and speed-authority field card

**Status:** NON-GRADUATED; eight PUBLIC PAPER cases **UNSCORED**, ten documentary gates **NOT RUN**. Read the [HSE/Norton/OSHA source audit](../research/4400_ABRASIVE_01_HSE_NORTON_OSHA_WHEEL_BURST_OVERSPEED_GUARD_COMPATIBILITY_AUDIT_2026-10-27.md). Applies only to actual abrasive-wheel equipment; do not assume a grinding wheel is fitted to OpenPressBrake.

## Five distinct questions every builder must answer

1. **Wheel:** Is this exact wheel type, bond, condition and marked maximum speed appropriate for the operation?
2. **Spindle:** What is the **actual** maximum free-running speed, including all control modes, drive changes and failure states? An `S` command or HMI limit is ordinary control evidence only.
3. **Mounting:** Are arbor, flanges, blotters, fit, fasteners and assembly procedure correct for this wheel and machine? A disc that fits is not necessarily compatible.
4. **Containment:** Does the correct guard/enclosure protect against **fragment impact** as well as accidental contact? A splash shield or interlocked door signal is not itself a fragment-impact rating.
5. **People and service:** Can operators mount, inspect, adjust, clean and restore the guard conveniently, without bypassing it? Does restart require a separate deliberate action after verified safe assembly?

## Eight unscored technician scenarios

For each, identify `BND/HAZ/SF/PHY/AUTH/DEP/HF/VAL/CHG/UNK`, name the unsafe inference, first safe documentary action, and what physical evidence would falsify your hypothesis.

- **ABR-P01 — Green speed display.** CNC shows 3,000 rpm command, but the wheel's marked maximum is unreadable. What may and may not be inferred? No operation until qualified.
- **ABR-P02 — Guard swap.** A shop substitutes a Type 27 grinder guard when mounting a cup wheel because the replacement clears the work. Explain wheel-type geometry and fragment-containment risk.
- **ABR-P03 — Better visibility.** Technician cuts an opening in a wheel guard to see the grinding point. Propose a practical redesign that preserves visibility and qualified containment rather than accepting removal.
- **ABR-P04 — One missing bolt.** Guard-position switch indicates closed, but a fastening screw is missing after maintenance. Explain why the green signal cannot prove fragment retention.
- **ABR-P05 — Wheel wear.** Operator increases commanded RPM as the wheel wears. Which actual wheel/machine speed and surface-speed restrictions require product-specific review?
- **ABR-P06 — Splash barrier.** An enclosure stops coolant but has never been assessed for wheel fragments. Separate ordinary splash protection, guarding, machine stop and personnel safety.
- **ABR-P07 — No ring.** An organic-bond wheel gives no clear metallic ring. Explain why an identical ring-test interpretation cannot be blindly transferred across wheel types; consult exact OEM method.
- **ABR-P08 — After a burst.** A wheel fractures, E-stop is pressed and the spindle stops. The operator wants to restart after sweeping fragments. Identify inspection of guard, spindle, mounting, damage and causal fault, plus deliberate rearm and change control.

## Ten documentary/physical qualification gates — ALL NOT RUN

| Gate | Required evidence | Status |
|---|---|---|
| ABR-G01 | Exact machine and wheel type/bond/markings and allowed operation identified; jurisdiction and product edition checked. | NOT RUN |
| ABR-G02 | Wheel condition, storage, handling and wheel-type-appropriate inspection method documented. | NOT RUN |
| ABR-G03 | Actual spindle speed envelope and qualified independent verification procedure documented; no reliance on CNC command alone. | NOT RUN |
| ABR-G04 | Exact wheel speed rating and actual spindle/wheel compatibility established without exceeding any product limit. | NOT RUN |
| ABR-G05 | Compatible mounting/flanges/blotters/arbor and torque/fit procedure from exact OEM. | NOT RUN |
| ABR-G06 | Guard/enclosure correct for wheel type and **fragment containment**, with verified condition/fasteners; splash screen not credited. | NOT RUN |
| ABR-G07 | Hazard-zone occupancy, start/stop, standstill/access and safe deliberate restart requirements allocated. | NOT RUN |
| ABR-G08 | Maintenance access/guard restoration design reviewed for predictable bypass incentives. | NOT RUN |
| ABR-G09 | Independent qualified validation plan and safe startup/inspection method; no ad hoc wheel burst/overspeed tests. | NOT RUN |
| ABR-G10 | `CHG` review of wheel type/diameter, drive, speed, spindle, guard, flange, enclosure, maintenance and occupancy; affected `VAL/PT` marked stale. | NOT RUN |

**Regulatory-scope trap:** OSHA §1910.215(a)(4) work-rest **1/8-inch** applies to specified **offhand grinding** machines; the adjustable upper tongue **1/4-inch** provision is also machine/guard-type specific. These numbers are **not** universal wheel-clearance settings for all CNC grinders. The OSHA-hosted page returned 403, but **direct eCFR 29 CFR 1910.215** was read, up to date 2026-10-23: https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XVII/part-1910/subpart-O/section-1910.215 . §(a)(4) offhand work rest, §(b)(9) specific tongue guard and §(d)(1)(i) organic-bond ring-test caveat are directly confirmed; exact selected machine applicability and local law still require verification. HSE HSG17 is UK guidance, not automatically a US legal mandate.

## Low-defeat design and independent safety boundary

Use clearly labeled wheel/guard compatibility, captive or obvious guard fasteners, unobstructed inspection, appropriate service access and a documented replacement procedure. If the guard makes normal use impractical, select a different qualified tool/fixture/machine rather than disabling the guard. Normal LinuxCNC/FPGA spindle speed, HMI and E-stop remain **ordinary control/diagnostics**, not fragment containment or automatically a safety-rated overspeed limiter. A selected independent safety function must be designed and validated if required; physical guard integrity remains a separate witness.

**Do not perform any live wheel experiment for this curriculum.** No selected abrasive machine, independent physical test, numerical stopping limit, PL/SIL or scored evaluator exists. No personnel-exposed hazardous operation if speed compatibility, guard strength or safe occupancy is unresolved. OpenPressBrake G0/G1 HOLD unchanged; 1000–3000 remain closed.
