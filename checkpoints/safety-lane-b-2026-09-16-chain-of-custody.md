# LinuxCNC / OpenPressBrake Safety Curriculum — Independent Lane B checkpoint

Date: 2026-09-16
Status: ACTIVE

## Completed this lane

- `safety-course/SAFETY_EVIDENCE_PROVENANCE_CHAIN_OF_CUSTODY_WORKSHEET.md`
- Durable commit: `d75180665fde84521e3b07e20736b1172461ea40`

## Parallel-work check

At selection time, primary-lane head was `3d1cf566ce21c3c1b6b2f5e104176f2b78154206`, advancing the primary safety course to post-maintenance restoration / proof-test / configuration-change validation after `safety-course/MAINTENANCE_BYPASS_OVERRIDE_LIFECYCLE.md`.

Lane B selected the already-checkpointed evidence-provenance / chain-of-custody worksheet. It did not modify the primary bypass module or its planned restoration-validation artifact.

Immediately before the Lane-B durable commit, current main was re-read. No primary-lane commit newer than `3d1cf566...` had appeared and no overlapping file existed. Immediately after the write, `d751806...` was current head.

## Frozen findings

- Evidence must be bound to the exact physical claim, observer/authority, raw artifact, tested configuration, time/session/sequence quality, transformations, integrity gaps, provenance label, bounded conclusion and explicit UNKNOWNs.
- Command evidence, logic-state evidence, electrical feedback, independent final-element evidence, physical-hazard evidence and personnel/space evidence are different levels; do not silently promote one into another.
- A safety signature/configuration signature identifies configuration. It does not prove field wiring, physical restoration, final-element response, energy dissipation or personnel clearance.
- Screenshots and copied CSV/report data are transformations/presentation artifacts when a richer raw source exists. Preserve the raw artifact and transformation ledger where practical.
- Matching controller configuration does not rescue undocumented wiring/guard/final-element changes.
- Wall-clock timestamps alone do not guarantee causal ordering across reboot, clock correction or buffered logging.
- A narrower evidence-bounded conclusion with explicit UNKNOWNs is preferred over an apparently complete conclusion supported by a broken evidence chain.

## Compute

No executable verification was needed. No GitHub-hosted or self-hosted runner compute was consumed.

## Precise next independent work

Develop an **evidence acceptance / rejection gate matrix** for commissioning and fault-injection records, without duplicating the primary post-maintenance restoration module.

It should answer, per evidence artifact:

1. Is the physical claim explicit and bounded?
2. Is the observer sufficiently independent for that claim?
3. Is raw evidence retained or is loss explicitly recorded?
4. Is configuration identity sufficient to bind the evidence to the tested machine state?
5. Are transformations traceable?
6. Are freshness/session/order gaps understood?
7. Is the provenance label justified?
8. What exact conditions force REJECT, REVIEW, or ACCEPT-AS-BOUNDED rather than PASS?

Include calibration cases for command echo, EDM/mirror feedback, current/pressure/motion witnesses, HMI screenshots, safety-controller logs, video, manually transcribed measurements, and configuration-signature reports. Do not create invented acceptance tolerances, stopping limits, hydraulic thresholds, PL/SIL claims, or proof-test intervals.

Before starting, re-read current main and primary safety work. If the primary lane has moved into evidence acceptance/rejection, switch to another independent open branch.