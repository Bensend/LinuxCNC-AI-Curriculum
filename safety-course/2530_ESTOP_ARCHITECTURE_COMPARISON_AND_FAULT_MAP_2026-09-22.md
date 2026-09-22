# 2530 — E-stop architecture comparison and fault-to-proposition map

Status: learner/source artifact. This advances 2530 while the 2520 information-separated competency gate remains open. It does **not** assign a PL/SIL to a generic topology.

## Why compare implementations

The point is not to pick a favorite safety relay. The point is to learn what each circuit feature actually detects, what it merely commands, and what physical proposition remains unproved.

Use the chain:

`hazard -> required PROP -> E-stop input -> input diagnostics -> safety logic -> output structure -> final element -> feedback/EDM -> reset/rearm -> fresh start -> physical validation`

## Architecture A — Rockwell Guardmaster single-input relay + two safety contactors

**DOC-CONFIRMED.** Rockwell application technique `SAFETY-AT059` connects a dual-channel string of E-stop devices to separate pulsed paths S11-S12 and S21-S22. The relay monitors the pulse stream at each input. Actuation interrupts both circuits. The relay then opens safety contacts and de-energizes two 100S safety contactors, producing a Category 0 coast-to-stop reaction in that specific application.

**DOC-CONFIRMED.** Normally-closed auxiliary contacts from both contactors are placed in the reset path. If a safety contact welds closed, the corresponding mechanically associated auxiliary contact remains open and prevents reset. The example uses monitored manual reset and rejects too-short or excessively long reset-button operation, explicitly addressing unintended/tied-down reset.

Source: Rockwell Automation, *E-stop String Safety Function Application Technique*, SAFETY-AT059, accessed 2026-09-22: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at059_-en-p.pdf

### Reverse fault map

| Feature | Fault hypothesis addressed | What it supports | What it does **not** prove |
|---|---|---|---|
| two E-stop contact paths | one contact/path opens or changes independently | safety demand can still be observed through the architecture assumed by the application | that both paths are physically independent of all common-cause faults |
| distinct pulsed input paths | covered shorts/cross-connections or loss of expected pulse behavior | electrical input-path integrity for faults the relay detects | mechanical operation of the mushroom/contact block; all wiring faults |
| two output contactors | one final switching element may fail dangerously | another allocated switching path exists in the example | motor shaft stopped; stored energy removed; brake applied; contactors truly independent in every application |
| NC contactor auxiliaries in reset path | contactor main contact welded/non-returning where auxiliary linkage correctly witnesses it | contactor returned to expected de-energized state before reset | machine motion stopped, voltage absent everywhere, gravity/fluid energy safe |
| monitored manual reset | reset contact held/tied down or invalid reset actuation | deliberate reset sequence rather than simple maintained permissive | zone clear; original emergency cause corrected; ordinary start authorized |

**INFERENCE:** The strongest lesson is that EDM/feedback is a *specific final-element witness*. It is not a generic physical-safe-state sensor.

## Architecture B — Siemens SIRIUS 3SK1 + contactors / machine safety function

**DOC-CONFIRMED.** Siemens' current *Safety Integrated Application Manual* (02/2025) includes E-stop plus protective-door monitoring using a 3SK1 safety relay and a pair of contactors. The architecture separates the emergency/protective-device inputs, start action, safety relay, and downstream switching elements.

Source: Siemens, *SIRIUS Safety Integrated Application Manual*, 02/2025, A5E03752040020A/RS-AM/012: https://support.industry.siemens.com/cs/attachments/81366718/application_manual_sirius_safety_integrated_en-US.pdf

**DOC-CONFIRMED.** The current 3SK1 equipment manual (11/2025) documents a monitored-start mode and a feedback circuit (`INF`) as distinct signals in the device timing behavior. This matters pedagogically: reset/start monitoring and final-element feedback are separate evidence paths, not one generic 'reset wire.'

Source: Siemens, *SIRIUS 3SK1 safety relays Equipment Manual*, 11/2025, A5E02526190021A/RS-AF/006: https://support.industry.siemens.com/cs/attachments/67585885/manual_safety_relay_3SK1_en-US.pdf?download=true

### Reverse fault map

| Feature | Fault hypothesis addressed | What it supports | What it does **not** prove |
|---|---|---|---|
| two-channel monitored protective input in application architecture | loss/disagreement in allocated input channels, subject to configured/device diagnostic capability | input-side safety demand detection | required machine stopping performance |
| monitored start | inappropriate static/held start behavior covered by the selected mode | intentional valid start/reset transition at the relay boundary | personnel clear or hazard absent |
| feedback circuit | downstream switching device(s) failed to return to the expected feedback state | expected final-element feedback state before enable | the physical process reached a safe state |
| pair of contactors in application | dangerous failure of one switching path is not assumed harmless | redundant allocated energy-interruption elements in that example | that a pair of contactors alone establishes any PL/SIL target |

**UNKNOWN:** The exact diagnostic claim for any proposed real machine depends on the exact 3SK1 variant, wiring mode, sensor/contact arrangement, downstream devices, integrity calculation and validation. Do not generalize the example's published integrity result to a different topology.

## Architecture C — Pilz PNOZ 1 + feedback loop + external contactors

**DOC-CONFIRMED.** The current PNOZ 1 operating manual says the relay provides safety-related interruption and supports E-stop, safety-gate and start-button connections. Internally it uses a redundant circuit with self-monitoring and tests correct relay opening/closing on cycles. It explicitly distinguishes single-channel operation from dual-channel operation and notes that single-channel machine safety level may be lower than the device's own capability.

**DOC-CONFIRMED.** The manual shows automatic/manual start and a feedback loop that can include external contactor contacts. It explicitly warns that automatic start or a bridged manual-start contact can cause automatic startup when the safeguard is reset, requiring external measures against unexpected restart.

**DOC-CONFIRMED.** The same manual warns that when relay outputs are on, mechanical output-contact opening cannot be automatically tested continuously; cyclic operation/checking is required so internal diagnostics can check opening. It also requires safety-function checks after initial commissioning and machine changes.

Source: Pilz, *PNOZ 1 Operating Manual*, 21114-EN-06, current publication accessed 2026-09-22: https://www.pilz.com/download/open/PNOZ_1_Operating_Manual_21114-EN-06.pdf

### Reverse fault map

| Feature | Fault hypothesis addressed | What it supports | What it does **not** prove |
|---|---|---|---|
| redundant/self-monitored relay internals | covered internal component failure | relay safety function remains effective for covered internal faults | external wiring/final-element/process integrity |
| selectable one/two-channel input | application can allocate redundancy where required | explicit architecture choice instead of assuming device rating transfers automatically | all cross-short/common-cause detection; manual states dual-channel mode is without cross-contact short detection for this product |
| feedback loop with external contacts | external contactor/relay not returned as expected | final-element feedback proposition represented by those contacts | shaft standstill, hydraulic pressure state, gravity load holding |
| manual start | separate deliberate start action | prevents simple input restoration from necessarily re-enabling when correctly wired | reset location visibility or personnel clearance |
| required cyclic check | latent non-opening output fault that cannot be continuously tested while energized | periodic opportunity for internal opening diagnostics | arbitrary proof interval for another device/application |

## Cross-manufacturer conclusions

1. **DOC-CONFIRMED:** all three architectures separate the emergency input from downstream final elements; none supports teaching that the mushroom button itself makes hazardous energy safe.
2. **DOC-CONFIRMED:** reset/start behavior is a designed and monitored part of the safety function, not a cosmetic HMI choice.
3. **DOC-CONFIRMED:** feedback/EDM is tied to a specific downstream switching-state proposition. It is not proof of complete machine safety.
4. **INFERENCE:** diagnostic coverage is feature- and fault-specific. 'Dual channel' is not a meaningful standalone diagnostic claim.
5. **INFERENCE:** an architecture can be electrically healthy while the physical safe-state proposition remains `UNKNOWN` because no suitable physical witness exists.
6. **UNKNOWN:** required stop category, stopping time/distance, integrity target, proof interval and physical witness for a real machine remain design-specific.

## Fault-driven learner exercise — improve only when a fault demands it

Start with a generic hazardous motor/process and a single NC E-stop contact driving an ordinary control input. Do **not** assign a PL/SIL.

### Stage 1 — identify the proposition

Write the physical proposition first, e.g. `PROP-ESTOP-01: hazardous motion reaches the machine-defined emergency safe state after an E-stop demand.` The actual state and permitted time are `UNKNOWN` until the machine risk/SRS work defines them.

### Stage 2 — attack the single-channel design

Consider separately:

- input wire shorted to its permissive state;
- input contact welded/stuck;
- ordinary controller output stuck on;
- power-switching element welded;
- reset input held;
- ordinary Cycle Start retained through the emergency event;
- control electronics report stopped while the physical process still coasts or stored energy remains.

For each, record `fault -> dangerous effect -> detectable? -> detection timing -> required reaction -> remaining physical proposition`.

### Stage 3 — add only justified measures

A second input channel is justified only for faults it actually helps tolerate/detect. Test pulses/cross-short diagnostics are justified only for covered wiring faults. Redundant final elements are justified only when final-element dangerous failure must be tolerated. Feedback/EDM is justified only if its contact/state is a valid witness for the relevant final-element fault. Monitored manual reset is justified to prevent inappropriate maintained/tied reset behavior and to enforce a deliberate rearm transition.

The learner must state the uncovered fault after every improvement.

### Stage 4 — common-cause attack

Ask whether the apparently redundant channels share:

- one actuator/contact mechanism;
- one cable/conduit vulnerable to the same damage;
- one 24 V source or common terminal failure;
- one output connector;
- one contactor/mechanical linkage;
- one brake/valve/energy source;
- one maintenance/configuration error.

If yes, record the dependency explicitly. Two wires do not erase a common cause.

### Stage 5 — reset/restart attack

Require distinct states:

`E-stop device released -> input paths valid -> final-element feedback valid -> safety reset/rearm eligible -> deliberate reset accepted -> ordinary controller permitted -> fresh production start demand`

A pre-fault held Cycle Start must not silently become a fresh production demand merely because safety permission returns.

### Stage 6 — physical proof attack

Give the learner a circuit with perfect input diagnostics, perfect relay status and healthy EDM, then state that the motor/process has an unmeasured coast-down or a gravity/fluid-power hazard. Correct answer: the electrical architecture does not prove the machine-level safe-state proposition. Stopping performance/energy state remains `UNKNOWN` until suitable physical evidence/validation exists.

## New freezes

- **TWO INPUT CHANNELS != TWO INDEPENDENT PHYSICAL WITNESSES.**
- **TEST PULSES HEALTHY != E-STOP MECHANISM PHYSICALLY OPERATED.**
- **EDM / FEEDBACK CLOSED != HAZARDOUS MOTION OR STORED ENERGY PROVED SAFE.**
- **MONITORED RESET VALID != ZONE CLEAR != ORDINARY START AUTHORIZED.**
- **REDUNDANT CONTACTORS != COMPLETE SAFETY-FUNCTION INTEGRITY ESTABLISHED.**
- **A PUBLISHED PL/SIL FOR ONE MANUFACTURER EXAMPLE DOES NOT TRANSFER TO A LOOKALIKE CIRCUIT.**

## Next source step

Trace LinuxCNC `estop_latch` at a pinned upstream commit only to define the normal-control/software boundary. Then connect this architecture lesson to physical E-stop span/segmentation and reset-location human factors. Do not turn LinuxCNC/HAL into the personnel-safety authority.
