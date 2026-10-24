# 4400-RET-01 — fresh-AI CNC safety cutover source-transfer handoff

**Prepared 2026-10-24 UTC. Status: NOT RUN / NOT SCORED / NOT GRADUATED.** This is a **novel hypothetical assessment**, not an installed-machine description, hidden answer key, software test or physical commissioning instruction. Do not treat a paper score as physical safety proof.

## Source pack

- [4400-RET-01 learner module](../safety-course/4400_RET_01_BROWNFIELD_CNC_SAFETY_CUTOVER_AND_FINAL_ELEMENT_MODULE_2026-10-24.md) and linked original research.
- [LinuxCNC 2.9 iocontrol](https://linuxcnc.org/docs/2.9/html/man/man1/io.1.html) and pinned [estop_latch source](https://github.com/LinuxCNC/linuxcnc/blob/514be4f657b2f1c432ebaaebd117ef112e3e7565/src/hal/components/estop_latch.comp).
- [Pilz PNOZ m B0 OEM 1002660-EN-13](https://www.pilz.com/download/open/PNOZ_m_B0_Operating_Manual_1002660-EN-13.pdf), exact model/version-specific.
- [Rockwell LVSAM-RM003A-EN-P Nov 2012](https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/lvsam-rm003_-en-p.pdf), general industrial switchgear guidance.
- [OSHA 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147) and [1910.302](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.302).
- [Blank cutover continuity worksheet](../safety-course/4400_CNC_RETROFIT_SAFETY_FUNCTION_CONTINUITY_AND_ISOLATION_WORKSHEET_2026-10-24.md).

## Novel assessment: two disputed retrofit bids

A fictional shop is replacing a legacy CNC on a hydraulic press brake with LinuxCNC, a general-purpose FPGA and a web diagnostic panel. It wants to keep an existing, but **unidentified**, safety controller. The existing guard wiring is incomplete on the drawing supplied to the bidder.

**Bid A:** The bidder connects a PLC terminal labeled `IM18` to an FPGA input named `SAFETY_OK`. It proposes that FPGA firmware turn off all valve outputs on loss of that bit. A photograph shows a controller RUN LED but not the model label. The bidder promises the original safety PLC will remain unchanged.

**Bid B:** The bidder retains an independent contactor circuit but changes the coil suppression and extends a remote control cable by an unknown length. The old cabinet's disconnect cannot accept a padlock. The bid includes a copied old stop-time certificate, without test configuration or an as-built wiring revision. A remote web screen can clear LinuxCNC's E-stop state. No local restart/occupancy evidence is provided.

For **both** bids, the actual machine safety PLC part/firmware, hydraulic final-element diagram, cylinder/ram load restraint, Y1/Y2/backgauge motion paths, actual coil AC/DC type, receiver electrical thresholds, cable topology, guard coverage, reset/foot-pedal sequence, isolation zones and physical stop/hold data are **not provided**.

The case is intentionally incomplete. Do not assume `IM18` is a safety output on an unknown PLC merely because a similarly named terminal appears in one manufacturer manual.

## Independent learner tasks

1. Build a **source/edition and applicability matrix** distinguishing LinuxCNC source, Pilz exact-product OEM, Rockwell general guide, OSHA applicability and unknown installed-machine facts. Cite original page/section/commit, not summaries alone.
2. For each bid, trace **normal control**, **independent safety**, **diagnostic status** and **maintenance isolation**. Mark missing links and physical final elements; do not substitute a general FPGA output for safety authority.
3. Identify at least **four falsifiable failure hypotheses** and their *non-executable* documentary/physical-witness evidence requests, including reset/start, terminal role, coil/suppression/cable and gravity/pressure.
4. Decide whether the existing old stop-time certificate can be reused without further work, and what `CHG/VAL/PT` records must be reviewed. No numerical stop-time or PL/SIL may be invented.
5. Analyze whether OSHA 1910.147(c)(2)(iii) **could** apply, identify the missing applicability facts, and distinguish a lockable energy-isolating device from a software OFF/contactor control. Do not declare every software update a major repair.
6. Propose a low-cost, **human-factors-resistant** wiring, guarding, service isolation and deliberate reset/start workflow that makes correct use easier than bypassing safeguards.
7. State explicit **HOLD / UNKNOWN / NOT APPLICABLE** dispositions for personnel-exposed operation and for isolated/remote experimentation, including the minimum evidence needed to change each gate.

## Freshness and evaluation contract

A fresh learner must submit an immutable response **before** independent evaluator feedback, with: primary prediction, causal mechanism, expected independently checkable observation, original source/section, alternative explanation, falsifier, confidence 0–100%, actual solution time and resources consulted. Do not supply an answer key, earlier solved near-duplicate or this authoring model's solution. The independent evaluator must check the cited original sources, not grade by stylistic similarity.

Use [BLIND_FEEDBACK_PROTOCOL.md](BLIND_FEEDBACK_PROTOCOL.md) dimensions (prediction, mechanism, efficiency, uncertainty/safety boundary, confidence calibration), 0–2 each, total /10, with explicit critical safety boundary failures. A contaminated learner/evaluator or invalid original-source oracle must be marked `CONTAMINATED` or `EVALUATION_INVALID`; never turn it into a pass. A failed attempt needs a distinct new case and recorded correction, not a recycled answer.

| Evaluation gate | Observation | Artifact / source | State |
|---|---|---|---|
| Fresh learner and evaluator independent | | | NOT RUN |
| Original source/edition identification | | | NOT RUN |
| Final-element and physical witness reasoning | | | NOT RUN |
| Product-specific terminal/coil/cable scope | | | NOT RUN |
| OSHA lockout applicability and restart | | | NOT RUN |
| Human factors and safe uncertainty | | | NOT RUN |
| Score / corrections / novel retest | | | NOT RUN |

**Boundary:** Even a perfect paper score is not `TEST-CONFIRMED` machine stopping, holding, LOTO, guard or safe restart. No person-exposed hazardous operation or live coil/hydraulic fault injection is authorized. If fresh external evaluation is unavailable, leave this handoff `NOT RUN`.
