# Safety Curriculum Next Work — 2026-09-15

## Current state

Primary curriculum priority is Practical Machine Safety Engineering / 4000 safety-oriented boundaries. The 3000 series remains GRADUATED/CLOSED.

Completed this pass:
- created `research/linuxcnc-safety-patterns.md` as the first R-SAFE-01 durable artifact;
- pinned LinuxCNC master at `d1a9d7d04cc274bfb5082caee6accc2489607418`;
- source-traced `estop_latch.comp` startup, fault, reset-edge and watchdog behavior;
- inspected upstream `hm2-stepper.hal` use of HostMot2 watchdog -> software E-stop latch;
- reconciled current HostMot2 watchdog semantics with the safety boundary;
- compared reset/channel/self-monitoring/STO concepts against current Pilz and Rockwell documentation;
- source-traced `iocontrol.0.user-enable-out`, `user-request-enable`, and `emc-enable-in` through `taskclass.cc` in `research/linuxcnc-iocontrol-estop-callflow-2026-09-15.md`;
- froze four separate concepts for future diagrams: **request -> permission -> safety authorization -> physical actuation**;
- froze the authority distinction: LinuxCNC/HAL = ordinary control/coordination; HostMot2/ordinary FPGA = fault containment; independent safety system + physical energy hardware = personnel-safety authority where required.

## Exact next work

1. Inspect at least three real public LinuxCNC machine integrations with external safety relays, STO, redundant contactors or equivalent independent safety hardware. Preserve wiring/config chronology and commissioning lessons; do not infer safety architecture from HAL alone.
2. Begin R-SAFE-02 using exact commercial safety-relay manuals. Extract reset modes, channel/cross-short behavior, EDM, output structure, response time, fuse/load assumptions, PL/SIL claims and restrictions into a comparison matrix.
3. Build the first 2510/2520 teaching artifact from evidence: hazard -> hazardous event -> safety function -> safe state -> reset/restart -> validation. Keep it generic and require explicit residual-risk statements.
4. Trace EDM/force-guided-contact behavior from exact manufacturer manuals and turn welded-contact failure into a source-backed exercise.
5. Only after the SRS/failure model exists, begin low-cost reference architecture drawings. Do not assign Category/PL/SIL claims to open reference circuits without the corresponding evidence.

## Lab decision

No lab is justified yet. Current unknowns are source/config/manual questions. Prefer evidence acquisition over synthetic simulation.

## Human-factors rule

Recovery must be easy but deliberate. Safeguards should be easier to use/reinstall correctly than to bypass. Diagnostics should identify the missing prerequisite without offering a bypass path.
