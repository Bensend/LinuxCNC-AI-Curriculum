# EDM, forcibly-guided contactor weld detection, and restart-inhibit boundary

Date: 2026-09-19

## Question

What does professional safety hardware actually prove when it monitors external contactors, and what must remain separate before hazardous motion can be re-authorized?

## DOC-CONFIRMED evidence — Omron forcibly guided contacts

Omron's current safety-use guidance for relays with forcibly guided contacts makes an important architectural distinction. Forcibly guided contacts do **not** themselves prevent a relay malfunction or guarantee that hazardous power is interrupted. Their mechanical contact relationship allows another circuit to detect a welded-contact or related abnormal state. Omron explicitly warns that a welded relay can, depending on circuit configuration, leave power uninterrupted and potentially dangerous.

Omron therefore recommends redundancy plus self-monitoring so that a weld or similar malfunction can be detected and restart prevented until the problem has been eliminated.

This is strong evidence against treating an auxiliary NC contact or an EDM bit as proof that hazardous energy has disappeared.

## DOC-CONFIRMED evidence — Omron G9SA application architecture

Omron's G9SA safety-relay documentation includes a two-channel light-curtain/manual-reset example in which motor power is switched through redundant magnetic contactors KM1/KM2 and their feedback contacts are returned through the safety relay feedback loop. The application description says motor power is turned off when the beam is blocked and kept off until the beam is clear and the reset switch is operated.

This exposes distinct layers:

`protective-device state -> safety relay -> contactor coils -> contactor main poles -> motor-power path`

with a separate feedback path:

`contactor auxiliary/feedback contacts -> safety relay feedback loop`

The feedback loop observes the expected external-device state for restart logic; it is not the same electrical path as the contactor main power poles.

## DOC-CONFIRMED cross-check — Schneider Preventa XPS-ATR

Schneider's XPS-ATR safety-relay instruction sheet independently documents manual or automatic start together with monitoring of the feedback loop of external contactors. This supports the general professional architecture in which reset/start handling and external-device monitoring are separate functions that are composed by the safety circuit.

The same manufacturer documents drive-system E-stop examples with a dedicated safety relay, external E-stop chain, and a separate manual-reset input when that mode is selected. This does not establish one universal reset policy; it confirms that the chosen safety application must deliberately define it.

## Frozen authority boundaries

`SAFETY OUTPUT OFF != CONTACTOR COIL DE-ENERGIZED != CONTACTOR MAIN POLES OPEN != HAZARDOUS POWER REMOVED != PHYSICAL HAZARD SAFE`

`FORCIBLY GUIDED CONTACTS != FAULT PREVENTION`

`EDM / FEEDBACK LOOP HEALTHY != PHYSICAL STOP PERFORMANCE PROVED`

`RESET REQUEST != EDM VALID != SAFETY OUTPUT RE-ENERGIZED != ORDINARY MOTION AUTHORITY`

A feedback loop can support detection of an external switching-device failure and inhibit restart. It cannot, by itself, prove that every hazardous energy path is absent, that a motor/ram/load has stopped, that stored energy is discharged, or that personnel are clear.

## Failure-path worksheet

A commissioning or maintenance validation should deliberately reason through at least these cases when applicable:

1. **One contactor main pole welded closed.** Does the monitored auxiliary state expose the failure and prevent safety re-enable/restart?
2. **Contactor coil de-energizes but hazardous power remains through a welded main pole.** Do diagnostics distinguish commanded state from physical power isolation?
3. **Feedback contact or feedback wiring is stuck in the healthy-looking state.** What independent evidence, test, redundancy, or periodic proof prevents this latent fault from becoming trusted truth?
4. **One of two redundant contactors fails while the companion opens normally.** Can the healthy element mask the failed element during functional testing?
5. **Reset is pressed while the feedback loop is inconsistent.** Safety authority should remain absent according to the validated device/application rather than reset becoming a bypass.
6. **Power is restored after a diagnosed external-device fault.** Power cycling is not repair; determine the manufacturer's required fault-clearing/recommission path.
7. **LinuxCNC/HAL reports MACHINE ON while the independent safety circuit withholds external-device authority.** Ordinary control must not override the safety-side inhibit.
8. **EDM becomes healthy after service while stale START/JOG/CYCLE remains asserted.** The application-specific ordinary-command policy must prevent an unintended hazardous restart.
9. **EDM is healthy but the physical machine still moves or hazardous energy remains.** Treat this as decisive evidence that EDM is only one layer of proof.

## Practical architecture lesson for LinuxCNC/OpenPressBrake

LinuxCNC, ordinary FPGA logic, and the HMI may consume diagnostic states such as `CONTACTOR_FEEDBACK_OK`, but they must not manufacture personnel-safety authority from those bits. The independent safety function owns the safety-output/feedback-loop decision where EDM is credited.

For teaching and HMI diagnostics, keep at least these claims separate:

- safety demand present/cleared;
- safety output commanded state;
- external-device coil command;
- EDM/auxiliary feedback state;
- physical hazardous-power state where independently witnessed;
- physical motion/load/pressure state where relevant;
- safety fault/rearm state;
- ordinary LinuxCNC motion request.

This separation makes a welded contactor understandable instead of collapsing it into a misleading single `SAFE` lamp.

## Provenance labels

- **DOC-CONFIRMED:** Omron forcibly-guided-contact guidance states that the guided structure enables detection of a weld/malfunction but does not itself prevent malfunction or necessarily interrupt power; redundancy/self-monitoring is used to prevent restart until the fault is eliminated.
- **DOC-CONFIRMED:** Omron G9SA application documentation exposes redundant magnetic contactors, feedback loop, protective-device trip, and manual reset as separate elements.
- **DOC-CONFIRMED:** Schneider XPS-ATR documentation supports external-contactor feedback-loop monitoring with selectable manual/automatic start architecture.
- **INFERENCE:** For an OpenPressBrake implementation, separate diagnostic presentation of command, EDM, physical energy and motion states would improve commissioning and fault localization without transferring safety authority to LinuxCNC.
- **UNKNOWN:** Exact OpenPressBrake contactor topology, number of power-isolation elements, feedback-contact implementation, reset policy, proof-test interval, PL/SIL/category/DC/CCF, physical stop behavior, and whether contactors are credited for any specific hazard.
- **TEST-CONFIRMED:** none in this study.
- **SOURCE-CONFIRMED:** none from LinuxCNC/OpenPressBrake source code in this study; this is manufacturer-documentation evidence.
- **COMMUNITY-REPORTED:** none relied upon.

## Non-transfer rules

Do not infer a required number of contactors, a specific contactor family, reset behavior, diagnostic coverage, switching time, stopping distance, or performance level from these examples. Do not treat EDM as proof of hydraulic safe state, gravity-load retention, pneumatic exhaustion, or personnel clear. Those require their own architecture and evidence.

## Next Lane-B checkpoint

Find a complete professional implementation or manufacturer validation procedure exposing:

`protective demand -> safety output OFF -> redundant external switching elements -> individual/meaningful feedback -> deliberate welded/stuck-device fault -> restart inhibited -> repair/replacement -> feedback/function re-proof -> physical hazardous-energy or motion witness -> safety rearm -> application-specific ordinary production command`.

Prefer an example that explicitly tests a welded contactor or feedback fault and makes clear what evidence is required after replacement before return to service.

## Sources

- Omron Industrial Automation, “Safety use of Safety Relays with Forcibly Guided Contacts,” current manufacturer guidance accessed 2026-09-19.
- Omron G9SA Safety Relay Unit datasheet/application example, manufacturer documentation accessed 2026-09-19.
- Schneider Electric Preventa XPS-ATR instruction sheet, safety relay for E-stop/protective-guard applications, manufacturer documentation accessed 2026-09-19.