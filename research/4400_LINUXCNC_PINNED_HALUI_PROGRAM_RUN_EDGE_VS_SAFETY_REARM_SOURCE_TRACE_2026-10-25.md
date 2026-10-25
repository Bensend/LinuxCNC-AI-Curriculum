# 4400-PEDAL-02 — LinuxCNC halui.program.run is rising-edge dispatched, not a safety-rearm authority
**2026-10-25 | original source trace, two pinned upstream revisions | no simulation | NON-GRADUATED**

## Concrete question
The OEM Schmersal UEDR foot-pedal manual warns of a switch-on impulse during mechanical unlock. Does LinuxCNC `halui.program.run` treat an input as a level that continuously restarts motion, or as a rising edge? Does this ordinary source behavior eliminate the independent safety requirement to reject an unlock pulse, retained request, or unsafe rearm?

## Direct source files and pinned versions
Upstream **LinuxCNC/linuxcnc**, `src/emc/usr_intf/halui.cc` inspected through the GitHub repository at:
- **2.9 pinned commit `a33293f`**, file blob `6aa51870512c9d29919452aaec0377338e350a04`: https://github.com/LinuxCNC/linuxcnc/blob/a33293f/src/emc/usr_intf/halui.cc
- **development pinned commit `062dc7c`**, file blob `c40e2831e737b3ff8bc4a8b9e750092b5a951379`: https://github.com/LinuxCNC/linuxcnc/blob/062dc7c/src/emc/usr_intf/halui.cc

**SOURCE-CONFIRMED 2.9:** `halui.program.run` is exported as HAL input at **line 791**. `check_bit_changed(bool halpin, bool &newpin)` at **line 1591** updates previous state only if changed and returns the **new Boolean level**; it therefore returns 1 only for a **0 -> 1 rising edge**, not a 1 -> 0 release or an unchanged high. At **line 1698**:
```cpp
if (check_bit_changed(new_halui_data.program_run, old_halui_data.program_run) != 0)
    sendProgramRun(0);
```
`sendProgramRun(int line)` at **line 1128** checks that a program file is open, records start line, calls `sendAuto()`, then dispatches an `EMC_TASK_PLAN_RUN` NML message. It does **not** read a safety PLC, verify pedal latch state, validate ram gravity holding or provide a machine personnel-safety function.

**SOURCE-CONFIRMED development:** same rising-edge helper at **line 1374**, `halui.program.run` export at **line 674**, run dispatch at **line 1483**, `sendProgramRun` at **line 934**. Behavior matches the 2.9 pinned source in these inspected paths. No assertion about uninspected older versions or alternate UIs.

**SOURCE-CONFIRMED 2.9:** `check_hal_changes()` copies HAL pin values and compares against saved prior state; main loop calls it before `modify_hal_pins()` and sleeps nominal 0.02 s. **Do not treat the nominal sleep as a guaranteed sampling period, impulse-width filter, stop time or diagnostic coverage.** A short pulse might be missed, but it could also be sampled; the actual pedal/contact/safety interface timing remains UNKNOWN.

**DOC-CONFIRMED official LinuxCNC 2.9 HALUI manual:** `halui.program.run` is a pin for running a program, while other pins explicitly say rising edge. Official remote-start example uses ordinary `halui.mode.auto`, `halui.mode.is-auto` and an `and2` gate to send `halui.program.run`. These are ordinary program-control examples, **not a personnel-safety architecture**.
- https://www.linuxcnc.org/docs/2.9/html/man/man1/halui.1.html
- https://linuxcnc.org/docs/2.9/html-10316140553/hal/halui-examples.html

## Engineering correction and failure-path boundary
A **held-high** `halui.program.run` that remains high while the **same HALUI process** continues does **not**, from this inspected source alone, repeatedly emit `EMC_TASK_PLAN_RUN`: no new rising edge occurs. It would be **wrong** to claim that a held high necessarily restarts a program each time E-stop is reset. Conversely, a **new 0 -> 1 impulse** during mechanical unlock *can* trigger an ordinary run request if wired to this pin and sampled. Whether Task accepts that request depends on current mode, file, task state and other checks not fully traced here. The downstream machine's physical behavior is **UNKNOWN**.

Further potential scenarios are **INFERENCE, not source-confirmed selected failures**: a downstream motion request retained in a separate custom controller, a new transition produced by reconnect/restart, a mode change that re-gates a held pedal through an `and2`, or another UI that implements level-based logic. These need exact selected configuration and safety controller evidence; do not infer them from HALUI alone.

**Required safety boundary:** An OEM pedal unlock transient, a new ordinary run edge, or a retained normal request must not authorize hazardous motion unless the **independent safety-related control**, guards, mode, fresh deliberate start, physical final elements and actual stop/hold conditions have been qualified. The independent safety architecture must not rely on HALUI edge detection as its personnel-safety reset interlock.

## Adversarial paper checks (no compute)
1. HALUI input 0 -> 1 while file open: source issues ordinary NML run request; **Task acceptance and physical motion UNKNOWN**.
2. HALUI input stays 1 across ordinary machine state change: **no additional HALUI run dispatch from unchanged pin** in inspected path; downstream retained motion still UNKNOWN.
3. Input 1 -> 0: helper updates state and returns 0, so no run command.
4. Input 0 -> 1 after unlock transient: run dispatch path exists; actual pulse detection, Task acceptance, safety final elements and ram behavior UNKNOWN.
5. HALUI process restart, custom HAL `and2`, GUI or safety-controller reset: **out of scope** until selected configuration; cannot assert universal behavior.

No build, simulation, Actions dispatch, physical test or independent evaluation. **SOURCE-CONFIRMED** pinned code paths, **DOC-CONFIRMED** official user documentation, **INFERENCE** risk scenarios, **TEST-CONFIRMED none**, **UNKNOWN** selected OpenPressBrake control/physical outcomes. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED.

## Next
If selected OpenPressBrake uses HALUI remote run or custom pedal HAL, obtain its exact `.hal`/`.ini` wiring, controller/relay reset semantics and physical witnesses in restricted G0 packet C/F. Do not use a generic HALUI bench test as a proxy for personnel-safety validation. No new lab is justified merely to reconfirm the obvious rising-edge helper.
