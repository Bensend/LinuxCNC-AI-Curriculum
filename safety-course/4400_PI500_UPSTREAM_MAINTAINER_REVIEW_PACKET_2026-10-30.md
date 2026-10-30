# PI500 LinuxCNC driver — upstream maintainer review packet (not a patch or machine release)
**2026-10-30 | HIGH-PRIORITY source discrepancy | ordinary-control behavior only | no runtime verification**

## Precise reportable behavior
Pinned [`pi500_vfd.comp`](https://github.com/LinuxCNC/linuxcnc/blob/e1c6a557c0e1c61961f17ee35a1ba188e7db275f/src/hal/user_comps/pi500_vfd/pi500_vfd.comp) blob `92cc57bdf5214bbb3fb92103837539e42a76d452` declares `enable=0` will remote-trip the VFD. In `user_mainloop`, the no-alarm/`!enable` branch logs `failed to trip` and `continue`s without a Modbus trip or STOP write. The commented `pi500_trip()` would write a bit at `0x002`, not a command validated by the inspected OEM table. When alarm is true and enable false, the source can still reach `pi500_run(ctx,true)` if `run=true` and the *last polled* running flag is false. When alarm and enable are true, the code attempts a fault reset automatically.

## Cross-layer manufacturer detail
The manufacturer-authored [March 2018 PI500 manual, Appendix I, mirrored page 94](https://www.manualslib.com/manual/1658524/Powtran-Pi500-Series.html?page=94) lists command word `0x2000`: `1` RUN, `5` free stop, `6` deceleration stop, `7` reset. [F9.04, mirrored page 96](https://www.manualslib.com/manual/1658524/Powtran-Pi500-Series.html?page=96) defaults communication timeout to `0.0 s` (disabled); [F8.18, mirrored page 52](https://www.manualslib.com/manual/1658524/Powtran-Pi500-Series.html?page=52) permits an Err.16 communication-fault action that **continues running**. In the disabled/no-alarm source path, Modbus status polling continues despite a frozen **HAL** heartbeat. A communication-gap watchdog is not equivalent to a HAL watchdog. These are 2018 manual statements, not verified for an installed clone/firmware or the inaccessible 2025 V5.1 PDF.

## Maintainer questions before changing code
1. What is the intended *ordinary* `enable` contract: request remote trip, inhibit RUN, or release remote command priority? Should it be documented as a non-safety control?
2. Which exact PI500/compatible models and firmware support a remote-trip command? Is the commented `modbus_write_bit(ctx,0x002,TRUE)` legitimate for any of them? If not, what normal-stop semantics are intended?
3. Should a held `enable=1` repeatedly reset faults? Should reset be a distinct edge/event and require fresh RUN authorization after a fault?
4. Should `enable=0` categorically suppress RUN writes in **all** alarm/status combinations? Should ordinary STOP be attempted when healthy communication exists, with an explicit error on failure?
5. How should stale status outputs, serial loss/recovery and HAL heartbeat freshness be represented? Does the UI make a false safe-to-enter claim from drive-reported `is_ready` or `is_at_speed`?
6. Are the documented F9.04 and F8.18 semantics confirmed on the exact supported drive models? Should the driver manual explicitly warn about disabled timeout and configurable fault response?

## Proposed source-level acceptance matrix (not executed)
| Polled alarm | enable | run | Desired review invariant, subject to maintainer contract |
|---|---|---|---|
| 0 | 0 | 0 or 1 | No RUN write; ordinary disable/STOP behavior explicitly specified; report failures |
| 0 | 1 | 0 | Ordinary STOP request, no restart |
| 0 | 1 | 1 | Ordinary RUN only with a current authorized request and valid state |
| 1 | 0 | 0 or 1 | No RUN write; no automatic reset |
| 1 | 1 | 0 or 1 | Reset semantics explicit; a held enable is not silently treated as a fresh reset/restart |
| read failure | either | either | No claim of fresh feedback; communication failure visible; do not infer physical stop |
| serial reconnect | either | held 1 | No surprise normal RUN without defined fresh-start policy |

This is a **review proposal**, not a claim that the existing LinuxCNC contract guarantees these invariants or that a code-only fix supplies personnel safety. An upstream maintainer must reconcile intended backward compatibility and actual supported hardware before implementation. The only authoritative runtime evidence would be from a frozen, isolated test on the appropriate model; no hosted compute and no people-exposed motor operation.

## Why this matters for the safety curriculum
**Normal control:** LinuxCNC/HAL/Modbus may request process STOP, display diagnostics, and detect stale communications. **Safety-related control:** independent protective devices and safety logic must own personnel-protective decisions. **Physical final elements:** verified torque removal, braking, holding and isolation depend on the selected machine. A Modbus STOP or a frozen HAL heartbeat is not a validated safety function, standstill witness, or lockout. Make the correct guard/STOP/restart workflow easier than bypassing it.

**Evidence:** SOURCE-CONFIRMED pinned code and VFS11 precedent (the latter uses its own drive-specific `enabled=false` semantics; not a generic enable contract); DOC-CONFIRMED mirrored OEM passages; INFERENCE cross-layer timing/stop implications; TEST-CONFIRMED none. No upstream issue or PR submitted. No selected OpenPressBrake PI500 drive known; G0/G1 HOLD, independent evaluator OPEN.

**Companion audits:** [PI500-VFD-01](../research/4400_PI500_VFD_01_LINUXCNC_PIN_REMOTE_TRIP_CLAIM_VS_COMMENTED_OUT_SOURCE_PATH_AUDIT_2026-10-30.md) and [PI500-OEM-COMM-02](../research/4400_PI500_OEM_COMM_TIMEOUT_02_SOURCE_OEM_CROSS_LAYER_WATCHDOG_AUDIT_2026-10-30.md).


## Same-revision cross-driver contract contrast (SOURCE-CONFIRMED; not a PI500 fix)
At the same pinned LinuxCNC commit, [`vfs11_vfd.c`](https://github.com/LinuxCNC/linuxcnc/blob/e1c6a557c0e1c61961f17ee35a1ba188e7db275f/src/hal/user_comps/vfs11_vfd/vfs11_vfd.c) blob `8626218e28bd7302a59397eb8eb7870dadaa8215`, `write_data()`, explicitly sends `REG_COMMAND1=0` when its `enabled` HAL input is false and comments that this means **no bus control**. That is a different *drive-specific authority relinquishment* contract, not proof that Toshiba VFS11 or Powtran PI500 physically stops when the HAL enable goes low. It reinforces the review requirement: specify `enable` behavior for the **exact driver and OEM** instead of treating HAL pin names as universal safety semantics.


## 2026-10-30 upstream tracker/source freshness recheck (source-only; not maintainer acceptance)
A fresh direct read of LinuxCNC default-branch `src/hal/user_comps/pi500_vfd/pi500_vfd.comp` returned **Git blob `92cc57bdf5214bbb3fb92103837539e42a76d452`**, matching the previous source audit. The documented `enable=0` remote-trip text (line 5), commented-out `pi500_trip` (around line 78), disabled/no-alarm `failed to trip` branch (lines 296–299), and ordinary RUN branch (around line 317) remain present. **SOURCE-CONFIRMED at this observed default-branch blob**, not runtime proof.

A **bounded GitHub issue/PR search** in `LinuxCNC/linuxcnc` for `pi500_vfd`, `failed to trip`, `pi500 enable`, and PI500 PRs found the original [PR #1172 (merged 2021-08-20)](https://github.com/LinuxCNC/linuxcnc/pull/1172), whose author reported normal PI500 7R5G3 control, but no matching reported remote-trip/disable-failure issue in these query results. The other PI500 text hit, [issue #2572](https://github.com/LinuxCNC/linuxcnc/issues/2572), concerns a Fedora build/missing `linuxcnc` command, **not** a remote-trip test. Search results are not an exhaustive proof that no related report exists; the original author's ordinary-control observation does **not** validate disabled behavior or personnel safety.

**Disposition:** upstream maintainer review remains **OPEN / NOT SUBMITTED**. The existing acceptance matrix remains a proposal; any change must preserve drive-specific compatibility and never treat Modbus STOP/enable as a personnel-protective function. No code patch, issue submission, workflow, simulator, physical test or independent evaluation performed.

## 2026-10-30 cross-instance scheduler addendum — a faulted PI500 can delay healthy peers

The [new PI500-MULTI-03 pinned-source/halcompile generator audit](../research/4400_PI500_MULTI_03_HALCOMPILE_SINGLE_THREAD_RESET_SLEEP_PEER_STARVATION_SOURCE_AUDIT_2026-10-30.md) adds a **distinct** upstream review question: the nonsingleton userspace component runs one `FOR_ALL_INSTS` traversal and one global Modbus context. A missing `mbslaveaddr` invokes `sleep(1)` every pass; an alarmed `enable=1` instance calls `pi500_reset`, which unconditionally sleeps one second after attempting the reset (including write failure). Other configured instances in the **same driver process** cannot be polled/commanded during these sleeps. Stable `v2.9.10` and inspected development source both contain the pattern. This is **SOURCE-CONFIRMED code ordering**, not measured latency or evidence that any selected drive moved.

**New maintainer review requests:** specify whether OEM reset requires per-drive or whole-bus quiet; replace avoidable blocking work with a documented fairness/freshness policy; require explicit ordinary reset event and fresh status before any RUN; define per-slave stale telemetry and restart behavior. The previously proposed no-RUN-when-disabled matrix remains open. Do not represent Modbus, watchdogs, or a scheduling fix as independent personnel safety. No patch, issue, simulator or hardware test was submitted/executed.

**Additional same-session PI500 status-coherence review:** [PI500-MULTI-03](../research/4400_PI500_MULTI_03_HALCOMPILE_SINGLE_THREAD_RESET_SLEEP_PEER_STARVATION_SOURCE_AUDIT_2026-10-30.md) also confirms that the `!alarm && !enable` branch refreshes `is_running/is_ready/is_alarm` but retains previous `is_at_speed/current/temperature` and freezes the heartbeat; failed status reads retain all outputs. The `is_at_speed` assignment compares positive requested frequency with reported frequency **without checking `status.running`**, so a hypothetical not-running/matching-frequency reply would assert at-speed. Actual OEM reply combination UNKNOWN. Ask maintainers for coherent sample age/validity and precise at-speed semantics, without treating any pin as a physical standstill or safety witness.


## 2026-10-30 PI500-FREQ-04 input-validation and stale-setpoint RUN addendum (source-only)
[New pinned source audit](../research/4400_PI500_FREQ_04_ZERO_NEGATIVE_NONFINITE_COMMAND_AND_RETAINED_RUN_SOURCE_AUDIT_2026-10-30.md) adds a **different** ordinary-command failure path: with `enable=true`, healthy status, `run=true` and a drive not already running, the driver can write RUN `0x2000=1` when `commanded_frequency=0` or negative because the frequency-write condition requires `commanded_frequency>0` but the RUN predicate does not. A previously configured drive frequency may be retained; actual physical behavior depends on selected OEM configuration and is UNKNOWN. The `fabs()*10*(10 or 1)` floating-to-`uint16_t` cast lacks finite/range validation; do not assume defined wrap or safe handling for NaN/Infinity/out-of-range values. The status poll reads `0xF001` into an unused `speed_setting`, while the code compares against `status_params[1]`, not a proven accepted new setpoint. Stable v2.9.10 retains the same conversion/RUN structure. **SOURCE-CONFIRMED** code, not TEST-CONFIRMED drive motion.

**New upstream acceptance questions:** Should `run=true` with zero/negative/nonfinite/sub-resolution/overflowing frequency be rejected, interpreted as an explicit stop, or allowed under a documented model-specific zero-speed mode? What exact selected-model limits and F0.02 scaling apply? Should a RUN command require a valid accepted frequency and a fresh normal start after reconnect/reset? What telemetry proves write acceptance versus running frequency? Freeze pure-software mock cases only after a maintainer-defined contract; never infer personnel-safety authority from this driver. No upstream submission, patch, workflow or compute.


## 2026-10-30 OEM frequency-source / EEPROM cross-layer addendum (PI500-OEM-FREQ-05)

[Direct pinned LinuxCNC + March 2018 Powtran Appendix I audit](../research/4400_PI500_OEM_FREQ_SOURCE_05_F001_EEPROM_RUNNING_FREQ_COMPARE_AUDIT_2026-10-30.md) identifies **another source/OEM discrepancy**: the driver writes `0xF001` (OEM `F0.01` *keyboard* frequency parameter), while OEM `F0.03=9` remote-communications frequency is the **different** `0x1000` percent-of-`F0.19` reference. The driver never checks `F0.03/F0.11/F0.12`, reads `0xF001` into an unused variable, and compares requested frequency with `0x1001` **running frequency**, not accepted setpoint. Thus even `run=false`, stopped with a positive requested frequency can repeatedly attempt `0xF001` writes; the OEM expressly warns frequent EEPROM storage reduces endurance and documents RAM-only `0x0001`. **SOURCE-CONFIRMED** attempted writes; **DOC-CONFIRMED** 2018 OEM register semantics; **INFERENCE** actual EEPROM wear or selected-machine effect; **TEST-CONFIRMED none**. Confirm exact firmware, source/binding parameters, persistence semantics and mode-specific units before patching. A blind replacement with `0x1000` is wrong because its unit is percent, not Hz. Upstream review remains OPEN/NOT SUBMITTED; no safety function or machine release.
