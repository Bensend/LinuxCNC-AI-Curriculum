# Dual-channel discrepancy, cycling, and fault-recovery authority study

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Why this lane

Current main was re-read immediately before this write. The primary safety lane is advancing CINCINNATI AUTOFORM energized hydraulic commissioning/post-service evidence and guard-interlock defeat/human factors. Lane B's immediately preceding study covered test-pulse/cross-short diagnostics. This study advances a different but adjacent unresolved commissioning question: what the evaluator must do when two channels do not transition together, how cycling/requalification differs from simple bit agreement, and why discrepancy timing is an engineering parameter rather than a generic number.

No executable lab is justified for this source/documentation question. No GitHub-hosted or self-hosted compute is used.

## Core architecture lesson

A redundant input pair can be electrically healthy yet behaviorally invalid.

Freeze these distinctions:

`CHANNEL A HEALTHY + CHANNEL B HEALTHY != DUAL-CHANNEL TRANSITION VALID`.

`BOTH CHANNELS EVENTUALLY AGREE != DISCREPANCY TIME SATISFIED`.

`DISCREPANCY TIMER NOT EXPIRED != SAFETY FUNCTION PROVED CORRECT`.

`DISCREPANCY FAULT CLEARED != INPUT PAIR REQUALIFIED`.

`INPUTS CURRENTLY ACTIVE != REQUIRED ACTIVE-INACTIVE-ACTIVE CYCLING COMPLETED`.

`DUAL-CHANNEL STATUS VALID != FIELD DEVICE MECHANICALLY HEALTHY`.

`SAFETY INPUT REQUALIFIED != SAFETY OUTPUT/FINAL ELEMENT REQUALIFIED != FRESH ORDINARY START`.

## Source-grounded behavior

### Rockwell Guard I/O: discrepancy is transition-consistency monitoring

Rockwell Guard I/O documentation defines dual-channel equivalent/complementary evaluation and monitors the interval during which the two channels disagree. If disagreement lasts beyond the configured discrepancy time, the safety input data/status for the pair is driven off. Rockwell explicitly warns not to set discrepancy time longer than necessary; its purpose is to tolerate normal differences between contact switching when a demand occurs.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/1791es-um001_-en-p.pdf
Evidence: **DOC-CONFIRMED** manufacturer manual.

This supports:

`DISCREPANCY TIME = APPLICATION/DEVICE TRANSITION ALLOWANCE`, not a generic OpenPressBrake constant.

The numerical setting for any future OpenPressBrake safety input therefore remains **UNKNOWN** until the actual device, wiring, evaluator, required response and validation evidence are known.

### Rockwell: zero can mean monitoring disabled/infinite, not zero tolerance

Guard I/O documentation for another module family warns that a configured discrepancy time of 0 ms can mean the channels may remain discrepant indefinitely without a discrepancy fault. It separately describes a `cycle inputs` condition: if one channel performs active -> inactive -> active while the other remains active, evaluated status stays safe until the required cycling is completed even when no discrepancy fault is declared.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/1791ds-um001_-en-p.pdf
Evidence: **DOC-CONFIRMED** manufacturer manual.

This is a critical commissioning trap:

`PARAMETER DISPLAYED AS 0 ms != ZERO DISCREPANCY PERMITTED`.

Parameter semantics must be verified against the exact safety device/instruction documentation. Copying a number between products can silently change the diagnostic behavior.

### Rockwell safety instruction: restart/cold-start policy is separate

Rockwell's Dual Channel Input Stop with Test and Lock instruction exposes discrepancy time separately from restart type and cold-start type. Manual restart requires a reset transition after enabling conditions are met; automatic restart can energize after enabling conditions become valid, and Rockwell cautions that automatic restart is only appropriate where it cannot create an unsafe condition or reset is performed elsewhere. Cold-start behavior is separately configurable.

Source: https://www.rockwellautomation.com/en-pl/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/safety-instructions/dcstl.html
Evidence: **DOC-CONFIRMED** manufacturer documentation.

Therefore:

`CHANNELS VALID != RESET POLICY SATISFIED != COLD-START POLICY SATISFIED`.

A future LinuxCNC/HAL `ready` indication must not collapse these states.

### SICK: discrepancy begins at first transition; filtering is a separate timing layer

SICK UE440/UE470 documentation defines discrepancy time as the maximum interval in which a dual-channel pair may occupy impermissible states. Monitoring begins with the first input state change; if the required equivalent/complementary relationship has not been reached before expiry, the safety controller switches its OSSDs off and reports an error. SICK also documents input delay separately and notes that discrepancy evaluation starts only after configured filter time has expired.

Source: https://www.sick.com/media/docs/3/53/153/operating_instructions_ue440_ue470_compact_safety_controller_en_im0014153.pdf
Evidence: **DOC-CONFIRMED** manufacturer manual.

This freezes another important distinction:

`INPUT FILTER/DEBOUNCE != DISCREPANCY TIME`.

A filter can change when the evaluator recognizes the first transition, while discrepancy time governs allowed inter-channel mismatch after that recognized transition. Both must be accounted for in the validated safety response where applicable.

## Failure-path analysis

### F1 — Channel A moves; Channel B never follows

Expected architectural question: does the independent safety evaluator drive the function safe, diagnose the pair, and inhibit requalification until the documented recovery condition is satisfied?

Evidence basis: **DOC-CONFIRMED** behavior family from Rockwell/SICK. Exact OpenPressBrake behavior: **UNKNOWN**.

### F2 — Channel B follows, but too late

The eventual static state does not erase a prior timing violation. Commissioning must prove the evaluator's documented fault/recovery behavior rather than observing only that both bits finally match.

Evidence: **INFERENCE**, directly grounded in discrepancy-time monitoring semantics.

### F3 — One channel cycles while the companion stays asserted

This can require a complete input cycle/requalification even where the current states again appear valid. A stuck companion channel must not be made invisible by looking only at the final two-bit state.

Evidence: **DOC-CONFIRMED** for the cited Rockwell Guard I/O family; transfer to another device is **UNKNOWN** until its manual is checked.

### F4 — Both channels are already active at power-up/recovery

Do not infer permission from static agreement. Cold-start/test/restart behavior is evaluator-specific and must be explicitly configured/validated.

Evidence: **DOC-CONFIRMED** that Rockwell exposes separate cold-start behavior; exact OpenPressBrake requirement remains **UNKNOWN**.

### F5 — Excessive discrepancy time masks a degrading mechanism

A long discrepancy window can turn abnormal delayed switching into accepted operation. Rockwell's warning to avoid longer-than-necessary discrepancy time makes this a commissioning/design parameter, not merely nuisance-trip tuning.

Evidence: **DOC-CONFIRMED** warning plus **INFERENCE** for degradation review.

### F6 — Input filtering hides a transition long enough to alter total response

Filter/debounce can improve availability but must not be treated as free. SICK documents it as a separate timing layer. Where it affects the protective function, total safety response must account for the configured behavior according to the exact device/system documentation.

Evidence: **DOC-CONFIRMED** device behavior; machine-specific response calculation **UNKNOWN**.

## Commissioning worksheet

For each actual dual-channel safety device later selected, record rather than assume:

| Challenge | Required evidence |
|---|---|
| Normal demand/release | Both channel transitions and evaluated state |
| A first, B within allowed interval | Accepted transition per documented configuration |
| B first, A within allowed interval | Accepted transition per documented configuration |
| A changes, B does not | Safe response + diagnostic/fault behavior |
| B changes, A does not | Safe response + diagnostic/fault behavior |
| Companion follows after allowed interval | Prior violation is not silently erased |
| One channel active->inactive->active while companion stays active | Documented cycle/requalification behavior |
| Pair active at power-up | Documented cold-start behavior |
| Pair becomes valid after input-status fault | Documented restart/requalification behavior |
| Reset held continuously | Prove reset semantics; no assumed fresh edge |
| Filter/debounce configured | Record value and timing consequence |
| Discrepancy configured as zero | Verify exact product semantics; never infer `zero tolerance` |
| Parameter changed/replacement device loaded | Revalidate configuration and functional challenges |
| Safety input becomes valid while LinuxCNC START/JOG/CYCLE is stale | No stale ordinary command becomes fresh motion authority |

Do not perform destructive fault insertion on a live hazardous machine merely to satisfy this worksheet. Use the manufacturer's approved commissioning method, safe bench/test arrangement, or a controlled machine validation procedure appropriate to the hazard.

## LinuxCNC / FPGA boundary

Ordinary LinuxCNC/HAL/FPGA may expose useful diagnostics:

- channel A/B state;
- pair evaluated state;
- discrepancy fault;
- input-cycle required;
- reset required;
- safety-ready summary.

But freeze:

`HAL A == HAL B != SAFETY DUAL-CHANNEL VALID`.

`FPGA TIMER SAYS CHANNELS MATCHED IN TIME != VALIDATED PERSONNEL-SAFETY EVALUATOR` unless the FPGA path itself is intentionally designed, developed and validated as the safety function.

`SAFETY READY DISPLAYED != FRESH LINUXCNC MOTION REQUEST`.

The ordinary controller can help a technician diagnose why the safety system refuses rearm. It should not silently synthesize the missing personnel-safety authority.

## Evidence classification

- Manufacturer-described discrepancy semantics: **DOC-CONFIRMED**.
- Manufacturer-described cycle-input/restart/cold-start behavior for the cited Rockwell families: **DOC-CONFIRMED**.
- Manufacturer-described SICK filter/discrepancy interaction: **DOC-CONFIRMED**.
- OpenPressBrake device selection/configuration/timing: **UNKNOWN**.
- Any exact machine response time, safety distance, PL/SIL/category/DC/CCF implication: **UNKNOWN** until the actual architecture is designed and validated.
- No **TEST-CONFIRMED** OpenPressBrake result is claimed here.
- No **COMMUNITY-REPORTED** claim is needed for this study.

## Precise next work

Seek a complete professional commissioning/fault-insertion example for one dual-channel guard/E-stop/enabling device that exposes:

`PHYSICAL DEVICE -> CHANNEL A/B -> FILTER/TEST CONFIGURATION -> DISCREPANCY EVALUATION -> DELIBERATE ONE-CHANNEL LATE/STUCK CHALLENGE -> FAULT -> REQUIRED INPUT CYCLING -> RESET/REQUALIFICATION -> SAFETY OUTPUT -> ACTUAL FINAL ELEMENT -> PHYSICAL HAZARD WITNESS -> FRESH ORDINARY START`.

Prefer a manufacturer example with wiring diagram, explicit discrepancy/cycling behavior, and commissioning test table. Keep this lane separate from the primary hydraulic evidence package and from the already-completed test-pulse/cross-short study.
