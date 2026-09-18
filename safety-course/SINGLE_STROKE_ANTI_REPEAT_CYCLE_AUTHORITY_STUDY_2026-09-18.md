# Single-stroke / anti-repeat cycle-authority study

Date: 2026-09-18
Lane: independent safety curriculum Lane B
Active level: 4000 safety course

## Selection / parallel-work boundary

The primary lane's newest durable work is `FINAL_ELEMENT_FEEDBACK_VS_PHYSICAL_HAZARD_WITNESS_TRACE_2026-09-18.md`, which separates safety command, final-element/EDM feedback, physical-hazard witness, access/rearm and ordinary START. This Lane-B study deliberately does not modify that file or its evidence package. It addresses a different failure class: a valid initiating control remaining asserted, or a cycle-complete state being misused, so that a machine repeats a hazardous cycle without a new permitted initiation.

## Question

What must a press-oriented curriculum preserve between an operator's initiating action, permission for exactly one hazardous cycle, cycle completion/interruption, release/reinitiation, and authority for another cycle?

## Evidence

### OSHA 29 CFR 1910.217 — mechanical power presses

**SOURCE-CONFIRMED.** OSHA 29 CFR 1910.217 contains explicit anti-repeat and single-stroke requirements for mechanical power presses. Full-revolution clutch machines require a single-stroke mechanism. Two-hand trip systems on full-revolution clutch machines require an anti-repeat feature. For part-revolution clutch machines, single-stroke two-hand controls require anti-repeat; the controls must require release of all operators' hand controls before an interrupted stroke can be resumed where the cited installation-date condition applies. The standard also requires the stop control to override other controls, with clutch reactuation requiring use of the selected operating/tripping means.

**SOURCE-CONFIRMED.** The same rule treats operating modes separately: Off, Inch, Single Stroke and Continuous are selected modes; continuous operation requires an additional prior operator action/decision beyond merely selecting Continuous before the operating means can cause continuous stroking. It also requires an automatic means preventing Single Stroke or Continuous initiation/continuation unless the press drive motor is energized in the forward direction.

**SOURCE-CONFIRMED.** OSHA's control-reliability language says a relevant control-system failure must not prevent normal stopping when required and must prevent initiation of a successive stroke until the failure is corrected; the failure must be detectable by a simple test or indicated by the control system.

**SOURCE-CONFIRMED.** OSHA's inspection provisions explicitly call out the clutch/brake mechanism, anti-repeat feature and single-stroke mechanism for periodic inspection/testing and require needed repair before operation.

Source: OSHA, 29 CFR 1910.217, Mechanical power presses, current electronic CFR presentation accessed 2026-09-18.

### OSHA machine-guarding eTool — foot control

**DOC-CONFIRMED.** OSHA's press foot-control eTool explains the practical consequence: a manually fed mechanical power press with the applicable mechanism must cycle only once for each foot-control depression, and the foot control must be protected against unintended operation. It separately warns about 'riding' the pedal.

Source: OSHA Machine Guarding eTool, Presses — Foot Control, accessed 2026-09-18.

## Applicability boundary

The OSHA clauses above are specific to **mechanical power presses** and particular clutch/control architectures. They are not evidence that OpenPressBrake, a hydraulic press brake, must implement the same mechanical clutch/brake circuitry or the same regulatory details.

The transferable engineering lesson is narrower and useful: where a mode is intended to permit one hazardous cycle per initiation, the architecture must distinguish a continuously asserted initiating input from a new permitted initiation and must define what happens after an interrupted or completed cycle. Exact OpenPressBrake legal applicability, required modes, cycle definition, safeguarding method and reinitiation rules remain **UNKNOWN** until machine-specific requirements and the applicable standards are established.

## Authority model

Preserve these propositions independently:

1. **Mode selected** — e.g. a machine-specific single-cycle/setup/automatic mode is selected.
2. **Safeguarding satisfied** — required independent safety functions permit the contemplated operation.
3. **Initiating control physically active** — foot control, two-hand control, PSDI sequence, or ordinary cycle command has an electrical/logical state.
4. **Fresh initiation accepted** — the validated control architecture recognizes a new permitted initiation event.
5. **One-cycle authority issued** — exactly the intended hazardous cycle may proceed under the applicable safeguards.
6. **Cycle state/progress** — the machine is within, has interrupted, or has completed that cycle.
7. **Reinitiation condition satisfied** — required release, reset, return-to-safe state, or other validated condition is complete.
8. **Next fresh initiation** — another deliberate event is required before another cycle where single-cycle semantics apply.

## Frozen rules

**INITIATING INPUT HIGH != FRESH INITIATION != ONE-CYCLE AUTHORITY != NEXT-CYCLE AUTHORITY.**

**CYCLE COMPLETE != AUTOMATIC PERMISSION TO REPEAT.**

**SAFETY RESET/REARM != NEW PRODUCTION CYCLE REQUEST.**

**MODE SELECTED != HAZARDOUS MOTION AUTHORIZED.**

**LINUXCNC START/CYCLE/JOG BIT STILL ASSERTED AFTER A SAFETY DEMAND != FRESH OPERATOR INTENT.**

Where a validated safety function intentionally defines initiation from a protective-device sequence (for example the separately studied PSDI case), that sequence must be treated as its own validated initiation mechanism; this does not justify interpreting arbitrary stale ordinary-control state as fresh intent.

## Failure-path analysis

Challenge these cases during design review and commissioning where applicable:

- An initiating input is held continuously through cycle completion. A single-cycle mode must not silently convert that level into repeated fresh initiations.
- A foot switch or pushbutton sticks/welds electrically active. Diagnose or inhibit successive-cycle authority according to the validated architecture rather than relying on the operator to notice.
- An interrupted cycle is cleared by reset/rearm while the initiating input remains asserted. Reset must not itself become the missing new cycle request.
- Safety authority drops during a cycle and later returns while LinuxCNC `START`, `CYCLE`, `JOG`, foot-input state or an FPGA command remains asserted. Restoration of safety permission must not reinterpret stale ordinary state as fresh intent.
- Power is removed and restored while an initiating device is held. Power restoration and controller boot must not create hazardous motion merely from retained input state.
- A mode selector changes from setup/inch to single-cycle or automatic while an initiation input is already asserted. Mode selection alone must not create a cycle.
- A cycle-complete sensor sticks or changes state unexpectedly. Do not let a single ordinary sensor become both proof of cycle completion and unconditional permission to issue another hazardous cycle.
- Multi-operator initiation is used. One station remaining actuated must not supply indefinite concurrence for later cycles; preserve the separate multi-operator/two-hand study's release and concurrence rules.
- A control-reliability diagnostic detects a fault after one cycle. Prevent the next cycle until the required correction/recovery chain is complete; fault acknowledgement alone is not repair.
- Continuous mode exists. Treat authorization of continuous operation as a distinct supervised/mode-specific proposition, not as a loophole that bypasses single-cycle safeguards.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC/HAL and an ordinary FPGA can own normal process sequencing, remember cycle progress, debounce ordinary controls, and present diagnostics. They may request motion only while the independent safety system permits it. They must not be treated as personnel-safety authority merely because a HAL edge detector or software state machine appears to prevent repeat cycles.

For an OpenPressBrake architecture, a useful future implementation contract is to make ordinary cycle intent explicitly edge/freshness-aware while separately maintaining the safety permissive. That is an **INFERENCE/design direction**, not a claim that a particular safety integrity level is achieved by software edge detection.

## Commissioning questions

Record evidence for each applicable proposition rather than only observing a normal cycle:

- What physical/operator event constitutes a new cycle initiation?
- What state proves that one-cycle authority has been consumed?
- What must be released or reset before another initiation is accepted?
- What happens if the initiating device never releases?
- What happens if safety authority disappears and returns with the initiating device still active?
- What happens across control-power loss/restoration with the input active?
- What distinguishes single-cycle from continuous mode, and what additional deliberate action is required for continuous operation?
- Which safety-side faults inhibit a successive cycle even though ordinary control is healthy?
- Which ordinary-control faults can create an unwanted request, and why can the safety architecture still prevent personnel exposure from depending solely on that ordinary request path?

## Evidence provenance labels

- OSHA regulatory text above: **SOURCE-CONFIRMED**.
- OSHA eTool explanatory guidance: **DOC-CONFIRMED**.
- No executable test was performed: **TEST-CONFIRMED: none**.
- No community report is used as evidence: **COMMUNITY-REPORTED: none**.
- Transfer of the fresh-initiation/anti-repeat principle to future OpenPressBrake architecture: **INFERENCE**.
- OpenPressBrake-specific required cycle semantics, safeguarding architecture, hydraulic response, stopping behavior, pressure/force limits, timing, PL/SIL/category/DC and exact legal/standards applicability: **UNKNOWN**.

## Minimum-safe-to-operate consequence

If a hazardous manually initiated cycle can repeat merely because a control remains asserted, or if restoring safety/control power can create motion without a deliberate permitted initiation, treat that as a commissioning failure. Do not operate with people exposed to the hazard until the initiation/reinitiation path is corrected and validated.

## Compute decision

No simulation, synthesis, benchmark or executable verification is justified for this source-tracing question. No GitHub-hosted or self-hosted compute was consumed.

## Precise next-work checkpoint

Find a professional hydraulic/servo press or press-brake implementation that exposes, in one trace, `mode selection -> safeguarded fresh cycle initiation -> one-cycle authority -> physical cycle progress/completion -> interrupted-cycle behavior -> required release/reinitiation -> next-cycle authority`, preferably with a stuck initiating device, power-restoration case, or diagnosed control fault. Preserve the mechanical-power-press OSHA material as transferable architecture evidence only; do not infer OpenPressBrake-specific timings, hydraulic truth tables, safeguarding performance or regulatory applicability.