# S02 fresh-AI transfer — feedback integrity and common-cause reasoning

Status: **PREPARED / UNSCORED — INFORMATION-SEPARATED EVALUATOR REQUIRED**
Course level: 2000
Module identity: **S02 — feedback integrity, diversity and common-cause reasoning**
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

The learner that authored or reconciled S02 must not answer or score this packet. Give it to a genuinely information-separated evaluator. Before scoring, the evaluator must identify the repository, module ID, this exact packet path, summarize the scenario in its own words, and confirm it has not been given the learner answer or an answer key.

## Allowed artifacts

- `guides/S02-feedback-integrity-common-cause-research.md`
- `call-flows/S02-feedback-transport-observability.md`
- `results/S02-004-authoritative-gate-reconciliation.md`
- pinned LinuxCNC source at the revision above, especially the relevant Mesa HostMot2 encoder and hm2_eth paths
- official LinuxCNC documentation needed to verify current/public semantics

Do **not** provide:

- `evaluation/S02-2000-adversarial-answer.md`
- `results/S02-005-adversarial-exam-grade.md`
- any prepared answer key or prior chat summary of expected answers

## Novel scenario

A duplicated-actuator commissioning stand uses two incremental encoder channels, A and B, acquired through one Ethernet-connected Mesa HostMot2 board. During a deliberately slow 4-second move:

- reported A and reported B remain numerically equal to each other throughout 120 consecutive servo periods;
- the current hm2_eth transaction/error surfaces remain healthy during those retained periods;
- neither channel reports the configured quadrature-sequence diagnostic;
- a temporary commissioning reference, mechanically independent of both encoder couplings and justified for this test, reports that the physical member moved approximately 0.7 mm while A and B remained unchanged;
- one atomic same-thread diagnostic record contains A, B, the temporary reference, transport status, quadrature diagnostics, phase and a deterministic cycle witness; producer overruns are zero and the retained witness is contiguous across the interval.

After motion stops, the commissioning reference is removed. A and B continue to agree and remain constant while transport remains healthy.

In a separate deliberate test, the HostMot2 watchdog is made to bite. Physical output authority is removed according to the tested configuration, while an internal encoder/module value can still be observed changing.

An engineer concludes:

> “A and B agree, Ethernet is healthy, quadrature diagnostics are clean, and the watchdog is independent. Therefore the two encoder channels were fresh and physically correct during the move; the temporary reference must have been wrong.”

## Fresh-AI task

Answer all of the following from the allowed evidence without inventing hardware behavior:

1. Separate the scenario into distinct claims about numerical agreement, board-transport freshness, per-sensor freshness, channel validity, independence/diversity, and physical truth. Which are established, contradicted, or still unknown?
2. Give the strongest defensible diagnosis for the 120-period moving interval. Explain exactly why the temporary commissioning reference changes what can be inferred, and what must be justified about that reference before relying on it.
3. After the move stops and the independent reference is removed, may equal constant encoder values plus healthy transport prove that both channels are fresh? Explain the observability ambiguity.
4. Construct at least one plausible common-cause class in which A and B agree while both are wrong. Explain why a detector restricted to A, B, and transport health cannot guarantee detection of every such case.
5. Bound the meaning of a clean quadrature diagnostic. State at least four broader properties it does not authenticate.
6. Explain what the deliberate watchdog test does and does not establish. Why can internal module/encoder state and physical I/O authority diverge without contradiction?
7. At the pinned revision, trace the relevant checked hm2_eth board-read/error path far enough to state precisely where transport evidence stops. Name source symbols/paths where practical rather than giving generic prose.
8. Judge whether the retained atomic trace is eligible to support an exact bounded software-observation claim for this interval. Then separately state at least four claims it still cannot prove, including physical performance or functional-safety claims.

## Pass criteria

A passing response must independently recover the mechanisms rather than repeat slogans. It must:

- reject equality as proof of freshness, independence, or physical truth;
- distinguish a current/accepted board transaction from fresh physical encoder information;
- use the independently justified commissioning reference to support the moving-interval stale/wrong-feedback conclusion while preserving the reference's own provenance requirement;
- return to **UNKNOWN freshness from value-only evidence** for the later stationary interval;
- explain common-mode observational indistinguishability for a detector limited to A/B/transport;
- scope quadrature diagnostics to their covered fault class rather than universal validity;
- separate watchdog/output authority from encoder truth and recognize that internal state can continue despite changed physical-I/O authority;
- trace the pinned transport path with appropriate source specificity and version discipline;
- require atomic/coherent retained evidence plus producer-health/continuity for exact software timing claims;
- reject conversion of the synthetic/commissioning evidence into claims of functional-safety integrity, guaranteed real-machine independence, exact stopping performance, or universal hardware behavior.

Any response that accepts the engineer's conclusion solely because A/B agree and LinuxCNC/Mesa diagnostics are green is an automatic failure.

## Evaluation record

- Repository identified:
- Module ID identified:
- Exact packet path identified:
- Scenario summary supplied before scoring:
- Information separation confirmed:
- Evaluator identity/session:
- Date:
- Result:
- Score/rationale:
- Critical trap failures, if any:
- Corrections required:
- Graduation consequence:

Do not mark S02 fully graduated until a genuinely information-separated evaluator completes and records this transfer.