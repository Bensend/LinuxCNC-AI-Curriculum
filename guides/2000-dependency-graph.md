# 2000-series dependency graph

Status: **ACTIVE**

This graph is the dependency-driven promotion pass after completion of T02–T05 and C01–C09 at 1000 level. Difficulty alone does not justify promotion; 3000 work requires new evidence that specialized prerequisites or infrastructure are actually necessary.

## Priority heuristic

Each candidate receives ordinal scores 1–5 for prerequisite value (P), unresolved uncertainty (U), consequence (C), expected information gain (IG), and infrastructure cost penalty (IC). Working priority score: `P + U + C + IG - IC`. This is a scheduling heuristic, not a scientific risk metric.

| ID | Advanced module | Score | State / dependency |
|---|---|---:|---|
| D01 | Coupled-control stability and tandem-joint authority | **17** | **GRADUATED 2000; 2026-09-09** |
| F02 | Compound-fault state-machine sequencing | **16** | blocked by S02, E20 and X02 |
| S02 | Feedback integrity, diversity and common-cause reasoning | **15** | **ACTIVE; highest-priority unblocked after D01** |
| E20 | HostMot2/hm2_eth watchdog/recovery across versions | **14** | unblocked; source/version matrix before hardware |
| X02 | Synchronized multi-surface diagnostics | **13** | requires X01 recorder perturbation evidence |
| X01 | Recorder perturbation and long-duration retention | **12** | unblocked |
| T20 | UI/Task/NML freshness and ownership under stress | **11** | strengthened by X02 |
| H30? | Custom HostMot2 FPGA/driver/distributed realtime extension | — | **3000 candidate only**; D01 did not justify promotion |

## Dependency graph

```text
1000-series graduated
        |
        +--> D01 GRADUATED --> S02 feedback integrity/common-cause --+
        |                                                            |
        +--> X01 recorder perturbation --> X02 correlation ----------+--> F02 compound faults
        |                                                            |
        +--> E20 hm2_eth/watchdog version behavior ------------------+
        |
        +--> X02 --> T20 UI/Task/NML stress

E20 / X02 / later evidence --only if justified--> H30? 3000 candidate
```

## D01 closure

Authoritative workflow `34375315740` passed unchanged frozen Gates A–J from retained artifact evidence. The already-frozen adversarial exam scored 20/20 without accepting any safety/conceptual trap. D01 established a version-pinned authority boundary: duplicated-coordinate command agreement and principal-looking Cartesian feedback do not prove duplicate-joint agreement or physical tandem geometry. Joint-level following-error authority can revoke ordinary global motion while Cartesian feedback remains principal-looking. D01 does not authenticate physical geometry, common-cause feedback integrity, stopping performance, or functional safety.

The D01 counterfactual/promotion test did not justify H30/3000 work. It did expose the next prerequisite directly: S02 must address feedback validity, diversity, freshness, and common-cause cases in which software channels can agree while physical truth is wrong.

## Re-promotion safeguards

1. Do not create a 3000 module merely because a 2000 experiment is difficult.
2. Preserve version-specific conclusions as version-specific until a source/version matrix supports generalization.
3. Keep physical sensor coupling, actuator authority, stopping performance, and functional-safety certification outside software-only proof.
4. A successful simulated disagreement detector proves only the modeled measurement/control relationship.
5. The end-of-1000 sealed benchmark remains information-separated; this graph does not reveal or infer its sealed oracle.

## Exact next dependency checkpoint

Begin S02. First inventory D01/C-series claims that currently treat feedback as evidence, then research LinuxCNC feedback validity/freshness surfaces and relevant encoder/HostMot2 failure semantics. Freeze an adversarial model before implementation that includes at least one common-cause case where both software feedback channels agree but physical geometry is wrong, one stale/frozen-channel case, and one ordinary differential disagreement case. Explicitly separate what software can detect from what requires independent physical diversity. Do not advance F02 until S02, E20 and X02 establish their accepted contracts.
