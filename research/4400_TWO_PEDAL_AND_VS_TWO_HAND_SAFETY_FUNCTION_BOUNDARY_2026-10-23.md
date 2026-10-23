# Two foot pedals in AND mode are not a two-hand protective device — 4400 source audit

Date: 2026-10-23. Status: learner-facing documentary/source reasoning; no selected-machine validation. Scope: press-brake operator interfaces and cross-machine transfer.

## The engineering question

A press brake can have two foot pedals and a safety-interface selector offering **pedal 1 AND pedal 2**. Does that prove the requirements or protective effect of a two-hand control? **No.** Concurrence of two foot-switch inputs and the protective use of both *hands* are different propositions.

## Evidence and provenance

1. **DOC-CONFIRMED — manufacturer product capability.** Fiessler FMSC-FP explicitly lists foot-switch 1 only, foot-switch 2 only, OR and AND selection, plus hardware/relay diagnostics and integration with a safety circuit. The public product page does not establish that AND implements a two-hand control or proves operator hand location. Source: https://www.fiessler.de/en/products/safety-products/safety-footpedals/safety-foot-pedals-fe-fs.php
2. **DOC-CONFIRMED — standard scope.** ISO 13851:2019 covers two-hand control devices whose output depends on *actuation by hand*. Its official abstract distinguishes them from enabling devices and hold-to-run devices, and says it does not decide which machine needs which type or the required machine-to-device distance. The 2019 edition was reconfirmed in 2024. Source: https://www.iso.org/standard/70295.html
3. **DOC-CONFIRMED — press-brake hazard.** OSHA's press-brake eTool explicitly identifies accidental cycling from foot pedals and workpiece motion as hazards, and lists two-hand controls among possible safeguarding methods. Source: https://www.osha.gov/etools/machine-guarding/presses/powered-press-brakes
4. **DOC-CONFIRMED — jurisdictional limitation.** OSHA 29 CFR 1910.217(a)(5) expressly excludes press brakes. Its two-hand-control/anti-repeat clauses are useful comparisons, **not automatically binding press-brake requirements**. Sources: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217 and https://www.osha.gov/enforcement/directives/cpl-02-01-025
5. **INFERENCE — non-equivalence.** Even if the FMSC-FP AND mode is wired and configured correctly, it establishes at most the selected interface's two-pedal concurrence proposition. It cannot establish where either operator's hands are, whether either person can reach the point of operation, whether two-person exposure is covered, whether an ordinary cycle command is fresh, or whether a hydraulic final element physically stopped motion.
6. **UNKNOWN — selected machine.** Exact pedal wiring/contacts, selected safety-controller program/firmware, which mode is active, operator stations, guard geometry, stop/hold architecture, response times, safety integrity target, and physical validation remain unverified.

## Do not conflate these three functions

| Function | What is requested/observed | What it cannot prove |
|---|---|---|
| Two-pedal AND | Both selected foot-pedal inputs meet the documented logic for the selected interface. | Two hands occupied, reach prevention, anti-tie-down, safe stop, two-person protection. |
| Two-hand control | Selected device/function requires a defined pattern of two hand actuations and supports a validated protective arrangement. | Another person's protection, machine stopping/holding, maintenance isolation. |
| Ordinary LinuxCNC start | Production sequencing receives a process command. | Personnel-safety permission, guard/field occupancy, fresh safety reset, physical safe state. |

**Freeze:** `TWO FOOT PEDALS AND == TRUE != VALID TWO-HAND SAFEGUARD`. Likewise `TWO OPERATORS CONSENTING != ALL EXPOSED PEOPLE PROTECTED`.

The selected safety architecture must independently own protective-demand evaluation and physical final-element authority. Normal LinuxCNC/HAL/FPGA may display diagnostics and request ordinary cycles, not provide the credited personnel-safety function.

## Adversarial review: questions to answer before any exposed-person operation

| Case | Discriminator | Required evidence/disposition |
|---|---|---|
| One pedal tied down before the other is pressed | Is AND merely steady-state Boolean concurrence? | Selected manual/config and fault response; do not assume anti-tie-down. |
| A released and re-pressed while B stays held | Does the function demand a full release of both? | Selected mode logic and application requirement; UNKNOWN until proven. |
| A operator presses pedal while hands are at die | Does foot concurrence constrain hands? | No; assess separate point-of-operation safeguard and workpiece sweep. |
| Mode changed from AND to OR | Can a single operator now initiate motion? | Record mode authorization, safety architecture and revalidation; stale prior proof. |
| Station B physically unplugged, bypassed or replaced | Is the selected channel genuinely included? | Physical channel mapping and individual station demand proof, not only HMI status. |
| Both pedals held across E-stop reset/power restoration | Can an old process command become live? | Independently validated reset/rearm and fresh-start behavior; no automatic restart assumption. |
| Both pedals released during hazardous motion | Does the actual machine stop/hold? | Physical motion, gravity, pressure and final-element witness appropriate to SRS; no guessed distance. |
| Technician uses pedal AND as replacement for a light curtain | Which hazards and people lose protection? | Reopen BND/HAZ/SF/PHY/SRS; do not credit AND as reach prevention. |

## Traceability insertion

For a selected machine, open or revise `BND-*` (operator count/modes), `HAZ-*` (hand access and workpiece sweep), `SF-*` (actual protective function), `PHY-*` (physical safe state), `SRS-*` (required response), `AUTH-*` (safety versus ordinary cycle ownership), `DEP-*` (pedal/selector common wiring and faults), `HF-*` (defeat incentives), `ARC-*` (chosen guards/ESPE/two-hand/pedal arrangement), `VAL-*` (mode and individual-channel tests), `UNK-*` (machine facts), and `CHG-*` (mode/wiring changes). A mode change invalidates only the dependent proofs but they remain STALE until revalidated.

**Practical human-factors design:** keep foot switches guarded against accidental stepping and easy to position/use; make the currently selected mode unambiguous to operators; use a controlled, understandable mode-change procedure; provide good fault localization so nobody has to defeat a station to find a wiring fault. None of these conveniences replaces the credited independent safeguard.

## Evidence limit and lab decision

No physical tests, simulation, or self-hosted compute were justified: the logical non-equivalence is resolved from manufacturer/standard scope and hazard documentation. Do not infer machine-specific hydraulic truth tables, safety PL/SIL, stopping limits, or foot-pedal circuit diagnostics. If the machine cannot establish its basic protective function, no exposed-person hazardous operation; any necessary experimental operation must be isolated/remote with people outside the danger zone.

Next: incorporate this distinction into the 4400 mode-selection technician worksheet and cumulative Safety Design Package without duplicating the existing two-hand course; review selected Fiessler wiring/manual and actual installed safety program only if authoritative evidence becomes available.
