# 4400-BLK-01 — Blank selected-machine support/LOTO physical witness
**Status: BLANK / NOT RUN / NO OPERATING AUTHORIZATION.** Complete only with qualified personnel and the actual selected machine. Do not paste proprietary as-built drawings into the public curriculum.

| Record | Required selected-machine evidence | Status |
|---|---|---|
| BND/HAZ | Exact machine identity, task, exposed people, gravity/shear/crush zones | UNKNOWN |
| ENE | All electrical, hydraulic, accumulator, trapped-volume, gravity and external load sources | UNKNOWN |
| PHY-GRAV | Actual ram/tooling/attachment load case and support rating/load path, supplier, revisions | UNKNOWN |
| PHY-ENGAGE | Physical engagement method and independent safe-location witness (not only a limit bit) | UNKNOWN |
| PHY-DYNAMIC | How powered-stroke/other dynamic energy is independently prevented, isolated or controlled | UNKNOWN |
| AUTH | Ordinary LinuxCNC/FPGA command, independent safety, isolators and physical support owners | UNKNOWN |
| DEP | Common frame/anchor, fasteners, control supply, diagnostic and bypass dependencies | UNKNOWN |
| LOTO | Task-specific energy-control procedure, each worker's personal control and group handoff | UNKNOWN |
| TRANSITION | Temporary test/positioning personnel-clear, authorized unlock, re-isolation and re-verification sequence | UNKNOWN |
| HF | Ease of support installation/removal, visible state, lock accessibility, bypass incentives | UNKNOWN |
| PT | Initial and periodic mechanical-integrity inspection/test records; change/incident retest | NOT RUN |
| VAL | Independent final-element, actual stop/hold, isolation and restart evidence | NOT RUN |
| RR/UNK | Residual risk and explicit missing machine facts | UNKNOWN |

**Witness fields to fill for each physical observation:** ID, task/mode, OEM model/revision, source drawing revision (private reference only), inspector/qualification, date UTC, safe vantage, instrument/calibration where applicable, observation, uncertainty, fault injected (if any and safely justified), pass/fail criterion established *before* testing, result, retained private evidence location, dependencies invalidated by changes.

**No unsafe demonstrations:** do not intentionally load an unqualified pin, energize a press against a block, or place a person in the hazard zone to check engagement. Establish safe remote/isolated inspection and engineered test methods with qualified personnel. Do not infer the support's capacity or safe-state from a sensor alone.

**Decision:** G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. Conditional selected-machine intake `IN-04aa` is UNKNOWN until inventory confirms applicability. If no slide-lock/support of this type exists, mark the device-specific branch N/A with evidence, **not** the gravity-hazard requirement. If minimum safe-to-operate conditions cannot be demonstrated, do not operate with personnel exposed.
