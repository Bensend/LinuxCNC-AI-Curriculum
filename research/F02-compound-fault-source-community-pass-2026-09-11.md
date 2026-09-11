# F02 — compound-fault diagnosis and recovery arbitration

Status: **RESEARCH / SOURCE PASS**
Course level: **2000**
Date: 2026-09-11
Pinned LinuxCNC source baseline: `8bf4605ae81042248add031e94c77300406e0413`

## Why F02 is the next 2000-level dependency

`PROGRESS.md` named F02 as blocked until the deliberately information-separated handoffs for S02, E20, X01 and X02 were valid. The returned evaluator response preserved in `evaluation/fresh-ai-evaluation-2026-09-11-valid.md` passes all four authoritative packets with no corrections. The explicit block is therefore removed.

`CURRICULUM.md` describes the remaining 2000-level integration topic as **compound faults** after coupled-axis authority, feedback integrity, communication/watchdog recovery, recorder integrity and synchronized diagnostics. F02 is materialized here as the integration lesson that prevents those individually correct mechanisms from being collapsed into a single misleading `fault` or `healthy` bit.

## Learning objective

An AI engineer completing F02 must be able to:

1. keep **current condition**, **latched diagnostic history**, **evidence validity**, **physical-I/O authority**, and **machine motion authorization** distinct;
2. trace how a single disturbance can create multiple observable faults without treating every symptom as an independent root cause;
3. preserve simultaneous/secondary fault evidence instead of using a destructive first-fault-only policy;
4. reject automatic motion reauthorization when a lower layer recovers but machine truth has not been independently reconciled;
5. distinguish a recorder/diagnostic failure from a machine-control failure while refusing unsupported physical conclusions from invalid evidence;
6. design deterministic fail-closed recovery logic that requires current prerequisites plus explicit rearm and never blindly resumes a stale command.

This is ordinary LinuxCNC/machine-control reasoning. It is **not** a functional-safety certification lesson and does not claim SIL/PL performance.

## Prerequisites now satisfied

- D01 — coupled-control/tandem authority: graduated.
- S02 — feedback integrity/common-cause reasoning: technical evidence accepted and fresh-AI PASS.
- E20 — Ethernet/watchdog recovery versus machine authorization: technical evidence accepted and fresh-AI PASS.
- X01 — recorder integrity: technical evidence accepted and fresh-AI PASS.
- X02 — synchronized multi-surface diagnostics: technical evidence accepted and fresh-AI PASS.

## Official-documentation pass

### Task state is not one undifferentiated health flag

LinuxCNC Developer documentation describes distinct Task states E-stop, E-stop Reset and Machine On. This is already evidence that state/authorization is explicit, not inferred from the disappearance of an unrelated diagnostic.

Reference: LinuxCNC 2.9 Developer Manual, Task controller state diagram.

### HostMot2 watchdog changes physical pin authority while module internals can remain active

The HostMot2 manual states that a watchdog bite disconnects I/O pins from their module instances and makes them inputs, while internal encoder/PWM/stepgen module state can continue. Clearing the watchdog `has_bit` restores communications/I/O configuration. This is exactly why internal changing state, physical pin authority, and machine motion cannot be represented by one generic `healthy` bit.

Reference: `hostmot2(9)` watchdog documentation.

### HAL watchdog recovery is explicitly latched/rearmed

The generic HAL `watchdog(9)` component sets `ok-out` false after a missing heartbeat and requires an enable transition to re-start monitoring. Recovery is therefore an explicit state transition rather than simple instantaneous inversion of a timeout condition.

Reference: `watchdog(9)` manual page.

### Homing creates coordinate validity used by later limits

Homing documentation distinguishes locating the home switch/index, assigning `HOME_OFFSET`, and the final move to `HOME`; the machine-coordinate origin and soft-limit relationship are established through that process. Losing a communication or feedback-validity assumption cannot be repaired merely because transport later becomes green.

Reference: LinuxCNC homing configuration documentation.

## Community pass

Community evidence is used only as field context and failure-discovery evidence, not as implementation authority.

### Communication loss can produce a secondary following error

In a Mesa 7i96 discussion, experienced community responders explicitly identify the joint following error as a consequence of lost communication and advise fixing the Ethernet loss rather than treating following error as the initiating problem. PCW explains that repeated delayed read responses can make `hm2_eth` disable communication after consecutive failures.

Source: https://forum.linuxcnc.org/38-general-linuxcnc-questions/39375-read-error-and-following-error-mesa-7i96

**COMMUNITY-REPORTED lesson:** simultaneous `COMM_LOSS` + `FOLLOWING_ERROR` observations do not justify claiming two independent root causes. Preserve both facts, but keep causal attribution bounded.

### Stale feedback can itself create following error after an Ethernet delay

A 7i96 thread explains that a missed packet can leave stale position feedback; at sufficient machine velocity, one stale servo-period observation can manifest as a substantial following error.

Source: https://www.forum.linuxcnc.org/27-driver-boards/35145-7i96-joint-following-error

**COMMUNITY-REPORTED lesson:** downstream symptom bits remain diagnostically useful, but their coexistence with a transport error requires causal ordering/provenance before root-cause claims.

### Watchdog/communication loss can leave displayed/internal position inconsistent with physical state

A 2025 field report describes a watchdog bite / communication-loss event followed by controller-side behavior that did not imply trustworthy physical position. PCW identifies loss of communication as the likely initiating mechanism.

Source: https://forum.linuxcnc.org/38-general-linuxcnc-questions/57774-program-stopped-do-not-understand-the-cause

**COMMUNITY-REPORTED lesson:** after communication/watchdog faults, returning software to a runnable state is not evidence that physical machine state is reconciled.

## Pinned-source inventory

| Source | Symbols / behavior | F02 relevance |
|---|---|---|
| `src/emc/task/emctask.cc` | `emcTaskAbort()`, `emcTaskSetState()` | Task abort clears pending command/interpreter state and queues resynchronization; OFF/ESTOP paths abort motion and disable trajectory authority. |
| `src/emc/task/emctaskmain.cc` | Task execution/error and abort call sites | Shows higher-level errors route through explicit abort/state handling rather than a universal auto-resume path. |
| `src/emc/motion/control.c` | joint/motion enable, following-error and homing state | Separates realtime joint/motion validity and motion authorization from Task/UI observation. |
| `src/hal/drivers/mesa-hostmot2/hm2_eth.c` | queued read/write confirmation, communication errors / soft-error recovery | Establishes current transport transaction evidence and error-history behavior; does not establish physical machine truth. |
| `src/hal/drivers/mesa-hostmot2/hostmot2.c` and watchdog support | watchdog handling / I/O authority | Establishes that physical pin authority is a distinct layer. |
| `src/hal/components/sampler.c` + stream implementation + `sampler_usr.c` | producer overrun and userspace retained sequence | Establishes evidence-validity boundary independently of control state. |

## Function/call-flow guide

### Task abort / state transition

Pinned `src/emc/task/emctask.cc::emcTaskAbort()`:

1. calls `emcMotionAbort()`;
2. clears the pending Task command and interpreter list;
3. sets interpreter state to IDLE and execution state DONE;
4. clears pause/line/call state;
5. queues an interpreter synchronization command;
6. closes/resets the task plan.

Pinned `emcTaskSetState()` treats OFF and ESTOP as explicit authority-changing transitions: it aborts motion, disables trajectory authority and performs Task/I/O cleanup. ESTOP_RESET is a separate state and does not mean Machine On.

**SOURCE-CONFIRMED consequence:** recovery cannot be modelled as `fault_bit == 0 -> resume old command`; LinuxCNC itself has explicit abort/resynchronization/state transitions.

### Compound transport -> stale feedback -> following-error observation

Bounded call-flow concept, using already accepted prerequisite evidence:

`hm2_eth transaction misses/invalid response`
→ transport diagnostic/error-history state changes
→ a fresh hardware feedback publication may be absent for the affected observation interval
→ motion/joint layer can compare commanded position against stale/unchanged feedback
→ following-error observation may occur
→ Task/UI/diagnostic surfaces publish their own later observations.

This flow does **not** prove every following error during a communication error is caused by communication. It proves that causal coupling is plausible and source/community-supported; F02 must therefore retain observations without inventing root-cause independence.

### Recorder failure branch

`sampler realtime producer`
→ `hal_stream_write()` fails when no FIFO space
→ producer overrun increments / attempted record is absent
→ userspace may later print contiguous successful-record tags.

A recorder failure invalidates claims that require complete retained coverage. It does not itself command or revoke machine motion unless an explicit control interlock is designed to do so.

## F02 policy model

F02 will test five separate state classes:

1. **Current conditions** — e.g. `transport_ok`, `feedback_valid`, `watchdog_clear`, `reference_valid`, `required_interlocks_ok`.
2. **Current motion authorization** — conjunction of required current conditions plus an explicit machine-authorized/rearm latch.
3. **Latched diagnostic history** — a non-destructive set of every observed fault class relevant to the episode.
4. **Evidence validity** — whether a diagnostic recorder interval is eligible for causal/timing claims.
5. **Recovery phase** — `RUNNING`, `FAULTED`, `RECONCILE`, `READY`, never automatic stale-command continuation.

A cause may affect more than one class, but the classes are not aliases.

## Claims ledger

| Claim | Class | Evidence | Boundary |
|---|---|---|---|
| Task OFF/ESTOP and abort perform explicit motion/plan/state cleanup. | SOURCE-CONFIRMED | pinned `emctask.cc` | LinuxCNC revision `8bf4605...` |
| HostMot2 watchdog bite can remove physical I/O pin authority while module internals remain active. | DOC-CONFIRMED + prerequisite source evidence | `hostmot2(9)`, E20 | Not physical actuator proof. |
| Ethernet loss can coexist with / precede a following error. | COMMUNITY-REPORTED, mechanism compatible with source | Mesa forum reports + E20 source trace | Not universal causal attribution. |
| Recorder overrun invalidates complete-coverage claims but is not inherently a motion-control fault. | SOURCE/TEST-CONFIRMED | X01 | Unless explicitly wired into an interlock. |
| Green transport after recovery is insufficient for machine reauthorization. | TEST-CONFIRMED + fresh-AI verified | E20 | Machine-specific revalidation remains required. |
| Two agreeing feedback channels cannot prove independent physical truth. | TEST-CONFIRMED + fresh-AI verified | S02 | Independent physical reference still needed for strong truth claim. |
| Nearest timestamps across HAL/Python/GUI do not prove same-cycle identity. | TEST-CONFIRMED + fresh-AI verified | X02 | Shared generation identity would be needed. |

## Predeclared prediction for F02-001

Before implementation/execution:

> If transport loss, following error and recorder invalidity occur in the same fault episode, a correct integration arbiter will preserve all three observations, revoke ordinary motion authorization because the control prerequisites are invalid, independently mark causal/timing evidence as degraded because the recorder is invalid, and refuse reauthorization after transport recovery until machine state is reconciled and an explicit rearm occurs. Clearing any one current condition must not erase the latched diagnostic history or restore a stale command.

The experiment must be rejected if it merely implements a single `fault` boolean, a first-fault-only diagnostic that destroys later evidence, or an auto-resume path.

## Adversarial questions F02 must eventually answer

1. Transport is green again, watchdog is clear, but reference validity is unknown. Can motion resume? Why not?
2. Communication loss and following error appear together. Which is the root cause? What can and cannot be concluded from ordering alone?
3. The recorder overruns during the event. Should that necessarily E-stop the machine? What evidence claim becomes invalid even if control remains safely revoked for another reason?
4. Two encoders agree after recovery. Is that sufficient to restore machine authorization?
5. A GUI timestamp places a following error before a Python-observed transport error. Does that establish causal order?
6. All current fault inputs clear while the operator has not rearmed. What remains false?
7. A second fault appears during reconciliation. May the reconciler continue to READY?
8. What must be logged atomically if an implementation claims same-cycle fail-closed revocation?

## Promotion / boundary

- Exact machine-specific revalidation procedure: 3000 machine specialization; does not block generic F02 if F02 requires explicit revalidation without inventing its contents.
- Functional-safety architecture / PL/SIL: 4000 safety-oriented hardware boundary; ordinary F02 logic makes no safety-rating claim.
- Exact physical stopping distance/time: machine/hardware-specific; not inferred from software state transitions.
- Universal causal ranking of compound faults: explicitly rejected. F02 teaches preserved observations + bounded attribution, not a universal root-cause oracle.
