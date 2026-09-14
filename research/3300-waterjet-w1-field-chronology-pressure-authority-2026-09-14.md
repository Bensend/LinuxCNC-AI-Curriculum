# 3300-W1 — waterjet field chronology, de-energized process state, and pressure-authority boundary

Date: 2026-09-14
Status: COMMUNITY-REPORTED real-machine chronology + vendor process comparator + bounded public-source search

## Purpose

Continue the W1 search for a defensible 3-axis waterjet process contract without copying plasma semantics or inventing a pump-ready state that has not been observed in a LinuxCNC implementation.

This pass targeted later chronology in an existing 2022 retrofit thread, an older converted FLOW machine, and industrial waterjet process documentation that distinguishes machine-controller requests from pump/pressure subsystem ownership.

## Real implementation E — 2022 Chinese water-cutter retrofit chronology

Source: LinuxCNC forum thread `Water cutter retorfit`, pages 1-3, November-December 2022.

Thread URL: https://forum.linuxcnc.org/plasma-laser/47355-water-cutter-retorfit

The chronology materially advances the earlier first-page evidence:

1. The original machine exposed distinct operator/process surfaces for water, machine oil, pump oil and aggregate/abrasive.
2. The abrasive/sand-blast function and main water valve were reported as pneumatic devices actuated through solenoids connected to the original controller.
3. By 24 November the replacement LinuxCNC/Mesa control had basic motion working; the owner then explicitly asked how to replace spindle-style UI/CAM controls with separate water and aggregate on/off behavior.
4. By 28 November the owner had the machine moving without following errors and was wiring process relays.
5. The physical waterjet command on this machine was deliberately **active-low**: the owner reported `0 = on` and `1 = off` so that controller shutdown would cause the system to depressurize. Community guidance noted that LinuxCNC HAL can invert output logic and that interface startup state must be considered rather than assuming logical TRUE means the physically safe state.
6. On 9 December the owner reported that the "CNC bit" was working. Operation of the complete machine was then blocked by hydraulic leaks, not by the LinuxCNC control conversion.

### Durable lessons

This is stronger commissioning evidence than a static machine description because it preserves the progression from unknown wiring -> motion -> process-output integration -> working CNC control -> independent hydraulic-system defect.

The machine reinforces these boundaries:

`logical process request != field electrical polarity != valve pneumatic state != pressure-system state`

and:

`LinuxCNC control operational != high-pressure hydraulic system healthy`

A production waterjet playbook must therefore document the **de-energized physical state** of each process output. A HAL boolean name alone is insufficient evidence of what loss of PC/Mesa/controller power does to the water valve or pressure circuit.

The reported active-low choice is machine-specific field evidence, not a universal recommendation. Fail-safe/depressurization behavior has to be established from the actual valve/pump hydraulic design and external safeguarding architecture.

## Real implementation F — converted FLOW machine longevity evidence

Source: LinuxCNC forum thread `LinuxCNC Error message on converted FLOW WaterJet`, October 2022.

Thread URL: https://forum.linuxcnc.org/24-hal-components/47189-linuxcnc-error-message-on-converted-flow-waterjet

The owner reported that a FLOW waterjet originally controlled by Windows XP had been converted to LinuxCNC roughly 8-9 years earlier and had been extremely reliable until a PC hardware failure. Diagnostic output shows an old LinuxCNC 2.6 pre-release environment and a Mesa 5i25/7i77-class hardware stack.

This is useful **deployment/longevity evidence**, but the public thread does not expose the process HAL/remaps, pump READY, pressure qualification or abrasive timing. It must not be treated as process-sequence evidence.

A second durable lesson is that long-lived machine availability can depend on non-process peripherals: this machine failed LinuxCNC startup after a motherboard change because `hal_input` could not become ready when the USB jog-controller dongle was absent. Restoring the dongle restored operation. That is a commissioning/maintainability reminder, not a waterjet process contract.

## Industrial comparator — controller request versus pump subsystem ownership

### Hypertherm Phoenix waterjet process documentation

Public Phoenix documentation describes a low-pressure-pierce mode where the CNC can:

- select low-pressure pierce in the part program;
- optionally provide a pressure setpoint when serial communication exists;
- otherwise assert a dedicated **Low Pressure Pierce output** to an input on the pump PLC;
- dwell to allow the waterjet pump to transition to the requested lower pressure before proceeding.

This is not LinuxCNC evidence and is not imported as a LinuxCNC implementation. It does, however, establish a real industrial architecture in which **the CNC requests a pressure mode while a separate pump controller/PLC owns the pump transition**.

That strengthens the W1 search model:

`recipe / pierce mode -> machine-controller pressure request -> pump controller/PLC -> physical pressure system -> readiness/fault witness -> cut authorization`

The missing LinuxCNC evidence is specifically the right half of that chain: what real retrofit observes to decide the requested pressure state has actually been achieved, and what it does on timeout/fault.

### OMAX process comparator

OMAX documentation independently shows that process sequencing is recipe/equipment-dependent:

- Vacuum Assist is intended to eliminate abrasive-feed delay for brittle-material piercing;
- low-pressure stationary piercing and dynamic pressure adjustment are supported;
- automated Air Sweep can divert water and purge the nozzle/abrasive path after a clog.

Again, this is physical/process evidence rather than LinuxCNC implementation evidence. It reinforces that abrasive availability, water/pressure command, clog detection and purge/recovery are distinct states. It also further invalidates any universal water-first/abrasive-second assumption.

## Public-source search result — pump READY still not exposed

A fresh bounded search targeted LinuxCNC + `pump ready`, `intensifier`, `high pressure valve`, `pressure switch`, `abrasive sender`, `low pressure pierce`, and `vacuum assist`.

Results surfaced real waterjet machines and process discussions but no downloadable LinuxCNC HAL/remap/custom component that exposes a complete pump-start -> pressure-request -> READY/fault -> water/abrasive sequence.

Classification: **SOURCE-AVAILABILITY GAP**, not proof that such implementations do not exist.

## Updated W1 process decomposition

Evidence now supports preserving these layers separately:

1. **Program recipe authority** — water/abrasive/pierce requests from CAM/G-code/remap.
2. **Manual process authority** — panel enable/inhibit/override during AUTO, explicitly arbitrated.
3. **Logical output state** — LinuxCNC/HAL command polarity.
4. **Field-interface state** — Mesa/relay energized or de-energized behavior, including startup/shutdown defaults.
5. **Pneumatic valve state** — physical water/abrasive valve actuation.
6. **Pump/pressure request** — normal/low/high pressure or pump run request.
7. **Pump-owned transition** — intensifier/direct-drive/PLC/hydraulic system changes pressure.
8. **Pressure/readiness witness** — still UNKNOWN in inspected LinuxCNC implementations.
9. **Pierce/cut authorization** — must not be inferred solely from output command.
10. **Fault/recovery** — leak, pressure failure, clog, abrasive failure, abort and restart reconciliation remain incompletely evidenced.

## Adversarial review — 8/8

1. Does `0 = water on` mean LinuxCNC universally uses active-low waterjet outputs? **No; it is one machine's deliberate field convention.**
2. Does an output that goes to the desired state on PC shutdown prove a safety-rated depressurization function? **No. External hydraulic/safeguarding design remains separate.**
3. Did the 2022 machine reach a working LinuxCNC control state? **Yes, by owner report; complete machine operation was then limited by hydraulic leaks.**
4. Does that prove pump READY/pressure qualification existed? **No; those internals were not exposed.**
5. Does the old FLOW machine prove a particular water/abrasive sequence? **No; it proves long-lived LinuxCNC deployment only.**
6. Can a CNC pressure command be treated as measured pressure achieved? **No; the Phoenix comparator explicitly separates CNC request from pump-side transition.**
7. Does Vacuum Assist support a universal water-before-abrasive sequence? **No; its purpose includes eliminating abrasive delay, so sequencing is process/equipment dependent.**
8. Has a real LinuxCNC pump READY/fault implementation now been found? **No. Preserve the gap explicitly.**

## Promotion / next evidence path

The W1 branch has gained useful field evidence but still cannot freeze a production 3-axis state machine. Reopen the pressure-readiness sub-branch only when public evidence exposes at least one of:

- pump/intensifier PLC I/O or communication mapping;
- measured pressure / pressure-switch / ready / fault qualification;
- high-pressure-valve ownership and timeout handling;
- downloadable remap/component implementing water/abrasive lead-lag;
- pause/feed-hold/abort reconciliation of those states.

In the meantime, rotate within 3300 to laser L1 or another open process-specific evidence path rather than repeating generic waterjet searches.
