# Fresh-AI evaluation routing audit — 2026-09-11

## Trigger

An information-separated evaluator returned the following module labels/results:

| Reported ID | Reported title/focus | Reported result | Reported correction |
|---|---|---|---|
| S02 | HAL & Safety Interlocks | CONDITIONAL PASS | outdated parallel-port focus; missing latency-test integration |
| E20 | Advanced G-Code & CRC | FAIL | flawed lead-in geometry examples; O-code scoping contradictions |
| X01 | Python UI / GladeVCP | PASS | minor `comp.ready()` documentation tweak |
| X02 | Sensor-Driven Adaptive Control | FAIL | unbounded signal scaling; missing hysteresis/filtering safety blocks |

## Identity check

Before applying those findings, the current repository was checked against its authoritative course state and handoff packets.

- Repository **S02** is the 2000-level watchdog/failure-engineering module (`CURRICULUM.md`: S02 — watchdog design patterns), not a module titled “HAL & Safety Interlocks.”
- Repository **E20** is the Ethernet/communication-recovery handoff whose novel scenario concerns Mesa Ethernet transport errors, HostMot2 watchdog state, independent machine revalidation, and motion reauthorization. It is not “Advanced G-Code & CRC.” See `evaluation/E20-fresh-ai-handoff-packet.md`.
- Repository **X01** is recorder-integrity transfer centered on `sampler.c`, `sampler_usr.c`, producer overruns, deterministic payload continuity, and the userspace reader. It is not “Python UI / GladeVCP.” See `handoffs/X01-fresh-ai-recorder-integrity-transfer.md`.
- Repository **X02** is synchronized multi-surface diagnostics centered on HAL sampling, Task `taskbeat`, motion `heartbeat`, Python/NML observation, and generation-vs-observer time. It is not “Sensor-Driven Adaptive Control.” See `handoffs/X02-fresh-ai-multi-surface-diagnostics-transfer.md`.

## Verdict

**EVALUATION ROUTING INVALID / NO MODULE PASS-FAIL CONSEQUENCE.**

The returned findings may be reasonable observations about some other syllabus or artifact set, but they do not evaluate the four repository modules whose IDs were requested. Applying them to S02/E20/X01/X02 would corrupt the curriculum by editing unrelated modules to satisfy findings generated against different subjects.

Therefore:

1. Do **not** mark X01 graduated from the reported PASS.
2. Do **not** mark S02 conditionally passed from this report.
3. Do **not** downgrade E20 or X02 on these findings.
4. Do **not** edit E20 CRC/O-code material, X01 GladeVCP material, or X02 adaptive-signal-conditioning material under these IDs; those are not the modules in the authoritative repository.
5. Preserve S02/E20/X01/X02 at their pre-evaluation technical status: technically accepted, fresh-AI handoff still pending.
6. Re-run the fresh evaluation using the repository's actual prepared handoff packets and allowed-artifact lists. The evaluator must return the exact packet identity/title or scenario summary in its result so routing can be verified before scoring.

## Corrected evaluation procedure

For each module, provide the fresh evaluator only the prepared packet plus the packet's explicitly allowed artifacts/source. Require the response header to state:

- repository: `Bensend/LinuxCNC-AI-Curriculum`;
- module ID;
- exact handoff packet filename;
- one-sentence description of the packet's novel scenario;
- confirmation that disallowed answer/score artifacts were not supplied.

Reject the evaluation before scoring if any of those identity fields do not match the repository packet.

Known packet identities verified in this audit:

- E20: `evaluation/E20-fresh-ai-handoff-packet.md` — Mesa Ethernet communication-fault recovery and machine reauthorization boundary.
- X01: `handoffs/X01-fresh-ai-recorder-integrity-transfer.md` — sampler producer-loss/recorder-integrity transfer.
- X02: `handoffs/X02-fresh-ai-multi-surface-diagnostics-transfer.md` — cross-surface generation/freshness diagnostics transfer.

S02 must likewise be routed from its actual repository handoff artifact rather than inferred from an ID/title supplied outside the repo.

## Adversarial check

Counterfactual: if the reported X01 PASS were accepted despite the title mismatch, the course would graduate a recorder-integrity module based on an evaluator discussing GladeVCP `comp.ready()` without demonstrating any understanding of sampler producer overruns, deterministic payload continuity, or reader/producer separation. That violates the fresh-AI transfer purpose even if the evaluator's GladeVCP advice is technically correct.

Likewise, accepting the reported X02 FAIL would force signal-conditioning edits into a diagnostics-generation module without testing its actual transfer traps (observer time versus producer generation, heartbeat ownership, recorder health, and same-cycle identity).

The identity/routing check is therefore a validity gate, not paperwork.

## Next checkpoint

Locate/verify the exact S02 fresh-AI packet path, then issue a corrected evaluator bundle for S02, E20, X01, and X02 using the packet-specific allowed-artifact lists. Do not alter technical graduation status until correctly routed information-separated evaluations are returned and independently checked against the packet criteria.
