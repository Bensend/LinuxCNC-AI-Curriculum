# 4400 safety design worksheet — mode selection, operator authority and fresh restart

**Learner-facing transfer exercise.** This is not a certified controller design, a wiring diagram, a machine acceptance test or a hidden evaluator answer key. Complete after 2520, 2530, 2590, 25C0 and the cumulative Safety Design Package. Source example: Fiessler FMSC-FP manufacturer brochure doc1872 (2025-10-15), printed p. 5, https://www.fiessler.de/default-wAssets/docs/download/FMSC-Schaltgeraete/prd-fmsc-switching-device-engl-doc1872-comp.pdf ; current product description https://www.fiessler.de/en/products/safety-products/safety-footpedals/safety-foot-pedals-fe-fs.php . The brochure documents four selectable foot-pedal modes and separate selector/pedal/relay diagnostics; no particular machine configuration is supplied.

## 1. Define the mode-dependent hazard proposition before selecting the switch

| Field | Record / linked package IDs |
|---|---|
| `BND/HAZ` machine, task, people, exposure and mode | |
| `SRS` what each person is allowed to initiate, maintain and stop | |
| `PHY` physical safe state required when a person releases/overpresses an input | |
| `AUTH` normal LinuxCNC/FPGA role vs independent safety-related controller | |
| `ARC` selected safety-related mode selector, input receiver and final elements | |
| `DEP` common selector/feedback/power/configuration faults | |
| `HF` visibility, nuisance trips, reset ergonomics, bypass incentives | |
| `VAL/PT` independent mode, stop, reset and physical witnesses | |
| `CHG/UNK/RR` stale evidence, unknown facts and operational restrictions | |

Mode indication in an ordinary HMI is **not** proof of the safety controller's active mode. A mode key or selector being physically present is not proof of correct downstream allocation. Reset acceptance is not a new ordinary start; foot-pedal release alone does not prove the safeguarded space is clear.

## 2. Two-pedal press-brake scenario — explicit authorization contrast

A selected FMSC-FP family permits pedal 1 only, pedal 2 only, OR, or AND according to manufacturer documentation. A machine has two separate operators holding a large workpiece. One operator believes both pedals are required; the selector is set to OR. Fill the abstract OR/AND truth table and explain the hazard of one-person initiation. Then **stop**: without exact selected controller configuration, you cannot infer its internal fault diagnostics, protective output, stopping distance, safe-speed limit, hydraulic response or whether the machine actually moves.

Provide the **minimum evidence** needed before permitting a selected two-person mode: exact selector identity and controlled access; each pedal's terminal and operator mapping; active mode and fault diagnostics from the independent safety-related controller; each person's stop demand; retained-start/rearm behavior; selected physical final element; independent stop/hold witness; protection of workpiece-sweep and helper zones; clear instruction/indication that does not encourage defeat. State the operational restriction until the missing evidence is obtained.

## 3. Transfer to three different machine classes

For each, retain the *same proof structure* but do **not** assume identical physical safety functions:

| Machine/task | Tempting false equivalence | Required distinction to analyze |
|---|---|---|
| Mill/VMC setup with guard open | Jog mode selected = safe speed proved | Selected guard/setup mode, independent speed/stop function if required, tool/spindle energy, axis travel and physical witness; ordinary LinuxCNC jog velocity is not safety-rated speed. |
| Robot teach pendant/enabling device | Enabling device held = safeguarded space empty | Occupancy, enabling-device three-position behavior if selected, safe motion/stop, zone protection and restart after exiting; actual robot safety controller owns personnel protection. |
| Plasma/cutting cell maintenance/test | Torch disabled in LinuxCNC = power isolated | Separate electrical/plasma source isolation, stored energy, fire/fume and motion hazards; production stop is not servicing lockout. |

## 3A. Independent enabling-device transfer (Pilz / Rockwell manufacturer sources)

Pilz's official mode-selector FAQ says that mode selection must not itself initiate operation, each selector position must exclusively enable one mode, and emergency stop retains precedence. Pilz PITenable describes a three-level Off-On-Off enabling device for guarded-zone setup; Rockwell 440J describes optional **separate** jog and E-stop functions. Compare the press-brake pedal's production-stroke request to the robot teach grip's manual-enabling function. For each, identify the *different* selected-machine stop, mode/guard-suspension, occupancy, reset/new-start and final-element requirements. A three-position device does not automatically provide E-stop, safe speed, maintenance isolation or physical standstill. Source audit: `research/4400_SAFE_MODE_SELECTOR_VS_THREE_POSITION_ENABLING_DEVICE_SOURCE_TRACE_2026-10-23.md`.

## 4. Adversarial change/restart review

Mark the affected `SRS/PHY/AUTH/DEP/ARC/VAL/PT` records `STALE` for each material `CHG` until evidence is renewed:

- OR/AND selector position or key/permission changes, but the ordinary HMI mode label is stale;
- second pedal added/replaced with a different contact arrangement, or left/right wiring swapped;
- one working contact sticks, one safety NC contact shorts, or selector diagnostic reports an error;
- a reset button is held during power restoration while an ordinary cycle request remains active;
- an operator is still in a hazardous zone after a guard/field clears;
- stopping/holding device or its feedback is replaced, or tooling/workpiece geometry changes;
- service/bypass mode is exited without independent safeguard restoration.

A valid physical contradiction defeats a controller-status PASS. If physical witness validity is itself uncertain, record `UNKNOWN`, not PASS. Never infer a machine PL/SIL, diagnostic coverage, response time or stop distance from a device brochure.

## 5. Practical usability requirement

For each safeguard, ask whether a worker can understand the active mode, find the failed input, restore the guard/pedal correctly, and rearm without repeatedly defeating safety devices. Propose the smallest practical improvements: visible mode indication verified against independent safety-controller state, guarded selector, clearly labeled pedal/zone identity, captive wiring/fasteners, accessible fault localization, and a release-then-deliberate-reset-then-new-start workflow. These are **design goals**, not claims that a specific architecture has passed validation.

**Operating boundary:** no personnel-exposed hazardous operation until the minimum safety function has been established for the selected machine. Any experiment must be isolated/remote with people outside the danger zone and residual risk plainly recorded. Maintenance energy isolation remains a separate requirement.
