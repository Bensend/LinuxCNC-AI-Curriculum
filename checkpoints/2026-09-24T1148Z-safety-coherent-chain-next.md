# Coherent safety-chain qualification checkpoint — 2026-09-24T11:48Z

Status: manufacturer-supported coherent OSSD -> safety logic -> contactor/EDM chain traced. Generic safety schematics remain NOT FROZEN. External/fresh 2520–25F0 competency gates remain open and uncontaminated.

Durable work:
- `research/WORKED_COHERENT_SAFETY_CHAIN_ROCKWELL_2026-09-24.md`
- updated `PROGRESS.md`

Key evidence:
- Rockwell SAFETY-AT164A-EN-P documents a coherent light-curtain -> 440C-CR30 -> 100S-C chain, safety-output withdrawal, contactor coil control, mechanically linked auxiliary feedback and reset behavior.
- SAFETY-AT138C-EN-P and 440C-UM001I-EN-P support OSSD fault/input semantics and explicit `2 OSSD` safety-input configuration rather than nominal-voltage inference.
- The application evidence resolves the prior existence/compatibility question for its documented family but does not make arbitrary products interchangeable.

New freeze:
- `MECHANICALLY LINKED CONTACTOR FEEDBACK != MACHINE SAFE STATE PROVED`.

Bench decision: no lab frozen. Authoritative documentation answers the current interface/proposition question. Compute would not add enough information yet.

Exact next work:
1. Refine the coherent chain at exact catalog/revision granularity where current documentation permits, especially selected light-curtain family, 100S-C feedback relationship, output/load/suppression restrictions and CR30 configuration assumptions.
2. Attack welded contactor, feedback open/short/plausible-state, common 24 V/0 V loss/restoration, held reset and retained ordinary start.
3. Compare this contactor energy-removal architecture with one drive-STO or monitored hydraulic final-element family, preserving different witness/residual-energy propositions.
4. Freeze a bounded bench lab only for a concrete unresolved selected-interface question after documentation; use `[self-hosted, openpressbrake]` only.
5. Do not invent machine-specific integrity, stopping, pressure, hydraulic or safe-speed values.