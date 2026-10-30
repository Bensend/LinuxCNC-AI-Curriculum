# 4400-PI500-VFD-01 — LinuxCNC's PI500 `enable=0` remote-trip promise is absent from its inspected source path
**2026-10-30 | pinned LinuxCNC source | high-consequence documentation/implementation discrepancy | NON-GRADUATED | NO MACHINE TEST**

## Why this matters and why it is not duplicate work
A LinuxCNC retrofit integrator may see the published `pi500_vfd.N.enable` description: **0 will remote-trip the VFD**. Could they rely on it to stop a spindle? Direct inspection of the current source shows the apparent trip function is **commented out**; when `enable=0` and the last polled status is not alarm, the loop **logs an error and continues without sending a trip or RUN=0 command**. This is a concrete **SOURCE-CONFIRMED implementation/documentation mismatch**. It is not an assertion that any installed drive necessarily keeps turning, or that the code has been executed in this session.

**Predecessor novelty check:** [VFD-EXIT-01](4400_VFD_EXIT_01_LINUXCNC_2910_SHUTDOWN_HAL_MODBUS_LAST_COMMAND_VS_INDEPENDENT_STOP_SOURCE_AUDIT_2026-10-29.md) already covers LinuxCNC exit and client timeout versus independent safety. [RST-01](../safety-course/4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md) already covers fresh start. [VFD-RESTART-01](4400_VFD_RESTART_01_SCHNEIDER_ATV12_2018_RETRY_MASKED_R1_HELD_RUN_FLYING_RESTART_OEM_AUDIT_2026-10-30.md) covers a **different OEM VFD** auto-retry configuration. The novel increment here is **the exact LinuxCNC PI500 driver code path not honoring its documented `enable=0` remote-trip behavior**, plus its ordinary automatic alarm reset.

## Pinned original source and exact call path
**SOURCE-CONFIRMED:** [LinuxCNC/linuxcnc `src/hal/user_comps/pi500_vfd/pi500_vfd.comp` at commit `e1c6a557c0e1c61961f17ee35a1ba188e7db275f`](https://github.com/LinuxCNC/linuxcnc/blob/e1c6a557c0e1c61961f17ee35a1ba188e7db275f/src/hal/user_comps/pi500_vfd/pi500_vfd.comp), file blob **`92cc57bdf5214bbb3fb92103837539e42a76d452`**. Fetched again from the repository's current default branch on 2026-10-30; the blob SHA matched. This pin is an **audit snapshot**, not a claim the file was newly published on the audit date.

| Source lines | Directly inspected implementation | Safety/diagnostic significance |
|---|---|---|
| 1–13 | `pin in bool enable` describes `0` as remote trip; `run` is a separate input; `watchdog_out` toggles per update | The documented name/claim is not a safety rating or proof of transmitted command |
| 66–86 | `pi500_reset()` writes Modbus holding register `0x2000=7`; **`pi500_trip()` is entirely commented out** at lines 78–81; `pi500_run(runBit)` writes `0x2000=1` for RUN and `0x2000=6` for STOP | No callable trip function is present in this inspected source |
| 90–131 | `pi500_getStatus()` polls registers `0x3000`, `0x8000` etc.; maps running/ready/alarm from responses | These are **drive-reported ordinary data**, not independent shaft or torque-off proof |
| 278–294 | main loop polls status, then updates `is_running,is_ready,is_alarm`; on read failure it logs and continues | Feedback freshness is not inherently established by a retained HAL value |
| **296–299** | `if (!status.alarm && !enable) { // && !pi500_trip(ctx)` then logs `failed to trip` and **continues** | **No Modbus trip or STOP write is attempted on this branch.** The error text alone is not proof a trip was commanded or rejected |
| 300–303 | `else if (status.alarm && enable && !pi500_reset(ctx))` | When `enable=1` and an alarm is reported, **the code attempts an ordinary fault reset**. It is not an independent safety reset; no operator edge is required in this code branch |
| 305–324 | conditional frequency write, `if(status.running ^ run) pi500_run(ctx,run)`, then `watchdog_out_set(!watchdog_out)` | The ordinary RUN command is sent on reported-state mismatch; heartbeat toggles **only after** the loop reaches this tail, not during the `enable=0` no-alarm branch |

**DOC-CONFIRMED (published LinuxCNC driver manpage):** [`pi500_vfd(1)`](https://linuxcnc.org/docs/stable/html/man/es/man1/pi500_vfd.1.html) describes `enable=0` as remote trip and `watchdog-out` as a communication-cycle heartbeat. The page is derived from the component's declarations; **it is not independent test evidence** of the implementation. The original source is authoritative for the observed missing call.

### A source-level counterexample, without pretending it was run
Given **ordinary polled status** `status.alarm=false`, **HAL input** `enable=false`, and any `run` value, the inspected code enters lines 296–299 and immediately `continue`s. It never reaches `pi500_run(...,false)` at line 317 or any other Modbus trip write in that iteration. The only printed action is `failed to trip`; this is a **static control-flow deduction**, not a TEST-CONFIRMED trace. If the VFD was already running, the selected VFD's response in the absence of a new command depends on its exact drive configuration and communication-loss behavior: **UNKNOWN**. Do not assume the spindle stops or continues from this code alone.

**Additional source-level nuance:** `watchdog_out` ceases toggling on this branch, but a separate consumer must actually detect the missing toggles and command a suitable independent safety path; no such integration is proven here. The code's `is_at_speed` uses a polled frequency comparison and does not constitute independent spindle standstill sensing.

## Design and human-factors consequences
- **Do not wire a personnel safety claim to this HAL `enable` input, `is_alarm`, `is_running`, `is_at_speed` or `watchdog_out`.** The userspace Modbus driver and its pins are ordinary control/diagnostics. Even a corrected remote-trip implementation would not become a certified protective stop or energy isolation.
- For a **normal process stop**, separately inspect actual `run` and communication behavior, selected VFD's response to link loss, drive faults, and command recovery. A logged "failed to trip" can coexist with no command being sent; label diagnostic freshness/communication explicitly.
- For **personnel exposure**, require independent protective-device/safety logic, suitable physical final element, kinetic-energy/standstill consideration, and separate deliberate restart. Do not substitute a software `enable=0` request for a verified guard interlock or safe-to-service isolation.
- A usability improvement is to distinguish **RUN requested**, **drive reported running**, **driver heartbeat stale**, **protective stop asserted**, and **isolated**. Make normal safe stopping and guard use easier than unplugging a cable or defeating a guard.

## Adversarial review / falsification boundary
1. **SOURCE-CONFIRMED:** `pi500_trip` is commented out; no call occurs when `enable=0` and no alarm. A new source revision could change this. The pinned file is an audit snapshot.
2. **DOC-CONFIRMED:** the published pin description promises remote trip. The promise conflicts with the observed source path, but no upstream maintainer explanation or issue/patch has been reviewed.
3. **INFERENCE:** an operator relying on the documented `enable=0` as a safety stop could be exposed if a selected VFD retains motion. That exposure is a conditional architecture hazard, **not** an observed accident.
4. **UNKNOWN:** selected Powtran model/firmware, VFD Modbus register semantics, output state after command loss, runtime packaging/version, actual spindle behavior, physical stop and safety circuit.
5. **TEST-CONFIRMED:** **none**. No hardware, build, simulation, test, benchmark, workflow or local runner use.

**No lab is needed to establish the source branch's missing Modbus trip call.** A future selected-drive behavioral question would require exact OEM manual, qualified isolated/remote fixture, frozen acceptance criteria and physical exclusion. It cannot authorize personnel-exposed operation.

## Follow-up and safety gate
Treat as **high-priority source/doc discrepancy for upstream maintainer review**; this curriculum session did **not** create an upstream issue, alter the LinuxCNC driver or test it. Any correction should be separately reviewed, tested on isolated equipment, and documented without implying safety certification.

OpenPressBrake Stage A A–G qualified public status unestablished; restricted evidence receipt UNKNOWN. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No selected PI500 drive is known on OpenPressBrake. Independent 2520–25F0 evaluation remains OPEN/NOT RUN; no laboratory compute.


## Build/documentation provenance and upstream issue-search addendum (same session)
**SOURCE-CONFIRMED:** [LinuxCNC `src/hal/user_comps/pi500_vfd/Submakefile` at pinned commit](https://github.com/LinuxCNC/linuxcnc/blob/e1c6a557c0e1c61961f17ee35a1ba188e7db275f/src/hal/user_comps/pi500_vfd/Submakefile), current blob `231c34aa0859a732816a1680114586c91a3cf0ab`, conditions the component on `HAVE_LIBMODBUS3`, generates `pi500_vfd.c` from `pi500_vfd.comp` with `halcompile -U --preprocess`, and generates the published manpage from the **same .comp** with `halcompile -U -u --document`. The generated `.c` is not tracked in the inspected repository. Thus the manpage is **not independent corroboration** of runtime behavior; the source/doc conflict is internal to one component definition. This does not prove a particular distributed binary contains the branch. Searches of visible upstream issues for `pi500_vfd enable trip` and `pi500_vfd failed to trip` returned no matches; **absence from search is not proof no report exists**. No issue was filed or upstream code changed.
