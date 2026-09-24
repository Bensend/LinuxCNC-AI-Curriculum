# Safety final-element witness checkpoint — 2026-09-24T12:39Z

Status: coherent Rockwell contactor chain deepened through exact family evidence, adversarial failure propositions, and a drive-STO architecture comparison. Generic safety schematics remain NOT FROZEN. External/fresh 2520–25F0 competency gates remain open and uncontaminated.

Durable work:
- `research/ROCKWELL_EXACT_CHAIN_FAULT_AND_STO_COMPARISON_2026-09-24.md`
- existing `research/WORKED_COHERENT_SAFETY_CHAIN_ROCKWELL_2026-09-24.md`

Key evidence:
- Rockwell SAFETY-AT164A-EN-P identifies the 450L -> 440C-CR30 -> 100S-C architecture family and documents safety-output withdrawal, contactor coil control, mechanically linked N.C. feedback and reset behavior.
- Rockwell 100-TD013 and 100S-CT015A-EN-E support the 100S-C mechanically-linked/mirror-contact relationship; exact selected catalog/coil/suppression/load details remain a schematic gate.
- Siemens SIMODRIVE 611 documentation provides an independent final-element contrast: STO removes torque-generating capability but is not electrical isolation and does not itself prove standstill; external torque/gravity can require separate holding measures.

New freezes:
- `FEEDBACK PLAUSIBLE != CONTACTOR MECHANISM PROVED`.
- `REDUNDANT CONTACTORS != INDEPENDENT ENERGY-REMOVAL CHANNELS`.
- `FINAL-ELEMENT ARCHITECTURE DETERMINES THE LEGITIMATE WITNESS`.

Bench decision: no lab frozen. Authoritative documentation answers the current architecture/proposition question; selected-circuit details must be established before a bench question is meaningful.

Exact next work:
1. Extend the final-element comparison to one monitored hydraulic safety architecture with authoritative valve-position/pressure/energy-path documentation. Do not invent a press-brake hydraulic truth table.
2. Build a learner-facing final-element witness matrix comparing contactor interruption, drive STO, monitored hydraulic valve/dump, and mechanical holding/restraint: demand, final element, available feedback, proposition actually proved, residual energy, maintenance-isolation boundary, and required physical witness.
3. Trace common-cause dependencies for the hydraulic example (pilot supply, valve supply, feedback supply/reference, shared manifold/mechanical path, accumulator/trapped volume) and preserve UNKNOWNs where the selected machine circuit is absent.
4. Reconcile the matrix into `SO_IMPLEMENTATION_SPEC_TEMPLATE.md` / selected-block qualification worksheet if it exposes a missing field or misleading generic assumption.
5. Freeze a bounded bench lab only if a concrete selected-interface uncertainty remains after documentation; use `[self-hosted, openpressbrake]` only. Do not use GitHub-hosted compute.
6. Preserve the independent safety boundary: ordinary LinuxCNC/HAL/FPGA may request/observe but does not gain personnel-safety authority.