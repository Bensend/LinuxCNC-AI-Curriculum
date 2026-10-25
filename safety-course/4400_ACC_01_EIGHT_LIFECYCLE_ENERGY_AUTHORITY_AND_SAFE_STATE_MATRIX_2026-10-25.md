# 4400-ACC-01 — Eight-state accumulator energy and authority decision matrix

**Status:** reusable engineering decision aid / PAPER ONLY / NON-GRADUATED. This is **not** an installed hydraulic truth table or valve-control recipe. It synthesizes [exact SAF/Parker source](../research/4400_HYDAC_SAF_2021_VARIANT_DEENERGIZED_BLEED_AND_PARKER_DUAL_ENERGY_AUDIT_2026-10-25.md), [HYDAC thermal fuse source](../research/4400_HYDAC_THERMAL_FUSE_GAS_VENT_FIRE_VS_PROTECTIVE_LOAD_AUDIT_2026-10-25.md), and [ISO/PED source-scope audit](../research/4400_ISO4413_2010_ACCUMULATOR_VENT_OR_ISOLATE_EXCEPTION_PED_SCOPE_AUDIT_2026-10-25.md). The ISO 4413:2010 §5.4.3.2 exception is **search-indexed preview only** (direct 502; full licensed clauses not inspected).

## Freeze the hazard proposition **before** selecting a valve

| Lifecycle / initiating event | Design question, not assumed action | Authority boundary | Physical witness required (selected machine UNKNOWN) |
|---|---|---|---|
| 1. Ordinary powered process | What legitimate work needs stored fluid energy? | LinuxCNC/FPGA may request process motion; independent safety still limits hazardous exposure | Verified process pressure/position, guards and independent protective function |
| 2. Protective stop / E-stop | Does the safe sequence require controlled stop energy **before** discharge or immediate isolation? | Independent safety SRS and final elements, not a HAL coil command | Actual Y1/Y2 or other load stopping/holding, residual pressure and guarding |
| 3. Electrical power loss | Is installed bleed E/Y normally-open, E/Z normally-closed, M manual, or a different circuit? | Exact OEM order code plus independently justified power-loss design | Actual pressure and gravity-load behavior; coil state alone insufficient |
| 4. Ordinary machine shutdown | Does selected design vent fluid or **positively isolate** retained pressure, and why? | Correct OEM manual, applicable standards and SRS; ISO preview is not signoff | Mapped trapped volumes, accessible servicing and stable load restraint |
| 5. Fire / thermal fuse actuation | Can loss of **gas** precharge remove protective-cycle energy or change mechanical forces? | Pressure-vessel fire device is distinct from hydraulic motion safety function | Fire-safe access/evacuation, independently supported load, separate fluid/gas states |
| 6. Qualified maintenance / group LOTO | Which hydraulic and electrical sources, gas vessel and gravity hazards remain? | Lockable physical isolation and each worker's personal control, not a safety relay or HMI | Correct zone-specific zero/retained-energy checks, mechanical supports, documented gas-side procedure |
| 7. Trapped-person rescue / controlled lowering | Can emergency lowering itself create a second crush hazard? | Qualified rescue procedure with independent controls and exclusion | Actual movement/hold/pressure witnesses and personnel exclusion; no generic override |
| 8. Restoration, change or restart | Were bleed variants, pressure taps, valves, guards or thermal accessories changed? | CHG invalidation, independent safety rearm and **fresh** motion command separate from LinuxCNC READY | As-built retest, independent physical stop/hold, access/occupancy and fault response |

## Adversarial invariants

- **BLEED COMMANDED != PRESSURE DISCHARGED.** HYDAC H4 depicts a restricting element in the E discharge branch but supplies no universal safe-time figure.
- **PRESSURE ISOLATED != ENERGY REMOVED.** Isolation may retain fluid energy; qualified servicing must still safely manage it.
- **HYDRAULIC ZERO != NITROGEN ZERO != RAM HELD.** These are distinct physical propositions.
- **SAFETY DEVICE NAME != COMPLETE SAFETY FUNCTION.** A valve block or thermal fuse cannot establish whole-machine integrity.
- **POWER LOSS != SAFETY STATE.** E/Y and E/Z differ; protective energy and gravity may complicate either.
- **NORMAL RESET != FRESH MOTION.** A safety circuit becoming READY cannot replay an old ordinary cycle request.

## Safer path should be easiest

For a machine actually using an accumulator, the design review should consider one concise laminated **energy-state card** with exact part/port labels, a reachable lockable isolator and manual bleed, test points in the actual hazard zones, captive mechanical support, clear service/return-to-service controls, and a simple route to get assistance without bypassing guards. Label any intentional retained pressure and the qualified way to discharge it before service. **Do not** tell an untrained builder to open or vent a pressure vessel.

## Blank machine-specific evidence mapping

| Required ID | As-built drawing/qualified witness | Status |
|---|---|---|
| BND/ENE/SRS — hazard and phase | — | UNKNOWN |
| ARC/DEP — exact accumulator/block/gas/port topology | — | UNKNOWN |
| AUTH — normal vs independent safety vs LOTO | — | UNKNOWN |
| PHY/VAL — stop/hold, pressure and guard witnesses | — | NOT RUN |
| HF/CHG — service ergonomics and substitution revalidation | — | UNKNOWN |
| RR — residual risk and restriction | No people-exposed operation until minimum safe-to-operate threshold proven | HOLD |

**Provenance:** direct original HYDAC/Parker OEM evidence for component functions; publisher-confirmed ISO scope and EU-OSHA PED scope; ISO clause **indexed preview only**; all machine outcomes **INFERENCE/UNKNOWN**, not TEST-CONFIRMED. No physical experiment, lab compute, independent evaluation or machine release. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.**
