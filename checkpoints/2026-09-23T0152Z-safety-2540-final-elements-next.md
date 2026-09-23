# Safety curriculum checkpoint — 2540 final-element boundary next

## Durable state

- 1000/2000/3000 remain GRADUATED/CLOSED; 4000 safety remains primary.
- 2520 and 2530 information-separated external evaluation gates remain OPEN and uncontaminated.
- 2540 now has a five-family manufacturer comparison and a relay/contactor physics bridge in `safety-course/2540_FIVE_FAMILY_SAFETY_RELAY_COMPARISON_AND_PHYSICS_BRIDGE_2026-09-23.md`.
- Families compared: Pilz PNOZ X3, Allen-Bradley Guardmaster SI 440R-S12R2, Phoenix Contact PSRclassic 2963912, Omron G9SE-201, ABB Sentry SSR10.
- Missing manufacturer fields are `UNKNOWN`; no family/component rating is transferred to a complete machine function.

## Key new freezes

- FORCE-GUIDED CONTACTS ENABLE COVERED DIAGNOSTICS; THEY DO NOT MAKE A RELAY INFALLIBLE.
- CONTACT CARRY CURRENT != SWITCHING SUITABILITY.
- RESISTIVE RATING != INDUCTIVE AC/DC INTERRUPTION RATING.
- ARC SUPPRESSION MAY CHANGE RELEASE BEHAVIOR; IT BELONGS IN VALIDATION.
- EDM AUXILIARY STATE != HAZARDOUS ENERGY REMOVED.
- RELAY RESPONSE TIME != MACHINE STOPPING TIME.
- COMPONENT PL/SIL/PFH != COMPLETE SAFETY-FUNCTION PL/SIL/PFH.

## Exact next work

1. Build the machine final-element lesson around three deliberately different paths: safety relay -> contactor -> motor power; safety relay/controller -> certified drive STO input; safety relay/controller -> fluid-power valve/final element.
2. For each, distinguish command state, diagnostic witness, final-element state, hazardous-energy state and physical safe-state proposition.
3. Trace welded main contacts, misleading/stale auxiliary feedback, common power/common actuator, suppression-delayed release, incorrect utilization category, replacement/maintenance drift and stored-energy cases.
4. Connect each case to the reusable 2520 verification/validation matrix and identify what requires machine-specific measurement rather than inference.
5. Do not invent universal PL/SIL, valve truth tables, stopping times, pressure thresholds or drive behavior.
6. No compute unless a concrete unresolved question survives authoritative engineering/source review; if justified, self-hosted `[self-hosted, openpressbrake]` only.

## Compute

No simulation/build/synthesis/benchmark/test compute was justified or consumed. No GitHub-hosted runner was used.
