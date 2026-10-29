# 4400-THC-ANTI-REPEAT-01 — Technician card: both hands released does not prevent a second cycle

**2026-10-29 | OEM-document review only; not a commissioning instruction or machine release.** Companion [original Banner/ISO/OSHA audit](../research/4400_THC_ANTI_REPEAT_01_BANNER_2025_TWO_HAND_TIEDOWN_VS_MACHINE_ANTIREPEAT_POWERUP_SOURCE_AUDIT_2026-10-29.md).

## Recognize the difference

**Anti-tie-down** (the selected two-hand monitor) asks whether both buttons have been released and then actuated together; **anti-repeat** (a separate machine-cycle requirement) asks whether a held command can produce another complete stroke after the first ends. Banner's **AT-FM-10K Rev L, 28-Oct-2025** explicitly says its module **does not provide anti-repeat**. It does require a fresh pair within **500 ms**, and rejects one-hand-held/repress and both-held power-up. These are exact Banner product claims, **not evidence of OpenPressBrake installation**.

## No-energy review prompts

| Condition to examine | Wrong shortcut | What the qualified reviewer must establish |
|---|---|---|
| Both hand controls held after one completed cycle | “Two-hand module is safe; it cannot repeat.” | Separate machine-cycle anti-repeat function; intended behavior and actual witnessed result. |
| One held, other released and pressed again | “Both inputs green.” | Full-release and simultaneous-rearm behavior of selected device. |
| Module powered, electronic buttons unpowered | “24 V is 24 V.” | Banner same-source supply requirement and actual restart/UPS topology. |
| Module output drops within 35 ms | “Hydraulic ram stops in 35 ms.” | Physical final elements, measured stopping and gravity-load holding. |
| Two-hand bar placed where operator can reach the die | “We used the OEM distance table.” | Current ISO 13855:2024, measured total response, reach geometry and controlled placement. |
| Operator must hold the sheet while using both hands on buttons | “Train them not to bypass it.” | Redesign workholding/mode/guarding so the safe method is practical. |
| Another person is behind the machine | “Operator has both hands on controls.” | Separate protective coverage for everyone exposed. |

**Critical OEM warnings:** Banner says anti-repeat is **not** supplied by the module; electronic buttons and the module must share a voltage source; ordinary PLC/PC must not be able to defeat the protective stop; and its 35-ms relay opening time is **not** machine stopping time. Original manual: https://info.bannerengineering.com/cs/groups/public/documents/literature/64137.pdf (printed pp. 8, 13–16, 17–18).

**Standards scope:** ISO 13851:2019 defines two-hand control but does not select a device for every machine; ISO 13855:2024 is the current safeguard-positioning edition. OSHA 1910.217 excludes press brakes despite providing useful mechanical-power-press comparisons.

**Decision:** Without independently validated guarding, safety logic, final elements, Y1/Y2 physical stop/hold and deliberate restart, **do not operate hazardous motion with people exposed**. Isolated/remote experimental operation requires separate approval, people outside the danger zone and residual-risk controls. G0/G1 **HOLD**, external evaluator **OPEN**; no tests performed.
