# 4400-RST-01 — Reset and power-return technician reasoning card
**2026-10-24 | 18 learner-visible PAPER scenarios | NOT BLIND / NOT PHYSICAL TEST**

For every case state: (a) what is known versus UNKNOWN, (b) what can energize and when, (c) the shortest discriminating *safe* evidence, (d) whether an independent new start is required, and (e) what forbids personnel-exposed operation. Cite the [original OEM audit](../research/4400_RESET_POWER_RETURN_EDM_WELDED_CONTACTOR_OEM_SOURCE_AUDIT_2026-10-24.md) or [SICK indexed caveat](../research/4400_SICK_EDM_ERROR_RESET_UNEXPECTED_SWITCH_ON_MANUFACTURER_INDEXED_AUDIT_2026-10-24.md) where relevant.

1. Rockwell CI in **AM** mode loses 24 V while all safety inputs and reset loop stay closed; power returns. Does the relay need a new reset edge? Does its output state prove a machine cycle cannot start?
2. The same relay is changed to **MM**, but the reset button is permanently shorted. What event is missing? What else remains unproven?
3. An engineer copies the CI manual's reset timing window into a different safety PLC without reading that PLC's manual. Identify the source-scope error.
4. A PNOZ X3P is wired for automatic start. An E-stop is released. Distinguish relay reactivation from a safe fresh-cycle start.
5. The PNOZ X3P auxiliary contact **41–42** drives a new safety valve. What is wrong with treating this as a safety output?
6. A PLC reports PNOZ X3P **Y32 high** after reset. What does this status fail to establish about the actual Y1/Y2 ram?
7. The PNOZ X3P has been continuously energized for months. What diagnostic limitation does its OEM manual mention? Why is an inspection schedule machine- and product-specific?
8. A contactor is welded shut. The safety relay's next rearm is blocked. Is the currently energized hazard necessarily stopped?
9. EDM feedback is wired to a spare contactor instead of the actual hydraulic pump contactor. The feedback is normal. What topology proof is missing?
10. A Rockwell DI is wired with two input wires but a documented variant without cross-fault detection. Does the phrase 'two channels' establish diagnostic coverage?
11. A guard closes while a technician remains inside the enclosure. Safety inputs turn healthy. Can a reset or rearm alone prove area clear?
12. A maintained foot pedal stays ON through a brownout. LinuxCNC restarts and resumes showing ready. Which independent start-inhibit and physical hold evidence is required?
13. An HMI combines **Clear Fault**, **Safety Reset** and **Start Cycle** into one button to save clicks. Identify at least three independent authority boundaries it collapses.
14. SICK Flexi Soft EDM Control=1 and feedback=0 when Error reset rises. Manufacturer-indexed text warns about an output-enabling consequence. What configuration/source evidence must be checked, and why is this not proof of a particular OpenPressBrake failure?
15. A reset is accepted only when a feedback contact is closed. What kinds of feedback shorts, incorrect contact types and common-cause errors remain possible?
16. A two-contactor circuit drops both coils on an E-stop, but a gravity-loaded ram settles. Why is 'coils deenergized' not the final physical safety proposition?
17. An electrician changes a safety relay from MM to AM to cure nuisance resets. What change-control evidence and human-factors analysis is required before any operation?
18. A new LinuxCNC/FPGA software update changes normal startup commands but not the safety PLC. Which regression evidence is still needed, and which safety authority must remain independent?

## Review criteria (paper only)
An acceptable answer never equates a reset request with a safety proof, a green diagnostic with a final element, an EDM signal with physical energy removal, or a qualified component's rating with a machine-level PL/SIL. It identifies exact product/mode before using timing or fault semantics, rejects invented selected-machine hydraulic values, and refuses personnel exposure without independently validated stop/hold/guard/rearm. These cases may be discussed openly and **must not be scored as blind evaluation**.
