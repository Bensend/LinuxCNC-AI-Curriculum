# 4400 OT-SEC-01 — Network access, ordinary CNC commands, and independent machine-safety authority

**Status:** 2026-10-26 documentary/source study; NOT machine validation, NOT a cybersecurity penetration test, NOT external competency evidence. **Novelty check:** the complete 4400 safety learner index and recent research entries were checked for *cybersecurity*, *remote access*, *remote start*, and *network segmentation* before selection. Existing 4400 E-stop, reset, diagnostic and LinuxCNC/HAL safety-boundary lessons remain prerequisites; this investigation adds an explicit **malicious/unauthorized command and configuration-change pathway**, not a new type of physical E-stop.

## Question / source selection

Can a network-connected CNC panel, remote service session or future web HMI affect the ability of a separately engineered safety-related control system to maintain safe operation? What evidence distinguishes authentication, ordinary motion authorization, and actual physical safety authority?

**Authoritative public sources inspected:**

1. NIST, *SP 800-82 Rev. 3, Guide to Operational Technology (OT) Security*, **final September 2023**, original 316-page PDF: https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-82r3.pdf ; official release https://csrc.nist.gov/pubs/sp/800/82/r3/final . Relevant **PDF pages 41 (2.3.7), 71 (4.2.2), 93–95 (5.2.5 and 5.3.1), 138–140 (6.2.10), 248–249 (AC-17 OT overlay)**. These are PDF page indices; the printed page numbers differ. NIST's **2026-09-21 Rev. 4 initial public draft is not the final Rev. 3**; do not silently transfer draft requirements.
2. IEC **TS 63074:2023**, *Safety of machinery — Security aspects related to functional safety of safety-related control systems*, official IEC product/abstract: https://webstore.iec.ch/en/publication/69228 . **Only the official scope/abstract inspected**, not the purchased normative technical clauses. It identifies direct and indirect vulnerabilities of safety-related control systems and IEC 62443-related threat-model questions. It expressly excludes ordinary non-safety IT security and physical manipulation/bypass from its scope. It is a *technical specification*, not a claim that this curriculum certifies an SCS.
3. LinuxCNC official current io(1) and halui documentation: https://www.linuxcnc.org/docs/master/html/en/man/man1/io.1.html and https://www.linuxcnc.org/docs/html/gui/halui.html . These establish non-realtime iocontrol and HAL/NML GUI command interfaces, including ordinary E-stop-request/reset pins. **DOC-CONFIRMED** interface only, not a machine's remote reachability or functional-safety rating.
4. LinuxCNC **source context**: pinned `LinuxCNC/linuxcnc` commit `c9a5a0a5034177c8db64cb44abf14d4f2eb166f7`, `src/hal/components/estop_latch.comp` (blob `f8b0e60b2784d6ca4c456fddd49e7308fa669795`): a *software* latch with reset edge and healthy input defaults. This source was re-inspected only as an **existing** LinuxCNC boundary; first-scan held-reset was already taught in `safety-course/4400_ESTOP_LATCH_FIRST_SCAN_ADVERSARIAL_CARD_2026-10-22.md`. **No novelty claim** for the source behavior.

## Evidence ledger

| Proposition | Classification | Exact support / limitation |
|---|---|---|
| OT cybersecurity risk must consider physical safety impacts, and a combined control/safety network may expose both to compromise | **DOC-CONFIRMED** | NIST SP 800-82r3 §4.2.2 printed p.55 (PDF p.71); guidance, not a machine-specific compliance finding |
| Cyber-related safety architecture may need physical separation rather than only logical segmentation; loss of communication can demand a defined fail-to-known-state response | **DOC-CONFIRMED** | NIST §5.3.1 printed p.79 (PDF p.95); actual safe state and communication-loss behavior remain machine-specific |
| Remote access should be justified, limited, monitored, temporary when appropriate, visible to operations, and must not negate safety controls | **DOC-CONFIRMED** | NIST §6.2.10 printed pp.122–124 (PDF pp.138–140); a VPN is **not** a safety controller |
| Safety-related control can be vulnerable directly or indirectly through other machine components | **DOC-CONFIRMED scope only** | IEC TS 63074:2023 official abstract; technical clauses **NOT INSPECTED** |
| `iocontrol` is non-realtime; `halui` can issue NML-related commands; `estop_latch` is software logic | **DOC-CONFIRMED / SOURCE-CONFIRMED** | Official LinuxCNC docs and pinned source above; no physical final-element authority follows |
| A compromised panel/remote account could request a CNC move, change a configuration, spoof a diagnostic or suppress a displayed fault | **INFERENCE / THREAT HYPOTHESIS** | Plausible only where those paths and privileges exist; **NOT an observed attack** or OpenPressBrake fact |
| Network isolation or password alone guarantees personnel safety | **NOT SUPPORTED** | Independent safety-related controls, physical energy removal/holding, guarding and validation remain necessary |
| OpenPressBrake network topology, web HMI, remote support, safety-controller programming interface, privileged paths, stop/hold, guard and rearm behavior | **UNKNOWN** | No private machine evidence or physical test inspected/credited |

## Boundary diagram (conceptual, not an as-built schematic)

`Remote support / update / web UI / removable media`
  → **IT/OT access boundary** (authentication, least privilege, temporary access, logging, segmentation)
  → **ordinary CNC panel / LinuxCNC / HAL / FPGA / process outputs** (may request motion, display safety status)
  → **ordinary actuation request**.

Separately, **qualified independent safety inputs → safety-related logic → qualified final elements / physical energy control and load holding**. Any diagnostics flowing *from* safety to CNC must not silently become a command path *into* safety authority. A network path to the safety controller's configuration is a **distinct change-control and cybersecurity boundary** to identify, not proof that the controller is unsafe.

## Adversarial failure paths and physical consequences

1. **Authenticated but wrong privilege:** a service account can jog remotely during a tooling change. Authentication proves identity, **not** local hazard clearance. Separate local deliberate motion authorization and independently active safeguarding are required; whether a particular machine implements them is UNKNOWN.
2. **Safety controller exposed through engineering port:** segmentation failure or maintenance laptop bridges ordinary and safety networks. A compromised engineering workflow could alter safety logic/configuration. Preserve controlled change authority, approved configuration identity, and independent revalidation; no invented SIL/PL or actual exploit claim.
3. **Remote patch/reboot or cable loss:** ordinary CNC stops reporting, but ram load, trapped hydraulic pressure and guard release do not become safe merely because the HMI is dark. Establish the selected physical safe-state proposition and failure response independently.
4. **HMI says safe:** a spoofed or stale diagnostic tag claims `E-stop clear`. It does not prove independent Y1/Y2 stopping, gravity holding, pressure isolation or restart prevention.
5. **Well-intended quick remote support:** leaving always-on remote desktop saves service time but expands attack and accidental-command opportunity. Prefer a conspicuous locally enabled, time-limited, automatically expiring, read-only-by-default support mode that does not bypass safety; this is an **INFERENCE/design candidate**, not a certified safety function.

## Design and human factors

Make safe support **easier** than bypass: one obvious local service-enable/disconnect control, visible session indicator, no secret always-on remote route, time-limited access, simple verified backups, a documented way to return to production and revalidate changed logic. Do not conflate a physical network disconnect with electrical/hydraulic lockout. The safe architecture should not require an operator to understand VPN internals to know whether remote motion requests are possible.

## Next evidence and information-gain stop

For a **qualified, private selected-machine** review: identify every ingress path and role; who can issue motion/reset/program change; physical local enabling and presence verification; safety-controller configuration access; safe-state behavior on network loss; backup/version/rollback; independent Y1/Y2 stop/hold and pressure/guard/rearm witnesses. Keep diagrams/credentials private. No numerical stop times, pressure limits, PL/SIL, or attack success inferred.

**No lab justified:** the primary question is architectural and resolved at documentary scope. A simulation of a spoofed GUI bit would not establish personnel safety. External competency assessment and private G0 evidence remain OPEN; G0/G1 HOLD.

## Same-session pinned LinuxCNC command-path deepening
The [direct `halui.cc` source trace](4400_OT_SEC_01_PINNED_LINUXCNC_HALUI_NML_COMMAND_ECHO_VS_PHYSICAL_AUTHORITY_SOURCE_TRACE_2026-10-26.md) at LinuxCNC commit `c9a5a0a5034177c8db64cb44abf14d4f2eb166f7` identifies `halui.machine.on` → `EMC_TASK_SET_STATE{ON}`, `halui.estop.reset` → `EMC_TASK_SET_STATE{ESTOP_RESET}`, and `halui.mdi-command-NN` → `EMC_TASK_PLAN_EXECUTE` via `emcCommandSend`. **SOURCE-CONFIRMED** at the pinned commit: `emcCommandSend` returns success after **Task serial-number echo**, not after physical motion/stop/hold verification. **INFERENCE** only: a remotely writable upstream HAL connection could submit ordinary requests; **UNKNOWN** whether such a path exists on OpenPressBrake or whether Task accepts any given request. This adds exact source mechanism without inventing a network exploit, bypass, or personnel-safety guarantee.
