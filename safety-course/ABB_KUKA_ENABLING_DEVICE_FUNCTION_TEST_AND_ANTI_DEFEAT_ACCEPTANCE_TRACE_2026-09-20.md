# ABB/KUKA enabling-device function-test and anti-defeat acceptance trace

Date: 2026-09-20

## Question

The active checkpoint asks for manufacturer/OEM acceptance evidence stronger than catalog architecture: does a professional procedure deliberately exercise a three-position enabling device and define pass/fail behavior, and what physical anti-defeat checks belong beside that functional test?

## Evidence

### ABB IRC5 product manual — explicit function test

**DOC-CONFIRMED.** ABB `Product manual - IRC5`, document `3HAC047136-001`, Revision AA (2023), section `3.5.4 Function test of three-position enabling device`, provides a named maintenance function test rather than only a device description.

The procedure:

1. starts the robot system and selects manual mode;
2. presses and holds the three-position enabling device in its middle position;
3. defines PASS as event `10011 Motors ON state` appearing, and FAIL if that event does not appear or event `90224 Enabling Device conflict` appears;
4. while continuing to hold the device, presses harder into position 3;
5. defines PASS for that challenge as event `10012 Safety guard stop state`, and FAIL if that event does not appear or the enabling-device conflict event appears.

Source: ABB, `Product manual - IRC5`, 3HAC047136-001 Rev AA, §3.5.4, p.214. Search-accessible official PDF: https://library.e.abb.com/public/1f3af42176c54f899b51d6a14d0472f1/3HAC047136%20PM%20IRC5-en.pdf

This is stronger evidence than an architecture diagram because the manufacturer instructs maintenance personnel to physically challenge the real device and gives explicit observed pass/fail states.

### Rockwell GripSwitch — 3 -> 2 non-reactivation behavior

**DOC-CONFIRMED.** Rockwell application note `SAFETY-AT016A-EN-P`, *GripSwitch (Enabling Switch) Applications with Monitoring Safety Relays*, states that the three-position trigger closes its safety contacts in the center position, opens them on release or further squeeze, and that release from the fully squeezed position does **not** close the safety contacts. The same note identifies reduced-performance tasks such as troubleshooting, calibration and adjustment as typical enabling-device uses and requires risk assessment for the reduced-performance condition.

Source: Rockwell Automation, `SAFETY-AT016A-EN-P`: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at016_-en-p.pdf

This supports the existing curriculum rule that position 3 -> position 2 must not be treated as a fresh enabling action for this implementation.

### KUKA Sunrise Cabinet Med — physical anti-defeat inspection

**DOC-CONFIRMED.** KUKA documents the enabling switch as a three-state device for T1/T2/CRR. Releasing all enabling switches held in center position or fully pressing one produces Safety Stop 1. More importantly for acceptance/human factors, KUKA warns against tape or other manipulation holding the enabling switch and explicitly instructs a **visual inspection of the enabling switches**, with tampering/foreign bodies to be removed or corrected.

Source: KUKA, `KUKA Sunrise Cabinet Med`, issued 2021-11-26, enabling-device section: https://www.kuka.com/-/media/kuka-downloads/manual-upload/kuka-sunrise-cabinet-med/kuka_sunrise_cabinet_med_en.pdf

KUKA also documents a non-obvious multiple-device hazard: if several enabling switches are simultaneously held in the center position, releasing only one does not cause the stop reaction. This is implementation-specific and must not be generalized into a universal enabling-device rule.

## Evidence reconciliation

The three sources establish complementary layers:

- ABB supplies an explicit installed-device functional test with defined PASS/FAIL observations for center and full-squeeze states.
- Rockwell supplies explicit non-reactivation behavior for the full-squeeze -> center return in its GripSwitch implementation.
- KUKA supplies a physical anti-defeat inspection requirement and exposes the multiple-enabling-device release hazard in its implementation.

No inspected source in this bounded search provides the entire requested all-in-one sequence: held jog/inch -> release challenge -> full-squeeze challenge -> 3->2 non-reactivation challenge -> setup exit -> ordinary safeguard restoration/requalification -> stale-command rejection -> fresh production START.

Therefore the all-in-one chain remains **UNKNOWN** rather than being synthesized as manufacturer fact.

## Curriculum freezes

**ENABLING DEVICE PRESENT != ENABLING DEVICE FUNCTIONALLY TESTED.**

**MIDDLE POSITION DETECTED != POSITION-3 STOP RESPONSE TESTED.**

**POSITION 3 RELEASED TOWARD POSITION 2 != FRESH ENABLE AUTHORITY** for implementations such as the documented Rockwell GripSwitch.

**FUNCTIONAL LOGIC TEST PASSED != DEVICE PHYSICALLY FREE OF TAPE/JAM/FOREIGN-BODY DEFEAT.**

**ONE ENABLING DEVICE RELEASED != STOP DEMAND** in architectures that permit multiple simultaneous enabling devices and explicitly require all center-held devices to be released.

## Practical commissioning contract derived from the evidence

The following is **INFERENCE** for curriculum use, not a claim that one manufacturer publishes this exact combined checklist:

1. visually inspect the enabling device for tape, wedges, binding, foreign bodies or other defeat;
2. select the intended restricted/setup mode;
3. challenge position 1, center position and position 3 individually;
4. observe the safety-system/final-element response required by the machine design, not merely an HMI icon;
5. explicitly challenge 3 -> 2 return semantics when the selected device architecture requires release to position 1 before re-enable;
6. if multiple enabling devices exist, test their interaction rather than assuming one-device semantics;
7. after any failed challenge, inhibit production return until the root cause is corrected and the relevant function test is repeated;
8. separately requalify ordinary safeguards and fresh-start/restart behavior before production authority.

The machine-specific stop category, stopping distance, reduced speed, final elements, reset semantics, required PL/SIL and test interval remain **UNKNOWN** until established for the actual machine architecture.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC/HAL or a normal FPGA may display mode, enabling-device and stop-state diagnostics, but this evidence does not transfer personnel-safety authority into ordinary control software. The independent safety implementation must own the safety function and its physical final elements. A LinuxCNC status bit is not a substitute for the installed-device function test or physical anti-defeat inspection.

## Information-gain decision

The narrow search for a single manufacturer all-in-one enabling-device acceptance chain is now **information-gain limited**. ABB materially improves the course by supplying a real functional test, but it still does not close setup-exit/safeguard-restoration/stale-command/fresh-production-start in one sequence. Future work should reopen this exact branch only for a genuinely stronger OEM acceptance checklist.

The next useful safety branch should therefore rotate away from generic enabling-device catalog/manual searching.
