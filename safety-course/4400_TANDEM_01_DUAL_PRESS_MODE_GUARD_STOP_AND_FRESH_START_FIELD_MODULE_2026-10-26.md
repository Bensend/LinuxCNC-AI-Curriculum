# 4400 TANDEM-01 — two press brakes, one workpiece: field module

**Status:** NON-GRADUATED, **12 PUBLIC PAPER scenarios UNSCORED**, **12 documentary gates NOT RUN**. No selected tandem press brake, physical test, independent evaluation or PL/SIL claim. Prerequisites: [original TRUMPF/Accurpress tandem source audit](../research/4400_TANDEM_01_TRUMPF_ACCURPRESS_MODE_DEPENDENT_GUARD_AND_DUAL_RAM_STOP_AUDIT_2026-10-26.md), 2520 hazard-to-SRS, 2590 safeguarding, 4400 Y1/Y2 hydraulic stop/hold and machine-change/restart lessons.

## The trap

**One long sheet is not two independent jobs.** When a press brake switches from two stand-alone workstations to one tandem bending station, the **hazard geometry and personnel-safety boundary change**, even if the ordinary CNC only changes a selector bit. TRUMPF's original TruBend 8000 announcement documents a separating door in stand-alone mode that retracts for tandem mode, with the two BendGuard systems interconnected. Accurpress documents a controller tandem selector. Neither source publishes the complete safety logic/stop truth table.

## Operator-visible architecture (NOT a wiring diagram)

```text
  STATION A            PHYSICAL SEAM / LONG SHEET          STATION B
  ram A + guards  <---> workpiece coupling <--->          ram B + guards
  local E-stop          separating door (mode-specific)     local E-stop
        \                      |                          /
         \------- [qualified INDEPENDENT safety logic] --/
                        |                |
                   A final elements   B final elements
                        |                |
                physical A stop/hold  physical B stop/hold

  LinuxCNC/FPGA/HMI: normal motion + status only, NOT final safety authority.
```

## Twelve public paper cases — all UNSCORED

| ID | Adversarial situation | Learner must identify |
|---|---|---|
| TAN-P01 | CNC selector says TANDEM but separating door has not completed its required movement. | Physical door state and safety-zone transition gate; no motion based on selector alone. |
| TAN-P02 | Two Y-position displays agree; B's hydraulic stop final element is unproven. | Ordinary position match is not independent physical stop/hold proof. |
| TAN-P03 | Operator at B breaks B light field while long sheet spans both presses. | Required hazard-zone stop behavior for BOTH machines, not an assumed single-machine reaction. |
| TAN-P04 | A's E-stop drops A pump but B continues a bend. | Mechanical coupling/part sweep, independent B stop/hold and selected design fault analysis. |
| TAN-P05 | Tandem link drops but each controller retains last trajectory. | Fault-response allocation, stale command inhibition, independent safety authority and physical witnesses. |
| TAN-P06 | Switch TANDEM→SINGLE while a long sheet still bridges tools. | Remove/secure workpiece, prove separation and both local safe states before mode release. |
| TAN-P07 | Barrier is closed but a technician can enter from the back around it. | Full perimeter/whole-body access and restart prevention, not only barrier contact. |
| TAN-P08 | One press is in service/LOTO, the other shows READY. | Multi-machine energy isolation, shared tooling/stock and trapped energy; no service under hazardous operation. |
| TAN-P09 | A's safety controller shows `STOPPED`; a long sheet is unsupported. | Workpiece gravity/elastic energy and separate physical support witness. |
| TAN-P10 | Two foot pedals remain pressed during a mode transition; HMI displays a fresh green READY. | Deliberate new start, release-to-rearm and local operator ownership, not retained input. |
| TAN-P11 | A short job uses only A while B's guard is removed for maintenance. | Define whether B can be safely isolated; exact selected-machine safety-zone dependency required. |
| TAN-P12 | OEM marketing says `BendGuard systems connected` and installer assumes PLe. | Product-level evidence is not a system PL/SIL claim; demand selected device architecture and validation. |

## Twelve documentary gates — all NOT RUN

| Gate | Evidence needed before engineering release |
|---|---|
| TAN-G01 | Private selected-machine identification and actual SINGLE/TANDEM capability; mark N/A if absent |
| TAN-G02 | Exact selected OEM installation/safety manual, control revision and machine arrangement |
| TAN-G03 | Workpiece/ram/tool geometry and shared swept/pinch/strike regions for all modes |
| TAN-G04 | Physical separating door, guard/interlock and whole-body access geometry, both stations |
| TAN-G05 | Actual mode-selection input, independent mode authorization and transition sequence |
| TAN-G06 | Safety input coverage from both E-stops/guards/optical systems for each relevant mode |
| TAN-G07 | Independent safety logic topology, supply/communication/diagnostic common-cause review |
| TAN-G08 | Actual A/B final elements and independent Y1/Y2 physical stop/hold witnesses |
| TAN-G09 | Sheet support, mechanical coupling and asymmetric-stop/energy-release analysis |
| TAN-G10 | Fault/maintenance/mode-switch/LOTO/recovery and retained-start challenge plan |
| TAN-G11 | Qualified safe commissioning/validation protocol, including witness instrumentation and acceptance criteria derived from selected design |
| TAN-G12 | Signed change-control and independent competency evaluation; evidence freshness/revalidation |

**These are desk gates, not instructions to operate or fault-inject a machine.** G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed hazardous operation while the minimum safe-to-operate threshold is unproved. Isolated/remote investigation, if separately authorized, keeps all people outside the danger zone and acknowledges residual risk.

## Human-factors acceptance

Both stations should unmistakably show **who owns start**, **which mode is active**, **which physical barrier/guards are required**, **why a changeover is inhibited**, and **what independent physical conditions remain unproved**. Use convenient guarded parking, accessible controls, clearly labeled station ownership, and a simple fresh-start sequence; avoid a setup that predictably encourages bypassing the separating door. A status indicator must not be misrepresented as a safety-rated witness.

## Handoff / evaluator boundary

For a fresh evaluator, give the learner this module and the OEM audit but **not** an unseen scoring key. Ask for a novel scenario in which the physical barrier reports CLOSED, A and B disagree on mode, and a worker is at the center seam. Require a precommitted hazard map, safety-function allocation, fail-safe default, evidence request and UNKNOWN/HOLD disposition. An independent evaluator must create and score the actual unseen challenge; this prompt is public and is **not blind**. [Evaluator preparation](../evaluation/4400_TANDEM_01_INDEPENDENT_MODE_SWITCH_AND_SHARED_WORKPIECE_HANDOFF_2026-10-26.md).
