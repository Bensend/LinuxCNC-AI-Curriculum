# S07 — restart/recovery/state-integrity adversarial exam

Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Use the S07 guides, pinned source, and accepted S07-017 evidence when available. Answers must distinguish SOURCE / DOC / TEST evidence and must not convert software lifecycle observations into physical-safety claims.

## Q1 — misleading premise: new PID means fresh machine truth

An engineer restarts LinuxCNC, records a different `linuxcnc` launcher PID, sees `joint.0.homed=TRUE`, and says: “The new process proved the control runtime is fresh, therefore the machine position is known.”

Identify at least three separate state/identity boundaries collapsed by this argument. State what additional evidence would be required before treating the `homed` observation as belonging to a genuinely fresh runtime, and what evidence would still be required before trusting physical position.

## Q2 — source call path

Trace ordinary simulated homing state from fresh motion/homing-module initialization through successful homing to the HAL-visible `joint.N.homed` value. Name the source owner of the per-joint state, the event/state transition that establishes `homed=1`, and one path that can clear it.

## Q3 — HAL lifetime failure path

A userspace HAL client exits and a second client starts with a new PID. Explain why the second PID is not sufficient evidence that the global HAL namespace was recreated. Reference the roles of `hal_lib_init()`, process-local RTAPI identity/mapping, shared HAL data initialization, and component/library reference lifetime.

## Q4 — teardown oracle trap

A lifecycle harness uses:

```sh
if halcmd show pin joint.0.homed >/dev/null 2>&1; then
    echo "pin still exists"
else
    echo "pin is gone"
fi
```

Explain why this is invalid at the pinned revision. Replace it with a narrower exact-object oracle and state one residual ambiguity that the replacement alone still cannot resolve.

## Q5 — version-sensitive reasoning

The pinned source used by S07 is a development revision whose `linuxcncrsh` implementation was substantially rewritten in 2026. A stable release is found where shutdown behavior or CLI status semantics differ. Which S07 conclusions can remain generic, which claims must remain revision-scoped, and what must be reverified before transplanting the laboratory harness to that stable release?

## Q6 — configuration persistence versus runtime state

Runtime A is homed and then shut down. Runtime B starts from a byte-for-byte identical INI file. Explain why an unchanged INI hash is useful evidence but cannot prove that runtime homing state should persist. Identify the owner/storage of the INI configuration and the owner/storage of `joint.N.homed` at the pinned revision.

## Q7 — `VOLATILE_HOME` adversarial premise

Someone claims: “`VOLATILE_HOME=0` means LinuxCNC persists homed state across process restarts.” Evaluate the claim from source and documentation. Explain what `VOLATILE_HOME` actually changes and what it does not establish.

## Q8 — absolute encoder scenario

A machine has an absolute encoder that retains position across host reboot. After LinuxCNC restarts, the encoder reports a plausible number. Is that sufficient to mark the machine position trustworthy? Give a 1000-level answer that identifies which part is architecture/device-specific, what LinuxCNC configuration/revalidation semantics must exist, and why sensor provenance/freshness remain separate from host-process restart.

## Q9 — failure classification

S07-017 runtime A homes successfully, the DISPLAY shutdown acknowledges, launcher PID and TCP port disappear, but the harness cannot prove whether the HAL homing pin is gone. Should the run be counted as evidence that homing persisted, evidence that homing reset, or HARNESS_INVALID? Defend the classification and state what would make the next run meaningfully stronger without weakening the frozen prediction.

## Q10 — bounded modification task

Modify the conceptual S07 teardown gate so it requires three independent observations before runtime B may start:

1. old launcher PID absent;
2. linuxcncrsh port unavailable;
3. exact `joint.0.homed` object absent.

Write shell-style pseudocode that is bounded in time and avoids treating a listing command's success as object existence. Include an explicit HARNESS_INVALID exit when the barrier cannot be established.

## Q11 — recovery semantics

Suppose a fresh runtime B correctly starts with `joint.0.homed=FALSE`, then re-homes to TRUE. What does that prove? List at least four things it does **not** prove about a physical machine or safety function.

## Q12 — novel transfer scenario

A service supervisor automatically restarts LinuxCNC after a controller process crash. The replacement process has a new PID, the same INI, and an external absolute-position gateway that republishes the last received device value with a new gateway sequence number on startup. Design the minimum evidence chain you would require before allowing coordinated motion. Your answer must explicitly address runtime freshness, HAL namespace freshness, measurement provenance/freshness, position-establishment semantics, actuator/safety state, and why a new gateway sequence number does not by itself prove a new physical measurement.

## Pass standard

A passing answer must preserve the central S07 distinction: **software restart/reinitialization, state re-establishment, physical truth, and functional safety are different evidence problems.** Any answer that treats a new PID, a successful shutdown command, a HAL bit, a persisted configuration file, or a republished sensor value as sufficient physical-recovery proof fails the exam.
