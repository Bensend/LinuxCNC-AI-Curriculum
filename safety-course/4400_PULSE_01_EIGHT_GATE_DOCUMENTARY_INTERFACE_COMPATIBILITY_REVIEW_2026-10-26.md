# 4400-PULSE-01 — Eight documentary gates for a safety I/O pulse interface
**2026-10-26 | ALL UNKNOWN / NOT RUN | no machine energization**

Each gate needs exact model/revision, qualified reviewer, evidence ID and date. PASS here is documentary only; physical validation is a separate gate.

| Gate | Required question | Current |
|---|---|---|
| PI-01 | What is the exact installed sensor/ESPE order code and manual edition? | UNKNOWN |
| PI-02 | What are its two OSSD outputs' specified self-test pulses, supply and electrical limits? | UNKNOWN |
| PI-03 | What is the exact safety-related receiver/input model, revision and accepted OSSD pulse behavior? | UNKNOWN |
| PI-04 | Does the safety receiver evaluate both channels and detect the required fault types? | UNKNOWN |
| PI-05 | Are controller test-source outputs correctly assigned, routed and not used for load driving? | UNKNOWN |
| PI-06 | Have changes to beam coding, filtering, wiring or sensor variant reopened response-time/guard-distance analysis? | UNKNOWN |
| PI-07 | Does a separate safety-related final-element path actually stop/hold the hazard without depending on LinuxCNC/FPGA? | UNKNOWN |
| PI-08 | Are independent physical stop/hold, guard, reset and maintenance isolation witnesses planned and validated by qualified personnel? | UNKNOWN |

**Disposition:** all NOT RUN. No generic 300 µs/5 ms filter design, performance level, diagnostic coverage, stop time or distance is authorized. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED.
