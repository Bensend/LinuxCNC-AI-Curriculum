# Rockwell PlantPAx maintenance ownership persistence and fresh-start boundary

Session: 2026-09-21

## Why this matters
The preceding exceptional-state work asked whether clearing or hiding a commissioning state can be assumed after reboot, mode transition, or return to automatic operation. PlantPAx provides unusually explicit evidence that this assumption is unsafe.

## Authoritative evidence

### DOC-CONFIRMED — maintenance acquisition persists
Rockwell Studio 5000 documentation for the PlantPAx Process Discrete Output (`PDO`) states on instruction first run that the **Maintenance acquired/released state is not modified and persists through a controller powerup or PROG-to-RUN transition**. The same behavior is documented for Process Analog Output (`PAO`).

This is direct evidence that:

**POWER CYCLE != MAINTENANCE OWNERSHIP CLEARED**

and

**PROG-to-RUN != MAINTENANCE OWNERSHIP CLEARED**.

### DOC-CONFIRMED — command-source classes are explicit and prioritized
The PlantPAx `PCMDSRC` instruction has explicit command sources including Hand, Out-of-Service, Maintenance, Override, External, Program and Operator. Maintenance acquisition/release is commanded explicitly (`MCmd_Acq`, `MCmd_Rel`). Maintenance supersedes ordinary Operator/Program/External/Override sources in the documented priority model.

### DOC-CONFIRMED — bypass clearing is an explicit action
PlantPAx device instructions including `PVLV`, `PNPOS`, `PAO` and `PLLS` expose `MCmd_Bypass` and a distinct `MCmd_Check`. Rockwell describes `MCmd_Check` as checking rather than bypassing interlocks/permissives; for PVLVMP/PNPOS it explicitly says it removes bypass and checks all interlocks/permissives. These command operands are automatically cleared after execution, but that command-pulse behavior must not be confused with the resulting device state.

### DOC-CONFIRMED — physical/virtual selection can also be explicit
PlantPAx device objects such as PVLV/PNPOS expose Maintenance commands selecting Physical device operation, and PNPOS additionally exposes Virtual operation. This demonstrates that maintenance ownership, bypass state, and physical/virtual selection are distinct exceptional-state dimensions rather than one generic maintenance bit.

## Engineering interpretation

The sources justify a stronger handoff model than "reboot it before production":

1. positively remove bypass / restore interlock checking;
2. positively restore physical rather than simulated/virtual device operation where applicable;
3. release Maintenance ownership / restore the intended normal command source;
4. independently disposition controller forces and baseline changes;
5. inspect non-machine-readable temporary aids;
6. only then permit a fresh ordinary production start request.

This ordering is a curriculum **INFERENCE** from documented state semantics. It is not a claim that PlantPAx itself implements a universal production-release sequence.

## Fresh-start boundary

The public documentation inspected establishes explicit exceptional-state clearing and persistence semantics, but it does not prove that every PlantPAx device universally requires a new operator START after Maintenance is released or bypass is cleared. Therefore:

- **DOC-CONFIRMED:** Maintenance state can persist across powerup and PROG-to-RUN.
- **DOC-CONFIRMED:** Maintenance acquisition/release and bypass/check are explicit operations.
- **INFERENCE:** a machine design should require a fresh ordinary start edge after exceptional-state cleanup rather than allowing cleanup itself to become motion authority.
- **UNKNOWN / machine-specific:** exact restart sequencing for a particular machine and device object.

This uncertainty is important: do not invent an automatic-restart guarantee or prohibition from generic PlantPAx documentation.

## Safety authority boundary

A fresh ordinary START discipline reduces accidental restart after maintenance, but it is not a substitute for safety reset/rearm, personnel-clear verification, protective-device behavior, or safety-rated final-element control. Conversely, a valid safety reset must not silently clear Maintenance ownership, software bypasses, virtual-device selection, forces, or physical test aids.

Freeze:

- **POWER CYCLE != MAINTENANCE STATE SANITIZED.**
- **PROG-to-RUN != PRODUCTION HANDOFF COMPLETE.**
- **BYPASS CLEARED != MAINTENANCE OWNERSHIP RELEASED.**
- **MAINTENANCE OWNERSHIP RELEASED != PHYSICAL DEVICE MODE PROVED.**
- **EXCEPTION CLEANUP ACTION != NEW START AUTHORITY.**
- **SAFETY RESET != ORDINARY COMMISSIONING-STATE CLEANUP.**

## Human-factors consequence

A machine that requires a technician to remember which hidden state survives reboot is badly shaped for safe handoff. The HMI/normal-control layer should show persistent maintenance/virtual/bypass state prominently and refuse production handoff until each applicable class has positive disposition. Reboot should never be taught as a cleanup procedure unless the exact platform documentation proves the relevant state is cleared.

## Sources
- Rockwell Automation, Studio 5000 Logix Designer, `Process Discrete Output (PDO)`, current online help retrieved 2026-09-21.
- Rockwell Automation, Studio 5000 Logix Designer, `Process Analog Output (PAO)`, current online help retrieved 2026-09-21.
- Rockwell Automation, Studio 5000 Logix Designer, `Process Command Source (PCMDSRC)`, current online help retrieved 2026-09-21.
- Rockwell Automation, Studio 5000 Logix Designer, `Process Valve (PVLV)`, `Process n-Position Device (PNPOS)`, `Process Lead Lag Standby Motor Group (PLLS)`, current online help retrieved 2026-09-21.

## Next
Use this evidence in a 25C0 adversarial handoff exercise: maintenance ownership survives a reboot, bypass has been cleared, the safety system is healthy, and the learner must identify what still blocks ordinary production release and what requires an independent fresh start. Then rotate toward a different open 25C0/25E0 human-factors failure surface rather than continuing generic PlantPAx searches.
