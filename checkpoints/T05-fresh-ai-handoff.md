# T05 — fresh-AI handoff: custom operator-interface patterns

Course level: **1000**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Status: **HANDOFF READY; graduation still requires valid T05-022 reconciliation**

## What the next AI must know

A LinuxCNC operator interface is not one evidence domain. Preserve these boundaries:

```text
operator intent
 -> command producer/transport
 -> matching semantic result
 -> controller status observation + freshness
 -> HAL/physical evidence where required
 -> diagnostics
 -> independent safety authority
```

Do not turn a green/enabled widget into proof of all seven.

## Representative source-grounded paths

### HALUI command path

```text
HAL input transition
 -> halui check_hal_changes()
 -> send*()
 -> emcCommandSend()
 -> Task/controller
```

HALUI's command pins represent operator intent. Local HALUI prechecks do not replace final controller semantics.

### HALUI status path

```text
NML status
 -> HALUI updateStatus()
 -> emcStatus snapshot
 -> modify_hal_pins()
 -> halui.* output
```

HALUI output pins are userspace projections of the most recently obtained controller status. They are not automatically realtime, direct physical, or safety-rated truth.

### QtVCP startup/freshness path

Pinned screen startup calls handler `initialized__()` before QtVCP's explicit `STATUS.forced_update()` synchronization point. But `_GStat.__init__()` can already make a best-effort `stat.poll()+merge()` and retain cache while `_status_active` remains false.

Therefore:

```text
object constructed / cached value exists
!= validated current observation
!= command acceptance
!= physical action
!= safe state
```

A controller-dependent UI action should have a declared freshness contract and normally start fail-defined.

### GStat failed update

```text
GStat.update()
 -> stat.poll() raises
 -> _status_active = False
 -> emit periodic
 -> return without that update's merge/state-change processing
```

A responsive GUI and generic periodic events can therefore coexist with invalid controller observation.

## Design checklist

Before implementing a custom control, answer:

1. Who owns the operator intent?
2. Which process/object actually sends the command?
3. How is the result correlated to that command rather than another producer's traffic?
4. What status source drives presentation?
5. What proves that observation is current enough for the decision?
6. Is physical/HAL evidence separately required?
7. Who consumes and, if needed, fans out diagnostics?
8. What lower layer enforces authoritative machine preconditions?
9. What independent safety function exists for hazardous conditions?

## Failure habits to avoid

- enabling a controller-dependent action from construction-time defaults;
- treating retained cache as current merely because it has a plausible value;
- treating HALUI status outputs as direct hardware truth;
- using one producer's `wait_complete()` to prove another producer's command completed;
- treating absence of an error popup as success;
- assuming multiple error-channel consumers each receive a complete diagnostic history;
- leaving controls active indefinitely after status validity/freshness is lost;
- treating GUI disablement as a safety-rated interlock.

## Novel handoff scenario

A machine has:

- a hardwired pendant using HALUI for operator requests;
- a local QtVCP screen;
- a remote service that can also issue maintenance commands.

The local screen has successfully shown Machine ON. Its status polling then fails, but its event loop continues to render. During the outage the pendant operator presses a command button.

### Required reasoning

A competent fresh AI should conclude:

- the local QtVCP screen must treat its controller-derived observation as invalid/stale according to its declared freshness policy and should fail-define relevant advisory controls;
- the old Machine ON display is only retained presentation, not proof of current Task or physical state;
- the screen cannot infer from its own communication failure whether HALUI/controller communication is functioning;
- it cannot use its own command object's `wait_complete()` as a proof about the pendant/HALUI command;
- the pendant edge represents intent; Task/controller semantic processing remains authoritative for command acceptance;
- any claim that physical machinery changed requires the relevant motion/I/O/HAL/hardware evidence;
- any hazardous safety claim requires the separate safety architecture, not QtVCP or HALUI presentation state.

This scenario is intentionally not answered by a single sentence in the research guide; it requires combining T03 result ownership, T04 freshness, and T05 custom-OI boundaries.

## Promotion awareness

Do not invent answers for the following higher-level topics:

- detailed multi-producer race/correlation behavior — 2000 HIGH;
- robust error-channel fan-out/arbitration — 2000 HIGH;
- remote reconnect/network timing faults — 2000 HIGH;
- hardware pendant latency/failure behavior — 2000 MEDIUM;
- safety-HMI integrity/certification — specialized higher-level work.

Those promotions do not weaken the 1000-level design rule because even opposite outcomes would not make presentation state equivalent to semantic, physical, or safety truth.

## Handoff verdict

**PASS at the artifact/reasoning level**, conditional only on T05 obtaining valid independent experiment evidence before graduation. The novel scenario is solvable from the durable T03-T05 materials without inventing missing subsystem behavior.
