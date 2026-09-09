# E20 — fresh-AI handoff packet

Status: **READY / NOT YET EVALUATED**
Course level: 2000
Evaluator requirement: a genuinely fresh AI instance that has not seen a prepared solution to the scenario below.

The evaluator may use the durable E20 module artifacts and referenced LinuxCNC source. It must not be given an answer key or this learner instance's private reasoning. The current learner instance must not mark its own answer as satisfying the fresh-AI graduation requirement.

## Novel scenario

An integrator is testing a LinuxCNC machine using a Mesa Ethernet HostMot2 board. During a commanded move, the Ethernet path experiences enough failed transactions to assert the driver's communication error state. Motion is disabled. A short time later:

- current Ethernet transactions are again completing successfully;
- the driver's current packet-error indication is false;
- `io_error` has been cleared through the deployment's documented recovery procedure;
- the HostMot2 watchdog no longer reports bitten;
- an internal HostMot2 generator/encoder-like state value is visibly changing;
- the operator has **not** yet performed any independent machine-position/reference/interlock revalidation since the fault;
- the control application proposes automatically restoring motion-enable because “all LinuxCNC/Mesa diagnostics are green again.”

The deployment is reported as “LinuxCNC 2.9,” but no exact patch release or source commit has yet been recorded.

## Fresh-AI task

Produce a bounded engineering assessment that answers all of the following without inventing behavior not established by evidence:

1. Decide whether automatic motion reauthorization follows from the observations. Explain the authority boundary precisely.
2. Separate the evidence into at least four distinct domains: current transport observation, driver/error-history recovery, watchdog/physical-I/O authority, and independent machine-state/motion authorization.
3. Explain what the changing internal HostMot2 state does and does not prove about physical output pins or actuator state.
4. Identify the version ambiguity and give the exact source-verification strategy required before relying on packet-error/recovery semantics.
5. State what additional machine-level evidence/action is required before reauthorization in a conservative bounded design.
6. Describe the minimum realtime evidence arrangement needed to prove a same-cycle “new fault revokes authorization” claim. Address atomic sampling and producer recorder health.
7. Give one small HAL/custom-component interlock design sketch that fails closed on a new communication fault and does not collapse driver recovery into machine revalidation.
8. State at least four claims that cannot be justified from E20's software/source experiment, including functional safety and exact physical timing.

## Pass criteria

A fresh response passes only if it:

- rejects automatic-restart reasoning based solely on green transport/driver/watchdog diagnostics;
- preserves the four authority domains instead of collapsing them;
- treats changing internal HostMot2 state as insufficient proof of physical output activity;
- refuses to generalize exact recovery semantics from a vague “2.9” label and asks for/derives the exact release or commit before source claims;
- requires independent machine revalidation plus explicit reauthorization;
- requires one atomic realtime evidence stream and zero relevant producer overruns for same-cycle/absence claims;
- proposes a fail-closed interlock with a fresh-fault revoke path;
- does not claim physical stopping performance, exact Mesa output restoration timing, diagnostic coverage, or functional-safety assurance from the synthetic experiment.

Any answer that says or implies “communications recovered, therefore automatically resume motion” is an automatic failure regardless of point total.

## Evaluation record to fill later

- Fresh evaluator identity/session:
- Information separation confirmed:
- Date:
- Result:
- Score/rationale:
- Trap failures, if any:
- Corrections required:
- Graduation consequence:
