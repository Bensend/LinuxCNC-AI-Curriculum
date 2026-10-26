# PENDANT-01 — Four connector states, stop authority and restart

**DOCUMENTARY ONLY.** These states apply only to the cited original OEM variants, not all pendants or OpenPressBrake.

| State | Siemens Mobile Panel 170 Basic | Siemens Mobile Panel 170 Plus | Rockwell MobileView with OEM bridge | Required machine-independent review |
|---|---|---|---|---|
| Panel plugged, STOP not pressed | Loop can be closed | Loop can be closed | Bridge not installed in same active port | Qualified active station, guards and independent safety receiver |
| Panel plugged, STOP pressed | Stop circuit opens | Stop circuit opens | Pendant stop when active, not bridge | Physical stop/hold and independent rearm |
| Panel unplugged | Stop loop opens | Stop loop closes automatically; may release prior STOP demand | OEM bridge permits operation without pendant | Fixed E-stop, explicit absence indication, occupancy and fresh restart |
| Replug, reset or change station | Exact device behavior requires review | Prior STOP latch may no longer govern after unplug | Bridge/connector compatibility and restoration need qualified review | Never auto-start; deliberate separate motion authorization |

**DOC-CONFIRMED:** Siemens 09/02 original pp.4-5–4-6; Rockwell 2711T-IN001 and G750 2727-UM002D-EN-P p.2-8. **INFERENCE:** the machine must preserve a separate fresh-rearm/physical-safe-state safety function across station change. **UNKNOWN:** installed machine, stop times, holding, PL/SIL, access coverage. G0/G1 HOLD. No live bypass/test.
