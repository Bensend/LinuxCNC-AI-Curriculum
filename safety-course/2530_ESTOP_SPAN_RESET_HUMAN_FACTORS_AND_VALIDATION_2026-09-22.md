# 2530 — E-stop span, reset human factors, and validation

## Purpose

Emergency stop is a deliberately human-operated complementary protective function. This lesson extends the 2530 fault-driven architecture work into a question that becomes difficult on linked machines and cells: **what does each emergency-stop device actually stop, what must remain stopped, what may continue, and what must a person be able to understand before reset/restart?**

Do not begin by drawing a relay circuit. Begin with the hazard and the physical proposition required after actuation.

## Evidence ledger

### DOC-CONFIRMED — whole-machine span is the default, segmentation is an engineered exception

IDEC's current ISO 13850 guidance summarizes ISO 13850:2015 section 4.1.2: the span of control of each E-stop device covers the whole machine by default. A narrower span may be appropriate when stopping all linked machinery could create additional hazards or unnecessarily affect production. Where multiple spans are used, they must be clearly defined and identifiable, the device must be readily associated with the relevant hazard, the span must be identifiable at the operating position, one span's actuation must not create/increase hazards, and it must not prevent initiation of E-stop in another span.

Source: https://www.idec.com/en-eu/solutions/safety/law/iso-iec/iso13850 (accessed 2026-09-22).

**Engineering consequence:** segmentation is not justified merely because stopping the entire line is inconvenient. The designer must show that the chosen spans preserve the required hazardous-state propositions at interfaces and do not create new hazards in adjacent or coupled equipment.

### DOC-CONFIRMED — devices belong where people may need them

IDEC's ISO 13850 guidance states that E-stop devices are located at operator stations unless risk assessment says otherwise, and at other risk-assessment-derived locations such as entrances/exits, intervention locations, and designed human/machine interaction points. Devices must be directly accessible and capable of non-hazardous actuation.

Source: https://www.idec.com/en-in/solutions/safety/law/iso-iec/iso13850 (accessed 2026-09-22).

Rockwell's 440E Lifeline cable-pull product is an industrial example of the human-factor problem on long or awkward machinery: the cable provides emergency-stop access along/around conveyors rather than assuming one mushroom button is reachable from every exposure point.

Source: https://www.rockwellautomation.com/en-be/products/hardware/safety-products/440e-lifeline-4-cable.html (accessed 2026-09-22).

### DOC-CONFIRMED — reset is local intentional release, not permission to start

IDEC's ISO 12100 summary states that the effect of the E-stop command is sustained until reset, reset is possible only at the location where the E-stop command was initiated, and reset does not restart the machinery; it only permits restarting. IDEC's ISO 13850 guidance also says instructions must require inspection for the reason for actuation before disengagement.

Sources:
- https://www.idec.com/en-us/solutions/safety/law/iso-iec/iso12100
- https://www.idec.com/en-in/solutions/safety/law/iso-iec/iso13850

**Engineering consequence:** `DEVICE RELEASED`, `E-STOP FUNCTION RESET/REARMED`, `ZONE CLEAR`, and `PRODUCTION START AUTHORIZED` are separate propositions. A convenient remote reset that destroys useful local human knowledge can be worse engineering even if it is electrically easy.

### DOC-CONFIRMED — detachable/cableless stations create an active/inactive-device confusion hazard

IDEC's ISO 13850 guidance states that when E-stop devices are installed on detachable or cableless operator stations, at least one E-stop device remains permanently available on the machine, and measures are required to avoid confusion between active and inactive E-stop devices (for example status indication, covering inactive devices, or proper storage).

Source: https://www.idec.com/en-eu/solutions/safety/law/iso-iec/iso13850.

Rockwell's March 2024 MobileView 2711T manual gives a concrete implementation warning: an unwired red/yellow E-stop terminal must be stored where operators cannot mistake it for an effective device; reset must not cause uncontrolled startup; the pendant E-stop does not replace other machine safety devices; and functionality is periodically tested and re-tested after shock/drop exposure.

Source: Rockwell Automation Publication 2711T-UM001H-EN-P, March 2024, https://literature.rockwellautomation.com/idc/groups/literature/documents/um/2711t-um001_-en-p.pdf.

## Span-of-control derivation workflow

For every E-stop device or pull-cord segment, build this trace before wiring:

`DEVICE -> person/exposure location -> hazardous event(s) -> required physical PROP(s) -> affected machine sections -> coupled/adjacent hazards -> span -> final elements -> physical witnesses -> reset location -> restart authority -> validation`

Ask explicitly:

1. From where can a person reasonably need to actuate this device?
2. Which hazardous events can that person observe or experience?
3. What physical propositions must become true after actuation?
4. Which machine sections must react to make those propositions true?
5. Could stopping one section while another continues create a transfer, stored-energy, collision, gravity, fire/process, tooling, or trapped-person hazard?
6. Does another span remain independently operable?
7. Can the person looking at the device identify its span without memorizing a schematic?
8. After actuation, what knowledge is gained by returning to the initiating device for release/reset?
9. What still has to be proved before restart?

## Human-factor design rule

A safety function that is technically correct but predictably confusing or burdensome invites defeat. Make correct behavior the easy behavior:

- put devices where exposure/intervention occurs;
- make span labels visible from the actuator position;
- use durable machine/zone names rather than PLC tag names;
- make inactive detachable E-stops unmistakable;
- avoid reset locations that force blind acceptance of hidden occupancy;
- if a large zone cannot be visually cleared from reset, add an engineered personnel-clearance method rather than pretending the reset button proves emptiness;
- do not make operators walk arbitrary distances merely as ritual if that walk provides no useful hazard observation;
- conversely, do not centralize reset merely for convenience if doing so removes useful local inspection/knowledge.

## Linked-cell counterexample

Consider three linked sections: feeder A, guarded processing cell B, and takeaway conveyor C. A worker can intervene at A/B transfer and another can enter B through a guard. A single line-wide E-stop may be appropriate, but it is not automatically the only safe answer. Three segmented spans may also be possible, but only after proving interface behavior.

If B is stopped while A continues feeding material into a jammed transfer, the B-only span may increase risk. If A's stop removes a support needed to retain a suspended load in B, line-wide stopping may also create a hazard. Neither result can be guessed from topology. The physical process determines the required propositions and therefore the span.

**UNKNOWN until machine evidence exists:** coast-down, stored pressure, gravity response, transfer accumulation behavior, safe distance, braking adequacy, stop category, required PL/SIL, and whether segmentation is acceptable.

## E-stop-specific commissioning / validation matrix

This matrix supplements the generic 2520 validation matrix; it does not replace it.

| Validation target | Required challenge | Evidence / pass proposition |
|---|---|---|
| Every physical E-stop device | Actuate individually from normal operating state | Intended span reaches its required safe-state propositions; device identity recorded |
| Every defined span | Actuate representative devices and observe boundaries | All required sections react; excluded sections do not create/increase hazard; other spans remain able to initiate E-stop |
| Input channel faults | Apply only documented safe fault-injection methods | Covered open/short/cross-channel/discrepancy faults are detected/reacted to as specified; no unsupported DC claim |
| Final-element feedback/EDM | Exercise safe documented feedback fault | Restart/rearm is inhibited as specified; feedback proves only the proposition it physically observes |
| Device release/reset | Release initiating actuator | Hazardous production does not restart merely from release/reset |
| Retained production demand | Hold or recreate Cycle Start / motion request across E-stop and reset | Old demand cannot silently revive hazardous motion; fresh start authorization is required where specified |
| Power cycle during E-stop | Remove/restore control power using safe procedure | E-stop state/recovery behavior matches SRS; power return does not create hazardous restart |
| Detachable/cableless station | Disconnect/store/inactivate station | Inactive E-stop cannot reasonably be mistaken for active; permanent machine E-stop remains available |
| Zone/reset visibility | Place an observer/test marker at plausible hidden location without exposure | Reset procedure does not falsely treat button operation as personnel-clear proof; clearance method works as designed |
| Physical stopping proposition | Perform design-specific safe measurement/test | Actual hazardous motion/energy reaches the required physical state within the established criterion; do not infer from relay/drive status |
| Post-maintenance device change | Change/replace only under controlled test conditions | Device identity, mounting, wiring, span label, diagnostics and physical reaction are revalidated to impact-derived scope |

### Important boundary

`EDM HEALTHY` can support a proposition such as a monitored contactor having returned to its expected feedback state. It does **not** by itself prove spindle standstill, gravity load holding, hydraulic pressure removal, pneumatic exhaustion, personnel clearance, or absence of trapped energy.

## Adversarial learner assessment

For each scenario, produce `HZ -> PROP -> span -> stop strategy -> FLT -> diagnostic -> final element -> EVID -> reset/restart -> VAL`. Label every unsupported physical fact `UNKNOWN`.

### Scenario A — long conveyor with three work positions

There is an operator station at one end, a manual loading point in the middle, and a jam-clearing point near the discharge. One mushroom E-stop exists at the operator station. Determine whether accessibility is adequate and propose a defensible actuator/span concept. Do not invent stopping distance or conveyor coast time.

### Scenario B — robot cell with detachable pendant

The pendant has a red/yellow E-stop but can be unplugged and left hanging on the fence. A fixed E-stop exists at the main panel. Explain the inactive-device hazard, the required human-factor controls, and what reset/restart propositions remain separate.

### Scenario C — segmented linked cell

A feeder, robot/process cell, and takeaway conveyor have separately proposed E-stop spans. Product can bridge the feeder/cell interface. Decide what evidence is needed before accepting segmentation. A correct answer may conclude `UNKNOWN / cannot release for exposed operation` if interface physics are missing.

### Scenario D — 'everything is green'

After E-stop reset, both input channels agree, safety relay diagnostics are healthy, EDM is healthy, safety network is healthy, LinuxCNC is idle, and a Cycle Start input has remained continuously asserted. The spindle's measured standstill state is unavailable after maintenance. Determine which propositions are proved, which are not, and whether restart is permissible.

### Scenario E — gravity/fluid-power axis

E-stop commands an electrical stop path and the valve output de-energizes. No validated machine-specific hydraulic truth table, load-holding proof, or pressure witness is supplied. Explain why neither the stop category nor the physical safe state can be invented and define the measurements/design evidence required before people are exposed.

## New freezes

- **E-STOP SPAN LABELLED != INTERFACE HAZARDS ANALYZED.**
- **ONE DEVICE PER PANEL != ACCESSIBLE EMERGENCY-STOP COVERAGE.**
- **DEVICE RELEASED != ZONE CLEAR != SAFETY FUNCTION REARMED != PRODUCTION START AUTHORIZED.**
- **REMOTE RESET CONVENIENT != RESET HUMAN FACTORS ADEQUATE.**
- **INACTIVE DETACHABLE E-STOP VISIBLE != ACCEPTABLE OPERATOR STATE.**
- **ONE SPAN STOPPED != ADJACENT SPANS PHYSICALLY SAFE.**
- **EDM HEALTHY != PHYSICAL STOPPING PROPOSITION PROVED.**
- **ALL ELECTRONIC STATUS HEALTHY != PERSONNEL CLEAR OR STORED ENERGY SAFE.**

## Lab decision

No simulation or executable lab is justified by this lesson. The unresolved questions are design-specific physical/human-factor questions requiring risk assessment, machine data, inspection, and where appropriate controlled physical validation. Running software merely because compute is available would not resolve them.
