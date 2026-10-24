# 4400 — Hydraulic valve-feedback and leakage source-trap technician card (2026-10-24)

**Open-book, paper-only; not a blind exam, commissioning procedure or permission to operate.** Source: [Bosch IH04 general versus IH04E die-cushion audit](../research/4400_BOSCH_IH04_VALVE_FEEDBACK_LEAKAGE_REPLACEMENT_SCOPE_AUDIT_2026-10-24.md).

## Goal

Prove that a technician can separate a valve's electrical indication, its actual flow/leakage behavior, the moving load, and the maintenance isolation state without borrowing another product's numerical limits. Each answer must state **what is known, what remains UNKNOWN, and the next non-hazardous evidence request**.

| Case | Misleading field statement | Required reasoning / disposition |
|---|---|---|
| HF-01 | "All valve end switches say safe; the die cushion cannot descend." | **REJECT.** The IH04E manual identifies leakage paths that can move a cylinder without a valve-switch discrepancy. Demand physical load/position evidence; do not enter the hazard. |
| HF-02 | "The PLC reads the analog valve actual value, so we can use that as the safety-off output." | **REJECT.** General IH04 instructions explicitly separate ordinary electronics actual-value signals from safety-related shutdown. Establish independent safety-related stop/final-element authority. |
| HF-03 | "OFF mode and zero on the convenient gauge mean we can remove the manifold." | **REJECT.** OFF can leave lines pressurized; establish every affected pressure zone, isolation and verified mechanical restraint before disassembly. |
| HF-04 | "Same type valve, same connector: skip all stopping tests." | **REJECT.** OEM calls for checking reaction time of all safety-related valves after a safety-valve replacement; selected machine also needs affected physical function revalidation. |
| HF-05 | "Bosch says 5 mm/s is acceptable, so use that for our Y1/Y2 beam." | **REJECT.** Identify RE 63124-B's specific load-side measuring-port condition and RE 63129-MON's distinct die-cushion conditions. No OpenPressBrake numerical criterion established. |
| HF-06 | "The IH04E 1 mm/s test is a press-brake ram rule." | **REJECT.** IH04E is a lower die-cushion module, and its described valve-open/pump-off checks are OEM-specific. No unqualified field execution. |
| HF-07 | "One limit-switch fault cleared after reboot; start immediately." | **REJECT.** Fault cause and physical state are unresolved; reset/rearm must be separate from a fresh deliberate motion start. |
| HF-08 | "Hydraulics are powered down, so a ram block is unnecessary." | **REJECT.** Gravity, trapped pressure and component failure remain; selected rated/installed mechanical restraint or proven fall-proof position is necessary before exposure. |
| HF-09 | "ISO 6909:2026 now gives us all the numbers." | **REJECT.** Public abstract is scope evidence only; full relevant clauses, machine type, manufacture date, jurisdiction and measured design are needed. |
| HF-10 | "A valve-limit-switch discrepancy test passed, so the cylinder seals are good." | **REJECT.** A valve-switch check does not test cylinder-seal leakage or manifold cracking. Physical tests require approved procedures and hazard isolation. |

## Technician answer template

For each case: (1) **control proposition** (what the software/valve signal says); (2) **physical proposition** (actual motion/energy/holding state); (3) **independent witness** required; (4) **scope source and edition**; (5) **safe next step**; (6) **UNKNOWNs**; (7) **return-to-service gate**. Avoid a numeric criterion unless it belongs to the exact selected design.

## Human-factors challenge

A mechanic says pressure-port caps are hidden behind a panel, the correct ram support takes too long to install, and a faulted valve switch is easily jumpered. Redesign the **access, labeling, support storage/installation and fault-repair path** so the safe action is the quickest ordinary action. Record the bypass incentive as `HF`, a design response as `CHG/ARC`, and the affected validation as `VAL/PT`; a warning label alone does not solve predictable defeat.

**Status:** cases `HF-01..10` are learning prompts, **NOT RUN** on any machine. Selected `PHY/VAL/PT UNKNOWN/NOT RUN`; no exposed hazardous operation authorized.
