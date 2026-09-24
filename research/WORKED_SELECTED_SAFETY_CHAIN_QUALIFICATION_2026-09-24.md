# Worked selected safety-chain qualification — 2026-09-24

Session start: 2026-09-24T10:38:48Z

Status: evidence-training example only. **NOT a canonical machine design, NOT machine validation, NOT a PL/SIL claim, and NOT permission to operate hazardous machinery.** Generic safety schematics remain NOT FROZEN.

## Purpose

Apply `hardware/SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md` to an inspectable professional chain and test whether the reusable evidence gate is sufficient before schematic capture.

Reference chain used for evidence continuity:

`SICK deTec4 Core protective field / dual OSSD -> external safety logic -> positively guided downstream contactors -> EDM/feedback -> hazardous-energy interruption`

A Pilz PNOZ s4 is used as an **architecture comparison/reference for the external safety-logic/output stage**, not asserted as a SICK-approved pairing unless a selected-device compatibility document establishes that exact combination.

## A. Identity and provenance

### Input/protective device
- Family: `SI-OSSD2`.
- Manufacturer: SICK.
- Product: deTec4 Core safety light curtain.
- Source: SICK operating instructions 8014253/1S70/2025-04-08.
- Evidence: `DOC-CONFIRMED`.

### External safety logic/output comparison
- Family: `SC-CORE` + relay-output implementation reference.
- Manufacturer: Pilz.
- Product: PNOZ s4.
- Source: Pilz operating manual 21396-EN-14 plus current Pilz product/manual index showing later revisions exist.
- Evidence: `DOC-CONFIRMED` for the documented PNOZ behavior; **UNKNOWN** for exact cross-vendor compatibility with the selected deTec4 Core until the current exact manuals/application evidence are checked together.

### Final elements
- Positively guided contactors are the final-element class required by the deTec4 Core EDM discussion.
- Exact contactor make/model, coil characteristics, utilization category, suppression, auxiliary-contact behavior, mechanical lifetime and machine energy path: `UNKNOWN`.

## B. Traceability allocation

This worked example exercises reusable propositions rather than inventing a machine SRS:
- `PHY-WORKED-01`: interruption of the protective field shall create a safety demand.
- `PHY-WORKED-02`: a safety demand shall remove permission from the selected downstream switching path.
- `PHY-WORKED-03`: restart/rearm shall not be inferred solely from restoration of the protective field.
- `PHY-WORKED-04`: downstream contactor state feedback is a contactor-state witness, not proof that hazardous motion/energy has ended.
- `AUTH-WORKED-01`: ordinary LinuxCNC/HAL/FPGA control has no authority to override the protective demand.
- `DEP-WORKED-01`: 24 V/0 V, wiring, OSSD compatibility, relay input behavior, contactor supply and feedback path must be reviewed for common dependencies.
- `VAL-WORKED-01..08`: validation cases defined below.

No machine stopping distance, response-time budget, PL/SIL target, contactor sizing or process safe-state value is assigned here.

## C. Electrical/interface evidence

SICK documents the deTec4 Core as a protective device whose OSSDs transition according to protective-field state. The exact OSSD electrical thresholds, pulse behavior, permissible load/filtering, cable constraints and response-time contribution must be taken from the exact current product data used for capture. They are intentionally not copied into this reusable example.

The SICK manual states that deTec4 Core does **not** provide integrated EDM; where EDM is required it must be implemented in the external control. It also states positively guided contactors are prerequisites for the described downstream monitoring architecture.

Pilz PNOZ s4 documentation shows architectures with automatic or monitored-manual start/restart and with/without feedback-loop monitoring. Its manual warns that automatic start or a bridged start contact can cause automatic startup when the safeguard is reset and calls for external measures to prevent unexpected restart.

**Schematic-blocking unknown:** exact deTec4 Core OSSD -> selected PNOZ s4 input compatibility, including test pulses/filtering, input current/thresholds, wiring/reference requirements and the current exact manual revisions. Do not draw the cross-vendor electrical connection from this example alone.

## D. State and restart/rearm semantics

SICK's deTec4 Core example states that interruption of the light path ends the dangerous machine state and that it is not re-enabled until an operator presses a reset pushbutton outside the hazardous area. The manual also says restart interlock must be available where a person can stand behind the protective device, subject to applicable rules.

For this example:
- safety demand: protective-field interruption / OSSD safe state;
- reset request: external reset action;
- deliberate reset event: product/application-specific; do not infer an edge rule generically;
- reset accepted: external safety logic decision;
- rearm eligible: requires all allocated conditions, not just clear field;
- safety permissive: external safety logic/output state;
- ordinary start/cycle: separate machine-control proposition;
- power restoration: must not be treated as rearm eligibility;
- held/stuck reset: adversarial validation case, not assumed safe from topology alone;
- occupancy/visibility: reset-button placement alone does not prove safeguarded space empty.

Freeze: **PROTECTIVE FIELD CLEAR != RESTART AUTHORIZED**.

## E. Hazardous-energy path

Abstract path:

`machine energy source -> downstream contactor/final switching elements -> hazardous actuator/process`

The protective device and external safety logic can command withdrawal of the downstream switching permission. What remains after contactor opening is machine-specific: stored electrical energy, rotating inertia, gravity, hydraulic/pneumatic pressure, thermal/process energy and alternate feeds are all `UNKNOWN` until the machine boundary is defined.

Production safeguarding is not maintenance isolation.

## F. Witness proposition

| Witness | What it proves | What it does NOT prove | Shared dependency / attack |
|---|---|---|---|
| deTec4 OSSD state | selected protective device output proposition | person absent from all hazardous space; machine stopped | common supply/reference, wiring, receiver faults subject to product diagnostics |
| external safety relay state | relay logic/output proposition | final contactor opened; hazardous energy ended | relay supply, configuration/wiring |
| positively guided contactor auxiliary contact | supported mechanical/contact state relationship of selected contactor | zero voltage/pressure, standstill, gravity restraint, all poles/alternate paths safe unless selected evidence establishes it | same mechanism, wiring, feedback supply, welded/broken target assumptions |
| LinuxCNC/HMI indication | ordinary diagnostic observation | personnel-safety authority or physical safe state | PC/FPGA/software path |

Freeze: **EDM SATISFIED != HAZARDOUS ENERGY ABSENT**.

## G. Dependency / CCF attack

The worked chain exposes these mandatory checks before capture:
- common 24 V and 0 V/reference between sensor and relay;
- protection/fusing whose failure can defeat both channels or diagnostics;
- OSSD cable routing and shorts/cross-connections;
- pulse/filter compatibility at the relay input;
- reset wiring and a stuck/bridged reset path;
- relay output supply and contactor coil supply;
- suppression components that can alter release behavior;
- feedback wiring supplied/referenced from a common source;
- two contactors that appear redundant but share a common mechanical or energy-bypass path;
- ordinary FPGA/LinuxCNC start signal being incorrectly placed where it can mask a safety demand;
- power restoration causing an unintended permissive/start sequence.

## H. Failure-state table

| Fault | Expected reasoning / evidence disposition | Rearm disposition |
|---|---|---|
| protective field interrupted | OSSDs demand safe response; external chain must withdraw permission | no rearm while demand persists |
| field restored without reset where restart interlock required | restoration alone is insufficient | no automatic credit for rearm |
| reset held/bridged | PNOZ documentation shows automatic-start risk for bridged start configurations; selected topology must prevent unintended restart as required | requires explicit selected-design evidence |
| one final contactor welded | feedback/EDM should detect only if the selected contactor/contact arrangement and wiring support that proposition | inhibit rearm on detected disagreement |
| feedback plausible but wrong | matching signal cannot be credited without independence/target analysis | no physical-safe-state credit |
| common 24 V/0 V fault | behavior depends on selected products/wiring | UNKNOWN until dependency analysis |
| power loss/restoration | do not equate restoration with rearm | deliberate rearm policy required |
| LinuxCNC/FPGA output stuck ON | safety chain must retain authority independent of ordinary command | ordinary command cannot override safety demand |

## I. Human factors / service

Reset must be deliberately located and designed so using the safeguard correctly is easier than bypassing it. SICK's example places reset outside the hazardous area; this supports location reasoning but does not prove complete visibility or occupancy clearance. If the safeguarded space permits whole-body entry or hidden occupancy, additional architecture is required by the machine risk assessment.

A fault that routinely requires bypassing the light curtain, relay or feedback loop to diagnose is an engineering defect in the service design. Bypass/muting/service modes require separate authority, indication, constraints and restoration validation.

## J. Validation plan

- `VAL-WORKED-01`: interrupt protective field; verify safety-demand propagation and downstream switching response.
- `VAL-WORKED-02`: restore field without reset; verify no unintended rearm where restart interlock is allocated.
- `VAL-WORKED-03`: hold/bridge reset; verify selected design cannot create prohibited unexpected restart.
- `VAL-WORKED-04`: simulate/open feedback disagreement using a safe bench fixture; verify rearm inhibition/diagnostic ownership.
- `VAL-WORKED-05`: create plausible-but-wrong feedback in a non-hazardous fixture; prove software/status agreement is not accepted as physical evidence.
- `VAL-WORKED-06`: remove/restore control power; verify restoration does not become a hazardous start command.
- `VAL-WORKED-07`: attack common 24 V/0 V/reference and shared protection in a de-energized or bounded fixture after the selected circuit exists.
- `VAL-WORKED-08`: command ordinary LinuxCNC/FPGA start continuously while demanding safety; verify ordinary control cannot override the safety path.

Machine physical validation must additionally witness the actual hazardous-energy proposition. Contact/EDM observations alone are insufficient.

## K. Integrity-claim boundary

Any component Type/Category/PL/SIL capability stated by manufacturer documentation remains component/subsystem evidence. This example makes **no achieved machine safety-function integrity claim**. Architecture, MTTFd/PFH/PFD, diagnostic coverage, CCF scoring, mission time, demand mode and systematic capability require the selected machine design and applicable method.

## L. UNKNOWN disposition and schematic decision

### SCHEMATIC-BLOCKING
- exact current deTec4 Core electrical/OSSD data for selected part;
- exact selected external safety relay/controller and input compatibility;
- exact current manual/revision and configuration;
- selected final contactors and feedback-contact properties;
- power/reference/protection topology;
- reset/start wiring semantics;
- suppression and output loading.

### MACHINE-VALIDATION-BLOCKING
- machine hazardous-energy path and alternate energy sources;
- stopping time/distance and protective-device positioning;
- gravity/stored-energy behavior;
- required integrity target and achieved calculation;
- occupancy/visibility assumptions;
- maintenance isolation method.

Decision: **NOT READY FOR SCHEMATIC CAPTURE as a generic chain.** The example successfully demonstrates the evidence gate and identifies what a real selected design must resolve.

## Reusable-template findings

The worksheet is broadly sufficient, but this worked example exposes one generic omission worth making explicit in future template revisions: **cross-product compatibility evidence must be a first-class schematic gate** whenever a safety input, controller and final element come from separately selected product families. Matching nominal voltage or connector semantics is insufficient; pulse/filter behavior, diagnostic interaction, output/input electrical limits, startup/reset behavior and manufacturer application restrictions must be reconciled.

Second generic lesson: a final-element feedback proposition should name the **feedback target/mechanical relationship**, not merely the feedback signal. Otherwise a learner can accidentally treat an electrically plausible auxiliary signal as independent proof of the final switching state.

## Sources

- SICK, *deTec4 Core Operating Instructions*, 8014253/1S70/2025-04-08: restart-interlock example; reset outside hazardous area; EDM external to deTec4 Core; positively guided contactors prerequisite for the described EDM architecture.
- Pilz, *PNOZ s4 Operating Manual*, 21396-EN-14: automatic vs monitored-manual start/restart, feedback-loop wiring, warning concerning automatic startup when safeguard is reset with automatic/bridged start configuration.
- Pilz current product/manual index (accessed 2026-09-24) shows newer PNOZ s4 manual revisions exist; therefore old-revision details are not silently treated as current selected-product values.

Evidence classes in this artifact are `DOC-CONFIRMED` unless explicitly marked `INFERENCE` or `UNKNOWN`. No runtime/test evidence was generated in this session.
