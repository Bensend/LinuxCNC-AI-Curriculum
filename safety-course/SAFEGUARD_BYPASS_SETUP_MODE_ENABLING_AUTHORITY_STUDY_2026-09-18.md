# Safeguard Bypass, Setup Mode, and Enabling-Device Authority Study — 2026-09-18

## Lane / scope

Independent LinuxCNC/OpenPressBrake safety-curriculum Lane B. This study intentionally avoids the primary lane's current hydraulic final-element disagreement / physical stop-performance work and the immediately preceding Lane-B safety-input test-pulse/cross-fault work.

Question: when a normal guard or protective device must be suspended for setup, adjustment, troubleshooting, or maintenance motion, what architecture prevents `bypass` from silently becoming ordinary production authority?

This is an architecture/source-tracing study, not an OpenPressBrake safety design. Machine-specific applicability, permissible motions, speeds, forces, stopping performance, hydraulic states, PL/SIL/category/DC/CCF, and physical safeguard requirements remain UNKNOWN until the actual machine is assessed and authoritative requirements are applied.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly supported by an authoritative manufacturer/regulatory/standards-oriented source cited here.
- **DOC-CONFIRMED** — confirmed by a repository-controlled document or implementation artifact.
- **TEST-CONFIRMED** — demonstrated by a reproducible test on the relevant implementation.
- **COMMUNITY-REPORTED** — reported by practitioners but not independently verified.
- **INFERENCE** — engineering conclusion derived from evidence, explicitly not claimed as source text.
- **UNKNOWN** — requires machine-specific evidence, measurement, risk assessment, or authoritative requirement.

## Architecture freeze

**MODE SELECTED != BYPASS REQUESTED != BYPASS SAFETY CONDITIONS VALID != NORMAL SAFEGUARD SUSPENDED != SUBSTITUTE SAFETY FUNCTION VALID != ENABLING DEVICE IN VALID MID POSITION != HAZARDOUS MOTION AUTHORIZED != PHYSICAL MOTION SAFE.**

And on return:

**BYPASS RELEASED != NORMAL SAFEGUARD RESTORED/PROVEN != SAFETY REARM COMPLETE != FRESH ORDINARY START/JOG/CYCLE INTENT.**

A bypass is therefore not a Boolean shortcut around safety. It is a constrained change of safety architecture: the normal protective function may be suspended only while an alternate, explicitly bounded protection scheme is valid.

## Source trace

### 1. SICK — manual temporary disabling of safety functions

**SOURCE-CONFIRMED.** SICK's *Guide for Safe Machinery* states that when setup/process monitoring requires a guard displaced/removed or protective device disabled, the arrangement uses an operating-mode selector and must disable automatic control and linked sequences. Hazardous functions are to require sustained-action controls such as enabling devices and be restricted by reduced-risk conditions such as speed, movement path, or function duration. It also gives a mode-change example in which the machine stops and requires a new manual start command.

Source: https://cdn.sick.com/media/docs/8/78/678/Special_information_Guide_for_Safe_Machinery_en_IM0014678.PDF

This is strong architecture evidence for separating `setup selected`, `normal safeguard suspended`, `sustained human enabling`, `reduced-risk motion`, and `fresh start after mode change`.

### 2. SICK — bypass does not mean no safety function remains

**SOURCE-CONFIRMED.** SICK UE440/UE470 documentation describes bypass as muting controller OSSDs for applications such as safe machine setup/jog. Critically, it warns that while bypass is active the OSSDs do not switch the controller off (apart from assigned E-stop behavior) and therefore *other protective measures* must be active, e.g. the machine's safe setup mode.

Source: https://www.sick.com/media/docs/3/53/153/operating_instructions_ue440_ue470_compact_safety_controller_en_im0014153.pdf

**INFERENCE:** `BYPASS ACTIVE` is not a safety-state proof by itself; it is evidence that the normal protective path has been intentionally suspended and the substitute protective path must now carry the safety claim.

### 3. Pilz — three-position enabling device

**SOURCE-CONFIRMED.** Pilz describes PITenable as a three-level enabling switch for work in a machine danger zone when a protective device must be suspended. The states are Off-On-Off: the middle position enables the function, while sudden release or full depression invokes the protective function and brings the machine to a standstill. This specifically addresses both release and panic/grip-through behavior rather than treating `button pressed` as sufficient.

Source: https://www.pilz.com/en-GB/products/operating-and-monitoring/control-and-signal-devices/pitenable-enabling-switch

### 4. SICK — independent enabling-device implementation

**SOURCE-CONFIRMED.** SICK E100 likewise uses a three-stage enabling switch for setup/maintenance operation; machine movement is enabled only in the middle position. This independently supports the Off-On-Off architecture.

Source: https://www.sick.com/cn/en/catalog/products/safety/safety-switches/e100/c/g195532

### 5. Rockwell — maintenance motion has its own permissive boundary

**SOURCE-CONFIRMED.** Rockwell's GuardLogix Maintenance Manual Valve Control (MMVC) instruction is intended for manual press-valve operation during maintenance, not press production. Its documented permissive includes a key switch, stopped flywheel, slide at bottom-dead-center, and Safety Enable input. Rockwell also warns to visually verify the physical press state before activating the key switch/enabling the valve.

Source: https://www.rockwellautomation.com/en-ua/docs/studio-5000-logix-designer/37-00/contents-ditamap/instruction-set/metal-form-instructions/mmvc.html

This is useful evidence that maintenance motion is not simply `normal output command with guard bypassed`; professional implementations can expose a distinct maintenance-only motion authority with explicit safety/physical preconditions.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC/HAL/ordinary FPGA may legitimately:

- request or display operating mode;
- request a setup/jog motion;
- display bypass/enabling diagnostics;
- limit ordinary commanded velocity or path as an additional control measure;
- refuse production sequencing while setup mode is active.

But if personnel safety relies on setup-mode selection, safeguard suspension, enabling-device state, safe speed/direction/position, or hazardous-energy removal, the independent safety architecture must establish those claims. An ordinary LinuxCNC velocity limit is not automatically Safely Limited Speed, and an ordinary HAL `enable` is not automatically a safety-rated enabling function.

## Required state decomposition

A learner must draw these as separate states/signals where applicable:

1. normal production mode selected;
2. setup/maintenance mode selected and valid;
3. normal safeguard state;
4. bypass request;
5. bypass accepted by safety authority;
6. substitute safety functions active/valid;
7. three-position enabling device: released / valid middle / overtravel;
8. sustained jog/manual motion intent;
9. any safety-rated speed/direction/position witness;
10. safety output/final-element authority;
11. direct physical motion/energy witness where required;
12. bypass/setup fault latch;
13. normal safeguard restored and proven;
14. deliberate reset/rearm;
15. fresh ordinary START/CYCLE intent.

## Failure-path / commissioning worksheet

| Challenge | Expected architecture question | Evidence status |
|---|---|---|
| Guard opened in production mode | Does normal safeguarding remove hazardous-motion authority? | machine-specific UNKNOWN |
| Bypass requested without valid setup mode | Does safety authority reject it? | implementation TEST required |
| Setup mode selected while automatic cycle command is active | Are automatic/linked sequences inhibited? | SOURCE-CONFIRMED principle; implementation TEST required |
| Enabling device released during setup motion | Does safety motion authority drop independently of LinuxCNC? | SOURCE-CONFIRMED device principle; implementation TEST required |
| Enabling device squeezed through to stage 3 | Does panic/overtravel remove authority rather than continue motion? | SOURCE-CONFIRMED device principle; implementation TEST required |
| Enabling device held in valid middle position before mode transition | Is a fresh valid sequence required, or can stale enabling become authority? | UNKNOWN; design/validation question |
| Ordinary LinuxCNC jog remains asserted while enabling device drops and returns | Can stale jog become fresh motion without a new human action? | must be challenged; machine-specific result UNKNOWN |
| Safety-rated reduced-speed witness is invalid/lost | Is bypass/setup motion inhibited even if LinuxCNC command is slow? | required architecture question; implementation UNKNOWN |
| Wrong direction/path while still below a speed limit | Are other relied-upon safe-motion constraints independent? | machine-specific UNKNOWN |
| Power cycle with bypass selector still selected | Does recovery preserve inhibit until substitute protections and deliberate rearm are valid? | implementation UNKNOWN |
| Bypass indication fails | Can operator still distinguish degraded safeguarding state? | validation question |
| Bypass defeated/stuck active | Is normal production prevented and fault exposed? | implementation UNKNOWN |
| Normal guard closes while bypass remains active | Is guard closure incorrectly treated as normal safeguarding restored? | must not collapse states |
| Return to production mode | Is normal safeguard proven, setup authority removed, machine stopped as required, and fresh ordinary START required? | SOURCE-CONFIRMED mode-change principle; implementation TEST required |
| E-stop demand during bypass | Does E-stop retain its defined authority independent of the bypass path? | source examples support separation; actual machine UNKNOWN |
| Safety output drops but physical hazard continues | Is final-element/physical witness evaluated separately? | must be challenged; actual reaction UNKNOWN |

## Anti-patterns to teach explicitly

- `if setup_mode then ignore_guard` in ordinary HAL/PLC logic with no substitute safety function.
- Treating a keyed selector as hazardous-motion permission by itself.
- Treating an ordinary momentary button as equivalent to a three-position enabling device.
- Allowing automatic or linked sequences while the architecture claims sustained manual setup control.
- Assuming a low LinuxCNC commanded speed proves actual safe speed.
- Letting a held JOG/START command resume automatically when the enabling device or bypass permission returns.
- Treating bypass indication as proof the hazard is controlled.
- Returning to production merely because the guard is closed, without proving the normal safeguard path and requiring the appropriate deliberate rearm/fresh production intent.

## What this study does NOT freeze

The following remain **UNKNOWN** for OpenPressBrake until measured/selected/validated:

- whether any safeguard bypass is permissible or required;
- which operating modes exist;
- which safeguards may be suspended in any mode;
- required enabling-device architecture;
- safe setup speed, force, direction, travel/path, or duration;
- stopping time/distance;
- hydraulic valve state, pressure, load-retention behavior, or rescue behavior;
- safety controller/I/O/drive selection;
- required PL/SIL/category/DC/CCF;
- reset/restart sequence;
- applicable machine-specific/type-C requirements.

## Durable curriculum takeaway

When normal safeguarding must be suspended, teach the learner to trace the *replacement safety architecture*, not the word `bypass`:

`authorized mode -> bypass request -> safety-side acceptance -> normal safeguard suspended -> substitute safety functions proven -> three-position enabling + sustained motion intent -> safety final element -> physical motion witness -> release/panic/fault safe reaction -> normal safeguard restoration -> reset/rearm -> separate fresh ordinary START`.

## Precise next-work checkpoint

Find a complete professional implementation—preferably a press, press brake, robot cell, or comparable hazardous machine—that exposes the entire chain:

`mode selector -> safeguard bypass/suspension -> substitute SLS/SDI/SOS or equivalent reduced-risk function -> three-position enabling device -> sustained manual motion -> final element -> enabling release/overtravel fault -> physical motion stop witness -> bypass removal -> normal safeguard proof -> reset/rearm -> separate fresh production START`.

Prefer documentation with a wiring/function diagram and at least one commissioning fault such as stuck enabling contact, invalid mode, loss of safe-motion feedback, bypass stuck active, or power restoration during setup.