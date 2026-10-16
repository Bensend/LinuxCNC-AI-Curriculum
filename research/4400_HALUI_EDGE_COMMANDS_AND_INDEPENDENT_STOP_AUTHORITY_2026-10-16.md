# 4400 — HALUI edge commands, retained inputs, and independent stop authority
Date: 2026-10-16. Status: source/documentation investigation; **no machine or lab validation**.

## Scope and evidence
Public LinuxCNC source only. Development revision `b99baf8e3904106a9feb719ab96076b6b296944e` and stable 2.9 revision `646fdb42`; both at `src/emc/usr_intf/halui.cc`. Official documentation: https://www.linuxcnc.org/docs/html/gui/halui.html and `docs/src/gui/halui.adoc` at those revisions. ISO 14118:2017 official scope: https://www.iso.org/standard/66460.html . No selected-machine configuration or private evidence used.

## Source-confirmed execution path
1. HALUI exports ordinary HAL input pins `halui.machine.on/off`, `halui.estop.activate/reset`, `halui.program.run/stop`. Development source around lines 661–678; stable around 761–800.
2. `hal_init_pins()` initializes the internal pin and prior-value state to zero (development ~1308–1320; stable ~1525–1535).
3. `check_bit_changed(halpin, oldpin)` returns the **new value** only when it differs from the previous value, and updates the previous value before the caller acts (development ~1374–1381; stable ~1591–1598). Therefore an input transition **0→1** invokes the associated command, while **1→0** only rearms the detector. Holding the input high does **not** continuously request the operation.
4. `check_hal_changes()` maps these rising edges to NML command sends (development ~1443–1454 and ~1483–1508; stable ~1652–1663 and ~1698–1723). `sendMachineOn()` sends `EMC_TASK_SET_STATE(ON)`; `sendEstopReset()` sends `EMC_TASK_SET_STATE(ESTOP_RESET)`; `sendProgramRun(0)` sends an ordinary task-plan run request if a file is open; `sendAbort()` sends `EMC_TASK_ABORT` (development ~766–795, ~934–949, ~1072–1077).
5. The userspace `main()` loop calls `check_hal_changes()`, `modify_hal_pins()`, sleeps `20ms`, then calls `updateStatus()` (development ~2157–2160; same structure at stable end of file). This is **not** a safety-rated realtime sampling contract.
6. The status output `halui.estop.is-activated` is set true exactly when the reported task state is `ESTOP` (development ~1906–1907). The current documentation's wording “indicates E-stop reset” is ambiguous against that source predicate; treat the source predicate as the implementation evidence for this pinned revision, not a physical E-stop contact witness.

## Consequences / claims ledger
| Claim | Evidence class | Consequence |
|---|---|---|
| `machine.off`, `estop.activate`, `estop.reset`, `program.stop` are rising-edge **commands**, not maintained safety contacts | SOURCE-CONFIRMED at both revisions | Do not use a held-high HALUI pin as proof of a maintained stop or independent inhibit. |
| The command-send return values are not checked at the `check_hal_changes()` call sites | SOURCE-CONFIRMED | A failed send can consume the rising edge without an automatic retry; command request is not acknowledgment. |
| A short input pulse can be missed between HALUI polling iterations | INFERENCE from userspace 20ms loop | No guaranteed minimum pulse width or exact worst-case latency established; do not infer one from the nominal sleep alone. |
| After a previously accepted `machine.off` edge, another ordinary control path may issue `machine.on` while the off input stays high | INFERENCE from edge-only semantics; not physically tested | A retained off input is not a safe-state interlock. |
| `halui.estop.is-activated` indicates task software state, not safety-contact/contactor/valve/standstill state | SOURCE-CONFIRMED for predicate; INFERENCE for physical nonclaim | Never use it as independent physical proof. |
| Exact effect of concurrent commands, network failure, restart and HAL wiring on a particular machine | UNKNOWN | Requires bounded application-specific inspection; do not assume a benign result. |

## Practical architecture and human factors
A user-friendly machine should expose separate indications for (a) operator command accepted, (b) normal LinuxCNC task state, (c) independent safety-system permission/fault state, and (d) verified physical safe-state propositions appropriate to the actual hazard. Ordinary HALUI can be used for production control and diagnostics. It must not be granted personnel-safety authority by labeling an input “E-stop.”

For maintenance, prevent unexpected startup using selected independent safety architecture and lockable isolation, energy dissipation/restraint, and verification appropriate to electrical, hydraulic, pneumatic, gravity and stored-energy hazards. ISO 14118:2017 covers unexpected start-up across these energy classes; it does **not** supply a machine-specific PL/SIL or safe-state design.

Prefer accessible dedicated stop devices and unambiguous rearm procedures. Do not force operators to rely on a fragile short pulse or a confusing indicator. If a nuisance-prone safeguard is being bypassed, correct the design/usability problem; do not substitute an ordinary software status bit.

## Adversarial source-only cases — NOT RUN
1. An HMI holds `halui.machine.off=1` while another input rises on `machine.on`. **Source prediction:** off is not resent just because its input remains high; outcome depends on Task and other authority paths. No claim of safe physical state.
2. A button generates a pulse shorter than one nominal HALUI iteration. **Source prediction:** sampling may miss it. Do not claim a specific minimum accepted width.
3. An NML send fails immediately after a rising edge. **Source prediction:** the old input state has already been updated; no resend occurs until a fresh falling/rising transition or another command path. No assumption that Task acted.
4. An indicator reads `halui.estop.is-activated=0` while a contactor is welded or a hydraulic ram is drifting. **Expected safety reasoning:** the indicator cannot establish physical safety; the independent safety function and machine-level witness prevail.
5. An operator resets ordinary E-stop and then reconnects a remote UI with a stale run command. **Expected safety reasoning:** reset/rearm and deliberate cycle start must remain separate, and independent safety logic must prevent hazardous restart where required; actual reconnect behavior remains untested.

## Handoff mapping and next work
- `SRS-*`: state the specific unexpected-start and protective-stop hazards and required safety functions.
- `AUTH-*`: allocate stop/rearm permission to the independent safety system, not HALUI/NML.
- `PHY-*`: specify stopping/holding/isolation propositions, not merely a software state.
- `DEP-*`: consider shared power, input wiring, communications, restart state, and plausible stale signals.
- `ARC-*`: distinguish ordinary command path from independent safety outputs/final elements.
- `VAL-*`: verify command/feedback separately from physical witness and rearm behavior.
- `CHG-*`: invalidate downstream evidence if wiring, mode behavior, stop element, or HMI authority changes.

No bench lab frozen: source resolves edge semantics. A later **non-hazardous offline** timing fixture may be justified only if a selected design requires a measurable input acceptance bound that source cannot establish. No GitHub-hosted compute. Self-hosted `[self-hosted, openpressbrake]` runner isolation is UNKNOWN, so do not dispatch.

**Release status:** SOURCE-CONFIRMED command path only. No functional-safety validation, no selected-machine approval, no invented stopping time, hydraulic truth table, PL/SIL or proof-test result.
