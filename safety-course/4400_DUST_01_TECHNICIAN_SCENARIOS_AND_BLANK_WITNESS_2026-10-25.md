# 4400-DUST-01 — 12 technician adversarial scenarios and blank selected witness
**2026-10-25 | PAPER / NOT RUN / NOT SCORED / NOT A MACHINE RELEASE**

## Learner scenarios (give reasoning and falsifier; no hidden answer key)
1. LinuxCNC `iocontrol.0.coolant-flood=TRUE` and the shop dust collector is silent. Which proposition does the bit establish? Which physical observations discriminate a disconnected fan from normal control?
2. Fan contactor auxiliary contact is TRUE but a flexible duct has fallen off the moving router. What additional evidence is needed before cutting?
3. A dust-foot retract sensor reports UP during ATC and then DOWN. Does that prove the hood captures dust at the tool?
4. A central collector serves three CNC routers. Router A executes M9 during an E-stop. Why is tying the central fan directly to A's coolant pin potentially unsafe?
5. A clogged filter leaves the fan running. How could both inhalation and fire/collector hazards remain?
6. A spark detector reports fire while the operator suggests forcing fan ON to clear dust. Why can a blanket ON command be hazardous, and who owns the approved response?
7. A novice bypasses a frequently tripping airflow switch with a jumper. Identify the human-factors defect and safer redesign direction; do not prescribe a jumper.
8. A dust collector is installed inside the building. Someone quotes OSHA's 1997 HIB as current permission because the duct is short. What source/edition and local approvals are missing?
9. A material change introduces combustible-metal particles into a wood collection line. Why must the material/collector hazard analysis be reopened?
10. After a power outage the collector restarts, and the CNC still has a queued program. Explain why extraction recovery is not machine-start permission.
11. A maintenance worker shuts the dust system using M9 and opens the collector. What isolation/stored-energy/fire risks remain?
12. During a stop, the spindle coasts and the collector's process-protection system may isolate its duct. How do you prevent both tool exposure and dust/fire propagation without pretending one LinuxCNC bit solves both?

For each scenario require: hazard boundary; command/feedback/physical distinction; one common-cause or bypass path; minimum safe-to-operate decision; evidence classification; a test that would falsify the initial claim. These are teaching prompts, not scored blind evaluation.

## Blank selected-machine / facility witness (qualified team only)
| Evidence ID | Required proposition | Source / exact hardware | Measured or inspected result | Witness/date | Status |
|---|---|---|---|---|---|
| DUST-INV-01 | Actual dust/material/collector/duct/return-air inventory and shared users | UNKNOWN | NOT RUN | — | OPEN |
| DUST-HZD-02 | Qualified combustible-dust and exposure hazard assessment; jurisdiction/edition | UNKNOWN | NOT RUN | — | OPEN |
| DUST-CAP-03 | Hood capture/duct/filter/fan physically effective for selected cutting | UNKNOWN | NOT RUN | — | OPEN |
| DUST-FIRE-04 | Collector location and engineered detection/isolation/vent/suppression where required | UNKNOWN | NOT RUN | — | OPEN |
| DUST-STOP-05 | Loss-of-capture, E-stop and collector-fire actions separately validated | UNKNOWN | NOT RUN | — | OPEN |
| DUST-HF-06 | Accessible cleaning/guard, no incentivized bypass, safe maintenance isolation | UNKNOWN | NOT RUN | — | OPEN |
| DUST-REARM-07 | Independent reset and deliberate fresh CNC start after recovery | UNKNOWN | NOT RUN | — | OPEN |
| DUST-CCF-08 | Shared collector failure/stop cannot silently endanger other machines | UNKNOWN | NOT RUN | — | OPEN |

No simulated data, numeric thresholds, stopping distances, dust combustibility or installed protection is supplied. If a selected machine does not have combustible dust, a qualified inventory can mark dust-specific requirements N/A; ordinary machine stopping/guarding/energy isolation still require separate proof. Do not run hazardous tests with people exposed. Use isolated/remote protected methods only under qualified approved test plan.
