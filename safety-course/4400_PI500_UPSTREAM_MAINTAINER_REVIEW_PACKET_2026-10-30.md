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
