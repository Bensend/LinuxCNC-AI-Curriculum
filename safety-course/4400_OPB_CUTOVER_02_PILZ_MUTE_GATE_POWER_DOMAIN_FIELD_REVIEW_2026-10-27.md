# 4400-OPB-CUTOVER-02 — retained Pilz is not automatically retained safety: real-interface technician review

**2026-10-27 | practical public paper/desk module | NON-GRADUATED | NOT a field test, installation procedure or safety release**

## Why this is different from the generic retrofit lesson

The [original cross-repository endpoint audit](../research/4400_OPB_CUTOVER_02_PILZ_MUTE_GATE_POWER_DOMAIN_CROSS_REPOSITORY_SOURCE_AUDIT_2026-10-27.md) traced the **actual published Rev 1** interface of the combined DNC/PVR replacement: six normal CNC→Pilz commands, seven Pilz→CNC statuses, proportional-output enable wire 75, direct X-drive Pilz enable wire 63, three Pilz-owned hydraulic on/off valves, switched L7/L07 through 11K2, and an unresolved PVR X2 high-current return. The earlier [brownfield cutover lesson](4400_CNC_RETROFIT_SAFETY_FUNCTION_CONTINUITY_AND_ISOLATION_WORKSHEET_2026-10-24.md) establishes the general principle; **this module teaches exact design-review discrimination at the real repository boundary**. The legacy drawing reconstruction is project documentation, not verified as-built machine evidence.

## Learning objective

Given a wiring/config change proposal, identify (1) ordinary command, (2) independent safety decision, (3) physical final element, (4) narrow feedback witness, (5) the precise missing evidence, and (6) the safe hold/return decision. A learner must **not** assume that a Pilz input labeled MUTE has safety muting authority, that a Pilz status bit is physical proof, or that a switched return can be bridged for convenience.

## Real source-derived boundary, not a generic wiring example

| Signal family | Design-declared role | Technician non-claim |
|---|---|---|
| `CTRL_MUTE_COMMAND` wire 44, `CTRL_CNC_OK` wire 45, plus wires 42/43/46/47 | Normal controller outputs **into** retained Pilz input channels | Actual Pilz program, guard/muting qualification and signal freshness are UNKNOWN. |
| `PILZ_VALVE_ENABLE` wire 75 | Intended hardware proportional-stage inhibit | Cannot prove no coil current or physical Y1/Y2 stop without circuit/physical witness. |
| Pilz wire 63 to X drive B4 | Retained direct drive-active path | Cannot be rerouted through normal FPGA as a harmless convenience. |
| Pilz 11Y4/11Y6/11Y8, proving wires 30–32 | Retained on/off hydraulic outputs and feedback | Do not infer safe hydraulic valve states or ram support from names. |
| 11K2 switched L7/L07 | Two-pole switched ordinary machine-facing I/O domain | Do not tie L07 to L06 to “fix” a missing return. |
| X2 proportional-bank load return; duplicated wire 111 | Unresolved harness/identity | Do not guess physical return or merge wire-number collisions. |

## Twelve public unsolved transfer cases — **UNSCORED**

For each case, write the **authority owner**, what is **observed vs physically established**, the **first discriminating document/inspection**, the **unsafe shortcut**, and a **HOLD or conditional-review disposition**. These are practice prompts, **not** a blind challenge, and no hidden evaluator answer is included.

1. A new FPGA build leaves wire 44 high through a power interruption while the guard status on the HMI is green. Which actual Pilz program and physical conditions must be reviewed before assigning any muting safety credit?
2. Wire 45 reads high immediately after the FPGA stops communicating. What evidence would distinguish a static “CNC OK” bit from a qualified fresh-health condition?
3. A schematic moves wire 75 to an FPGA GPIO and uses firmware to turn all five proportional channels off. Which independent hardware path, physical element and witness are now missing?
4. The gate on wire 75 is correct for PROP1–PROP4 but PROP5 has an alternate load path. How should the cross-channel stop claim be disposed?
5. A technician ties L07 to L06 to eliminate an intermittent 11K2 return problem. Which pre-existing switching behavior can be bypassed, and why is “all outputs disabled” insufficient?
6. A board connector maps legacy wire 111 from the X encoder to Y2S2 because both drawings use “111.” What source ambiguity and machine check block release?
7. An engineer reassigns 11Y6 to a spare FPGA high-current output to simplify harnessing. Which authority boundary has been crossed?
8. A HMI shows `PILZ_DOWN_MODE=0` after E-stop, but Y1 is unsupported. Which physical propositions remain unresolved?
9. The original X drive B4 wire 63 is disconnected, but a new ordinary RUN output remains inactive. Does that demonstrate the retained independent X-drive stop path?
10. A valve proving contact on wire 30 changes state while the ram remains elevated. What exactly can the proving contact establish, and what cannot it establish?
11. The replacement board's proportional return is routed through the sensor 0 V connector because X2 was not shown on drawing 13. What current-path and common-cause evidence is missing?
12. After a Pilz reset, an old held UP/MUTE request is still asserted at the new board. Which independent reset conditions and **new deliberate motion request** must be verified before hazardous motion is permitted?

## Twelve documentary gates — **NOT RUN**, not twelve successful tests

| Gate | Desk review question | Required restricted evidence | State |
|---|---|---|---|
| D01 | Are all six CNC→Pilz inputs mapped to exact as-built terminals? | Rev-matched Pilz program, drawings and cable trace | NOT RUN |
| D02 | Is mute qualification independent of an untrusted stuck normal request? | Actual Pilz logic, protective device model, mode/guard qualification | NOT RUN |
| D03 | Does CNC health have documented freshness/fault semantics? | Actual program and normal-controller behavior evidence | NOT RUN |
| D04 | Is wire 75 a real non-maskable hardware inhibit for every intended proportional channel? | Circuit, selected parts, fault-path review and qualified validation plan | NOT RUN |
| D05 | Does the Pilz wire 63 path still reach the selected X drive independently? | As-built route and selected drive safety-interface evidence | NOT RUN |
| D06 | Are Pilz-owned 11Y4/11Y6/11Y8 outside ordinary board output authority? | Exact field termination and program/output mapping | NOT RUN |
| D07 | Are valve proving contacts mapped to their true physical targets? | Device, sensor and hydraulic evidence | NOT RUN |
| D08 | Is the 11K2 switched L7/L07 domain preserved without a return bridge? | Source-to-load/return continuity and common-cause review | NOT RUN |
| D09 | Is the proportional X2 load return safely identified and rated? | Machine harness inspection, conductor/current-path evidence | NOT RUN |
| D10 | Are duplicate “111” identifiers physically disambiguated? | Signed restricted field trace | NOT RUN |
| D11 | Are stop/hold/pressure/guard/restart propositions independently evidenced? | Stage A A–G plus applicable Stage B; qualified witness plan | NOT RUN |
| D12 | Does any safety reset require a separate fresh intentional start? | Installed safety program, LinuxCNC/HMI/foot-command state transitions and validation plan | NOT RUN |

**All gates are documentary readiness reviews, not physical acceptance tests.** Even a later PASS on D01–D12 would not itself prove the machine-level stop, hold, pressure, guard, occupancy or service isolation propositions.

## Failure-path and human-factor review

A nuisance-trip “fix” that bridges a return, parks CNC OK high, masks a wire-75 fault, uses a spare FPGA output for a Pilz-owned valve, or bypasses a guard is a **design failure**, not a technician success. Make the safe path easy: keyed harnesses, distinguishable safety/normal terminals, visible revision tags, protected test points, correct return wiring, actionable fault messages, and guard access that does not require defeat. Record what operators actually find inconvenient and redesign that friction.

A **good** commissioning screen shows “Pilz request rejected / guard state unknown / valve inhibit mismatch” with the evidence source and non-authority warning; it never reports “RAM SAFE” from a command bit. The correct evidence route is **existing documentation and safe de-energized inspection first**. No energized probing, live short, forced mute, hydraulic pressure release or suspended-ram experiment is authorized by this module.

## Explicit boundaries and scoring

**SOURCE-CONFIRMED:** published Rev 1 design files at the revision identified in the audit. **DOC-CONFIRMED:** general OSHA LOTO and Pilz product-example scope in the audit. **INFERENCE:** fault hypotheses and proposed low-friction design checks. **UNKNOWN:** installed Pilz program, wire semantics, exact valve/final-element behavior, stopping limits, pressure, physical Y1/Y2 hold and rearm. **TEST-CONFIRMED:** none.

Twelve practice cases are **UNSCORED**, twelve gates **NOT RUN**. The independent 2520–25F0 evaluator remains information-separated and outstanding. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed hazardous operation.**

**Next:** qualified restricted evidence on the six Pilz input semantics, wire 75/63/11K2 and physical safety path; then independent review and separately authorized no-person-exposure validation. See [restricted delta card](4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md).


## Current board-source precedence addendum — 2026-10-27
[Second original implementation-source audit](../research/4400_OPB_CUTOVER_02_MAX22216_FOUR_INPUT_GATE_FANOUT_AND_STALE_AUTHORITY_RECONCILIATION_2026-10-27.md) directly checked current `REV1_OUTPUT_INHIBIT_AUTHORITY.yaml` schema v3: the ordinary hardware permit is **four** prerequisites (`PILZ_VALVE_ENABLE_LOGIC && WATCHDOG_OK && FPGA_CONFIGURED && CORE_POWER_GOOD`), **not** the obsolete five-term prose including circular `ENABLE_PATH_HEALTHY`. One physical wire-75 source fans out to a **separate diagnostic input** and the **hardware permit**, which must reach **both MAX22216 ENABLE pins** with local fail-low bias. Field voltage/polarity/conditioning and implementation proof remain OPEN; the safety-interface block is BEHAVIORAL ONLY / NOT SCHEMATIC-READY. The old netlist contract is explicitly quarantined by current board integration authority. **Eight additional negative SOURCE-REVIEW cases F1–F8 are NOT RUN/UNSCORED**, not machine tests or independent evaluation. No safety rating is assigned to the ordinary permit.
