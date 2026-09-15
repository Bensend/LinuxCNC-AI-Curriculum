# 4000 Safety — TeSys Deca mirror-contact witness and SIM-REUSE-01 truth vectors

Session start UTC: 2026-09-15T23:34:00Z

Status: SOURCE/DOC RESEARCH — no compute used

## Frozen reference family

For the Safety Sandbox power-contactor example, freeze Schneider Electric TeSys Deca / TeSys D LC1D09..LC1D95 as the first concrete family.

DOC-CONFIRMED from Schneider documentation:
- the built-in 21-22 NC auxiliary is identified as a mirror contact for LC1D09..LC1D95;
- a mirror contact is an NC auxiliary that reflects the state of the NO main contact(s): if a main power contact remains closed, e.g. welded, the mirror contact cannot close;
- mirror-contact terminology for power contactors is associated with IEC 60947-4-1;
- Schneider recommends the NC auxiliary in the base device for monitoring rather than an arbitrary separate block; the integrated contact cannot simply be removed;
- TeSys D also documents 1 NO + 1 NC mechanically linked auxiliary behavior, but that auxiliary-to-auxiliary relationship is distinct from the mirror relationship to main power poles.

Primary manufacturer evidence consulted this session:
- Schneider FAQ FA142116, TeSys Deca/K mirror contacts, last modified 2025-08-22.
- Schneider FAQ FA126437, LC1D linked/mirror contacts, last modified 2026-05-12.
- Schneider LC1D09 product datasheet: mechanically linked 1NO+1NC to IEC 60947-5-1 and mirror NC to IEC 60947-4-1.

## Simulator semantic contract

Do not model `coil=false => main_open=true` as an identity.

For each K device retain separately:
- `coil_command`
- `mechanical_state`
- `main_poles[]` continuity
- `mirror_21_22` continuity
- any ordinary auxiliary continuity
- `edm_observation`
- `rearm_permission`

For the frozen TeSys Deca mirror-contact model, the key witness constraint is:

`ANY(NO main pole remains closed) => mirror_21_22 MUST NOT be closed`

The reverse must not be overclaimed as a universal physical proof of every possible hazardous-energy condition outside the modeled contactor. A closed mirror is evidence about the contactor relationship defined by the device documentation; it is not proof that downstream stored energy, hydraulics, gravity, another bypass path, or another device is safe.

## SIM-REUSE-01 deterministic vectors

The fixture uses K1 and K2 as two series interruption devices. `hazard_path` here means only the abstract electrical path represented by those two devices, not a complete machine safe-state claim.

| Vector | Stop demand | K1 main | K1 mirror | K2 main | K2 mirror | EDM/rearm expectation | Abstract hazard path |
|---|---:|---|---|---|---|---|---|
| V01 healthy stop | 1 | open | closed | open | closed | healthy witness; rearm may become eligible only after reset/restart policy | interrupted |
| V02 K1 main welded | 1 | CLOSED fault | MUST remain open | open | closed | discrepancy; inhibit rearm | interrupted by K2, latent K1 fault remains |
| V03 K2 main welded | 1 | open | closed | CLOSED fault | MUST remain open | discrepancy; inhibit rearm | interrupted by K1, latent K2 fault remains |
| V04 K1 welded + ordinary aux falsely follows coil | 1 | CLOSED fault | n/a ordinary aux may appear closed | open | closed | ordinary aux must NOT be promoted to mirror evidence; false-safe inference exercise | interrupted by K2 |
| V05 mirror feedback stuck/open | 1 | open | OPEN fault | open | closed | cannot establish healthy EDM; inhibit rearm | interrupted |
| V06 feedback wire broken | 1 | open | physically closed but circuit unseen | open | closed | EDM path unhealthy/unknown; inhibit rearm | interrupted |
| V07 both mains fail closed | 1 | CLOSED fault | open | CLOSED fault | open | discrepancy; inhibit rearm | NOT interrupted — hazardous electrical path remains |
| V08 control power lost | 1 | device states evaluated under deenergization + persistent faults | according to physical state | same | same | no automatic rearm | evaluate actual poles, not command bits |
| V09 power restored after healthy stop | 1 | open | closed | open | closed | restoration alone MUST NOT cause restart/rearm | interrupted |
| V10 power restored with latent welded K1 | 1 | CLOSED fault | open | open | closed | discrepancy persists; inhibit rearm | interrupted by K2 |

## Adversarial teaching cases

1. **Commanded off is not proven off.** The learner sees K1 coil deenergized while a welded K1 main remains conducting.
2. **Redundancy can remove the immediate path while leaving a dangerous latent fault.** V02/V03 are not a pass for continued operation; EDM/rearm behavior must expose the failure before another demand.
3. **An ordinary auxiliary can create false confidence.** V04 deliberately permits a simplistic auxiliary model to indicate release even though the main is welded; the course must explain why a documented mirror/forced-guided relationship matters.
4. **Diagnostics and physical outcome are independent outputs.** V05/V06 can have the hazard path physically interrupted while diagnostic evidence is unavailable, so rearm remains inhibited.
5. **Two failed interruption paths defeat the abstract architecture.** V07 explicitly reports the hazardous path remains; the simulator must not hide this behind a generic `safe` flag.
6. **Power restoration is not a reset.** V09/V10 preserve deliberate restart/rearm behavior.

## Boundaries

- These vectors do not assign PL, SIL, Category, diagnostic coverage, probability of dangerous failure, stopping distance, or machine-specific suitability.
- They do not establish a press-brake hydraulic safe state, motor standstill, spindle stop, plasma-energy removal, robot safe state, or stored-energy dissipation.
- A real machine exercise must separately identify the hazard boundary and every energy path that must be controlled.
- LinuxCNC and the ordinary OpenPressBrake FPGA may observe/report states but are not promoted to personnel-safety authority by this exercise.

## Compute decision

No execution is justified yet. The remaining DigitalJS question is representational/deterministic and should first be answered by source inspection. Only freeze a local self-hosted prototype if source reasoning leaves a concrete unresolved state-propagation question. GitHub-hosted runners remain prohibited.
