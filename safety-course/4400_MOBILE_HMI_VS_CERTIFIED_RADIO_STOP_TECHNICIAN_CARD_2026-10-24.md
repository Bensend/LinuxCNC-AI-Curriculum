# 4400-RAD-02 — Mobile HMI versus certified radio STOP (10 PAPER cases)
**Open-book; not blind, not graded, no physical testing.** Read [IEC/FME scope audit](../research/4400_IEC62745_FME_MOBILE_DEVICE_CABLELESS_SAFETY_AUTHORITY_SCOPE_2026-10-24.md) and [RAD-01](4400_RAD_01_WIRELESS_PENDANT_STOP_LINK_LOSS_AND_RESTART_MODULE_2026-10-24.md). For each case identify the independent safety function, normal/diagnostic controls, physical safe state, uncertain evidence, foreseeable bypass and practical lowest-complexity safer design.

1. A Wi-Fi tablet's red STOP button sends `halui.estop.activate`. Is it a qualified machine E-stop? What local device must remain accessible?
2. A browser status page shows radio connected while the physical receiver STOP relay is open. What does the page prove?
3. A web HMI retains a cycle-start button state during network dropout and restores it on reconnection. What must block motion?
4. A tablet is used for press-brake setup inside the hazard zone with the front guard open. Does local Wi-Fi proximity establish enabling/safe speed?
5. An integrator cites FME's 0.5 s connection recommendation as the maximum acceptable total Y1/Y2 stop time. What provenance and physics errors occurred?
6. A certified radio STOP receiver is replaced by a cheap Wi-Fi relay board to save cost, with the same GUI indicators. What safety integrity claim is lost?
7. Two phones are both authorized to jog a mill; one operator cannot see the spindle. How should ownership, visibility and local protection be designed?
8. A tablet battery dies while a robot carries a vacuum-held payload. Is dumping all energy a safe generic response?
9. A local E-stop is pressed, then the remote HMI reconnects and auto-acknowledges the alarm. Which independent reset/start boundary is violated?
10. A machine builder cites the IEC 62745 official abstract as proof of full normative compliance. What exact standards, manufacturer and physical evidence is missing?

**Scoring boundary:** no hidden answer or self-score. This exercise develops source discrimination, not physical machine release.
