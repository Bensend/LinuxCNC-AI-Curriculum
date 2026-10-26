# 4400-FDI-01 — Twelve unscored technician cases (PAPER ONLY)

**Open-book; no hidden answers, external scoring or machine test.** Read the [manufacturer source audit](../research/4400_SIEMENS_S210_FDI_ASYMMETRIC_DISCREPANCY_FAULT_TO_STO_SOURCE_AUDIT_2026-10-26.md). For every answer state (a) initial two-channel polarity, (b) requested/active safety state, (c) diagnostic and transition status, (d) physical hazardous element, (e) what evidence is missing, and (f) HOLD/qualified next action. Never inject a fault on an exposed machine.

1. **Initially LOW/LOW:** one F-DI becomes HIGH and a discrepancy is reported; the other later becomes HIGH before the p9658 transition ends. Can the technician equate F01611 with latched STO?
2. **Initially HIGH/HIGH:** one input becomes LOW while p9652 is nonzero. Distinguish the immediate commanded response, subsequent discrepancy and eventual STO.
3. **Initially HIGH/HIGH with p9652 zero:** one input becomes LOW. What changes compared with case 2? Do not assume p9658 is a universal response time.
4. **Debounce bounce:** an input returns to its previous state inside p9651. What is the OEM-described filter boundary? Why is a brief pulse not proof that the protective system was validated?
5. **Discrepancy configuration:** an integrator makes p9650 longer than the shortest ON/OFF-to-OFF/ON interval to avoid nuisance faults. Identify the OEM constraint and human-factor redesign issue.
6. **Fault LED red, motor energized:** maintenance argues that F01611 means torque must already be off. Explain the possible timing state and what must remain excluded.
7. **S210 STO active, vertical mill Z axis:** an axis is stopped, but the brake is mechanically worn. Why does SBC status not establish physical holding?
8. **SBT from HMI:** a technician proposes running SBT during hands-on service because “test” sounds passive. Identify actual test torque, required drive enables and exclusion/isolation conflict.
9. **Drive READY after reset:** guard closes and LinuxCNC cycle-start remains asserted. Explain the distinction between drive ON/OFF1 edge, independent safety rearm and fresh ordinary motion authorization.
10. **Press brake retrofit:** an installer cites S210's motor F-DI discrepancy logic as proof that a hydraulic Y1/Y2 beam is safe. Identify the invalid technology transfer and the missing load-side witnesses.
11. **Machine with multiple drives:** one drive reports STO active; another has no safety input connection. Define the system boundary and why “all axes safe” is unproven.
12. **Replacement drive:** p9650/p9651/p9652/p9658 and safety firmware differ after replacement. What change-control records and independent physical tests must be planned before personnel-exposed release?

## Open-book review criteria

For cases 1–3, correctly distinguish the two OEM initial-state paths without inventing numeric times. For cases 4–6, distinguish filtering/discrepancy/transition/error from actual torque removal. For cases 7–8, reject motor brake command and energized SBT as load-side proof or maintenance isolation. For cases 9–12, demand separate occupancy, fresh-start, as-built physical safe-state and change-control evidence. All cases **UNSCORED** until independent evaluation. G0/G1 HOLD, no live testing authorized.
