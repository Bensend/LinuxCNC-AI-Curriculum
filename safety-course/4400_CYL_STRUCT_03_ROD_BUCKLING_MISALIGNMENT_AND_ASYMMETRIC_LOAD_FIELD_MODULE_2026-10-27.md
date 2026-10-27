# 4400 CYL-STRUCT-03 — Cylinder pressure is not a column-strength certificate
**Public paper field module**, 2026-10-27; NON-GRADUATED. Read [direct Aggressive Hydraulics/Enerpac OEM audit](../research/4400_CYL_STRUCT_03_AGGRESSIVE_ENERPAC_BUCKLING_SIDELOAD_AND_DUAL_AXIS_STRUCTURAL_AUDIT_2026-10-27.md). Eight **UNSCORED** paper scenarios and eight **NOT RUN** documentary gates. No physical load test.

## Practical mental model
Keep five propositions separate: (1) hydraulic pressure within selected limits; (2) rod/column compression and mount capacity; (3) ram/frame/guide alignment and Y1/Y2 load distribution; (4) independently protective stop/hold; (5) safe maintenance and mechanical blocking. An HMI STOP or pressure gauge proves none of the other four automatically.

### Eight paper scenarios — UNSCORED
1. A cylinder's pressure is below nameplate but its long extended rod bows. Explain column instability versus pressure burst and what selected OEM calculation is missing.
2. Two cylinders move to the same target position but one clevis shows uneven wear. Explain why matching position does not prove equal structural load or alignment.
3. A replacement cylinder matches bore and pressure rating but has a longer stroke. Identify changed unsupported length, column and stop-tube qualification, plus stale safety evidence.
4. A maintenance worker removes a guide to make a guard easier to open. Explain new lateral-load and defeat hazards; propose captive/accessible guide/guard redesign.
5. An operator applies a portable Enerpac lifting 80% guideline to an industrial press-brake cylinder. Explain why product-specific lifting guidance cannot be used as an as-built structural design rating.
6. A rod is thickened to reduce buckling risk but the cylinder annulus shrinks. Connect the CYL-STRUCT mechanism to HYD-INT pressure-intensification review without guessing numbers.
7. A dual-ram system stops hydraulically but a mounting pin is cracked. Identify the independent physical safe-state failure and positive mechanical support required before access.
8. An engineer claims an ideal Euler equation alone proves safe press-brake operation. Identify missing end conditions, eccentricity, guide geometry, material, fatigue, real OEM rating and independent validation.

### Eight documentary gates — NOT RUN
| Gate | Qualified evidence | HOLD if |
|---|---|---|
| STR-G1 | Exact installed Y1/Y2 cylinders, revisions and drawings | Model UNKNOWN |
| STR-G2 | Stroke/rod extension/unsupported length and mount end conditions | Column length assumed |
| STR-G3 | Compressive/tensile/side-load envelope incl. asymmetric ram cases | Only hydraulic pressure considered |
| STR-G4 | OEM column/buckling, bearing, stop-tube, guide and pin rating | Ideal equation treated as certificate |
| STR-G5 | Ram/frame/guide and tool-load transfer map | Load path unverified |
| STR-G6 | Wear/misalignment inspection and maintenance access | Damage signs ignored |
| STR-G7 | Independent physical Y1/Y2 stop/hold and positive support | Position/valve state substituted |
| STR-G8 | Change/revalidation and qualified physical commissioning plan | Hazardous proof test or unverified restart |

## Design for humans
Make mount/guide inspection reachable without guard bypass, provide keyed replaceable pins and clear inspection criteria, and ensure mechanical blocking is accessible and easy to use. If a rod or mounting path cannot be shown adequate, **do not operate with people exposed**. Any experimental activity must isolate personnel remotely/outside the hazard zone with residual risk explicit. No proposed physical buckling demonstration.

## Uncertainty and handoff
The manufacturer's 80% portable lifting guideline is not transferred to a press brake. No selected machine dimensions, buckling load, structural rating, PL/SIL, hydraulic truth, stopping time or test result is claimed. All gates NOT RUN; evaluator NOT RUN; **G0/G1 HOLD**.
