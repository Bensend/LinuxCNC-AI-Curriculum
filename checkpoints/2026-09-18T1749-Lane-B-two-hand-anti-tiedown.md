# Lane B checkpoint — two-hand anti-tiedown and reinitiation authority

Date: 2026-09-18

## Completed

Created `safety-course/TWO_HAND_CONTROL_ANTI_TIEDOWN_RELEASE_REINITIATION_AUTHORITY_STUDY_2026-09-18.md` in commit `e28b91cf0320f4c735e7995a266be7e81c359b0f`.

## Parallel-lane reconciliation

Required governance/current-state files and recent commits were inspected before selection. The primary lane's newest durable work is hydraulic press-brake physical stop proof/periodic validation (`5c219f3`, progress `f1f9895`, checkpoint `7aacc56`). Lane B therefore selected a different initiating-device safety function and did not modify the primary hydraulic study or shared `PROGRESS.md`.

Immediately before the substantive write, current main ended at `9314227` above primary checkpoint `7aacc56`. Immediately after the write, `e28b91c` was HEAD with no intervening overlapping commit.

## Frozen result

`LEFT INPUT ACTIVE + RIGHT INPUT ACTIVE != VALID TWO-HAND ACTUATION`.

`BOTH HANDS PRESENT != SYNCHRONISM VALID != SAFETY OUTPUT AUTHORIZED != PHYSICAL HAZARD SAFE`.

`ONE BUTTON RELEASED != OTHER BUTTON MAY REMAIN TIED DOWN FOR NEXT INITIATION`.

`BOTH BUTTONS RELEASED != FRESH CYCLE AUTHORITY`.

`SAFETY RESET/REARM != FRESH TWO-HAND INITIATION != ORDINARY LINUXCNC START/JOG/CYCLE INTENT`.

Rockwell manufacturer evidence explicitly documents concurrent two-hand operation, continuous actuation during hazardous conditions, anti-tie-down release/reinitiation behavior, a certified THRS function block that rejects invalid/tied-down sequencing, and a dedicated THC validation checklist. Pilz independently treats two-hand control as a monitored safety function evaluated by safety relays/controllers.

## Evidence limits

No OpenPressBrake THC applicability, control type, physical layout, synchronism value, required operating mode, PL/SIL/category/DC/CCF, stopping performance, hydraulic response or final-element topology was asserted. Manufacturer numerical timing remains implementation-specific evidence, not an OpenPressBrake design value.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.

## Precise next work

Find a complete professional hydraulic/servo press, press-brake, or comparable hazardous-machine implementation exposing `two physical controls -> safety input diagnostics -> synchronism/anti-tiedown evaluator -> safety output -> final element -> physical motion witness -> one-control release -> hazardous-motion reaction -> both-controls release -> fresh reinitiation -> separate ordinary production sequencing`.

Prefer an OEM/manufacturer commissioning/validation document with a tied-down/stuck-button, channel-disagreement, power-restoration, or failed-final-element test. Keep THC sequence validity separate from physical stop-performance validation.