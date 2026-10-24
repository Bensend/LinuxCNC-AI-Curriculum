# 4400-ESPE-02 — Blanking, effective resolution and late detection: 16 technician challenges
**2026-10-24 | PAPER ONLY / NOT A PHYSICAL TEST / NOT AN INDEPENDENT BLIND SCORE**

**Task for each case:** State (a) what the visible indication actually proves, (b) what remains hazardous, (c) the exact source/configuration evidence needed, (d) the independent final-element/physical safe-state witness, and (e) the permitted next action. Distinguish **DOC-CONFIRMED** product facts from **INFERENCE** and selected-machine **UNKNOWN**. Do not invent stop time, PL/SIL, geometry or thresholds.

| Case | Situation to analyze | Specific discrimination required |
|---|---|---|
| BL-01 | SICK C4000 Advanced 2016, monitored fixed blanking; fixture removed and OSSD red. | Is object-presence checking the same as closing reach gaps? |
| BL-02 | Same fixture leaves a 25 mm gap beside a roller while present. | Which physical aperture remains outside the beam protection? No numeric finger-protection conclusion from gap alone. |
| BL-03 | C4000 floating region uses **partial** object monitoring; fixture removed, green persists. | Does this mode require object occupancy? |
| BL-04 | C4000 floating **complete** object monitoring; smaller substitute object. | What tolerance and size evidence determine the expected output? |
| BL-05 | 14 mm physical C4000, one-beam reduced-resolution setting. | What is the OEM example's effective resolution and which test rod is required? |
| BL-06 | Technician uses 14 mm rod after reduced resolution to 22 mm. | Why is nameplate-only inspection inadequate? |
| BL-07 | Fixed blanking position tolerance changed; size tolerance unchanged. | Why must positional and size tolerance not be treated identically? |
| BL-08 | New floating blanking -2-beam size tolerance; operator assumes unchanged minimum distance. | What does OEM say about edge effective resolution and recalculation? |
| BL-09 | Tooling update shifts a metal flange next to a blanked region. | What `CHG` and physical reach-around review is triggered? |
| BL-10 | One sub-area of blanked field tested red; second untested. | What does OEM §7.3.3 require across all protected sub-areas? |
| BL-11 | Safety PLC receives valid OSSD OFF, but hydraulic beam keeps moving. | Why does signal state not prove final stop or gravity hold? |
| BL-12 | PLC restores permissive on field clear while LinuxCNC retains cycle demand. | Separate reset, rearm and fresh-start propositions. |
| BL-13 | Team copies 1910.217 mechanical press muting rule onto a hydraulic press brake. | Which explicit OSHA exclusion applies and what general guarding duty remains? |
| BL-14 | Proposed laser line is immediately beneath the upper die; a hand is detected only at pinch entry. | Why is detection timing more important than the sensor's “safety” label? |
| BL-15 | Production claims 1997 OSHA “4 inches” is an optical safety-distance setting. | Distinguish narrow work-practice exception from measured sensor-to-hazard protective separation. |
| BL-16 | A removable hard guard causes slow stock loading, and crew tapes it out of the way. | Redesign for safe normal workflow; reject convenient bypass and prove the physical aperture is closed. |

## Source anchors
- SICK original **8009861/YT64/2016-02-25** §§4.8.1–4.8.3, 4.9, 7.3.3: [OEM source audit](../research/4400_SICK_C4000_BLANKING_OBJECT_MONITORING_EFFECTIVE_RESOLUTION_AUDIT_2026-10-24.md).
- OSHA **1910.217(a)(5)**, **1910.212(a)(3)(ii)**, **1997 CPL 02-01-025** and **2004-02-11 laser interpretation**: [scope/late-detection audit](../research/4400_OSHA_PRESS_BRAKE_VS_MECHANICAL_PRESS_LIGHT_CURTAIN_SCOPE_AND_LATE_DETECTION_AUDIT_2026-10-24.md).
- [Blank physical evidence worksheet](4400_OPTICAL_BLANKING_FIELD_AND_RESTART_BLANK_WITNESS_2026-10-24.md).

## Adversarial review / safe-to-operate threshold
Challenge any answer that credits an OSSD, green LED, single test-rod point, machine-ready HMI, normal FPGA inhibit, or an unmeasured safety-distance example with **personnel-safety physical proof**. If optical gaps, actual stop/hold, inside occupancy or fresh restart are unverified, **NO personnel-exposed operation**. Any experimental operation requires isolated/remote arrangement with people outside the danger zone and explicit residual-risk review. This paper card is not a physical commissioning procedure.

**Status:** `BL-01..16 PAPER ONLY`, `VAL/PT NOT RUN`, `G0/G1 HOLD`, `G3/G4 NOT AUTHORIZED`, external evaluation NOT RUN/SCORED.
