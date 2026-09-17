# Trapped-Person / Restart-Prevention Design Card — 2026-09-17

Use this card when a person can pass through a perimeter safeguard and then become invisible to that safeguard.

## 1. Geometry gate

- Can a person fully cross the protective field or guard boundary?
- Once across, can the boundary return to its normal/clear state while the person remains inside?
- Are there rear, side, under-machine, elevated, tooling, pit, or maintenance spaces not visible from the reset station?
- Can another person close the guard or clear the field while someone remains inside?

If **yes** to any of these, `boundary clear` is not sufficient proof of `zone clear`.

## 2. Restart-prevention mechanism

Document the credited mechanism. Examples may include risk-assessed combinations of:

- reset/restart interlock with full-zone visibility;
- presence sensing that continues to observe the occupied zone;
- trapped-key / key-in-pocket personnel retention;
- zone-specific entry accounting;
- blind-spot inspection/check sequence where the validated architecture permits it;
- physical lockout/tagout and hazardous-energy control for maintenance rather than production restart logic.

Do not combine these labels as if they were interchangeable. Each has a different physical claim and failure set.

## 3. Proof boundary

For every mechanism record:

`what detects entry?`

`what prevents restart while occupied?`

`what detects/records exit?`

`what happens on power loss?`

`what happens on communications loss?`

`what happens if the reset input sticks?`

`what happens if ordinary LinuxCNC/HAL/FPGA state is stale?`

`what physical final element remains inhibited?`

`what fresh action is required before motion?`

## 4. Key-in-pocket transfer lesson

Manufacturer application guidance from Pilz describes an access-management pattern where authorized personnel sign into the protected plant, retain their personal transponder while inside, and must sign out after leaving before productive enable can return. For large plants without overall visibility, Pilz additionally describes a blind-spot check before restart.

**DOC-CONFIRMED:** this is evidence that personnel-retention state can be part of restart prevention.

**NOT ESTABLISHED FOR OPENPRESSBRAKE:** no claim is made that this specific product/architecture, PL/SIL result, number of keys, or reset sequence is appropriate for the installed press brake without its risk assessment and complete implementation evidence.

## 5. Separation from ordinary control

Keep these states distinct:

`PERSONNEL / ZONE CLEARANCE AUTHORITY`

`SAFETY RESET ACCEPTED`

`SAFETY FINAL-ELEMENT AUTHORITY`

`LINUXCNC MACHINE-ON / ENABLE`

`FPGA OUTPUT FRESHNESS`

`NEW START INTENT`

`PHYSICAL MOTION`

LinuxCNC and the normal FPGA may consume and display bounded status, but must not become the sole personnel-safety authority merely because they already know machine state.

## 6. Human-factors adversarial review

Reject or redesign an implementation if normal work predictably encourages any of these:

- wedging a gate because repeated entry/reset is too cumbersome;
- putting a reset where the operator cannot see the relevant zone;
- sharing one reset across zones that cannot all be inspected;
- leaving a key/token at the machine so the retention function is bypassed;
- using an HMI acknowledgement as a substitute for physically clearing an occluded zone;
- allowing automatic restart because manual restart is operationally inconvenient;
- teaching maintenance staff to rely on production safeguarding instead of task-appropriate hazardous-energy control.

The safer workflow should be easier than the bypass.

## 7. Commissioning challenges

Do not invent timing or distance values. Challenge the actual installed design:

1. Enter the protected zone and allow the perimeter device to return clear while remaining inside. Verify restart remains prevented by the credited mechanism.
2. Attempt reset from every intended reset station with a test person/object in each relevant blind/occupancy condition permitted by the validation procedure.
3. Remove and restore ordinary-controller power while occupancy protection remains demanded.
4. Remove and restore safety-controller power according to manufacturer procedure; verify retained-person state/restart prevention behaves as designed.
5. Interrupt communications to HMI/LinuxCNC/FPGA consumers and verify stale diagnostic state cannot authorize restart.
6. Clear the zone correctly, reset safety, and verify a separate fresh ordinary START/rearm is still required where the architecture specifies it.
7. Challenge multiple-person entry/exit if the architecture relies on personnel accounting.

Use manufacturer-approved validation methods and safe test conditions; do not place people in a hazardous state merely to prove a fault response.

## 8. Minimum-operate decision

If a person can remain in an accessible hazardous zone after the perimeter safeguard clears and no validated restart-prevention method covers that condition, classify that operating condition **DO-NOT-OPERATE WITH PEOPLE EXPOSED** until corrected. Remote/isolated experimental operation may be used only with people kept outside the danger zone and residual hazards explicitly controlled.