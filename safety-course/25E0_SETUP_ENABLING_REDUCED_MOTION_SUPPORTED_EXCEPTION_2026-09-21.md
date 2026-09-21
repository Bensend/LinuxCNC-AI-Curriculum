# 25E0 — Setup/Enabling + Reduced-Motion Supported Exception

Date: 2026-09-21

## Purpose

Extend the intentional-exception study beyond material-flow muting into a substantially different professional pattern: guarded-machine/robot setup or recovery where normal protection is displaced or unavailable but hazardous motion is still required.

This is an **exception architecture**, not a recipe for defeating guards. Machine-specific safe speed, stopping distance, force, geometry, PL/SIL target and hydraulic/mechanical acceptance criteria remain design-specific and are not supplied here.

## Evidence

### DOC-CONFIRMED — enabling is permission, not start

ABB AC500-S `SF_EnableSwitch` documentation reproduces the IEC 60204-1 enabling-control requirement: an enabling control, when actuated, allows machine operation to be initiated by a **separate start control**; deactivation initiates a stop and prevents initiation. It also states that defeat should be minimized, including requiring deactivation before operation can be reinitiated.

Source: ABB AC500-S safety help, `SF_EnableSwitch` / `SF_EnableSwitch_2` (accessed 2026-09-21).

### DOC-CONFIRMED — displaced protection requires a specific alternate strategy

ABB AC500-S `SF_Override` cites the ISO 12100 setup/teaching/process-changeover/fault-finding/cleaning/maintenance pattern: when a guard must be displaced/removed or a protective device disabled and machine operation is necessary, use a specific control mode that disables other control modes, permits hazardous elements only by continuous actuation of enabling/two-hand/hold-to-run control, permits operation only under reduced-risk conditions, and prevents hazardous operation through voluntary/involuntary sensor action.

Source: ABB AC500-S safety help, `SF_Override` (accessed 2026-09-21).

### DOC-CONFIRMED — professional robot recovery exposes separate safety state and motion action

ABB SafeMove for OmniCore documents recovery after supervision violations. In Manual mode, speed/standstill violations require release and re-activation of the three-position enabling device; position/orientation violations then require jogging back to a non-violating position. An unsynchronized SafeMove state permits movement only at reduced speed until synchronization is performed. Two-channel fault recovery requires validation of the safety inputs.

Source: ABB, *Application manual — Functional safety and SafeMove for OmniCore*, 3HAC066559-001 Rev T (2020–2025), recovery section.

### DOC-CONFIRMED — commanded reduced speed is not automatically safety-rated monitoring

KUKA Sunrise Cabinet Med explicitly says its normal T1 reduced velocity does **not** constitute safety-rated reduced speed in the standard safety configuration. If safety-oriented velocity monitoring is required, it must be separately configured using the relevant safety option.

Source: KUKA, *Sunrise Cabinet Med*, safety section 3.5.2.2.

## Reusable authority chain

A supported setup/recovery exception should be reasoned about as distinct authorities:

`authorized/safely selected exceptional mode`

`+ replacement protective conditions`

`+ enabling/hold-to-run condition`

`+ independently justified reduced-risk condition where required`

`+ separate deliberate motion command`

`-> exceptional motion eligibility`

None of those terms may be silently collapsed into an ordinary LinuxCNC `machine-is-on`, `motion-enabled`, or FPGA permissive bit.

## Frozen distinctions

- **EXCEPTION MODE SELECTED != MOTION COMMAND.**
- **ENABLING DEVICE VALID != MOTION COMMAND.**
- **ORDINARY SPEED COMMAND/LIMIT != SAFETY-RATED SPEED MONITORING.**
- **GUARD DISPLACED WITH A SUPPORTED ALTERNATE STRATEGY != GUARD DEFEATED WITHOUT REPLACEMENT PROTECTION.**
- **REDUCED SPEED != SAFE SPEED unless the hazard analysis, safety architecture and validation establish the relevant criterion.**
- **RECOVERY MOTION ALLOWED != NORMAL PRODUCTION AUTHORITY.**
- **SAFETY RESET/RE-ENABLE != FRESH ORDINARY START DEMAND.**

## Supported exception vs superficially similar defeat

| Question | Supported setup/recovery exception | Unauthorized defeat |
|---|---|---|
| Why normal protection is unavailable | Defined task and selected mode | Convenience/workaround |
| Activation authority | Deliberate, controlled mode selection | Jumper, spare actuator, forced bit, taped switch, ad-hoc software |
| Replacement protection | Explicit enabling/hold-to-run and reduced-risk strategy as required | Missing or assumed |
| Motion authority | Separate deliberate command | May inherit stale/automatic demand |
| Reduced motion | Safety-oriented monitoring when required by design | Ordinary command clamp/override often substituted |
| Indication/state | Exceptional mode should be conspicuous and bounded | Often hidden or normalized |
| Exit | Defined return-to-normal sequence and revalidation | Remove bypass and hope normal status is enough |
| Production return | Restore normal safeguards; clear exceptional states; re-prove affected propositions; establish fresh production demand | Permissive bit becomes true |

## LinuxCNC/OpenPressBrake boundary

LinuxCNC may request ordinary jog/recovery motion and may display diagnostic state. Ordinary HAL, userspace, realtime logic, a normal FPGA controller, or a software velocity clamp does not become personnel-safety authority merely because it participates in the workflow.

Where personnel can be exposed, the independent safety architecture must own the safety-related mode/enabling/reduced-risk conditions and physical final-element response appropriate to the machine. A press-brake gravity/hydraulic axis cannot inherit robot-specific assumptions about what reduced speed makes safe; stored hydraulic energy, ram retention and gravity remain separate propositions.

## Human-factors rule

If legitimate setup/recovery work repeatedly requires defeating a guard or taping an enabling device, treat that as evidence that the supported workflow is poorly engineered. Improve access, visibility, pendant/enabling ergonomics, diagnostic observability, recovery controls, or mode design so the supported path is easier than the bypass path.

## Evidence boundary

The cited professional material establishes the architecture above but does **not** establish a universal numeric safe speed, stopping distance, force, enabling-device location, restart edge, or machine-specific safe state. Those remain `UNKNOWN/design-specific` until the actual machine hazard analysis and validation establish them.
