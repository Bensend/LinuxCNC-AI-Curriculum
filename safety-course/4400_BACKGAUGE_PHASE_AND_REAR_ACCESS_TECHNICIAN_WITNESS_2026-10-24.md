# 4400-BG-01 — Backgauge phase/guard technician review and blank physical witness

**2026-10-24 | 12 PAPER scenarios, not blind/not scored/not run | No hazardous test authorization**

## Source prerequisites

Read [original TRUMPF/AMADA source audit](../research/4400_PRESS_BRAKE_BACKGAUGE_STEP_CHANGE_REAR_ACCESS_AND_INDEPENDENT_STOP_OEM_AUDIT_2026-10-24.md) and [BG-01 module](4400_BG_01_BACKGAUGE_STEP_CHANGE_REAR_ACCESS_AND_STOP_AUTHORITY_MODULE_2026-10-24.md). Do not transplant TRUMPF B35 behavior or AMADA product specifications into an uninspected machine.

## Twelve learner-visible paper challenges

For **each** case, identify (a) the hazardous movement and person, (b) ordinary control versus independent safety authority, (c) what signal is insufficient, (d) the physical proposition requiring a witness, and (e) whether normal production may be authorized. Do not treat answers as external evaluation.

| Case | Adversarial prompt |
|---|---|
| BG-P01 | Ram is at top, gauge has a programmed next position, operator begins sheet placement. Does top-of-ram mean gauge cannot move? |
| BG-P02 | A footswitch advances the program while the operator believes it only lowers the ram. What must the hazard analysis separate? |
| BG-P03 | Rear door opens and LinuxCNC X-axis command becomes zero; a technician reaches behind the machine. What is unproved? |
| BG-P04 | Gauge drive electronics remain energized while a certified drive reports STO. Is the electrical cabinet isolated for servicing? |
| BG-P05 | A gauge finger is replaced with a longer version; soft limits and old validation still pass. What evidence is stale? |
| BG-P06 | One side guard opens; a normal HMI says axes stopped; another safety door has a different reaction in the OEM example. Can one Boolean represent both? |
| BG-P07 | A protective stop occurs while a gauge step is pending; after reset the next step executes without new operator start. Identify the fault path. |
| BG-P08 | Front laser field is clear, but a helper stands behind the gauge carriage. What independent coverage question remains? |
| BG-P09 | A controller alarm automatically commands gauge return to its previous position. Does STOP imply safe return? |
| BG-P10 | A qualified gauge STO test passes but Y1/Y2 gravity-load holding is unknown. Can the machine be released with people exposed? |
| BG-P11 | A guard is hard to align after every finger adjustment and technicians want to tape the actuator. What is the safer engineering response? |
| BG-P12 | After a power outage the gauge reports 'homed' and a stored program resumes at the next index. Which reset/restart and actual-state checks are required? |

**Non-blind review standard:** correct answers reject any claim of safe operation from controller status alone, keep ram and gauge hazards separate, request exact selected protective authority and actual physical proof, and preserve isolation for service. No hidden key is created here.

## Blank selected-machine evidence worksheet — qualified team only

| Evidence ID | Required as-built fact / witness | Owner / instrument / revision | Result and evidence path | Status |
|---|---|---|---|---|
| BG-IN-01 | Machine identity; gauge X/R/Z/L and accessories, actuators, travel directions | | | UNKNOWN |
| BG-IN-02 | People/tasks: front, rear, side, helper, foil/tool/finger adjustment, inside access | | | UNKNOWN |
| BG-IN-03 | Actual phase-to-step trigger map: automatic, START, footswitch, resume, fault and power return | | | UNKNOWN |
| BG-IN-04 | Guard/ESPE exact hardware, geometry, reset, bypass protection, inside escape and personnel-clear method | | | UNKNOWN |
| BG-IN-05 | Independent safety controller and drive STO/final elements, actual wiring, version, safety signature | | | UNKNOWN |
| BG-IN-06 | Gauge motor/drive stored energy and separate hydraulic Y1/Y2 gravity/accumulator energy map | | | UNKNOWN |
| BG-IN-07 | Qualified actual gauge stop response at each protective demand; separately Y1/Y2 hold and all hazards | | | NOT RUN |
| BG-IN-08 | Tool/finger/support swept envelope and change-control, with nonhazardous verification plan | | | UNKNOWN |
| BG-IN-09 | Power return, queued step, guard close, reset, fresh deliberate start and remote UI | | | NOT RUN |
| BG-IN-10 | Real operator/maintainer guard access friction and reinstallation proof | | | UNKNOWN |
| BG-IN-11 | Approved physical exclusion, independent instrumentation, abort/containment and risk review | | | NOT AUTHORIZED |
| BG-IN-12 | Independent reviewer acceptance, residual risk, current drawings and evidence validity | | | HOLD |

### Decision logic (no manufactured acceptance values)

1. **Documentary gate:** obtain exact as-built devices, motion/access modes, energy map, SRS, approved test envelope and responsible qualified reviewers. An OEM example is not the as-built record.
2. **Nonhazardous gate:** inspect guards, wiring, output assignments, cable routes, mechanical finger clearance and configuration under appropriately isolated conditions. Do not interpret a green lamp as proof of final-element operation.
3. **Protected physical gate:** if independently authorized after risk review, witness actual axis stopping, Y1/Y2 holding, guard opening, power-loss and deliberate restart with personnel outside the hazard area and qualified instrumentation. Do **not** use a person's hand/body as a test target or defeat a guard to perform a test.
4. **Change gate:** after any guard, finger, drive, program phase, reset or safety-logic change, mark dependent evidence **STALE** and repeat affected validation.
5. **Release gate:** if minimum safe-to-operate protection is not proven, **do not operate with people exposed**. Experimental isolated/remote operation requires explicit residual risk and physical exclusion.

**Current status:** all selected OpenPressBrake physical facts/witnesses **UNKNOWN/NOT RUN**; independent evaluation OPEN; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No physical tests, simulation or Actions workflow dispatched.
