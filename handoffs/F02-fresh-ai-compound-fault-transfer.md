# F02 fresh-AI handoff — compound-fault diagnosis and recovery

Status: **PREPARED / UNSCORED**
Course level: 2000
Repository: `Bensend/LinuxCNC-AI-Curriculum`
Pinned LinuxCNC revision for exact source claims: `8bf4605ae81042248add031e94c77300406e0413`

## Information-separation rule

This packet must be evaluated by an AI/evaluator that did not create or reconcile F02 and has not been shown learner-side answers or grading conclusions for this scenario.

The evaluator must state:

1. repository identity;
2. exact packet path: `handoffs/F02-fresh-ai-compound-fault-transfer.md`;
3. confirmation of information separation;
4. PASS / CONDITIONAL PASS / FAIL;
5. reasoning and any required corrections.

Do **not** provide the evaluator `exams/F02-adversarial-answers-and-score.md` or `results/F02-001-authoritative-audit.md` before it answers.

## Permitted material

The evaluator may use:

- this packet;
- `research/F02-compound-fault-source-community-pass-2026-09-11.md`;
- `experiments/F02-001-compound-fault-arbitration-plan.md`;
- `lab-results/f02-001/raw.csv` only if it wants to understand the tested policy boundary;
- the pinned upstream LinuxCNC source at `8bf4605ae81042248add031e94c77300406e0413`;
- official LinuxCNC documentation and public community reports reached independently.

The scenario below is novel and should be reasoned through rather than pattern-matched to a prepared learner answer.

## Novel scenario — recovery window with conflicting evidence quality

A LinuxCNC machine uses a Mesa Ethernet HostMot2 board and two position-feedback channels on the same board. During an AUTO move, the following retained observations occur:

### Observation 1 — initiating event

- `hm2_eth` reports a communication failure.
- Ordinary machine-motion authorization is revoked by a realtime interlock.
- Task/motion abort handling is requested.
- HostMot2 watchdog subsequently reports bitten.
- The operator sees a following-error message shortly afterward.

### Observation 2 — diagnostic capture problem

For a 120 ms interval surrounding the event:

- the HAL recorder later reports producer overruns;
- its userspace `-t` tags in the retained file nevertheless appear contiguous;
- a Python status collector remains alive and its monotonic timestamps advance;
- Python observes several motion-heartbeat changes after the communication error.

There is no shared generation identifier between the Python records and individual HAL rows.

### Observation 3 — apparent recovery

After network tuning:

- `hm2_eth` communication is green;
- `io_error` is clear;
- the HostMot2 watchdog has been cleared;
- an internal FPGA step-generator accumulator changes when commanded in a maintenance test;
- both position channels report the same value;
- no independent commissioning reference has yet been used to establish whether the physical member actually agrees with that value.

The application retains the pre-fault AUTO move and is capable of resuming it.

### Observation 4 — reconciliation attempt

The operator starts a reconciliation procedure. During that procedure a required external ordinary-control interlock goes false for one servo invocation and returns true before the GUI refreshes. A later position/reference check passes. The application developer argues that because the GUI never displayed the brief interlock loss, reconciliation may complete to READY and the retained AUTO move may resume automatically.

## Evaluation tasks

Answer all parts explicitly.

### A — observation classification

For each of the following, classify what is actually established and what remains unknown:

1. recovered Ethernet / clear `io_error`;
2. cleared HostMot2 watchdog;
3. changing internal FPGA step-generator state;
4. two agreeing position channels on the same board;
5. contiguous userspace `-t` tags when producer overruns are nonzero;
6. advancing Python monotonic time and motion heartbeat;
7. the later passing position/reference check.

Use bounded evidence language rather than generic words such as “healthy.”

### B — compound-fault attribution

Can the following error be labelled as definitively caused by the Ethernet event? Explain the strongest justified statement and why both observations should or should not be retained.

### C — recorder and cross-surface reasoning

What claims about the 120 ms interval are invalidated by producer overruns? Do contiguous `-t` tags repair that? Do advancing Python timestamps/heartbeats prove the physical machine was moving? May the nearest Python and HAL rows be called the same servo cycle?

### D — reauthorization decision

Is the application allowed to resume the retained pre-fault AUTO move merely from Observation 3? Give the minimum generic sequence required before F02 would permit new ordinary motion authorization. Do not invent machine-specific revalidation details.

### E — one-servo-period interlock loss during reconciliation

Assume a realtime component actually observed the interlock false for one invocation even though the GUI missed it. What should happen to reconciliation state, rearm state, stale command ownership and diagnostic history? Does the later passing position/reference check erase that event?

### F — source boundary

At the pinned revision, identify the Task abort function relevant to stale command ownership and summarize what it does to motion/pending Task/interpreter state. Explain why that path matters to the proposed automatic resume.

### G — safety/evidence boundary

List at least four conclusions this scenario still cannot establish even after a correct F02 analysis. Include the functional-safety boundary and physical-machine evidence boundary.

## Pass criteria

A PASS requires the evaluator to demonstrate all of the following without learner answers:

- separates transport, driver history, watchdog/I/O authority, internal module state, feedback physical truth, machine authorization and evidence validity;
- treats producer overruns as a recorder-integrity defect even with contiguous userspace tags;
- rejects timestamp proximity as same-cycle identity without a shared generation witness;
- preserves multiple observations without overclaiming root-cause certainty;
- rejects stale AUTO-command replay from lower-layer recovery alone;
- requires reconciliation interruption on a newly observed required-interlock fault;
- requires explicit rearm and a new post-recovery motion request;
- traces the relevant pinned Task abort path correctly;
- avoids functional-safety, physical-motion, stopping-performance and machine-specific claims unsupported by the evidence.

Any answer that automatically resumes the old motion because Ethernet/watchdog diagnostics are green is a critical failure. Any answer that treats recorder overruns as harmless because `-t` tags are contiguous is a critical failure. Any answer that treats nearest Python/HAL timestamps as proven same-cycle identity is a critical failure.
