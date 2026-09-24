# Worked coherent safety-chain qualification — Rockwell application family — 2026-09-24

Session start: 2026-09-24T11:37:15Z

Status: evidence-training example only. **NOT a canonical machine design, NOT machine validation, NOT an achieved PL/SIL claim, and NOT permission to operate hazardous machinery.** Generic safety schematics remain NOT FROZEN.

## Why this example exists

The earlier SICK deTec4 Core worked example correctly exposed a cross-vendor compatibility gate but intentionally left the selected receiver/final element unresolved. This example removes that particular ambiguity by using an inspectable manufacturer-supported Rockwell application family whose published application technique specifies the protective device, configurable safety relay, and safety contactors as one documented chain.

Reference architecture:

`Rockwell safety light curtain dual OSSD -> Guardmaster 440C-CR30 safety inputs/logic -> redundant 100S-C safety contactors -> mechanically linked auxiliary-contact feedback -> motor power interruption`

An E-stop and reset are present in the manufacturer's worked application, but the light-curtain path is the focus here.

## Evidence ledger

### DOC-CONFIRMED

Rockwell application technique SAFETY-AT164A-EN-P documents that:
- the light curtain connects to a 440C-CR30 configurable safety relay;
- interruption of the light curtain causes the relay safety outputs to de-energize;
- those outputs control the coils of 100S-C contactors;
- opening the contactors removes motor power and the documented machine response is a category-0 coast stop;
- the 440C-CR30 monitors the 100S-C contactors through mechanically linked auxiliary contacts and will not reset unless the main motor contacts are open;
- reset is a press-and-release action with the application-specific 0.25–3.0 s interval after safety inputs are correct and faults absent.

Rockwell application technique SAFETY-AT138C-EN-P further documents the same architecture class: the light curtain monitors its own circuitry/OSSD outputs; OSSD faults such as shorts can force the OSSDs OFF; E-stop channels use CR30 test pulses; and reset/contactor-feedback signals may be placed on standard I/O only because the CR30 constrains that standard I/O to functions that are not themselves safety-rated input signals. Light-curtain and E-stop signals must use safety-rated inputs.

Rockwell 440C-CR30 user manual 440C-UM001I-EN-P documents a light-curtain/safety-input model with configurable input type including `2 OSSD`, plus input filter, discrepancy and pulse-test settings. This is direct evidence that OSSD reception is an explicit selected input mode, not an inference from nominal 24 V.

### INFERENCE, bounded by the application

The manufacturer-supported application removes the *cross-vendor* producer/receiver compatibility uncertainty that blocked the prior worked example. It does **not** prove that arbitrary Rockwell light curtains, CR30 firmware/configurations, contactor variants, suppressors, cables or replacement parts are interchangeable. Exact catalog numbers, revisions and the published application conditions remain part of the selected design baseline.

### UNKNOWN / machine-specific

Stopping time/distance, protective-device placement, motor/load inertia, gravity behavior, stored energy, alternate feeds, contactor sizing/utilization, required integrity target for a new machine, and maintenance isolation remain machine/design-specific. No values are invented here.

## Exact proposition chain

1. **Protective-device proposition:** the selected light curtain reports protective-field state through its dual OSSD outputs and internal diagnostics.
2. **Receiver proposition:** the CR30 receives the selected OSSD pair as safety inputs under the documented configuration.
3. **Safety-logic proposition:** a safety demand removes the CR30 safety-output permissive.
4. **Actuation proposition:** removal of the safety outputs de-energizes the selected contactor coils.
5. **Final-element proposition:** the selected contactors' main power contacts are expected to open, interrupting the documented motor-power path.
6. **Feedback proposition:** mechanically linked auxiliary contacts report a supported mechanical relationship to the contactor main-contact mechanism and are used to inhibit reset when the required open state is not reported.
7. **Physical-safe-state proposition:** whether the machine has actually reached its required safe state still requires machine-level evidence. The contactor/EDM chain alone does not establish standstill, zero stored energy, gravity restraint or maintenance isolation.

Freeze: **MECHANICALLY LINKED CONTACTOR FEEDBACK != MACHINE SAFE STATE PROVED**.

## What EDM/feedback proves — and its boundary

In this documented chain, feedback is stronger than an arbitrary PLC mirror bit because it comes from mechanically linked auxiliary contacts associated with the final contactors. The CR30 uses that feedback to refuse reset unless the expected open state is present.

Credit is therefore limited to the selected contactor/mechanical-state proposition supported by the manufacturer's contact relationship and wiring. It is not evidence that:
- the motor has stopped;
- all hazardous energy is absent;
- every power pole/alternate feed is electrically isolated for maintenance;
- a gravity-loaded mechanism is restrained;
- hydraulic/pneumatic pressure is safe;
- the feedback wiring/supply has no common-cause fault;
- the machine-level safety function has achieved a claimed PL/SIL.

This preserves the existing freezes `EDM SATISFIED != HAZARDOUS ENERGY ABSENT` and `MATCHING COMMAND/FEEDBACK != INDEPENDENT PHYSICAL WITNESS`.

## Restart/rearm semantics

The worked application requires correct safety inputs, absence of detected faults, and a reset pushbutton press-and-release within its documented timing window before the CR30 turns its safety outputs on. Therefore a clear light curtain by itself is not restart authorization.

The 0.25–3.0 s timing is **application/product evidence**, not a generic safety-reset value. It must not be copied into another safety controller without selected-product evidence.

Ordinary LinuxCNC/HAL/FPGA cycle-start remains a separate proposition. A safety reset may restore the safety permissive; it must not be treated as the ordinary command to initiate hazardous motion.

## Dependency / common-cause attack

Before a real schematic is frozen, the selected implementation still has to examine:
- common 24 V and 0 V/reference failures affecting sensor, CR30, outputs or feedback;
- shared protection/fusing and connector/cable faults;
- the exact OSSD input/filter configuration and any pulse interactions;
- CR30 configuration/firmware and programming/service access;
- contactor-coil suppression and its effect on release behavior;
- common contactor coil supply and output supply;
- feedback wiring/reference failures that can create plausible state;
- welded/stuck main contacts and the exact mechanically linked auxiliary relationship;
- alternate motor-energy paths or bypasses around the selected contactors;
- power loss/restoration and retained ordinary start commands;
- ordinary LinuxCNC/FPGA commands placed such that they could defeat or mask the independent safety demand.

A single manufacturer application is useful compatibility evidence, not immunity from CCF analysis.

## Validation cases derived from the documented chain

- `VAL-RW-01`: interrupt the light curtain and witness OSSD demand, CR30 safety-output withdrawal and downstream contactor release in a bounded fixture before any hazardous-machine validation.
- `VAL-RW-02`: restore the field without the required reset action and verify no safety-output rearm.
- `VAL-RW-03`: exercise reset outside the documented timing/eligibility conditions and verify it is rejected according to the selected configuration.
- `VAL-RW-04`: force one selected contactor feedback disagreement in a safe fixture and verify reset/rearm inhibition.
- `VAL-RW-05`: create a plausible-but-wrong ordinary controller/HMI status while the safety chain is demanded; verify that ordinary status has no safety authority.
- `VAL-RW-06`: remove/restore control power with ordinary start asserted; verify power restoration/reset does not itself become hazardous cycle start.
- `VAL-RW-07`: review or safely inject selected common 24 V/0 V/reference/protection faults after the exact circuit exists; verify the claimed diagnostic/safe response rather than assuming channel independence.
- `VAL-RW-08`: machine commissioning must separately witness the actual safe-state proposition, including stopping/stored-energy/gravity/process behavior as applicable.

## Bench-lab decision

No bench lab is frozen from this source trace. The principal question from the previous checkpoint — whether an inspectable coherent manufacturer-supported OSSD -> safety logic -> contactor/EDM chain exists and what its feedback proposition means — is answered adequately by authoritative application/manual evidence.

A future bench test is justified only for a concrete selected implementation uncertainty that the exact manuals/application do not resolve (for example a specific replacement device, suppression network, wiring dependency or configuration interaction). If needed, it must run only on the local `[self-hosted, openpressbrake]` infrastructure and must not energize hazardous machinery merely to prove an interface fact.

## Curriculum consequences

1. A manufacturer-supported application can satisfy the producer/receiver compatibility evidence gate for the exact documented product/configuration family; it does not create a generic 24 V safety-I/O compatibility rule.
2. Mechanically linked final-element feedback is a useful final-element-state witness but remains narrower than the machine physical safe-state proposition.
3. Reset timing and restart behavior are selected-architecture facts, not reusable generic constants.
4. Standard/non-safety I/O may be used for some auxiliary reset/feedback functions only where the selected safety architecture explicitly permits and constrains that use; this must not be generalized to safety demands.
5. Generic safety schematics remain NOT FROZEN. Machine-specific energy paths and integrity calculations remain downstream design/validation work.

## Sources

- Rockwell Automation, *Light Curtain and Configurable Safety Relay Safety Function Application Technique*, SAFETY-AT164A-EN-P — coherent light-curtain -> 440C-CR30 -> 100S-C contactor chain, mechanically linked contactor monitoring, reset sequence.
- Rockwell Automation, *Safety Function: Light Curtain and Configurable Safety Relay*, SAFETY-AT138C-EN-P — OSSD fault behavior, safety-rated input allocation, E-stop test pulses, reset/feedback auxiliary-I/O allocation.
- Rockwell Automation, *Guardmaster Configurable Safety Relay User Manual*, 440C-UM001I-EN-P (Nov. 2022) — configurable `2 OSSD` safety-input mode, filtering/discrepancy/test-source configuration.

Evidence classes are `DOC-CONFIRMED` unless explicitly marked otherwise. No runtime/test evidence was generated in this session.