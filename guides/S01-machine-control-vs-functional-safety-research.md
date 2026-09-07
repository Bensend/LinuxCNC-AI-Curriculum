# S01 — LinuxCNC machine control versus functional safety — initial research

Status: **RESEARCH**  
Entry prerequisite: IO07 graduated.

## Objective

Define a hard evidence boundary between LinuxCNC machine-control behavior and a validated functional-safety function. The purpose is not to design a machine-specific safety system at this level; it is to prevent software/HAL/watchdog/estop vocabulary from being mistaken for a PL/SIL/category claim.

## Official LinuxCNC documentation evidence

### Software alone is not a sufficient safety claim

The current LinuxCNC `plasmac(9)` manual includes an explicit safety disclaimer: it states that relying on software alone for safety is extremely unwise, that machinery capable of harming people needs provisions to completely stop motors/moving parts before people enter a danger area, and that machinery must comply with applicable local/national safety codes.

Reference: https://linuxcnc.org/docs/stable/html/man/man9/plasmac.9.html

Evidence class: **DOC-CONFIRMED** for LinuxCNC's documented boundary. This is not itself a machine-specific compliance determination.

### Software limits and physical stopping distance are different

Current Stepconf documentation distinguishes a software-enforced soft limit from a physical limit switch and hard stop. It specifically warns that the distance between a limit switch and hard stop must be sufficient for an unpowered motor to coast to a stop.

Reference: https://linuxcnc.org/docs/html/config/stepconf.html

Evidence class: **DOC-CONFIRMED**. This is useful because it demonstrates, even inside LinuxCNC's own documentation, that software state/commands and physical stopping behavior are not interchangeable.

### A component name containing “safety” is not a certification

Current/devel LinuxCNC contains a HAL component named `safety_latch` that counts/latches error signals and exports `error-out`/`ok-out`. Its manual describes software signal-processing semantics; it does not claim SIL, PL, category, certified diagnostics, safe failure fraction, or a validated external safety function.

Reference: https://www.linuxcnc.org/docs/devel/html/man/man9/safety_latch.9.html

Evidence class: **DOC-CONFIRMED** for component behavior. **No certification inference is permitted from the component name.**

## Community research

Community evidence is retained as field practice and diagnostic context, never as a standards authority.

### External safety architecture is treated separately from LinuxCNC

A 2024 discussion, “Is software Estop allowed,” contains multiple experienced-user responses distinguishing LinuxCNC's software E-stop/control state from hardwired emergency-stop/safety-relay architecture. The thread discusses redundancy, force-guided relays, deliberate reset behavior, and the machine integrator's responsibility for applicable regulations.

Reference: https://forum.linuxcnc.org/24-hal-components/53650-is-software-estop-allowed

Evidence class: **COMMUNITY-REPORTED**.

### Recent field discussion makes the same boundary

A September 2026 discussion, “External ESTOP trouble,” recommends that a compliant external safety circuit establish the safe condition and report that condition to LinuxCNC, rather than depending on LinuxCNC itself to perform the safety function. The discussion cites STO/safety hardware examples for a large machine.

Reference: https://www.forum.linuxcnc.org/9-installing-linuxcnc/59173-external-estop-trouble

Evidence class: **COMMUNITY-REPORTED**. Device/example recommendations are not imported as universal requirements.

### Removing drive power can create a separate control/recovery problem

A 2025 EtherCAT discussion describes a system whose safety relay removes drive power because the drives lack STO, which in turn makes the drives disappear from the fieldbus. Replies discuss sequencing/stopping and bus recovery separately.

Reference: https://forum.linuxcnc.org/ethercat/55333-e-stop-and-ethercat-drives-going-offline

Evidence class: **COMMUNITY-REPORTED**. The important lesson is architectural separation: a safety action can intentionally disrupt the ordinary control/communications system, and recovery behavior is a different engineering problem.

## S01 boundary taxonomy

A fresh AI must classify every “safety” statement into one of these layers before evaluating it:

1. **Software control intent** — LinuxCNC state, HAL pins/signals, GUI/Task commands, software limits.
2. **Fault detection/diagnostics** — amp faults, following error, watchdog flags, stale-feedback monitors, latches.
3. **Control-system fail behavior** — what HostMot2/transport/drive commands do after watchdog, communication loss, disable, or reset.
4. **Physical risk-reduction function** — STO, safe brake control, contactors, safety relays/controllers, guards/interlocks, emergency stop, etc.
5. **Validated functional-safety claim** — requires an explicitly defined safety function and machine-specific evidence such as hazard/risk analysis, required performance target, suitable/certified components and architecture, diagnostic behavior, systematic measures, reaction/stopping-time validation, fault testing, documentation, and applicable legal/standards compliance.

Layers 1–3 may support layer 4 but do not automatically become layer 5.

## Corrections carried forward from IO07

- `joint.N.amp-enable-out=FALSE` means LinuxCNC commands that path disabled; it does not prove torque is absent.
- A HostMot2 watchdog is a machine-control fault-containment mechanism unless the complete architecture has independent evidence for a safety claim.
- A HAL signal named `estop`, `enable`, `fault`, or `safety-*` does not acquire a safety integrity level from its name.
- Same-servo-cycle software response does not establish physical stopping time.
- Stale/frozen feedback during failed communication is a separate hazard from a cleanly processed fault input.

## Research questions opened

1. Precisely document LinuxCNC's user-space/task/I/O-controller E-stop state path and identify which parts are ordinary controller interlocks versus external-input reporting.
2. Inventory official LinuxCNC documentation that explicitly warns about software-only safety or distinguishes soft limits/control functions from physical protection.
3. Trace representative E-stop/enable HAL pins through pinned source without treating them as safety-certified logic.
4. Build an adversarial claims matrix: for each observation (`estop` active, amp-enable false, watchdog bite, limit switch, software limit, STO feedback), list what may and may not be inferred.
5. Decide whether a no-hardware experiment is useful at S01. Likely useful scope: software E-stop state transitions only. Explicitly not useful for proving an emergency-stop safety function.

## Precise next checkpoint

At pinned revision `8bf4605ae81042248add031e94c77300406e0413`, trace the LinuxCNC E-stop/machine-enable state boundary through `iocontrol`, Task/NML, motion enable, and relevant HAL pins. Produce a source guide and call-flow that labels every edge as command, status, diagnostic, or external-interface state. Then compare that source model against the official safety disclaimers above and construct the claims matrix before designing any S01 experiment.
