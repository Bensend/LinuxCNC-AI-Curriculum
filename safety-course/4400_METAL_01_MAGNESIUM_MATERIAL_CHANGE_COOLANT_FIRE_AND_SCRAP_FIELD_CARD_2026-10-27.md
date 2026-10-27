# 4400-METAL-01 — Material-change technician review: magnesium chips, coolant and fire response

**Non-graduated documentary field card.** Applies only where magnesium or another assessed combustible metal is actually machined/ground/collected. **Not evidence of magnesium on OpenPressBrake.** Original sources and scope: [source audit](../research/4400_METAL_01_MAGNESIUM_CNC_COOLANT_HYDROGEN_CLASS_D_AND_CHIP_HANDLING_SOURCE_AUDIT_2026-10-27.md).

## Five separate propositions before a magnesium job

1. **Material/process:** verify the actual alloy, operation, chip/fine fraction and tool condition. A normal job name or G-code comment is not a material witness.
2. **Cooling/chemistry:** use a qualified dry process **or** a specifically engineered wet/inhibited coolant process. **Never infer “water is always forbidden in machining”** from a warning against pouring water on a magnesium *swarf fire*. DGUV documents engineered wet processes but requires hydrogen control throughout coolant/chip/storage paths.
3. **Collection/storage:** confirm compatible dust/chip collection, duct/fire propagation control, labeled segregation, cleanup and maintenance. “Fan running” and “M8 ON” are only normal controls.
4. **Fire/gas response:** match fire agent to the **actual metal and process** and verify safe access/evacuation. Do not use a generic ABC/CO2/water assumption for burning magnesium fines. The 75-ft OSHA Class D distribution rule has defined workplace scope and exemptions; it is not a machine stopping distance.
5. **Return to service:** after a fire, extraction loss, chemistry change or unexplained heat, hold production until qualified physical evidence and deliberate restart. Ordinary E-stop, CNC cycle end and power restoration do not clear chemical or dust hazards.

## The failure to catch

A shop loads a magnesium program on a previously aluminum machine. LinuxCNC still drives the coolant and chip conveyor exactly as before. The operator sees green HMI indicators. A wet sump or collector may nevertheless be incompatible; fine magnesium dust and hydrogen management are different from the prior job. **Stop the job before personnel exposure unless the process, collector, gas handling and fire response are qualified.** Do not perform ad hoc ignition tests or enter a suspected flammable atmosphere to investigate.

**One-pass witness:** MET-1 alloy/operation; MET-2 approved coolant/process; MET-3 collector/duct; MET-4 wet-system hydrogen/ventilation through idle and power loss; MET-5 selected Class D agent/training; MET-6 segregation/maintenance; MET-7 independent protective stop/isolation/rearm. All UNKNOWN until selected-machine proof. No invented numerical limits or new graded paper case.

**Evidence:** Luxfer magnesium supplier and DGUV/IFA wet-process guidance **DOC-CONFIRMED direct**; OSHA §1910.157(d)(6) and Appendix A **DOC-CONFIRMED indexed-only**; CSB Hayes Lemmerz **DOC-CONFIRMED different metal/process**; physical machine **UNKNOWN**; no TEST-CONFIRMED result.

## Dry grinding / deburring addendum (DGUV FB HM-051, 08/2014)

If the job includes **fine magnesium grinding dust**, a stopped CNC spindle does not clear dust stuck to clothing or a nearby hand-grinder/steel contact spark source. The original DGUV guidance calls for a magnesium-suitable extraction/cleanup system, clothing that does not retain dust, avoiding blow-off of fines, and **vented storage for wet magnesium sludge**. Its example separates first-aid water for burns from water applied to burning magnesium metal. Add **MET-8: clothing/secondary tool ignition, approved vacuum and vented wet-sludge handling** to the physical witness. This is a *dry-grinding-specific* addition, not an all-machining rule. Original source: https://www.dguv.de/medien/fb-holzundmetall/publikationen-dokumente/infoblaetter/infobl_deutsch/051_trockenschleifen.pdf .
