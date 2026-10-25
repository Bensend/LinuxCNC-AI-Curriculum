# 4400-SCAN-01 — A sensor reset that never reaches the safety controller
**4000 safety engineering | 2026-10-25 | NON-GRADUATED | DOCUMENTARY ONLY**

## Learning outcome and prerequisites
After 2520 SRS, 2530 E-stop/reset, 2590 protective devices, 4400-EDM-01 and 4400-TEACH-01, a fresh engineer must distinguish **field-clear state**, **OSSD output state**, **safety-controller restart authority**, **fresh normal motion request**, and **physical stop/hold**. Read the [exact 2025 SICK S300 source audit](../research/4400_SICK_S300_2025_EFI_FIELD_STATUS_BYPASSES_INTERNAL_RESTART_INTERLOCK_AUDIT_2026-10-25.md).

## Essential manufacturer counterexample
The S300 manual §7.10 says the internal restart interlock acts on its OSSDs. If a Flexi Soft controller uses **OSSD status via EFI**, that interlock affects the controller. If it instead uses **protective-field status**, the internal restart interlock does **not** affect the controller: an independent restart interlock is needed in the controller. **DOC-CONFIRMED, S300 8010948/ZD76/2025-08-19 p.89**.

```
person enters field -> field interrupted -> OSSD OFF
person passes beyond scanner -> field clear
                           |                |
                  field status TRUE    OSSD remains OFF (interlocked)
                           |                |
           Flexi Soft consuming FIELD    Flexi Soft consuming OSSD
           loses sensor interlock        sees sensor interlock
                           |
            MUST implement independent safety reset
                           |
            fresh motion command remains distinct
                           |
            qualified physical stop / hold validation
```
This diagram is a teaching proposition, **not** a real wiring drawing or proof of unsafe motion. A machine can remain safe if the downstream independent safety design is correct; the sensor checkbox alone proves nothing.

## Architecture contract
| Layer | Allowed role | Not a sufficient safety claim |
|---|---|---|
| Scanner | detect within configured field; apply configured internal OSSD interlock | clear field = empty hazard zone |
| Safety-rated controller | evaluate exact rated signal path, implement missing reset interlock, drive rated final elements | any EFI bit = safe OSSD or actual stop |
| Normal LinuxCNC / FPGA | display field status, sequence non-safety requests, record alarms | sole personnel-safe reset, hold, or unlock |
| Final electrical/hydraulic/mechanical elements | independent stop, isolation, ram restraint and proof | green HMI status or software estop bit |
| Human/operator | deliberately reset from visible safe location and separately request motion | reset button = stroke command |

## Documentary acceptance gates (NOT RUN)
Exact model/firmware; physical protective-field and OSSD maps; internal restart configuration; which EFI signal is consumed by each safety logic branch; controller logic/config revision; downstream restart state; reset station placement/visibility; EDM and final elements; unexpected power-cycle/reintegration response; fresh motion request handling; qualified Y1/Y2 stop/hold, pressure isolation and guard coverage. See [12-gate worksheet](4400_SCAN_01_TWELVE_GATE_NO_ENERGY_RESTART_SIGNAL_PATH_REVIEW_2026-10-25.md).

## Human factors
Provide a labeled **RESET — NO MOTION** control with full hazard view, separate START control, visible reason for inhibited rearm and simple recovery instructions. Do not make a bypass jumper or disabled interlock the easiest path to resume work. A scanner should not require operators to memorize obscure EFI field/OSSD semantics: configuration inspection should expose them in the safety documentation.

## Safety release, evidence and promotion
**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** Physical OpenPressBrake Y1/Y2 independent stopping, gravity holding, hydraulic isolation, occupancy and restart remain UNKNOWN. No personnel-exposed operation. If minimum safe-to-operate cannot be established, any experimental operation must be remote/isolated with all people outside danger zone and residual risks stated. **DOC-CONFIRMED:** exact SICK manual. **INFERENCE:** engineering transfer. **SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **UNKNOWN:** selected implementation, PL/SIL, timings, physical proof, evaluator.

**Graduation:** NOT GRADUATED; 12 documentary gates NOT RUN, 12 public scenarios UNSCORED, external evaluator PREPARED/NOT RUN. Higher-level queue: selected controller/EFI as-built (**CRITICAL; blocks machine release**), independent whole-body occupancy coverage (**CRITICAL; blocks machine release**), measured stop/hold (**CRITICAL; blocks machine release**). Counterfactual: different installed hardware would not overturn the exact S300 manual finding, but prevents machine-specific transfer until verified.
