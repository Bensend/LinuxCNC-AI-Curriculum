# 4400 TOOL-LOAD-03 — Six load-path transfer cases (PUBLIC / UNSCORED)
**2026-10-26 | Six paper scenarios UNSCORED | Eight documentary gates NOT RUN | Not a force-calculation or bending authorization**

Read [manufacturer load/height/variant audit](../research/4400_TOOL_LOAD_03_WILA_LOCAL_TOOL_LOAD_DISTRIBUTION_AND_VERTICAL_HANDLING_SOURCE_AUDIT_2026-10-26.md) after [TOOL-RET-01 retention module](4400_TOOL_RET_01_TOOL_RETENTION_PRESSURE_LOSS_ROLLOUT_AND_FRESH_RESTART_FIELD_MODULE_2026-10-26.md).

| Case | Prompt | Discriminator |
|---|---|---|
| LOAD-P01 | A press is rated 170 tons and the 100-mm punch is rated in kN/m. | Separate press-wide capacity, tool local capacity and load distribution; no unsupported unit conversion. |
| LOAD-P02 | A 100-mm segment is rated 1,000 kN/m under evenly distributed load; shop assumes it can accept 1,000 kN on its tip. | Manufacturer example yields 100 kN only for the specified evenly distributed case; reject point-load transfer. |
| LOAD-P03 | Two same-height punches have WILA labels 80 ton/m and 130 ton/m. | Exact variant/length/holder/adapter and actual force path; same height is not same capacity. |
| LOAD-P04 | A horned tool contacts at its edge and the software predicts safe overall tonnage. | Local bending/contact concentration, selected OEM application limits and physical guard. |
| LOAD-P05 | A 515-mm tool has Safety-Clicks and a technician assumes vertical extraction. | OEM BIU-031 example requires horizontal change; physical clearance and selected instructions govern. |
| LOAD-P06 | A new extender raises the punch while controller recipe/guard geometry are unchanged. | CHG invalidates stack height, access, load and retention/ram stop evidence. |

### Eight documentary gates — all NOT RUN
1. **LOAD-G01** selected machine model, capacity and exact current source;
2. **LOAD-G02** selected punch/die ID, geometry, length, segment and local rating;
3. **LOAD-G03** selected holder/adapter/extender capacity and approved load path;
4. **LOAD-G04** actual bend force and distribution basis, with uncertainty and applicable OEM derating;
5. **LOAD-G05** handling geometry, safe tool support, horizontal/vertical change and roll-out protection;
6. **LOAD-G06** workpiece whip/projectile/fragment containment and guard coverage;
7. **LOAD-G07** independent ram stop/hold, setup energy isolation and fresh restart;
8. **LOAD-G08** qualified calculation, inspection, validation, change-control and reviewer signoff.

All are **paper/documentary** tasks, not a request to press a test coupon or overload tooling. A real force calculation needs selected machine/tool/material/geometry and qualified engineering. `LinuxCNC ready`, a simulated bend and a green tool-location LED are not physical safety witnesses. No external evaluation, machine tests or compute. **G0/G1 HOLD**.