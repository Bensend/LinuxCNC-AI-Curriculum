# 25E0 external evaluator handoff — no solution key

## Information-separation rule

Give the learner only the challenge portion. Do not provide expected answers, scoring interpretation, prior evaluator notes, or later corrections before the learner commits its response. This file intentionally contains no answer key.

## Challenge

A generic automated machine has:

- a movable interlocked guard;
- an E-stop chain;
- a drive with STO;
- a pneumatic actuator with trapped-energy potential;
- a manual reset station;
- LinuxCNC receiving safety-system status for diagnostics but not owning final personnel-safety authority.

The machine has passed schematic review and all safety-controller diagnostics currently report healthy.

Produce a commissioning/validation plan sufficient to decide whether the machine can be released for attended operation. The response must:

1. derive tests from explicit safety requirements rather than a generic checklist;
2. identify the physical proposition established by each test;
3. distinguish controller/status evidence from independent physical evidence;
4. include reset/restart and power-restoration behavior;
5. address guard opening while hazardous motion may coast;
6. address STO versus actual standstill and stored/gravity energy where applicable;
7. address trapped pneumatic energy;
8. include at least three justified fault/adversarial tests and state why each is safe enough to perform or how it must be isolated;
9. define what configuration/version evidence is frozen at release;
10. identify changes that trigger partial or full revalidation;
11. define the latent-failure logic for at least one periodic proof test without inventing a calendar interval;
12. explain what LinuxCNC logs/status can corroborate and what they cannot prove;
13. explicitly mark machine-specific stopping limits, pressure thresholds, quantitative integrity claims and proof-test intervals UNKNOWN unless evidence is supplied.

Then evaluate this change: after release, tooling is replaced with a substantially higher-inertia tool while safety code and guard hardware remain unchanged. State whether prior validation remains sufficient and justify the scope of any required revalidation.

## Evaluator process

Score mechanism understanding, physical-proof discipline, uncertainty handling, restart reasoning, change-control reasoning and ordinary-control/safety-authority separation. A response that treats healthy safety-controller bits, STO status, EDM, or unchanged code as sufficient physical proof has a central competency defect.

Record the independent result through the repository blind-feedback protocol. Do not mark 25E0 graduated from this handoff alone; follow the repository's external scoring/correction/retest process.
