# Field-device replacement revalidation and EDM proof boundary

Date: 2026-09-19

## Why this branch

The primary hydraulic search produced a useful machine-level replacement rule but remains source-limited on unmasked individual hydraulic retaining-valve proof. Per work-selection policy, rotate rather than invent a hydraulic test.

## Authoritative evidence

### Rockwell GuardLogix project validation

Evidence class: `DOC-CONFIRMED`.

Rockwell requires active validation with field devices because that is the way to verify sensors and actuators are wired correctly. Full application validation activates every sensor and actuator involved in each safety function and tests shutdown functions. Rockwell also states that validation is specific to the physical application tested and calls for impact analysis/revalidation consideration when components in a certified functional-safety system are modified.

This is an important return-to-service boundary: a replacement device being electrically present is not the same thing as the safety function being revalidated in the actual machine context.

### Rockwell SAFETY-AT055 contactor validation

Evidence class: `DOC-CONFIRMED`.

The published validation procedure deliberately removes and shorts contactor feedback, commands Stop, then attempts Reset. The expected result is that the system cannot reset/restart while the feedback fault exists. This proves a diagnostic/restart-inhibit behavior with the real external switching-device feedback path.

### Schneider SF_EDM

Evidence class: `DOC-CONFIRMED`.

Schneider's safety-related EDM function monitors contactor initial state and switching behavior. Invalid feedback keeps the EDM output in the safe state. Error reset is accepted only after the cause is no longer present; a reset edge can remove the inhibit once prerequisites are satisfied.

## Durable conclusions

`REPLACEMENT DEVICE INSTALLED != FIELD WIRING VERIFIED != SAFETY FUNCTION REVALIDATED != HAZARD PHYSICALLY SAFE != PRODUCTION AUTHORITY`

`STOP COMMAND != CONTACTOR COIL OFF != MAIN POWER POLES OPEN`

`EDM FEEDBACK CORRECT != HAZARDOUS ENERGY ABSENT != PHYSICAL STOP PERFORMANCE PROVED`

`FAULT CAUSE REMOVED != ERROR RESET != SAFETY OUTPUT RE-ENABLED != ORDINARY PRODUCTION START`

The strongest transferable lesson is that post-replacement proof must exercise the **actual field device in the actual application**, not merely clear diagnostics or verify configuration data.

## Important feedback-granularity boundary

Rockwell application material also shows that one feedback can be used for two contactors in some validated architectures, while two feedbacks improve identification of which contactor caused a fault. Therefore:

`REDUNDANT CONTACTORS != INDIVIDUAL CONTACTOR FEEDBACK`

and

`SHARED EDM PASS != INDIVIDUAL SWITCHING-ELEMENT IDENTITY PROOF`.

Do not silently claim individual fault localization or independent mechanical proof when the implementation only returns a combined feedback state.

## Application to the curriculum

For future OpenPressBrake safety architecture, ordinary LinuxCNC/FPGA diagnostics may display safety-device status, but they must not become the sole authority that a replacement safety device is valid. Where a safety function depends on external final elements, commissioning/recommissioning must preserve an independent safety-side validation path and a physical witness appropriate to the hazard.

This does **not** assign a PL/SIL/category/DC value to OpenPressBrake and does not prove any particular contactor or hydraulic topology is suitable.

## Compute decision

No executable lab was justified. The unresolved issue is physical field-device validation/replacement authority, already answered at the documentation level for this branch. No GitHub-hosted or self-hosted compute was consumed.

## Next Lane-B target

Find a professional implementation that continues beyond EDM/restart inhibit into:

`detected/stuck external switching element -> repair/replacement -> field-device functional re-proof -> physical hazardous-energy/motion witness -> safety rearm -> application-specific fresh ordinary start`.

Prefer a procedure that explicitly replaces a contactor/drive/valve and repeats a physical shutdown or stopping test, rather than treating EDM feedback alone as physical proof.
