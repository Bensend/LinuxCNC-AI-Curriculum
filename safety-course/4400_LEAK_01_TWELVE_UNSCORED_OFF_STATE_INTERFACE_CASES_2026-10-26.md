# LEAK-01 — Twelve public adversarial technician cases (UNSCORED)
**2026-10-26 | PAPER ONLY | No hidden answers, no physical tests**

For each case: identify the hazard, the **exact** missing device evidence, what the diagnostic/command does **not** prove, which independent physical safety function is needed, and why G0/G1 remains HOLD. Do not invent numbers or provide a bypass procedure.

1. PLC relay contact reports open; a documented RC snubber is wired across it; downstream CLOSE input is high impedance. What could still be energized?
2. Solid-state OFF output has nonzero manufacturer leakage; receiver OFF threshold is absent from the drawing. What remains UNKNOWN?
3. A proposed interposing relay solves one input-compatibility issue. Does that alone establish a safety-rated stop?
4. Coil suppression is moved from directly across the load to across an opening command contact. What electrical failure path must be reconsidered?
5. Technician removes all surge suppression to make an LED go dark. What new reliability issue might that create?
6. Schmersal AES 2335 UE contact is used to switch a microampere-level input; catalog states minimum 10 mA. What exact interface qualification is missing?
7. Maintenance replaces a discontinued relay with a pin-compatible model. Which minimum-load, AC/DC utilization, diagnostics and timing properties require re-review?
8. An electrically held contactor uses a maintained two-wire CLOSE command at power restoration. What prevents uncommanded hazardous restart?
9. An OEM power-up protection DIP setting was disabled years ago. Does a clean power-cycle log validate the safety function?
10. A controller output is OFF but a programmed undervoltage time delay holds a contactor closed. Which stop-time and final-element assumptions are unresolved?
11. Contactor auxiliary feedback reports open while an independent hydraulic load is gravity-loaded. Which physical evidence is still needed?
12. A healthy Ethernet/FPGA/HAL diagnostic and safe PLC output are shown, but no qualified Y1/Y2 stop or hold witness exists. Which gate disposition is defensible?

**Scoring:** none performed. No answer key, expected result or sealed oracle is supplied. A fresh evaluator must create unseen cases independently after learner commitment. No selected-machine evidence or release.
