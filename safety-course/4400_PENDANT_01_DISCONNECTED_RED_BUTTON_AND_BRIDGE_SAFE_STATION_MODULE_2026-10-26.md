# 4400 PENDANT-01 — A disconnected red E-stop can be a false promise

**Status:** NON-GRADUATED documentary safety module; 2530/2520/2590 and 4400 RAD-02 prerequisites. No selected-machine proof.

## Learner objective
Given a tethered portable HMI, distinguish its **physical presence**, its **active membership in the safety circuit**, the connector/box's **unplug response**, the availability of **another reachable E-stop**, and the machine's **physical stop/hold and deliberate restart**. Do not infer one from another.

## Original-source contrast
- Siemens Mobile Panel 170 **Basic**: unplugging opens the stop loop.
- Siemens Mobile Panel 170 **Plus**: unplugging automatically closes the loop, even when the panel's STOP was pressed. Manufacturer warns stop status may be released.
- Rockwell 2711T-JUMP/2711T-22JUMP: OEM-designed bridge accessories allow the machine to operate without a MobileView pendant, but Rockwell explicitly requires another E-stop. This is not permission for improvised bypass.
- Rockwell G750: an unconnected pendant must be kept away from operators; pressing a nearby inactive button in an emergency can be fatal. A dropped terminal requires safety-device testing.

Sources and exact editions: [manufacturer audit](../research/4400_SIEMENS_ROCKWELL_DETACHABLE_PENDANT_ESTOP_BRIDGE_AND_FALSE_AVAILABILITY_OEM_AUDIT_2026-10-26.md).

## Five questions before trusting a pendant
1. **Which station is active?** A nearby screen is not proof.
2. **Which stop circuit is actually connected?** Red mushroom is not an electrical membership witness.
3. **What does unplug/bridge do?** Basic, Plus and bridge behaviors are different.
4. **Where is the always-available independent E-stop?** It must be reachable for the actual work/exposure.
5. **Can reconnect, unplug or reset restart motion?** Require separate deliberate fresh authorization and physical safe-state proof.

## Human-factors design
Provide a visible active-station indicator *as diagnostic information only*, fixed accessible emergency-stop stations, a storage cradle outside operating reach for disconnected panels, connector compatibility controls, unambiguous labeling and a simple documented handoff. Avoid nuisance-prone procedures that predictably encourage operators to leave inactive pendants in reach or bypass interlocks. Never treat a LinuxCNC status widget or connected Ethernet as independent safety proof.

## Cross-machine transfer
Press brake: Y1/Y2 gravity holding and hydraulic isolation remain separate. Robot/cell: entry visibility, trapped-person and multi-station reset authority. Mill/lathe: spindle coast and door/access. Conveyor: remote stations and fixed cable pulls. Every selected system requires its own hazard analysis and OEM-specific connector behavior.

## Competency and gate
Work [10 public unscored cases](4400_PENDANT_01_TEN_UNSCORED_DISCONNECTED_STOP_CASES_2026-10-26.md) and [8 documentary gates](4400_PENDANT_01_EIGHT_GATE_STATION_AVAILABILITY_REVIEW_2026-10-26.md). No live connector manipulation or energized bypass is authorized. **DOC-CONFIRMED** manufacturer behavior, **INFERENCE** architecture recommendations, **UNKNOWN** OpenPressBrake selected equipment. G0/G1 HOLD; independent evaluator NOT RUN; no TEST-CONFIRMED.

## Uncertainty / graduation
Exact station layout, selected connector generation, safety circuit, machine-specific reset/rearm, PL/SIL and physical stop/hold are all blockers for selected-machine release. The general lesson survives different hardware, but no physical claim may graduate without qualified evidence.
