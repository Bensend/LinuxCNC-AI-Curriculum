# 4400-MWF-MIST-01 — A stopped spindle is not a clear breathing zone

**2026-10-27 | NON-GRADUATED | Practical safety course / mills, lathes and grinders with MWF | 8 PUBLIC PAPER cases UNSCORED / 10 documentary gates NOT RUN.** Source: [NIOSH/HSE/OSHA original audit](../research/4400_MWF_01_02_NIOSH_HSE_OSHA_MIST_SKIN_MICROBIAL_EXPOSURE_SOURCE_AUDIT_2026-10-27.md). Applicability to OpenPressBrake **UNKNOWN**. This is a documentary learner module, not a test permission or hidden evaluator key.

## Objective and four independent authorities
Teach a technician to identify the hazard that persists **after machining motion stops** and to distinguish:
1. **Normal control:** LinuxCNC M5, M8/M9, ordinary extractor request, enclosure delay, HMI notification.
2. **Monitoring:** extraction flow/pressure indication, door timer, maintenance status; these report narrow states, not absence of mist or moving hazard.
3. **Safety-related control:** installed guard interlock, hazardous-motion stop, guard-lock release and restart only where actually required, specified and independently validated.
4. **Physical controls:** machine enclosure, effective LEV and verified breathing-zone clearance, independent mechanical motion stop and access geometry, personal energy isolation for service.

HSE MW1 explicitly warns that mist may remain when the enclosure is opened shortly after machining ends. It recommends a clearance delay based on the actual extraction/enclosure, not a generic 10-, 30- or 60-second rule. HSE allows a program/timer to implement an **exposure-control delay**; that is not evidence that the timer is a safety-rated guard-lock controller. A stop request, fan ON, and timed wait cannot each stand in for the others.

## Practical workflow without dangerous live experiments
**Design stage:** identify actual fluid, machining process, aerosol source, enclosure leaks, door/opening behavior, people, extraction duct/filter/discharge/recirculation, fan failure, maintenance access and motion hazard. Determine which access functions require independent personnel-safety control and which are occupational-hygiene controls. Keep a failure-safe response when extraction is unavailable without assuming every machine needs the same shutdown sequence.

**Document stage:** obtain actual enclosure/LEV drawings, OEM manual, flow/indicator specification, service log, workplace exposure assessment and change history. A product filter efficiency does not establish whole-system capture or worker exposure. Have a competent occupational hygienist design any actual mist-clearance/air sampling validation; have a qualified machine-safety engineer independently validate hazardous-motion stopping/guard access.

**Use stage:** favor enclosure and effective extraction, clear operator indication, easy access to maintenance and swarf vacuum tools, and an actual process that does not pressure workers to bypass the door. If a coolant/nozzle/door/filter or extraction geometry changes, mark clearance/exposure evidence STALE; if guard, speed or stop circuit changes, independently reopen affected motion-safety evidence.

## Eight PUBLIC open-book adversarial decisions — answers deliberately not scored
| Case | Scenario | Required written decision |
|---|---|---|
| MIST-P01 | M5 finishes, door releases, visible mist remains | Separate motion and inhalation propositions; identify HOLD and owner |
| MIST-P02 | Fan command true but a duct is disconnected | Identify what feedback cannot prove and independent witness |
| MIST-P03 | Supplier states filter is 99.95% efficient | Distinguish element efficiency from source capture and breathing-zone exposure |
| MIST-P04 | A universal 15 s timer is copied from a different CNC | Identify machine-specific validation missing; no invented time |
| MIST-P05 | Door interlock is bypassed to make cleaning faster | Diagnose usability failure and preserve independent motion protection |
| MIST-P06 | Compressed air clears wet swarf rapidly with door open | Compare practical alternatives and mist/noise/swarf hazards |
| MIST-P07 | Extraction runs but return air is directed at another worker | Identify recirculation/discharge and exposure scope |
| MIST-P08 | Extractor alarm is cleared by power cycling; operator immediately restarts | Separate diagnostic reset, ventilation restoration, physical access safety and deliberate restart |

For each answer require: **hazard boundary; physical final element; normal vs safety authority; independent witness; easiest safe workflow; change/retest; UNKNOWNs.** These are not blind challenges and do not establish competence.

## Ten documentary gates — all NOT RUN
| Gate | Required selected-machine evidence | Status |
|---|---|---|
| MIST-D01 | Actual fluid, process and aerosol-generating modes identified | NOT RUN |
| MIST-D02 | Exposure and breathing-zone map includes opening/cleaning tasks | NOT RUN |
| MIST-D03 | Enclosure leaks, door geometry and reach hazards mapped | NOT RUN |
| MIST-D04 | LEV airflow, filter, discharge and recirculation design identified | NOT RUN |
| MIST-D05 | Independent LEV functionality/exposure assessment owner named | NOT RUN |
| MIST-D06 | Actual clearance-delay evidence with qualified method (no assumed seconds) | NOT RUN |
| MIST-D07 | Motion stop/guard-lock independent safety functions separately documented | NOT RUN |
| MIST-D08 | Compressed-air/cleaning alternatives and operator usability reviewed | NOT RUN |
| MIST-D09 | Failure, maintenance, bypass and power-return/restart response documented | NOT RUN |
| MIST-D10 | Changes to fluid, extraction, door, guard or motion trigger scoped revalidation | NOT RUN |

**Evidence:** HSE MW1/NIOSH/OSHA are **DOC-CONFIRMED** only within source scope; separation and low-friction architecture are **INFERENCE**; actual installation/exposure/physical stop are **UNKNOWN**; no **TEST-CONFIRMED** results. Do not transfer HSE's UK 14-month LEV examination interval into a universal US legal obligation. No person-exposed machine trials; no compute justified. **Selected OpenPressBrake G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED.**
