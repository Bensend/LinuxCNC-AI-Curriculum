# 4400 — Reset-edge, power restoration and downstream feedback technician field card

**2026-10-24 | Open-book, paper-only exercise | NOT a machine commissioning instruction or safety release.**

## Objective

Given a relay nameplate, wiring diagram and a sequence of power/input/reset events, distinguish **safety input**, **reset edge**, **safety output**, **feedback contact**, **ordinary CNC start**, and **physical load/energy**. Avoid a “green means safe” conclusion.

**Read first:** [Rockwell MSR142RTP original-source audit](../research/4400_MSR142_RESET_EDGE_POWERUP_FEEDBACK_WIRING_SOURCE_AUDIT_2026-10-24.md). Primary manual: Rockwell 440R-IN089A-EN-P (July 2022), https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440r-in089_-en-p.pdf, pp. 2–4. Pilz PNOZ X start terminology: https://www.pilz.com/en-INT/support/faq/products-solutions/articles/180991. Earlier [asymmetric power matrix](SAFETY_ASYMMETRIC_POWER_RESTORATION_RETAINED_STATE_MATRIX_2026-09-17.md) supplies cross-layer context.

## Technician worksheet — ten distinct decisions

For each case, write: **(a)** what the cited device documentation actually confirms, **(b)** what remains unknown at machine level, **(c)** which independent physical witness would be required, and **(d)** whether exposed operation can be released. Do not invent wiring truth tables or tests.

| Case | Given observation / tempting shortcut | Discriminating question |
|---|---|---|
| RE-01 | Rockwell T-mode safety relay, safety inputs and reset loop closed at restoration. “We have a manual button, so reset cannot happen automatically.” | Does this mode monitor an S33–S34 edge? What happens when both circuits close at power-up? |
| RE-02 | Rockwell R-mode relay, reset contact welded closed before an E-stop is cleared. | What does the manual require of the reset signal? Is an immediate enable proved or disproved for this **specific event history**? |
| RE-03 | Rockwell 440R-xxxxxM negative-edge variant, operator pushes Reset but does not release. | Is the valid edge a press or release? What does this say about deliberate fresh **production** start? |
| RE-04 | Replacement device from Pilz has a “manual start” option; installer reuses the old Rockwell reset links. | Can labels be assumed equivalent? Which exact manual, terminal and edge must be qualified? |
| RE-05 | Relay Y1–Y2 loop closes, all output LEDs green, but hydraulic beam can drift. | Which contacts does the loop observe? Which `PHY-HOLD` evidence is missing? |
| RE-06 | Four-wire dual-channel input is changed to external 24 V signals without revising the safety file. | Which Rockwell cross-loop monitoring claims are no longer justified? Which `CHG/VAL` become stale? |
| RE-07 | Safety controller remains powered; field 24 V to a hydraulic coil disappears and later returns. | Why does unchanged safety status not prove the coil/valve's actual state? Which energy zones remain? |
| RE-08 | LinuxCNC host reboots while safety relay remains enabled and a drive command may be retained. | Why is safety permissive not a new motion command? What prevents stale-command replay? |
| RE-09 | After maintenance, operator cycles E-stop, then removes a personal lock while ram is raised. | Why is a relay reset not physical isolation, residual-pressure proof or mechanical ram restraint? |
| RE-10 | Reset button is hidden behind an inconvenient cover, guard access requires tools, and workers routinely bridge the input. | Which practical redesign makes correct use easier than bypass, without reducing the independent safety function? |

## Reasoning rubric (open book; not a sealed evaluation)

A satisfactory answer must explicitly identify **T no-edge** versus **R edge-monitored** behavior; the **negative-edge release** variant; **Y1–Y2 actuator NC contact feedback** versus load position; topology-dependent cross-loop monitoring; and the **distinct safety-reset / ordinary-start / physical-hold / maintenance-isolation** propositions. The correct disposition for selected OpenPressBrake without actual wiring and physical evidence is **UNKNOWN / HOLD / NOT RUN**, not a guessed PL/SIL or automatic permission.

## Practical architecture checklist

- A conspicuous, locally reachable reset with clear sight of the hazard zone, appropriate to the selected safety design; deliberate fresh production start is a separate action.
- Exact relay part number/suffix and manufacturer revision labeled inside the cabinet; wiring revision and installed reset mode recorded at the device.
- Safety circuit status and output feedback displayed as **narrow diagnostics**, never as proof of zero energy or a held ram.
- Reset circuit protected against easy intentional defeat; make proper guards, service access, test points and approved restraints convenient to use.
- After replacement, a qualified engineer reviews input topology, fault coverage, output contact feedback, supply domains, occupancy and restart behavior; all affected evidence marked STALE until revalidated.

## Evidence record / stop condition

Record `RE-01..10 PAPER ONLY`, author, OEM edition, actual installed device **UNKNOWN**, `IN-03/03a/10/10a UNKNOWN`, `PHY/VAL/PT NOT RUN`. No machine energized, no fault injected, no stopping distance or reaction time measured. A hypothetical paper answer is **not TEST-CONFIRMED**. Do not operate with people exposed to the hazardous zone without a proven minimum independent safety architecture. Experimental machine operation, if ever justified and qualified, must be isolated/remote with everyone outside the danger zone and residual risks documented.
