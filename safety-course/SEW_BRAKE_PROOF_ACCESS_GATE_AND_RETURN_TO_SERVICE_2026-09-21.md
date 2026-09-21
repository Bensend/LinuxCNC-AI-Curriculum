# SEW Brake Proof, Access Gate, and Return-to-Service Boundary — 2026-09-21

## Why this branch

The preceding 25E0 work established that a product family may contain Safe Brake Control, Safe Brake Test, and safe-motion monitoring without proving that those observations are automatically conjoined into one production permissive. This trace therefore looked for a stronger application-level rule: a physical brake proof whose result is explicitly coupled to access/return-to-service, plus documented failure acknowledgment behavior.

## Evidence classification

### DOC-CONFIRMED — active physical brake proof

SEW-EURODRIVE documents FCB 21 brake test as a static proof of up to two brakes. The inverter generates configurable torque against the applied brake and permits only configured movement. With two brakes, each brake is tested separately. SEW states that the function diagnoses the safety-related brake subfunctions safe stopping (SBA) and safe holding (SBH).

This is a physical challenge + process-response architecture, not merely command or auxiliary-contact feedback.

### DOC-CONFIRMED — proof result can gate personnel access

SEW's 2026 brake project-planning documentation states that, where access to the hazard zone is safely prevented by measures such as guard locking, a brake test may be performed immediately before access and **access may be granted only after a positive test result**.

This is materially stronger than treating a periodic proof test as background maintenance evidence. In this application pattern the proof result participates directly in an access decision.

SEW also recommends brake-test execution after events including initial startup, emergency-stop braking, voltage failure, machine switch-on, and inspection/maintenance/repair. The exact required interval remains machine- and risk-assessment-specific; these examples are not OpenPressBrake defaults.

### DOC-CONFIRMED — explicit failed-test return path

SEW MOVIPRO technology documentation gives an explicit SBT completion/failure sequence. On successful completion, SBT becomes inactive and the inverter is in STO. On test error/failure, SBT becomes inactive, STO remains active, diagnostic status is asserted, and a safe-brake-system error is reported. To acknowledge an error, brake-test control is first deactivated; the pending error may then be acknowledged at the safety option. After successful acknowledgment the inverter returns to its documented non-test state.

The important curriculum point is that **failure disappearance is not itself the documented return-to-service action**. The documented path includes deactivating the test control and acknowledging the safety-option error.

### DOC-CONFIRMED — failed/cancelled tests can require safe acknowledgment and retest

SINAMICS S210 documentation independently shows a similar but product-specific pattern: several SBT cancellation/failure conditions instruct the user to perform a safe acknowledgment and, where required, restart the brake test. This corroborates the general engineering lesson that proof-test failure/recovery state must be traced from the actual implementation, but SEW and Siemens semantics must not be merged into one universal algorithm.

## Evidence boundary

The public evidence inspected still does **not** establish one universal machine state machine that continuously ANDs brake capability with an independent safe-speed witness at every hazardous transition. The earlier composition boundary therefore remains valid.

Likewise, SEW's documented acknowledgment path does not by itself prove that an already-held ordinary Cycle Start, jog, or automatic request is cancelled. Demand freshness remains a separate ordinary-control state-machine property unless the actual machine implementation documents otherwise.

## New freezes

- **PERIODIC BRAKE PROOF != CONTINUOUS BRAKE PROOF.**
- **POSITIVE BRAKE TEST != ALL HAZARDOUS ENERGY SAFE.**
- **POSITIVE BRAKE TEST CAN BE A PREREQUISITE FOR ACCESS without becoming proof of personnel clearance or every other safety function.**
- **BRAKE TEST FAILED -> STO != RETURN TO SERVICE COMPLETE.**
- **FAULT CAUSE REMOVED != DOCUMENTED SAFETY ERROR ACKNOWLEDGED.**
- **SAFETY ERROR ACKNOWLEDGED != BRAKE CAPABILITY RE-PROVED unless the actual application requires/executes a successful new proof.**
- **SAFE BRAKE TEST RESULT != FRESH ORDINARY START DEMAND.**
- **TWO BRAKES TESTED SEPARATELY != BOTH BRAKES CONTINUOUSLY PROVED at every later transition.**

## Human-factors consequence

For a gravity-loaded machine, the safer workflow should make the required proof test and its disposition difficult to bypass accidentally. If access is intentionally conditioned on a proof result, the machine should present one obvious path: perform the proof in a suitable protected test position, obtain a valid result, satisfy the independent access/guarding conditions, and only then permit access. A maintenance workflow that makes bypassing the proof easier than completing it is an engineering defect.

A failed proof test must not be reduced to a nuisance banner that maintenance can clear while leaving the machine looking production-ready. The UI/state model should distinguish at least: test required, test active, test passed for the applicable interval/event, test failed, fault acknowledged, and production/access eligibility. These are typed states, not one `SAFE` bit.

## OpenPressBrake teaching boundary

Do not copy SEW test torque, motion tolerance, diagnostic coverage, proof interval, STO sequencing, or access architecture into OpenPressBrake. A press brake has machine-specific hydraulic, gravity, tooling, ram, guarding, and stored-energy hazards. The reusable lesson is the evidence structure:

`retaining element commanded/applied -> deliberate physical challenge -> independent mechanical response witness -> acceptance criterion -> typed proof result -> application-specific access/return gate`

and on failure:

`proof failure -> defined safe reaction -> cause correction -> explicit safety disposition/acknowledgment -> required re-proof if specified -> separate safety rearm -> fresh ordinary demand`

## Source provenance

- SEW-EURODRIVE, FCB 21 Brake test, current online documentation: configurable torque against applied brake, bounded movement, separate testing of two brakes, SBA/SBH diagnostic role.
- SEW-EURODRIVE, Project Planning for BK/BKB/BP/BR/BY/BZ Brakes, edition 04/2026, Test rate: access only after positive test result in the documented guarded-access pattern; recommended event-driven test occasions.
- SEW-EURODRIVE, MOVIPRO technology DSI, edition 08/2025, Test result and ending the test: success/failure state, STO, diagnostic error, deactivate SBT control then acknowledge safety-option error.
- Siemens SINAMICS S210 operating instructions: selected SBT cancellation/failure conditions require safe acknowledgment and may require restarting the test; retained only as cross-vendor corroboration, not as SEW semantics.

## Information-gain stop / next branch

The search for a public application that explicitly conjoins retaining/brake evidence and independent motion evidence continuously at every hazardous transition remains source-limited. Do not keep searching product catalogs indefinitely. The next high-value 25E0 branch should develop **physical commissioning and validation methodology for heterogeneous witnesses**: how to prove that each sensor/feedback path actually observes the claimed physical condition, how to inject disagreement/failure safely, how to validate sequencing without collapsing evidence classes, and how modification/maintenance invalidates prior proof. Prefer authoritative commissioning procedures and standards/manufacturer validation guidance before any lab.
