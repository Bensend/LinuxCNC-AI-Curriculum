# Safety Replacement-Part / Equivalence Validation Worksheet

## Purpose

A replacement part is not safety-equivalent merely because it fits, has the same nominal voltage/current, accepts the same command, or is advertised as a successor. This worksheet treats replacement as a bounded safety change and asks what credited safety claims must be re-established before exposed operation resumes.

## Evidence labels

Use only: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

A safety-critical `UNKNOWN` leaves the affected operating state **NOT CLEARED**.

## Frozen principle

> Replace by safety function and verified behavior, not by connector fit or nominal electrical rating.

Manufacturer evidence supports this boundary. SICK requires validation after component replacement and after changes to mounting, alignment, electrical connection, configuration, or the safety function. Flexi Soft can automatically recover configuration only for replacement EFI devices of the same type; connected devices retain their own configuration/verification mechanisms. A manufacturer's listed successor can therefore be a useful engineering candidate without being automatic proof of application-level safety equivalence.

## 1. Change record

| Item | Record |
|---|---|
| Machine / asset | |
| Safety function(s) affected | |
| Removed manufacturer / exact MPN / revision | |
| Installed manufacturer / exact MPN / revision | |
| Reason for replacement | |
| Manufacturer-declared direct replacement? | YES / NO / UNKNOWN |
| Manufacturer-declared engineering replacement? | YES / NO / UNKNOWN |
| Physical wiring/plumbing/configuration changed? | YES / NO / UNKNOWN |
| Validated baseline before change | |
| Person performing verification | |

Do not translate `engineering replacement` into `drop-in safety equivalent` without application evidence.

## 2. Equivalence dimensions

For every credited safety function affected, reconcile all applicable rows.

| Dimension | Old | New | Evidence | Result |
|---|---|---|---|---|
| Intended safety use/function | | | | |
| Supply/coil/actuation requirements | | | | |
| Safe/output state on loss of power | | | | |
| Contact/output arrangement | | | | |
| Positive-guided / mirror feedback behavior where credited | | | | |
| EDM/feedback contact state and timing assumptions | | | | |
| Switching/load utilization category | | | | |
| Short-circuit/fusing/protection coordination | | | | |
| Environmental limits | | | | |
| Mechanical mounting and actuator geometry | | | | |
| Connector/pin/channel identity | | | | |
| Diagnostic behavior / test pulses / discrepancy detection | | | | |
| Restart/reset behavior | | | | |
| Configuration identity / signature / CRC | | | | |
| Network/safety-device identity | | | | |
| Response-time contribution where the machine design credits it | | | | |
| Certification / claimed safety characteristics actually required by design | | | | |
| Failure behavior relevant to the hazard | | | | |
| Common-cause dependencies introduced/removed | | | | |

Do not invent PL/SIL/DC, response times, stopping distances, hydraulic thresholds, or diagnostic coverage. Obtain the application requirement and component evidence or mark `UNKNOWN`.

## 3. Component-specific challenges

### Safety contactor / relay

Check coil voltage and drive compatibility; pole/contact topology; mechanically linked or mirror feedback contacts where credited; EDM polarity and physical independence; load/utilization category; fuse/SCCR coordination where relevant; release behavior; auxiliary-contact assignment; terminal mapping; and whether the existing EDM test actually detects a welded/stuck new device.

A manufacturer's catalog may explicitly call a newer contactor an **Engineering Replacement**. That is evidence for candidate selection, not proof that the machine's EDM, protection coordination, wiring, or achieved safety function remains valid.

### Hydraulic / pneumatic safety valve

Check exact valve function and normal/de-energized state; porting and spool/poppet arrangement; monitored position switch behavior; connector/pinout; pressure/flow/envelope requirements established by the machine design; contamination/filtration assumptions; response behavior if credited; redundant architecture; trapped/stored energy effects; and the physical hazard-control result.

Never infer a hydraulic truth table from coil voltage, valve footprint, or a similar catalog symbol.

### Drive / STO / safe-motion device

Check exact safe functions used; safe-input electrical behavior; dual-channel/test-pulse compatibility; parameter/configuration transfer; motor/feedback compatibility; safe-motion sensors; reaction behavior; reset/restart behavior; safety signature/checksum; and whether replacing the drive changes stopping or coast behavior that the risk reduction depends upon.

STO is not electrical isolation and a successful STO input test is not proof that all hazardous energy is absent.

### Safety I/O / controller / relay

Check hardware type/revision compatibility; firmware compatibility; channel type; test-pulse behavior; discrepancy timing; configuration ownership/identity; safety signature/CRC; network identity; output characteristics; restart behavior; and any automatic configuration-recovery feature.

Automatic configuration recovery is not automatic application revalidation.

### Protective device / guard switch / scanner / light curtain

Check protective field/geometry; resolution/range; mounting; alignment; response time if credited; OSSD/interface behavior; EDM/restart interlock options; coding/actuator compatibility; muting/blanking/configuration; defeat resistance; and required safety distance from the actual machine stopping performance.

### Sensor / encoder used by a safety function

Check measurement principle; resolution; direction; scaling; supply; signal electrical format; diagnostic coverage actually credited; mounting/coupling; common-cause independence from the second channel; plausibility limits; and safe-motion configuration.

### Safety/control power supply

Check output voltage/tolerance; current/inrush; protective coordination; hold-up/restart behavior; grounding/isolation; diagnostics; output fault modes; and whether both nominally redundant safety channels now share a new common-cause supply dependency.

## 4. Configuration and identity gate

Before energization, establish:

- physical installed MPN/revision matches the change record;
- safety-controller/project hardware configuration matches installed hardware;
- any device-local configuration is transferred and verified using that device's prescribed mechanism;
- configuration CRC/signature/readback is recorded where available;
- LinuxCNC/HAL/FPGA normal-control mappings are reconciled if connector/channel identity changed;
- safety feedback is not synthesized or masked in ordinary LinuxCNC/FPGA logic;
- drawings/BOM/spares list are updated so the next maintainer does not reinstall the obsolete assumption.

## 5. Revalidation scope decision

Classify each affected safety claim:

- `UNCHANGED — EVIDENCE CLOSED`: replacement demonstrably leaves the credited claim unchanged.
- `RETEST REQUIRED`: physical/configuration/diagnostic behavior must be challenged.
- `REDESIGN / RECALCULATION REQUIRED`: a design assumption changed.
- `UNKNOWN — NOT CLEARED`: evidence is insufficient.

Replacement is not a reason to reduce the test scope to “machine runs.” At minimum, challenge each affected protective demand, safety logic path, final element, feedback/EDM path, actual energy-control effect, reset/restart behavior, and relevant power-loss/restoration state.

## 6. Bounded functional validation

Where practical, begin with hazardous actuator energy withheld. Then use the commissioning package to prove the affected chain. Examples:

1. demand each affected protective device separately;
2. verify safety logic/output state;
3. verify the replacement final element physically changes state;
4. verify feedback/EDM agrees and fails closed when deliberately contradicted by a safe test method;
5. verify the actual hazardous-energy path is controlled as intended;
6. verify reset does not itself initiate hazardous motion;
7. verify stale ordinary-control commands do not become effective on rearm/recovery;
8. verify power loss/restoration and communications recovery do not create automatic hazardous restart;
9. reconcile temporary jumpers, forces, test plugs, blocks and bypasses before return to service.

## 7. Human-factors / spare-parts gate

A correct replacement process must be easier than an improvised bypass. Keep the approved exact part or a documented validated replacement in the spare-parts record where practical. If a long-obsolete component routinely forces technicians to improvise, treat that as an engineering-maintainability defect and create a controlled modernization path.

Do not leave a machine in a tempting half-working state. If the replacement cannot be validated, keep the affected state unmistakably **OUT OF SERVICE / DO NOT OPERATE** and physically control the relevant hazards.

## 8. Return-to-service disposition

| Gate | Status |
|---|---|
| Exact installed identity verified | |
| Application requirements reconciled | |
| Configuration/CRC/signature reconciled | |
| Wiring/plumbing/mechanical installation verified | |
| Final-element physical behavior tested | |
| EDM/feedback integrity tested | |
| Actual energy-control effect tested | |
| Restart/rearm/restoration tested | |
| CCF/latent-failure impact reviewed | |
| Drawings/BOM/spares updated | |
| Temporary service conditions reconciled | |
| Safety-critical UNKNOWNs closed | |

Final disposition: `CLEARED FOR DEFINED OPERATING STATE` / `LIMITED TEST ONLY — ISOLATED/REMOTE` / `OUT OF SERVICE`.

## Source notes

- SICK Safeguard Detector operating instructions: validation is required after replacing components and after relevant configuration, mounting, alignment or electrical changes.
- SICK Flexi Soft hardware operating instructions: the system plug retains the controller-system configuration; replacement expansion modules/gateways do not inherently require reconfiguration, and Automatic Configuration Recovery can reconfigure EFI-enabled devices **of the same type**. Connected devices may have separate configuration and verification mechanisms.
- Rockwell Automation product lifecycle pages distinguish a discontinued safety contactor's listed **Engineering Replacement** from the old device and expose concrete electrical/contact/protection attributes that must be reconciled at application level.
- Pilz PNOZ s30 documentation demonstrates that even configuration compatibility across device versions can require an explicit configuration upgrade and can produce a new CRC; configuration identity is therefore part of replacement evidence, not a cosmetic detail.
