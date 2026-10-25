# 4400-CHIP-01 — Auxiliary chip conveyor restart, reversal and safe cleanout
**2026-10-25 | 4400 SAFETY | NON-GRADUATED | PAPER ONLY**

## Learning objective
A learner must distinguish *stopped at this instant* from *incapable of hazardous restart*, identify conveyor discharge/auger/nip hazards outside the main CNC work envelope, and design a practical guarded cleanout/LOTO path that people will actually use. Start with the [original OEM and regulator audit](../research/4400_HAAS_CHIP_CONVEYOR_PERIODIC_RESTART_REVERSAL_AND_CLEANOUT_OEM_AUDIT_2026-10-25.md).

## The dangerous ordinary behavior
On documented Haas options, M31 starts conveyor automation. While a machining cycle runs, Settings 114 and 115 determine automatic restart intervals and on-times. The conveyor can stop between intervals and later restart; the OEM also advertises automatic reversal on jams. M33 or CHIP STOP is an ordinary operating command, not an energy-isolating device. A worker clearing chips from the discharge during a pause is exposed to exactly the event the ordinary program intends.

**Version caveat:** Haas M31/M33 are Haas machine conventions. LinuxCNC does not inherit this M-code mapping. A LinuxCNC build might implement auxiliary motion through HAL, custom M-codes, PLC or another controller; the actual implementation must be inspected. None is independent safety authority by default.

## Required four-layer architecture
1. **Ordinary process control:** CNC/PLC selects conveyor forward/reverse, timed cycle and diagnostics. It may know jam status but does not authorize a hand in the mechanism.
2. **Independent protective control:** selected guarding/interlock/stop function for actual access hazards, with qualified fault response and deliberate rearm.
3. **Physical final elements:** selected power isolation, braking/stop or immobilization appropriate to belt/auger/drive, verified against unexpected forward and reverse motion.
4. **Maintenance energy isolation:** qualified lockable disconnects for every relevant drive/auxiliary supply, verification at the work point and controls against mechanical stored energy or coasting. Stop pushbutton, M33 and CNC E-stop alone are not assumed sufficient.

## Hazard boundary and failure matrix
| Event | What the operator may see | Required safety question |
|---|---|---|
| Timed conveyor OFF between runs | Silent stationary belt | Is restart independently inhibited while a guard is open or a person is servicing? |
| Jam and auto-reverse | Conveyor stalls | Can reverse move unexpectedly and draw hands/tools into nip? |
| Door closed on CNC | 'Door safe' indication | Is the **external** chip discharge opening still reachable? |
| CHIP STOP or M33 | Belt stationary | Can another control, auxiliary supply, or restored cycle re-enable it? |
| Cleaning hatch open | Easy access to blockage | Does physical guard/isolator actually prevent both directions and stored motion? |
| Main machine isolated | CNC drives off | Is conveyor power separately supplied? Is it independently locked? |
| Power returns | HMI ready | Is deliberate new start required and are all guards installed? |

## Human factors
Do not design a cleanout guard that requires 20 loose screws or forces a worker to reach through the discharge. Use captive fasteners, service lighting, chip rake ports isolated from moving mechanisms, quick removable bins outside nip reach, guarded reverse diagnostics and a clearly identified personal lock point. Make safe cleanout faster than improvising a bypass.

## Verification and release
Complete the [14 PAPER technician cases](4400_CHIP_01_TECHNICIAN_DECISION_CARD_AND_BLANK_WITNESS_2026-10-25.md). Selected-machine proof requires actual guard geometry, stop/inhibit path, final-element witness, independent isolation, jam recovery, reset and post-maintenance restart evidence. No live testing authorized here. Independent evaluator/physical results remain UNKNOWN; no personnel-exposed operation where the hazard is not adequately controlled.

**Claim classes:** OEM/OSHA/HSE behavior DOC-CONFIRMED in source audit; four-layer design INFERENCE; selected machine/PL/SIL/timing UNKNOWN; no SOURCE-CONFIRMED new LinuxCNC code and no TEST-CONFIRMED result.
