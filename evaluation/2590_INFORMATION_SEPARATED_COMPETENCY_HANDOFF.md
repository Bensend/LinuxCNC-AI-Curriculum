# 2590 information-separated competency handoff

## Purpose

For an independent/fresh evaluator. This file intentionally contains **no hidden solution**. Do not expose a preferred safeguard architecture or expected diagnosis before the learner commits.

## Evaluation contract

Present one novel machine scenario containing at least five of the following without identifying the traps:

- a movable access guard;
- dangerous motion that persists after a stop request;
- a coded/non-contact interlock;
- a proposed guard lock;
- a light curtain or scanner;
- a location where a person can pass through a field and remain inside;
- a reset station with imperfect visibility;
- a two-hand station used by one operator while another person may have access;
- setup/jog requiring an enabling device;
- a plausible bypass incentive caused by poor ergonomics or nuisance trips;
- a proposed maintenance intervention;
- ordinary LinuxCNC/HAL/FPGA guard/status logic.

Do not provide machine stopping time, approach parameters, guard-lock holding requirement, setup speed/force, PL/SIL target, diagnostic coverage or application-specific reach geometry unless deliberately included as evidence.

## Required learner deliverable

Require the learner to provide:

1. hazardous event and physical safe-state proposition;
2. safeguard-selection rationale by operating/access mode;
3. exact proposition established by each guard/interlock/presence/enabling/two-hand device and what it does not establish;
4. complete safety-function chain to the physical end of the dangerous state;
5. foreseeable defeat, reach-around/over, pass-through and remaining-inside-zone analysis;
6. stopping-distance evidence requirements with explicit UNKNOWNs rather than invented machine data;
7. reset/rearm/start separation and reset-location reasoning;
8. two-hand concurrence/release/anti-tie-down and bystander-access reasoning where applicable;
9. enabling/hold-to-run restricted-mode reasoning where applicable;
10. production-versus-maintenance boundary;
11. human-factors changes that make correct use/reinstallation easier than bypass; and
12. LinuxCNC/FPGA authority boundary.

## Scoring dimensions

Score independently for safeguard selection, physical-proposition discipline, stopping-time/distance reasoning, defeat analysis, pass-through/occupancy reasoning, lifecycle/reset/restart behavior, human factors, maintenance boundary, uncertainty discipline, and safety-authority separation.

## Critical failures

A response is not competent if it treats any of these as complete proof without the missing application evidence:

- guard closed;
- interlock healthy;
- guard lock commanded;
- high-coded sensor;
- protective field clear;
- device response time alone;
- two ordinary buttons true;
- enabling switch held;
- safety reset;
- LinuxCNC/HAL/ordinary FPGA state;
- production safeguard state as maintenance energy isolation.

Inventing machine stopping time, safety distance, lock force, integrity target or restricted-mode physical limits is also a critical evidence-discipline failure.

## Information separation

Record the learner's complete response before constructing/revealing the evaluator diagnosis. If the expected architecture or answer was exposed beforehand, mark the result non-blind and exclude it from blind competency metrics.

After commitment, reconcile significant conclusions against the supplied machine evidence and authoritative device/application documentation. A transfer retest should change the machine surface, access pattern or safeguard technology rather than simply rename components.
