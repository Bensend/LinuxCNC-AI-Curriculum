# C06 Fresh-AI Novel Scenario Handoff and Promotion Audit

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Novel scenario
A Mesa-Ethernet-controlled machine is running normally. Then the host begins missing replies. The low-level transport eventually exposes `io_error=true`, while `watchdog.has_bit` is still false. During the outage the physical machine cannot be observed from the controller. A technician restores the network and clears `io_error`; on the first successful reads, `watchdog.has_bit` becomes true. The technician clears that pin too, sees HostMot2 service resume, and proposes automatic cycle continuation because the reported position still equals the last commanded position.

Using only the C06 artifacts and referenced pinned source, determine:

1. what can be concluded at the first `io_error=true / watchdog.has_bit=false` observation;
2. why the later watchdog indication is not a contradiction;
3. the transport-vs-watchdog recovery sequence and what each clear actually permits;
4. whether command/feedback agreement after recovery proves the plant is safe to resume;
5. what evidence a real-machine commissioning procedure would still need.

## Handoff solution

1. **At `io_error=true / watchdog.has_bit=false`, only transport escalation is established.** The low-level driver has declared an I/O fault. The false watchdog pin does not prove the FPGA watchdog did not bite, because generic HostMot2 watchdog status is processed from successfully returned TRAM data and is skipped while reads fail/`io_error` blocks normal service.
2. **A later watchdog indication after transport recovery is causally plausible and state-consistent.** Communication/timing loss may delay the normal write/pet service long enough for the FPGA watchdog to expire. Once communication succeeds again, the previously unobservable watchdog status can be processed, asserting real `watchdog.has_bit` and `needs_reset`. Thus `transport fault -> possible later-observed watchdog bite` does not imply `transport fault == watchdog bite`.
3. **The two recovery boundaries remain distinct.** Clearing `io_error` permits the low-level/generic HostMot2 path to resume trying normal I/O. A valid watchdog bite can then be observed. While `watchdog.has_bit` remains true, generic watchdog recovery is held. Clearing `watchdog.has_bit` permits the pending reset/reconfiguration path, including `hm2_force_write()`, provided transport remains healthy. Either state can recur and abort progress.
4. **Command/feedback agreement is not safe-resume proof.** During the outage the controller may lack independent knowledge of physical position/output/energy state. A recovered reported value can be stale, wrong, or simply not independent of the same I/O chain that failed. Ordinary HostMot2/HAL recovery establishes control-software state, not functional-safety state.
5. **Real-machine commissioning still needs hardware-specific evidence:** board/firmware watchdog electrical output behavior; drive/valve/contactor behavior when board pins become inputs; whether outputs fail to an actually safe state; independent position/state verification where needed; stored-energy and motion hazards; restart interlocks/state-machine integrity; network/realtime fault characterization; and the applicable machine safety architecture/standards. Those requirements are outside what the software-only fixture can establish.

## Evaluation

**PASS at 1000 level.** The scenario combines transport escalation, delayed observability of watchdog status, sequential recovery, and a misleading safe-resume inference in a way not stated verbatim by the accepted experiment. The solution correctly transfers the source/experiment mechanisms without inventing physical certainty.

The strongest transfer discriminator is the asymmetric observability rule:

```text
watchdog.has_bit == true
    => generic HostMot2 processed watchdog-bite status in the tested contract

watchdog.has_bit == false while transport/read service is broken
    != proof that the FPGA watchdog did not bite
```

## Higher-level promotion / uncertainty queue

| Item / question | Current evidence | Why unresolved / deferred | Consequence if wrong | Destination | Priority | Blocks current graduation? | Why promotion is safe |
|---|---|---|---|---|---|---|---|
| Exact meaning of the current `hostmot2(9)` phrase "all communication with the board stops" across boards/firmware/driver revisions | Current official docs conflict; pinned host-side source has readable watchdog status/recovery paths | Requires board/firmware/version-specific contract and likely hardware testing | Changes version-specific diagnostic details | 2000 / HM08-E08 | HIGH | No | C06 explicitly refuses to infer a universal communication state from `watchdog.has_bit`; its core separation does not depend on resolving the phrase universally |
| Real Mesa-Ethernet timing from packet loss through missed pet to watchdog bite | Source/docs plus community causal reports; deterministic fixture separates states but does not emulate physical Ethernet/FPGA timing | Requires real hardware, controlled packet/timing faults, and board timing capture | Changes timing probabilities/latency, not state identity | 2000 / E05-E08-S03 | HIGH | No | The 1000-level claim is only that the mechanisms are distinct yet causally linkable; no universal timing bound is taught |
| Electrical state of actual connected outputs/drive inputs after watchdog I/O disconnection | Documentation describes HostMot2 pins becoming high-impedance inputs; no target-machine electrical validation | Depends on pullups, interface circuitry, drives/valves, external wiring and machine architecture | Material to real safe-state behavior | 2000+ / S01-S03-IO07 | CRITICAL for a machine design | No for generic C06 | C06 explicitly states watchdog bite is not proof of physical safe state, so no unsafe generic conclusion depends on the missing hardware evidence |
| Safe restart/state reconstruction after communication + watchdog fault | C06 verifies software fault-state transitions only | Requires machine state model, independent sensors, stored-energy analysis and restart interlocks | Material to automatic restart policy | 2000 / S07 and capstone sequencing | HIGH | No | C06 explicitly prohibits treating software reset as restart authorization |
| Distribution of real-world `packet-error-limit`, `packet-read-timeout`, servo period and network topology settings | Pinned defaults/source semantics plus docs; installations vary | Version/configuration/hardware dependent | Changes tuning/diagnostic thresholds | 2000 / E05-E07 | MEDIUM | No | The accepted experiment labels its 3-failure threshold as a fixture analogue and teaches configuration-aware diagnosis |

## Counterfactual promotion test

Assume every promoted item turns out differently from the current expectation: a particular board truly blocks communication after watchdog bite, a physical Ethernet path reaches watchdog timeout at a different latency, an external drive reacts unexpectedly to high-impedance inputs, or a machine requires a different restart sequence. None overturns the central C06 teachings because they are deliberately scoped to evidence:

- host communication failure state and watchdog-bite state are not identical;
- generic HostMot2 watchdog status depends on successful status observability in the tested contract;
- transport recovery and watchdog recovery are separate;
- a causal sequence from communication/timing trouble to watchdog bite is possible without making the states synonymous;
- neither software fault indication nor software fault clearing proves a physical machine is safe to resume;
- version/firmware/hardware claims must be verified at their actual target.

Therefore the promoted items do not invalidate the C06 evidence chain, downstream prerequisites, or retained safety boundary.

## Minimum graduation evidence floor audit

- [x] Core mechanism identified from pinned source (`hm2_eth`, generic HostMot2 read/write, watchdog process/write/recovery).
- [x] Behaviorally significant execution paths traced end-to-end for transport failure and watchdog processing/recovery.
- [x] Independent verification exists: accepted C06-046 authoritative deterministic fixture, 2,976 ordered samples, frozen Gates A–H PASS.
- [x] Representative failure path understood: read failure/soft-error escalation to `io_error`, skipped normal service, distinct watchdog status path.
- [x] Predeclared prediction checked against independent evidence: C06-030 frozen before implementation and later accepted without changing Gates A–H.
- [x] Fresh-AI handoff demonstrates a novel course-level scenario and preserves uncertainty/safety boundaries.
- [x] No promoted item can overturn the central 1000-level teaching as scoped.
- [x] Every promoted item states why promotion is safe.

## Graduation sufficiency decision

C06 has official-documentation research, community leads, pinned-source mechanism tracing, function/call-flow artifacts, a deterministic hardware-free fixture, multiple preserved harness-invalid/corrected attempts, an accepted authoritative experiment with predeclared gates, a 10/10 adversarial exam, the correction for asymmetric watchdog observability, and this novel transfer scenario.

The unresolved work is version-, firmware-, Ethernet-hardware-, target-output-, or machine-restart-specific. Those questions matter greatly to a real machine design, but C06 does not claim answers it has not established. The counterfactual test therefore passes.

**Decision: C06 — GRADUATED at 1000 level.**
