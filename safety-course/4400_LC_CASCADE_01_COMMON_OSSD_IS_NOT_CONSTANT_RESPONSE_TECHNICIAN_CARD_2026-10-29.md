# 4400-LC-CASCADE-01 — One OSSD pair does not mean one sensor's response time

**2026-10-29 | UNSCORED PAPER TRANSFER | NO LIVE MACHINE TEST**

Read [Rockwell GuardShield Micro 400 Jan 2024 original-manual timing investigation](../research/4400_LC_CASCADE_01_ROCKWELL_MICRO400_CASCADED_RESPONSE_BLANKING_CONFIG_AND_SAFETY_DISTANCE_OEM_AUDIT_2026-10-29.md) after 2590 and the [LC-REFLECT-01 optical change lesson](4400_LC_REFLECT_01_REFLECTIVE_SURFACE_WELD_SHIELD_AND_SECOND_CURTAIN_FIELD_CARD_2026-10-29.md).

**LC-C1 — front curtain works; add rear curtain with common OSSDs.** The Rockwell Micro 400 manual states cascaded segments' response times **add**; shared OSSDs do not erase added delay. Treat it as a `CHG` that invalidates stale response/separation evidence until revalidated.

**LC-C2 — copy the original sensor's 26.3-ms label into the safety worksheet.** The manufacturer's **example**, not your machine, has 41.9 + 18.5 + 26.3 = **86.7 ms**, **plus controller/extension time `tC`**. Using 26.3 alone omits **60.4 ms + tC** in this example. Do not convert that to a machine-specific safety distance without actual machine data.

**LC-C3 — enable MSR42 fixed/floating blanking to feed material.** OEM says blanking changes both **effective resolution** and **response time**; use the new longer time/larger resolution in a revised safety-distance calculation and update the configuration label. A healthy OSSD does not prove the previous validation is still valid.

**LC-C4 — installer sees green OSSD and says the machine is safe.** Not sufficient: verify selected protective geometry, controller/OSSD chain, independent safety logic, final elements, actual physical stop/hold, zone-clear, deliberate reset and separate fresh start.

**LC-C5 — "we'll test by reaching through the field during a cycle."** Prohibited. Paper inventory only. A qualified independent commissioning plan must establish physical exclusion, energy isolation, suitable nonhuman test means, final-element witness and explicit residual risk before any physical validation.

**Passive evidence request:** existing dated sensor BOM and model suffixes, number/order of segments, cable lengths, controller type and configuration export, blanking/muting/stop-delay settings, actual response/resolution labels, last stop-time/geometry evidence and change-control record. Do not open a cabinet, operate equipment, defeat a safeguard or interrupt a live field to fill this worksheet.

**Status:** Rockwell original manual **DOC-CONFIRMED**; arithmetic independently checked; selected machine **UNKNOWN**, **TEST-CONFIRMED none**. **G0/G1 HOLD; external evaluator OPEN; no personnel-exposed hazardous operation.**