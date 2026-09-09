# C09 — integrated 1000-level architecture invariants

## Scope

This guide is the minimum architecture contract a fresh LinuxCNC engineer should carry from the completed 1000-series work into a generic coupled-actuator machine design. It intentionally avoids machine-specific implementation data.

## Responsibility partition

### Realtime control plane

Keep cyclic hardware I/O, per-actuator control, synchronization/cross-coupling that depends on servo-period ordering, and deterministic fault-state inputs in the realtime execution graph. Function order is part of behavior: a value sampled before a producer runs is not equivalent to the same named value sampled after it.

### Task / NML / userspace supervision

Task and NML coordinate commands, modes and status across process boundaries. A UI or HALUI endpoint can request a transition, but request publication is not proof the requested state was achieved. Userspace presentation may lag or fail while controller state changes independently. Therefore UI state is a projection, not control-loop truth.

## Coupled actuator topology

Use separate feedback/control paths for actuator A and B. A shared coordinate command may fan out to both loops, while each loop retains its own feedback and actuator command. Cross-coupling can use measured A/B disagreement to reduce disagreement, but that does not transform either sensor into an independent truth oracle.

Important epistemic boundary:

```text
A_feedback ~= B_feedback
```

means the two reported measurements agree within the chosen criterion. It does not independently prove that the physical members are aligned, that both sensors are correctly coupled, or that actuator authority is healthy. Common-mode sensor faults and mechanical decoupling require evidence outside the pair itself.

## State transition contract

Represent at least three distinct concepts:

1. **request** — an edge/event asking LinuxCNC to change state;
2. **achieved state** — returned status showing the controller actually reached the requested condition;
3. **cycle authorization** — permission to initiate/continue the hazardous or consequential sequence.

A sequencing rule should advance from achieved state, not from request issuance. A fault consumes/revokes the current authorization. Restoring a prerequisite or clearing a fault does not resurrect the old authorization and does not imply the previously requested state was automatically restored. Require a fresh authorization and a fresh request where appropriate, then confirm achieved state again.

## Transport and watchdog fault contract

Keep Ethernet/transport failure and FPGA watchdog evidence separate.

- Transport/read/packet failures can escalate to an `io_error`-class software-visible state.
- Watchdog bite evidence comes from the watchdog status path when that status can be read and processed.
- Failed communication can prevent watchdog service and therefore causally lead to a watchdog bite, but causal relationship is not state identity.
- While transport is broken, `watchdog.has_bit=false` is not proof the FPGA watchdog did not bite because current watchdog status may be unobservable.
- Recovering network transport is not proof the watchdog, machine state, authorization, or physical plant has recovered.

## Diagnostic evidence contract

For a same-servo-cycle causal claim, use a retained realtime observation stream whose function placement/order relative to relevant producers is known. Preserve collector lifecycle, configuration/provenance, and producer-side loss/overrun evidence.

At the pinned development revision used by the capstone, contiguous consumer sample tags describe successful retained enqueues; they do not prove the realtime producer never attempted a sample while the FIFO was full. Thus consumer continuity alone is not a no-loss oracle.

Task/NML/error-channel/process-log events can be correlated with realtime traces, but they do not become one atomic global clock merely because timestamps are nearby. State the synchronization mechanism before making cross-surface ordering claims.

## Safety boundary

Ordinary LinuxCNC, HAL components, HostMot2 watchdogs, Ethernet fault logic, UI interlocks and diagnostic traces are machine-control mechanisms/evidence. Do not call them safety-rated or assign them certified safe-stop/restart authority without independent evidence appropriate to that claim.

The architecture should allow an external safety system to remove or withhold hazardous authority independently of ordinary software state. Logical recovery in LinuxCNC is not proof the physical machine is safe to restart.

## Verification contract

Before accepting an implementation of this architecture, independently test at least:

- shared command with asymmetric actuator response and retained A/B same-cycle evidence;
- frozen/jumping/biased feedback cases, including a case where sensor agreement is misleading;
- a state request blocked by a prerequisite, proving request != achieved state;
- fault interruption followed by prerequisite restoration, proving stale authorization is not reused;
- transport-only failure and independently observable watchdog-status behavior;
- a recorder-overrun adversary showing that trace validity is checked rather than assumed;
- userspace/UI presentation failure while controller state remains independently observable.

Physical commissioning adds separate tests for actual sensor coupling, actuator authority, mechanics, external safety functions and failure energy. Those cannot be proven by the software laboratory alone.

## Retrieval cues

When reviewing a proposed architecture, ask these in order:

1. What must execute every servo period, and in what function order?
2. Is this a request, an achieved state, or an authorization?
3. What produces this feedback/status, and can it authenticate the physical fact being claimed?
4. Is this a transport fault, watchdog evidence, or a causal hypothesis connecting them?
5. Is the evidence atomic realtime capture or only correlated userspace/log observation?
6. What proves the recorder itself retained what the conclusion assumes?
7. Who owns safe-stop/restart authority, and what evidence supports that classification?

If the architecture cannot answer one of these, preserve the uncertainty instead of inventing a guarantee.
