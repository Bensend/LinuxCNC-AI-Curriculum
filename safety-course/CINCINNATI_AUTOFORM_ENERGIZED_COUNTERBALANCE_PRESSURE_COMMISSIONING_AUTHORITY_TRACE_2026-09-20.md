# Cincinnati AUTOFORM energized counterbalance-pressure commissioning authority trace

Date: 2026-09-20

## Question

What does a real hydraulic press-brake OEM procedure look like when hydraulic energy must intentionally remain present so a technician can measure and adjust a hydraulic function, and what safety/authority boundaries can legitimately be learned from it without inventing an OpenPressBrake procedure?

This study continues the controlled-energy diagnostic branch. It does **not** define OpenPressBrake pressures, modes, speeds, valve truth tables, PL/SIL/category, or a generic maintenance bypass.

## Primary source

Cincinnati Incorporated, *90-350 AUTOFORM CNC Forming Center with PC Control*, EM-494 (N-01/03), Section 9, "Checking & Setting Hydraulic Pressures," especially pp. 9-6 through 9-7 as rendered in the available manual copy.

Accessible text copy used for source tracing:

- https://www.scribd.com/document/1014945953/em-494-n-01-03-cincinnati-90-350-autoform-cnc-forming-center-with-pc-control

Relevant source region in the accessible rendering: lines approximately 2962-3071.

Evidence class: **DOC-CONFIRMED** for what the OEM manual explicitly instructs. The public copy is a third-party rendering of an identified Cincinnati OEM manual; preserve that provenance limitation rather than silently treating the hosting site as the OEM.

## OEM procedure reconstructed

### 1. Measurement hardware and physical configuration

The manual identifies two counterbalance pressure test ports (#3), one for each side, and explicitly says **both must be checked**. It instructs installation of a 0-600 PSI pressure gauge using the quick-disconnect test port and says not to leave the gauge permanently attached.

The same procedure explicitly requires that **no dies be installed** for this check.

Evidence: **DOC-CONFIRMED**.

This is a useful human-factors pattern: remove an unnecessary crushing/tooling variable before deliberately energizing the hydraulic system for measurement. It is not evidence that "dies removed" alone makes the die space safe for personnel.

### 2. Ordinary production authority is deliberately narrowed

Before energizing the machine, the procedure specifies the operator-control configuration rather than leaving every normal station active:

- Palmbutton Operator Station 1 ON;
- Palmbutton Operator Station 2 OFF;
- Footswitch Station 1 OFF;
- Footswitch Station 2 OFF;
- MODE SELECT set to STROKE;
- OPERATOR CONTROL selector ON.

Evidence: **DOC-CONFIRMED**.

This is not a modern functional-safety validation by itself, but it is direct OEM evidence that an energized hydraulic maintenance/adjustment task can have an explicit **control-authority contract** rather than a generic "maintenance bypass."

Freeze:

`HYDRAULIC ENERGY PRESENT != ALL ORDINARY OPERATOR STATIONS AUTHORIZED`.

`MAINTENANCE/ADJUSTMENT TASK ACTIVE != FOOTSWITCH PRODUCTION AUTHORITY REQUIRED`.

### 3. The task requires intentional machine energization and commanded motion

The OEM then instructs the technician to turn the main disconnect ON, start the main drive, select QUICK BEND, enter a prescribed program, start the cycle, and use the palmbutton station to calibrate the ram. A further Cycle Start puts the machine into CYCLE ACTIVE.

Counterbalance pressure is measured **while the ram is running down**.

Evidence: **DOC-CONFIRMED**.

This closes the current branch's main evidence gap: this is a hydraulic press-brake OEM procedure in which hydraulic energy and actual ram motion intentionally remain present because the quantity of interest cannot be measured from an isolated/depressurized machine.

Freeze:

`ENERGY ISOLATED FOR SERVICE != ENERGIZED MEASUREMENT STATE`.

`ENERGIZED MEASUREMENT STATE != NORMAL UNRESTRICTED PRODUCTION STATE`.

`CONTROL COMMAND ISSUED != PRESSURE PHYSICALLY MEASURED AT TEST PORT`.

### 4. The witness is physical hydraulic pressure, not a controller bit

The measurement witness is a pressure gauge physically connected to the identified counterbalance test port. The pressure is observed while the ram moves down. The manual gives machine-size-specific target values and directs consultation with Cincinnati for configurations such as wide rams, extensions, or very heavy upper dies.

Evidence: **DOC-CONFIRMED**.

For this curriculum, the important transferable lesson is not the numeric pressure table. It is the witness boundary:

`SOFTWARE/HAL PRESSURE COMMAND != TEST-PORT PRESSURE WITNESS`.

`VALVE COMMAND != HYDRAULIC STATE PROVED`.

The numeric Cincinnati values are machine-specific and **must not** be transplanted to OpenPressBrake.

### 5. Adjustment is followed by cycling and bilateral recheck

If pressure is incorrect, the manual directs adjustment of the counterbalance valve and retightening of the locknut. After setting pressure, it requires cycling the ram a number of strokes and then **rechecking both counterbalance pressures**.

Evidence: **DOC-CONFIRMED**.

This is stronger than a one-shot adjustment witness. The OEM deliberately asks whether the setting remains acceptable after subsequent machine motion and whether both sides remain correct.

Freeze:

`ADJUSTING SCREW SET != LOCKNUT SECURED != SETTING STABLE AFTER CYCLING != BOTH SIDES RECHECKED`.

This corroborates the earlier AUTOFORM counterbalance/drift study but places the finding in the full energized diagnostic sequence.

### 6. The procedure has an explicit de-energization endpoint

After the measurement/adjustment/recheck is complete, the manual instructs turning the motor/pump OFF and removing the pressure gauge.

Evidence: **DOC-CONFIRMED**.

This matters architecturally: the energized authority is task-bounded. The fact that energy was needed for the test does not imply that the energized diagnostic state should persist after the measurement need ends.

Freeze:

`DIAGNOSTIC COMPLETE != CONTINUED ENERGIZED DIAGNOSTIC AUTHORITY JUSTIFIED`.

## Relationship to isolated valve service

Immediately later in the same maintenance section, Cincinnati states that the manifold-mounted hydraulic control valves can be removed for service/replacement, but **whenever servicing these valves the ram should be blocked, all power turned OFF, and the electrical disconnect locked**.

Evidence: **DOC-CONFIRMED**.

This gives a particularly useful within-one-OEM contrast:

- pressure measurement/adjustment: intentionally energized and motion-producing because the physical pressure witness requires it;
- valve removal/service: ram blocked, power OFF, disconnect locked.

Freeze:

`SAME HYDRAULIC SYSTEM != SAME ENERGY-CONTROL METHOD FOR EVERY TASK`.

`MEASUREMENT REQUIRES ENERGY != DISASSEMBLY MAY REMAIN ENERGIZED`.

`CONTROLLED ENERGIZED DIAGNOSTIC != EXEMPTION FROM PHYSICAL ISOLATION FOR DISASSEMBLY`.

This is the concrete task/hazard/precondition distinction the curriculum should teach instead of a single "maintenance mode" concept.

## What this source does NOT prove

The manual excerpt does **not** establish all of the desired modern safety-chain details. Preserve these as **UNKNOWN** rather than filling them by inference:

1. It does not state a modern PL/SIL/category for the procedure or controls.
2. It does not document a three-position enabling device or safely limited speed function for this task.
3. It does not explicitly state a personnel-exclusion boundary or a named safe technician standing position during the pressure measurement. `No dies installed` is not equivalent to `personnel clear of all hazardous motion`.
4. It does not expose a deliberate abort/release test analogous to releasing a hold-to-run enabling device.
5. It does not deliberately isolate one counterbalance valve from a companion retaining path to prove that valve individually.
6. It does not provide an individual static load-retention acceptance test for a serviced/replaced counterbalance or holding valve.
7. It does not say that successful pressure adjustment/recheck alone is sufficient return-to-production validation after a safety-related repair.
8. It does not define an OpenPressBrake hydraulic truth table, diagnostic mode, pressure target, safe speed, or return-to-service sequence.

## Companion-path masking result

This procedure checks left and right counterbalance pressure separately and requires both sides to be rechecked, but it is **not** an unmasked individual retaining-function challenge.

Therefore:

`LEFT/RIGHT PRESSURE MEASURED SEPARATELY != LEFT/RIGHT LOAD-RETENTION PATH INDIVIDUALLY UNMASKED`.

`COUNTERBALANCE PRESSURE PASS != HOLDING/CHECK VALVE STATIC RETENTION PASS`.

The earlier Cincinnati CB II one-servo-at-a-time diagnostic remains a better example of deliberate companion-path isolation. The FoldSafe secondary-stop startup test remains a better example of deliberately preventing the normal stop path from masking the secondary dynamic stop path. None of these should be collapsed into the missing post-replacement static retaining proof.

## Reusable energized-diagnostic authority contract

For curriculum purposes, an energized diagnostic should be modeled as a bounded authority object with at least:

1. **Task** — the exact quantity/function that cannot be established while isolated.
2. **Hazards** — which electrical/hydraulic/mechanical/gravity hazards remain live.
3. **Physical configuration** — tooling/load/restraint/exclusion conditions required before energy is restored.
4. **Mode/control selection** — which normal controls are disabled and which deliberate controls remain permitted.
5. **Permitted actuation** — exactly what pump/valve/axis action is needed.
6. **Physical witness** — gauge, motion measurement, spool feedback, stop-time instrument, or other observation independent of merely commanding the output.
7. **Abort behavior** — how hazardous motion/energy is removed when the task is released, faults, or leaves its allowed envelope.
8. **Masking control** — whether another path could create a false pass and, if so, how it is prevented or detected.
9. **Acceptance criterion** — machine-specific and source/measurement grounded; never invented.
10. **Exit** — remove temporary instrumentation as required, restore isolation or validated safeguards, requalify safety state, and require fresh ordinary start authority as applicable.

The Cincinnati AUTOFORM procedure directly supports items 1, 3 in part, 4, 5, 6, 9 for that machine, and 10 in part. Items 3 (personnel exclusion), 7, and 8 remain incomplete in this source.

## LinuxCNC / OpenPressBrake boundary

**INFERENCE, constrained by the OEM evidence and existing course governance:** ordinary LinuxCNC/FPGA software may coordinate a diagnostic request, display instructions, record measurements, and suppress normal production commands, but those conveniences do not make ordinary control software the personnel-safety authority.

A future OpenPressBrake energized diagnostic should exist only when a concrete measurement actually requires energy. Its safe conditions, final elements, physical restraints/exclusion, enabling behavior, and acceptance limits must come from the real machine risk assessment, hydraulic design, component/OEM data, and validation—not from this Cincinnati procedure.

Human-factors rule: make the safe diagnostic path easier than improvised probing. Provide accessible labeled test points, a narrowly scoped service workflow, obvious control-state indication, and an easy route back to isolation. If technicians must defeat guards, reach around live tooling, guess which valve is active, or hold temporary probes in a crush zone, the architecture is encouraging bypass and should be redesigned.

## Curriculum outcome

The current evidence target is materially advanced. We now have a genuine hydraulic press-brake OEM energized adjustment procedure showing:

`DEFINED TEST PORT -> SELECTED CONTROL CONFIGURATION -> MAIN DRIVE ENERGIZED -> PRESCRIBED CYCLE -> RAM MOVING -> PHYSICAL PRESSURE WITNESS -> ADJUSTMENT -> MULTIPLE CYCLES -> BOTH SIDES RECHECKED -> MOTOR/PUMP OFF -> GAUGE REMOVED`.

It does **not** close the individual post-service retaining-valve proof gap and does not justify a generic maintenance bypass.

## Next evidence target

Rotate rather than reread this source. Highest-value continuation is an authoritative energized press-brake commissioning/service example that adds one of the pieces missing here:

- explicit personnel exclusion/restraint and safe technician position;
- hold-to-run/enabling-device release or other explicit abort behavior;
- deliberate isolation of one redundant hydraulic final element from companion masking during the energized test;
- faulted-test disposition and requalification before production.

Prefer a modern OEM/manufacturer implementation with a schematic or test sequence. If no new evidence appears quickly, rotate to another open 4000 safety module rather than manufacturing a synthetic lab.

## Compute decision

No executable lab is justified. The unresolved questions are documentary/physical-machine architecture questions, not software-runtime questions. No GitHub-hosted or self-hosted compute is required for this study.
