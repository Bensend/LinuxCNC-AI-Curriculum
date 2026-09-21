# Board-design curriculum checkpoint — BD16

Date: 2026-09-21
Lane: independent LinuxCNC/OpenPressBrake board-design curriculum

## Completed

Created `hardware/4000-board-design/BD16_FPGA_RESOURCE_AGGREGATION_EXECUTABLE_FIT.md` at commit `318585a245c817a3c65899162b12dee31928be49`.

BD16 teaches:

`block resource contract -> board instance count -> semantic resource allocation -> package/bank/pin plan -> LUT/FF/BRAM/PLL/clock/bus aggregation -> arithmetic headroom -> exact configured image -> synthesis -> place-and-route -> timing -> evidence binding -> regression trigger`

## Student-facing verification

Current OpenPressBrake main artifacts opened directly during the run:

- `hardware/blocks/fpga_core_ecp5_25/manifest.yaml`
- `hardware/blocks/fpga_core_ecp5_25/STATUS_CHECKLIST.md`
- `hardware/integration/REV1_FPGA_CORE_RECONCILIATION.md`
- `hardware/integration/REV1_BOARD_INTEGRATION_RECONCILIATION.yaml`

They are `VERIFIED_FOR_LESSON` only for the bounded claims used by BD16: current ECP5-25 architecture/resource planning, exact current FPGA-core maturity, current board/core precedence, current proportional serial-resource architecture, retained real-image utilization, and the known under-constrained timing-evidence failure.

They remain `INCOMPLETE_NOT_STUDENT_MATERIAL` if presented as proof that the complete OpenPressBrake controller or FPGA core is released. Exact Rev46 timing, routed interface qualification, final power/current/thermal work, schematic review and Rev-1 release remain open.

## Adversarial findings

1. “Does it fit?” must be decomposed into semantic, package, bank/electrical, logic, and routed/timing fit.
2. Scalar GPIO headroom does not prove a usable legal package ball exists.
3. Resource demand belongs in reusable block contracts; exact package assignment belongs to board integration.
4. Arithmetic LUT/FF/BRAM headroom is planning evidence, not synthesized utilization.
5. A packed bitstream proves more than a spreadsheet but still does not prove timing closure.
6. Timing evidence is inseparable from its constraint set. Run `34904495381` reached 40.08-MHz sys Fmax while targeting only 12 MHz, so the repository correctly rejects it as final 40-MHz timing proof.
7. Current OpenPressBrake status retains real-image utilization of 141/197 IO, 4/56 DP16KD, 7338/24288 FF and 17717/24288 COMB for the corresponding image; that evidence is revision-bounded, not a timeless device-capacity claim.
8. Stale proportional PWM/ADS7953 resource assumptions must not re-enter board allocation after the MAX22216 shared-SPI architecture change.
9. Resource evidence should eventually carry machine-readable invalidation edges from block contract and configured-image changes.

## Durable freezes

- `RESOURCE ARITHMETIC IS A PLANNING GATE; THE CURRENT EXACT IMAGE IS THE FIT/TIMING AUTHORITY`.
- `PIN COUNT FIT != LEGAL PACKAGE/BANK FIT != LOGIC FIT != TIMING CLOSURE`.
- `UNUSED GPIO != USABLE GPIO`.
- `ARITHMETIC HEADROOM != SYNTHESIZED HEADROOM`.
- `SYNTHESIS PASS != PLACE/ROUTE PASS != TIMING PASS`.
- `PACKED BITSTREAM != TIMING CLOSURE`.
- `MEASURED FMAX ABOVE INTENDED FREQUENCY != TIMING CLOSURE WHEN THE INTENDED CONSTRAINT WAS NOT APPLIED`.
- `OLD COMPLETE RESOURCE TABLE != CURRENT AUTHORITY`.
- `BOARD PACKAGE ALLOCATION DOES NOT BELONG INSIDE A REUSABLE FUNCTIONAL BLOCK`.
- `FPGA FAULT CONTAINMENT != PERSONNEL-SAFETY AUTHORITY`.

## OpenPressBrake interaction

No OpenPressBrake files were modified. Immediately before this checkpoint, OpenPressBrake `main` remained `fee290c8385638aa5b2601f332981edd800d2b48` (`integration: reconcile board authority through machine power Rev16`). The curriculum therefore consumed current engineering read-only and did not overlap active machine-power/integration work.

No new executable verification was justified. Existing repository evidence already supplies both a real-image fit result and an explicitly insufficient timing result. No GitHub-hosted compute was used. Future synthesis/place-and-route/timing work remains restricted to `[self-hosted, openpressbrake]`.

## Exact next work — BD17

Build **startup, default, reset, partial-power and de-energized-state contracts**.

Start by re-reading current main in both repositories and current board-design governance/checkpoints. Open every student-facing OpenPressBrake artifact directly.

Teach and adversarially test:

`power absent -> partial rails -> reset asserted -> configuration -> configured but inhibited -> enabled -> watchdog/fault -> brownout -> recovery -> power-down`

For representative reusable input/output/driver/core blocks, require explicit answers for:

- field power present while logic power is absent;
- logic power present while field power is absent;
- FPGA unconfigured/configuration failed;
- reset asserted/released;
- watchdog timeout;
- output-enable absent;
- brownout and rail sequencing;
- connector hot-plug/unpowered-input behavior;
- default pull/bias ownership;
- back-power paths;
- whether any machine load can energize before explicit authority.

Treat every behavior that requires tribal knowledge as a block-catalog defect. Keep ordinary-control containment separate from independent personnel-safety authority. If executable verification is genuinely required, use only `[self-hosted, openpressbrake]`; otherwise preserve unverified physical behavior as an open qualification gate.