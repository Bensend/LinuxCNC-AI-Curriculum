# 3000-series promotion / playbook-completeness review — 2026-09-15

Status: **PASS — 3000 GRADUATED / CLOSED; transition to 4000 justified**

## Review question

Does the 3000 machine-specific specialization level now provide enough durable, evidence-bounded machine-class architecture, failure/recovery reasoning, and cross-machine transfer guidance to serve as a prerequisite for 4000 hardware and AI-assisted implementation, without requiring repetitive mining of source-thin branches?

## Governing scope

`CURRICULUM.md` defines 3000 as evidence-based specialization across major LinuxCNC machine classes, mining real implementations and converting findings into AI-readable machine build/playbook knowledge. Reusable board/FPGA implementation belongs primarily to 4000.

This review therefore does **not** require every machine class to have a complete production reference design. It requires the specialization layer to expose the machine-specific authorities, failure/recovery boundaries, implementation asymmetries, and reusable patterns needed to avoid designing generic hardware from mill-centric assumptions.

## Track review

| Track | Architecture / authority coverage | Failure / recovery coverage | Evidence maturity | Closeout decision |
|---|---|---|---|---|
| 3100 Mills/VMCs | M6 physical/logical/G43 separation; spindle orient; probing/tool-setting; readiness auxiliaries; gravity-axis brake/drive sequencing | probe validity, ATC abort ambiguity, readiness witness quality, brake timing/open-loop assumption | multiple real configs + upstream source | PASS |
| 3200 Lathes/Turning | spindle sync/G76/CSS; turret; chuck/workholding; tailstock variants; toolsetter | workholding proof chain, ownership transitions, toolsetter validity/frame conventions | source + field/config evidence | PASS |
| 3300 Plasma/Laser/Waterjet | mature QtPlasmaC plasma; native laser primitives + field integration; bounded waterjet process authorities; cross-process gantry playbook | plasma recovery/state reconstruction; laser readiness gaps; water/abrasive/pump recovery explicitly bounded | asymmetric by process and explicitly preserved | PASS |
| 3400 Routers/Woodworking | two ATCs; spindle/VFD; dust shoe; gantry homing; custom DOUT | interrupted M6, abort/output persistence, readiness-versus-authority | real configs + upstream source | PASS |
| 3500 Robots/Custom Kinematics | genserkins, ROS2/HAL/EtherCAT command chain, CiA-402, physical-home/DH/coupling distinctions | stale high-level command, drive fault containment, IK failure, safety/STO boundary | source + real ZA6/PUMA evidence | PASS |
| 3600 Press Brakes | Y1/Y2/hydraulic/backgauge/process/HMI integration map | bounded unknowns explicitly preserved; safety and recovery not flattened into ordinary control | deepest branch but source-limited in specific public areas | PASS for 3000 breadth; reopen only on named high-value evidence |
| 3700 Grinding/EDM | EDM geometry/adaptive motion versus spark/wire/dielectric authorities; servo versus hydraulic grinder distinction | reverse motion does not reconstruct process state; wire/process recovery boundaries | source + field evidence, some source-thin machine-specific process control | PASS |
| 3800 Saws/Feeders/Cells | ClassicLadder sequencing, extra-joint feeder, carousel/indexer, supervisory handshakes | STOP versus output/reset, physical completion, locking transaction and stale request concerns | upstream source + industrial field evidence | PASS |
| 3900 Emerging/Unusual | two additive architectures; thermal authority; winding; genhexkins | thermal freshness/readiness, winding evidence limits, solver convergence versus physical branch/workspace | source + real implementations where available | PASS |

## Cross-track transfer test

The synthesis in `research/3000-cross-machine-authority-patterns-2026-09-15.md` demonstrates that the specialization passes produced reusable knowledge rather than nine disconnected surveys. The strongest transferable contract is:

`request -> actuation path -> physical witness -> qualified completion -> continuation acknowledgement`

Additional transferable rules now supported across multiple machine classes:

- command/value, validity, freshness and process readiness are separate dimensions;
- ownership transfers require explicit neutralize/reconcile/request/ack/enable/fault sequencing;
- motion stop/reverse/abort does not imply process-state cleanup/reversal/reset;
- commanded, interface/electrical, physical and process-valid states should not be collapsed;
- status availability does not imply trustworthy status or control authority;
- normal process permissives, software fault containment and independent safety-rated authority are separate;
- diagnostics should expose transaction phase, owner, witnesses, freshness and blocking reason rather than only a synthetic `ready` result.

These are directly usable as 4000 hardware-block contract requirements.

## Counterfactual review of preserved gaps

The major open items are branch-local and do not overturn the 3000 teaching if later evidence differs:

- waterjet public pump/pressure-ready sequencing remains source-thin;
- production fiber-laser READY/FAULT/gas/focus/recovery implementations remain thinner than plasma;
- press-brake quantitative tandem/sensor-bending and tooling-aware backgauge automation remain bounded unknowns;
- production vacuum-table pressure/recovery contracts are source-thin;
- robot command-freshness watchdog behavior remains implementation-specific;
- EDM complete process-controller implementations remain thinner than geometric/motion evidence;
- winding tension/break/restart implementations remain source-thin.

If these later resolve differently, the durable 3000 rule is still to preserve process-specific authority and not infer missing witnesses. None invalidates the transition to reusable hardware design; rather, they argue for parameterized interfaces and explicit unknown/optional witness contracts in 4000.

## Promotion decision

**3000 is GRADUATED / CLOSED as a curriculum level.**

This does not mean every 3100–3900 branch is exhausted forever. Their latest checkpoints remain reopen maps for materially stronger evidence. Routine autonomous work should no longer mine them merely to accumulate breadth.

The active curriculum level becomes **4000 — hardware and AI-assisted implementation**.

## 4000 entry requirements derived from 3000

Every reusable hardware block should document at minimum:

1. physical authority commanded;
2. independent feedback/witness inputs available;
3. validity/freshness/watchdog semantics;
4. reset and communication-loss output state;
5. hardware enable/inhibit independent of numeric command where appropriate;
6. locally latched versus reported-only faults;
7. realtime-critical versus supervisory timing;
8. parameterization envelope and what must not be parameterized away;
9. ownership-transfer/rearm semantics where multiple control modes exist;
10. safety boundary and what external safety authority must remain independent.

## Lab decision

No 3000 closeout lab is justified. The promotion question is architectural/playbook completeness, and the remaining uncertainties are named machine-specific evidence gaps rather than a single unresolved executable LinuxCNC behavior that could overturn the level-wide conclusions.
