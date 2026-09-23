# 2560 — One safety function, two integrity methods

## Purpose

Show how the same physical safety function is reasoned about under ISO 13849-style PL reasoning and IEC 62061-style SIL reasoning without pretending that PL and SIL are labels that can be directly converted.

This exercise is deliberately symbolic. Missing machine-specific values remain `UNKNOWN`.

## Safety function used for comparison

Generic guarded hazardous-motion cell:

- a movable guard prevents routine access to hazardous motion;
- opening the guard demands the safety-related control function;
- safety sensing has two channels;
- safety logic evaluates the channels and reset/restart conditions;
- the output path commands two independently controllable final elements intended to prevent hazardous motion;
- feedback exists for covered final-element faults;
- ordinary LinuxCNC may observe state and inhibit normal commands, but does not own personnel-safety authority.

Required physical proposition:

> When guard access is demanded, hazardous motion must be prevented or brought to the specified safe state, and restart must remain inhibited until the safety function has been restored and a valid restart sequence occurs.

The actual stopping time, safe distance, PLr, SIL target, component failure rates, diagnostic coverage, CCF score, HFT, SFF, proof-test interval, mission time, and final-element physical behavior are `UNKNOWN` until supplied by the actual SRS and design evidence.

## Shared evidence required before either method is credible

Both methods need the same physical engineering foundation:

1. Correct hazard and lifecycle boundary.
2. Correct safety-function/SRS definition, including demanded safe state and restart behavior.
3. A real architecture trace from sensor through logic to final elements.
4. Application-valid component data rather than generic catalog labels.
5. Fault analysis, including common/dependent failures and failures in wiring, connectors, power, environment, configuration and maintenance.
6. Evidence that claimed diagnostics actually detect the faults credited to them.
7. Evidence that the final elements actually produce the physical safe state required by the SRS.
8. Systematic-correctness controls over specification, design, software/configuration, commissioning, change and maintenance.
9. Validation on the real implementation.

**Freeze:** METHOD CHOICE DOES NOT REMOVE THE NEED TO PROVE THE PHYSICAL SAFETY FUNCTION.

## ISO 13849-style analysis

The 2550 reasoning path asks, at minimum:

- What PLr is required by the risk assessment? `UNKNOWN` here.
- What Category/designated architecture describes the SRP/CS structure?
- What dangerous-failure reliability evidence supports each channel/subsystem (for example MTTFd/B10d-derived evidence where applicable)?
- What DCavg is actually justified by the implemented diagnostics?
- What CCF measures and dependency analysis support the assumed independence?
- Do the subsystem results and architecture support an achieved PL at least equal to PLr?
- Are systematic and validation requirements satisfied?

A drawing with two channels does not by itself establish Category 3/4. A component with a high MTTFd or a subsystem with a PL-capability label does not establish the complete safety function's PL. A SISTEMA result cannot repair a wrong SRS, an invalid use profile, an omitted common final element, or missing physical validation.

## IEC 62061-style analysis

The 2560 reasoning path asks, at minimum:

- What SIL is required for the SRCF by the risk assessment/SRS? `UNKNOWN` here.
- How is the SRCF decomposed into subsystems?
- What PFHd contribution is justified for each relevant subsystem and the complete function?
- What architectural constraint applies, including HFT and the applicable SFF/diagnostic evidence?
- What common-cause/dependency assumptions support the architecture?
- What systematic safety-integrity measures apply over specification, design, software/configuration, integration, validation and maintenance?
- Does the achieved integrity meet the required SIL and the SRS?

Current manufacturer guidance for IEC 62061:2021 explicitly treats PFHd and architectural constraints as separate dimensions; the SIL capability of a subsystem is influenced by architecture and SFF/diagnostic level. A small summed PFHd therefore cannot overrule an architectural claim limit.

## Shared evidence versus method-specific evidence

| Evidence | Shared physical basis | ISO 13849-style use | IEC 62061-style use |
|---|---|---|---|
| hazard/SRS/safe state | yes | establishes PLr context and function boundary | establishes required SIL/SRCF boundary |
| sensor/logic/output architecture | yes | Category/designated architecture | subsystem decomposition/HFT architecture |
| dangerous-failure data | yes | MTTFd/B10d/use-profile inputs as applicable | failure-rate/PFHd inputs as applicable |
| diagnostics | yes | DCavg and Category behavior | diagnostic/SFF/PFHd and architecture evidence |
| common/dependent failures | yes | CCF/dependency evidence | CCF/dependency and architectural evidence |
| systematic controls | yes | required design/systematic measures | systematic safety integrity/lifecycle measures |
| physical safe-state validation | yes | required beyond PL calculation | required beyond SIL/PFHd calculation |
| LinuxCNC diagnostic visibility | possibly useful monitoring | not personnel-safety authority by itself | not personnel-safety authority by itself |

## Invalid direct-conversion shortcuts

Do not do any of the following:

- `PL e -> SIL 3`, therefore no IEC 62061 analysis is needed.
- `SIL 3 component -> PL e machine function`.
- `PFHd happens to fall in a SIL band -> architecture and systematic integrity are proven`.
- `Category 4 drawing -> SIL 3`.
- `SISTEMA passes -> IEC 62061 requirements are automatically satisfied`.
- `manufacturer publishes both PL and SIL capability -> either label transfers to any application`.

Parallel manufacturer PL/SIL data are evidence that a product has been assessed under stated conditions; they are not a universal conversion table for complete machine safety functions.

## Case A — attractive PFHd arithmetic, indefensible claim

Assume a designer has credible manufacturer PFHd values for sensor, logic and output subsystems and obtains an attractive numerical sum inside a desired SIL band.

Now expose one omitted fact: both nominal output channels ultimately depend on one unmonitored mechanical element whose dangerous failure defeats the required safe state.

Result:

- the arithmetic may still be numerically correct for the items included;
- the architecture/dependency model is incomplete;
- HFT/architectural assumptions may be false;
- the physical proposition is not established;
- the SIL claim is not defensible.

The corresponding ISO 13849 analysis fails for the same physical reason: drawing two channels or obtaining attractive MTTFd/DC figures does not create fault tolerance when one common dangerous final element defeats both paths.

**Freeze:** CORRECT ARITHMETIC OVER AN INCOMPLETE ARCHITECTURE IS STILL THE WRONG MODEL.

## Case B — qualitative fault analysis beats more calculation

Assume the same guarded cell has detailed reliability data, but inspection finds that both guard-input channels share a single removable connector whose loss can present both channels as permissive because of the actual wiring/interface design.

The highest-value first action is not to refine another decimal place of PFHd or MTTFd. It is to correct the interface so loss/cross-connection faults move the system toward a detectable safe condition and then re-evaluate diagnostics/dependencies.

This correction improves the physical architecture before quantitative optimization. Only after the fault path is credible should either framework's quantitative model be refined.

**Freeze:** FIX AN OBVIOUS SINGLE-POINT/COMMON-CAUSE WEAKNESS BEFORE OPTIMIZING THE RELIABILITY MODEL AROUND IT.

## Case C — plausible model invalidated by application drift

Suppose an electromechanical output element's reliability input was derived from a documented use profile. Production changes increase demand/cycling substantially, but the safety calculation is not updated.

The old model can remain internally consistent while its application premise is stale. ISO 13849-style B10d/MTTFd reasoning and IEC 62061-style failure-rate/PFHd reasoning both depend on application-valid assumptions. Neither framework permits stale duty evidence to become true merely because the calculation file still opens without errors.

**Freeze:** A VALID METHOD CANNOT RESCUE INVALID INPUT PROVENANCE.

## What the two methods should agree on

A competent analysis under either method should discover the same important physical defects:

- a single common final element that defeats apparent redundancy;
- a shared power/connector/environment dependency that invalidates independence;
- diagnostics credited for faults they cannot observe;
- feedback that proves only contact/valve/drive state while the SRS requires standstill, pressure exhaustion, restraint or another physical condition;
- a stale use profile;
- uncontrolled safety-related configuration or software change;
- a reset/restart path that can initiate hazardous motion unexpectedly.

If the methods appear to disagree about one of these physical facts, inspect the model boundary and assumptions before treating the difference as a standards disagreement.

## LinuxCNC boundary

LinuxCNC can consume safety-system status for ordinary control, inhibit commands, display diagnostics and support commissioning evidence. Unless a separately justified safety-rated architecture says otherwise, ordinary LinuxCNC software, HAL and normal FPGA/controller logic remain outside personnel-safety authority. Their visibility does not replace the independent safety-related control function or the physical final elements.

## Evidence status

- IEC 62061:2021 lifecycle orientation, PFHd bands, HFT/SFF architectural relationship: `DOC-CONFIRMED` from current Pilz IEC 62061 guidance.
- ISO 13849 Category/MTTFd/DCavg/CCF method frame: inherited `DOC-CONFIRMED` 2550 evidence.
- Shared-evidence and invalid-conversion conclusions: `INFERENCE` from the two documented methods plus the physical-proposition methodology; deliberately bounded from certification claims.
- Machine-specific PLr, SIL, PFHd, MTTFd, DCavg, HFT, SFF, stopping time, proof-test interval and safe-state behavior: `UNKNOWN`.

## Release implication

The dual-method comparison closes the major conceptual bridge requested by the 2560 checkpoint. Before a 2560 learner route is frozen, audit the syllabus for explicit coverage of SIL target derivation, PFHd, subsystem composition, HFT/SFF/diagnostics, systematic integrity, CCF/dependencies, proof/validation boundaries, PL/SIL non-conversion, and application-data provenance.

No executable compute is required for this reasoning exercise.
