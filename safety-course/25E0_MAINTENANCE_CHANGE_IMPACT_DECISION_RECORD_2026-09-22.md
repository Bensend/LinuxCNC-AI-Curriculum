# 25E0 — Maintenance / change impact decision record

Use this record **before work begins**, not only during return to production. Its purpose is to make the safe workflow easier: a technician should know what evidence will be invalidated and what revalidation will be required before disassembly, forcing, simulation, rewiring or parameter changes begin.

## A. Planned change
- machine / safety-function identifier:
- work order / reason:
- components, wiring, software, parameters or plumbing expected to change:
- temporary forces, simulations, jumpers, overrides or alternate modes expected:
- person responsible for work:
- person/role with acceptance authority:

## B. Pre-change evidence snapshot
For each affected safety function record the accepted configuration identity and the propositions currently relied upon. Do not record only green diagnostics.

| Proposition relied upon | Current witness/evidence | Evidence class | Will change make it stale? | Why? |
|---|---|---|---|---|
| input corresponds to real protective-device state | | | | |
| final element reaches required physical state | | | | |
| process reaches required safe response | | | | |
| stopping/holding performance meets machine criterion | | | | |
| safety configuration/hardware identity is accepted | | | | |
| exceptional states are absent | | | | |

## C. Change-impact decision
For every `YES`, name the required re-proof **before work starts**.

`planned change -> stale proposition -> re-proof method -> acceptance criterion/source -> acceptance authority -> record to retain`

If the criterion is unknown, write `UNKNOWN`. Do not substitute a convenient diagnostic. A safety-critical UNKNOWN blocks the dependent production-return claim.

## D. Temporary-state control
Record every force, simulation, jumper, bypass, defeated guard, commissioning mode or temporary parameter separately.

| Temporary state | Why needed | What real evidence it suppresses/substitutes | Positive clearance method | Required real-field re-test |
|---|---|---|---|---|
| | | | | |

`disabled` and `not currently selected` do not automatically mean `removed`. Use the platform's actual lifecycle semantics.

## E. Post-work revalidation
Keep evidence classes separate.

- component diagnostics/health:
- physical witness correspondence:
- final-element physical response:
- process response:
- stopping/holding performance where applicable:
- configuration/checksum/version identity:
- fault-injection or discrepancy tests required:
- all temporary states positively cleared:
- documentation/acceptance report updated:

## F. Production re-entry
- safety function accepted by named authority: YES / NO / UNKNOWN
- guards/access state restored and physically checked: YES / NO / UNKNOWN
- reset/rearm performed under the machine's validated semantics: YES / NO / UNKNOWN
- ordinary Start/Cycle/Jog demand released and fresh-demand rule satisfied: YES / NO / UNKNOWN
- residual risk / restrictions:

Any safety-critical `NO` or `UNKNOWN` blocks normal production. If the minimum safe-to-operate threshold cannot be met, do not operate with people exposed to the hazard; any justified experiment must be isolated/remote with people outside the danger zone.

## Adversarial composition exercise
A servo machine receives a replacement safety encoder and replacement guard switch during the same maintenance window. The encoder and guard switch each report healthy after installation. The drive safety checksum matches the saved project. The guard input toggles correctly on the diagnostic screen. A simulated speed witness used during commissioning is now disabled. E-stop appears to stop the machine normally. Cycle Start remained held from before maintenance.

Learner task: decide whether production return is acceptable and construct the minimum impact-based revalidation record without inventing a safe speed, stopping distance, PL/SIL or vendor-specific test.

Expected reasoning boundary:
- encoder health/checksum does not prove calibration, direction or actual-value acquisition;
- guard input toggling does not by itself prove the complete protective-device-to-safe-response function or relevant fault behavior;
- two individually healthy replacement components do not prove the **composed** machine safety function;
- simulation disabled does not prove authentic field evidence until positive clearance and real-field testing are complete;
- observed E-stop behavior is evidence for the tested E-stop scenario, not automatically for every guard/safe-speed function affected by the maintenance;
- a held ordinary demand must not gain production authority merely because safety eligibility is restored.

This exercise intentionally has no universal numeric acceptance criteria. The correct answer is an evidence/authority structure, not a guessed threshold.
