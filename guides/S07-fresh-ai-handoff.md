# S07 fresh-AI handoff — restart/recovery/state integrity

## Core model

A restart crosses several different state domains. Never collapse them into one claim of "the machine restarted cleanly."

1. **Process identity** — a new launcher/controller process can be proven by PID/lifecycle evidence.
2. **HAL namespace/lifetime** — a new process can attach to shared HAL state; process freshness alone is not HAL freshness.
3. **LinuxCNC homing state** — ordinary joint `homed` state is runtime state owned by the homing module and is established by the homing state machine.
4. **Persistent configuration** — the INI can remain byte-for-byte unchanged while runtime state is discarded and rebuilt.
5. **Measurement/physical truth** — neither a fresh process nor a fresh `homed` bit proves that the physical machine position, encoder provenance, actuator state, or safety state is trustworthy.

## Representative verified path

At pinned revision `8bf4605ae81042248add031e94c77300406e0413`, S07-017 used ordinary homing. Runtime A began unhomed, homed, shut down through the configured DISPLAY protocol, and passed an independent disappearance barrier. Runtime B had a distinct launcher identity, began unhomed under the unchanged INI, and had to home again to re-establish the bit. This is TEST-CONFIRMED for that fixture.

## Failure/debugging rule

A recovery claim needs independent oracles for the state that matters. A service port disappearing is not sufficient teardown evidence; a reporting command returning success is not necessarily object-existence evidence; a new PID is not position evidence. Prefer exact state/object queries plus lifecycle barriers whose failure semantics are understood from source.

## Novel scenario test

Scenario: a machine uses an absolute encoder whose drive retains position across host reboot. LinuxCNC restarts with a new PID and the drive immediately reports a plausible coordinate. May the control declare recovery complete solely because the PID is new and the coordinate is plausible?

**Expected reasoning:** No. The learner must separately establish runtime/HAL freshness, measurement freshness and provenance, the architecture's configured absolute-position revalidation semantics, agreement with physical/reference constraints where required, actuator/enable state, and any independent safety state. S07-017 proves ordinary-homing runtime state is not inherited; it does not authorize inventing absolute-encoder recovery semantics.

A fresh AI passes S07 when it reaches that conclusion without claiming that LinuxCNC software restart itself proves physical truth.

## Promotion queue / counterfactual audit

- Device/driver-specific absolute-encoder retained-position and freshness semantics — **2000 / HIGH**. Non-blocking because even if a selected device behaves differently than expected, the 1000-level teaching remains: recovery semantics are architecture-specific and require independent provenance.
- Abnormal process death and backend-specific dangling-HAL cleanup — **2000 / MEDIUM**. Non-blocking because orderly restart was independently verified and the generic teaching explicitly forbids inferring HAL freshness from PID freshness.

Counterfactual promotion test: if either promoted topic turns out differently, no central S07 claim above becomes false and no safety boundary becomes weaker. Therefore promotion is legitimate.

## 1000-level graduation audit

- Source mechanism: PASS — launcher cleanup, HAL lifecycle, homing ownership/init/finish path traced.
- Independent verification: PASS — S07-017 attempt 3, exit 0, unchanged frozen gates.
- Representative failure behavior: PASS — two defective teardown/existence oracles were identified and rejected as HARNESS_INVALID rather than misclassified as persistence behavior.
- Predeclared prediction checked: PASS — fresh ordinary-homing runtime B began FALSE and re-homed TRUE.
- Fresh-AI competency: PASS — novel absolute-encoder scenario above requires separating state/provenance domains.
- Critical uncertainty promoted: NONE.
- Promotion justification/counterfactual test: PASS.

**Decision: S07 GRADUATED at 1000 level.**
