# 4400 — MSR57P safely limited speed reset can interrupt the monitoring delay
**2026-10-25 | Official manufacturer-indexed manual excerpt; full original PDF NOT independently opened | Evidence limited**

## Question
Can an operator or automation reset a safely limited speed (SLS) request **before** the configured monitoring-delay period expires, thereby allowing normal speed to return? Is the SLS reset itself a new machine start?

## Source and inspection limitation
Rockwell Automation, *MSR57P Guardmaster Speed Monitoring Safety Relay User Manual*, publication **440R-UM004D-EN-P, December 2022**, Chapter 7, **printed page 80**:
https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um004_-en-p.pdf
Official product family page:
https://www.rockwellautomation.com/en-us/products/hardware/safety-products/safety-relays-speed.html

The official PDF is about 11.8 MB; the document reader rejected full open for size and a direct download failed. The official search-indexed **page-80 text** was available and inspected. Therefore this is **DOC-CONFIRMED only at manufacturer-indexed excerpt strength**, not an assertion that the entire original manual was examined. Product revisions and other chapter requirements remain UNKNOWN. Do not generalize these reset rules to Pilz/SICK or selected OpenPressBrake.

## Specific indexed manufacturer statements
- SLS reset is a **transition out of SLS monitoring**; when completed, the relay no longer enforces the configured limited-speed restriction and the guard door locks (according to the indexed chapter).
- SLS reset can be requested **during** the configured SLS Monitoring Delay; when so requested, the reset **does not wait** for the delay to finish.
- **Automatic** reset: with SLS_In closed, the relay permits return to normal operating speed **without a separate reset button**.
- **Manual** reset: the relay checks SLS_In transition and Reset_In level; it can wait for Reset_In to turn on.
- **Manual monitored** reset: the indexed text specifies an OFF–ON–OFF Reset_In sequence following the SLS_In change.
- These are **product-state transitions**, not proof of absence of people, fresh CNC start, stopped motion, drive torque removal, mechanical holding or electrical isolation.

## Adversarial fault path (INFERENCE)
A guard-open setup sequence requests reduced speed; SLS monitor is in its delay window while the ordinary drive decelerates. A wired selector, guard-closure signal or automated reset changes SLS_In; the monitor can leave SLS before the delay expires and restore permission for full speed. If LinuxCNC retains a command, or a guard/occupancy state is stale, a human may encounter motion faster than expected. **This is a design-review scenario, not proof that the exact sequence is possible in an installed machine.** The selected actual relay configuration, all interlocks, fault behavior and physical state must be traced.

## Practical design discriminators
1. Draw independent state transitions: setup requested → monitored reduction pending → SLS active → SLS reset → normal-speed permitted → *new* machine start.
2. Require a qualified review of **who may request SLS reset**, guard/occupancy state, safety controller input truth, and whether an old CNC demand can resume.
3. Treat monitoring delay as a potentially unprotected transition until the selected OEM manual and risk assessment prove otherwise; do not infer a generic delay budget or safe access point.
4. Separate speed monitor reset, safety-controller rearm, machine cycle start and physical load holding.
5. Prefer intuitive, visible setup controls, manual fresh start and guards that can be reinstalled without nuisance; do not normalize bypass to speed up recovery.

## Evidence ledger
**SOURCE-CONFIRMED:** none. **DOC-CONFIRMED (manufacturer-indexed excerpt only):** page-80 reset modes and during-delay statement; manufacturer product family identification. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **INFERENCE:** failure path and design discriminators. **UNKNOWN:** full manual context, selected MSR57P installation, exact SLS wiring, stop/hold/guard/restart, PL/SIL, measured response. G0/G1 HOLD, G3/G4 NOT AUTHORIZED. No hazardous machine test or new lab compute. Full original PDF should be obtained before treating this as a frozen device-specific commissioning instruction.
