# 4400 BUMP-01 — Tactile bumper actuation delay depends on approach speed

**Status:** original manufacturer source audit 2026-10-26, no simulation or machine test. **Source:** Mayser Safety Bumpers SB, product information 220923 v3.03-RiA, https://www.mayser.com/media/2662/download/PI-SB_EN.pdf?v=5 , PDF pp.20–22, 29–38.

## Direct documentary findings
- Manufacturer separates **actuation distance**, **overtravel distance** and **response time**; the protection question is whether hazardous movement ceases before the permitted compression/force limit is exceeded. **DOC-CONFIRMED.**
- In the **same** STB 1000 × 100 × 150 product table (PDF p.30), at 10 mm/s test speed response time is 1700 ms and actuation distance 17 mm; at 100 mm/s response time 140 ms and actuation distance 14 mm; at 200 mm/s response time 65 ms and actuation distance 13 mm. These are manufacturer test-condition results, **not** controller or machine universal timings. **DOC-CONFIRMED.**
- Mayser's selection example uses a complete system follow-through time (bumper response plus machine stopping), calculates a required overtravel with a specified factor, and compares against the selected bumper's force-dependent available overtravel. The exact numeric examples are not transferable without machine-specific evidence. **DOC-CONFIRMED.**
- Product tables distinguish a sensor-only assembly from a sensor **plus** control unit, including different safety classification. Component label is not machine-level PL/SIL. **DOC-CONFIRMED.**

## Key causal lesson
At slow contact approach the bumper may take far longer in **time** to deform enough to actuate, even though the displacement to actuation is similar. Conversely faster motion shortens actuation time but may leave too little remaining run-on to stop without excessive contact force. Neither 'fast sensor' nor 'soft bumper' alone proves safety. Do not infer a force threshold, distance or stop-time for a press brake or robot from these tables. **INFERENCE based on OEM data.**

## Source integrity issue
On PDF p.22, a worked example prose line appears to print **'v = 200 m/s'** while the immediately following formula substitutes **200 mm/s**. Preserve this as a manufacturer-document inconsistency; the calculation's units imply a likely typo, but no author correction was obtained. **UNKNOWN** normative intent of that sentence; do not quote it as a machine design speed.

## Architecture and human factors
Use contact protection only where contact itself is acceptable within the validated force/travel envelope. Prefer eliminating reachable pinch points, guarding approach routes and limiting hazardous motion before contact. Keep bumper replacement and cleaning straightforward, prevent crushed/blocked profiles and inspect environmental deterioration. Independent safety control/final elements and physical stop/hold remain mandatory to prove the relevant safety function.

**Evidence:** DOC-CONFIRMED exact Mayser tables and selection method; INFERENCE design boundary; SOURCE-CONFIRMED LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none; UNKNOWN selected machine profile, speed, load, stop/hold, PL/SIL. G0/G1 HOLD.
