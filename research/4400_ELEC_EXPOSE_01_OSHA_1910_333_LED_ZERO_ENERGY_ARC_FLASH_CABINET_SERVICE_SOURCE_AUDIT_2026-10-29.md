# 4400-ELEC-EXPOSE-01 — Cabinet E-stop OFF is not verified electrical de-energization; arc-flash/shock maintenance boundary

**Research date:** 2026-10-29. **Scope:** original OSHA electrical-work rules and interpretations; NFPA publisher edition status; cross-machine cabinet servicing. **Status:** DOC-CONFIRMED regulatory/publisher sources; architecture INFERENCE; selected OpenPressBrake electrical installation UNKNOWN; no field test or computed incident energy.

## New causal safety question

A technician stops LinuxCNC, presses E-stop, sees the controller's 24-V indicator go dark, opens a CNC cabinet and starts troubleshooting an exposed drive/contactor circuit. What proves electrical safety? **None of those normal-control indications.** Electrical shock/arc hazards can remain from line-side feeds, separate supplies, drive capacitors, UPS/backfeed, induced voltage, and energized testing. Personnel-safety stopping and maintenance electrical isolation are different safety functions.

This branch is **not** a duplicate of [DC-LINK-02](../safety-course/SAFETY_COURSE_INDEX.md) (drive stored energy), [PWR-UPS-01](4400_PWR_UPS_01_PILZ_PHOENIX_ROCKWELL_SEPARATE_24V_DOMAINS_AND_BUFFERED_POWER_AUDIT_2026-10-28.md) (buffered 24 V) or [LOTO-TEAM-01](../SAFETY_COURSE_RESEARCH.md) (multi-person isolation). The new source-backed contribution is **the legal/electrical distinction between a control status indicator and qualified test-equipment verification of exposed electrical parts**, plus shock/arc protective-work requirements and edition provenance. It does not replace those predecessors.

## Primary sources and classification

1. **DOC-CONFIRMED — OSHA 29 CFR 1910.333(a)(1) and (b)(2)(ii)(B):** live parts to which workers may be exposed are generally to be de-energized before work, subject to stated exceptions. Pushbuttons, selector switches and interlocks **cannot be the sole means of de-energizing circuits**. All energy sources must be disconnected; hazardous stored electrical energy must be addressed. Original regulation: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.333
2. **DOC-CONFIRMED — OSHA 1910.333(b)(2)(iv):** a qualified person must verify that equipment cannot restart and use **test equipment** to verify de-energization of the exposed elements, including unintended induction and unrelated backfeed. This is not equivalent to seeing a status LED off. The regulation explicitly specifies additional meter checking for circuits over 600 V; do not invent a universal voltage-independent test sequence from this clause.
3. **DOC-CONFIRMED — OSHA's 12-Dec-2012 interpretation:** an installed LED-type voltage indicator, even if correctly installed and maintained, may only be a **redundant indication** and is **not** the test equipment verification required by 1910.333(b)(2)(iv)(B). https://www.osha.gov/laws-regs/standardinterpretations/2012-12-12
4. **DOC-CONFIRMED — OSHA 1910.333(c)(2), 1910.335:** only qualified persons may work on exposed energized circuit parts not properly de-energized; electrical protective work practices, insulated tools, barriers and appropriate eye/face protection against arcs/flashes are required as applicable to the hazard. No generic PPE category or arc-flash boundary can be assigned without an actual assessment. https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.335
5. **DOC-CONFIRMED — OSHA LOTO eTool case study:** electrical shock exposure in utilization installations invokes 1910.333, not simply a generic reading of 1910.147; the relevant energy-control obligations need correct scope. https://www.osha.gov/etools/lockout-tagout/case-studies/overhead-crane-servicing-maintenance
6. **DOC-CONFIRMED — NFPA publisher, checked 2026-10-29:** NFPA 70E *Standard for Electrical Safety in the Workplace* currently lists **2027** as the active edition. This does not establish local legal adoption, availability of full text, or a machine-specific incident-energy value. https://www.nfpa.org/codes-and-standards/nfpa-70-standard-development/70E . NFPA's public learning page distinguishes arc-rated clothing from generic flame-resistant clothing: https://www.nfpa.org/education-and-research/electrical/learn-more-about-nfpa-70e

## Separation of control, safety, and physical isolation

```text
LinuxCNC / FPGA / HMI:  normal E-stop request, drive inhibit, status, diagnostics
Independent safety:   stop demand, guard-related protection, final-element authority
Electrical isolation: identified disconnecting means for ALL applicable supplies
Electrical verification: qualified-person test of exposed elements, including backfeed
Work protection:      qualified work practices; assessed shock/arc hazards and PPE/barriers
Mechanical/hydraulic: independently restrain ram/gravity and isolate stored fluid energy
```

**INFERENCE:** a controller display may be dark while line-side conductors remain energized; a voltage-indicator lamp may fail dark; a UPS or separate supply can energize parts after the main disconnect is opened. These are failure hypotheses for an actual circuit review, not claims that they occurred on OpenPressBrake.

## Adversarial service-path review

| Situation | False evidence | Evidence needed before exposure |
|---|---|---|
| E-stop pressed; HMI dark | “Power is removed.” | Identified sources, disconnecting means, lock/tag, qualified verification of each exposed circuit. |
| Main disconnect open; panel has another supply | “Everything in the cabinet is dead.” | As-built supply map, separate feeds/UPS/backfeed and qualified test-equipment verification. |
| Drive says STO and DC-link LED dark | “Safe to touch.” | Electrical isolation and stored-energy management; STO is not electrical disconnection. |
| Technician sees an LED voltage monitor OFF | “Zero volts confirmed.” | OSHA 2012 interpretation: status LED is not the required qualified-person test. |
| Live troubleshooting justified by convenience | “It is quicker to probe it powered.” | De-energize by default; documented reason and qualified electrical work protections if energized work truly necessary. |
| PPE selected from motor horsepower or breaker rating | “Arc-flash category is obvious.” | Site-specific arc-flash/shock risk assessment; source and circuit parameters; do not invent PPE/incident energy. |
| Electric circuits verified, ram still elevated | “Machine is now safe.” | Independent mechanical/hydraulic stored-energy and gravity-load restraint. |
| Cabinet reenergized after maintenance | “E-stop reset means resume.” | Qualified reenergization checks, people clear, safeguards restored, distinct deliberate machine restart. |

## Practical engineering / human factors

Make **de-energized diagnostics the normal, easy route**: separate safe test points and accessible external diagnostics, clearly identified supply/disconnect mapping, service-friendly covers and labelled isolation points, and readily available appropriate verified test equipment for qualified electricians. Do not make technicians remove covers or reach exposed terminals merely to view ordinary fault history. Design guard and panel restoration so replacing covers is easier than leaving them off. An E-stop, software inhibit, door interlock or HMI status is not a substitute for the required electrical energy-control procedure.

**UNKNOWN:** actual OpenPressBrake cabinet supply count, voltage, protection and fault current, arc-flash analysis, PPE/boundaries, discharge time, UPS/backfeed, electrical test-point design, as-built wiring, operator/service procedures, and actual Y1/Y2 stop/hold. **TEST-CONFIRMED none**. No incident-energy or NFPA PPE category calculated; no energized work or physical experiment authorized. If basic electrical and mechanical safety cannot be demonstrated, **no personnel-exposed hazardous operation**; any experimental operation must be isolated/remote with people outside the danger zone and residual risk controlled.

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. Independent 2520–25F0 evaluator OPEN.** No new owner Stage A questionnaire; detailed cabinet review remains conditional qualified work.
