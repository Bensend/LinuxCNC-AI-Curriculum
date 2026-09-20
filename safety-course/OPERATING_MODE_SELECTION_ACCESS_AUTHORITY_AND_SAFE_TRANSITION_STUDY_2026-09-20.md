# Operating-mode selection, access authority, and safe-transition study

Date: 2026-09-20
Lane: independent safety curriculum B

## Question

When setup, maintenance, automatic, or other operating modes use different safeguards, what must be safety-related, and what must happen when the mode changes?

## Evidence

### Pilz — operating-mode selector requirements

**DOC-CONFIRMED.** Pilz states that where several operating modes/control sequences require different safety levels, each selector position may enable only one mode; operation of the selector alone may not start the machine; and the selected mode overrides other control functions except emergency stop/emergency off. Pilz further argues that exclusive-mode selection requires safe evaluation rather than relying on a standard controller.

Source: Pilz, “Must an operating mode selector switch be safely evaluated?”, accessed 2026-09-20.

### Pilz — safe evaluation and access permission are related but distinct

**DOC-CONFIRMED.** Pilz PITmode documentation separates access permission from functionally safe operating-mode evaluation. PITmode fusion uses a separate Safe Evaluation Unit to evaluate the selected mode and switch among modes; PITmode flex performs safe evaluation in PNOZmulti 2/PSS 4000. Pilz also recommends restricting mode-selection access to appropriately qualified personnel because mode changes may enable/disable different safeguards.

Source: Pilz PITmode operating-mode selection/access-permission documentation, accessed 2026-09-20.

**DOC-CONFIRMED.** PITmode flex system documentation warns that a defective safety function can cause an unexpected mode switch or failure to switch, states that the safest operating mode should be assigned as MSO1, and calls for a complete functional test after installation and each configuration change by qualified personnel.

Source: Pilz PITmode flex System Description 1005276-EN-07.

### Rockwell — ambiguous mode selection is a safety fault, not a mode

**DOC-CONFIRMED.** Rockwell's GuardLogix Five Position Mode Selector safety instruction exposes separate `No Mode Selected`, `Multiple Modes Selected`, and `Fault Present` states. When Fault Present is set, no mode output can become active; fault reset is a separate transition after the fault conditions are corrected.

Source: Rockwell Automation, Five Position Mode Selector (FPMS), Studio 5000 Logix Designer documentation, accessed 2026-09-20.

### SICK — mode transition must not itself create hazardous motion

**DOC-CONFIRMED.** SICK's Guide for Safe Machinery states that where safeguards are manually disabled for setup/process monitoring, an operating-mode selector is required, automatic control and linked sequences are disabled, hazardous functions require sustained-action control, and hazardous functions are permitted only under reduced-risk conditions such as limited speed/path/duration. It also gives the example that changing between setup and normal operation stops the machine and requires a new manual start command.

Source: SICK, Guide for Safe Machinery, section on disabling safety functions and combining/switching safety functions.

## Architecture freeze

**ACCESS PERMISSION VALID != OPERATING MODE SAFELY SELECTED != EXACTLY ONE MODE VALID != MODE-SPECIFIC SAFEGUARDS VALID != SAFE TRANSITION COMPLETE != SAFETY FUNCTION READY != ORDINARY START REQUEST FRESH != HAZARDOUS MOTION AUTHORIZED.**

Also freeze:

**HMI/LINUXCNC MODE DISPLAY != SAFETY-EVALUATED MODE STATE.**

LinuxCNC, HAL, an ordinary FPGA state machine, or an HMI may request/display a mode and use the safely evaluated mode as an interlock or diagnostic input, but ordinary control must not be the sole personnel-safety authority for a mode that changes safeguarding.

**NO MODE != MULTIPLE MODES != A VALID PRODUCTION OR SETUP MODE.** Ambiguous selector state is a fault/inhibited condition, not permission to choose whichever ordinary-control state appears plausible.

**MODE CHANGE != START.** A mode transition that restores an automatic/production safeguard set must not resurrect a retained LinuxCNC START/CYCLE/JOG request.

## Practical failure paths to teach

1. Selector wiring/input fault yields no valid mode.
2. Two mode inputs are simultaneously asserted.
3. HMI says SETUP while the safety evaluator says AUTO, or vice versa.
4. Access credential is valid but the requested mode is not safely established.
5. Setup mode suppresses a normal safeguard but the required compensating measure (for example enabling device and independently monitored motion constraint) is not valid.
6. Operator changes SETUP -> AUTO while an ordinary START/CYCLE/JOG command is still held or retained.
7. Power is restored with the selector already in a less-protective mode.
8. Mode-selector/safety configuration is replaced or changed without a complete functional revalidation.
9. A conventional key is left permanently in the machine, turning nominal authorization into practical unrestricted access.

## Question-driven commissioning worksheet

For the actual machine, document rather than assume:

- What modes exist, and which safeguards differ in each mode?
- Which device/request selects the mode, and which independent safety logic evaluates it?
- How are `no mode` and `multiple modes` detected and disposed?
- Does selector movement alone ever cause motion? It must not be accepted as a substitute for deliberate motion initiation.
- What safe state is reached during a transition between modes?
- Which safeguards must be proved before the destination mode becomes valid?
- If setup permits access, what compensating safety functions are required before motion (enabling device, SLS, limited path, hold-to-run, etc.)?
- Can stale LinuxCNC/HMI/HAL START, CYCLE, JOG, pedal, or other ordinary command survive a mode transition and create motion when safety authority returns? Challenge this explicitly.
- What happens at cold start when the selector is already in SETUP or another reduced-protection mode?
- What access control prevents casual/unauthorized selection, and does loss of access permission revoke or merely prevent future selection? Record the documented design rather than guessing.
- After selector, evaluator, credential system, or configuration replacement, what functional revalidation is required?
- Does the physical final element and machine behavior match the selected mode's safety claim?

## Evidence status

- Requirement that each selector position exclusively enable one mode: **DOC-CONFIRMED** (Pilz).
- Selector operation alone must not initiate machine operation: **DOC-CONFIRMED** (Pilz).
- Safe evaluation/access-permission architectures exist as separate functions: **DOC-CONFIRMED** (Pilz).
- No-mode/multiple-mode states can be explicit safety faults inhibiting mode outputs: **DOC-CONFIRMED** (Rockwell).
- Setup with safeguards disabled requires compensating reduced-risk controls and mode transition should not itself restart: **DOC-CONFIRMED** (SICK).
- OpenPressBrake's required modes, selector hardware, access policy, safety evaluator, transition sequence, mode-dependent safeguards, permitted setup motion, safe speed/path, PL/SIL/category/DC/CCF, hydraulic response, stopping performance, and production-start sequence: **UNKNOWN**.
- Any actual OpenPressBrake mode-transition test result: **UNKNOWN**, not TEST-CONFIRMED.

No COMMUNITY-REPORTED claim is used as design authority in this study. No SOURCE-CONFIRMED code claim is needed for this documentation lane.

## OpenPressBrake boundary

Do not infer that OpenPressBrake requires PITmode, GuardLogix, a key selector, a particular number of modes, a particular setup speed, or any named safety performance level. Those examples establish architecture and failure-path patterns only.

A future OpenPressBrake implementation should keep ordinary LinuxCNC/FPGA mode behavior subordinate to the independently established safety-mode authority whenever mode selection changes personnel safeguards.

## Next independent evidence target

Find a complete professional machine implementation or commissioning procedure showing:

`authorized mode request -> exclusive safety-evaluated mode -> no/multiple-mode fault handling -> safe transition with motion inhibited -> destination-mode safeguard/compensating-function proof -> separate fresh deliberate motion command -> actual final element -> physical machine witness`

Prefer an implementation that also documents cold-start behavior and a deliberate stale-command or mode-input fault challenge. Do not copy machine-specific numerical limits.