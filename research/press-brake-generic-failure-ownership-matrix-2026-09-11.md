# Generic press-brake failure ownership matrix

Date: 2026-09-11
Course context: dependency-safe 4600 preparation; generic/public architecture only
Pinned LinuxCNC source baseline for source claims: `8bf4605ae81042248add031e94c77300406e0413`
Related evidence:
- `research/press-brake-cycle-timeout-ownership-2026-09-11.md`
- `call-flows/press-brake-M66-Q-supervisory-wait-timeout.md`
- `experiments/M66-TIMEOUT-001-run079-independent-audit.md`
- `research/m66-timeout-stale-state-fix-review-2026-09-11.md`

## Purpose

A press brake combines ordinary LinuxCNC motion, fast tandem synchronization, hydraulic/process sequencing, field I/O, operator/supervisory logic and a separate functional-safety system. A failure must not be assigned to a layer merely because that layer can observe some symptom.

This matrix records **generic ownership**, not machine-specific thresholds or valve truth tables. Exact limits, response times, permitted recovery actions and safety functions require the actual machine risk assessment and hardware architecture.

## Layer shorthand

- **MOTION:** LinuxCNC joint/trajectory layer and its ordinary following-error/limit/homing mechanisms.
- **SYNC:** servo-period Y1/Y2 differential synchronization and side-disagreement monitoring using physical side feedback.
- **PROCESS:** press-cycle state machine: approach/change point/working stroke/dwell/decompression/return and process completion where these are not ordinary trajectory semantics.
- **HYDRAULIC:** machine-specific decoding/actuation authorization for pumps, directional/proportional valves and pressure mode.
- **PROGRAM:** interpreter/Task/supervisory program waits such as M66.
- **FIELD-I/O:** HostMot2/transport/driver path and its communication/watchdog evidence.
- **SAFETY:** independent functional-safety chain. Ordinary LinuxCNC software is not presumed safety-rated.

## Failure ownership matrix

| Failure / condition | Primary detector / evidence | Timing class | Ordinary-control owner | Minimum ordinary response contract | Diagnostic witness | Safety boundary |
|---|---|---|---|---|---|---|
| One physical Y scale stops changing while its side is commanded/moving | side-specific physical feedback age/change plus command context; encoder/field-I/O diagnostics where available | servo-period / bounded persistence | SYNC + MOTION/feedback diagnostics | stop or inhibit normal tandem continuation according to validated machine policy; do not substitute Cartesian Y as proof of side position | Y1/Y2 physical positions, command, feedback age/change witness, encoder/transport status | any hazardous-motion removal requirement belongs to SAFETY |
| Joint following error exceeds LinuxCNC threshold | LinuxCNC per-joint ferror logic | servo-period | MOTION | enter LinuxCNC motion fault/disable path; PROCESS must not continue a bend merely because its own state remains active | joint ferror, threshold, motion error/status | not a safety-rated stop by itself |
| Y1−Y2 side mismatch exceeds permitted ordinary-control bound | explicit differential error from physical Y1/Y2 feedback; not Cartesian/master Y | servo-period | SYNC | bounded correction while valid; transition to tandem fault when correction authority/allowed mismatch is exceeded | differential error, sync correction, side commands, final limiter/saturation state | permissible mismatch and hazardous stop response require machine validation/safety analysis |
| One side command reaches final actuator limit/saturation | final command allocator/limiter after all common and differential corrections | servo-period | SYNC/HYDRAULIC interface | expose loss of correction authority; do not keep integrating/correcting as though full authority remains | pre-limit command, final command, saturation flag per side | saturation is ordinary-control evidence, not safety proof |
| Both/one scale values are implausible or disagree with independent reference | explicit plausibility/redundancy logic where implemented | servo-period to qualified persistence | SYNC / feedback-integrity layer | reject invalid feedback for continued tandem control and fault according to validated policy; never silently choose a convenient sensor | raw scales, plausibility residual, qualification timer/state | independent safety position monitoring, if required, belongs to SAFETY hardware/system |
| Hydraulic pressure not achieved by expected process point | pressure transducer/switch or other process feedback with explicit state/time context | process-cycle; possibly fast sampling but semantic timeout is PROCESS-owned | PROCESS | terminate/abort current process state according to hydraulic shutdown contract; report pressure-not-achieved distinctly from motion error | process state, pressure witness, target/qualification, elapsed state time | pressure limiting/protection may have separate hardware/safety requirements |
| Hydraulic pressure exceeds ordinary control limit | pressure feedback compared in the realtime/process control path | servo-period or fast process loop | HYDRAULIC/PROCESS ordinary fault path | remove/inhibit ordinary pressure command and force defined process abort; retain cause | measured pressure, configured ordinary limit, command/mode, fault latch | overpressure protection cannot be assumed satisfied by PC software; hardware/code compliance separate |
| Operator pedal/request released during an active cycle | pedal/request input after ordinary qualification | process-cycle; response class depends on machine mode | PROCESS, with HYDRAULIC authorization responding to resulting state | explicit state transition; never rely on a GUI timeout to infer release | raw/qualified request, process state, transition reason | safety pedal/three-position/enabling-device functions, if applicable, belong to validated SAFETY architecture |
| Expected non-time-critical process input never arrives | process input plus explicit state timer; or PROGRAM M66 only where documented non-realtime behavior is sufficient | process/supervisory | PROCESS for machine-cycle semantics; PROGRAM for G-code-level supervisory waits | explicit timeout/failure transition; distinguish timeout from false/low input | input state, wait type, elapsed/timeout, process/program state, `#5399` where M66 used | M66/HAL/software timeout is not a safety device |
| `M66 Q` times out | LinuxCNC Task delay/input-wait state; synchronized interpreter sees `#5399=-1` | non-realtime supervisory | PROGRAM | program must branch/abort/recover explicitly if timeout means failure; do not reinterpret it as a fast machine fault | `#5399`, Task input-timeout state, program line/state | explicitly unsuitable as primary tandem/safety detector; current pinned source also has confirmed stale-state defect after timeout |
| M66 timeout is followed by G4 and dwell stalls | stale `emcAuxInputWaitIndex` surviving timeout into shared `WAITING_FOR_DELAY` | Task/userspace | LinuxCNC Task defect, not press-process owner | source correction should disarm timed-out input waiter while preserving `input_timeout=1`; focused regression required | run079 markers; Task input_timeout/index/delay state | no change to safety allocation; reinforces supervisory-only use |
| Field-I/O Ethernet/HostMot2 communication loss or stale transport | hm2_eth/HostMot2 transport error plus watchdog/driver evidence; distinguish software transport recovery from FPGA watchdog state | servo-period / transport watchdog | FIELD-I/O, propagated to MOTION/HYDRAULIC authorization | inhibit further trusted I/O commands as defined by verified recovery design; surface stale/failed transport distinctly | driver error/recovery state, HostMot2 watchdog, motion/I/O authorization | hardware safe-state and safety-chain response must be independently designed; transport recovery is not safety authorization |
| HostMot2 watchdog trips | HostMot2 watchdog status/physical output behavior | hardware/servo interaction | FIELD-I/O / hardware interface | require deliberate recovery/re-enable sequencing; ordinary control must not assume outputs remained valid | watchdog has-bit/tripped state and relevant output-enable evidence | watchdog behavior is not automatically a safety-rated function |
| Program/task execution stalls while servo thread still runs | Task heartbeat/status freshness vs independent realtime witnesses | userspace supervisory | PROGRAM/HMI diagnostics | stop advancing process-program semantics; present stale Task condition; machine-specific ordinary authorization may need to expire independently | Task heartbeat, motion heartbeat/realtime status, command/status generations | hazardous motion must not depend solely on GUI/Task freshness unless validated as part of safety system |
| Realtime servo execution misses/degrades timing | realtime latency/deadline diagnostics, watchdogs, motion/control symptoms | realtime | platform/MOTION/control infrastructure | fault/inhibit operation according to validated realtime health policy; preserve timing evidence | latency/deadline witnesses, watchdogs, servo period/overrun diagnostics | safety function remains separate |
| Safety chain opens / light curtain / E-stop safety channel removes permission | safety controller/relay/drive-safe-state chain, not an ordinary HAL state alone | safety-system response time | SAFETY | safety system directly enforces required safe state; LinuxCNC may observe status for diagnostics/recovery but does not own the safety action | safety device/controller diagnostics plus LinuxCNC indication if provided | **SAFETY-owned by definition**; LinuxCNC observation must never be treated as the sole enforcement mechanism |
| Safety permission is absent at startup/recovery | safety chain status plus ordinary machine-enable prerequisites | before motion authorization | SAFETY for permission; MOTION/HYDRAULIC for ordinary enable gating | ordinary software must remain disabled until permission and all ordinary prerequisites are valid; recovery must be explicit | safety-permission indication, machine state, drive/output enables | software cannot manufacture safety permission |
| Process component crashes/ceases updating while motion layer remains alive | component heartbeat/generation witness if designed; inconsistent process authorization age | servo/process | PROCESS/HYDRAULIC authorization | expire process-specific authorization rather than hold last hazardous request indefinitely | component heartbeat, state age, final hydraulic authorization | independent safety protection still required |

## Causal ownership rules extracted from the matrix

1. **Detect from the closest trustworthy evidence.** A side-mismatch detector needs Y1 and Y2 physical feedback; Cartesian Y or a GUI DRO is insufficient because duplicated-coordinate forward position can represent only the principal mapped joint.
2. **The operation owner must own a terminal transition.** Detecting a timeout without defining the state transition it causes is incomplete.
3. **Final command authority must be observable.** Differential correction before a downstream clamp does not prove the actuator received the requested correction; retain per-side final saturation/limit evidence.
4. **Do not collapse timing classes.** Servo-period faults, process timeouts and non-realtime interpreter waits all use elapsed time but have different causal evidence and permissible responsibilities.
5. **Communication recovery is not machine authorization.** A transport that reconnects does not prove feedback is trustworthy, outputs are in a known state, or the process may resume.
6. **Safety permission is not ordinary state.** LinuxCNC may consume safety-system status for diagnostics and recovery sequencing, but generic HAL logic, Task, M66 and GUI watchers are not presumed safety-rated.

## Adversarial cases

### Case A — equal Cartesian Y, unequal scales

If the displayed Cartesian Y is correct but Y1 and Y2 physical scales differ beyond the ordinary-control bound, the equal Cartesian display does not clear the mismatch. SYNC owns the discrepancy detector because the forward kinematic coordinate is not a redundant side witness.

### Case B — process timeout while both position loops look healthy

Healthy Y1/Y2 tracking does not prove the pressure/process event occurred. PROCESS owns the missing-event timeout and its abort transition; MOTION remains responsible only for its own joint behavior.

### Case C — Ethernet recovers after several bad cycles

Successful reconnect is not permission to resume a bend. FIELD-I/O can report transport recovery; higher layers must re-establish fresh feedback/output state and explicit machine/process authorization. Safety permission remains independent.

### Case D — light curtain changes a HAL input

Seeing the light-curtain state in HAL is useful diagnostics, but it does not prove the HAL path is the safety enforcement channel. The required protective stop must be owned by the validated SAFETY architecture.

### Case E — M66 timeout reports `#5399=-1`

The correct `#5399` result alone does not prove Task state is clean. The pinned source and run079 show the wait index can survive and contaminate a following G4. Program logic must therefore not infer that a correct timeout return proves all internal wait state is reset.

## Open questions intentionally not invented here

- exact safe Y1/Y2 mismatch threshold and persistence time;
- exact pressure limits, tonnage model and pressure-ramp behavior;
- exact valve/spool truth tables and electrical safe state;
- exact pedal mode/three-position behavior;
- exact safety performance level/category/SIL or applicable regulatory design;
- exact final Y1/Y2 correction insertion topology (PB-PREP-001 remains INCONCLUSIVE);
- exact recovery sequence after field-I/O or safety-chain interruption.

These require machine-specific engineering, additional public-source evidence, or a later activated 4600 implementation module. Their absence does not justify inventing values in the public curriculum.

## Next research checkpoint

The matrix exposes the next high-information source task: inspect a mature public press-brake cycle component/config for **explicit terminal transitions** on pressure/process timeout, pedal release, motion fault and machine disable, then compare those transitions with this ownership model. Prioritize the already-audited Accurpress chronology because source is available; use Ursviken only for claims actually published. In parallel, preserve the M66 abort-state cleanup concern as a bounded LinuxCNC source issue rather than expanding the supervisory-wait investigation unless it affects the press-cycle architecture.
