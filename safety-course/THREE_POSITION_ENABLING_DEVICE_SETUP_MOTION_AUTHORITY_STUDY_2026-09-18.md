# Three-position enabling device / setup-motion authority study

Date: 2026-09-18

## Scope

Independent Lane-B study of personnel-safety authority when setup, teaching, maintenance, or observation requires a person to be inside a hazardous area with a normal guard/protective function suspended. This is not an OpenPressBrake design specification. It does not assign a safe speed, force, stopping time/distance, PL/SIL/category/DC, hydraulic state, or permissible setup operation to a physical machine.

## Why this branch is independent

The primary durable safety work is centered on gravity-axis brake/retaining proof and failure disposition. Lane B's immediately preceding work covered press-brake dynamic optical muting. This study instead addresses the human-held enabling-device authority chain and uses separate files/evidence.

## Professional evidence

### Pilz PITenable

**DOC-CONFIRMED.** Pilz describes PITenable as a manually operated three-level enabling switch for work inside a machine danger zone when the effect of a safeguard must be suspended. The documented sequence is Off-On-Off: an unoperated switch is not enabling; the middle position activates the enabling function; sudden release or full depression invokes the protective function and brings the machine to a standstill. Pilz explicitly frames the third position as protection against a shock/panic overreaction. Pilz also identifies PNOZmulti and PSS 4000 as safe evaluation systems for the solution.

Source: Pilz, `Enabling switch PITenable`, https://www.pilz.com/en-GB/products/operating-and-monitoring/control-and-signal-devices/pitenable-enabling-switch

Important limit: the public product page does not establish the correct OpenPressBrake setup mode, permissible motion, stopping performance, or hydraulic response.

### SICK E100 and Guide for Safe Machinery

**DOC-CONFIRMED.** SICK's E100 is a three-stage Off-On-Off enabling switch intended for setup or maintenance operation; movement can be activated only in the middle position. SICK's machinery-safety guide adds the crucial authority rule: actuation of the enabling device alone must not initiate machine start. Movement is permitted only while the enabling device remains actuated, and an additional start/jog control may be used. The guide also states that the enabling function must not be released while returning from position 3 to position 2 and calls out manipulation protection.

Sources:
- SICK E100 product documentation: https://www.sick.com/cn/en/catalog/products/safety/safety-switches/e100/c/g195532
- SICK `Guide for Safe Machinery`, enabling-devices section: https://cdn.sick.com/media/docs/8/78/678/Special_information_Guide_for_Safe_Machinery_en_IM0014678.PDF

### Rockwell 440J Grip

**DOC-CONFIRMED.** Rockwell describes the 440J Grip as part of the conditions required for safe work inside a machine guard. The standard model contains two independent three-position enabling switches, with variants providing a separate jog button or dual-channel E-stop. Rockwell identifies the dual-channel device as suitable for Category 3 or 4 systems, but that product-level statement must not be transferred into a claim that any OpenPressBrake implementation achieves a category or performance level.

Source: Rockwell Automation, `440J Grip Enabling Switches`, https://www.rockwellautomation.com/en-us/products/hardware/safety-products/440j-grip-switches.html

## Frozen authority model

Do not collapse these states:

`SETUP/MAINTENANCE MODE SELECTED`

`!= SAFEGUARD SUSPENSION AUTHORIZED`

`!= PERSON HOLDS ENABLING DEVICE IN VALID MIDDLE POSITION`

`!= SAFETY SYSTEM GRANTS LIMITED SETUP-MOTION PERMISSIVE`

`!= SEPARATE JOG/MOTION INTENT PRESENT`

`!= FINAL ELEMENT ACTUATED`

`!= HAZARDOUS MOTION WITHIN THE VALIDATED SETUP ENVELOPE`.

Likewise:

`ENABLING DEVICE RELEASED OR SQUEEZED TO POSITION 3`

`=> SAFETY MOTION PERMISSIVE MUST BE REMOVED BY THE VALIDATED SAFETY PATH`

but this does **not** by itself prove that hazardous motion has physically ceased, that gravity/load energy is retained, or that all energy is isolated.

The practical architecture rule is therefore:

**ENABLING DEVICE = permission condition, not a START command and not proof of safe physical state.**

## LinuxCNC / FPGA boundary

**INFERENCE, grounded in the manufacturer evidence above.** LinuxCNC/HAL or an ordinary FPGA may request/command the selected setup motion only after receiving the safety-side permissive appropriate to the architecture. It must not be the sole evaluator of the personnel-held enabling function when that function is relied upon for personnel protection.

A stale `JOG`, `DOWN`, `ENABLE`, or pendant-motion bit must not silently become fresh motion intent merely because the enabling device returns to its valid middle position. The SICK evidence that enabling alone must not initiate start makes this separation especially important.

## Failure-path analysis

### Device released in surprise/panic

**DOC-CONFIRMED device behavior:** Pilz and SICK define the released position as Off. Commissioning must prove the installed safety chain removes setup-motion authority and then measure the actual machine response separately. Exact OpenPressBrake stopping behavior is **UNKNOWN**.

### Device squeezed fully in surprise/panic

**DOC-CONFIRMED device behavior:** the third position is Off/protective. The test must challenge full squeeze as well as release; testing only release misses half of the intended three-position human-factor mechanism.

### Position 3 -> position 2 transition

**DOC-CONFIRMED general requirement from SICK:** enabling must not be released merely by relaxing from position 3 back to position 2. Commissioning should therefore challenge this transition rather than assuming the mechanical middle position automatically restores authority. Exact reset/re-enable logic for a chosen implementation remains **UNKNOWN**.

### Enabling held/taped/wedged in middle position

**DOC-CONFIRMED concern:** SICK explicitly calls for manipulation protection; Pilz describes PITenable as difficult to manipulate. A commissioning/human-factors review must look for fixtures, tape, clamps, magnets, cable routing, or work practices that convert a hold-to-enable device into a permanently asserted bit.

### Enabling valid but no fresh jog/start intent

**DOC-CONFIRMED general principle:** SICK states that enabling-device actuation alone must not initiate machine start. Therefore a valid enabling state with no separate motion request must produce no commanded hazardous motion.

### Jog/start held before enabling becomes valid

The manufacturer evidence inspected here does not define every control architecture's stale-command behavior. Treat automatic motion on later enable as **UNKNOWN / requires application validation**, not as acceptable by assumption. For OpenPressBrake curriculum purposes, require a question-driven test proving the intended restart/rearm semantics.

### Safety permissive lost while ordinary control still commands motion

**INFERENCE:** the safety path must remain authoritative over the final element(s) relied upon for personnel protection. LinuxCNC should be allowed to observe the loss and clear its own motion state, but personnel safety cannot depend on LinuxCNC noticing first.

### Enabling-device channel disagreement / conductor fault

The cited product pages establish multi-contact/dual-channel implementations but not the exact diagnostic state machine for the future OpenPressBrake implementation. Classification: hardware redundancy **DOC-CONFIRMED** for cited devices; application discrepancy timing/fault reaction **UNKNOWN**. Obtain the selected evaluation-device manual before freezing a circuit.

### Power cycle while operator is inside

No cited source here proves an OpenPressBrake recovery sequence. Required commissioning question: after safety-controller or ordinary-controller power restoration, can setup-motion authority return without re-establishing valid mode, enabling-device state, required reset/rearm, and fresh motion intent? Until validated, behavior is **UNKNOWN**.

## Commissioning / validation card

For the actual installed implementation, deliberately test and record:

1. normal safeguard active, enabling device untouched;
2. setup mode selected but enabling device at position 1;
3. valid middle position with no separate motion command;
4. valid middle position plus deliberate jog/motion command;
5. release from middle while motion is commanded;
6. full squeeze to position 3 while motion is commanded;
7. relaxation from position 3 toward position 2;
8. one enabling channel open/stuck/disagreeing, where safely injectable;
9. attempted wedging/defeat of the enabling actuator;
10. jog/start asserted before enable becomes valid;
11. loss/restoration of safety permissive while ordinary command remains asserted;
12. controller/safety power cycle during setup state;
13. mode change out of setup while enabling/jog remains asserted;
14. final-element response and actual hazardous-motion cessation measured on the installed machine;
15. gravity, hydraulic, pneumatic, electrical, or stored-energy hazards that remain after motion command removal.

A passing HMI lamp, HAL bit, safety-controller diagnostic, or enabling-switch contact check is not physical final-element proof.

## Human-factors rule

The safer setup path should be easier than bypassing the guard. A usable enabling device plus deliberate jog control can support legitimate adjustment while retaining immediate human release/squeeze authority. If the setup workflow is so awkward that operators routinely wedge the device or defeat the guard, that is a design problem to correct, not merely an operator-training problem.

If minimum personnel protection cannot be demonstrated for the intended setup task, do not operate with a person exposed to the hazard. Experimental operation should be isolated/remote with people outside the danger zone and residual risk stated plainly.

## Evidence ledger

- Three-position Off-On-Off enabling behavior: **DOC-CONFIRMED** (Pilz, SICK).
- Intended use during setup/maintenance when normal protective effect is suspended: **DOC-CONFIRMED** (Pilz, SICK).
- Enabling device alone must not initiate machine start: **DOC-CONFIRMED** (SICK).
- Position 3 -> 2 must not automatically release the enabling function: **DOC-CONFIRMED** (SICK guide).
- Manipulation protection is a design concern: **DOC-CONFIRMED** (SICK; Pilz product claims difficult manipulation).
- Dual independent three-position switches available in a professional enabling device: **DOC-CONFIRMED** (Rockwell 440J).
- LinuxCNC/HAL should not own personnel-safety enabling authority: **INFERENCE** from the safety-boundary architecture and manufacturer behavior.
- Exact OpenPressBrake setup mode, permitted motion, speed/force envelope, stopping performance, final elements, channel diagnostics, reset sequence and achieved PL/SIL/category/DC: **UNKNOWN**.
- No physical OpenPressBrake behavior was tested in this study: **TEST-CONFIRMED: none**.
- No community claim was required: **COMMUNITY-REPORTED: none**.

## Next independent evidence target

Trace a complete manufacturer application showing `mode selection -> guard/protective suspension -> three-position enabling device -> safety evaluation -> separate jog/start -> safe-motion/final-element authority -> release/full-squeeze stop -> reset/rearm`, including channel-disagreement and power-cycle behavior. Prefer a wiring/application manual over another product overview. If the primary lane moves into enabling-device/setup-mode work first, rotate Lane B to another independent branch rather than editing overlapping files.

No simulation, synthesis, benchmark, executable test, or GitHub-hosted Actions compute was justified or used.