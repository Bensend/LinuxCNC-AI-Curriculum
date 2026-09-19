# Safe Brake Control vs Mechanical Brake Proof — Lane B Study

Date: 2026-09-19
Lane: independent safety curriculum Lane B

## Why this branch

The primary lane is presently advancing press-brake hydraulic startup-test/final-element masking and hydraulic re-proof. This study deliberately uses a different energy domain, different manufacturer evidence, and a new file: drive-integrated Safe Brake Control (SBC) versus actual mechanical holding-brake proof.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly stated by cited manufacturer material.
- **DOC-CONFIRMED** — established by repository/manufacturer documentation but not physically tested here.
- **TEST-CONFIRMED** — established by an executed test with preserved results. None in this study.
- **COMMUNITY-REPORTED** — reported by community material. None relied upon here.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence and labeled as such.
- **UNKNOWN** — not established by the available evidence.

## Architecture freeze

**SBC REQUESTED != BRAKE CONTROL ELECTRICALLY SWITCHED != BRAKE MECHANICALLY APPLIED != BRAKE HOLDS REQUIRED LOAD != LOAD PHYSICALLY RETAINED != BRAKE TEST PASSED != AXIS SAFE FOR PERSONNEL EXPOSURE.**

A safe electrical brake-control path can remove/release electrical brake authority correctly while the mechanical brake itself is worn, contaminated, incorrectly adjusted, undersized, damaged, or otherwise unable to retain the hazardous load. Mechanical retaining capability therefore needs its own proof when the risk reduction depends on it.

## Siemens trace

Source: Siemens, *Safety Integrated Commissioning Manual*, 03/2025, A5E47278158B AL.
https://cache.industry.siemens.com/dl/files/318/109987318/att_1323149/v1/ONE_SI_commis_man_0325_en-US.pdf

**SOURCE-CONFIRMED:** Siemens states SBC brake activation is performed using a safe two-channel method. SBC is executed when STO is selected and electrical faults such as a brake-winding short circuit or wire break can be detected when state changes.

**SOURCE-CONFIRMED:** Siemens explicitly warns that SBC does **not** detect mechanical brake defects and that a defective brake can permit undesirable motor/load motion. Siemens directs the integrator to test the brake with the Safety Integrated **Safe Brake Test (SBT)** diagnostic function.

**INFERENCE:** STO + SBC can therefore be electrically correct while the gravity/load-retention claim remains false. Treating an SBC status bit as `LOAD_RETAINED` would collapse two different evidence layers.

Siemens acceptance-test evidence:
https://support.industry.siemens.com/cs/attachments/109988228/828D_AT_fct_man_0325_en-US.pdf

**SOURCE-CONFIRMED:** Siemens' acceptance-test material separately verifies SBC wiring/hardware/parameterization and its forced checking procedure when SBC is configured. This supports teaching commissioning as a trace through actual configured hardware, not merely observing a software status.

## SEW-EURODRIVE trace

Source: SEW-EURODRIVE, *Brake Test Diagnostics Function with MOVISAFE CS..A*.
https://download.sew-eurodrive.com/download/pdf/27800261.pdf

**SOURCE-CONFIRMED:** Safe Brake Control must be enabled to configure the safe brake test.

Current SEW documentation also exposes the dual-brake boundary:
https://download.sew-eurodrive.com/download/html/33356904/en-EN/4600296525963366640907.html

**SOURCE-CONFIRMED:** When two brakes are part of the safe brake system, both safe outputs use SBC, but during the brake test the two brakes are controlled/tested separately: first the brake on F-DO00, then the brake on F-DO01.

**INFERENCE:** A companion brake must not be allowed to mask the mechanical weakness of the brake under test. This is a reusable validation principle, not a numerical test prescription for OpenPressBrake.

SEW start-inhibit evidence:
https://download.sew-eurodrive.com/download/html/33354294/en-EN/4840932058758615372043.html

**SOURCE-CONFIRMED:** SEW's start inhibit activates STO and prevents automatic startup of the safety option. It is invoked for several commissioning/recovery states, including parameterization during an active brake test and parameter-set restoration after device replacement.

**INFERENCE:** Completion/recovery of brake diagnostics must remain separate from ordinary LinuxCNC motion intent. A LinuxCNC `ENABLE`, `JOG`, or cycle request is not personnel-safety authority and must not substitute for safety-side brake-test/rearm state.

## Failure-path worksheet

For a gravity-loaded axis or other application where a brake is credited with retaining hazardous motion/load, validate these as distinct questions:

| Fault / challenge | Required observation | Provenance status |
|---|---|---|
| SBC requested but brake mechanical friction is inadequate | Electrical SBC state may be correct; physical retaining proof must fail or remain UNKNOWN | SOURCE-CONFIRMED boundary / application result UNKNOWN |
| Brake coil wire break or short during a state transition | Diagnostic behavior according to exact drive/brake interface | SOURCE-CONFIRMED capability; machine result UNKNOWN |
| Two brakes fitted; companion brake can hold load | Test each credited brake without companion masking its weakness | SOURCE-CONFIRMED SEW architecture |
| STO active and SBC active | Do not infer that hazardous gravity/load motion is physically retained | INFERENCE from Siemens warning |
| Brake test fails | Withhold production/personnel-exposure authority according to validated application; do not clear merely from LinuxCNC | INFERENCE; exact machine disposition UNKNOWN |
| Safety option/device replaced or parameter set restored | Re-establish required verified safety state before normal authority; preserve start inhibit where product requires it | SOURCE-CONFIRMED SEW behavior |
| Safety-side brake test/rearm completes while stale LinuxCNC JOG/START remains asserted | Stale ordinary command must not be treated as proof of safe retaining capability or safety validation | INFERENCE; exact process-command policy application-specific |
| Electrical brake control passes but load moves | Treat physical retaining claim as failed even if control diagnostics are healthy | INFERENCE directly supported by Siemens mechanical-defect boundary |

## LinuxCNC / FPGA authority boundary

LinuxCNC, HAL, and the ordinary OpenPressBrake FPGA may:

- request normal axis motion and normal brake sequencing where appropriate;
- display SBC/SBT/brake-test diagnostics supplied by the safety architecture;
- inhibit ordinary process progression in response to safety permission being absent;
- log brake-test state and maintenance evidence.

They must not be the sole personnel-safety authority for:

- deciding that SBC electrical state proves a mechanical brake is holding;
- overriding a failed required brake test;
- declaring a gravity-loaded axis safe for bodily access from an ordinary motion/status bit;
- silently restoring hazardous motion because a safety diagnostic or start inhibit cleared.

## Commissioning questions to preserve

1. Which physical brake(s) are actually credited with retaining the hazardous load?
2. What safe output/control path commands each brake?
3. What electrical faults does that path diagnose, and under what state-change conditions?
4. What independent test establishes mechanical retaining capability?
5. For multiple credited brakes, can each brake be tested without the other masking it?
6. What physical witness demonstrates that the load remained retained during the proof?
7. What happens after a failed test: fault latch, start inhibit, service state, re-test requirement?
8. After device/brake replacement, which electrical and mechanical proofs must be repeated?
9. Which ordinary LinuxCNC commands are invalidated or ignored while the safety proof/rearm is incomplete?
10. What machine-specific physical support/blocking is required before service? This remains UNKNOWN until the actual machine architecture is documented.

## Explicit non-claims

This study does **not** claim that OpenPressBrake has a motor holding brake, that SBC/SBT is the correct architecture for its hydraulic ram, or that drive-brake evidence substitutes for hydraulic retaining-valve validation. It does not assign a test torque, duration, proof interval, stopping distance, PL, SIL, category, diagnostic coverage, brake capacity, or allowable load. Those require the selected hardware, risk assessment, OEM requirements, and/or physical measurement.

## Durable lesson

**Safe brake control is control-path evidence; safe brake test is mechanical-function evidence; neither label alone is proof that the hazardous load is physically safe.** Keep command, electrical actuation, mechanical application, measured retaining behavior, safety rearm, and ordinary process authority as separate states.

## Precise next Lane-B checkpoint

Find a professional drive/gravity-axis implementation that exposes the complete chain:

`protective demand -> STO/SBC -> individual brake command -> physical brake application -> independent mechanical brake test -> physical load/motion witness -> failed-test start inhibit -> service/replacement -> re-test -> safety rearm -> application-specific ordinary motion reauthorization`

Prefer evidence that explicitly shows the **failed mechanical brake-test disposition and post-replacement re-test**, while staying outside the primary lane's hydraulic press-brake startup-test artifacts. Do not infer OpenPressBrake brake topology from this drive-domain study.
