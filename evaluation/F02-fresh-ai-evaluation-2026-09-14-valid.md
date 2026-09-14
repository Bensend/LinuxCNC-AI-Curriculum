# F02 fresh-AI evaluation — VALID — 2026-09-14

Status: **PASS — no corrections required**

This file preserves the full information-separated evaluator response supplied for the authoritative packet `handoffs/F02-fresh-ai-compound-fault-transfer.md`.

## Evaluator identity

Repository: `Bensend/LinuxCNC-AI-Curriculum`

Exact packet path: `handoffs/F02-fresh-ai-compound-fault-transfer.md`

Evaluator/session description: Independent fresh-session evaluator reasoning from the authoritative handoff, the specifically permitted F02 research/experiment artifacts, the pinned LinuxCNC source revision `8bf4605ae81042248add031e94c77300406e0413`, and official LinuxCNC documentation.

Information separation confirmed: **YES**

The evaluator explicitly confirmed that:

1. it evaluated repository `Bensend/LinuxCNC-AI-Curriculum`;
2. the exact authoritative packet was `handoffs/F02-fresh-ai-compound-fault-transfer.md`;
3. it had not been shown or used learner-side F02 answers or prior F02 grading conclusions and did not open or use `exams/F02-adversarial-answers-and-score.md` or `results/F02-001-authoritative-audit.md`;
4. its result was based only on the permitted F02 materials, the pinned upstream LinuxCNC source, official LinuxCNC documentation, and independent reasoning.

---

## A — Observation classification

### A1. Recovered Ethernet / clear `io_error`

This establishes a current transport/driver condition at the observation point: the Ethernet HostMot2 path is presently communicating sufficiently that the relevant communication error indication is no longer asserted.

It does not establish that:

- communication was uninterrupted during the fault episode;
- previous communication-error history should be erased;
- every realtime transaction in the recovery window succeeded;
- physical I/O state is reconciled;
- feedback is physically correct;
- machine motion is authorized;
- the diagnostic recording covering the earlier event is complete.

Transport recovery is therefore evidence about the current communications layer, not a general-purpose machine-health or motion-authorization statement.

### A2. Cleared HostMot2 watchdog

A cleared watchdog establishes that the watchdog's presently latched bitten condition has been cleared. LinuxCNC's HostMot2 documentation states that a watchdog bite disconnects the board's I/O pins from their module instances, while clearing `has_bit` resumes communication and restores the configured I/O-pin configuration.

That is meaningful evidence about board-side watchdog/I/O authority, but it does not prove:

- that an actuator received the intended command;
- that a motor or hydraulic member moved;
- that feedback agrees with physical reality;
- that ordinary machine interlocks are satisfied;
- that previous watchdog history may be discarded;
- that AUTO execution may resume.

### A3. Changing internal FPGA step-generator state

This establishes that an internal FPGA module state is changing in response to the maintenance command.

It is not proof of physical movement.

That distinction is particularly important with HostMot2 because the documented watchdog behavior explicitly allows internal encoder/PWM/step-generator module state to continue while the physical I/O pins have been disconnected from those modules.

Thus:

`internal step-generator activity ≠ physical output authority ≠ physical motor motion`.

### A4. Two agreeing position channels on the same board

This establishes agreement between the two reported position observations at that time.

It does not establish independent physical truth. Both channels share at least the same HostMot2 board and communications path, and may also share other common-mode failure mechanisms. Agreement therefore reduces some disagreement hypotheses, but it cannot exclude a common stale, shifted, or otherwise incorrect observation.

An independent commissioning/revalidation reference is still required before making the stronger statement that the physical member is actually where those channels say it is.

### A5. Contiguous userspace `-t` tags while producer overruns are nonzero

The producer overruns establish an evidence-integrity defect: at least one realtime producer attempt was unable to place its record into the FIFO and that data was lost.

At the pinned LinuxCNC revision, `sampler.c` explicitly treats a failed `hal_stream_write()` as a full-FIFO condition, increments the overrun count, and records that the data is lost.

More importantly, the underlying stream implementation checks writability and increments `num_overruns` before returning `-ENOSPC`; its stream sample number is incremented only later on a successful write.

Therefore contiguous `-t` values can truthfully mean:

> the records that successfully entered the FIFO have contiguous successful-write sequence numbers.

They cannot mean:

> every realtime producer invocation during the interval was retained.

The overrun indication wins on the completeness question.

### A6. Advancing Python monotonic time and motion heartbeat

This establishes that the Python collector remained active enough to obtain later observations, its monotonic clock advanced, and it observed changes in the chosen software heartbeat.

It does not establish:

- physical motion;
- fresh physical feedback on every heartbeat;
- successful physical I/O;
- absence of realtime faults;
- complete HAL evidence;
- common-cycle identity between any Python observation and a HAL recorder row.

A software heartbeat is a useful liveness/observation signal, not a physical-motion witness.

### A7. Later passing position/reference check

The later check establishes whatever its defined criteria establish at that later check point. If it is the required independent/revalidated reference procedure, it may satisfy that particular recovery prerequisite from then onward.

It does not retroactively repair the missing recorder records, prove what happened during the 120 ms fault interval, erase previously observed faults, or restore stale motion authorization.

It also cannot erase an interlock failure that was actually observed earlier in reconciliation.

## B — Compound-fault attribution

The following error cannot be labelled definitively caused by the Ethernet event from this evidence.

The strongest justified statement is:

> The communication failure preceded or occurred in the same fault episode as the following-error observation, and communication loss/stale feedback provides a technically credible mechanism by which a following error could result. Therefore the Ethernet failure is a plausible contributor or initiating event, and the following error may be a secondary consequence. The retained evidence does not establish exclusive or definitive causation.

There are at least two reasons not to strengthen that claim.

First, coexistence and plausible mechanism are not identical to causation. A different underlying condition could contribute to both observations, or the following error could have another contributor.

Second, recorder overruns make the diagnostic interval incomplete, so fine-grained causal ordering cannot be reconstructed as though every servo-cycle observation were retained.

Both observations should therefore remain in diagnostic history:

- communication/transport failure;
- following-error observation.

The following error must not be discarded merely because it may be secondary, and it must not be promoted to a separate proven root cause merely because it was independently observed. This non-destructive treatment is consistent with the permitted F02 policy material.

## C — Recorder and cross-surface reasoning

Producer overruns invalidate any claim requiring complete retained HAL coverage of the 120 ms interval.

Examples of invalid claims include:

- every realtime producer invocation is present;
- a particular signal never changed during the interval merely because no retained row shows it;
- exact event ordering can be reconstructed across missing records;
- exact servo-cycle separation between two retained events is known;
- every transition preceding/following the fault has been retained.

Contiguous `-t` tags do not repair this. The pinned stream implementation permits exactly the reported situation: an attempted producer write can be rejected as an overrun, while the stream sample number increments only for a subsequent successful write.

The advancing Python timestamps and heartbeat also do not prove physical motion. They establish userspace observation/liveness and heartbeat changes.

Likewise, the nearest Python and HAL timestamps must not be described as the same servo cycle. With no common generation identifier, sequence witness, or atomic shared-cycle record, timestamp proximity provides only approximate temporal correlation.

A valid same-cycle claim would require a common witness generated in the relevant realtime invocation and carried to both observation surfaces, or an equivalent synchronization mechanism that actually establishes generation identity.

## D — Reauthorization decision

No. Observation 3 is insufficient to resume the retained pre-fault AUTO move.

Green Ethernet, clear `io_error`, a cleared HostMot2 watchdog, and changing FPGA internals establish recovery of particular lower-level conditions. They do not recreate the motion authorization that existed before the fault.

The minimum generic F02 recovery sequence is:

1. **Fault handling:** revoke ordinary motion authorization and invalidate the pre-fault command's ownership. Clear any previous rearm authorization.
2. **Restore current prerequisites:** transport, watchdog/I/O authority, required feedback validity, required interlocks and other generic current prerequisites must be valid enough to begin reconciliation.
3. **Explicit reconciliation:** perform the required independent feedback/reference reconciliation. F02 should require this but should not invent machine-specific details.
4. **Monitor reconciliation continuously:** any newly observed required realtime control fault interrupts reconciliation.
5. **Complete to READY only:** successful reconciliation may produce a motion-ready state, but it does not itself resume RUNNING.
6. **Explicit post-recovery rearm:** the operator/application must deliberately establish a new authorization latch after successful reconciliation.
7. **New motion request:** only a new post-recovery run/motion request, with current prerequisites still valid, may cause ordinary motion to become authorized.

The frozen F02 policy states the same essential ownership boundary: entering FAULTED removes stale run ownership; reconciliation completes to READY rather than RUNNING; and explicit rearm plus a fresh run request is required before RUNNING returns.

The retained pre-fault AUTO move must therefore not silently restart.

## E — One-servo-period interlock loss during reconciliation

Because the realtime component actually observed the required interlock false, the GUI's failure to display it does not make the event disappear.

The correct control behavior is:

- reconciliation is immediately invalidated/interrupted;
- recovery state returns from `RECONCILE` to `FAULTED`;
- ordinary motion remains unauthorized;
- any rearm attempt/latch applicable to the interrupted recovery must be cleared;
- reconciliation remains required;
- stale pre-fault command ownership remains invalid;
- `INTERLOCK_INVALID` is added to the retained diagnostic episode history;
- earlier transport, watchdog, following-error and recorder-history observations remain preserved rather than being overwritten.

This is precisely the kind of realtime-versus-GUI separation required by the F02 recovery contract: a second control-authority fault during reconciliation returns the system to FAULTED and adds the event to history.

The later passing position/reference check does not erase the interlock event.

That later check may be useful evidence during a subsequent recovery attempt, but reconciliation must be restarted under valid current prerequisites. Successful completion still has to be followed by explicit rearm and a new motion request.

## F — Source boundary

At pinned revision `8bf4605ae81042248add031e94c77300406e0413`, the relevant Task function is:

`src/emc/task/emctask.cc::emcTaskAbort()`

The pinned function:

- calls `emcMotionAbort()`;
- clears the current pending `emcTaskCommand`;
- clears the interpreter command list;
- puts Task interpreter state into `IDLE`;
- sets Task execution state to `DONE`;
- clears pause state;
- clears motion/read line tracking and the current command text;
- clears call-level state;
- clears stepping state;
- queues an interpreter synchronization command;
- closes and resets the task plan, including flushing unflushed segments.

The source explicitly contains the significant comment that without `emcTaskPlanClose()`, a new run command would resume at the aborted line. The implementation then closes/resets the plan instead.

The same pinned source also shows explicit authority-changing state transitions. For example, the OFF path aborts motion, disables trajectory authority, performs I/O abort handling, and invokes Task abort rather than treating disappearance of an error indication as permission to continue.

This matters directly to stale command ownership.

`emcTaskAbort()` demonstrates that LinuxCNC's Task semantics intentionally terminate the current execution context and resynchronize rather than preserving an implicit right to continue the old motion.

An external application may, of course, retain a copy of the old AUTO command. But that does not mean LinuxCNC's aborted command still owns motion. Automatically injecting that retained command after Ethernet/watchdog recovery would constitute new reassertion of stale intent, bypassing the recovery/reauthorization boundary.

Therefore the proper F02 rule is not `communications returned, therefore continue.` It is:

`abort old ownership → reconcile → explicitly rearm → issue a new post-recovery motion request`.

## G — Safety/evidence boundary

Even after a correct F02 analysis, this scenario does not establish:

1. **Functional-safety certification or performance.** Nothing here establishes SIL, PL, Category, safety integrity, diagnostic coverage, certified fault reaction, or compliance with a machine-safety standard.
2. **Actual physical motion or physical position truth.** Software heartbeat activity, internal FPGA state and two agreeing same-board feedback channels do not establish where the physical machine member actually moved or is located.
3. **Stopping performance.** No conclusion can be made about physical stopping time, stopping distance, hydraulic response, servo coast, load behavior, or mechanical settling.
4. **Machine-specific recovery requirements.** F02 cannot determine whether a particular machine requires homing, encoder-index reacquisition, tooling verification, hydraulic checks, axis synchronization procedures, operator inspection, or some other machine-specific reconciliation.
5. **Actual independence of the two position channels.** Agreement alone does not demonstrate independence or absence of common-cause failure.
6. **Definitive root cause.** The observations support bounded causal hypotheses, not proof that Ethernet loss was the exclusive root cause of every later symptom.
7. **Future Ethernet reliability.** Successful communication after network tuning does not prove that the transport fault cannot recur.
8. **Physical actuator-output correctness.** Clearing a watchdog and changing an FPGA accumulator do not demonstrate correct pulses, valve currents, motor torque or machine displacement at the physical actuator.

The HostMot2 documentation itself makes the internal-versus-physical-I/O distinction explicit: internal module state may remain active while watchdog handling has disconnected the physical I/O pins.

---

## Evaluation result

**PASS**

### Reasoning for the result

The permitted F02 artifacts successfully transfer enough understanding for a fresh evaluator to reason through the novel compound-fault scenario correctly.

The independent result separates all of the required domains:

- current Ethernet/transport recovery;
- retained driver/error history;
- HostMot2 watchdog and board-side I/O authority;
- internal FPGA/module state;
- physical-feedback truth and common-cause limits;
- machine motion authorization;
- diagnostic evidence validity.

The packet and permitted supporting artifacts also transfer the three especially important adversarial boundaries correctly:

**Recorder integrity:** producer overruns remain an evidence-integrity defect even when userspace `-t` tags look contiguous. The pinned source independently confirms why contiguous retained sequence numbers do not prove that failed producer attempts were retained.

**Cross-surface synchronization:** Python/HAL timestamp proximity is insufficient to assert same-servo-cycle identity without a shared generation witness.

**Command ownership:** lower-layer Ethernet/watchdog recovery cannot resurrect stale AUTO authorization. The pinned `emcTaskAbort()` behavior materially supports the requirement that old execution ownership be terminated and that post-fault motion require reconciliation, explicit rearm, and a new request.

The material also correctly supports non-destructive compound-fault history: communication loss and following error may be causally related, but both observations remain valuable and neither should be converted into unsupported definitive root-cause certainty.

The one-servo-period interlock example is likewise handled correctly: a realtime-observed required-interlock failure interrupts reconciliation even when a slower GUI misses it.

Finally, the evidence boundaries are appropriately bounded. Nothing in F02 is sufficient to claim functional-safety certification, actual physical motion, measured stopping performance, physical feedback truth without independent revalidation, or machine-specific recovery requirements.

### Material deficiencies

None identified that materially affect the transfer or the F02 conclusions.

One particularly subtle point—the possibility of contiguous `-t` tags despite producer overruns—is not merely a policy assertion; it is independently consistent with the pinned stream implementation, where a rejected write increments the overrun count without incrementing the successful stream sample sequence. That removes what otherwise could have been an ambiguity in the packet.

### Exact corrections required

None.

### Does any deficiency block F02 graduation?

**No.**

On the evidence and information-separation conditions specified for this evaluation, F02 satisfies the stated 2000-level graduation standard.
