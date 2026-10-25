# 4400-HOLD/FILT — Coupled hydraulic safety common-cause and rearm desk-review package
**2026-10-25 | Engineering synthesis | INFERENCE with OEM anchors | NON-GRADUATED | NO ENERGIZED TEST**

## Why this integration matters
The [HOLD-01 original Bosch Rexroth/Parker audit](../research/4400_REXROTH_AVBC90_EMERGENCY_SCREW_RELIEF_AND_PARKER_E2_LOAD_HOLD_SOURCE_AUDIT_2026-10-25.md) identifies *multiple opening paths inside one nominal load-holding valve*. The [FILT-01 Parker/HYDAC audit](../research/4400_PARKER_HYDAC_FILTER_BYPASS_COLD_START_INDICATOR_RESET_AND_VALVE_CONTAMINATION_OEM_AUDIT_2026-10-25.md) identifies *multiple ways a filter alarm can fail to establish filtered flow*. Together they expose an easily missed **common-cause claim**: two separately commanded Y-axis hydraulic circuits may still depend on shared fluid quality, shared pilot/return routing, shared maintenance practice and shared restoration of manual overrides.

**No actual OpenPressBrake common-cause failure is established.** These are falsifiable design questions for a qualified restricted as-built review, not a discovered machine defect.

## Typed causal graph (candidate edges, not physical findings)
```text
NORMAL CONTROL / DIAGNOSTICS (non-safety)
  LinuxCNC/HAL/FPGA Y1/Y2 commands -- ordinary valve requests
  HMI FILTER_OK / RAM_STOPPED ------- telemetry of named signals only

FILTER / FLUID BOUNDARY
  element restriction + peak return flow + viscosity
    -> possible ΔP increase -> bypass-to-downstream OR bypass-to-tank OR no-bypass
    -> actual downstream cleanliness UNKNOWN
  indicator: independent ΔP sensor OR linked mechanism
    -> automatic reset / manual retained alarm / thermal lockout
    -> historical clog/bypass state may be absent from current HMI

LOAD / ENERGY BOUNDARY
  actual cylinder-side chamber + gravity + hose/seal
    -> load movement potential
  selected holding valve
    <- pilot opening
    <- overload/shock relief opening
    <- manual lowering override
    <- contamination-related malfunction? [INFERENCE, mechanism not established]
  Y1/Y2 independence? [UNKNOWN: shared pilot, oil, return, relief, controls]

INDEPENDENT SAFETY AND PHYSICAL PROOF
  hazard-specific protective demand
    -> independent safety controller/final element (selected identity UNKNOWN)
    -> actual safe STOP/HOLD (qualified physical witness NOT RUN)
  maintenance access -> isolation + residual-energy verification + positive support
  reset -> physical restoration -> independent rearm -> NEW deliberate start
```

## Fault-tree questions to resolve before making a safety claim
Top event T1: **person exposed to hazardous ram motion despite nominal STOP/HOLD**. Candidate contributors (not quantified): F1 load path lacks adequate restraint; F2 pilot/relief/manual override can release the load; F3 safety final element fails or is bypassed; F4 diagnostics misrepresent actual state; F5 maintenance resumes with stale or unrestored configuration. The reviewer must derive real minimal cut sets **from the selected circuit**; this text does not assume that any single contributor alone produces T1.

Top event T2: **both nominally independent Y circuits lose the intended holding function**. Candidate shared contributors: C1 common hydraulic fluid contamination, C2 shared pilot/vent/return or accumulator path, C3 common relief architecture, C4 common electrical/safety control supply, C5 identical valve variant/service error, C6 common operator reset/maintenance practice. A claim of redundancy requires evidence for **fault independence and diagnostic coverage**, not merely a count of two cylinders.

Top event T3: **false filter-clean inference**. Potential diagnostic ambiguity: D1 auto-reset alarm cleared when ΔP falls; D2 optional thermal lockout masks cold-start indication; D3 switch polarity/wiring wrong; D4 independent ΔP switch not equal bypass position; D5 peak-flow bypass occurs between slow HMI samples. These are separate mechanisms; do not claim a particular one is installed.

## G0 no-energy reviewer matrix
| Required restricted artifact | Specific question it resolves | Release if absent? |
|---|---|---|
| Dated as-built Y1/Y2 chamber/pilot/return/relief/accumulator schematic and valve BOM | Actual holding/opening paths and common feeds | NO |
| Valve model/suffix/manual override condition, OEM installation/maintenance instructions | Whether an E-screw/other override exists and how restoration is evidenced | NO |
| Filter housing/element/bypass schematic, part suffix, indicator wiring and thermal option | Whether unfiltered flow reaches downstream components and what the indicator really measures | NO |
| Qualified fluid cleanliness/maintenance and contamination sensitivity basis | Whether the selected valve's required reliability assumptions are supportable | NO |
| Hazard-specific independent STOP/HOLD SRS and fault/CCF analysis | Whether the safety function survives selected credible faults | NO |
| Physical restraint and task-specific isolation/LOTO plan | Whether service can be performed without relying on normal motion control | NO |
| Qualified remote/excluded G1/G2 witness method with calibration/abort | Whether actual stop/hold can later be verified without exposing personnel | NO |
| Independent reviewer, revision record, unresolved contradiction list and fresh rearm acceptance | Whether changes invalidate earlier evidence and whether restart is deliberate | NO |

## Human-factor redesign (concepts, not modifications)
- Make filter replacement **clean, reachable, and clearly identified** without opening the hazardous ram zone; show the exact OEM element and a retained service history.
- Provide an explicit distinction between *filter maintenance needed*, *indicator inhibited during cold start*, *bypass status not measured*, and *independent machine safety hold not proven*; do not collapse them into a single green lamp.
- A qualified rescue/maintenance override should be **physically inspectable, restored and recorded**, with service-state interlocks/administrative controls as appropriate to the OEM, rather than a hidden manual screw that routine production depends on.
- Do not let a new software alarm acknowledgment silently clear the physical restoration task or restart the ram.
- Make correct guards, service covers, mechanical support and reset station ergonomically easier to use than to defeat. Interview operators and maintainers before freezing layout.

## Change-control adversarial checks
A filter element substitution, different indicator reset variant, addition/removal of thermal lockout, altered hydraulic oil/viscosity, valve replacement, new relief setting, different manual lowering provision, hose routing, pilot plumbing, Y-axis cylinder change, firmware/control change or altered tool-change access creates a **CHG** event. Mark dependent STOP/HOLD/diagnostic/maintenance evidence STALE pending qualified review. A previous bench test or catalog page does not automatically validate the changed physical machine.

## Evidence and stop rule
**DOC-CONFIRMED** only the OEM statements in linked original audits; **INFERENCE** coupled fault tree and design patterns; **SOURCE-CONFIRMED** no new LinuxCNC source; **TEST-CONFIRMED none; COMMUNITY-REPORTED none; UNKNOWN** selected machine, quantitative reliability, PL/SIL, hydraulic truth tables, stopping distances, physical witness and external evaluation. This is **not** a simulated fault tree, validation report or certification. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** No intentional contamination, manual override, hose opening, pressure/ram movement or personnel exposure is authorized by this desk review.
