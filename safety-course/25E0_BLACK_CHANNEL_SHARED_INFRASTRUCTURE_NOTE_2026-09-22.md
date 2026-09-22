# 25E0 — Black-Channel Safety and Shared Network Infrastructure

Date: 2026-09-22
Status: supplemental professional source trace

## Question

If several safety functions share Ethernet switches, routers, links, or other ordinary network infrastructure, does the shared infrastructure become a safety authority or does its failure simply create a common availability loss that the end-to-end safety protocol must detect?

## Professional evidence

### DOC-CONFIRMED — CIP Safety end-to-end / black-channel model

Rockwell Automation documents that CIP Safety devices may communicate through bridges, switches, routers, adapters, and redundancy modules that are not SIL 2/SIL 3 certified. It calls this black-channel communication and states that CIP Safety is an end-node-to-end-node safety protocol whose devices are protected from network delivery errors.

Source: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um900/controllogix-5590-controller-user-manual-ditamap/functional-safety-reference/cip-safety-systems-and-safety-network-numbers.html

Claim class: `DOC-CONFIRMED`.

ODVA independently describes CIP Safety as running over standard cabling/switches, with safety mechanisms in the safety protocol/end devices rather than depending on integrity of the underlying network media.

Source: https://www.odva.org/technology-standards/distinct-cip-services/cip-safety/

Claim class: `DOC-CONFIRMED`.

### DOC-CONFIRMED — PROFIsafe black-channel model

PROFIBUS & PROFINET International describes PROFIsafe as covering the communication path from sensor through controller to actuator while treating underlying transmission paths as black channels. Communication faults lead to the defined safety reaction; the safety protocol is designed independently of the ordinary transmission channel.

Source: https://www.profibus.com/technologies/profinet/profiles/profisafe

Claim class: `DOC-CONFIRMED`.

## Curriculum consequence

A shared standard switch can be a **common dependency for availability/communication continuity** without becoming the personnel-safety decision authority. If that switch fails, several safety connections can disappear together. The safety protocol/application must produce its defined fault/safe reaction for each affected path.

Reverse dependency example:

`DEP-SWITCH-CELL-A -> EVID-CONNECTION-GUARD -> PROP-GUARD-DATA-AVAILABLE`

`DEP-SWITCH-CELL-A -> EVID-CONNECTION-SCANNER -> PROP-SCANNER-DATA-AVAILABLE`

`DEP-SWITCH-CELL-A -> EVID-CONNECTION-SAFE-DRIVE -> PROP-DRIVE-SAFETY-DATA-AVAILABLE`

Loss of `DEP-SWITCH-CELL-A` can therefore make all three evidence sources unavailable at once. This is a common-cause **communication availability** event. It does not prove that the physical guard, scanner field, or drive changed state; nor does it prove that their prior physical validation remains applicable. Those are separate proposition/freshness questions.

## Critical distinction — unavailable versus stale

- If a network switch fails with no evidence of physical/configuration change, current remote state evidence may become `UNAVAILABLE` while some historical installation/validation evidence remains applicable under its contract.
- If the same event also includes device replacement, configuration change, mechanical impact, maintenance, or another event that challenges the accepted baseline, affected evidence can become `STALE`, not merely unavailable.
- When communication returns, `UNAVAILABLE` current-state evidence can become available again through fresh safety data. `STALE` physical/configuration evidence requires whatever revalidation its proposition contract specifies.

Do not automatically mark every historical validation stale on a transient packet/connection loss; doing so would confuse evidence transport with physical change. Do not automatically preserve every proposition either; a safety function that requires a continuously current field witness cannot operate while that witness is unavailable.

## What black channel does not mean

It does **not** mean:

- any network topology automatically meets the machine's required availability or reaction-time needs;
- redundancy is unnecessary for every application;
- a standard switch becomes safety-rated;
- a restored Ethernet link proves device reintegration;
- ordinary network health proves machine safety;
- the curriculum may invent a PL/SIL target, timeout, reaction time, or redundancy requirement.

Those remain design-specific and `UNKNOWN` until established.

## New freezes

- **BLACK-CHANNEL SAFETY != NETWORK INFRASTRUCTURE IS SAFETY AUTHORITY.**
- **SHARED NETWORK LOSS CAN BE COMMON-CAUSE EVIDENCE UNAVAILABILITY WITHOUT PROVING COMMON PHYSICAL FAILURE.**
- **EVIDENCE UNAVAILABLE != EVIDENCE STALE.**
- **CONNECTION RESTORED CAN RESTORE OBSERVABILITY; IT DOES NOT AUTOMATICALLY RESTORE STALE PHYSICAL/CONFIGURATION EVIDENCE.**

## Compute decision

No executable compute is justified. The architecture distinction is resolved adequately from authoritative CIP Safety/PROFIsafe documentation. No GitHub-hosted compute was used.
