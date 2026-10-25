# 4400-MIRROR-01 — Twelve paper cases: replacing a contactor without silently losing EDM
**2026-10-25 | 12 PAPER cases / UNSCORED | No energized experiments**

Use [original Schneider/Siemens manufacturer audit](../research/4400_SCHNEIDER_SIEMENS_MIRROR_NC_VS_GUIDED_AUX_EDM_VARIANT_SOURCE_AUDIT_2026-10-25.md). For each case, identify exact source evidence, power-pole versus auxiliary-contact proposition, fault that may escape diagnosis, next qualified evidence, and HOLD decision.

| Case | Change or failure |
|---|---|
| 01 | A generic NC auxiliary is used as a mirror NC without any exact-part documentation. |
| 02 | A TeSys K 0601 unit is swapped for a similar 0610 family without verifying the mirror contact. |
| 03 | A TeSys Deca base 21–22 NC is replaced with an optional front auxiliary contact of uncertain variant. |
| 04 | A removed auxiliary block is reattached after maintenance without checking mechanical engagement. |
| 05 | A welded main power pole is assumed detected because an ordinary PLC input reads contactor OFF. |
| 06 | An EDM loop is bridged to suppress a fault and left in place at restart. |
| 07 | A manufacturer advertises “positively guided auxiliary contacts”; technician assumes main poles are mirrored. |
| 08 | A manufacturer advertises “mirror NC”; technician assumes every auxiliary NO/NC pair is positively guided. |
| 09 | The contactor coil voltage is changed while keeping a compatible-looking feedback contact. |
| 10 | Two contactors share a common control supply that fails; feedback is green, but stored hydraulic energy remains. |
| 11 | A replacement uses a contactor from the same series but a different exact auxiliary suffix. |
| 12 | The machine's reset lamp is green; Y1/Y2 independent physical holding and hydraulic isolation remain unverified. |

## Blank answer and independent witness
- Case / source document / revision / exact part: __________
- Mirror-to-main-pole relation supported? **YES / NO / UNKNOWN** (source): __________
- Aux-NO-to-aux-NC mechanically linked relation supported? **YES / NO / UNKNOWN**: __________
- EDM wiring, safety logic and bypass status: __________
- Physical stop/hold/energy zones independently proven? __________
- Disposition and missing qualified evidence: __________
- Evaluator/independent result: **NOT RUN**

**Critical failure:** granting personnel-exposed operating release because a contactor carries a “safety” marketing label, because a generic NC exists, or because the ordinary FPGA/LinuxCNC sees an OFF signal. The safe design should make qualified replacement and guard restoration easier than installing a jumper. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. No physical test, independent score, local or hosted compute.
