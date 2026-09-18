# Gravity-axis brake-proof failure disposition trace — 2026-09-18

Session start: 2026-09-18T08:34:13Z

## Scope

This note closes a narrow evidence gap left by the prior gravity-axis SBT/SBC work: what a professional implementation actually does after a brake proof fails, and what that does **not** prove about a suspended/gravity load.

Evidence labels used here: SOURCE-CONFIRMED, DOC-CONFIRMED, TEST-CONFIRMED, COMMUNITY-REPORTED, INFERENCE, UNKNOWN.

## Professional evidence

### SEW-EURODRIVE safe brake test result and recovery

**DOC-CONFIRMED.** SEW-EURODRIVE's 2025 MOVIPRO/CS..A documentation states that when the safe brake test completes with an error, either the test execution failed or the brake failed the test. The inverter is placed in STO; `STO` and `Diagnosis ASF` are asserted and the safety option reports an SBT safe-brake-system error. To acknowledge, the SBT control first has to be deactivated; the pending error can then be acknowledged at the safety option.

This is useful because failure disposition is not merely `display alarm and continue`: the documented drive state goes to STO.

**DOC-CONFIRMED.** SEW's 2026 safe-motion documentation also states explicitly that STO removes drive torque and that a gravity-loaded axis can crash without further action. For gravity-loaded axes, safe brake control must therefore be considered separately from torque removal.

### Pilz safe brake test

**DOC-CONFIRMED.** Pilz states that the SBT deliberately loads the brake with additional torque. Position change during the test is an impermissible state; the resulting message prevents further operation, the plant is brought to a safe stop, and the brake can be repaired.

This independently supports the rule that failed proof removes further-production authority. It does not identify the detailed physical load-retention path for every machine.

### Proof validity depends on the physical chain

**DOC-CONFIRMED.** SEW documents brake-test fault patterns including brake remaining open and insufficient braking torque. It also warns that in non-SEW motor-integrated safety-brake systems the user must rule out a break in the mechanical transmission between motor, tested brake and diagnostic encoder. Backlash must not mask a defective brake.

**DOC-CONFIRMED.** SEW further requires gravity/load torque to be included in the test-torque model. Too little test torque can leave faults undetected; too much can produce false failure and unwanted structural load.

Therefore `SBT PASS` is evidence only inside the validated mechanical/test chain. It is not a universal proof that every downstream load-retaining element is healthy.

## Frozen authority/evidence chain

**BRAKE TEST REQUEST != TEST TORQUE APPLIED != BRAKE HELD TEST TORQUE != LOAD PHYSICALLY RETAINED != TEST PASS != PRODUCTION AUTHORITY.**

On failure:

**SBT FAIL -> SAFETY FAULT/INHIBIT -> PHYSICAL LOAD-SAFE DISPOSITION REQUIRED -> FAULT CAUSE CORRECTED -> ACKNOWLEDGEMENT -> REQUIRED RE-PROOF -> SAFETY AUTHORITY -> FRESH ORDINARY START.**

The middle physical-load-safe disposition is machine-specific. STO is not sufficient evidence for a gravity axis because it removes motor torque rather than gravity. The load may require the tested brake, a second brake, hydraulic holding element, mechanical prop/restraint, or another validated retaining architecture. Public evidence reviewed here does not establish the OpenPressBrake mechanism, so that remains **UNKNOWN**.

## Two-retaining-element disagreement

Siemens documentation supports SBT of up to two brakes (motor holding + external, two external, or either singly). Pilz also describes applications using a second brake/dual-brake architecture. This establishes that multiple retaining elements are a real professional architecture, but does not justify an inference that one passing brake automatically permits continued production after the other fails.

Freeze the conservative commissioning rule:

**INFERENCE:** if the machine's safety concept requires two independent retaining elements, `Brake A PASS + Brake B FAIL/UNKNOWN` cannot be collapsed into `LOAD SAFE FOR PRODUCTION`. The required degraded-state behavior must come from the validated machine safety concept.

A separate physical maintenance restraint remains distinct from functional brake safety.

## Fault-injection / commissioning card

Challenge the implementation with these cases before crediting the safety claim:

1. Brake command closes but test detects movement: further hazardous operation remains inhibited.
2. SBT fails and STO becomes active on a gravity axis: verify the intended physical retaining element actually controls the load; do not infer this from STO.
3. One of two required brakes passes while the other fails or has missing diagnostics: reject a composite machine-safe claim unless the validated architecture explicitly supports that degraded state.
4. Encoder/mechanical transmission used by SBT is disconnected, slipping or backlash-masked: reject the brake-proof claim until diagnostic-chain integrity is established.
5. Test torque is inconsistent with actual gravity/load torque: reject both false-pass and false-fail conclusions until the validated test condition is restored.
6. Operator acknowledges the SBT fault without repair: acknowledgement must not become proof restoration.
7. Repair is completed but no required re-test is performed: production authority remains unproved.
8. Safety authority returns while LinuxCNC/HAL/FPGA START/JOG/ENABLE was already asserted: require fresh ordinary intent; stale normal-control state must not initiate motion.
9. Maintenance requires bodily entry beneath/near the gravity load: functional SBT/SBC status does not replace physical isolation/blocking/restraint required by the task.

## Minimum-safe-to-operate gate

If a retaining function required by the machine safety concept has failed its proof, its proof channel is unavailable, or the test chain cannot establish the required holding capability, do **not** operate with people exposed to the fall/crush hazard. Experimental troubleshooting must keep people outside the danger zone and use appropriate physical load control.

## LinuxCNC / FPGA boundary

LinuxCNC and the ordinary FPGA may display SBT/SBC state, suppress normal commands, and require a new application-level START after safety recovery. They are not the sole personnel-safety authority, must not synthesize a brake-proof PASS from ordinary motion feedback, and must not bypass an independent safety latch because the axis appears stationary.

## OpenPressBrake unknowns preserved

The following remain **UNKNOWN** until machine-specific evidence exists: required number/type of retaining elements; brake or hydraulic holding topology; proof torque; permitted movement; test interval; stopping/holding performance; PL/SIL/category; encoder diagnostic chain; acceptable degraded modes; reset/re-proof sequence; and maintenance restraint.

## Sources

- SEW-EURODRIVE, MOVIPRO technology DSI / CS..A, `Test result and ending the test`, edition 08/2025.
- SEW-EURODRIVE, safe-motion documentation, `Fault response on limit value violation`, edition 05/2026.
- SEW-EURODRIVE, `Diagnostic coverage (DC)` and `Effect of load torque on the hoist`, 2026 documentation.
- Pilz, `Safe brake test (SBT)` / Safety Compendium safe-motion chapter.
- Siemens SINAMICS S120 Safety Integrated Function Manual, Safe Brake Test: up to two brakes; test torque/force against applied brake and movement tolerance.

No simulation, build, synthesis, benchmark, test suite, or GitHub-hosted Actions compute was used for this source/documentation trace.
