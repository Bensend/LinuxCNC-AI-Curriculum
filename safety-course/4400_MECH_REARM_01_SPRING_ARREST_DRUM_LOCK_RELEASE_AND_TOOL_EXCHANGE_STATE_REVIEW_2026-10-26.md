# 4400-MECH-REARM-01 — Mechanical "reset" can release stored spring energy

**2026-10-26 | Original OEM-source-derived state/failure-path review | PAPER ONLY / NON-GRADUATED.** This is **not** a step-by-step instruction for changing or servicing an actual balancer. No selected machine evidence or physical tests.

## Evidence anchor
[ENDO KOGYO EWF/ELF BMU-0002 (June 2021)](https://endo-kogyo.co.jp/pdfs/ja/spring_balancer/standard_spring_balancer/instruction/001_JP_EN_User_BMU-0002.pdf): §4-3-2 spring-rupture arrest (English p.22), §4-3-3 drum lock (p.23), §5-2-2 unloaded rope retraction (p.25), §6-3 drum-lock activation/release (p.28), §6-4-3 same-mass tool replacement (p.29), §7-1/7-2 fault handling/arrest release (p.30). See [primary OEM audit](../research/4400_ENDO_EWF_ELF_FALL_ARREST_TOP_SUSPENSION_ROPE_AND_DRUM_LOCK_SCOPE_AUDIT_2026-10-26.md).

## State model: what the mechanical device can do versus what a person may assume
| State | Source-supported fact | Wrong inference | Safe engineering disposition |
|---|---|---|---|
| **S0 — tool loaded, operating** | Spring balances within OEM capacity range; rope/drum/hook still require inspection | Balanced means mechanically isolated | No work beneath load; monitor wear and installation |
| **S1 — internal fall-arrest activated** | Can be triggered by spring rupture or too-low tension; drum movement inhibited | Device is permanently safe and tool cannot fall under any other failure | Identify trigger and intact load path; do not treat it as personal lockout |
| **S2 — drum manually locked** | Drum lock is used for limited OEM tool/rope replacement operations | Lock secures the whole support chain or permits personnel under tool | Distinguish spring/drum lock from rope, hook, hanger and personal energy isolation |
| **S3 — tool removed or mass changed** | Stored spring energy remains; OEM warns against release unloaded or with wrong mass | Removing tool removes all hazard | Rapid rope retraction and falling load remain possible |
| **S4 — release requested** | OEM explicitly warns of retraction/fall if released with unloaded or changed tool; §7-2 requires fault-specific action | "Reset" is harmless because motion control is disabled | Qualified recovery only under OEM procedure, exclusion and independently supported load |
| **S5 — returned to service** | OEM requires inspection/appropriate load/tension; release can restore movement | Green status means safe restart for people | Separate mechanical integrity, personnel clearance, safety reset and fresh ordinary start |

**DOC-CONFIRMED:** the cited OEM behavior/restrictions. **INFERENCE:** abstract S0–S5 state names, physical-personnel boundary, and process design. **UNKNOWN:** actual selected machine, spring energy, fault cause, attachment, tool mass, verified support and operator exposure.

## Adversarial transitions
- **S1→S4 without fault diagnosis:** a "reset" may undo a restraining mechanism while the spring is ruptured or tension is incorrect. The source instructs fault-specific recovery, not universal reset.
- **S2→S3→S4 with changed tool mass:** OEM prohibits same-lock shortcut for a different mass; the hazard is rapid retraction or falling tool.
- **S0→S3 without positively restrained drum:** an unloaded rope may retract rapidly; a motor E-stop does not prevent it.
- **S1 with broken lower rope:** spring-rupture drum arrest and upper backup cannot by themselves hold a mechanically detached tool. Do not equate "arrested drum" with "tool retained."
- **S5 after top-hanger change:** auxiliary chain, independent anchor and hook/latch require reinspection; an unchanged LinuxCNC program says nothing about this physical change.

## Human-factor correction
A safe tool-change station should put the supported tool at an accessible height, make positive engagement and load identification visible, use captive/labelled restraints, avoid reaching beneath suspended weight, and provide simple service instructions matched to the exact OEM. Never make a mechanic hold a load with one hand while operating a lock with the other. If a reset path is easier than the safe recovery path, redesign the interface and fixture; do not merely add warnings.

## Transfer to LinuxCNC and press-brake safety
Ordinary LinuxCNC/FPGA controls may display "BALANCER ARRESTED", "TOOL PRESENT", or "SERVICE MODE" if appropriately instrumented, but they do not provide the physical arrest. The independent safety-related controller may inhibit hazardous actuation, but stored spring/gravity energy persists. A press-brake ram's hydraulic holding and Y1/Y2 stop remain separate, **UNKNOWN** and not established by any ENDO component. This review applies to a selected machine **only if** its actual installed mechanical mechanisms match the evidence.

## Validation and uncertainty
No fault injection, dropped-tool test, drum release or energized service action is authorized. A qualified reviewer must obtain selected OEM/model, structural path, access map, and approved no-exposure acceptance method before any physical verification. **TEST-CONFIRMED none; SOURCE-CONFIRMED new LinuxCNC none; COMMUNITY-REPORTED none.** External fresh evaluation not run. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.