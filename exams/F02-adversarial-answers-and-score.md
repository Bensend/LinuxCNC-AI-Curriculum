# F02 adversarial exam — answers and score

Course level: 2000
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Result: **20/20 PASS**
Critical questions Q1/Q3/Q5/Q7: **all passed**

## Q1 — 3/3

Automatic replay is **not justified**.

The premise collapses at least these distinct properties:

1. current Ethernet/transport transaction health;
2. driver/error-history recovery;
3. HostMot2 watchdog / physical I/O pin authority;
4. internal FPGA/module state progression;
5. feedback-channel numerical agreement;
6. feedback physical truth / independence / freshness;
7. machine coordinate/reference/interlock validity;
8. machine motion authorization and stale program/command ownership.

A green transport diagnostic and cleared watchdog do not establish that the machine is where software believes it is. Changing internal step-generator state does not prove actuator motion. Two agreeing encoders do not prove independent physical truth after a common-mode or association failure.

Minimum generic F02 sequence: revoke/abort old motion ownership; retain episode diagnostics; restore required current communication/I/O prerequisites; independently reconcile the machine properties required by that machine, including feedback/reference/interlocks; finish reconciliation to READY; require explicit rearm; require a **new** run/motion request. Never replay the pre-fault stale command merely because lower layers recovered.

## Q2 — 2/2

Pinned `src/emc/task/emctask.cc::emcTaskAbort()` first calls `emcMotionAbort()`. It then clears `emcTaskCommand`, clears `interp_list`, resets Task interpreter/execution/pause/line/call state, queues interpreter synchronization, and closes/resets the task plan.

This matters because actual LinuxCNC abort handling is an explicit ownership/state cleanup path. A recovery design that silently retains and replays the pre-fault motion command contradicts that architectural boundary unless a higher-level application deliberately establishes a new, validated command after recovery.

## Q3 — 3/3

No. The UI may not promote `ETHERNET CAUSED FOLLOWING ERROR` to a source-confirmed root-cause fact from those observations alone.

Safe wording is: transport invalidity was observed first; a following error was observed one retained invocation later; LinuxCNC community evidence and the known stale-feedback mechanism make transport loss a plausible initiating cause of a subsequent following error. Exact causal attribution for this episode remains bounded by the retained evidence and observation topology.

Both bits should be retained because they are independently useful observations. Destroying the following-error evidence loses information about what the motion layer saw; destroying the transport bit loses the candidate initiating disturbance. F02 preserves observations while refusing unjustified causal certainty.

## Q4 — 2/2

Recorder failure proves neither that the machine continued moving nor that the independent interlock failed. It degrades the **evidentiary completeness/timing claim** for intervals that depend on that recorder. The control interlock may still have functioned correctly; conversely, the recorder cannot be used to prove physical behavior that it failed to observe completely. Physical movement requires separate physical evidence.

## Q5 — 3/3

The claim is unsupported. Python observer time and a HAL recorder timestamp are different observation surfaces; one-millisecond numerical proximity does not establish generation identity or “the very next servo cycle.” Without a shared producer-owned generation witness, buffering/publication/consumer delay prevents that conclusion.

For an exact same-cycle/one-cycle claim, the relevant communication-fault condition and authoritative authorization output must be evaluated in a known realtime execution order and retained coherently with a deterministic cycle/generation witness. The recorder must have valid provenance, zero relevant producer overruns and continuous deterministic coverage. If two surfaces are compared, they need a shared generation identifier or another justified cross-surface identity mechanism rather than nearest timestamps.

## Q6 — 2/2

Obtain the exact deployed build/patch version or source commit and, if distribution/vendor patches are possible, the corresponding package source/build metadata. Exact `hm2_eth` retry thresholds/recovery and watchdog behavior must then be traced in that source rather than projected from an arbitrary 2.9 revision.

Generically, F02 can still say that transport recovery, driver history, watchdog/physical I/O authority, machine-state validation and machine authorization are separate properties; lower-layer recovery alone does not justify stale-command replay or automatic machine reauthorization.

## Q7 — 3/3

Continuing reconciliation is wrong. Under the frozen F02-001 contract, loss of a required interlock during RECONCILE causes **RECONCILE -> FAULTED immediately**. Motion remains unauthorized; stale command ownership remains absent; rearm is cleared/ignored; the latched episode history retains the earlier faults and adds `INTERLOCK_INVALID`.

A later successful position-reference check cannot erase the second fault or jump directly to READY. Current prerequisites must again be restored and reconciliation deliberately restarted.

## Q8 — 2/2

Replace the one Boolean with the minimum separate state/data classes:

- `current_faults` / current prerequisite inputs;
- additive `latched_episode_history` for all observed fault classes;
- `evidence_valid` tracked independently from machine-control authority;
- recovery state at least `READY / RUNNING / FAULTED / RECONCILE`;
- `reconcile_required` plus explicit completion criteria supplied by the machine-specific layer;
- `rearm_latched`, accepted only after successful reconciliation/current validity;
- explicit `motion_authorized` derived from current prerequisites + state + rearm, not from `!any_fault_now`;
- stale command ownership cleared on fault, with a fresh post-recovery command required to run again.

Recorder invalidity need not automatically revoke control unless explicitly designed as a control prerequisite, but it must degrade evidence claims. Latched history must not be erased just because current fault inputs return healthy.

## Score

| Question | Score |
|---|---:|
| Q1 | 3/3 |
| Q2 | 2/2 |
| Q3 | 3/3 |
| Q4 | 2/2 |
| Q5 | 3/3 |
| Q6 | 2/2 |
| Q7 | 3/3 |
| Q8 | 2/2 |
| **Total** | **20/20** |

No critical-fail condition triggered.

## Corrections triggered by exam

No central F02 teaching required correction. The exam reinforces one wording discipline for the final guide: community chronology can support a **plausible causal chain**, but F02 must never upgrade transport-before-following-error timing into universal or episode-specific root-cause certainty without stronger evidence.
