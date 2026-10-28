# 4400-MIRROR-01 service addendum — Is this the *right* NC contact?
**Technician field review | 2026-10-28 | PAPER / UNSCORED | NOT A LIVE TEST**

Read the [original Schneider/Rockwell/Omron source audit](../research/4400_MIRROR_01_ROCKWELL_SUVA_AND_SCHNEIDER_ACCESSORY_SOURCE_DEPTH_ADDENDUM_2026-10-28.md) and [existing RST-01](4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md). This is an **addendum to existing 2026-10-25 MIRROR-01** (see [original manufacturer audit](../research/4400_SCHNEIDER_SIEMENS_MIRROR_NC_VS_GUIDED_AUX_EDM_VARIANT_SOURCE_AUDIT_2026-10-25.md) and [existing UNSCORED cases](4400_MIRROR_01_TWELVE_REPLACEMENT_AND_EDM_FAULT_CASES_2026-10-25.md)). It does not create a new competency. Do not replace the existing 2540 or RST-01 curriculum or count this card as an independent exam.

## One-minute fault review
A maintenance replacement has the same contactor voltage, number of power poles and an NC terminal numbered 21–22. The safety relay sees the feedback close after a stop. **Is it an equivalent safety feedback path?** No: first identify the **exact base and auxiliary part numbers**, approved assembly/mounting, **manufacturer-declared mirror behavior for that exact NC**, terminal-to-contactor mapping, wiring and feedback monitoring. Normal continuity proves only that this circuit changes in the observed state.

**What to inspect with power isolated and qualified authorization:** photographs of K1/K2 base labels and **front/side** accessory labels; wiring drawings with unique EDM terminal mapping; manufacturer's product/assembly instructions and certificate; physical retention, damage and unauthorized bridges; installation change record; and the independent safe-state/stop/hold verification plan. Do not improvise live weld faults or expose people.

## Three diagnostic traps
1. **'Any NC is a mirror contact.'** False. Schneider's exact product FAQ lists mirror and non-mirror variants, and even some NC accessories do not carry the property. A field-supplied snap-on replacement may change the safety argument.
2. **'Mirror means the reverse is also guaranteed.'** False as a general claim. Mirror is **main NO closed => mirror NC cannot be closed**; mechanically linked relay contacts impose a broader NO/NC mutual-exclusion property. Verify exact product scope.
3. **'EDM healthy means ram safely held.'** False. EDM checks a limited switching-device proposition. Motor coast, another energized path, hydraulic pressure, gravity and workpiece hazards require independent machine-specific proof.

## Repair-first human factors
Keep an approved preassembled, labeled spare and the exact accessory documentation at the cabinet; prefer retained/factory-mounted feedback blocks where the selected design permits. Label K1/K2 EDM distinctly, make fault reasons legible, require deliberate rearm and a **separate fresh motion start**, and make approved restoration faster than hunting for a jumper. A maintenance bypass must not become a production mode.

## Conditional restricted witness, no new form
Use existing [RST-01 blank as-built witness](4400_POWER_RETURN_EDM_AS_BUILT_BLANK_WITNESS_2026-10-24.md), especially **RST-03/04/07/11/12**, and [SO final-element template](../hardware/SO_FINAL_ELEMENT_IMPLEMENTATION_SPEC_TEMPLATE.md). Record: selected contactor + auxiliary SKU/edition; which exact NC is mirror; front/side mounting and retention; approved isolated validation; fault/feedback response; physical final-element and ram hold; restoration/new-start; change record. Unknowns remain **UNKNOWN/NOT RUN**, not inferred from a catalog family.

**No personnel-exposed operation without the independently established minimum safe-to-operate threshold. G0/G1 HOLD.**

### Replacement detail: the numbers and switching order can change
Original Schneider FA122251 (modified 2026-05-12) says **LADN11** uses **NO 53–54 / NC 61–62**, while **LADN11P** uses **NO 13–14 / NC 21–22**. Original FA234029 (modified 2026-08-22) says **LADC22** includes one **make-before-break overlapping** auxiliary NO/NC pair. The manufacturer catalog also restricts side-mounting for particular low-consumption contactor variants. **Four separate checks:** correct terminal identity, correct auxiliary sequence, exact main-pole mirror property, and allowed mechanical mounting. Neither an overlapping auxiliary pair nor a familiar terminal number independently proves or disproves main-pole mirror qualification. Record exact part/terminal mapping; do not make a live assumption.
