# C04 source guide — PID saturation transition semantics

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Evidence class: **SOURCE-CONFIRMED + TEST-CONFIRMED for the dynamic transition described below**.

## `calc_pid()` control flow relevant to saturation

For an enabled PID, pinned `src/hal/components/pid.c::calc_pid()` computes the unconstrained output and then reads `maxoutput`.

```text
computed output tmp1
  -> maxoutput = pid.maxoutput
  -> if maxoutput != 0:
       if tmp1 > +maxoutput: tmp1=+maxoutput; limit_state=+1
       else if tmp1 < -maxoutput: tmp1=-maxoutput; limit_state=-1
       else: limit_state=0
  -> if maxoutput == 0:
       skip this whole block
       (no limit_state assignment on this path)
  -> write pid.output = tmp1
  -> if limit_state != 0:
       saturated=true
       saturated-s += period
       saturated-count += 1
     else:
       saturated=false
       saturated-s=0
       saturated-count=0
```

If `enable=false`, the separate disabled branch forces output to zero and explicitly clears `limit_state=0`.

## Consequence of a dynamic `maxoutput -> 0` transition

Zero is the documented sentinel for 'no limit'. But if an enabled PID was already output-limited and has nonzero `limit_state`, changing only `maxoutput` directly to zero causes subsequent cycles to skip the block that would otherwise clear `limit_state`.

Therefore at the pinned revision:

```text
previous cycle clipped -> limit_state != 0
current maxoutput = 0, PID still enabled
=> current output is not clipped
BUT limit_state may retain the previous nonzero value
=> saturated may remain true
=> saturated-s/count may continue increasing
```

C04-026 reproduced precisely this state with same-cycle realtime records. After recovery, feedback A/B converged and PID-B `maxoutput=0`, but B `saturated=1` and `saturated-count` continued increasing.

The same source structure is still present in LinuxCNC `master` as inspected on 2026-09-08.

## Documentation comparison

Current LinuxCNC PID documentation says:

- all `max*` limits use zero to mean no limit;
- `pid.N.maxoutput=0` therefore means output is unlimited;
- `pid.N.saturated` is true when the **current** PID output is saturated, described as output being at `+/- maxoutput`;
- `saturated-s` / `saturated-count` represent how long output has continually been saturated.

Those statements do not describe the transition-history behavior above. Treat the source/runtime finding as revision-specific implementation truth when dynamically changing `maxoutput`.

## Safe engineering interpretation

Do not consume `pid.saturated` as an isolated causal or safety signal. At minimum, interpret it alongside:

- current `maxoutput`;
- current `enable`;
- transition history;
- actual `pid.output`;
- pinned LinuxCNC revision/source behavior.

A source-aware application that dynamically changes output limits should explicitly validate the transition semantics it relies on rather than assuming the telemetry is memoryless.

This still does not elevate software PID telemetry into physical or safety truth:

```text
pid.saturated
!= proof of actuator stall
!= proof of amplifier current limiting
!= proof of hydraulic pressure/flow limiting
!= proof of feedback sensor failure
!= safety-rated anti-racking or stop authority
```

## C04-027 recovery strategy

C04-027 uses a deliberately huge but finite phase-4 `maxoutput=1000.0` sentinel. That makes `calc_pid()` enter the nonzero-limit block; because the toy output is far inside that sentinel, the explicit `else` path assigns `limit_state=0`. The experiment also requires proof that the sentinel never binds. This is a source-semantic test device, not a recommended physical-machine output limit.
