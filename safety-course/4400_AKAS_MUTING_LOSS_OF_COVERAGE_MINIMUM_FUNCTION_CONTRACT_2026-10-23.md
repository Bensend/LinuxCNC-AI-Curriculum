# 4400 — AKAS-5M muting: minimum replacement-protection contract

**Original 4000 safety architecture worksheet, 2026-10-23.** Based on the manufacturer's AKAS-5M 2024 instructions; not an as-built hydraulic/laser design, safety-rated code, or test authorization. This worksheet complements (but is **not an exact archival publication of**) the six pending source files. Use with 2590 guarding, 2580 hydraulics and the selected-machine `IN-01..10` intake.

## The narrow question

When a press brake's front laser field is deliberately muted to permit a box flange or small workpiece, **what is protecting the operator during that interval?** “OSSD ON” and “slow speed requested” are not answers. A selected machine must identify the *replacement* protection for the precise task and all exposed zones.

## Source trace (DOC-CONFIRMED, one product/edition)

Fiessler **AKAS-5M Operating Instructions, document 1581, revision 2024-02-15**, https://www.fiessler.de/default-wAssets/docs/download/AKAS/bdh-akas-5-original-engl-doc1581-v1.0.pdf:

- Printed **p. 4**: the manufacturer's text explicitly states that protection is cancelled with the muting lamp on; E3–E6 do not protect the operator-front region in box-bending mode.
- Printed **p. 5**: for its specified integration, the manufacturer requires independently assured slow closing during muting and separates the safe blanking-test signal **SSP** from the machine's **SP**; product-specific numerical thresholds and sequencing must **not** be copied to other machines/variants.
- Printed **p. 11**: in box mode E3–E6 are muted, initially E1/E2 remain; later receiver elements can all be muted. It warns that a finger beside a large die can escape detection. Foot-pedal release/reapplication can allow a conditional slow stroke after an interrupted field; this is not general restart approval.
- Printed **pp. 24–26**: integration separates **SGA** fast/slow request, **SGS/SGO** slow-position feedback, safety distance/blanking verification, and **OSSD1/OSSD2** safety outputs. A request for slow motion is not proof of actual safe motion. Manufacturer wording says the ordinary response to the SGA request need not itself be safety-oriented while independent safe slow-motion assurance is required.
- Printed **p. 43**: the manufacturer's inspection sheet defines selected-product testing, not an independently measured machine's present stop/hold proof.

The manufacturer manual is **not** an installed machine safety certificate. Its category, speed, distance, timing and overrun statements are product/edition-specific. Do not invent or transpose a universal safe-speed threshold, PL/SIL, stopping distance, sensor timing, hydraulic truth table or force limit.

## Replacement-protection allocation matrix (INFERENCE)

| Protection proposition | What is lost in the muting transition | Required independent authority/evidence | Wrong substitute |
|---|---|---|---|
| Front finger detection | One or more laser elements intentionally no longer monitor the former field | Selected tooling, hand location and guarded zone; alternate means for reachable crushing point; documented permissible mode/task | Green OSSD or lit muting lamp |
| Actual slow motion | The normal machine controller may be told to slow | Safety-related actual-motion sensing, mode/speed logic and final-element response, justified for selected machine | LinuxCNC trajectory speed, SGA request or valve command |
| Correct transition position | Blanking/muting must occur only at justified position and sequence | Independent qualified distance/position witness and correct SSP/SP/HUSP ownership | NC coordinate alone or an HMI “box mode” bit |
| Stop after intrusion/fault | A muted beam cannot detect intrusion in that zone | Independent safety stop demand for remaining hazards and measured final-element + ram response | OSSD ON or pressure switch alone |
| Gravity-load holding | Low commanded velocity is not zero ram force or restraint | Independent holding/anti-drop architecture and physical position/restraint witness | Motor off, valve feedback, no commanded movement |
| Fresh rearm | Mode may survive an HMI screen change, power event or tool swap | Independent safety-mode change/restart logic; reset not start; new deliberate ordinary start | Reapplying a held foot pedal or software reset |
| Secondary hazards | Laser at die does not cover sheet sweep, side/rear pinch, backgauge or ejecta | Task-specific guarding, reach/occupancy and workholding review | A point-of-operation guard's component rating |

## Adversarial design review

**Scenario A — box flange:** the front beam is muted to avoid nuisance stops. A hand can now enter the previously monitored region. The integrator must name an actual alternative safety function, verify hand/task geometry, and establish physical stopping/holding. A product's ability to enter box mode is **not** evidence of operator protection.

**Scenario B — slow commanded, fast actual:** a proportional valve sticks while the normal FPGA reports the requested slow trajectory. The independent safety-related speed/position monitor must detect and react to the discrepancy through its validated final elements. Without this architecture, exposed-person operation must not proceed.

**Scenario C — tool change:** after replacing a die, the old blanking position and stop distance are still displayed. The selected geometry/overrun evidence becomes STALE. Requalify the relevant safety function before restoring the mode.

**Scenario D — shortcut incentive:** workers tape over a sensor because small parts cause repeated interruptions. Record the legitimate task, then design an approved fixture, correct mode or accessible safeguarding arrangement; do not simply suppress diagnostics or make the bypass permanent.

**Scenario E — held pedal after reset:** an operator releases and re-presses the foot pedal after interruption, but the safety system has not established deliberate fresh authorization. The manufacturer documents a conditional product behavior; it does **not** waive machine-level restart inhibition, occupancy clearance or actual stop/hold proof.

## Required selected-machine evidence record

Use a row for each permitted task/mode: **tool/die/stock envelope; accessible body locations; exact AKAS variant and firmware; receiver field elements active/muted at each transition; SSP/SP/HUSP/SGA/SGS/SGO/OSSD safety versus normal-control owners; independent speed and position sensor/fault assumptions; safety final elements and mechanical/hydraulic restraint; independently measured stopping/holding; retained-command reset/restart logic; human-factors/defeat review; qualified test fixture and independent reviewer; change-control signature**.

Treat any UNKNOWN safety owner, absent independent motion witness or uncovered reachable hazard as **HOLD**, not a candidate for exposed-person testing. If no minimum safe-to-operate design is available, only isolated/remote experimental work with people outside the danger zone and an approved residual-risk plan is permissible.

**Evidence:** Fiessler interface and warning statements DOC-CONFIRMED for doc 1581 (2024-02-15); matrix/failure analysis INFERENCE; actual machine configuration UNKNOWN; TEST-CONFIRMED none; `VAL/PT` NOT RUN; 2520–25F0 external evaluations OPEN.