# Independent fresh-AI evaluator handoff — 4400-ACC-SAF-01

**Status: PREPARED / NOT RUN / NOT SCORED.** The public module and 14 public cases are **not** a blind challenge. Use the repository's [blind feedback protocol](BLIND_FEEDBACK_PROTOCOL.md). Evaluator must construct a *novel* exact-part/energy-boundary challenge and retain the hidden solution outside learner-visible material until learner precommitment.

## Competencies to challenge

1. Read an unfamiliar original hydraulic accumulator block **exact order code** and identify manual versus automatic discharge, normally-open versus normally-closed deenergized state, and optional gauge/locking hardware without guessing.
2. Separate **fluid-side pressure**, **gas-side vessel precharge**, **other trapped zones** and **gravity-loaded motion**; correctly refuse a one-gauge/coil-LED safe-state claim.
3. Explain why normal LinuxCNC/FPGA commands and HMI status cannot replace independent safety logic, physical energy control or personal LOTO.
4. Diagnose one deliberate **replacement variant** or blocked-return fault and identify which SRS/ARC/PHY/VAL/CHG evidence is stale.
5. Design a practical human-friendly maintenance and restart control that does not invite bypass, while refusing unverified machine-specific pressure/PL/stop-distance claims.
6. Distinguish a **direct OEM manual**, an **indexed-only standards preview**, an **ISO publisher scope record**, and an **EU pressure-equipment directive** without treating any one as automatic machine-level safety approval; test a novel retained-pressure exception scenario.

## Information-separation procedure

- Evaluator chooses a **new** manufacturer/device configuration not copied from the public 14 cases; retain its answer and source excerpt privately.
- Learner receives only the challenge, allowed reference scope and declared evidence limits. Record its **prediction, confidence, solve time and safety uncertainty** before answer release.
- After commitment, independently check the exact manufacturer source and score the six competencies plus error taxonomy. Publish only the result and permissible feedback after scoring.
- Require novel transfer (e.g., lathe hydraulic chuck or vertical robot axis) and later retention; do not count this prepared handoff as an evaluation.
- If the evaluator cannot preserve answer separation, mark **NON-BLIND** and exclude from blind score.

## Physical safety boundary

No evaluator is authorized to operate, bleed, charge or open an accumulator or energize an exposed machine. Any machine-specific proof requires qualified physical commissioning, independently selected witnesses and a separate approved safety plan. OpenPressBrake selected Y1/Y2 stop/hold, pressure, guarding and deliberate restart remain UNKNOWN; **G0/G1 HOLD**.

**Compute:** none requested; no GitHub-hosted runner, no self-hosted run and no physical test.
