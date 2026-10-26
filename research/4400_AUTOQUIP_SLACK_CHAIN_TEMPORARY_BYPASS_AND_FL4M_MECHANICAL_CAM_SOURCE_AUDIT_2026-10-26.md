# 4400-SLACK-01 — OEM temporary commissioning bypass and mechanical arrest are different authorities

**2026-10-26 | Original manufacturer-source audit | NON-GRADUATED.** Two **different** Autoquip equipment/manual families; do not merge their features into one imagined machine. No selected OpenPressBrake Autoquip hardware asserted.

## Source scope and frozen question
Why can an otherwise correctly adjusted slack-chain switch make commissioning recovery impossible without a deliberately controlled exception, and what physical mechanism (if any) catches a load if the chain fails? What evidence proves a temporary exception was removed?

1. [Autoquip FLM/FLMC Slack Chain Sensing Switch Installation Instructions, document 35100961 Rev.1, five-page OEM PDF](https://autoquip.com/wp-content/uploads/2018/03/flm_flmc_slack_chain_sensing_switch_installation_instructions.pdf), pp.1,5. File path 2018/03 is not an independently verified issue date.
2. [Autoquip FREIGHTLIFT FL4M Installation, Operation and Service Manual, 830FL4M Version 3.4, April 2017, 101-page OEM PDF](https://autoquip.com/wp-content/uploads/2018/03/830FL4M-V3.4.pdf), printed pp.12–14, 36, 88–90. This is a **different FL4M model**, not proof of installed FLM/FLMC mechanics.
3. [Autoquip OEM troubleshooting index](https://autoquip.com/troubleshooting/), linking these manuals.

## DOC-CONFIRMED findings
**A. FLM/FLMC temporary exception.** The Rev.1 five-page switch installation manual describes normally-open contacts *held closed* by taut chains, opening on slack/break. Its commissioning procedure creates a **recovery deadlock**: once properly tripped, the switch prevents the drive motor from restoring chain tension. The OEM therefore documents a **qualified-electrician temporary bypass** to restore tension, with an explicit instruction to **remove the temporary jumper afterward** (p.5). It also warns that slack-chain conditions require factory assistance. This is not authorization for routine operation with the protective circuit defeated.

**B. FL4M independent mechanical catch.** The distinct April 2017 FL4M manual describes spring-loaded serrated **locking cams** on carriage guide beams: chain slack causes mechanical wedging to arrest downward carriage travel (printed p.12). The same manual describes separate slack-chain sensing switches that cut motor power (pp.12–13), counterweight top switches (p.14), and guarding/interlocks. Thus **electrical motor stop and mechanical carriage arrest are separate physical functions**. The FL4M manual explicitly calls reinforcement bars non-optional for cam load paths (printed p.36) and warns that cam edges wear after engagements (printed p.88); do not transfer its component life/strength to other equipment.

**C. Service/restart authority.** FL4M manual warns against forcing contactors directly in the panel (printed p.90), requiring guard/interlock restoration after repairs, and against personnel accessing a jammed carriage before independent blocking (pp.9,86). Its installation checklist calls for multiple distinct guards, switches, brakes and cams. **A passing sensor continuity check is not a complete load-retention or occupancy-safety case.**

## Failure-path and human-factor analysis (INFERENCE)
| Fault / lifecycle | Electrical path | Physical path | What can go wrong if treated as one bit |
|---|---|---|---|
| Slack chain / carriage jam | Sensor opens, motor stop requested | FL4M mechanical cam is a *separate* catch if installed/healthy | Motor stop does not prove carriage held |
| Bypass applied for supervised recovery | Sensor stop demand temporarily not authoritative in that circuit | Independently engineered support/exclusion must remain effective | A forgotten bypass can silently defeat the next slack-chain detection |
| Chain tension restored | Sensor may return normal | Cam and structural supports require inspection after fault | "Input normal" does not prove physical fault resolved |
| Cam teeth or reinforcement damaged | Sensor may still read normal | Mechanical arrest may not carry required load | Electrical diagnostics miss a structural degradation |
| Direct contactor actuation | Ordinary command path bypassed | Guard/interlock/stop assumptions may be defeated | Treating a manual electrical shortcut as a service mode |

**Practical architecture recommendation, not an OEM retrofit instruction:** prefer a *bounded, controlled service recovery mode* that cannot persist unnoticed: qualified access, independent physical support and exclusion, conspicuous temporary-state indication, restricted motion authority, return-to-normal check and independent verification that no bypass remains. The cited OEM manual's jumper is a historical documented example; this course does **not** provide wiring, pinouts or a procedure for defeating safety devices. Any selected machine requires a qualified safety design and OEM-approved recovery method.

## Provenance/uncertainty
**DOC-CONFIRMED:** OEM exact FLM/FLMC Rev.1 and FL4M v3.4 passages. **SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **INFERENCE:** forgotten-bypass fault, fault-path independence, human-factor recovery design. **UNKNOWN:** selected machine presence of slack chain, cams, support bars, bypass history, actual safety rating/PL, physical stopping and release behavior. No claims about OpenPressBrake hydraulics/Y1/Y2. No live test or bypass operation authorized. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.**
