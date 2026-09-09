# 2000-series dependency graph

Status: **ACTIVE / INITIAL GRAPH**

This graph is the first dependency-driven promotion pass after completion of T02–T05 and C01–C09 at 1000 level. It deduplicates the major unresolved queues into advanced modules. Difficulty alone does not justify promotion; 3000 work requires new evidence that specialized prerequisites or infrastructure are actually necessary.

## Priority heuristic

Each candidate receives ordinal scores 1–5 for:

- **P** prerequisite value — how much later work it unlocks;
- **U** unresolved uncertainty — how much the 1000 evidence still leaves open;
- **C** consequence if the assumption is wrong;
- **IG** expected information gain from a bounded module;
- **IC** infrastructure cost/availability penalty.

Working priority score: `P + U + C + IG - IC`.

This is a curriculum scheduling heuristic, not a scientific risk metric.

| ID | Advanced module | P | U | C | IG | IC | Score | State / dependency |
|---|---|---:|---:|---:|---:|---:|---:|---|
| D01 | Coupled-control stability and tandem-joint authority | 5 | 4 | 5 | 5 | 2 | **17** | **ACTIVE; unblocked** |
| F02 | Compound-fault state-machine sequencing | 5 | 5 | 5 | 5 | 4 | **16** | blocked by D01, S02, E20 and X02 |
| S02 | Feedback integrity, diversity and common-cause reasoning | 4 | 4 | 5 | 4 | 2 | **15** | unblocked after D01 baseline; physical authentication remains separate |
| E20 | HostMot2/hm2_eth watchdog/recovery across versions | 3 | 5 | 4 | 5 | 3 | **14** | unblocked; source/version matrix before hardware |
| X02 | Synchronized multi-surface diagnostics | 4 | 4 | 4 | 4 | 3 | **13** | requires X01 recorder perturbation evidence |
| X01 | Recorder perturbation and long-duration retention | 3 | 4 | 3 | 4 | 2 | **12** | unblocked |
| T20 | UI/Task/NML freshness and ownership under stress | 3 | 4 | 3 | 4 | 3 | **11** | strengthened by X02 |
| H30? | Custom HostMot2 FPGA/driver/distributed realtime extension | — | — | — | — | high | **3000 candidate only** | may be promoted only by E20/X02/D01 evidence |

## Dependency graph

```text
1000-series graduated
        |
        +--> D01 coupled-control stability/authority --------+
        |                                                     |
        +--> X01 recorder perturbation --> X02 correlation ---+--> F02 compound faults
        |                                                     |
        +--> E20 hm2_eth/watchdog version behavior -----------+
        |                                                     |
        +--> S02 feedback integrity/common-cause -------------+
        |
        +--> X02 --> T20 UI/Task/NML stress

E20 / X02 / D01 evidence --only if justified--> H30? 3000 candidate

physical safety / commissioning = separate human/hardware evidence domain
```

## Why D01 is first

D01 has the highest unblocked priority and directly tests an assumption that becomes hazardous when generalized: duplicated-coordinate kinematics can issue the same Cartesian target to multiple joints, but that does not itself prove the joints share the same actual mechanical pose, available authority, or stability margin. The module can begin entirely in software and source analysis, yet it unlocks compound-fault and feedback-integrity work.

## Re-promotion safeguards

1. Do not create a 3000 module merely because a 2000 experiment is difficult.
2. Preserve version-specific conclusions as version-specific until a source/version matrix supports generalization.
3. Keep physical sensor coupling, actuator authority, stopping performance, and functional-safety certification outside software-only proof.
4. A successful simulated disagreement detector proves only the modeled measurement/control relationship.
5. The end-of-1000 sealed benchmark remains information-separated; this graph does not reveal or infer its sealed oracle.

## Exact next dependency checkpoint

Complete D01 docs/community/source/call-flow research, then freeze a bounded experiment **before implementation** that can distinguish command-space agreement from per-joint tracking and from unobserved physical geometry. Do not advance F02 until D01 establishes its accepted authority/fault-containment contract.