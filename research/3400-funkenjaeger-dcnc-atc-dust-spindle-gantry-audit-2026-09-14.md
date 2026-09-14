# 3400 Router / Woodworking — Funkenjaeger DCNC ATC, dust, spindle and gantry audit

Date: 2026-09-14
Status: substantive source/config evidence
Candidate: `Funkenjaeger/fj-lcnc-cfg`
Pinned inspected revision: `f4877f862ab757bd396b02e54acb12e6835f8259`

## Why this implementation matters

This is a materially useful second production-style router architecture after the earlier FENJA/Groot audit. It combines a six-pocket rack ATC, independent pneumatic pressure proof, per-pocket occupancy sensing, dust-shoe mechanics, WJ200 VFD feedback, an XYYZ gantry, fixed tool measurement and a remapped M6. It also has preserved commit history showing toolchange behavior was revised after field-visible failures.

## 1. ATC authority and state chain

`nc_files/toolchange.ngc` remaps M6 and makes automatic versus manual tool change an explicit runtime choice through `#<_hal[tool-change-mode]>`.

The automatic path performs, in order:

1. spindle stop (`M5`) and coolant stop (`M9`);
2. retract Z and temporarily retract the dust shoe (`M210 P1`);
3. immediate air-pressure sample through `M66 P7 L0`; abort if absent;
4. immediate source/destination pocket occupancy sanity checks;
5. spindle purge-air enable;
6. safe machine-coordinate motion to the current pocket;
7. rack extension and dwell;
8. pocket-presence verification before release;
9. drawbar release through synchronized `M62 P0` followed by Z motion;
10. pocket-presence verification after spindle retract;
11. logical current-tool reset with `M61 Q0`;
12. move to selected pocket, drawbar release, rack positioning and pickup;
13. synchronized drawbar engagement with `M63 P0` followed by motion;
14. pocket-empty verification after pickup;
15. logical current-tool assignment with `M61 Q#<_selected_tool>`;
16. rack retract, purge-air off, fixed-tool measurement (`M201 P1`), return to saved XY, and conditional dust-shoe restoration (`M211 P1`).

Preserve the state model:

`selected logical tool/pocket -> pneumatic readiness -> source/destination pocket evidence -> physical rack/tool transfer -> drawbar command -> pocket evidence -> logical M61 identity -> measured tool length -> restored dust state`

The logical tool identity is deliberately changed only after a physical transfer checkpoint. This is stronger than a blind `M6 => tool changed` model.

## 2. Feedback actually present vs absent

HAL/config evidence exposes:

- six pocket sensors on `motion.digital-in-00..05`;
- air-pressure switch on `motion.digital-in-07`;
- dust-shoe-retracted sensor on `motion.digital-in-08`;
- drawbar command on `motion.digital-out-00`;
- purge air on DOUT 01;
- ATC rack actuator on DOUT 04;
- dust-shoe cylinder controls on DOUT 05/06.

The inspected files do **not** expose a direct drawbar-clamped/drawbar-released feedback witness. Drawbar confidence is inferred from timed actuation plus subsequent pocket-state behavior. That distinction matters for recovery design.

## 3. Failure/recovery behavior

The remap contains numerous `(abort,...)` exits:

- no air pressure;
- current pocket unexpectedly occupied;
- selected pocket unexpectedly empty;
- failed deposit;
- tool not present after retract;
- failed pickup;
- dust-shoe retract/lower failures in the auxiliary remaps.

Local cleanup exists at some failure sites (for example rack retraction on failed deposit), but there is no repository-visible `ON_ABORT_COMMAND`/global abort routine that reconciles all of the following after an arbitrary interruption:

- drawbar DOUT;
- purge-air DOUT;
- rack actuator;
- dust-shoe outputs;
- physical spindle-tool state;
- rack pocket inventory;
- LinuxCNC logical current tool;
- validity of the later measured tool length.

Therefore this implementation reinforces, rather than weakens, the earlier 3400 rule: **an interrupted custom M64/M65/M62/M63 ATC must be treated as a physical/logical state-reconciliation problem, not as an idempotent retry.**

## 4. Real chronology: toolchange bugs changed the implementation

The repository commit history is useful field evidence rather than only a final snapshot.

A 2025-08-16 commit is explicitly titled `fix issue causing indefinite pause during tool change in Auto mode`. Its patch inserted:

- temporary G91;
- `G1 X0 F1`;
- restore G90;

immediately before the real G1 pocket-entry move. The commit comment says this mitigates waiting on spindle-at-speed upon the first real G1 move. This is a concrete example of a non-obvious LinuxCNC execution-state interaction surfacing during ATC commissioning.

A following 2025-08-17 commit is titled `mitigate interference with adjacent tool post during tool change`, showing that physical tool/rack clearance continued to drive sequence changes.

Curriculum implication: router ATC commissioning must test real modal/motion/spindle-readiness interactions and physical neighboring-tool clearance; geometric happy-path simulation alone is insufficient.

## 5. Dust-shoe authority is its own state machine

The dust-shoe remaps are materially better than a simple relay output.

`dust_shoe_up.ngc`:

- immediately samples the retracted sensor;
- remembers whether the shoe had been down;
- saves modal state and current position;
- raises Z;
- commands swing-away and raise;
- waits up to 4 s for the retract sensor using `M66 P8 L3 Q4`;
- aborts if the expected transition does not occur;
- restores position/modal state.

`dust_shoe_down.ngc`:

- conditionally restores only when prior state says it had been down;
- raises Z;
- commands lower;
- waits for the retract sensor to go inactive using `M66 P8 L3 Q1`;
- dwells for full extension;
- swings the shoe under the spindle;
- restores position/modal state.

This gives a reusable authority pattern:

`operator/ATC request -> saved prior auxiliary state -> clearance move -> actuator sequence -> transition witness -> restore/abort`

But it also exposes a bounded weakness: only the **retracted** position has a dedicated sensor in the inspected config. Full downward/swing-under completion is partly dwell-based rather than independently proved.

## 6. Spindle/VFD readiness

The WJ200 userspace VFD component supplies `wj200-vfd-emd.0.is-at-speed`, which is wired to LinuxCNC `spindle.0.at-speed`. Machine enable also drives the VFD component enable.

This is a real readiness witness used by LinuxCNC trajectory semantics, but it remains ordinary-control VFD status, not safety-rated standstill proof.

The 2025 toolchange fix demonstrates a practical consequence: spindle-at-speed gating can affect the first feed move inside a remap even after an earlier M5 if the task/motion state is not behaving as expected. That interaction belongs in ATC commissioning tests.

## 7. XYYZ gantry squaring

`DCNC.ini` declares four joints with `trivkins coordinates=XYYZ`. JOINT_1 and JOINT_2 are the two Y-side joints and both use `HOME_SEQUENCE = -1`, with separate physical home switches wired in HAL.

This is evidence of independent Y-side homing/squaring, not two axes. The negative synchronized home sequence preserves gantry-style joint homing while the coordinated world coordinate remains one Y axis after homing.

Do not infer a complete one-side-home-switch failure-recovery policy from these files alone; that still needs either LinuxCNC homing-source tracing or a documented field failure.

## 8. Vacuum/workholding evidence status

This implementation materially advances dust-shoe and pneumatic ATC evidence but does not provide a vacuum-table pressure-proof architecture. A broad GitHub search produced mostly generic/course examples rather than a trustworthy real LinuxCNC production config with vacuum zones plus vacuum-ready/fault response.

Therefore 3400-R3 should preserve two separate sub-branches:

- **dust-foot / chip collection:** real stateful source now available and partially promoted;
- **vacuum workholding:** still source-poor; do not invent pressure thresholds, zone sequencing or loss-of-vacuum recovery rules from generic examples.

## 9. Adversarial boundary review

1. Does an air-pressure input prove the drawbar is physically clamped? **No.** It proves only source pneumatic pressure at that input.
2. Do pocket sensors prove spindle tool presence? **Not directly.** They prove rack-pocket occupancy and are used as indirect transfer evidence.
3. Does `M61` move a tool physically? **No.** It reconciles LinuxCNC logical tool identity after the remap believes transfer succeeded.
4. Does a local abort guarantee all custom DOUTs return safe? **No evidence.** Some paths explicitly clean a subset; no global reconciliation hook was found.
5. Does `spindle.0.at-speed` equal safety-rated standstill? **No.** It is ordinary-control VFD feedback.
6. Do equal negative Y home sequences prove independent squaring? **They support synchronized gantry homing with independent joints/switches**, but not every fault/recovery behavior.
7. Does dust-shoe retract sensing prove both end positions? **No.** Retracted transition is sensed; some extended/swing completion remains dwell-based.
8. Does absence of vacuum logic prove the machine has no vacuum hold-down? **No.** It proves only that the inspected public config does not expose a usable vacuum authority contract.

Result: **8/8 boundary checks passed.**

## Promotion decision

Promote to the 3400 router playbook:

- separate pneumatic source readiness, actuator command, rack-pocket evidence, logical tool identity and tool-length validity;
- preserve auxiliary mechanisms such as dust shoes as explicit state machines with prior-state restoration;
- ATC field testing must include spindle-readiness/task interactions and physical neighboring-tool clearance;
- custom ATC abort/recovery needs explicit output and physical/logical reconciliation;
- independent Y joints/home switches are the correct conceptual layer for gantry squaring.

Do **not** yet promote:

- a universal drawbar-feedback architecture;
- a universal vacuum-table state machine;
- a universal interrupted-M6 restart procedure;
- a one-side gantry-home fault/recovery contract.

## Next evidence

Highest-value next 3400 work:

1. source-trace LinuxCNC gantry synchronized homing behavior and failure handling for negative HOME_SEQUENCE with one side failing to find/latch home;
2. inspect one real router vacuum-table implementation with zone control **and** readiness/loss evidence, if publicly available;
3. compare a third ATC architecture only if it contributes direct clamp/tool-present feedback or explicit global abort recovery;
4. decide whether the bounded custom-DOUT abort/machine-OFF/E-stop lab now adds evidence beyond source inspection.
