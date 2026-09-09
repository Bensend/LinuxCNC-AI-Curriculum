# Initial 2000-series promotion candidate ledger

Status: **INVENTORIED / RECONCILED**

This ledger is the deduplicated 1000→2000 promotion inventory. The scored scheduling graph now lives in `guides/2000-dependency-graph.md`; this file preserves provenance and scope boundaries.

| Candidate cluster | 1000 evidence/gap | Consequence if wrong | Prerequisite value | Expected information gain | Infrastructure | Destination |
|---|---|---|---|---|---|---|
| Coupled-control stability/authority | C03/C04 established bounded cross-coupling/asymmetry behavior, but not duplicated-coordinate authority, broad stability margins, delay/saturation envelopes or command-vs-geometry observability | HIGH | HIGH | HIGH | software lab first; realistic plant/hardware later | **D01 / 2000 ACTIVE** |
| hm2_eth + watchdog version/recovery internals | C06 pinned one revision and preserved transport/watchdog distinction; version/documentation differences remain | HIGH | HIGH | HIGH | source/version matrix + lab; hardware later | **E20 / 2000** |
| Multi-surface synchronized diagnostics | C08 proved realtime recorder validity rules and that NML/log evidence is not automatically atomic with HAL | MEDIUM-HIGH | HIGH | HIGH | software instrumentation lab | **X02 / 2000**, after X01 |
| Recorder perturbation/long-duration behavior | C08 did bounded capture and tiny-FIFO adversary, not jitter/long-run characterization | MEDIUM | MEDIUM-HIGH | MEDIUM-HIGH | realtime lab with scheduler/load telemetry | **X01 / 2000** |
| Sensor common-cause/diversity/plausibility | C05/C09 preserve feedback != physical truth; independent physical authentication remains unresolved | HIGH/CRITICAL | HIGH | HIGH | simulation/source first; physical sensor architecture later | **S02 / 2000**; hardware validation separate |
| State-machine formalization under compound faults | C07 proved request/achieved/fresh-authorization semantics only in bounded sequences | HIGH | HIGH | HIGH | software state-machine/model tests | **F02 / 2000**, after D01/S02/E20/X02 |
| UI/Task/NML freshness and ownership under stress | T02-T05 established ownership/freshness boundaries but not broad overload/reconnect behavior | MEDIUM | MEDIUM | MEDIUM | software lab | **T20 / 2000**, strengthened by X02 |
| Custom HostMot2 FPGA/driver/distributed realtime extension | 1000 traced existing HostMot2/hm2_eth behavior; extension engineering not yet required to prove 1000 claims | HIGH but specialized | depends on D01/E20/X02 evidence | potentially HIGH | HDL/driver/network lab and likely hardware | **H30? / 3000 candidate only** |
| Functional-safety architecture and physical commissioning | 1000 repeatedly bounded ordinary LinuxCNC away from safety authority | CRITICAL | external to ordinary LinuxCNC software curriculum | HIGH for a real machine, but different evidence domain | certified safety engineering + physical machine/human work | separate hardware/safety track |

## Deduplication decisions

- C03/C04 coupled-control and C09 multi-actuator architecture gaps combine into **D01**, rather than restarting either 1000 module.
- C08 recorder integrity splits into **X01** (can the recorder itself perturb/lose evidence?) and **X02** (how do independently clocked evidence surfaces get correlated?). X02 depends on X01 so correlation claims are not built on an unvalidated recorder.
- C05/C09 feedback-vs-physical-truth gaps combine into **S02**.
- C06 version/documentation uncertainty becomes **E20**, not a rerun of C06-030.
- C07 stale authorization/request-vs-achieved evidence becomes one prerequisite of **F02**, which intentionally waits for the independent fault domains above.
- T02-T05 ownership/freshness stress becomes **T20** and does not supersede realtime authority boundaries.

## Ranking rule

For each item, the active graph scores prerequisite value, unresolved uncertainty, consequence if wrong, expected information gain and infrastructure cost. Prefer bounded work that can falsify an important assumption and unlock later modules. Do not simply continue in old module-number order.

## Re-promotion safeguard

No unresolved item becomes 3000 merely because it is difficult. `H30?` remains only a candidate until 2000-level evidence demonstrates specialized FPGA/driver/distributed-realtime prerequisites or infrastructure are necessary.

The end-of-1000 sealed benchmark remains information-separated and is not opened merely to populate this ledger.