# 4400-TSC/TAB-01 — CNC through-spindle coolant / through-tool air blast: backflow, sensor identity and safe service
**2026-10-27 | original manufacturer/regulator source audit | NON-GRADUATED | no selected machine, no physical test**

## Precise engineering question
On a CNC mill with through-spindle coolant (TSC) and through-tool air blast (TAB), can a healthy-looking command bit, pressure reading, or successful pump stop establish that (a) air and coolant cannot cross into the wrong circuit, (b) coolant/air pressure is absent at a service opening, and (c) the tool-change area is safe? **No.** The original manufacturer documents physically different check-valve constructions, two opposite backflow directions, a pressure-sensor feed, and independent pump/purge/relief paths. The exact installed machine and its isolation must be identified.

## Predecessor / novelty reconciliation
The complete [canonical learner index](../safety-course/SAFETY_COURSE_INDEX.md), [research plan](../SAFETY_COURSE_RESEARCH.md), current [PROGRESS](../PROGRESS.md) and source-path search were checked, not merely a keyword-zero result. Predecessors:
- [HYD-INJ](4400_HYDRAULIC_PINHOLE_INJECTION_HOSE_FAILURE_ISOLATION_SOURCE_AUDIT_2026-10-24.md): generic high-pressure fluid injection and hose servicing. **Not new:** injection mechanism or lockout doctrine.
- [ATC-01](../safety-course/SAFETY_COURSE_INDEX.md): tool retention, drawbar release and service. **Not new:** tool-release or ejection hazard.
- [WJ-01](../safety-course/SAFETY_COURSE_INDEX.md): waterjet pump-off versus trapped pressure. **Not new:** generic pressure-zone isolation.
- [AIR-CLEAN-01](../safety-course/SAFETY_COURSE_INDEX.md): ordinary CNC air output and cleaning exposure. **Not new:** generic air jet or M-code output limitation.
- [CHIP-01/03](../safety-course/SAFETY_COURSE_INDEX.md): unexpected auxiliary restart. **Not new:** general command-versus-physical-isolation distinction.
**Actual increment:** exact Haas TSC/TAB *bidirectional cross-media check-valve failure paths*, spring-and-ball versus shuttle-and-ball hardware and revision-specific fitting, pressure-sensor sampling-port/firmware semantics, plus separate purge/relief/maintenance energy-zone witness. This changes what a technician must inspect before declaring a coolant/air retrofit safe.

## Primary source inventory and publication provenance
1. **Haas TG0145, Through-Tool Air Blast Troubleshooting Guide, Revision C, October 2025; page last updated 2025-10-15.** Original directly inspected: https://legacy-aem.haascnc.com/service/troubleshooting-and-how-to/troubleshooting/through-tool-air-blast--tab----troubleshooting-guide.html . Main service-manual mirror: https://haascnc.com/service/online-manuals/chip-and-coolant---service-manual/through-tool-air-blast.html.html . Sections: shuttle/spring/built-in diagrams, symptom table, check-valve inspection, analog input. **DOC-CONFIRMED** manufacturer *published* failure mechanisms; not a physical failure on our machine.
2. **Haas AD0086, HPC-1000/TSC-1000 operator supplement; page last updated 2020-10-06.** Original directly inspected: https://haascnc.com/service/troubleshooting-and-how-to/how-to/hpc-1000-tsc-1000---operator-s-manual-supplement . Sections: main components, M88/M89, dry/wet priming, tool-hole-dependent relief. **DOC-CONFIRMED** for this pump family only.
3. **OSHA 29 CFR 1910.147**, original regulator: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 . Especially (b) energy-isolating-device definition; (d)(5) residual/reaccumulating energy; (d)(6) verification; (e) restoration. **DOC-CONFIRMED** regulatory text in its actual servicing/maintenance scope.
4. **LinuxCNC official M-code documentation**: https://www.linuxcnc.org/docs/stable/html/nb/gcode/m-code.html . **DOC-CONFIRMED** standard M7/M8/M9 coolant, M62–M65 outputs and M100–M199 user-defined commands; **Haas M88/M89 are not LinuxCNC built-ins; Haas M73 starts TAB while LinuxCNC M73 saves/autorestores modal state; Haas M74 is not a stock LinuxCNC TAB command**. Never transfer an OEM M-code or its purge/toolchange sequence into a LinuxCNC retrofit without a selected implementation trace.
5. **Historical Haas HS-series manual (1997)** was search-indexed but full PDF direct retrieval exceeded source-access limits. Its old precharge/tool-change narrative is **INDEXED-ONLY**, not a source for present variant truth or a claimed modern release time.

## Exact documented physical paths (not a universal schematic)
**DOC-CONFIRMED TG0145 Rev C:**
- The **TAB air check valve** prevents TSC coolant entering the CALM air circuit. Its documented failure sends coolant back through TAB pneumatic tubing and out the cabinet muffler when TSC runs. This is a *coolant-to-air* backflow path.
- In the **spring-and-ball coolant check valve**, the spring/ball can jam: TAB air can travel backward into the coolant circuit, making the tank bubble or overflow. This is the *air-to-coolant* path. The two failures are **not** interchangeable, and neither proves a particular injury or pressure at the point of release.
- The **shuttle-and-ball** construction uses a ball deflector and pressure/gravity-dependent movement rather than the spring-and-ball geometry. Its slotted elbow intentionally passes some pressure to the sensor. A healthy sensor response therefore **does not establish** correct tool-tip flow, check-valve direction, absence of leakage, or a safe-to-open service joint.
- Manufacturer's applicability note: certain VF-1..VF-5 machines built **2023-03-15 to 2023-05-19** may lack the newer slotted elbow; a Haas service update is specified. This is **an OEM build-window applicability discriminator**, not a blanket recall or proof every unit has a defect.
- TG0145 also says TAB pressure alarm behavior changes with software **100.22.000.1000+** (published alarm trip from 30 psi to 15 psi). These numbers are **OEM diagnostic setpoints for an identified option**, not safety-rated pressure limits, injury thresholds or acceptable maintenance pressure.
- TG0145 identifies ordinary output 43, analog input 7 and the LOW TSC status. They show what the control believes or samples, **not physical isolation or independent safety authority**. A firmware or I/O patch can change ordinary functionality while leaving physical check valves and maintenance energy hazards untouched.

**DOC-CONFIRMED AD0086, distinct HPC-1000/TSC-1000 pump family:**
- The manufacturer depicts a **high-pressure outlet**, **normally-open air-bleed/prime path**, **high-pressure relief valve** and **bypass-to-tank**. M88 commands pump ON; M89 commands pump OFF. The prime/bleed and high-pressure relief serve different physical purposes.
- Pressure depends on the tool opening. A small opening can cause the relief to bypass excess flow; a larger opening may have substantially lower backpressure at similar pump operation. **Pressure reading alone is not flow delivery, and pump-off alone is not proof of downstream zero pressure**.
- The published maximum 1000 psi / 68.9 bar is a *family capability*, not an installed measurement, a universal TSC rating or a safe access threshold.
- Automatic dry/wet priming and purge describe **normal production behavior**, not a lockable energy-isolating device. No claim is made that the normal air-bleed path empties every isolated downstream volume.

## Adversarial failure-path review
| Challenge | Plausible misleading observation | Independent fact/witness needed | Status |
|---|---|---|---|
| TAB coolant-check spring/ball jams | TAB command OFF or TSC sensor healthy | Correct variant and actual check direction/condition; protected tank and overflow routing | UNKNOWN |
| TAB air check leaks | TAB output OFF and TSC pump normal | Air/coolant separation, line routing, muffler discharge destination and safe service | UNKNOWN |
| Shuttle elbow substituted | Pressure reading present | OEM-specific elbow/check-valve part and sensor tap; actual tool delivery, not sensor bit alone | UNKNOWN |
| Tool opening changes | Same pump command | Selected tool/flow/relief and pressure-zone map | UNKNOWN |
| Pump stopped or alarmed | M89, M9 or HMI OFF | Lockable pump energy isolation, bleed/drain path, pressure verification at each exposed zone | UNKNOWN |
| TSC/TAB firmware/I/O change | Alarm now clears | Exact machine build/option/software and qualified change/revalidation | UNKNOWN |
| Tool change or service | Spindle stopped, tool-release command complete | Separate drawbar/tool-retention, residual coolant/air, guard and physical access propositions | UNKNOWN |

**Failure-chain inference:** check-valve failure can redirect energy or coolant into a circuit not designed as the normal outlet; a sensor on a tap may still read plausibly while the intended path is blocked or bypassing. This is an **INFERENCE** from OEM-described plumbing and fault modes; it is not an observed injury, proof of sensor malfunction or evidence that any OpenPressBrake unit has this equipment.

## Four independent authority layers
1. **Normal control:** OEM Haas M88/M89 and M73/M74, or a *separately designed* LinuxCNC M7/M8/M9/custom-output sequence. The CNC may request pump, air and purge.
2. **Monitoring/diagnostics:** pressure transducer, LOW TSC bit, alarm and I/O state; all require topology/revision interpretation.
3. **Safety-related control:** only the selected and independently justified protective path, if required by the machine risk assessment. **No safety rating is claimed** for OEM pressure switch, TAB check valve, purge timer, CNC, FPGA or HMI.
4. **Physical energy control:** appropriate lockable energy-isolating devices, pressure relief/drain/isolation and independently verified safe service condition for *each* exposed coolant/air zone. OSHA §1910.147 specifically requires stored energy rendered safe and verified before covered servicing.

## Practical minimum and anti-bypass design
For any selected high-pressure coolant/air system, the technician must have an accessible, labeled, **lockable pump/air isolation method** and a safe, shielded, readily identifiable way to verify that service points are not pressurized, with OEM-specific routing. Keep check valves, filters and hose connections reachable **without reaching into exposed rotating/tool-change hazards**. Put the approved variant and inspection interval where a technician can actually find it; stock the correct replacement instead of inviting an incorrect fitting substitution. A simple, reliable cleanout and drain procedure is more effective than a complex diagnostic screen that encourages opening live plumbing.

**Do not operate with people exposed to unqualified jets, leaking high-pressure connections, or unexpected tool-change motion.** If a necessary experimental observation cannot be performed under a qualified isolated/remote plan with personnel outside the danger zone, it remains NOT RUN.

## Conditional selected-machine evidence (not a new owner questionnaire)
- **TSC-1 identity:** exact CNC model, pump/TSC/TAB option, year, selected valve assembly, firmware and OEM document revision.
- **TSC-2 plumbing:** as-built air, coolant, check, bleed, relief, bypass, tool outlet, sensor-tap and trapped-volume map.
- **TSC-3 authority:** commands versus actual pump/solenoid power, feedback and independent protective functions, if any.
- **TSC-4 maintenance:** lockable isolators, physical pressure/air bleed and verification at each exposed service point; no energized opening.
- **TSC-5 failure/change:** approved check-valve/slot variant, documented backflow/overflow path, sensor/firmware applicability and change-control revalidation.
- **TSC-6 access:** spindle/tool-release and guarding interactions, operator/maintainer usability and fresh restart after service.
All **UNKNOWN/NOT RUN**. Fold these only into the existing restricted [Stage A A–G](../safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) and conditional Stage B **if** a selected machine actually has TSC/TAB. **No TSC/TAB equipment is asserted on OpenPressBrake.**

## Evidence and stop conditions
No machine, hydraulic/pneumatic drawing, selected valve, pressure measurement, test, external evaluator, stopping time, safety integrity claim or computed pressure limit was available. No lab justified: the exact documentary questions are resolved by primary sources; the remaining questions require qualified physical evidence. **GitHub-hosted compute 0 min; local compute 0 min.** 1000/2000/F02/3000 remain CLOSED. OpenPressBrake G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Independent 2520–25F0 competency evaluation remains NOT RUN.

**Exact LinuxCNC M-code collision and M6 source correction (2026-10-27):** LinuxCNC's [stable M-code manual](https://www.linuxcnc.org/docs/stable/html/nb/gcode/m-code.html) explicitly defines **M73 as save-and-autorestore modal state**, while Haas TG0145 uses **M73 to start TAB** and **M74 to stop TAB**. Thus M73 is **not absent** in LinuxCNC; it is a dangerous *same-number, different-meaning* portability trap. The LinuxCNC M6 section additionally states that coolant **continues to flow unless M9 turns it off**; never import a Haas toolchange purge/stop expectation into a LinuxCNC M6 without an implemented, verified sequence. Haas M88/M89 are OEM TSC commands, not standard LinuxCNC coolant commands. These are DOC-CONFIRMED **documentation semantics**, not a runtime test or proof of physical safe state.
