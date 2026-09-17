# Safety Status and Diagnostic Annunciation Boundary

Date: 2026-09-17

## Purpose

Prevent an HMI, LinuxCNC screen, FPGA status register, ordinary PLC bit, stack light, or generic `SAFE` indicator from collapsing several different safety-relevant physical states into one overclaim.

The core rule is:

> **Diagnostic knowledge is not physical safety state, and one positive status must not imply more than its evidence actually proves.**

This module is generic/public curriculum material. It does not claim any OpenPressBrake-specific safety wiring, hydraulic truth table, stopping performance, PL/SIL/DC, or final-element behavior.

## Evidence ledger

### DOC-CONFIRMED — reset is not restart

SICK Flexi Soft operating instructions define reset as returning the protective device to monitoring/releasing restart interlock, while machine restart requires a second, separate start command. Reset itself must not introduce movement or a dangerous situation.

Source: SICK, *Flexi Soft in Flexi Soft Designer*, operating instructions 8012480/1T57/2025-07-30, glossary entries `Reset` and `Restart interlock`.

### DOC-CONFIRMED — safety, diagnostic, and non-safe data are distinct

SICK Flexi Soft Safety Designer explicitly distinguishes safe data from diagnostics and non-safe data in its logic editor. Function blocks may expose separate `Release`, `Reset required`, and optional `Fault present` outputs. A cleared diagnostic fault therefore does not by itself establish release, physical final-element state, absence of stored energy, or permission to start.

Source: SICK, *Flexi Soft in the Safety Designer*, operating instructions 8014519/T157/2025-07-30, section 9.

### DOC-CONFIRMED — a safety-module status output has bounded meaning

Pilz PMCprotego safe-motion documentation distinguishes safe restart interlock from safe status output and exposes status such as `Ready`, `FSRUN`, and `FAULT`. The existence of a safe status output is evidence for the safety module's documented state; it is not evidence that every external contactor, hydraulic valve, brake, trapped-energy volume, guard, or machine zone is physically safe unless the architecture separately establishes those claims.

Source: Pilz, *Safe motion with safety card PMCprotego S*, current product/application documentation inspected 2026-09-17.

### DOC-CONFIRMED — diagnostics may be detailed without becoming the safety function

Pilz Safety Device Diagnostics and IO-Link Safety material describes diagnostic/status data as a way to improve transparency, fault diagnosis, maintenance and availability. This supports preserving diagnostic detail rather than replacing it with one synthetic `SAFE` bit.

Sources: Pilz, *Safety Device Diagnostics* and *IO-Link Safety – safe communication up to field level*, inspected 2026-09-17.

## State vocabulary that must remain separate

A machine interface should not merge these without explicit evidence:

1. `SAFETY_CONTROLLER_RUNNING` — safety logic/controller is executing its validated configuration.
2. `PROTECTIVE_DEVICES_CLEAR` — relevant guard/light-curtain/E-stop inputs are in the state required by the safety function.
3. `SAFETY_DEMAND_ACTIVE` — at least one safety function is presently demanding a stop/inhibit/restricted state.
4. `RESET_REQUIRED` — safety logic requires deliberate reset before release/restart progression.
5. `SAFETY_RELEASE_AVAILABLE` — safety logic has satisfied its documented conditions to release a safety output/function.
6. `FINAL_ELEMENT_FEEDBACK_OK` — EDM/valve/brake/contact feedback agrees with the commanded state within the validated architecture.
7. `MOTION_SAFE_STATE_PROVED` — the applicable safe-motion function has established its documented state, where one exists.
8. `HAZARDOUS_ENERGY_ABSENT` — the physical hazardous-energy boundary has been directly established for the relevant task. This is a stronger and different claim than output OFF.
9. `STO_ACTIVE` — a drive's STO function is active where applicable. This does not mean mains/DC bus is isolated or a gravity load is mechanically retained.
10. `ORDINARY_CONTROL_REARMED` — LinuxCNC/PLC/FPGA ordinary control has accepted fresh commands after recovery.
11. `START_PERMITTED` — the machine's complete restart conditions allow a deliberate start command.
12. `MACHINE_RUNNING` — ordinary machine sequence is active.
13. `DIAGNOSTIC_FAULT_PRESENT` — a fault has been detected and annunciated; this is diagnostic knowledge, not itself a physical hazard-state witness.
14. `STATUS_UNKNOWN` — evidence is missing, stale, contradictory, or not applicable.

## Why a single `SAFE` lamp is dangerous

A generic green `SAFE` indication can be interpreted by different people as any of the following:

- guard closed;
- E-stop released;
- safety controller healthy;
- safety outputs released;
- contactors actually open;
- hydraulic pressure absent;
- ram mechanically restrained;
- servo torque unavailable;
- stored energy discharged;
- maintenance may begin;
- machine may restart.

Those meanings are not equivalent. If the indicator is retained for operator convenience, its label and documentation must bound it to the exact condition it represents. For example, `GUARDS CLEAR` or `SAFETY RESET REQUIRED` communicates substantially more safely than an unexplained `SAFE`.

## HMI/diagnostic architecture

### Layer 1 — safety authority

Safety-rated controller/relay/device and its validated field wiring execute the safety function. Ordinary LinuxCNC, HAL, HMI, Ethernet, and the normal FPGA are not promoted to safety authority merely because they display the result.

### Layer 2 — safety status export

Where the safety architecture provides status/diagnostic outputs, export them with explicit semantics and freshness. Prefer several bounded states over a synthetic aggregate.

### Layer 3 — ordinary-control interpretation

LinuxCNC/HAL/FPGA may use exported status to inhibit normal commands, explain why motion is unavailable, log faults, or guide recovery. Failure of this layer must not defeat the independent safety function.

### Layer 4 — human annunciation

Display the actual condition and required action. Examples:

- `E-STOP ACTIVE — DEVICE E3`
- `GUARD G2 OPEN`
- `LIGHT CURTAIN LC1 BLOCKED`
- `RESET REQUIRED`
- `CONTACTOR FEEDBACK DISAGREEMENT`
- `SAFE SPEED NOT PROVED`
- `SAFETY STATUS STALE / UNKNOWN`
- `ORDINARY CONTROL REARM REQUIRED`

Avoid `SAFE`, `OK`, or `READY` when the user could reasonably infer a broader physical state than is proved.

## Freshness rule

A previously true status is not permanently true. A network/HMI/FPGA diagnostic consumer must distinguish:

`VALUE` + `SOURCE` + `FRESHNESS` + `APPLICABILITY`.

If the status path is stale, disconnected, rebooting, configuration-mismatched, or otherwise uncertain, the display must degrade to `UNKNOWN/STALE`, not preserve the last reassuring state.

This is ordinary diagnostic integrity unless the status path itself is part of a validated safety function.

## Reset/restart display rule

Preserve the state sequence:

`SAFETY DEMAND` -> `HAZARD RESPONSE` -> `DEMAND CLEARED` -> `RESET REQUIRED` -> `SAFETY FUNCTION RESET/RELEASE` -> `ORDINARY CONTROL REARM` -> `DELIBERATE START` -> `MOTION`.

A UI must not silently map `demand cleared` to `ready to run`, nor `reset` to `start`.

## Maintenance rule

No HMI indication should be the sole basis for servicing when hazardous energy must be isolated, discharged, blocked, restrained, or otherwise physically controlled. Maintenance verification follows the relevant energy boundary and physical witness.

Home-shop application: if the machine is left unsafe, incomplete, bypassed, partially disassembled, or not safe to operate, use unmistakable `OUT OF SERVICE / DO NOT OPERATE` status. That tag communicates the condition; it does not replace physical hazard control before work.

## Adversarial challenge set

1. HMI shows `SAFE` because all E-stops are released, but a guard is open. **Reject the aggregate.** E-stop span and guard state are separate.
2. Safety controller reports `Release=1`, but EDM reports a contactor disagreement. **Do not claim final-element proof.** Investigate the disagreement and inhibit restart per the validated architecture.
3. STO status is active on a vertical servo. **Do not claim the load is retained.** Brake/load-retention proof is separate.
4. Hydraulic valve command is OFF and HMI pressure reads zero. **Do not claim a trapped branch is depressurized** unless the observation point is known to witness that volume.
5. Light curtain clears after obstruction. **Do not automatically restart.** Respect restart interlock/reset/start architecture.
6. Safety controller reboots and the HMI retains the last green status. **Mark stale/unknown.** Do not use retained display state as current evidence.
7. LinuxCNC restarts with its own enable bit false while safety outputs are released. **This is ordinary-control state**, not proof of physical energy isolation.
8. Diagnostic fault clears after reset. **Fault cleared != safety release != final-element proof != start.**
9. Guard is locked and status says `LOCKED`. **Do not infer hazard absence.** Lock state and hazard state answer different questions.
10. Operator asks for one green lamp. **Permit only a narrowly named aggregate whose exact conditions are documented**; retain detailed states for diagnosis and never label it simply `SAFE` if broader interpretations are plausible.

## Design review questions

- What exact physical/logical fact does each displayed state prove?
- What evidence source establishes it?
- Can that source be stale?
- Does the displayed label imply more than the source proves?
- Are `reset required`, `release`, `fault`, final-element feedback, and ordinary rearm separately observable?
- Does any ordinary controller synthesize a safety state that should instead come from the safety system?
- Can one broken wire/common return/config mapping falsely make several displayed states agree?
- What remains energized when each stop state is displayed?
- What physical witness is required before maintenance?
- After power/comms recovery, can a retained green status survive without fresh evidence?

## Curriculum freeze

`SAFETY STATUS != DIAGNOSTIC STATUS != FINAL-ELEMENT PROOF != ENERGY ISOLATION != ORDINARY CONTROL READY != START AUTHORITY`.

A professional interface should expose enough of those distinctions that an operator or maintainer is not encouraged to defeat safeguards merely to discover why the machine will not run.

## Deliberate UNKNOWNs

For any particular machine, until its evidence is inspected:

- exact safety-function spans;
- exact safety status outputs;
- EDM/valve/brake feedback topology;
- which hazards remain energized after each demand;
- safe-motion implementation;
- restart/reset locations;
- required physical maintenance witnesses;
- stopping/pressure/timing acceptance values;
- PL/SIL/DC.

These remain machine-specific and must not be invented from the generic annunciation model.
