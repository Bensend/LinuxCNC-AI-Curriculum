# OT-SEC-01 source trace — HALUI command pins → NML Task echo ≠ physical safety

**Pinned LinuxCNC revision:** `LinuxCNC/linuxcnc` commit `c9a5a0a5034177c8db64cb44abf14d4f2eb166f7`. **Inspected source:** `src/emc/usr_intf/halui.cc`, Git blob `c40e2831e737b3ff8bc4a8b9e750092b5a951379`; direct connector fetch of the exact commit. Source permalink: https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/usr_intf/halui.cc . No runtime executed. This is **SOURCE-CONFIRMED at the pinned commit only**.

## Concrete end-to-end ordinary command paths

| Input/entry | Source lines and call chain | Meaning / limit |
|---|---|---|
| `halui.machine.on` HAL input | `halui.cc:661` exported → `:1443–1445` rising edge via `check_bit_changed` → `sendMachineOn` `:766–771` builds `EMC_TASK_SET_STATE{ON}` → `emcCommandSend` | Ordinary Task request, **not** independent physical motion authorization |
| `halui.estop.reset` HAL input | `:664` exported → `:1453–1454` rising edge → `sendEstopReset` `:790–796` builds `EMC_TASK_SET_STATE{ESTOP_RESET}` → `emcCommandSend` | Software E-stop reset request, **not** evidence that the external safety system was physically reset |
| `halui.mdi-command-NN` HAL input | `:758–760` pin exported → `:1893–1896` rising edge → `sendMdiCommand` `:834–877`; if needed, request MDI mode `:856–870`, then `EMC_TASK_PLAN_EXECUTE` `:871–872` | Task can still reject or conditionally process the command; source does **not** prove any particular machine will move |
| Command submission | `emcCommandSend` `:431–455` writes `emcCommandBuffer`, waits for `emcStatus->echo_serial_number` to reach command serial, returns 0 on echo | **An echo is not physical Y1/Y2 stop, gravity hold, guard clear, energy isolation, or command completion.** |

`check_bit_changed` `:1374–1381` updates the remembered pin and returns its new boolean value on a change; therefore the above callers react to a **rising edge** (false→true), not a continuous asserted level. The software pin can be driven by any HAL-connected source that the particular configuration allows. This source trace does **not** establish a remote connection, privilege bypass, or safety-controller exposure on any actual machine.

## Security-to-safety interpretation

**SOURCE-CONFIRMED:** LinuxCNC provides ordinary HAL-visible command ingress into NML Task; Task acknowledgment is an ordinary software exchange. **INFERENCE:** if a remotely writable or compromised upstream interface can reach these HAL inputs, it can *request* ordinary commands. That conditional pathway requires a configuration/privilege/network review, not an assumed exploit. **UNKNOWN:** actual task acceptance, machine movement, final elements, safety circuit, guard coverage, physical safe state and any OpenPressBrake remote support.

A VPN login, `halui.estop.reset` pulse, successful NML echo, green GUI status or absence of network traffic cannot substitute for **independent safety-related control and physical proof**. The safe pattern is to preserve an independently qualified safety controller and physical final elements; keep remote support restricted and visibly controlled; require qualified local verification and deliberate restart.

## Version and evidence limits

No stable 2.9 comparison was performed, no live LinuxCNC or machine test run, no safety PL/SIL or response time calculated. A fresh reader must recheck these line ranges against their deployed revision. Official user-facing interface reference: https://www.linuxcnc.org/docs/html/gui/halui.html . Relevant NIST OT security analysis: [OT-SEC-01 primary audit](4400_OT_SEC_01_NIST_800_82R3_IEC_TS_63074_REMOTE_HMI_SAFETY_AUTHORITY_AUDIT_2026-10-26.md). Existing [first-scan estop latch lesson](../safety-course/4400_ESTOP_LATCH_FIRST_SCAN_ADVERSARIAL_CARD_2026-10-22.md) remains separate; no novelty claim for that mechanism.

**No lab justified**: source establishes the ordinary command path; a simulated remote pin cannot validate the independent physical safety chain. External evaluator NOT RUN; G0/G1 HOLD.
