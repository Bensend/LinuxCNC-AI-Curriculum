# 4400-DUST-01 — Wood-router LEV, collector fire/explosion, and LinuxCNC command versus capture proof
**2026-10-25 | ORIGINAL official safety sources + pinned LinuxCNC source | no machine test | NON-GRADUATED**

## Question and novelty
Can a CNC router safely infer that dust is being captured and that a combustible-dust collector is safe because LinuxCNC commanded a coolant/auxiliary output ON? What happens if a generic M8-derived output is reused for a shared extraction system and machine E-stop changes it? Prior 3400 research covered *normal* collector versus dust-foot/vacuum command arbitration; this 4400 investigation adds occupational exposure, collector deflagration and independently justified failure/restart architecture. It does not reopen graduated 3400.

## Original authoritative evidence
1. **OSHA woodworking production/wood-dust eTool**, https://www.osha.gov/etools/woodworking/production/wood-dust (accessed 2026-10-25). **DOC-CONFIRMED:** LEV removes dust near generation; hood design and maintenance matter; fan/duct failures and blockages undermine capture. Routers, shapers and sanders are high-dust processes. The eTool discusses typical duct velocities but these are *not* a universal CNC sensor setpoint or acceptance criterion.
2. **OSHA woodworking fire/explosion eTool**, https://www.osha.gov/etools/woodworking/safety-hazards/fire-explosion (accessed 2026-10-25). **DOC-CONFIRMED:** fine wood dust is fire/explosion fuel; extraction and housekeeping address different paths; compressed-air blowdown can form hazardous clouds; ignition and grounding must be addressed. OSHA describes continuous LEV and collector siting exceptions, not a universal software stop sequence.
3. **OSHA HIB, May 2 1997**, https://www.osha.gov/publications/hib19970502 . **DOC-CONFIRMED HISTORICAL:** improperly installed indoor cyclone collectors create fire/explosion risk; the bulletin quotes *then-current* NFPA 664 indoor exceptions. **DO NOT apply 1997 exception dimensions or the old edition as 2026 approval.**
4. **NFPA official standard-development listing**, https://www.nfpa.org/codes-and-standards/nfpa-660-standard-development/660 . **DOC-CONFIRMED publisher scope:** NFPA 660, 2025, consolidates NFPA 61/484/652/654/655/664; wood-processing provisions are now part of the consolidated standard. **Full normative clauses NOT independently inspected**; edition adopted by jurisdiction/AHJ, combustible-dust hazard analysis, explosion protection and collector-specific design remain UNKNOWN.
5. **US Chemical Safety Board, U.S. Ink investigation/news release, Jan 15 2015**, https://www.csb.gov/csb-names-poor-design-and-failure-to-test-dust-collection-system-among-causes-of-us-ink-new-jersey-flash-fire-that-burned-seven-workers-in-2012-osha-again-urged-to-issue-new-combustible-dust-regulations-/ . **DOC-CONFIRMED incident, different material/process:** poorly designed dust collection, accumulation, ignition, rooftop explosion and flame propagation injured seven workers. This is *not* evidence that a particular wood router has the same ignition mechanism; it demonstrates why a running collector can be an active process hazard.
6. **OSHA combustible dust standards page**, https://www.osha.gov/combustible-dust/standards . **DOC-CONFIRMED:** OSHA lists applicable federal standards and General Duty Clause; an NFPA publication is not automatically the applicable legal text without jurisdiction/edition determination.

## LinuxCNC pinned source trace
Repository `LinuxCNC/linuxcnc`, exact commit **062dc7c097693bb68e76192516cd92878dd5ecdf**. Inspected original source (2026-10-25):
- `src/emc/task/emccanon.cc:3340–3343`: `FLOOD_ON()` constructs `EMC_COOLANT_FLOOD_ON`; ordinary interpreter/canonical command.
- `src/emc/task/emctaskmain.cc:2151–2156`: Task dispatches flood ON/OFF to `emcCoolantFloodOn/Off`.
- `src/emc/task/taskclass.cc:55–56,84–89,437–448`: HAL `iocontrol.0.coolant-flood` is an **output**; `Task::emcCoolantFloodOn()` writes status=1 and HAL pin=1, OFF writes both 0. Neither function measures fan operation, flow at a hood, dust exposure, spark isolation or collector condition.
- `src/emc/task/emctask.cc:331–366`: machine OFF, ON, ESTOP_RESET and ESTOP paths each invoke `emcCoolantFloodOff()` (source comments include `TODO: race here`). **SOURCE-CONFIRMED** ordinary flood request may be driven OFF in those Task transitions. Do not infer downstream physical fan response without selected HAL/wiring.
- `docs/src/man/man1/io.1.adoc:31–34`: `iocontrol.0.coolant-flood` TRUE **when requested**, not proof of physical coolant/LEV.
- `configs/sim/axis/cooling.hal`: simulated flood and mist connect to ordinary HAL logic; no physical extraction validation in this example.

**Source-grounded execution chain:** program M8/FLOOD_ON -> canonical NML message -> Task dispatch -> Task HAL output/status -> selected external wiring/relay/PLC (UNKNOWN) -> physical fan/duct/hood (UNKNOWN). A separately engineered safety or environmental system must establish its own physical proposition; LinuxCNC is only normal command/diagnostic.

## Failure paths / design inference (NOT OEM truth tables)
| Event | False shortcut | Required discriminator |
|---|---|---|
| Fan commanded ON, duct detached | green `coolant-flood` => capture good | qualified hood/duct capture witness and inspection |
| Collector running, filter blocked | motor running => dust safe | qualified airflow/capture and differential pressure/maintenance, with failure detection |
| Machine E-stop, flood output OFF | assume every fan must stop | selected risk analysis must coordinate extraction, fire isolation and mechanical stop; neither always-ON nor always-OFF is universally safe |
| Collector fire/spark alarm | simply keep LEV running to clear dust | engineered fire/deflagration detection, isolation, suppression/venting and shutdown strategy according to approved design |
| Fan stopped, spindle still cutting | let G-code finish | selected stop/inhibit of dust-producing operation with separately justified safe stop of hazardous motion |
| Power return | auto-run fan means safe cutting | extraction readiness and independent deliberate new machine start; do not restart retained CNC motion |

**INFERENCE:** a process interlock should prevent new dust-producing cuts when effective extraction is not established, while protective stop, fire response and isolation remain independent where risk analysis requires. Do not assign a safety PL/SIL, fixed airflow threshold, dust explosibility, ignition source, delay or stop distance without material/installation-specific evidence. An E-stop is not automatically a fire-control system.

## Claim and evidence ledger
- **SOURCE-CONFIRMED:** pinned ordinary flood command/output and Task OFF paths above.
- **DOC-CONFIRMED:** OSHA LEV/fire/housekeeping guidance; NFPA 660 2025 publisher scope; CSB distinct dust collector incident.
- **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** prior 3400 LinuxCNC forum examples exist, not used as physical safety proof.
- **INFERENCE:** staged independent LEV availability and process-inhibit/stop architecture.
- **UNKNOWN:** selected wood/dust combustibility and exposure, facility code/AHJ, installed collector type/location, suppression/vent/isolation, actual flow and failure response, safety integrity, independent evaluation. No OpenPressBrake dust collector asserted.

## Decision
No bench simulation: the question of whether a HAL command measures extraction is resolved by direct source; the remaining collector/fire/capture questions need a qualified *selected installation* and measured physical evidence. No hosted/local Actions dispatched. Preserve the 3400 normal-control findings and 2500 safety-method graduation state.

## DUST-02/03 exact-source continuations
[2.9 versus development coolant/ESTOP version audit](4400_LINUXCNC_2_9_VS_DEVELOPMENT_COOLANT_REQUEST_AND_ESTOP_VERSION_BOUNDARY_2026-10-25.md) confirms 2.9 uses Task -> `EMC_TOOL_ABORT` -> `ioControl[(_v2)]` for OFF on abort/ESTOP/RESET, while development writes flood HAL directly in Task and also explicitly turns it OFF in the ON branch. No physical collector response inferred. [Donaldson CPC Rev6 and HSE commissioning source audit](4400_DONALDSON_POWERCORE_FILTER_DELTA_P_VENT_AND_SPRINKLER_OEM_AUDIT_2026-10-25.md) adds exact OEM collector vent-discharge and sprinkler-water structural warnings, Delta-P ambiguity and qualified hood commissioning. No numeric site criteria.

**DUST-04 exact interpreter addition:** [M8/M9 remap/queue pinned source trace](4400_LINUXCNC_M8_M9_INTERP_QUEUE_REMAP_VS_PHYSICAL_LEV_READINESS_SOURCE_TRACE_2026-10-25.md) confirms interpreter `settings->flood` and queued canonical requests are not immediate fan/hood capture. No safety timing inferred.
