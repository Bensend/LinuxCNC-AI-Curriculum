# 4400 technician card — S3000 unallocated fields, OSSD mode and restart owner

**Paper-only exercise, 2026-10-24.** Read [S3000 OEM source adjudication](../research/4400_SICK_S3000_EFI_UNALLOCATED_FIELD_CLEAR_AND_OSSD_BIT_INTEGRATION_TRAPS_2026-10-24.md) and original SICK manual 8009942/ZE09/2026-09-09 pp. 20, 93, 98–101: https://www.sick.com/media/docs/3/63/863/operating_instructions_s3000_safety_laser_scanner_en_im0011863.pdf .

## Source-scoped decision table

| Selected S3000 configuration | OEM-documented signal meaning | Safe documentary conclusion |
|---|---|---|
| Allocated protective field | EFI field bit **1 clear, 0 interrupted** | Validate allocation, inversion and safety PLC logic. |
| **Unallocated** protective field | Initially **1 clear** | Do not infer 'unused means blocked'; SICK instructs **Transfer unallocated fields as interrupted** for field-status evaluation. |
| Local OSSDs **not used** | EFI OSSD state always **active** | **Do not** use that bit for safety-related functions; use evaluated protective-field statuses and PLC-side interlock. |
| Dual protective fields | Field 2 does **not** switch scanner local OSSDs | Route field 2 cut-off over EFI to independent external OSSD pair. |
| Scanner internal restart + raw field status in PLC | Scanner interlock does **not** govern raw field status | Implement/validate PLC-side restart interlock. |
| Warning field | Not a personnel protective field | Pre-warning is not safety stop or occupancy proof. |

## Ten novel cases to reason through, not live-test

1. `UF-01` Field status is high with nobody present; identify **allocated versus unallocated** before claiming health.
2. `UF-02` S3000 external OSSDs selected and EFI OSSD bit is high while an obstacle blocks field; identify why this bit cannot be the safety authority.
3. `UF-03` A second protective field is added to a dual mode without a second cut-off path; identify missing safety output.
4. `UF-04` A warning field lights a lamp before a worker enters the rear; explain why the lamp cannot count as protective stop.
5. `UF-05` A scanner local reset holds OSSD OFF, yet Flexi Soft using raw field status returns ready; locate the missing interlock.
6. `UF-06` A new field set is imported but safety PLC logic refers to an old field index; require versioned allocation review and physical revalidation.
7. `UF-07` A rear access scan is moved behind a cart; examine blind zones and deliberate restart.
8. `UF-08` A machine uses fixed fence/monitored door and no S3000; mark scanner-specific risk **NOT APPLICABLE**, still inspect actual rear safety.
9. `UF-09` Someone claims TRUMPF backgauge STO means a gravity-loaded R axis cannot drift; separate STO from mechanical holding.
10. `UF-10` Remote HMI reads scanner diagnostic green after power restoration; require independent physical zone inspection, local reset and separate new start.

For each: record `BND → HAZ → SF → ARC → DEP → PHY → VAL/PT`, exact manufacturer edition, **which signal is consumed**, interlock location, output/final element, physical witness and UNKNOWNs. `UF-01..10 PAPER ONLY`. No self-scored external evaluation, no scanner numerical transfer, no selected-machine test. Do not operate with people exposed absent a demonstrated minimum safety threshold.

**Additional paper adversarial cases (source §4.3.3 / §7.8.2):** `UF-11` A mode changes to a different protective field after the moving hazard already reaches the new region; identify missing case-switch timing/overlap proof. `UF-12` A complementary input pair reads 1/1 after a wiring change; identify invalid-state fault semantics rather than treating it as 'mode enabled'. `UF-13` A 1-of-n selector reads all zero after cable disconnection; manufacturer defines this as an error, not an intentionally permissive mode. These are **paper-only**, no physical fault injection. Total `UF-01..13`.
