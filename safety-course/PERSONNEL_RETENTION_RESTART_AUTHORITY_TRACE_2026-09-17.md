# Personnel-Retention / Restart-Authority Trace

Session start UTC: 2026-09-17T22:38:28Z

## Scope

This lesson closes a recurring ambiguity in perimeter-guarded machinery: a guard/light curtain/scanner becoming clear is not necessarily evidence that the hazardous zone is empty. It traces a professional retained-person implementation and converts it into a reusable LinuxCNC/OpenPressBrake safety boundary without assigning personnel-safety authority to LinuxCNC, HAL, or the ordinary FPGA.

## Evidence ledger

### Pilz Key-in-pocket

**DOC-CONFIRMED** — Pilz documents a maintenance safeguarding architecture using PITreader plus PNOZmulti 2 or PSS 4000. A person authenticates before entry; that person's security ID is stored in a safe list in the safety controller; the person retains the transponder while inside; every entered person must sign out after leaving; only when the safe list is empty is the plant released for return to productive operation. Pilz also documents multiple simultaneous entrants and different entry/exit gates.

Source: Pilz, "Access management for your plant and machinery" / Key-in-pocket maintenance safeguarding, accessed 2026-09-17.

**DOC-CONFIRMED** — For large plants without complete visibility, Pilz specifies an additional blind-spot check before restart. This is important because an empty retained-person list proves only that all recorded entrants signed out; it does not physically sense every possible person or obstruction in every blind location.

**DOC-CONFIRMED** — Pilz describes the solution as restart protection while personnel remain in the danger zone. The published architecture places the retained-person state in a safety controller, not in an ordinary HMI or machine PLC status bit.

### SICK contrasting architecture

**DOC-CONFIRMED** — SICK describes robot safeguarding that combines access detection with presence detection: a safety light curtain can form the primary access safeguard while a safety laser scanner detects presence and prevents unintended robot startup. This is a different physical strategy from key-in-pocket: retained-person state is inferred from continuing safety-rated presence detection rather than solely from a personnel sign-in list.

Source: SICK SRAP/sBot Stop application material, accessed 2026-09-17.

## Proof-chain reconstruction

For a retained-person architecture, the useful chain is:

1. **Entry authorization** — an authorized person authenticates at the safeguarded access point.
2. **Retained-person state established** — the independent safety system records that a person has entered / is retained.
3. **Protective access transition** — hazardous operation is brought to the machine-specific safe state required for entry.
4. **Person enters with retention token** — the personal token remains with the entrant.
5. **Additional entrants independently retained** — each person creates their own retained state; one person's exit cannot clear another person's protection.
6. **Exit and sign-out** — each person leaves and deliberately removes their retained state.
7. **Blind-area verification where required** — an empty list is supplemented by the required visibility/presence check for areas the retention method does not directly prove empty.
8. **Safety release becomes possible** — only after the safety-side retained-person conditions are satisfied.
9. **Ordinary machine rearm/start remains separate** — LinuxCNC/HAL/FPGA may receive a safety-permissive/status indication, but a stale or maintained ordinary command must not become a newly intended start merely because the safety side released.
10. **Physical final elements re-enable according to the validated machine architecture** — exact contactors/STO/hydraulic/pneumatic final elements remain machine-specific.

## Claim boundaries

### What an empty retained-person list can prove

**DOC-CONFIRMED / bounded:** in the Pilz architecture, the safe list being empty means the recorded authenticated entrants have signed out.

It does **not** by itself prove:

- every physical person is outside the hazard;
- nobody entered through an uncontrolled route;
- a person did not misuse/share/lose a token;
- a blind area is empty;
- a guard is physically closed and locked;
- final contactors/STO/valves reached their demanded state;
- stored electrical, hydraulic, pneumatic, gravity, spring, thermal, or process energy is absent;
- LinuxCNC's current command is fresh;
- machine START is intended.

Those stronger claims require their own evidence.

## Failure-path analysis

### F1 — One of two people signs out

Required result: the remaining person's retained state continues to block productive release. A shared generic `someone_inside` bit implemented only in LinuxCNC is not an acceptable substitute for the independent safety architecture.

### F2 — Person crosses perimeter, sensor clears behind them

A clear perimeter sensor is insufficient if the person can stand behind it. Either continuing presence sensing, retained-person logic, trapped-key/key-in-pocket logic, or another validated restart-prevention measure must cover the resulting hazard.

### F3 — Safety release occurs while LinuxCNC command remains TRUE

The ordinary command is potentially stale. Safety release must not silently convert it into a new intentional START. Require the machine-specific deliberate rearm/start sequence.

### F4 — HMI/network loses the personnel list

Loss of the ordinary display must not erase the safety controller's retained-person state. Conversely, a stale HMI showing `0 persons` is not current proof. Display safety status with source and freshness.

### F5 — Token lost while person remains inside

Do not invent a universal recovery sequence. The machine requires a controlled, authorized recovery procedure that cannot simply clear the retained state and permit restart without establishing personnel absence. The exact certified product procedure is implementation-specific.

### F6 — Unauthorized/unrecorded entry route

A perfect safe list cannot prove absence of a person who bypassed the controlled entry mechanism. Physical guarding, access-route design, anti-bypass measures, and commissioning challenge remain part of the safety function.

### F7 — Large cell with blind spots

The Pilz evidence explicitly adds a blind-spot check. Human-factors design should make the correct sweep/check natural and difficult to skip; a reset station with poor visibility or an awkward sequence that encourages defeat is an engineering defect to address.

## OpenPressBrake / LinuxCNC transfer

**INFERENCE, safety-bounded:** For an enclosed press-brake cell, robot cell, plasma loading cell, automated feeder, or other LinuxCNC machine large enough for a person to enter and disappear from the perimeter sensor, use the following architecture rule:

> Personnel-presence/restart-prevention authority belongs to the independent safety system. LinuxCNC/HAL/ordinary FPGA may consume diagnostic/permissive state, display it, and sequence normal control, but must not be the sole memory that a person remains inside.

For a conventional operator-front press brake where nobody can bodily enter behind the protective device, the hazard geometry is different; do not cargo-cult a key-in-pocket system merely because it exists. Perform the machine-specific risk assessment and choose the physical safeguard appropriate to the actual hazard boundary.

## Commissioning challenges

1. Enter with person A; verify productive release remains blocked.
2. Enter A then B; sign out A; verify B independently keeps release blocked.
3. Use each permitted access/exit route and verify retained state cannot be accidentally cleared by route choice.
4. Challenge perimeter-clear while a test person remains in a permissible protected test position; verify perimeter clear alone does not establish zone clear.
5. Interrupt HMI/network diagnostics; verify safety-side retained state persists and the HMI fails stale/unknown rather than reassuring.
6. Hold an ordinary LinuxCNC start/jog/enable command across the safety release transition; verify it does not become an unintended restart.
7. Challenge the documented blind-spot verification sequence where the machine has areas without complete view.
8. Verify restoration of guard/retained-person conditions does not itself command hazardous motion.
9. Challenge power restoration in safety controller, LinuxCNC, FPGA/field I/O, and drives independently; retained-person/restart prevention must follow the validated safety architecture, not assumptions about common reboot.

Do not conduct personnel-exposure commissioning on an incompletely validated machine. Use isolated/remote challenge methods and keep people outside the danger zone until the minimum-safe-to-operate gate is satisfied.

## Frozen teaching rule

**ACCESS CLEAR ≠ PERSONNEL CLEAR ≠ RETAINED-PERSON LIST EMPTY ≠ BLIND AREA CLEAR ≠ SAFETY RELEASE ≠ FINAL-ELEMENT PROOF ≠ ORDINARY START AUTHORITY.**

Each transition requires evidence appropriate to the claim.

## Remaining UNKNOWNs

- Exact final-element circuitry used in a particular Pilz key-in-pocket customer machine.
- Product-specific lost-key/key-list-reset recovery details sufficient to prescribe a universal recovery procedure.
- Machine-specific PL/SIL/category requirements for any OpenPressBrake installation.
- Whether any specific OpenPressBrake machine needs bodily-entry restart prevention at all; this depends on installed geometry and access.

These UNKNOWNs do not justify invented values or moving safety authority into LinuxCNC.

## Next evidence target

Trace a complete professional implementation that exposes retained-person/presence logic **and** physical final-element re-enable (contactors, STO, or hydraulic/pneumatic safety elements), then build the end-to-end truth table from person entry through separate ordinary START. If public evidence stops before final elements, rotate to a distinct high-value safety module rather than infer the missing circuit.
