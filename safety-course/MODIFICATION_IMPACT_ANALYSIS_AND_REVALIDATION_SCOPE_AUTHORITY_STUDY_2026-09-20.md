# Modification impact analysis and revalidation-scope authority study

Date: 2026-09-20
Lane: independent safety curriculum Lane B
Course: 4000 safety / professional machine implementation

## Why this branch

The primary lane has just created the four-class validation/return-to-service matrix and an enabling-switch fault-injection/proof-test study. This independent lane therefore does not extend those files or repeat the enabling-device evidence package. It closes a separate lifecycle question: **after a safety-related modification, how is the required revalidation scope chosen without either blindly retesting too little or treating every change as an unsupported full-machine recertification?**

## Evidence labels

- **DOC-CONFIRMED** — explicit manufacturer documentation.
- **SOURCE-CONFIRMED** — primary manufacturer/source material that directly supports the statement.
- **TEST-CONFIRMED** — demonstrated by an actual retained test result. None added in this study.
- **COMMUNITY-REPORTED** — community evidence. None relied upon here.
- **INFERENCE** — engineering conclusion synthesized from confirmed evidence.
- **UNKNOWN** — machine-specific fact not established by available evidence.

## 1. Validation must include the assembled field devices, not just logic

**DOC-CONFIRMED — Rockwell Automation, GuardLogix / FactoryTalk Design Studio validation guidance:**

Rockwell requires a documented set of test cases covering the safety application. Active validation with field devices is required because it is the way to verify that sensors and actuators are wired correctly. The guidance calls for manual manipulation of sensors and actuators, tests of wiring faults and network communication faults, fault routines, I/O channels, and all shutdown functions. It also states that validation is specific to the application tested; moving the application to another installation requires startup and validation in the context of the new sensors, actuators, wiring, networks, and physical control equipment.

Primary source:
https://www.rockwellautomation.com/en-se/docs/factorytalk-design-studio/current/technical-content/ftds-pm001/web_ftds-pm001-ditamap/safety-system-principles/commission-safety-system/validate-project.html

Freeze:

**SAFETY LOGIC TESTED != FIELD WIRING VALIDATED != SENSOR/ACTUATOR MAPPING VALIDATED != COMPLETE SAFETY FUNCTION VALIDATED.**

For LinuxCNC/OpenPressBrake this means HAL/FPGA observation can assist a test record, but ordinary-control telemetry cannot substitute for physically challenging the actual safety sensor and actual final element.

## 2. Modification requires impact analysis before choosing revalidation scope

**DOC-CONFIRMED — Rockwell Automation:**

Rockwell's revalidation guidance says to perform an impact analysis for planned modifications, review relevant firmware/software changes and compatibility, document the impact of modifications/enhancements/adaptations, and select the appropriate level of hardware/software revalidation from that impact analysis. The same guidance notes that unchanged elements need not necessarily be revalidated when the validation plan and safety-signature evidence justify that boundary.

Primary source:
https://www.rockwellautomation.com/en-cz/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-applications/commissioning-lifecycle/validate-the-project.html

Freeze:

**CHANGE MADE != REVALIDATION SCOPE KNOWN.**

and

**UNCHANGED FILE/CODE != UNCHANGED SAFETY FUNCTION.**

A mechanical relocation, wiring reroute, sensor replacement, hydraulic change, drive firmware change, safeguard-field change, or changed stopping performance can invalidate evidence even when the safety program itself is byte-for-byte unchanged.

## 3. Replacement communication/configuration success is not return-to-service authority

**DOC-CONFIRMED — Rockwell Safety I/O replacement guidance:**

Rockwell allows automatic configuration in defined replacement cases, but explicitly requires validation of proper operation before SIL-rated functions are used following I/O replacement. The replacement workflow therefore separates successful network/configuration establishment from functional acceptance.

Primary source:
https://www.rockwellautomation.com/en-ie/docs/factorytalk-design-studio/current/technical-content/ftds-pm001/web_ftds-pm001-ditamap/safety-environment/safety-controller-profile/safety-io-replacement.html

Freeze:

**REPLACEMENT CONNECTED != REPLACEMENT CONFIGURED != PHYSICAL SAFETY FUNCTION VALIDATED != RETURN TO SERVICE.**

This complements, rather than duplicates, the existing safety-network replacement studies: the new lesson is how replacement/change feeds the *scope-selection* gate for revalidation.

## 4. Validation is normal + abnormal operation, not a happy-path demonstration

**SOURCE-CONFIRMED — Rockwell machine-safety lifecycle guidance:**

Rockwell describes validation as a documented process that tests normal and abnormal operation of the safety system. Its validation services explicitly evaluate circuit performance, fault tolerance, fault action, software logic, device application/function, and reset actions across operating modes.

Sources:
https://www.rockwellautomation.com/en-gb/company/news/blogs/machine-safety-on-off.html
https://www.rockwellautomation.com/en-ca/capabilities/industrial-safety-solutions/machine-safety-services.html

Freeze:

**NORMAL DEMAND PASSED != ABNORMAL/FAULT RESPONSE VALIDATED.**

This is consistent with the primary lane's four evidence classes without modifying or duplicating that matrix.

## 5. Revalidation-scope worksheet

The following is an **INFERENCE** scaffold. It does not prescribe OpenPressBrake-specific tests; it determines what evidence must be reconsidered after a change.

| Change | Safety-function boundary to reconsider | Evidence that may be invalidated | Required decision before production |
|---|---|---|---|
| safety sensor/device replacement | physical detection, wiring, channel mapping, diagnostics | normal demand; fault handling; device-specific proof basis | identify affected functions and revalidate actual field device path |
| safety I/O replacement | identity/configuration, wiring, network, output mapping | normal demand; fault/network behavior; physical mapping | validate proper operation before safety-rated use |
| safety controller logic/firmware change | logic, signatures, compatibility, fault routines | logic tests; affected field functions; fault handling | perform documented impact analysis and select justified revalidation scope |
| contactor/drive/final-element replacement | output mapping, EDM/status, physical energy interruption | normal demand; mismatch/fault response; physical stop/energy behavior | prove actual final element and any quantitative performance affected |
| guard/scanner/light-curtain relocation | physical boundary, reach/access path, safety distance | field geometry; stopping-performance/distance relationship | re-establish physical coverage/distance with machine-specific evidence |
| brake/hydraulic/mechanical service | load retention, stop behavior, stored-energy behavior | quantitative physical performance; final-element witness | repeat affected physical acceptance tests; thresholds remain machine-specific |
| ordinary LinuxCNC/HAL/FPGA change | command freshness, mode interface, diagnostics, non-safety interactions | stale-command/restart behavior; interface assumptions | verify ordinary control cannot acquire safety authority or defeat fresh-start boundary |

## 6. Return-to-service decision chain

**INFERENCE**, constrained by the manufacturer evidence above:

`describe change -> identify affected safety functions -> perform impact analysis -> identify previously valid evidence touched by the change -> select justified revalidation tests -> challenge actual sensors/final elements where affected -> include relevant abnormal/fault tests -> repeat affected quantitative physical tests where the change can alter performance -> resolve discrepancies -> restore/requalify safeguards -> document acceptance -> require separate ordinary production start`

Do not collapse this to `maintenance complete -> reset -> run`.

## 7. OpenPressBrake boundary

The following remain **UNKNOWN** until actual design evidence or measurement establishes them:

- which safety controller/network architecture OpenPressBrake will use;
- required PL/SIL/category/DC/CCF;
- stopping-time or stopping-distance limits;
- hydraulic safe-state truth table or pressure thresholds;
- which maintenance actions invalidate which quantitative acceptance tests;
- proof-test intervals;
- exact final-element architecture;
- whether a particular change can be accepted with partial revalidation or requires broader machine revalidation.

No example manufacturer value may be copied into those blanks.

Ordinary LinuxCNC/FPGA control may guide a technician through the worksheet and record observations. It must not decide personnel-safety authority merely because it can see safety status or command state.

## Practical curriculum rule

Teach maintenance/change as an **evidence invalidation problem**. Before touching the machine, know which safety claims the work could invalidate. After the work, re-establish those claims with the appropriate evidence rather than relying on component status, successful communications, or a generic E-stop check.

Strong freeze:

**CHANGE COMPLETE != PREVIOUS VALIDATION STILL VALID != REVALIDATION SCOPE JUSTIFIED != AFFECTED TESTS PASSED != SAFEGUARDS REQUALIFIED != PRODUCTION AUTHORIZED.**

## Compute disposition

No simulation, synthesis, benchmarking, or executable verification was justified for this source-tracing task. No GitHub-hosted runner was used. A future executable lab should run only when a specific question requires it and then only on `[self-hosted, openpressbrake]`.

## Precise next-work checkpoint

Find one authoritative OEM/manufacturer maintenance or modification procedure that names a concrete safety-related change and then traverses the physical return-to-service chain: **change/repair -> affected-function identification -> field-device/final-element test -> representative abnormal/fault challenge where applicable -> quantitative physical recheck where the change can affect performance -> safeguard restoration/requalification -> explicit release for production**.

Prefer a press/press-brake or other high-energy machine. Do not count a generic statement to “test machine operation” as closure. If the primary lane reaches this same evidence package first, rotate Lane B to an independent open branch instead of duplicating it.