# 4400 change-control exercise — The 'drop-in' laser replacement

**Learner-facing, not scored blind.** Sources: Fiessler AKAS-5M doc 1581 (2024-02-15) and AKAS LC-5M doc 1910 (2021-07-30), see `../research/4400_AKAS5M_VS_LC5M_VARIANT_TRANSFER_TRAP_2026-10-23.md`.

A maintenance technician proposes replacing an AKAS-5M with an AKAS LC-5M because both appear to use `OSSD1/2`, `SGS/SGO`, `SP/SSP`, and `HUSP` (although the LC-5M box-mode page also uses `KAST` terminology). A startup check shows no controller alarm. The operator wants to resume box bending immediately.

**Required written answer:** Determine whether matching signal labels and an alarm-free startup establish safety-function equivalence. Cite the two manufacturers' exact receiver sets, flat-bend blanking sequences and overrun figures *only as model-specific evidence*. Identify the minimum `CHG/DEP/PHY/SRS/AUTH/VAL/PT` entries made STALE by the replacement. Explain why even a green OSSD does not prove the newly configured physical protective zone. Propose a safer procurement/service pattern that avoids incentivizing a hurried bypass.

**No-test decision:** With exact machine wiring, selected product compatibility, tool geometry, speed/stop/holding witnesses and safety-related control integration UNKNOWN, block personnel-exposed operation. No live test is authorized by this worksheet. Independent qualified revalidation is necessary, not just a successful LinuxCNC status read or a generic manufacturer's product-page claim.
