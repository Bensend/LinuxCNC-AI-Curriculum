# 4400-ENC-01 — Direct Rockwell source audit: conditional single-encoder integrity, mechanical coupling and motion-dependent diagnostics
**2026-10-25 | DOC-CONFIRMED for original 2013 product/manual | not a selected-machine PL/SIL claim**

## Evidence and narrow scope
Rockwell Automation original *Kinetix 6200 and Kinetix 6500 Safe Speed Monitoring Safety Reference Manual*, publication **2094-RM001C-EN-P**, **May 2013**: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/2094-rm001_-en-p.pdf . **Directly opened and visually inspected** printed pp.18–19 (PDF pages 17–18); read Ch.5 printed pp.50–52 (PDF pages 49–51). Device families catalog 2094-SE02F-M00-S1 / 2094-EN02D-M01-S1. This is an OEM example, not an OpenPressBrake part identification or current-certification determination.

## Directly supported engineering distinctions
1. **Conditional single-encoder integrity** — Printed p.19 lists prerequisites for achieving up to SIL CL3/PL e/Cat 4 in a single-encoder application: permanent-magnet brushless AC motor; closed-loop field-oriented control using that encoder for commutation; specified Sin/Cos encoder; motor-to-encoder coupling designed to exclude slip; **motor/encoder-to-load coupling excludes slip and breakage as dangerous failure mechanisms**. These are conditions on an application claim, not a transferable rating for a different motor, hydraulic axis or retrofit.
2. **Two encoders do not eliminate mechanical common cause** — Printed p.18 permits up to SIL CL3/PL e/Cat 4 with two independent encoders **when installed to avoid common-cause dangerous failure**. Ch.5 p.50 says dual-encoder channels are discrepancy-checked, then speed/direction/standstill are derived from **encoder 1**; encoder 2 is a diagnostic witness. Both encoders attached to one failed mechanical element can agree while the hazard continues.
3. **Some diagnostics need actual motion** — Printed p.18 explicitly says some encoder diagnostics require motion to detect faults and requires motion at least once every six months **for this product's documented use**. It is **not** a generic safety-machine service interval and does **not** authorize energizing a dangerous machine to exercise a diagnostic.
4. **Default is not qualification** — Ch.5 feedback table printed p.54 defaults to **Single Encoder**; a configuration default does not prove the required motor type, encoder signal design, coupling fault exclusion, diagnostic test schedule, mechanical hazard coverage or whole-machine PL.
5. **Reaction latency is a parameter-dependent chain** — Printed p.18 distinguishes input-event-to-initiation 20 ms maximum for this device from overspeed-event-to-initiation governed by its configured **Overspeed Response Time**. Neither is a measured machine stopping time or a guard-access distance.
6. **Mechanical design is part of the safety claim** — A coupling fault excluded by analysis/design cannot be silently reintroduced by a service replacement, changed gear, belt, or improvised encoder mount. Treat this as a change-control trigger requiring renewed physical and integrity evidence.

## Practical failure paths and safe decisions
- **Common coupling failure:** two encoders mounted on a common rotating shaft agree, while a downstream load is mechanically disconnected and coasts/falls. **INFERENCE** from mechanics and OEM assumptions; specific fault frequency UNKNOWN. Remedy: identify the actual hazardous load and ensure fault exclusion is justified or monitor an independent path.
- **Unused machine:** machine sits motionless for a long time. A diagnostic that only operates during motion may not have exercised its fault coverage. **DOC-CONFIRMED** motion-dependent requirement for this exact OEM; **INFERENCE** maintenance review must consider controlled/qualified proof testing, not force a hazardous startup.
- **Copied PL e:** an integrator copies the manufacturer's upper capability rating into a press-brake SRS despite a hydraulic cylinder and ordinary FPGA encoder. **Invalid transfer**; selected PL/SIL is UNKNOWN and requires system-level risk assessment and validated architecture.
- **Sensor status to guard:** encoder1 reports standstill but gravity-loaded ram creeps. Even a qualified drive monitor does not prove the hydraulic holding or load path; independent ram support and safe access remain G0 HOLD.

## Evidence ledger
- **DOC-CONFIRMED** original OEM pp.18–19 and 50–54 as above.
- **SOURCE-CONFIRMED new LinuxCNC** none; **TEST-CONFIRMED** none; **COMMUNITY-REPORTED** none relied upon.
- **INFERENCE** coupling failure transfer, change-control and human-factor remedies.
- **UNKNOWN** installed selected machine sensors, coupling and valve mechanics, fault exclusions, achieved PL/SIL, physical stopping and holding, actual proof-test interval.
- No simulated fault injection, Actions dispatch or physical machine test. Original manual fully resolves the limited product-specific questions; no redundant lab justified.

## G0 qualification additions
For each selected machine: identify the motor/encoder/load path, actual safety diagnostic functions and motion-dependent proof needs; document what fault exclusions are claimed and their engineering justification; check service/replacement changes; trace safety status through final elements and independent gravity/hydraulic holding; require a qualified test plan if physical verification is needed. **No people-exposed operation** until independently validated. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.
