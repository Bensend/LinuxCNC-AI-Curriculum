# 4400-OPB-CUTOVER-02 — actual retrofit endpoint trace: ordinary DNC commands into Pilz, independent gates, switched power

**2026-10-27 | cross-repository source/configuration audit | NOT a machine inspection, safety-PLC program audit, circuit validation or installation release.**

## Engineering question and genuinely incremental scope

The existing [brownfield retrofit audit](4400_BROWNFIELD_CNC_RETROFIT_SAFETY_PLC_CUTOVER_AND_LOCKABLE_ISOLATION_AUDIT_2026-10-24.md), [FS-IF contract](../hardware/SAFETY_BLOCK_INTERFACE_CONTRACTS.md) and [G0 Stage A intake](../safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) already establish independent safety authority. **This audit adds actual, inspectable OpenPressBrake Rev 1 endpoint names, directions, wire identities and source-of-truth conflicts.** It does not invent a new generic safety principle or repeat paper scenarios as new competencies.

The specific unresolved question is: **Can the replacement combined DNC/PVR board change a retained Pilz safety function indirectly through a normal CNC handshake, shared power/return, or a misclassified field connector, even when Pilz remains installed?** The answer is a set of **credible failure hypotheses** and exact documentary review gates; not a claim that an installed failure exists.

## Primary inspectable project evidence — version scope

Source inspected directly through the connected GitHub repository on 2026-10-27. These are **SOURCE-CONFIRMED repository design statements**, not independently inspected field wiring or qualified safety-PLC application logic:

| ID | Exact source | What it establishes in the **published Rev 1 design** | What it does NOT establish |
|---|---|---|---|
| OPB-1 | [OpenPressBrake Rev 1 endpoint audit](https://github.com/Bensend/OpenPressBrake/blob/main/docs/REV1_DNC_PVR_ENDPOINT_AUDIT.md), Git blob `717e7a07ab2d170b7727bb19c06734f5b31f83aa` | J10 DNC→Pilz six 24 V inputs, seven Pilz→DNC status signals; wire 75 Pilz→PVR hardware enable; 11K2 switched L7/L07; X2 load-return unresolved | Exact as-built harness, safety program truth table, electrical response |
| OPB-2 | [Rev 1 I/O map](https://github.com/Bensend/OpenPressBrake/blob/main/docs/IO_MAP.md), retrieved 2026-10-27 | Explicit normal controller outputs `CTRL_MUTE_COMMAND` and `CTRL_CNC_OK`; wire 75 treated as a local hardware gate | That the hardware gate actually dominates every hazardous current path |
| OPB-3 | [Machine configuration](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/REV1_MACHINE_CONFIG.yaml), retrieved 2026-10-27 | Lists Pilz as safety owner; excludes wire 63 X-drive, wire 123 pump, wire 402 AKAS mute, wires 189–191 safety hydraulic valves and wires 30–32 proving from normal board authority; lists five proportional coils and three separate Pilz-controlled on/off coils | Correctness of original drawing reconstruction or installed Pilz application |
| OPB-4 | [Electrical connector map](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/REV1_CONNECTOR_MAP.yaml), Git blob `4d1d5df43627964c91737f8936855e2f2dd35f0e` | Explicit J10 pin identities; separate L9/L06, L6/L06, L7/L07; warning not to bridge L07 to L06; X14/2 wire 75; wire 111 ambiguity | Final connector mechanics, safe wiring or field validation |
| OPB-5 | [Hydraulic phase table](https://github.com/Bensend/OpenPressBrake/blob/main/docs/HYDRAULIC_PHASE_STATE_TABLE_REV0.md), retrieved 2026-10-27 | Six phase labels, five proportional electrical coils, three retained Pilz-controlled on/off coils; phase-to-coil electrical mapping still UNRESOLVED | Any machine-specific safe-state valve truth table or validated mute window |

The original ERMAK/Pilz/PVR drawing PDFs were **not independently re-parsed or physically checked in this session**. The project documents report a reconstruction of drawings 9–14 and the PVR manual; classify those legacy drawing details as **PROJECT-DOCUMENTED / SOURCE-CONFIRMED AS DOCUMENTATION**, **not TEST-CONFIRMED as-built**. Exact Pilz program, device variants and installed revisions remain UNKNOWN.

## Exact controller/safety boundary from the published endpoint map

| Boundary | Normal or retained path in published design | Consequential question |
|---|---|---|
| J10/10, **wire 44** | `CTRL_MUTE_COMMAND` from DNC replacement to Pilz A2 X1 I2 | Does the *actual safety program* treat this as a request requiring independent speed/position/guard conditions, or can a stuck/replayed command create an unsafe mute? **UNKNOWN.** The label alone proves neither muting nor its safe qualification. |
| J10/16, **wire 45** | `CTRL_CNC_OK` to Pilz A2 X1 I3 | Does safety logic detect loss/staleness of normal-controller health? Constant-high or restored output is a candidate fault, not proof of healthy control. |
| J10/12, /14, /15, /9 — **42,43,46,47** | top dead center, end of bend, manual mode, up request to Pilz | Which inputs are safety-credited, transition-qualified, and independently corroborated in the installed program? No semantics inferred from labels alone. |
| PVR X14/2, **wire 75** | Pilz A5 X2 OA14 to replacement proportional-stage hardware gate | Does independent physical gating dominate every normal FPGA/driver command including startup, short, fault and service? Hardware **design intention**, no bench or field proof. |
| X drive B4, **wire 63** | Pilz A5 X1 OA8 directly to drive | Must stay outside ordinary FPGA authority; verify actual retained hardwired connection and drive behavior, not merely its software status. |
| **11Y4/11Y6/11Y8** | three Pilz-owned on/off hydraulic valves; normal board has zero drive instances | Must not migrate these to spare general outputs or proportional channels for wiring convenience. Exact pressure/ram safe-state role still requires installed hydraulic evidence. |
| **wires 30–32** | valve proving inputs to retained safety system | A proving contact can witness its actual target only; cannot alone establish beam restraint or pressure-zone safety. |
| **L7/L07** | switched machine-facing I/O supply/return through two-pole 11K2 | A replacement-board L07→L06 return bridge could defeat the legacy switched-return boundary. Verify schematic and physical return topology; a software “output inactive” is not enough. |
| **L6/L06 and L9/L06** | distinct field and controller source domains | Sharing upstream supply does not authorize downstream uncontrolled bridging or claim functional safety isolation. |
| PVR **X2** | dedicated proportional valve-bank load return is defined in PVR manual but omitted from machine drawing 13 | Physical harness unknown; high-current return cannot be silently reassigned to sensor/logic return. This is a common-cause/power integrity and installation blocker, not automatically a personnel-safety function. |
| **wire 111** | reused as Y2S2 coil terminal and X encoder 0 V in different drawings | Must retain qualified identities `S13_PVR_Y2S2_111` and `S14_XENC_111` until traced; auto-joining them can produce unintended coupling. |

**Important correction to oversimplified architecture language:** “Pilz remains independent” means the *safety decision/final elements must remain independently effective*, not that the Pilz program has no inputs from ordinary CNC. Six such inputs are explicitly present. Their **trust, polarity, validity, temporal qualification, mode and muting logic must be reviewed** before treating the retrofit as functionally equivalent.

## Five adversarial cross-boundary failure hypotheses — INFERENCE, not observed

1. **Stuck mute request:** wire 44 remains asserted across a mode transition, communications loss or reset. An installed safety program might reject it; only the actual program, selected sensor conditions and qualified validation can answer. Do not equate a Pilz input LED with safe muting.
2. **CNC OK frozen high:** wire 45 is retained from a normal-controller boot/failed watchdog path. Determine whether its health claim is independently checked, edge/freshness-qualified, or only a static input. No unverified heartbeat interval or watchdog coverage is assigned.
3. **Hardware gate bypassed by PCB fault:** wire 75 reaches a monitoring input or firmware-controlled enable, while an alternate power path can still energize a proportional coil. A passed logic-level test would not prove final coil current is inhibited. Safety authority remains with independent physical final elements, not this board alone.
4. **Return-domain bridge:** L07 inadvertently joins L06 through PCB copper, protection, instrumentation, USB/ground, or an external harness. The 11K2 switched-return effect can be defeated without a deliberate software bypass. Determine actual switching and fault response from schematic and qualified physical inspection.
5. **Retained valve path misclassified:** Pilz-owned 11Y4/11Y6/11Y8 or wire 63 is treated as an ordinary spare output during connector simplification. A normal FPGA restart or test utility could then assert a path previously outside its authority. Preserve a non-migration list and inspect *both* schematic and physical wiring.

These are **engineering review tests/negative cases**, not instructions to inject faults into an energized machine. Actual safe response depends on the selected machine and safety program.

## Required four-plane trace and evidence gate

- **Normal control:** LinuxCNC/HAL/FPGA, five proportional coil commands, X command, six CNC→Pilz handshakes. A command or internal watchdog is not safety authority.
- **Monitoring:** seven Pilz→CNC status signals, valve-position ADCs and HMI; they can explain state, not prove physical stopping/pressure/hold.
- **Independent safety-related control:** actual Pilz program, AKAS/guard inputs, qualifying logic, direct output authority including wire 75 and 63, retained hydraulic safety valves and proving. Exact selected design and safety claims UNKNOWN.
- **Physical energy removal/retention:** verified contactors, drive enable, hydraulic elements, mechanical load support, pressure zones and lockable service isolators. No command, status or single gauge substitutes for this.

**G0 documentary evidence needed (restricted):** exact as-built Pilz program/export and revision; six input semantics/qualification; safe muting mode and independent guard/speed/position conditions; 11K2 both-pole wiring/returns; wire 75 local hardware gate topology; wire 63 and 11Y4/11Y6/11Y8 continuity; physical valve proving targets; actual X2 load-return; wire 111 tracing; safety-function-to-physical-witness matrix; independent reviewer identity/competence. Do not publish wiring details or proprietary program in the public curriculum.

**G1/G2** are separate: only qualified, separately authorized no-person-exposure methods may establish independent Y1/Y2 stopping, gravity holding, pressure isolation, guard behavior and deliberate rearm. No energized tests are authorized by this audit.

## External authority and transfer

- [OSHA 29 CFR 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147): production control/stop circuitry is not automatically a maintenance energy-isolating device; scope and exceptions are task-specific (**DOC-CONFIRMED**, official text).
- [OSHA 29 CFR 1910.217(a)(5)](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217): press brakes are excluded from the *mechanical power press* section; do not transfer its requirements unqualified (**DOC-CONFIRMED**).
- [Pilz original PNOZmulti application manual](https://downloads.pilz.nl/downloads/PNOZMulti/PNOZmulti_Spec_Applic_Op_Man_1002337-EN-02.pdf): manual reset behavior in a **different published example** depends on the configured logic; not evidence of this installed machine's program (**DOC-CONFIRMED example only**).

The same trust-boundary problem transfers to mills (spindle/tool-change permission), lathes (chuck/door mode), robot cells (setup/teach requests), and plasma tables (arc enable/fume/process permits). Their actual safety programs and final elements must be traced independently.

## Evidence disposition and next step

**SOURCE-CONFIRMED:** inspected repository Rev 1 design/config statements, with exact path/selected blob IDs. **DOC-CONFIRMED:** narrow official OSHA scope and Pilz example. **INFERENCE:** five plausible cross-boundary failures and proposed review criteria. **UNKNOWN:** installed Pilz logic, exact machine wiring, actual electrical gate, hydraulic stop/hold/pressure, guard muting, physical proof and integrity targets. **TEST-CONFIRMED:** none. No compute, Actions, simulation or physical fault injection.

**Release:** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Do not operate with people exposed to an unproved hazard. No generic valve truth table, mute timing, pressure or stopping distance has been invented.
