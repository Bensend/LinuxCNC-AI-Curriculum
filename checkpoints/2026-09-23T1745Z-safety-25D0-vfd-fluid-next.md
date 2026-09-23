# Safety curriculum checkpoint — 25D0 VFD/fluid next

## Durable state

- 25D0 remains active.
- `research/25D0_TIER_ABC_FAULT_COMPARISON_2026-09-23.md` now completes the first A/B/C fault comparison requested by the prior checkpoint.
- Siemens 3SK2 documentation was reopened for the exact EDM proposition: appropriate positively driven NC/mirror contacts witness controlled actuator switch state; fail-safe re-enable can be conditioned on the feedback circuit. Schmersal SRB-E-301ST documentation was reopened for product-specific wire-break, cross-circuit, reset-edge and feedback capabilities.
- Dollar pricing remains intentionally unfrozen because this pass did not establish a sufficiently comparable traceable current transaction-price set.
- No executable compute is justified. No GitHub-hosted runner is to be used.

## Exact next work

1. Build a machine-class comparison between an ordinary VFD without integrated STO using appropriate external energy switching and a drive with integrated STO plus separately justified maintenance isolation.
2. Re-open authoritative drive-manufacturer application documentation. Keep STO != standstill, STO != electrical isolation, contactor-open != DC bus discharged, and reset != motion-start boundaries explicit.
3. Compare incremental hardware cost by named failure path/proposition, not by component count. Use actual dollar figures only from traceable like-for-like sources.
4. Audit the 25D0 syllabus after the VFD comparison. If low-cost fluid-power treatment is materially required, add a Tier-E comparison separating supply isolation, dump/decompression and load holding; do not invent valve truth tables or pressures.
5. If coverage is coherent after that work, prepare the 25D0 canonical learner route and no-solution information-separated evaluator handoff rather than self-graduating.
6. Keep ordinary LinuxCNC/FPGA outside personnel-safety authority.
7. Freeze executable compute only for a concrete unresolved implementation question that source/engineering analysis cannot answer; use `[self-hosted, openpressbrake]` only.