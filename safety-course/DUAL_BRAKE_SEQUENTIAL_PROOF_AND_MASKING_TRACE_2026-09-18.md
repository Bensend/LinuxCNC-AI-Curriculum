# Dual-brake sequential proof and masking trace — 2026-09-18

Session start: 2026-09-18T12:38:24Z

## Scope

Continue the gravity-axis retaining-function branch with authoritative evidence about two brakes on one axis: how each brake is proved, how the companion brake can mask a defect, and what may be claimed after only one proof succeeds.

Evidence labels: SOURCE-CONFIRMED, DOC-CONFIRMED, TEST-CONFIRMED, COMMUNITY-REPORTED, INFERENCE, UNKNOWN.

## Professional evidence

### SEW-EURODRIVE MOVISAFE safe brake test

**DOC-CONFIRMED.** Current SEW documentation allows both safe digital outputs to be assigned SBC. In ordinary functional control the two brakes are controlled together, but during the safe brake test they are controlled separately. F-DO00 is tested first; only when that test is free of irregularities does the sequence automatically repeat for F-DO01.

**DOC-CONFIRMED.** SEW's passive gravity/load-torque test makes the isolation requirement physical: when two brakes are tested, one brake is tested while the second brake remains released, then the roles reverse. STO is active during this passive stage so the drive cannot provide motor torque; movement is monitored against the permitted test range.

**DOC-CONFIRMED.** SEW warns that an active brake test itself can cause unintended machine movement. No person may be in the danger area during the test, and a hoist mechanism must be designed for a possible fall (for example by suitable buffers) and tested at an appropriate machine position.

### Kollmorgen AKD2G SBT/SBC

**DOC-CONFIRMED.** Kollmorgen permits two brakes on one axis and gives each an independent slippage tolerance. Its SBT guidance requires each mechanically coupled brake to be tested independently. Other motors/brakes coupled to the axis must be placed so they do not impede motion of the brake under test.

**DOC-CONFIRMED.** Kollmorgen states that after a failed brake test safe brake operation can no longer be assumed and brake replacement or service is necessary. It also requires SBT after brake service/replacement and at other defined lifecycle points.

This is strong evidence against treating `Brake A PASS` as proof of `Brake B`, or letting the companion brake mechanically hide a failed brake during proof.

## Frozen evidence/authority rules

**BRAKE A TEST REQUEST != BRAKE A ISOLATED PROOF CONDITION != BRAKE A PASS != BRAKE B PROOF.**

**BRAKE A PASS + BRAKE B UNTESTED/FAIL/UNKNOWN != DUAL-BRAKE PROOF COMPLETE.**

**COMPANION BRAKE HOLDING THE AXIS DURING BRAKE A TEST CAN MASK BRAKE A FAILURE.**

Where the validated machine safety concept requires both brakes, production authority is not established until both required proofs have succeeded under valid independent test conditions.

A successful first test is therefore only an intermediate state in a two-brake proof sequence. It must not be surfaced to ordinary LinuxCNC/HAL logic as `machine retaining system proved`.

## Failure-path model

For a required two-brake architecture, teach and commission the following conservative chain:

`PROOF REQUEST -> TEST-SAFE MACHINE POSITION / PEOPLE CLEAR -> isolate Brake A proof condition -> A PASS -> isolate Brake B proof condition -> B PASS -> composite retaining proof eligible -> safety authority eligible -> fresh ordinary START`.

If either proof fails:

`A/B FAIL -> composite proof invalid -> safety fault/inhibit -> physical load-safe disposition -> repair/service -> independent re-proof of serviced brake -> verify companion proof remains valid/current as required by the machine safety concept -> safety authority -> fresh ordinary START`.

The exact fault latch, test interval, proof-validity lifetime, and whether the unaffected brake must always be immediately retested after companion repair remain **UNKNOWN** unless specified by the machine's validated safety concept.

## Adversarial commissioning card

1. Hold Brake A closed while testing Brake B. Confirm that the test procedure does not permit A to mask B's inability to hold.
2. Reverse the test and challenge Brake A independently.
3. Force A PASS then B FAIL. Confirm no composite `retaining system proved` or production permissive is emitted.
4. Force A PASS then make B proof unavailable. Treat the composite proof as incomplete, not degraded production authority, unless the validated machine design explicitly permits such a mode.
5. Fail B, acknowledge the diagnostic without service, and request production. Reject authority.
6. Service B and attempt restart without required SBT. Reject authority.
7. Service B, pass B, but use stale/expired/invalid A evidence. Reject composite proof until the machine-specific validity requirement is met.
8. Corrupt the common motion witness/encoder. Two reported PASS results do not establish two independent physical proofs when the shared witness cannot detect movement.
9. During an active SBT, keep personnel out of the gravity/fall danger zone and use the machine's validated test position/fall-mitigation provisions. The test intentionally challenges a retaining element and is not a personnel-access state.
10. Restore safety authority while LinuxCNC START/JOG/ENABLE remains asserted from before the test/fault. Require fresh ordinary intent.

## Common-cause lesson

Two physical brakes do not automatically create two independent diagnostic channels. Both proofs can share motion sensing, safety logic, supply domains, mechanics, parameterization, or installation errors. Separate brake actuation and separate test phases improve observability but do not prove common-cause independence by themselves.

Therefore freeze:

**TWO BRAKES != TWO INDEPENDENT PROOFS != COMMON-CAUSE ABSENCE.**

The commissioning record must identify shared witnesses and shared dependencies rather than counting components.

## LinuxCNC / FPGA boundary

LinuxCNC and the ordinary FPGA may display per-brake test state and may suppress normal motion until an independent safety permissive exists. They must not OR the two brake PASS bits, synthesize a composite PASS from axis-stationary feedback, or use a stale application command as restart intent after safety authority returns.

## OpenPressBrake unknowns preserved

Required number/type of retaining elements, actual hydraulic/mechanical topology, acceptable degraded modes, proof interval, proof-validity lifetime, proof torque/movement limits, common motion witness, reset sequence, physical test position/fall mitigation, and required post-repair companion retest remain **UNKNOWN** for OpenPressBrake until machine-specific evidence exists.

## Sources

- SEW-EURODRIVE, MOVISAFE CS..A safe brake system, 2026: safe F-DO assignment and sequential two-brake test; passive brake-test stage; static brake-test safety warnings.
- Kollmorgen AKD2G-S Safety Option documentation: SBT, SBC and motor-brake requirements; two brakes per axis, independent test requirement, failure/service disposition.

No simulation, build, synthesis, benchmark, test suite, or GitHub-hosted Actions compute was used. This question was resolved from authoritative manufacturer documentation.