# Dual-brake independent proof and diagnostic-chain study

Date: 2026-09-18

## Scope

Primary safety-course gravity-axis branch. This study closes part of the open dual-retaining-element question using current professional drive documentation. It does not define an OpenPressBrake brake arrangement, hydraulic truth table, required performance level, test torque, slippage limit, test interval, or stopping behavior.

## Professional evidence

### SEW-EURODRIVE FCB 21 brake test — 2026 documentation

**DOC-CONFIRMED.** SEW-EURODRIVE documents FCB 21 as testing the function/performance of up to two brakes for one inverter. In a two-brake system, the brakes are tested **separately**: brake 1 and then brake 2. Supported arrangements include a motor brake plus an external brake and separately controlled brakes through safety outputs/external control arrangements.

SEW also documents a critical diagnostic-chain failure: if an unsuitable encoder connection allows an encoder-track failure to escape detection, the brake test can report `OK` even though the motor moved beyond the permitted limit during the active test. SEW therefore recommends encoder interfaces that can detect the relevant signal failure rather than relying on an inadequately diagnosed counter input.

Source: SEW-EURODRIVE, `FCB 21 Brake test`, Edition 05/2026: https://download.sew-eurodrive.com/download/html/33354294/en-EN/17501214219.html

### Siemens Safe Brake Test

**DOC-CONFIRMED.** Siemens Safety Integrated documentation describes SBT as checking required holding torque by deliberately generating force/torque against an applied brake and detecting excessive axis movement. Siemens documents support for testing up to two brakes, including a motor holding brake plus external brake or two external brakes.

Source: Siemens, SINAMICS S120 Safety Integrated Function Manual, Safe Brake Test section: https://support.industry.siemens.com/cs/attachments/109763292/S120_safety_fct_man_1218_en-US.pdf

### Kollmorgen AKD2G SBT

**DOC-CONFIRMED.** Kollmorgen documents that two brakes may be assigned to one axis with independent slippage tolerances. Where other brakes/motors are mechanically coupled to the same axis, the other retaining elements must be put into a state that does not mask the brake under test; only one brake is to be tested at a time and each brake must be tested independently.

Source: Kollmorgen, `SBT (Safe Brake Test)`: https://webhelp.kollmorgen.com/AKD2G/English/Content/AKD2G-S%20Install/e/fsm/fs2/AKD2S_install_22_07_00_SBT.htm

## Frozen lesson

For a machine whose safety concept requires two retaining elements:

**BRAKE 1 PASS + BRAKE 2 UNTESTED != DUAL-RETAINING PROOF.**

**BRAKE 1 PASS + BRAKE 2 PASS != COMMON-CAUSE ABSENCE.**

**TEST CONTROLLER SAYS OK != BRAKE HELD REQUIRED TORQUE** unless the motion/feedback chain used to decide pass/fail is itself adequate and validated.

And:

**OTHER BRAKE STILL HOLDING DURING TEST != BRAKE UNDER TEST PROVED.**

The second point is especially important: a redundant retaining element can create a false sense of diagnostic confidence if it mechanically masks failure of the element being tested.

## Diagnostic-chain model

Keep these claims separate:

`TEST REQUESTED`

`!= CORRECT BRAKE SELECTED`

`!= OTHER RETAINING ELEMENT RELEASED/NEUTRALIZED AS REQUIRED BY TEST DESIGN`

`!= TEST TORQUE ACTUALLY APPLIED`

`!= MOTION SENSOR CHAIN VALID`

`!= MOVEMENT WITHIN VALIDATED LIMIT`

`!= INDIVIDUAL BRAKE PASS`

`!= SECOND BRAKE PASS`

`!= REQUIRED DUAL-RETAINING FUNCTION AVAILABLE`

`!= PRODUCTION AUTHORITY`.

## Failure-path analysis

### Brake 1 fails but brake 2 masks movement

Kollmorgen's independent-test requirement directly exposes this hazard. If brake 2 remains capable of holding the common mechanical axis while brake 1 is supposedly being proved, little/no movement does not prove brake 1 carried the test load. Test topology must prevent the untested retaining element from masking the element under test where the manufacturer's method requires independent proof.

### Both brakes pass, common feedback fails

SEW's encoder warning establishes that a brake-test result can be falsely positive if the movement-detection chain has an undetected failure. Two successful brake tests using the same defective movement witness therefore do not establish two independent physical proofs. Shared encoder, wiring, supply, mechanics, parameter set and test logic belong in the common-cause review.

### One brake passes and one fails

The cited documentation proves independent testing, but does not establish that a generic machine may continue production in a degraded one-brake state. Therefore `ONE REQUIRED BRAKE FAILED -> DEGRADED PRODUCTION PERMITTED` is **UNKNOWN and must not be assumed**. If the machine safety concept requires both, loss of either required proof removes the dual-retaining claim until repaired and re-proved.

### Wrong brake selected / wiring swapped

A test can be numerically plausible while proving the wrong physical element. Commissioning must map brake identity from safety command through output/wiring to the physical brake and then challenge each independently.

### Shared mechanical coupling failure

Two brake mechanisms do not automatically provide independent load retention if a common shaft, coupling, gearbox, adapter or structural element can disconnect both from the hazardous load. Exact common-cause boundaries are machine-specific and must be traced physically.

## Commissioning / adversarial card

1. identify every retaining element and the load path from each element to the hazardous mass;
2. prove which safety output controls brake 1 and brake 2;
3. test brake 1 while preventing brake 2 from masking the test according to the validated test method;
4. test brake 2 independently;
5. inject/open each brake command/feedback path where safely possible;
6. challenge swapped brake wiring/identity;
7. challenge movement-feedback loss, frozen value, single encoder-track failure and implausible-but-in-range feedback;
8. verify a failed movement witness cannot yield a trustworthy brake PASS;
9. challenge shared supply/output/common return failures;
10. trace common shaft/coupling/gearbox/structure failures that can defeat both retaining elements;
11. prove one brake failure is latched/dispositioned according to the machine safety concept rather than silently accepted as redundancy consumed;
12. after repair, require the intended independent re-proof before restoring the dual-retaining claim;
13. prove safety-authority restoration still does not turn stale LinuxCNC/HAL/FPGA START/JOG/ENABLE into fresh intent;
14. separately prove physical load retention and maintenance-safe blocking/restraint where personnel exposure requires it.

## OpenPressBrake boundary

The transfer is methodological. A future OpenPressBrake design must not infer that two valves, two brakes, two outputs, or two sensors automatically equal redundant safety. It must establish the actual hazardous-load path, individual proof method, shared dependencies, fault reaction and return-to-service sequence.

No public evidence inspected here establishes an OpenPressBrake dual-brake requirement, hydraulic/mechanical retaining topology, permissible degraded mode, test torque, slippage threshold, interval, stopping distance, pressure threshold, PL/SIL/category/DC or diagnostic coverage. Those remain **UNKNOWN** until the actual machine architecture and risk analysis support them.

## Evidence ledger

- Up to two brakes can be tested and two-brake systems are tested separately in SEW FCB 21: **DOC-CONFIRMED**.
- A movement-feedback failure can create a false `OK` brake-test result if the diagnostic interface does not detect the relevant encoder fault: **DOC-CONFIRMED** (SEW).
- Siemens SBT supports up to two brakes and deliberately applies torque against the applied brake: **DOC-CONFIRMED**.
- Kollmorgen requires independently testing each brake and preventing mechanically coupled elements from impeding/masking the test: **DOC-CONFIRMED**.
- Two passing tests sharing one defective witness do not establish independent physical proof: **INFERENCE** directly grounded in the SEW diagnostic-chain warning.
- Permission for production with one of two required retaining elements failed: **UNKNOWN** absent machine-specific safety concept.
- OpenPressBrake physical dual-retaining implementation: **UNKNOWN / TEST-CONFIRMED none**.
- Community evidence: **COMMUNITY-REPORTED none used**.

## Next evidence target

Seek a professional implementation/manual that explicitly defines the **reaction after one of two required retaining elements fails proof**: safety latch/inhibit, whether/how the hazardous load is physically secured, repair prerequisites, individual re-proof of the repaired element, proof/status of the companion element, restoration of final-element authority, and separate ordinary production START. Prefer a complete machine or safety-function manual over another generic brake product page.

No simulation, build, synthesis, benchmark, test suite, or GitHub-hosted Actions compute was justified or used.