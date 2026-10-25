# 4400-SD-01 — Serial diagnostics, guard-lock authority, delayed warnings and escape: original manufacturer evidence
**Date:** 2026-10-25 | **Status:** source study, not selected-machine validation | **Machine release:** NO

## Question frozen before study
Can a convenient serial-diagnostic gateway's guard-lock/unlock command be used as the personnel-protective gate-retention function, and can a generic diagnostic warning be interpreted as immediate safety shutdown? What must remain independent when a person can enter the guarded volume?

## Original documents inspected
1. **Schmersal**, *Safety in System — Serial Diagnostics*, EN, issue 03, July 2023, publication part 103035434, 12-page original PDF: https://products.schmersal.com/upload/orig/10/00/34/91/DOC_MAR_BRO_b-sd_SEN_AIN_V3.pdf . Directly opened and indexed. PDF p.3–5 (zero-based pages 2–4), pp.10–11 (zero-based 9–10). The brochure is product-family/architecture literature, not a selected device's operating manual.
2. **Pilz**, *Definition of safety locking device*, current official manufacturer explainer: https://www.pilz.com/en-AU/support/lexicon/articles/073478 . Directly opened; describes process versus personnel guard locking, conditional unlock, spring-to-lock and bistable principles, and inside escape.
3. **Pilz**, *PSENmlock product family*, official manufacturer page: https://www.pilz.com/en-IN/products/sensor-technology/safety-switches-with-guard-locking/psenmlock-safety-locking-devices . Manufacturer describes optional inside escape release, five-padlock restart-prevention insert, and variant-specific emergency release constraints. These features cannot be assigned to another product.
4. **Schmersal AZM201 indexed manual**, https://products.schmersal.com/upload/orig/10/00/19/97/DOC_MAN_MEC_mrl-azm201_SEN_AIN_V5.pdf . Search index surfaced magnet-control and Z/B output differences, but direct URL redirected to catalog, so **indexed-only / NOT independently PDF-opened**. Do not treat these unverified lines as the decisive source for this study.

## Direct original-source observations and limits
| ID | Observation | Classification | Consequence / scope |
|---|---|---|---|
| SD-01 | Schmersal diagram separates series safety signals X1/X2/Y1/Y2 from the serial diagnostic wire and its ordinary PLC gateway; safety may be evaluated by separate relay/controller. | DOC-CONFIRMED brochure pp.3–5 | A status/command telegram does not inherit the authority of the safety OSSD chain. |
| SD-02 | Schmersal footnote explicitly restricts solenoid interlocks **when lock/unlock is commanded through the non-safe SD gateway** to process protection. | DOC-CONFIRMED brochure p.11, footnote 1 | Do not use ordinary SD unlock to prove personnel-retention-until-safe-stop. This is a conditional architecture statement, not a declaration that every Schmersal interlock is process-only. |
| SD-03 | Brochure separates non-safety-critical warnings (outputs reportedly switched off only after **30 minutes**) from safety-critical faults (outputs off immediately). | DOC-CONFIRMED brochure p.5 | Do not equate WARN with STOP or infer immediate loss of safety outputs. The 30-minute brochure statement is **not** a universal timer, selected-machine setting, safe-access delay or authorization to operate through a warning. Exact product/manual fault table is needed. |
| SD-04 | Pilz distinguishes conditional unlocking for personnel when access time is shorter than hazardous stopping time from unconditional unlocking/process protection. | DOC-CONFIRMED Pilz explainer | Time-to-hazard and measured stopping time require selected-machine evidence; neither is assumed here. |
| SD-05 | Pilz identifies spring-applied or bistable locking as ways to retain locking state during power loss, while separately requiring inside escape where full-body access is possible. | DOC-CONFIRMED Pilz explainer | Power-loss retention alone may trap a person; inside release must be physically reachable and verified. |
| SD-06 | Pilz PSENmlock family offers an inside escape handle and a multiple-padlock restart-prevention feature; some emergency-release variants have reset constraints. | DOC-CONFIRMED family page | Product option/suffix, location and installation are mandatory; a product-page picture is not selected-machine proof. |
| SD-07 | The complete OpenPressBrake rear-access geometry, interlock model/suffix, safety-rated unlock, safety output wiring, person escape, independent ram hold and rearm are absent. | UNKNOWN | G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED. |

## Architecture: what controls what
- **Ordinary LinuxCNC/HAL/FPGA/PLC/HMI:** process request to open/close, maintenance messages, event history, diagnostic presentation; may request access but cannot independently grant protective access or motion authorization.
- **Safety-related controller and input/output chain:** evaluates selected guard closed/locked status, independent hazard-stop/hold and safety-related unlock-permission conditions; exact selected device may demand safety-rated lock control and independent interlock monitoring.
- **Physical layer:** guard door/latch and inside escape; final energy isolation, ram support, hydraulic stored-energy control, rescue; do not equate a gate's holding force with hydraulic ram holding.
- **Human factors:** visible access request; door cannot be opened during hazard; no person stranded after power loss; access for service without defeating guard; reset station has occupancy visibility; reopening/closing door does not reissue an old motion command.

## Adversarial failure paths
1. **Ordinary SD unlock issued during coast-down:** a safe-looking diagnostic interface could unlock before actual hazard ceases. Require selected independent safe-unlock function or prove process-only use with separate protective measures.
2. **Noncritical warning while outputs remain enabled:** operator sees warning but assumes E-stop happened. Treat warnings as diagnosis; demand actual safe-output/final-element/physical-state evidence.
3. **Supply loss while worker inside:** spring/bistable lock retains door shut; external-only emergency release cannot substitute for reachable inside escape.
4. **Repair/guard reclose and stale LinuxCNC command:** outputs healthy and locked are necessary inputs but do not authorize motion. Require independent rearm and fresh deliberate start with exclusion of occupied zone.
5. **Swapped suffix / gateway:** same mechanical housing or green LED does not establish equivalent lock-control integrity, diagnostic class, output semantics, or escape route.
6. **Common cable/supply fault:** diagnostic and safety signals may share mechanical routing; investigate cross-fault and physical final-element independence rather than declaring redundancy from two named channels.

## Evidence not obtained
No selected Schmersal/Pilz product is asserted to be installed on OpenPressBrake. No standard text beyond manufacturer explanation is claimed as inspected. No SOURCE-CONFIRMED LinuxCNC implementation in this study; no TEST-CONFIRMED or COMMUNITY-REPORTED outcome. No PL/SIL, stopping time, time-to-hazard, pressure, guard-force or physical escape result is assigned. An official indexed AZM201 PDF was **not** directly opened. No energized, simulated or physical experiment is justified before exact device/architecture selection. No GitHub-hosted or local runner minutes.

## Transfer question
A machine reports "LOCKED" over SD, and a non-safety PLC can send UNLOCK. The installer says the gate is therefore safe for personnel access. The learner must identify which proof is missing (safety-rated retention until independent physical safe state), distinguish the separate safety OSSD path, and specify inside escape and fresh-start evidence. Preserve unknowns instead of guessing hardware.
