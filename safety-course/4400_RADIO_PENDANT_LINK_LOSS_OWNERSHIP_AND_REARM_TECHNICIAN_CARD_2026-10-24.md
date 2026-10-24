# 4400-RAD-01 — Radio pendant technician scenarios (PAPER ONLY)
**16 open-book scenarios; learner-visible, not a blind evaluation.** For each: classify DOC-CONFIRMED / INFERENCE / UNKNOWN, identify ordinary-control vs independent-safety vs physical-hold boundaries, give the safest practical design correction, and state which selected-machine evidence would falsify your claim. No live experiments.

1. A T19-02/R15 installation claims PLd because the red PLd configuration LED is OFF, but stop relays are wired only to a LinuxCNC HAL input. Which downstream function is unproven?
2. The receiver is configured for discontinuous radio mode 5 to extend battery life. Buttons work. What does original R15 v09 say about the PLd STOP function?
3. Link-loss timeout is raised beyond the OEM limit to prevent nuisance stops. What happens to the *claimed configuration* and what must be reviewed before commissioning?
4. A transmitter battery is removed while a loaded vertical ram is held by hydraulics. Why is the OEM's no-load battery-removal check not a safe live test plan?
5. The receiver briefly loses power while the transmitter remains active; Require start is OFF. What receiver behavior does the OEM describe, and why is machine motion restart a separate hazard?
6. Require start is ON, but a CNC program retains a cycle-start demand. Is a radio start packet enough to authorize the cycle?
7. Two transmitters are registered; one is switched OFF but remains logged in. Why can the second transmitter fail to take control? How should custody/transfer work?
8. A lost pendant is replaced using a receiver maintenance menu while a load is suspended. Which hazard boundary and proof are missing?
9. A receiver LED says a radio link exists, but an output contactor is welded. Which independent evidence is required?
10. A normal CAN heartbeat and a GUI stop indicator are both green; a wireless safety stop relay is open. Which signals may control safety final elements?
11. A Scanreco product advertises a 'dump valve' output. Can it be connected to the hydraulic ram valve without a selected safe-state and holding analysis?
12. A remote operator stands behind a large machine without line of sight to the danger zone. Does a certified pendant STOP button replace guarding or occupancy detection?
13. A transmitter is left on a table with a held directional button while another person restores receiver power. What must happen before any new motion?
14. A manufacturer specifies 500 ms maximum **radio safety-stop subsystem** response. Is that the machine stopping distance or acceptable gravity-load hold time?
15. A receiver's ordinary function relay changes on link loss but its two safety STOP relay terminals are not verified. What exactly must be inspected?
16. After a safety configuration update, the pendant controls motion and the receiver PLd LED indicates compliance. What source/readback, independent final-element and physical witness remain required?

**Evaluation discipline:** No official answer key, no hidden oracle, no self-assigned score. Independent novel transfer challenge must be information-separated. This card is suitable for supervised discussion only.
