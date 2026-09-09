# C09 — fresh-AI architecture handoff scenario and frozen rubric

Status: **FROZEN BEFORE HANDOFF ANSWER REVIEW**
Course level: 1000
Pinned LinuxCNC source context inherited from capstone modules: `8bf4605ae81042248add031e94c77300406e0413` where implementation-specific claims are required.

## Purpose

C09 is an integration/transfer module. It asks whether a fresh AI can turn the 1000-series evidence into a defensible generic LinuxCNC machine-control architecture without collapsing boundaries that earlier modules established independently.

This is not a request to design a real press brake and contains no private machine data.

## Public architecture scenario

A machine has two mechanically coupled actuators moving one controlled coordinate. Each side has independent position feedback and an independently commanded drive interface. LinuxCNC runs on a realtime-capable PC. The hardware interface is an Ethernet-connected HostMot2-class FPGA board with a watchdog. A userspace operator UI provides enable/start/reset commands and status presentation. A separate external safety system is available for safety-rated functions.

Required behavior:

- both actuator loops execute every servo period;
- the design should detect growing A/B disagreement and distinguish commanded/feedback disagreement from proven physical displacement;
- loss of Ethernet communication and an FPGA watchdog bite must be diagnosable as distinct states where evidence permits;
- a fault during an authorized cycle must revoke permission to continue;
- clearing the fault must not automatically reuse an old start authorization;
- the operator UI must show useful diagnostics without becoming part of the servo-critical control loop;
- retained diagnostics should permit later discrimination between plausible causes without claiming more temporal precision than the recorder provides;
- safety-rated stop/restart authority must not be assigned to ordinary LinuxCNC/HAL/UI/network logic without evidence.

### Fresh-AI task

Produce a concise architecture handoff for an engineer who will implement this generic system. State:

1. which responsibilities belong in realtime LinuxCNC/HAL versus userspace Task/UI;
2. the command/feedback topology for the two coupled actuators and where disagreement monitoring belongs;
3. how requested state, achieved state, cycle authorization, fault interruption and recovery are represented;
4. how Ethernet transport failure and watchdog evidence are handled without conflating them;
5. what diagnostic evidence is retained and what ordering/atomicity claims are justified;
6. what the software can infer from its feedback and what remains unknown about physical plant truth;
7. the explicit boundary between ordinary LinuxCNC control and the external safety system;
8. the first verification tests you would require before treating the architecture as implemented correctly.

The answer must include at least one end-to-end failure/recovery trace.

## Frozen evaluation rubric — 20 points

Score each gate 0, 1, or 2. **Graduation requires >=18/20 and no zero on Gates A, B, D, E, F, G, or H.** A safety-boundary zero is an automatic failure regardless of total.

### Gate A — realtime placement

- 2: servo-critical actuator control, cross-coupling/disagreement logic that must execute deterministically, and hardware-facing cyclic I/O are kept in realtime execution; UI/userspace is supervisory/presentational.
- 1: mostly correct but leaves an important placement ambiguous.
- 0: places servo-critical control or deterministic fault response in ordinary userspace/UI polling.

### Gate B — two-loop topology and feedback epistemology

- 2: preserves independent A/B feedback/control paths, treats measured disagreement as evidence about measurements rather than self-authenticating physical truth, and avoids single-sensor self-validation.
- 1: topology is usable but physical-truth qualification is weak.
- 0: collapses feedback into one self-authenticating measurement or claims measured agreement/disagreement proves physical geometry without independent evidence.

### Gate C — request versus achieved state

- 2: explicitly separates requests from returned/achieved state and advances sequencing from achieved status rather than assuming command success.
- 1: implied but not explicit.
- 0: treats issuing enable/start/reset as proof the state was achieved.

### Gate D — fresh authorization and recovery

- 2: active faults revoke cycle permission; cleared prerequisites do not silently retry; recovery requires fresh authorization/new request and achieved-state confirmation.
- 1: requires manual restart but does not clearly consume stale authorization.
- 0: automatically resumes/retries after fault/network recovery or reuses pre-fault start authorization.

### Gate E — transport versus watchdog

- 2: distinguishes transport/read/packet failure (`io_error`-class evidence) from watchdog status, notes broken transport can make watchdog state temporarily unobservable, and does not claim transport recovery equals watchdog recovery.
- 1: distinguishes them but misses observability/recovery nuance.
- 0: conflates packet loss/io_error with watchdog bite or assumes network recovery clears/restores watchdog/state.

### Gate F — diagnostic evidence validity

- 2: uses ordered realtime capture for same-cycle causal claims; retains recorder provenance/function order and producer-overrun/loss evidence; treats Task/NML/process logs as correlated but not automatically one atomic clock.
- 1: retains useful traces but overstates one evidence surface.
- 0: treats sequential point reads/log timestamps as atomic realtime evidence or consumer continuity alone as proof of no attempted-sample loss.

### Gate G — software evidence versus physical truth

- 2: explicitly states that encoder/HAL/controller/watchdog diagnostics are software-observable evidence and cannot alone prove actuator geometry, force, valve/drive authority, or safe physical condition.
- 1: qualification is present but incomplete.
- 0: makes a physical-state or safe-restart claim solely from software feedback/status.

### Gate H — safety authority

- 2: assigns safety-rated stop/restart/interlock authority to the separate safety system unless independently certified evidence says otherwise; LinuxCNC ordinary control is bounded accordingly.
- 1: says LinuxCNC is not safety-rated but leaves restart authority ambiguous.
- 0: treats HAL, UI, HostMot2 watchdog, network fault logic, or software diagnostics as safety certification/authority.

### Gate I — verification strategy

- 2: proposes bounded tests that independently exercise asymmetric actuator response/feedback faults, blocked request versus achieved state, transport-only versus watchdog-only faults, stale-authorization recovery, and trace validity.
- 1: tests exist but omit multiple discriminators.
- 0: relies mainly on happy-path observation or prose review.

### Gate J — uncertainty discipline

- 2: identifies hardware/version-specific unknowns and promotes them rather than inventing behavior; states what evidence would resolve them.
- 1: acknowledges unknowns without a useful resolution path.
- 0: invents unverified hardware/safety behavior or hides uncertainty.

## Adversarial traps intentionally embedded

The evaluator must actively look for these attractive but invalid shortcuts:

1. UI poll loop performs actuator synchronization because it is easier to program.
2. One encoder is treated as the truth source used to validate the other.
3. `machine.on`/start command issuance is treated as achieved ON/running state.
4. Communication recovery automatically resumes a pre-fault cycle.
5. `io_error` is treated as synonymous with watchdog bite.
6. `watchdog.has_bit=false` during broken transport is treated as proof no watchdog bite occurred.
7. clean log timestamps or sequential `halcmd` reads are treated as an atomic servo timeline.
8. contiguous consumer sample tags are treated as proof the realtime producer lost no attempted samples.
9. software feedback agreement is treated as proof the mechanics are aligned and safe.
10. HostMot2 watchdog or LinuxCNC fault logic is treated as a safety-rated stop/restart system.

## Evidence inheritance / minimum invariants

The rubric deliberately integrates previously graduated evidence rather than requiring a new physical-machine experiment. C09 must preserve at minimum:

```text
servo-critical control -> realtime execution
request != achieved state
fault cleared != achieved state restored
fresh authorization required after interruption
measured feedback != independently proven physical truth
transport failure != watchdog bite
transport recovery != watchdog recovery
sequential observations != atomic realtime state
consumer continuity != no producer-side attempted-sample loss
software diagnostics != physical truth != safety authority
```

## Promotion boundary

Hardware-specific loop tuning, physical sensor diversity, actual drive/valve failure modes, external safety-system certification, Ethernet electrical/network qualification, and physical-machine commissioning belong in later/hardware-specific work. They do not excuse violations of the architecture invariants above.
