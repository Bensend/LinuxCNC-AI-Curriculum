# Initial 2000-series promotion candidate ledger

Status: **INITIAL / INCOMPLETE INVENTORY**

This ledger starts the required transition from the completed 1000 series to a dependency-driven 2000 series. It is intentionally not yet the final dependency graph: the next session must inspect every existing promotion/uncertainty artifact and deduplicate the complete set.

| Candidate cluster | 1000 evidence/gap | Consequence if wrong | Prerequisite value | Expected information gain | Infrastructure | Provisional destination/priority |
|---|---|---|---|---|---|---|
| Coupled-control stability/authority | C03/C04 established measurable cross-coupling/asymmetry behavior in bounded simulated plants, but not broad stability/authority envelopes | HIGH: poor architecture could amplify disagreement or hide local saturation/authority limits | HIGH for multi-actuator machines | HIGH | software lab first; later realistic plant/hardware | 2000 / HIGH |
| hm2_eth + watchdog version/recovery internals | C06 pinned one revision and preserved transport/watchdog distinction; version/documentation differences remain | HIGH: wrong recovery/observability assumptions affect fault handling | HIGH for Ethernet HostMot2 systems | HIGH | source/version matrix + lab; hardware later | 2000 / HIGH |
| Multi-surface synchronized diagnostics | C08 proved realtime recorder validity rules and that NML/log evidence is not automatically atomic with HAL | MEDIUM-HIGH: bad correlation can produce false root cause/recovery claims | HIGH for later experiments | HIGH | software instrumentation lab | 2000 / HIGH |
| Recorder perturbation/long-duration behavior | C08 did bounded capture and tiny-FIFO adversary, not jitter/long-run characterization | MEDIUM: can invalidate diagnostic evidence under load | MEDIUM-HIGH | MEDIUM-HIGH | realtime lab with scheduler/load telemetry | 2000 / MEDIUM-HIGH |
| Sensor common-cause/diversity/plausibility | C05/C09 preserve feedback != physical truth; independent physical authentication remains unresolved | HIGH/CRITICAL on hazardous coupled mechanics | HIGH for fault engineering | HIGH | simulation/source first; physical sensor architecture later | 2000 / HIGH; hardware validation separate |
| State-machine formalization under compound faults | C07 proved request/achieved/fresh-authorization semantics in bounded sequences | HIGH: compound/reordered faults can expose stale-state bugs | HIGH | MEDIUM-HIGH | software state-machine/model tests | 2000 / HIGH |
| UI/Task/NML freshness and ownership under stress | T02-T05 established ownership/freshness boundaries but not broad overload/reconnect behavior | MEDIUM: operator presentation can mislead diagnostics/operations | MEDIUM | MEDIUM | software lab | 2000 / MEDIUM |
| Custom HostMot2 FPGA/driver/distributed realtime extension | 1000 traced existing HostMot2/hm2_eth behavior; extension engineering not yet required to prove 1000 claims | HIGH but specialized | Depends on advanced HostMot2 + diagnostics | Potentially HIGH | HDL/driver/network lab and likely hardware | **3000 candidate only**; re-promotion evidence required |
| Functional-safety architecture and physical commissioning | 1000 repeatedly bounded ordinary LinuxCNC away from safety authority | CRITICAL | External to ordinary LinuxCNC software curriculum | HIGH for real machine, but different evidence domain | certified safety engineering + physical machine/human work | hardware/safety track; not promotable as a software-only conclusion |

## Ranking rule for final graph

For each deduplicated item assign explicit ordinal scores for:

- prerequisite value;
- unresolved uncertainty;
- consequence if wrong;
- expected information gain;
- infrastructure availability/cost.

Prefer work that unlocks several later questions and can falsify important assumptions with bounded evidence. Do not simply begin with the first 1000 module again.

## Re-promotion safeguard

No 1000 unresolved item may be labeled 3000 merely because it is hard. The only current 3000 candidate is custom FPGA/driver/distributed-realtime extension work, and even that remains only a candidate until 2000-level evidence demonstrates specialized prerequisites or infrastructure that justify the tier.
