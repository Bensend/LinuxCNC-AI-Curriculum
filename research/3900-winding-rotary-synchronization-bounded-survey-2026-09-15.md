# 3900 — Winding / rotary synchronization bounded survey — 2026-09-15

## Purpose

After establishing a second inspectable additive implementation, rotate within 3900 to a genuinely different machine class as required by the work-selection policy.

## Public evidence found

A bounded web/community search found a LinuxCNC forum thread, **“Winding up wire on a coil”** (2014), in which the machine concept is coordinated rotary/traverse motion: repeated A rotation while a linear Y traverse advances and reverses at the winding endpoints. A community reply points to an older LinuxCNC winder example.

This is useful evidence that coil winding has been treated as a LinuxCNC coordinated-motion application, but the bounded pass did not surface a current inspectable production repository/config with tension feedback, material-break detection, spindle/traverse phase error, restart reconciliation, or layer-transition authority.

## Architecture implications that are evidence-safe

The public example supports only a narrow foundation:

- mandrel rotation and traverse can be represented as coordinated LinuxCNC motion;
- reversing the traverse at layer endpoints is naturally expressible in path/program logic;
- geometric pitch can therefore be encoded by the relationship between rotary and linear travel.

It does **not** establish production material authority. A real winding playbook must keep separate:

1. geometric rotary/traverse synchronization;
2. wire/fiber tension authority;
3. material-present/break/slip detection;
4. mandrel/chuck/workholding readiness;
5. layer/end-turn transition policy;
6. spool/payoff state;
7. pause/abort/restart reconciliation of material already laid.

Durable rule:

**rotary/traverse coordination != winding-process correctness.**

This directly parallels the additive finding that coordinated extrusion motion does not prove deposited-material correctness, but the physical process state is different enough to justify a separate specialization pattern.

## Source boundary

No production-quality inspectable LinuxCNC winder implementation surfaced in the bounded search. Do not invent tension/recovery semantics from generic coordinated motion or lathe threading.

Evidence that would reopen this path:

- a public HAL/config/source tree for an operating coil/filament winder;
- a build diary exposing tension dancer/load-cell feedback and commissioning failures;
- explicit spindle/traverse electronic-gearing logic with restart behavior;
- material-break or spool-runout handling tied to LinuxCNC execution state.

## Next selection

Because the winder path is source-thin, rotate rather than repeat searches. The next high-information 3900 task is a bounded native `genhexkins` source trace focused specifically on convergence/failure/switching authority and singular/invalid-pose behavior, avoiding duplicate general robot-IK work already covered in 3500.

## Lab decision

No lab. Without a real public winding process contract, a synthetic coordinated A/Y exercise would prove only ordinary trajectory behavior already known elsewhere in the curriculum.
