# 25E0 — Maintenance/bypass/force lifecycle and production-carryover boundary

Date: 2026-09-21

## Question

What lifecycle semantics should the safety curriculum teach for temporary commissioning states such as forces, direct safety-tag manipulation, deactivated safety mode, service overrides, bypasses, and simulated witnesses, without inventing one universal implementation?

## Authoritative evidence

### Rockwell Logix / GuardLogix — forces are an exceptional development state

**DOC-CONFIRMED** — Rockwell Logix SIS documentation permits I/O-tag forcing only while the project is safety-unlocked and no safety signature exists. Forces on safety tags must be **removed, not merely disabled**, before the project can be safety-locked or a safety signature generated. A generated safety signature also prevents forcing safety I/O and other safety-application modifications. Rockwell further requires programming tests to be complete before signature generation; verification follows from the signed application state.

**DOC-CONFIRMED** — Studio 5000 defines forcing as overriding the actual input value or overriding logic for the physical output. Therefore a forced signal is not evidence that the corresponding field condition is physically true.

**DOC-CONFIRMED** — FactoryTalk Security exposes separate securable actions for `Tag: Force` and `Tag: Force and Safety: Modify Component`, so the ability to force safety data can be separately authorization-controlled rather than treated as ordinary operator authority.

### Siemens S7 Distributed Safety — deactivated safety mode is conspicuous and bounded

**DOC-CONFIRMED** — Siemens documents deactivation of safety mode as a commissioning/testing state. It states that deactivation must be verifiable, recommends indication on the operator-control/monitoring system, and calls for logging where possible (or organizational measures otherwise). When an F-CPU sending safety-related data is in deactivated safety mode, Siemens says the receiving side can no longer assume that those data were generated safely; affected portions require organizational safety measures or fail-safe substitution.

**DOC-CONFIRMED** — Siemens documents that safety mode remains deactivated until the F-CPU is next switched from STOP to RUN. This is an explicit lifecycle boundary; it is not an ordinary production bit that silently follows process state.

**DOC-CONFIRMED** — Siemens also ties modifications to acceptance consequences: changes can alter the collective signature and may require a new acceptance test; its commissioning/acceptance workflow checks the deployed safety program against the accepted state.

## Engineering interpretation

The two ecosystems implement different mechanisms, but they support the same reusable lifecycle model:

`AUTHORIZED ENTRY -> CONSPICUOUS EXCEPTIONAL STATE -> BOUNDED TEST/MAINTENANCE USE -> EXPLICIT CLEARANCE -> CONFIGURATION/STATE IDENTITY CHECK -> REQUIRED REVALIDATION -> NORMAL SAFETY AUTHORITY -> FRESH ORDINARY DEMAND`

This is a **methodology**, not a universal state machine. A specific machine must derive its allowed exceptional states, authorization mechanism, indication, clearance test, restart behavior, and revalidation scope from its actual safety architecture and risk analysis.

## Required exceptional-state manifest

Every service/commissioning design should enumerate temporary states rather than hiding them behind one `maintenance_mode` bit. For each state record:

| Field | Required question |
|---|---|
| identity | What exactly is exceptional: safety force, standard force, safety-mode deactivation, bypass, service key, simulated witness, temporary jumper, direct command, inhibited diagnostic, alternate parameter set? |
| authority | Who/what may enter it? Is authority technical, physical-key, credential/role, procedure, or a combination? |
| scope | Which safety function, sensor, actuator, zone, or claim is affected? |
| indication | How is the state made conspicuous at the machine and, where useful, supervisory UI? |
| physical consequence | Which real-world proposition can no longer be trusted while active? |
| ordinary-control consequence | Which LinuxCNC/PLC/CNC commands remain allowed, inhibited, or require hold-to-run/enabling-device semantics? |
| personnel consequence | Is personnel exposure permitted? Under what independent protective measures? |
| persistence | Does it survive mode change, restart, power cycle, download, controller RUN transition, or key removal? Do not guess. |
| clearance | What proves the temporary state is actually removed rather than merely disabled or hidden? |
| revalidation | What physical/configuration tests become stale because the exceptional state existed or because hardware/software changed? |
| restart freshness | What happens to Start/Jog/Cycle demands asserted before or during the exceptional state? |
| record | What audit/commissioning evidence is retained? |

## Human-factors rules

1. **Exceptional state must look exceptional.** A technician should not be able to leave a safety force/bypass active while the HMI presents an ordinary production-ready appearance.
2. **Removal is stronger than disablement.** Where the platform distinguishes an installed-but-disabled override from removal, production clearance should prove removal when the safety lifecycle requires it. Rockwell's safety-force/signature rule is a concrete professional example.
3. **Authorization is not safety proof.** A password, key, role, or maintenance login can authorize entry; it does not prove that a guard, brake, valve, pressure state, or motion state is safe.
4. **Indication is not containment.** A warning banner or lamp is valuable human-factors evidence, but cannot replace an independent protective measure required while the normal safety function is unavailable.
5. **Configuration identity is not physical validation.** A matching signature/checksum can prove an accepted software/configuration identity within its documented scope; it does not prove field wiring, valve motion, brake torque, stopping performance, or personnel clearance.
6. **Exit is a commissioning event, not merely a mode bit.** Clear temporary states, verify the intended accepted configuration, perform the required impact-based revalidation, restore independent safety authority, and require fresh ordinary production demand where the application requires demand freshness.
7. **Make correct exit easier than accidental carryover.** Provide an explicit production-readiness checklist/manifest whose failed item prevents a `ready for production` declaration. Avoid relying on technician memory to remove hidden forces, jumpers or simulations.

## Production-readiness gate

A reusable acceptance record should separately answer:

- no safety forces/bypasses/simulated safety witnesses remain where prohibited;
- physical temporary aids/jumpers are accounted for and removed where required;
- safety mode/application is in its intended accepted state;
- accepted configuration/signature identity is verified where the platform provides one;
- modifications have been impact-assessed and required tests repeated;
- independent physical witnesses needed by each safety function have passed;
- reset/rearm semantics have been exercised after exceptional-state clearance;
- ordinary Start/Jog/Cycle demand freshness has been tested rather than assumed;
- operator-visible maintenance/service indication has cleared;
- personnel exposure is not permitted until the required independent protective functions are restored and validated.

## New freezes

- `AUTHORIZED BYPASS != SAFE PHYSICAL CONDITION`.
- `BYPASS/FORCE DISABLED != BYPASS/FORCE REMOVED` where the platform distinguishes them.
- `FORCED INPUT TRUE != FIELD INPUT PHYSICALLY TRUE`.
- `SAFETY MODE RESTORED != SAFETY FUNCTION REVALIDATED`.
- `SAFETY SIGNATURE MATCHES != FIELD HARDWARE VALIDATED`.
- `SERVICE KEY/PASSWORD PRESENT != PERSONNEL-SAFETY AUTHORITY`.
- `VISIBLE WARNING != ADEQUATE RISK REDUCTION`.
- `EXCEPTIONAL STATE CLEARED != FRESH ORDINARY START DEMAND`.
- `MAINTENANCE COMPLETE != PRODUCTION READY` until temporary-state clearance and impact-based revalidation are complete.

## Open boundary

No universal timeout for bypass/service mode is frozen. Public evidence supports conspicuousness, authorization, explicit lifecycle/clearance and revalidation principles, but the permissible duration and exact restart algorithm remain application/platform specific. A timer may reduce exposure to forgotten bypasses, but an arbitrary timer can also create unsafe or unusable behavior; derive it from the safety function and machine task rather than copying an example.

## OpenPressBrake/LinuxCNC boundary

LinuxCNC and the ordinary FPGA/controller may display maintenance state, inhibit normal production commands, log exceptional states, and help enforce fresh-demand policy. They must not become the sole personnel-safety authority merely because they have a convenient `maintenance`, `override`, `halui`, or diagnostic signal. Independent safety control and physical final-element/process validation remain separate.

## Sources

- Rockwell Automation, Logix SIS Safety Reference Manual / online help: `Force Data`; `Generate the Safety Signature`; Studio 5000 `Force`; FactoryTalk Security securable actions. Accessed 2026-09-21.
- Siemens, *S7 Distributed Safety — Configuring and Programming*, Programming and Operating Manual 07/2013, sections on deactivating safety mode, commissioning, program identification, acceptance testing, and operation/maintenance. Accessed 2026-09-21.

No executable compute was required for this source-and-architecture question. No GitHub-hosted runner was used.
