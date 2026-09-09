# 2000-series dependency graph

Status: **ACTIVE**

This graph is the dependency-driven promotion pass after completion of T02–T05 and C01–C09 at 1000 level. Difficulty alone does not justify promotion; 3000 work requires evidence that specialized prerequisites or infrastructure are actually necessary.

## Priority heuristic

Working priority score is `P + U + C + IG - IC` for prerequisite value, uncertainty, consequence, expected information gain, and infrastructure-cost penalty. It schedules work; it is not a risk metric.

| ID | Advanced module | Score | State / dependency |
|---|---|---:|---|
| D01 | Coupled-control stability and tandem-joint authority | **17** | **GRADUATED 2000; 2026-09-09** |
| F02 | Compound-fault state-machine sequencing | **16** | blocked by S02, E20 and X02 |
| S02 | Feedback integrity, diversity and common-cause reasoning | **15** | authoritative gates + exam + promotion complete; **fresh-AI handoff pending** |
| E20 | HostMot2/hm2_eth watchdog/recovery across versions | **14** | **ACTIVE / highest-priority executable; experiment frozen** |
| X02 | Synchronized multi-surface diagnostics | **13** | requires X01 recorder perturbation evidence |
| X01 | Recorder perturbation and long-duration retention | **12** | unblocked |
| T20 | UI/Task/NML freshness and ownership under stress | **11** | strengthened by X02 |
| H30? | Custom HostMot2 FPGA/driver/distributed realtime extension | — | **3000 candidate only**; D01/S02 do not justify promotion |

## Dependency graph

```text
1000-series graduated
        |
        +--> D01 GRADUATED --> S02 technical evidence complete --fresh handoff--+
        |                                                                      |
        +--> X01 recorder perturbation --> X02 correlation --------------------+--> F02 compound faults
        |                                                                      |
        +--> E20 hm2_eth/watchdog version behavior ACTIVE ---------------------+
        |
        +--> X02 --> T20 UI/Task/NML stress

E20 / X02 / later evidence --only if justified--> H30? 3000 candidate
```

## D01 closure

Authoritative workflow `34375315740` passed unchanged frozen Gates A–J; frozen adversarial exam scored 20/20. D01 established that duplicated-coordinate command agreement and principal-looking Cartesian feedback do not prove duplicate-joint agreement or physical tandem geometry. It did not justify H30/3000.

## S02 technical closure and remaining boundary

Authoritative workflow `34395556653` passed frozen Gates A–J **10/10** from retained atomic evidence; its frozen adversarial exam scored **20/20** with all critical traps rejected. The counterfactual/promotion test did not justify H30.

The only remaining S02 graduation requirement is a genuinely fresh-AI handoff. The same learner instance must not self-certify this information-separated test. This boundary does not justify idling other independent prerequisites, so E20 becomes the highest-priority executable work while S02 awaits valid external/fresh evaluation.

## E20 activation

Source/community/version work establishes a material recovery delta:

- inspected 2015/2.7-era lineage used a fixed ~200 ms queued-read wait and lacked the later queued-read packet-error accumulator/decay/`io_error` threshold path;
- v2.9.10 uses current-cycle packet-error plus accumulated level/limit, clean-cycle decay, `needs_soft_reset`, `io_error`, and an explicit saturated-counter recovery interaction after external `io_error` clear;
- current master preserves the high-level state machine while changing backend/confirmation implementation;
- HostMot2 watchdog/pin authority is distinct from hm2_eth transport/driver error state, and internal FPGA generator/encoder state can continue while physical pin authority is absent.

`experiments/E20-001-transport-watchdog-recovery-boundaries.md` freezes P0–P8 and Gates A–J before implementation. It specifically forbids automatic motion reauthorization from a clean current packet, clearing `io_error`, watchdog reset, or changing internal generator state alone.

## Re-promotion safeguards

1. Do not create a 3000 module merely because a 2000 experiment is difficult.
2. Preserve version-specific conclusions as version-specific until a source/version matrix supports generalization.
3. Keep physical sensor coupling, actuator authority, stopping performance and functional-safety certification outside software-only proof.
4. A successful synthetic fault/recovery state model proves only the modeled software distinctions.
5. The end-of-1000 sealed benchmark and fresh-AI tests remain information-separated.

## Exact next dependency checkpoint

Implement frozen E20-001 as a standalone realtime HAL component followed by `sampler` in one 1 ms thread. Preserve `packet-error-limit=10`, increment=2, decrement=1, P0–P8 and Gates A–J unchanged. Retain source/topology/thread order, atomic samples and producer overrun evidence. Run a non-authoritative preflight first; correct harness defects only. Do not advance F02 until S02's fresh handoff plus accepted E20 and X02 contracts are complete.
