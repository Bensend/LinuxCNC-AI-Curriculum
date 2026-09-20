# Press-Brake Post-Maintenance Stopping-Performance, Safeguard, and Production-Release Chain

Date: 2026-09-20

## Question
Can an authoritative press-brake source connect maintenance to physical machine re-test, stopping-performance/safeguard authority, and an explicit boundary before production resumes?

## Evidence

### Rockford RHPS hydraulic press-brake control manual — DOC-CONFIRMED
Rockford Systems' RHPS hydraulic press-brake installation manual states that after **any maintenance** the machine is to be operated numerous times in **all modes of operation as a function test before allowing the operator to start production**. It also requires point-of-operation safeguarding to be in place, adjusted, and operating properly for the job and operator before production.

The same RHPS source family establishes that stopping performance is part of safeguarding authority: total stopping time includes control response plus actual ram stopping, and increased stopping time/distance requires safety-distance recalculation and, when required, outward safeguard repositioning. This is preserved in the earlier curriculum artifact `PRESS_BRAKE_STOP_TIME_DETERIORATION_SAFEGUARD_REPOSITION_LIFECYCLE_TRACE_2026-09-20.md`.

Source: Rockford Systems, *Installation Manual for RHPS Control Systems on Hydraulic Press Brakes*, KSL278. Current web copy retrieved 2026-09-20: https://rockfordsystems.com/wp-content/uploads/RHPS-Control-Systems-On-Hydraulic-Press-Brakes_KSL278.pdf

### Rockford stop-time measurement guidance — DOC-CONFIRMED
Rockford describes stop-time measurement as measuring the time a machine takes to stop after a stop signal, specifically including hydraulic presses and press brakes. The measured result is used to establish the minimum safety distance for safeguarding devices. Rockford also describes STM as applicable to newly installed safeguards and periodic validation of existing safeguards.

Source: Rockford Systems, Stop-Time Measurement Device / service guidance, retrieved 2026-09-20.

### Fiessler AKAS press-brake protection — DOC-CONFIRMED
Fiessler's AKAS-LC press-brake protection documentation explicitly parameterizes allowable stopping distance against the physical protective geometry. The published table ties the adjusted Z distance to a maximum allowable press stopping distance in fast speed. This is direct evidence that the safeguard's physical setup is conditional on measured machine stopping behavior, not merely on the controller configuration being intact.

Source: Fiessler Elektronik, AKAS-LCII press-brake protection instructions, current copy retrieved 2026-09-20.

## Integrated lifecycle

The combined authoritative evidence supports this return-to-production chain:

1. **Maintenance/repair occurs.**
2. Determine which safety evidence the work can invalidate; do not assume a checksum or restored configuration closes physical effects.
3. **Function-test the press brake repeatedly in all modes** before production.
4. Where the work can affect stopping performance or a stopping-dependent safeguard, obtain the required **quantitative physical stopping evidence** rather than relying on a normal cycle test.
5. Recalculate/recheck safeguard placement or press-brake protective geometry from the accepted stopping performance when that safeguard depends on it.
6. Confirm point-of-operation safeguarding is physically in place, adjusted, and operating properly for the actual job/operator.
7. Only after the affected evidence is accepted does the source permit the boundary to move to operator production.

The exact test scope remains change-dependent. `After any maintenance` does not mean every maintenance action automatically requires a stop-time measurement; it does mean Rockford requires a post-maintenance all-mode function test before production. Quantitative stopping measurement is additionally required when stopping-dependent safeguarding authority has been invalidated or must be established.

## Four-class validation mapping

- **A — normal-demand functional test:** explicitly present: repeated operation in all modes after maintenance.
- **B — deliberate abnormal/fault-injection test:** not established by this RHPS post-maintenance passage; invoke only when the changed safety function requires it.
- **C — quantitative physical performance:** stop-time/distance measurement is the authoritative physical witness when safeguarding distance/geometry depends on stopping performance.
- **D — periodic functional/proof test:** Rockford separately describes periodic validation of existing safeguarding through stop-time measurement; interval remains application-specific.

## Curriculum freezes

**MAINTENANCE COMPLETE != ALL-MODE FUNCTION TEST COMPLETE != PRODUCTION AUTHORIZED.**

**ALL-MODE FUNCTION TEST PASSED != QUANTITATIVE STOPPING PERFORMANCE ACCEPTED WHEN STOPPING-DEPENDENT SAFEGUARDING WAS INVALIDATED.**

**STOPPING PERFORMANCE ACCEPTED != SAFEGUARD PHYSICALLY IN PLACE/ADJUSTED/OPERATING FOR THE JOB.**

**SAFETY DISTANCE/PROTECTIVE GEOMETRY CALCULATED != INSTALLED SAFEGUARD PHYSICALLY REQUALIFIED.**

**CONFIGURATION RESTORED != PHYSICAL RETURN-TO-PRODUCTION EVIDENCE COMPLETE.**

## OpenPressBrake boundary

This evidence does **not** establish OpenPressBrake-specific stopping time, stopping distance, AKAS geometry, hydraulic thresholds, PL/SIL, test frequency, or acceptable drift. Those remain `UNKNOWN` until the actual machine, safeguard, and safety architecture establish them.

For OpenPressBrake curriculum design, LinuxCNC/ordinary FPGA diagnostics may record test state and measurements, but personnel-safety authority remains with the independent safety architecture and physical safeguard/final-element evidence.

## Information-gain decision

The previously open target—high-energy machine evidence connecting post-maintenance testing, quantitative stopping performance, safeguard requalification, and a before-production boundary—is now materially closed at manufacturer-documentation level by the Rockford press-brake chain. Further generic press-brake stop-time searching is information-gain limited unless a stronger OEM procedure adds a missing physical witness or explicit acceptance criterion.

Next high-value branch: develop the **change-to-evidence invalidation matrix** for representative safety-related maintenance actions (sensor replacement, final-element replacement, hydraulic work, drive/encoder replacement, safeguard relocation), preserving UNKNOWN machine-specific thresholds and using the four evidence classes rather than mechanically retesting everything.
