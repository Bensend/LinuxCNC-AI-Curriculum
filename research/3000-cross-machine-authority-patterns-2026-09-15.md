# 3000 cross-machine authority patterns — 2026-09-15

Status: cross-track synthesis after every 3100–3900 specialization has received a substantive evidence pass.

## Purpose

Extract reusable controller-design patterns from the machine-specific work without flattening machine physics. This is intended to become a prerequisite bridge into 4000 hardware / AI-assisted implementation work.

## 1. The most reusable lesson: command is not completion

Across every machine class, the same failure pattern appears under different names:

- mill ATC request versus tool physically transferred and clamped;
- lathe turret/chuck request versus indexed/locked/clamped workholding;
- plasma Torch On versus Arc OK/transfer;
- laser source enable versus READY and actual modulation authority;
- waterjet valve command versus pressure/process readiness;
- router drawbar command versus tool retention;
- robot trajectory command versus fresh actuator command and drive state;
- EDM spark/gap request versus valid gap/process state;
- saw feeder position command versus material physically stable at length;
- indexer target versus mechanical lock proof;
- additive heater command versus fresh/valid temperature and extrusion readiness.

General contract:

`request -> actuation path -> physical witness -> qualified completion -> continuation acknowledgement`.

A controller board or AI-generated machine block should expose these stages separately whenever hardware permits. Do not save pins by collapsing command and witness into one semantic state.

## 2. Freshness is its own dimension

A value can be plausible but stale. 3000 examples repeatedly expose this:

- ROS/ros2_control command storage can remain after higher-level update activity stops;
- non-realtime plasma RS485 telemetry can lose communication independently of realtime motion;
- probe/contact inputs can remain asserted across a new transaction;
- spindle/turret acknowledgements can be level-held across a new request;
- temperature values can exist without a complete freshness/runaway contract;
- process status bits can be available in HAL yet unused as authority.

Reusable hardware/software pattern:

- value;
- valid/quality;
- freshness/age or generation;
- fault/timeout;
- reset/rearm semantics.

Where a transaction can repeat, prefer request-scoped acknowledgement or explicit rearm over an unqualified held-high bit.

## 3. Ownership transitions are first-class state machines

Several difficult failures arise not during steady-state control but while ownership moves between controllers/modes:

- lathe spindle velocity -> M19 orient -> C-axis position control;
- robot userspace trajectory manager -> HAL realtime command -> EtherCAT/CiA-402 drive authority;
- press-brake normal axis command -> synchronization correction / retract phases;
- plasma nominal Z -> external-offset THC correction;
- router manual versus automatic drawbar/dust/vacuum control;
- extra-joint prehome versus posthome independent command;
- additive normal motion versus thermal/process readiness.

A reusable ownership transition should define:

1. outgoing owner neutralization;
2. feedback/reference reconciliation;
3. mode/drive request;
4. mode/drive acknowledgement;
5. incoming command initialized to a bumpless/current-state value where appropriate;
6. incoming owner enable;
7. timeout/fault path;
8. abort/recovery owner.

Never let two active loops command the same actuator simultaneously unless their combination is explicitly designed and bounded.

## 4. Motion state and process state are orthogonal

Machine-specialization evidence repeatedly disproves the assumption that stopping/reversing trajectory reconstructs process state.

Examples:

- EDM negative adaptive feed can reverse retained trajectory while synchronized process outputs are not automatically inverted;
- plasma Run From Line reconstructs material/process state rather than merely seeking a line;
- laser queued synchronized power/gate changes depend on future motion boundaries;
- custom Motion DOUT can survive generic motion abort/disable unless explicitly reconciled;
- ClassicLadder STOP does not generically clear prior outputs or reset sequence state.

General rule:

**reverse/stop/abort motion != reverse/stop/reset physical process state**.

Every machine playbook should define process cleanup and restart eligibility independently from trajectory cleanup.

## 5. Feedback hierarchy

Useful controller designs distinguish at least four levels:

1. **commanded state** — what software requested;
2. **electrical/interface state** — what output/drive/network reports;
3. **physical machine state** — clamp, pressure, contact, position, rotation, temperature, etc.;
4. **process-valid state** — part retained, arc transferred, tool clamped, material stable, thermal process ready, etc.

A higher layer may be inferred from lower layers only when the machine architecture explicitly justifies the inference.

## 6. Readiness should be compositional

Avoid a single opaque `ready` bit inside reusable blocks. Better structure:

- actuator/drive ready;
- feedback valid/fresh;
- mechanism in required physical state;
- process source ready;
- recipe/mode valid;
- safety-chain permissive as an externally supplied boundary signal;
- resulting normal-control continuation permissive.

This makes diagnostics and AI-generated integration substantially more auditable.

## 7. Safety boundary remains independent

The 3000 evidence spans high-energy spindles, hydraulic presses, laser optical hazards, plasma power, extreme-pressure waterjet, robot motion, EDM power and workholding. LinuxCNC normal control, HAL status, software quick stop and communications health must not be promoted into functional-safety claims without a real safety architecture.

Reusable hardware should make safety-chain interfaces explicit and electrically appropriate, but the curriculum must preserve the distinction between:

- normal process permissive;
- software fault containment;
- independent safety-rated stop/energy isolation.

## 8. Diagnostics should expose the chain, not only the result

Minimum high-value diagnostic surfaces across machine classes:

- requested mode/action;
- active owner;
- command value;
- feedback value;
- validity/freshness;
- physical completion witnesses;
- timeout/fault reason;
- interlock blocking reason;
- current transaction phase;
- whether restart/recovery is automatic, operator-qualified, or prohibited.

This is more transferable than machine-specific lamp names.

## 9. Implications for 4000 hardware blocks

When the curriculum transitions into reusable custom control hardware, each block specification should answer:

1. What physical authority does the block command?
2. What independent feedback can prove actuation or detect failure?
3. What freshness/watchdog information exists?
4. What happens when command communications stop?
5. What state does the output assume on FPGA/MCU reset?
6. What hardware enable/inhibit exists outside the numeric command path?
7. What faults are latched locally versus merely reported?
8. What timing is realtime-critical versus supervisory?
9. Can the block be parameterized without changing its safety/authority semantics?
10. What signals must remain independent rather than being synthesized into one `ready` bit?

This directly supports the project's intended reusable board-block methodology: preserve known-good circuit topology where available, parameterize ratings where justified, and pair every electrical block with an explicit authority/failure contract.

## 10. 3000 promotion state

All nine 3000 tracks have now received substantive machine-specific evidence passes, but branch-local breadth stops are not automatically graduation. Before declaring the entire 3000 level graduated, perform a deliberate promotion review against the curriculum's machine-playbook objective and verify that each track has enough durable architecture/failure/recovery guidance to support the 4000 transition.

No lab is justified by this synthesis itself.
