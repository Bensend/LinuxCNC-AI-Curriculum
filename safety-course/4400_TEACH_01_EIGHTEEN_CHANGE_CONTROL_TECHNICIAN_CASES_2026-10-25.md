# 4400-TEACH-01 — 18 open-book technician transfer cases
**2026-10-25 | PAPER ONLY | UNSCORED | NOT BLIND | NOT PHYSICAL TESTS**

Use the [original-OEM audit](../research/4400_SICK_DETEC4_2026_TEACH_IN_AUTO_OSSD_AND_ROCKWELL_MICRO400_RESPONSE_TIME_AUDIT_2026-10-25.md) and [learner module](4400_TEACH_01_PROTECTIVE_OUTPUT_TEACH_IN_AND_RESPONSE_TIME_CHANGE_MODULE_2026-10-25.md). For each case: state the **observed proposition**, **what is not proven**, the **least burdensome safe correction**, the **evidence required to falsify your diagnosis**, and **whether selected-machine operation can be authorized**. No scoring key is exposed or invented.

1. A deTec4 HG DCM4 operator successfully teaches a new table into fixed blanking. The receiver's OSSDs switch ON without a second pushbutton. Which exact OEM configuration can explain this? Does a hydraulic ram necessarily move?
2. A technician performs teach-in with an empty field and then reports the old fixed blanking is gone. Distinguish documented behavior from an undocumented device failure.
3. A safety PLC receives OSSD ON after teach-in while the LinuxCNC cycle-start bit remains asserted from before maintenance. Trace the independent rearm and fresh-command obligations.
4. A blanked table is present and monitored; a narrow side slot admits a hand without breaking an active beam. Which proposition is missing despite valid object detection?
5. A fixed-blanking region has no size tolerance and the SICK documentation says effective resolution is unchanged. Does that mean the blanked aperture detects a finger?
6. A technician widens the allowed size tolerance at a blanked object's edge but uses the original physical-resolution test rod and old safety-distance sheet. Identify stale evidence.
7. A Micro 400/MSR42 retrofit enables blanking and labels only the changed resolution, leaving response time untouched. Identify the additional OEM requirement.
8. Two Micro 400 segments are cascaded through one controller; the installer uses only the fastest segment's response time. What timing contributions are omitted?
9. A replacement receiver has identical wiring but a different stored optical map. Explain why successful communication and green OSSD are not configuration equivalence.
10. A technician wants a frequently changed fixture and proposes repeating teach-in at every job change. Offer a simpler physical arrangement that avoids predictable bypass incentives.
11. The authorized key switch is accessible to untrained staff and the blanking map can change while a helper is behind the light curtain. Which controls and occupancy assumptions are missing?
12. A curtain passes a test rod at the front of the table but a person can reach from the side. Is the rod test sufficient for all access routes?
13. A configured restart interlock keeps OSSDs OFF after teach-in. Is that alone proof of fresh motion command or safe gravity-load holding?
14. A stored sensor configuration changes, but the HMI still shows the last job's expected guard geometry. What should the ordinary HMI display, and who has final authority?
15. The receiver indicates OSSD OFF on a blocked beam; the hydraulic ram continues downward due to a mechanical/valve failure. Separate sensing from stopping and gravity holding.
16. A team cites a mechanical-power-press PSDI clause as binding for a hydraulic press brake. Locate the applicability error and identify the machine-specific standards/guarding review still needed.
17. An installer substitutes a SICK deTec4 model for a Rockwell Micro 400 and copies the Rockwell response-time assumption. What exact documentation/configuration evidence must be reacquired?
18. After a successful documentary review, a manager proposes hands-in-die production before independent stopping/holding and external evaluator evidence. State the operational boundary and safe next step.

**Review status:** All 18 scenarios UNSCORED. No learner responses, test execution, stop-time measurements, evaluator scores or OpenPressBrake acceptance are claimed. Do not self-score these as blind evaluation. The course remains NON-GRADUATED.
