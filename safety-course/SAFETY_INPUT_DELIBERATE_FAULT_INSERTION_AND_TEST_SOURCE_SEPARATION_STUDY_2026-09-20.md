# Safety-input deliberate fault insertion and test-source separation study

Date: 2026-09-20

## Scope

Continue the Lane-B safety-input diagnostic checkpoint with an inspectable manufacturer commissioning/fault-insertion example. This study is generic professional-machine safety architecture; it does not define OpenPressBrake machine-specific wiring or a claimed PL/SIL.

## Evidence

### Pilz PNOZ p1p installation fault insertion

**DOC-CONFIRMED.** Pilz PNOZ p1p operating documentation gives a deliberate installed-system check for the short-across-contacts detection function when cable resistance warrants the check. The procedure starts with the unit active, deliberately shorts test terminals S12 and S22, requires the unit fuse/fault response, then removes the short and power-cycles for recovery. This is materially stronger evidence than merely asserting that test pulses exist: it is a manufacturer-directed injected wiring fault with an observable diagnostic disposition.

Source: Pilz `PNOZ_p1p_Operating_Manual_20674-EN-05`, Wiring section.

**DOC-CONFIRMED.** Pilz separately defines test-pulse outputs as applying specific pulses to inputs when wired appropriately so shorts across contacts can be detected.

Source: Pilz support lexicon, `Test pulse output`.

### Rockwell POINT/FLEX safety input architecture

**DOC-CONFIRMED.** Rockwell safety I/O documentation requires a safety input configured for pulse testing to be associated with a test source. Test outputs used as pulse-test sources permit detection of shorts to positive supply and signal-line/cross-channel faults subject to the actual source assignment.

**DOC-CONFIRMED.** Rockwell documents an important masking limitation: two safety inputs using the *same* test output cannot have a short between those two channels detected by this mechanism. Wiring two channels to different test-output sources is therefore materially different from simply having two physical input conductors.

Sources: Rockwell PointMax/FLEX safety I/O user documentation, `Safety Input Modules in CIP Safety Systems` and `Wiring Diagrams for Safety Mode and Safety Pulse Mode`.

**DOC-CONFIRMED.** Rockwell Guardmaster safety-relay documentation describes pulse testing that detects shorts from an input to +24 V, to common, and between the two input terminals for applicable relay families.

Source: Rockwell `Guardmaster Safety Relays User Manual`, publication 440R-UM013.

### Fault disposition and restart ownership

**DOC-CONFIRMED.** Rockwell ControlLogix safety-system documentation states that a detected safety-I/O failure drives the offending channel/device data to its safe state and reports the failure. It also explicitly assigns the application designer responsibility for latching I/O failures and verifying proper restart.

Source: Rockwell ControlLogix 5590 Controller User Manual, `System Status`.

This prevents a common architectural mistake: a diagnostic bit clearing is not itself a complete return-to-production policy.

## Evidence chain now available

A real manufacturer example now supports:

`INSTALLED FIELD CIRCUIT -> DELIBERATE SHORT INSERTION -> DIAGNOSTIC/FAULT RESPONSE -> SHORT REMOVED -> REQUIRED RECOVERY ACTION`.

The broader reusable architecture is:

`FIELD DEVICE -> INDEPENDENT CHANNELS -> APPROPRIATE TEST SOURCE/DEVICE SELF-TEST -> SAFETY INPUT CONFIGURATION -> DELIBERATE OPEN/SHORT CHALLENGE -> SAFE RESPONSE -> DIAGNOSTIC/LATCH -> FAULT REMOVAL -> SAFETY REQUALIFICATION -> FRESH ORDINARY START`.

Only the first chain is fully witnessed by the located Pilz procedure. The complete second chain remains an engineering validation template assembled from manufacturer evidence; it must not be represented as one universal vendor procedure.

## Durable freezes

- `TWO INPUT WIRES != TWO DIAGNOSTICALLY INDEPENDENT CHANNELS`.
- `DIFFERENT INPUT TERMINALS != DIFFERENT TEST SOURCES`.
- `SAME TEST SOURCE ON BOTH CHANNELS != CROSS-SHORT BETWEEN THOSE CHANNELS DETECTABLE`.
- `TEST PULSE CONFIGURED != FAULT COVERAGE PROVED`.
- `DELIBERATE SHORT INSERTED != EXPECTED SAFE RESPONSE OBSERVED`.
- `FAULT INDICATION PRESENT != ALL HAZARDOUS FINAL ELEMENTS PHYSICALLY SAFE`.
- `FAULT REMOVED != FAULT LATCH CLEARED != SAFETY FUNCTION REQUALIFIED != FRESH PRODUCTION START`.

## OpenPressBrake / LinuxCNC boundary

**INFERENCE.** Ordinary LinuxCNC/HAL or a normal FPGA can consume diagnostic status for HMI, logging, maintenance guidance, or production inhibition, but that does not make those ordinary-control layers the authority that validates safety-input independence or permits personnel exposure.

**UNKNOWN.** Exact OpenPressBrake safety-input hardware, test-source assignment, OSSD compatibility, discrepancy timing, required diagnostic coverage, reset policy, and achieved PL/SIL remain unspecified here. These require the actual safety architecture and its validation basis.

## Human-factors consequence

Commissioning instructions should make the deliberate fault challenge easy and explicit. A dual-channel circuit that visually looks redundant but uses a masking test-source arrangement is a predictable integration trap. The safer wiring and test procedure should be the default documented path rather than relying on the technician to infer diagnostic topology from terminal numbers.

## Compute decision

No simulation or executable lab is justified by this question. The relevant behavior is installation/configuration dependent and manufacturer documentation already provides a direct physical fault-insertion procedure and a documented masking limitation. No GitHub-hosted or self-hosted compute is consumed.

## Next evidence target

Prefer a current manufacturer validation table that deliberately challenges several faults (open circuit, channel-to-channel short, short to +24 V/common, wrong test-source assignment or equivalent) and explicitly records safe-output behavior plus reset/restart disposition. If no higher-information source appears quickly, rotate to another open safety branch rather than repeatedly searching test-pulse manuals.
