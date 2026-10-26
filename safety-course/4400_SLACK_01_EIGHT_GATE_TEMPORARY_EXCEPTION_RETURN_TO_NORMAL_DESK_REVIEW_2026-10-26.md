# 4400-SLACK-01 — Eight-gate temporary-exception return-to-normal documentary review

**2026-10-26 | BLANK / NOT EXECUTED / NOT A LIVE TEST PROCEDURE.** This is a qualified reviewer checklist for a *future* machine-specific design. It does not authorize bypassing an interlock, wiring a jumper, operating a jammed lift, dropping a load or exposing people.

## Why this exists
[Autoquip FLM/FLMC 35100961 Rev.1](https://autoquip.com/wp-content/uploads/2018/03/flm_flmc_slack_chain_sensing_switch_installation_instructions.pdf) describes a **temporary** qualified-electrician bypass to escape a specific slack-chain recovery deadlock, and explicitly requires removing it afterward. [Autoquip FL4M v3.4](https://autoquip.com/wp-content/uploads/2018/03/830FL4M-V3.4.pdf) separately documents mechanical locking cams, structural reinforcement, guards and a prohibition on directly actuating contactors. **Do not assume these two model families share identical equipment or procedures.** See [original audit](../research/4400_AUTOQUIP_SLACK_CHAIN_TEMPORARY_BYPASS_AND_FL4M_MECHANICAL_CAM_SOURCE_AUDIT_2026-10-26.md).

| Gate | Documentary question for independent qualified reviewer | Evidence/status (blank) |
|---|---|---|
| **EX-1 Applicability** | Is the exact machine/OEM/option/revision and fault diagnosed, rather than copying a different model's procedure? | UNKNOWN / NOT RUN |
| **EX-2 Physical safe state** | Is the load independently supported/contained, stored energy identified, access excluded and personnel outside the hazard zone? | UNKNOWN / NOT RUN |
| **EX-3 Exception authorization** | Is the recovery mode OEM-approved, bounded to qualified service and explicitly prohibited for normal production? | UNKNOWN / NOT RUN |
| **EX-4 Visibility & duration** | Is a temporary exception obvious to all relevant workers, controlled against persistence and recorded by responsible owner? | UNKNOWN / NOT RUN |
| **EX-5 Independent barriers** | Which independent protective stop, guard and mechanical restraint remain effective while the normal detection path is unavailable? | UNKNOWN / NOT RUN |
| **EX-6 Removal proof** | Is there independent documented evidence that the temporary exception was **fully removed** and normal circuit configuration restored, not just a green HMI bit? | UNKNOWN / NOT RUN |
| **EX-7 Function & damage review** | Does a qualified no-exposure acceptance plan cover normal sensor response, structural catch/wear, brake/guard condition and fault cause without unapproved live injection? | UNKNOWN / NOT RUN |
| **EX-8 Deliberate return** | Is physical occupancy clear, maintenance LOTO formally released, safeguards restored and fresh intentional start separate from sensor reset? | UNKNOWN / NOT RUN |

## Adversarial documentary cases
**A.** Recovery succeeds and the motor runs normally; a temporary jumper remains hidden. EX-6 cannot pass merely because the input reads NORMAL. **B.** A broken chain is detected and motor trips, but the carriage cam reinforcement is missing. EX-2/EX-5/EX-7 remain unresolved. **C.** An OEM procedure is cited for FLM while the installed lift is FL4M. EX-1 fails; no cross-model assumption. **D.** A service person proposes pressing the contactor by hand. This defeats the reviewed authority boundary; no service release. **E.** A sensor reset occurs while someone is under the carriage. EX-2 and EX-8 fail regardless of stop command.

## Decision and evidence discipline
No gate may be marked PASS by the curriculum AI from manufacturer prose. A future qualified evaluator must identify actual selected hardware, hazard map, design calculations as needed, physical evidence, responsible sign-off and a safe approved verification plan. If a mechanism is not installed, mark **N/A only with dated as-built evidence**; this does not close unrelated Y1/Y2/hydraulic/guard requirements. All statuses currently **UNKNOWN/NOT RUN**.

**DOC-CONFIRMED:** named Autoquip manuals. **INFERENCE:** eight-gate process and forgotten-bypass risk. **SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none.** No Actions dispatch, simulation, physical test, bypass or PL/SIL claim. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.**
