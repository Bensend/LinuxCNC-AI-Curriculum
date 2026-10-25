# 4400-RESCUE-02 — Haas HPB 2026 power-loss restart, homing and pedal-role source audit
**2026-10-25 | original manufacturer online manual | DOC-CONFIRMED model/edition only | not a rescue instruction**

## Question
Does restoring power after a press-brake emergency leave the ram's position and operator-control semantics reliably unchanged? Can a pedal marked UP also serve another reset function? How should a safety course teach this without assuming a particular retrofit?

## Exact original source
Haas Automation, [Haas Press Brake Operator's/Service Manual, section 5 HPB Operation](https://legacy-aem.haascnc.com/content/haascnc/en/service/online-manuals/haas-press-brake---operator-s--service-manual/5---hpb---operation.html), **Revision A — 08/2026**, inspected 2026-10-25. Relevant headings: “Pre-Operation,” “Machine Power-On/Off,” “Recovering From a Failed Power Down,” “Protective Side Doors,” “Foot Pedal - Basic Operation.” Models in the Haas HPB safety manual are HPB 50-5 and 170-10; exact selected options/firmware remain UNKNOWN. Original [HPB safety section](https://legacy-aem.haascnc.com/service/online-manuals/haas-press-brake---operator-s--service-manual/3---hpb---safety.html) warns that motion is possible with power and no E-stop. The site is an OEM manual, not independent physical test evidence.

## Observations
1. **DOC-CONFIRMED:** the OEM specifically warns that powering down with the ram raised can cause **incorrect position feedback or erratic ram motion at next startup**. It states startup involves an upward homing movement and documents a special recovery context after power loss/incorrect position. This is an explicit **post-power-loss motion hazard**, not evidence of a safe or unsafe selected machine.
2. **DOC-CONFIRMED:** the left foot pedal ordinarily requests UP, and the same pedal can function as **Reset** when required; the right pedal requests DOWN and during bending also acts as cycle-start/feed-hold. A single physical operator device can have multiple documented roles depending on state. **Do not infer** the left pedal directly resets an independent safety controller: OEM text does not establish that wiring or safety authority.
3. **DOC-CONFIRMED:** the manual lists a multistep startup involving E-stops released, RESET, oil pump and separate START. It also requires reset after protective side-door opening or transmitter adjustment. These are **normal OEM operation instructions**, not an independently validated proof of anti-restart or a universal rescue script.
4. **UNKNOWN:** actual safety output logic, retained command behavior, hydraulic load holding, exact homing displacement, unexpected-motion frequency, speed, PL/SIL and independent physical validation.

## Transfer analysis with the separate TRUMPF B35 2023 OEM
- TRUMPF B35 source: E-stop/side/rear guard open deactivates normal beam-UP. Its trapped-person residual-risk instruction refers to UP in another operating context. **DOC-CONFIRMED conditional availability**, not a universal rescue sequence.
- Haas HPB 2026 source: UP pedal may also serve Reset, and the manual warns about unexpected ram behavior after powering off raised. **DOC-CONFIRMED mode-dependent roles and power-loss restart hazard**, not proof of TRUMPF or OpenPressBrake behavior.
- **INFERENCE:** the safe architecture must define a selected state-dependent operator control map, independent STOP/HOLD, separate controlled rescue authority, physical home/position plausibility and deliberate fresh start after faults. A printed pedal label or CNC UI state cannot carry personnel-safety authority.

## Adversarial cut sets (qualitative; no probability claims)
- Power loss with ram raised + lost/incorrect position reference + automatic or mistaken homing request + person in reach zone.
- Entrapment + operator sees “UP/Reset” on a shared pedal + ambiguous current state + unintended control transition.
- Guard opening + reset/reenable + retained ordinary motion request + no independent clear-zone/fresh-start check.

## Verification needed (not performed)
For any selected machine: inspect OEM edition/firmware and actual pedal wiring/state semantics, all power-loss and safety-stop conditions, independent position/holding, homing/return-to-reference strategy, guard/access scope and post-rearm new-start proof. Design a safe unoccupied external physical test only after documentary G0/G1 prerequisites and qualified approval. No live human entrapment, guessed hydraulic truth table or generic power-cycle recovery.

**Evidence:** DOC-CONFIRMED OEM edition; INFERENCE general failure pathways; UNKNOWN selected OpenPressBrake; TEST-CONFIRMED none; SOURCE-CONFIRMED new LinuxCNC code none; COMMUNITY-REPORTED none.