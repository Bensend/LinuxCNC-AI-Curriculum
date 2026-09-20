# Siemens safety-hardware replacement complete acceptance and physical-axis mapping trace

Date: 2026-09-20

## Question

After a safety-related drive/module replacement, what does an authoritative manufacturer require beyond acknowledging the new hardware and restoring configuration?

## Manufacturer evidence

### Hardware acknowledgement explicitly does not equal acceptance

**DOC-CONFIRMED.** Siemens SINUMERIK 828D Safety Integrated documentation describes alarm `27035` as `new hardware component, confirmation and functional test required`. The `Acknowledge SI HW` workflow requires the user to confirm that a complete Safety Integrated function test will be performed for drives with replaced safety hardware.

For sensor-module or DRIVE-CLiQ motor replacement, Siemens specifically calls for:

- recalibration of the actual-value encoder;
- checking Safety Integrated actual-value acquisition, including speeds, traversing direction and absolute position where required;
- documenting new checksum values;
- documenting hardware/software versions.

For TM54F terminal-module replacement, Siemens calls for testing selection of safety functions and functionally testing forced dormant-error detection. The acknowledgement then initiates a warm restart, after which Siemens directs the user to perform the complete Safety Integrated function test and acceptance report.

Source: Siemens, `Safety Integrated Function Manual`, 08/2018, section 7.8 `Acknowledging hardware replacement`, document `6FC5397-3EP40-6BA1`: https://support.industry.siemens.com/cs/attachments/109761936/828D_SI_fct_man_0818_en-US.pdf

This establishes:

**NEW HARDWARE ACKNOWLEDGED != FUNCTION TEST COMPLETE != ACCEPTANCE REPORT COMPLETE != PRODUCTION AUTHORITY.**

**CHECKSUM RECORDED != PHYSICAL AXIS MAPPING PROVED.**

### Acceptance after replacement deliberately moves the axis

**DOC-CONFIRMED.** The same Siemens acceptance-test material requires, after component replacement, switching the system on and briefly operating the affected axis in both directions for actual-value sensing. With motion-monitoring safety functions activated, the drive is again moved in both directions to test safety-relevant actual-value acquisition. The acceptance content also includes checking safety input/output signals, testing new safety functionality, checking checksums/software versions and completing a commissioning-status report with appropriate counter-signatures.

Source: Siemens, `Safety Integrated Function Manual`, acceptance-test section: https://cache.industry.siemens.com/dl/files/936/109761936/att_966541/v1/828D_SI_fct_man_0818_en-US.pdf

This is a direct physical mapping witness. A configuration database may say an encoder belongs to Axis X; deliberately moving the real axis in both directions and checking safety-relevant actual-value sensing challenges that mapping in the installed machine.

Freeze:

**SAFETY ACTUAL-VALUE CHANNEL CONFIGURED != CORRECT PHYSICAL AXIS CONNECTED != DIRECTION CORRECT != SAFETY MONITORING RESPONSE ACCEPTED.**

### Validation is broader than a reboot

**DOC-CONFIRMED.** Siemens separates the hardware acknowledgement/reset from the later complete function test and acceptance report. The restart is therefore an intermediate lifecycle event, not proof of successful safety commissioning.

Freeze:

**WARM START SUCCEEDED != SAFETY FUNCTION REVALIDATED.**

**NO ACTIVE REPLACEMENT ALARM != ACCEPTANCE COMPLETE.**

## Relation to Lane B networked-I/O work

Lane B is studying safety-network identity, ownership/configuration and wrong-station/wrong-channel risk. This Siemens trace intentionally covers a different layer: **post-replacement physical motion/actual-value mapping and complete acceptance**. The two studies are complementary rather than duplicates.

A useful combined evidence ladder is:

1. replacement device identity/type/address/configuration ownership correct;
2. safety configuration/checksum/version recorded and verified;
3. physical sensor/axis mapping deliberately challenged;
4. safety-relevant actual-value direction and behavior observed;
5. affected safety functions functionally tested;
6. acceptance report completed;
7. only then may the machine-specific production-return process proceed.

Items 1-2 are configuration/identity evidence; 3-5 are functional/physical evidence. Neither layer substitutes for the other.

## What this still does not prove

The inspected Siemens material does not, in the cited replacement sequence, provide one universal `fresh production START` challenge after the acceptance report. Therefore:

- **fresh production START after replacement acceptance:** **UNKNOWN** from this source;
- machine-specific reset/rearm sequence: **UNKNOWN**;
- OpenPressBrake hydraulic final-element behavior: **UNKNOWN**;
- machine-specific safe speeds, stopping distances, PL/SIL and acceptance tolerances: **UNKNOWN**.

Do not synthesize these missing details into Siemens's procedure.

## Curriculum return-to-service contract

**INFERENCE grounded in Siemens + ABB evidence:** replacement acceptance should be modeled as a set of evidence layers, not as a single boolean:

`replacement identity/configuration -> physical mapping -> safety-function challenge -> final-element/physical response -> quantitative acceptance where applicable -> documented acceptance -> reset/rearm -> fresh ordinary start`.

If a layer is not applicable, record why. If a layer is applicable but untested, production authority must not be inferred from an upstream green status.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC/HAL and the normal FPGA can assist with axis motion, diagnostic capture and acceptance records only where the safety plan permits. They do not become independent safety authority by participating in the test. The safety-related sensing/logic/final-element chain and its physical acceptance retain separate provenance.

## Next work

The replacement branch now has strong authoritative evidence for configuration/version/checksum plus physical bidirectional axis mapping and complete acceptance after replacement. The remaining narrow gap is the explicit final transition from accepted safety functions through reset/rearm to a **fresh ordinary production START**. Search for that only if a manufacturer/OEM acceptance record appears likely to add it; otherwise rotate to another safety branch.

## Compute

No simulation/build/test compute was justified. No GitHub-hosted runner was used.
