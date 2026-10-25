# 4400-CLAMP-01 — 16 technician cases and blank physical witness
**2026-10-25 | PAPER ONLY / NOT BLIND / NO PHYSICAL TEST**

For each case, identify the exact OEM proposition, a credible failure path, the required physical/independent discriminator, and an easy-to-maintain safer design. Never assign a PL, stopping distance, pressure or load capacity without selected evidence.

1. A standard Festo KP cartridge is used for repeated emergency dynamic braking because it has adequate static force on paper.
2. KEC is substituted for KEC-S because rod diameter and housing appear identical.
3. A KEC-S has an OEM Cat.1 scope; integrator labels the whole two-axis system PLe without architecture analysis.
4. A 5/3 center-closed valve traps pressure in both chambers; a vertical fixture is declared safely held for unattended service.
5. The spring clamp engages after pressure loss, but the cylinder seal leaks and the load shifts.
6. A brake is released while the piston has unequal chamber forces.
7. An elevated mass is held by a clamp whose rod-to-load coupling is cracked.
8. A clamp output bit says "engaged," but no physical holding witness has been performed.
9. A dynamic braking clamp has never had overtravel measured on the selected machine.
10. An engineer copies a stopping distance from a different cylinder bore and line length.
11. A quick-exhaust valve is installed; the engineer assumes this automatically achieves the required safety level.
12. Repeated emergency stops increase clamp wear, but the inspection schedule is unchanged.
13. A technician changes pneumatic tubing length without reviewing the stop response.
14. A replacement rod has different surface finish/hardness and the clamp slips.
15. The machine automatically releases its clamp on safety reset while an old CNC motion command remains queued.
16. A press-brake retrofit copies a Festo pneumatic brake example as proof of Y1/Y2 hydraulic holding.

## Selected-machine evidence intake (blank)
| ID | Restricted qualified evidence required | State |
|---|---|---|
| CLAMP-01 | Exact installed clamp/rod/actuator/valve model and OEM manual edition; certified variant or N/A | UNKNOWN |
| CLAMP-02 | Mechanical rod-to-hazard load path, surface/attachment/force balance and gravity exposure | UNKNOWN |
| CLAMP-03 | Static holding versus dynamic stopping function, risk-based PL/SIL and architecture | UNKNOWN |
| CLAMP-04 | Independent energy isolation and stored pressure/weight support | UNKNOWN |
| CLAMP-05 | Qualified protected selected overtravel, wear, valve/line effects and maintenance plan | NOT RUN |
| CLAMP-06 | Safe force balance before release and independent fresh-start behavior | UNKNOWN |
| CLAMP-07 | Personnel guarding, service/LOTO and easy-to-reinstall protective hardware | UNKNOWN |
| CLAMP-08 | Independent fresh evaluation and signed commissioning release | NOT RUN |

If selected inventory proves no such pneumatic clamp, mark conditional **N/A with evidence**. Y1/Y2 independent stopping/holding, hydraulic isolation, guarding and restart still require separate physical proof. No test permitted until G0/G1, approved protected plan, personnel exclusion and residual risk review. G3/G4 NOT AUTHORIZED.
