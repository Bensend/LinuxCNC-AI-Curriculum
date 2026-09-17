# OpenPressBrake Shared-Power / Common-Cause Safety Review

Date: 2026-09-17
Status: DURABLE SAFETY ARCHITECTURE REVIEW

## Purpose

Turn the next OpenPressBrake safety question into schematic-review rules: where can ordinary controller circuits and independent safety circuits acquire a common-cause failure through shared 24-V distribution, 0-V returns, connectors, protection, field harnesses, or power restoration?

This is not a rule that every shared supply is unsafe. It is a dependency-tracing method. The actual required category/PL/SIL and allowed common-cause assumptions remain machine-specific.

## Authoritative evidence

`DOC-CONFIRMED`: SICK's Safe Entry Exit / Flexi Soft installation guidance identifies measures against common-cause failures including separation of safety signal pathways, separate cables or shielding, overvoltage/overcurrent protection, and control of consequences from supply failure, fluctuations, overvoltage and undervoltage.

`DOC-CONFIRMED`: current SICK nanoScan3 guidance gives a concrete dual-encoder example: common-cause encoder failure must be excluded; possible measures include independent electrical supplies and supply lines, or a common supply located in a protected location with separate supply lines/cables to each encoder/device.

`INFERENCE`: therefore "same 24-V PSU" is not automatically the decisive question. The review must identify whether a single PSU, branch fuse, return, connector, cable, transient, short, or restoration event can defeat nominally independent channels or create a false-safe state.

## Schematic-review rules

For every safety-relevant channel pair or safety/ordinary boundary, trace separately:

`source -> protection -> branch conductor -> connector pins -> field cable -> device -> return conductor -> return connector -> source`

Then mark every point that is common to both channels or to both safety and ordinary control.

### Rule 1 — Do not count two signal wires as independent if one ordinary common can defeat both

Examples to investigate:
- shared 0-V return opening both channels;
- shared +24-V branch short/fuse loss removing both sensors;
- one connector shell/pin group allowing adjacent-pin short between channels;
- one harness crush point damaging both channels;
- one transient path upsetting both evaluation channels.

Whether each failure is safe, detected, excluded by construction, or unacceptable must be established from the actual architecture.

### Rule 2 — A shared supply may be acceptable only when its failure consequences are explicitly handled

Review:
- loss of supply;
- brownout/undervoltage;
- overvoltage/transient;
- return shift;
- branch short;
- fuse/protection operation;
- power restoration.

Do not infer safe behavior from nominal voltage alone.

### Rule 3 — Separate safety final-element power from ordinary command authority conceptually even if some source hardware is shared

A proportional-valve command supply, FPGA/logic supply, safety-controller supply, relay/contactor coil supply, and safety-valve supply can share upstream energy only if the resulting dependencies are understood. The safety function must not rely on ordinary LinuxCNC/FPGA software to remove the shared energy correctly.

### Rule 4 — Feedback/EDM commons are safety-relevant

If two final-element feedback contacts share a conductor, connector, input common, or synthesized software path, ask whether one open/short/common fault can make both appear in the expected state. Feedback independence must be judged on the complete electrical path, not merely on having two auxiliary contacts.

### Rule 5 — Power restoration is a separate test

After loss and restoration of any shared rail:
- safety outputs must return to the documented safe/restart state;
- ordinary FPGA/HAL outputs must not replay stale actuator requests;
- reset must not itself start hazardous motion;
- safety readiness and ordinary-control rearm must remain distinct.

### Rule 6 — Protection coordination belongs in the common-cause review

A branch fault in an ordinary output must not silently collapse the safety supply unless the resulting state is known safe and restart behavior is controlled. Conversely, a safety-channel fault must not create uncontrolled ordinary actuator behavior through a shared rail or return.

Exact fuse curves, wire sizes, PSU ratings and protection coordination are board/machine calculations and are not invented here.

## OpenPressBrake review checklist

Before schematic freeze, produce a one-page power/common map containing:

- every 24-V source and DC/DC source;
- safety-controller supply branch;
- safety input/device supply branches;
- safety relay/contactor/valve coil branches;
- ordinary FPGA/controller branch;
- proportional-driver field-power branch;
- encoder/sensor branches used by safety functions;
- all 0-V/common bonds and intentional isolation boundaries;
- fuses/e-fuses/breakers/protection devices;
- connector pins and harness segments carrying redundant channels;
- EDM/feedback return paths;
- power-good/brownout behavior where relied upon;
- restart/rearm behavior after each relevant branch loss.

For each shared node assign one of:

- `SAFE CONSEQUENCE ESTABLISHED`;
- `FAULT DETECTED / RESTART INHIBITED`;
- `EXCLUDED BY CONSTRUCTION + EVIDENCE`;
- `NOT SAFETY-RELEVANT`;
- `UNKNOWN — REVIEW REQUIRED`.

Do not use `independent` unless the complete shared-dependency trace supports it.

## Human-factors rule

Do not solve nuisance brownouts or intermittent connector faults by bypassing safety inputs, widening discrepancy windows without evidence, tying channels together, or moving safety devices onto an undocumented "cleaner" ordinary supply. Repeated power-related trips are diagnostic evidence requiring root-cause correction.

## Compute decision

No compute is justified. This is schematic/source reasoning. No GitHub-hosted Actions minutes or self-hosted runtime were consumed.

## Precise next work

Use this review to build the **OpenPressBrake safety power/common map template** that the board-design automation can fill from the actual schematic. Keep it interface-based so routine board development can evolve without moving safety authority into the normal FPGA.
