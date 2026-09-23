# 25D0 — Low-cost guard-interlock architecture comparison

## Why this artifact exists

The 25D0 syllabus names a guard-interlock architecture as a candidate low-cost reference. The A–E ladder already covers E-stop/final-element, STO/external switching, and fluid-power functions, but did not yet make the low-cost guard case explicit. This artifact closes that learner-facing gap without duplicating 2590.

This is educational architecture reasoning, not a universal wiring recipe and not a PL/SIL claim.

## G1 — single interlock in an ordinary control permissive

**Physical proposition sought:** opening the guard removes the ordinary run permissive.

**Incremental cost/value:** very low parts/wiring burden and useful process control. A normally-closed/de-energize-to-trip path may also react usefully to some broken-wire faults.

**Material limits:** a stuck/defeated switch, short around the contact, ordinary controller output failure, or downstream final-element failure may preserve the hazard. Guard-open state is not proof that hazardous motion or energy ended. An ordinary LinuxCNC/FPGA permissive is not personnel-safety authority.

This tier can reduce risk but must not be mislabeled as a validated safety-related guard function.

## G2 — safety-rated interlock interface + safety evaluation + justified final element

**Physical proposition sought:** guard opening is evaluated through a safety-related input architecture and causes the separately justified final element(s) to demand the defined safe state.

**What the added cost can buy:**

- manufacturer-defined dual-channel/OSSD/coded sensing behavior where the selected device supports it;
- specified wiring-fault/discrepancy diagnostics when correctly applied;
- deliberate reset/rearm behavior;
- integration with redundant/monitored final elements when required by the safety-function architecture;
- clearer diagnostics than an opaque ordinary-control permissive.

**DOC-CONFIRMED carry-forward:** Siemens SIRIUS 3SK safety-relay families provide application-dependent safety-door monitoring, monitored-start options and cross-circuit detection; exact capability depends on the selected device/configuration. The current 3SK2 manual states that monitored start evaluates the START signal sequence and rejects a static/overlong start signal rather than treating it as a valid fresh start.

**Residual limits:** a correctly evaluated guard signal still does not prove the dangerous state ended. Common mechanical defeat, sensor mounting failure, shared wiring/environmental CCF, final-element failure, coast-down, gravity/stored energy and pass-through occupancy remain separate propositions.

## G3 — guard locking when access can outrun hazard cessation

Guard locking is not simply a more expensive G2. It buys a different physical function: prevent guard opening until the release conditions are satisfied by the engineered safety function.

Use it only when the risk assessment and stopping/cessation behavior justify it. Do not infer that a lock command, lock-status bit, or guard-closed signal proves standstill, safe pressure, discharged energy, or sufficient holding force for the application.

**Cost reasoning:** if the dangerous state can cease before a person can reach it, adding locking may buy little relative to improving sensing/final-element diagnostics. If access can occur while the hazard persists, however, the lock may close a dominant failure path that an expensive ordinary interlock cannot. Spend against the physical hazard, not the catalog hierarchy.

## Fault comparison

| Fault/event | G1 ordinary permissive | G2 safety evaluation | G3 guard locking | Remaining proposition |
|---|---|---|---|---|
| broken input conductor | may remove permissive in de-energize-to-trip wiring | supported wiring diagnostics can detect specified faults | same sensing issue plus lock circuit/state | stop demand is not safe-state proof |
| one sensing channel stuck | may defeat function | disagreement may be detected in a valid dual-channel application | same, plus locking does not repair bad sensing | independence/mechanical CCF still required |
| switch physically defeated/misaligned | may falsely report closed | coding/diagnostics can make some defeat harder, not impossible | lock may also be defeated/misapplied | foreseeable defeat and mounting remain engineering concerns |
| final element fails dangerous | ordinary permissive can be correct while hazard remains | safety evaluation alone does not repair a single downstream failure | locked guard may delay access, but release logic must remain valid | final-element architecture/feedback and physical cessation are separate |
| power loss | behavior depends on sensor/logic/final element | safety-related system must have defined loss-of-power behavior | power-to-lock versus power-to-unlock choice is application-specific | evacuation, trapped-person and residual-energy behavior must be analyzed |
| power restoration | ordinary logic may resume permissive | deliberate restart/rearm can prevent unexpected re-enable | lock/release state must not silently authorize motion | reset/rearm != cycle start |
| guard closed after entry | can appear healthy while person remains inside | same pass-through/occupancy problem | locking a closed guard does not prove space empty | visibility/presence/restart architecture remains required |

## Human-factors boundary

A cheap guard that must be removed with loose fasteners for every adjustment, obscures necessary process visibility, or produces unexplained nuisance trips predictably creates defeat pressure. Spend first on hinges/captive hardware, sensible access, visible diagnostics and a legitimate setup/recovery mode when those changes make correct use easier. Higher-coded sensing cannot compensate for a workflow that rewards bypass.

## Required freezes

- **GUARD CLOSED != DANGEROUS STATE ENDED.**
- **GUARD INTERLOCKED != GUARD LOCKED.**
- **GUARD LOCKED != PHYSICAL SAFE STATE PROVED.**
- **HIGHER-CODED SENSOR != DEFEAT INCENTIVE REMOVED.**
- **RESET/REARM COMPLETE != MOTION START AUTHORIZED.**
- **ORDINARY LINUXCNC/FPGA PERMISSIVE != PERSONNEL-SAFETY AUTHORITY.**

## Machine-specific UNKNOWNs

Before applying any tier, establish the hazard and lifecycle boundary, stopping/cessation time, access/reach geometry, pass-through possibility, required integrity target, interlock/locking principle, final-element architecture, power-loss behavior, escape/trapped-person needs, environmental/CCF assumptions and validation method. Do not invent these from the reference architecture.

## Source note

This comparison reuses the already-developed 2590 safeguard/interlock evidence and current Siemens SIRIUS 3SK documentation. It adds no machine-specific stopping distance, locking force, PL/SIL, or diagnostic-coverage number.
