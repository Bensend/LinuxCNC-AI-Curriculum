# 4400-OUT-01 — A safety fault bit can coexist with an energized load
**4000 safety module; 2026-10-25; NON-GRADUATED; no physical tests.** Original [Rockwell output-side SA+ cross-circuit source audit](../research/4400_ROCKWELL_POINTMAX_SAFETY_OUTPUT_SA_BACKFEED_DETECTED_NOT_SAFE_OEM_AUDIT_2026-10-25.md). Companion [PULSE-01 input-side diagnostic limitation](4400_PULSE_01_DUAL_CHANNEL_TEST_SOURCE_IDENTITY_AND_CROSS_FAULT_MODULE_2026-10-25.md).

## Learning outcome
Explain why a safety-rated output's OFF command or detected wiring fault does **not** guarantee physical energy removal, and specify how a machine builder must verify the entire protective-stop function including independent final elements and hydraulic/gravity hazards.

## OEM-confirmed counterexample
The Rockwell **5034-OB8S/XT** manufacturer wiring page expressly warns that an external cross-circuit from **SA+** to safety output **SO_n** can prevent the load from shutting down **even while the module detects the fault and raises its fault bit**. This is a particular product/fault topology, not a universal assertion that every safety output behaves identically.

**Safety signal chain:**
1. A guard/E-stop creates a demand.
2. Qualified safety logic requests OFF.
3. Output electronics may detect a field fault.
4. **External wiring must actually cease supplying the load** (not established by steps 1–3).
5. The independent final element must actually remove hazardous force or prevent hazardous motion.
6. Press-brake ram Y1/Y2 must actually stop and remain held despite gravity, trapped pressure and foreseeable faults.
7. Restart requires safe-zone clearance, restored protection, deliberate reset and a **new** ordinary motion request.

An HMI or ordinary LinuxCNC/FPGA signal may **observe** status, not replace independent safety authority. An output-side backfeed and an input-side shared-test-source short are **different** failures requiring different countermeasures.

## Practical technician decision table
| Observation | What it proves | What it cannot prove |
|---|---|---|
| LinuxCNC says STOP | Ordinary stop request/status | Physical energy removed |
| Safety output commanded OFF | Command state | Output wire has no external SA+ bypass |
| Safety module shows fault | Some fault detected | Load actually de-energized |
| Contactor mirror feedback changes | A specified contactor relation | Hydraulic Y1/Y2 hold |
| Hydraulic coil measured OFF | That measured electrical state | Spool closed, pressure isolated or beam held |
| Qualified physical stop/hold verification | Only its defined tested conditions | All untested failures or configurations |

## Ten paper-only cases (UNSCORED)
For each case identify **DOC-CONFIRMED / INFERENCE / UNKNOWN**, the missing physical witness, and a nonhazardous next action:
1. A 5034-OB8S detects SA+ to SO0 cross-circuit while load remains ON.
2. Two independent output channels are tied to a single unmonitored contactor.
3. Output mode is changed from pulse-tested to ordinary mode to stop nuisance faults.
4. Installer quotes module's PL e ceiling as the entire machine's rating.
5. Controller reports a stuck-high output while LinuxCNC continues to display E-stop.
6. A 24 V cable is crushed against the output cable in a common tray.
7. A cabinet technician proposes a temporary output-to-load jumper.
8. Safety output is OFF, but a directional hydraulic valve sticks.
9. Contactor is open, but the ram lowers due to trapped/redirected pressure.
10. A repaired output fault clears; the operator's old start request remains asserted.

## Safe, low-friction design practice
Provide labeled **SA+ / SO / load / return** terminals and a drawing revision at the cabinet, protected wiring paths, qualified monitored final elements, easy replacement instructions and a no-jumper restoration check. If a safeguard regularly trips because of bad routing or wiring, fix that cause; defeating diagnostics is not a sustainable convenience feature.

## G0 documentary gate (NOT RUN)
Record the exact output module, version, mode, permitted pairing, as-built load supply/return paths, potential positive bridges, fault monitoring, independent final-element architecture, selected hydraulic physical stop/hold evidence, access/guarding and fresh rearm. For every item retain a qualified reviewer and evidence ID **outside this public repo**; publish status only. Any safety-critical UNKNOWN means **HOLD**. No live cross-short injection, no people-exposed operation, no simulated PL/SIL claims.

## Graduation gate
A fresh learner must solve an **unseen** output-backfeed/final-element scenario using a newly supplied exact OEM manual and an information-separated evaluator. **No external score, selected-machine physical validation, or runtime TEST-CONFIRMED evidence exists.** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED; no safety release.
