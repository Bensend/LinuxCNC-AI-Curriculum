# Sensor / Feedback Independence and Common-Cause Worksheet

Date: 2026-09-16
Status: durable independent safety-curriculum artifact
Scope: LinuxCNC / OpenPressBrake safety evidence, diagnostics, and witness independence

## Purpose

Multiple agreeing signals are useful only to the extent that their failure causes are actually independent.

Core rule:

> **Three displays derived from one stale bit are one witness, not three independent witnesses.**

This worksheet forces the learner to trace where each safety-relevant observation comes from, what it shares with other observations, and what common cause could make apparently independent channels agree incorrectly.

It does not assign PL, SIL, Category, DCavg, PFHd, MTTFd, diagnostic-coverage percentages, stopping distances, hydraulic thresholds, or other machine-specific performance values.

## Provenance vocabulary

Use only:

- `SOURCE-CONFIRMED` — directly verified in inspectable source/code/configuration.
- `DOC-CONFIRMED` — supported by authoritative documentation.
- `TEST-CONFIRMED` — demonstrated by a recorded test within its tested boundary.
- `COMMUNITY-REPORTED` — reported by a community/user source but not independently verified here.
- `INFERENCE` — reasoned conclusion with stated premises.
- `UNKNOWN` — evidence absent, contradictory, stale, unbound, or insufficient.

Do not convert channel count into an independence claim without tracing dependencies.

## Independence record

For each claimed witness/channel record:

| Field | Entry |
|---|---|
| Channel / witness ID | |
| Exact physical fact claimed | |
| Sensor / final element observed | |
| Physical sensing principle | |
| Power source / supply path | |
| Ground / reference path | |
| Connector / cable / route | |
| Input hardware / isolator | |
| Controller / I/O module | |
| Network / transport | |
| Software source / tag / register | |
| Filtering / transformation | |
| Timestamp / freshness source | |
| Configuration identity | |
| Mechanical linkage shared with another witness | |
| Environmental exposure shared with another witness | |
| Shared calibration / setup dependency | |
| Shared maintenance / human-error dependency | |
| Known diagnostics | |
| Common-cause candidates | |
| Independence conclusion | |
| Provenance class | |
| Remaining `UNKNOWN` | |

## Pairwise common-cause matrix

Do not merely write `independent=yes/no`. Compare every pair used to support the same safety claim.

| Dependency | Witness A | Witness B | Shared? | Consequence if shared | Evidence |
|---|---|---|---|---|---|
| sensing element | | | | | |
| mechanical actuator/linkage | | | | | |
| 24-V supply / fuse | | | | | |
| common / reference | | | | | |
| cable / conduit / connector | | | | | |
| I/O module | | | | | |
| controller / CPU | | | | | |
| network switch / link | | | | | |
| source variable / register | | | | | |
| software calculation | | | | | |
| clock / freshness mechanism | | | | | |
| configuration file | | | | | |
| calibration procedure | | | | | |
| physical environment | | | | | |
| maintenance action | | | | | |

A shared dependency does not automatically make the architecture unacceptable. It limits what may be claimed and identifies a failure that must be considered or challenged.

## Independence ladder

Keep these layers distinct:

1. **Display independence** — separate screens or indicators.
2. **Software-path independence** — separate variables/calculations.
3. **transport independence** — separate communication paths.
4. **electrical independence** — separate input/supply/reference paths.
5. **sensor independence** — separate sensing elements or principles.
6. **physical-witness independence** — observation of a different physical consequence or point in the hazard path.
7. **safety-authority independence** — the ordinary LinuxCNC/FPGA path is not silently being used as the sole personnel-safety authority.

Passing a lower layer does not imply passing a higher one.

## Common-cause patterns learners must recognize

### One source, many presentations

HMI lamp, LinuxCNC status panel, historian tag, and FPGA debug page all ultimately display the same network bit. Their agreement is not independent corroboration.

### Shared power

Two nominally separate sensors lose or corrupt their outputs together because they share the same supply, fuse, return, or DC/DC converter. Record whether loss is detectable and what state results; do not assume it is safely diagnosed.

### Shared cable or connector

Dual channels routed through one damaged connector or cable can fail together. Separate terminal numbers alone do not establish independence.

### Shared mechanical target

Two switches can be electrically separate yet both be fooled by the same loose cam, bent bracket, misaligned guard tongue, or failed linkage.

### Shared software derivation

`pressure_safe_A` and `pressure_safe_B` may look separate while both are calculated from one ADC value. Two tags are not two sensors.

### Shared freshness failure

Two values can agree because both froze at the same last-good packet, boot image, cache, or gateway. Freshness/session identity must be established independently enough for the claim being made.

### Shared configuration error

Two channels may be wired separately but mapped to the same input, inverted by the same template error, or scaled from the same wrong parameter.

### Shared environment

Heat, fluid ingress, vibration, EMI, contamination, magnetic target shift, or mechanical impact can defeat multiple channels together. Physical separation is not useful if the relevant environmental cause remains common.

### Shared maintenance error

A technician can reconnect both channels incorrectly, replace both sensors with the wrong type, or copy a bad parameter to both. Configuration/change validation remains necessary.

## Disagreement versus agreement

Disagreement is diagnostically valuable and must not be suppressed merely to keep production running.

Agreement is weaker than it looks when a common cause can produce the same value on both channels. Ask:

- Could one fault make both agree falsely?
- Could one stale source feed both?
- Could one physical target fool both?
- Could one configuration error map both to the same thing?
- Could one power/reference failure force both to the same state?
- Is the claimed independent witness actually downstream of the same controller decision?

If these are unresolved, mark independence `UNKNOWN` rather than counting votes.

## Authoritative evidence notes

- `DOC-CONFIRMED` — OSHA 29 CFR 1910.147 defines an energy-isolating device as a physical device preventing transmission/release of energy and excludes pushbuttons, selector switches, and other control-circuit devices. This reinforces the architectural boundary between control indications and physical energy isolation.
- `DOC-CONFIRMED` — OSHA's lockout/tagout guidance requires verification of isolation/deenergization before work and notes that verification may require a combination of methods. It also requires continued verification where stored energy can reaccumulate.
- `DOC-CONFIRMED` — Rockwell GuardLogix documentation distinguishes module-level dual-channel discrepancy checking from controller instruction-level discrepancy diagnostics. This demonstrates that two channels and the location of their comparison are separate architectural questions; diagnostic implementation must be traced rather than inferred from the existence of two inputs.

These sources do not establish OpenPressBrake diagnostic coverage or safety performance.

## Question-driven validation plan

Only run a test when it resolves a named uncertainty. Useful questions include:

1. Does removing one sensor supply produce a detectable fault or a false agreement?
2. Does freezing the shared network source make multiple displays appear consistently safe?
3. Can one input mapping/configuration error make two software channels mirror one physical input?
4. Does opening one channel produce the expected discrepancy at the actual diagnostic layer?
5. Does controller reboot invalidate stale safe-state evidence before rearm?
6. Does a mechanical target failure defeat more than one nominally separate switch?

For each test record stimulus, expected discriminating observation, independent witness, configuration identity, raw artifact, bounded conclusion, and recovery/rearm steps.

Do not execute hazardous machine tests merely to fill a worksheet. OpenPressBrake physical tests require a controlled commissioning boundary and machine-specific procedure. If executable verification later becomes necessary, use only the repository's `[self-hosted, openpressbrake]` runner; otherwise keep the question `UNKNOWN` and continue source/design work.

## Adversarial cases

1. Three UI indicators agree because all subscribe to the same stale MQTT/network value.
2. Two pressure transmitters have separate inputs but share one fused 24-V sensor supply that fails high through a wiring fault.
3. Dual guard switches have separate electrical channels but share one loose actuator bracket.
4. Two PLC tags are presented as redundant pressure channels but both derive from one ADC register.
5. Separate safety inputs are configured from the same physical terminal due to a copied mapping error.
6. Two contactor auxiliary contacts are observed by the same ordinary FPGA and its input image freezes during communication loss.
7. Encoder and motion-status bit agree on standstill because the status bit is calculated from that same encoder.
8. Two sensors share a cable that is crushed against the machine frame.
9. A reboot restores last-known-safe values before freshness/session identity is re-established.
10. Both channels are replaced during maintenance with the wrong sensor type using the same incorrect work instruction.
11. A diagnostic says channel discrepancy is clear because discrepancy checking was configured at a different layer than the reviewer assumed.
12. Two hydraulic observations agree but both are upstream of the same closed valve and say nothing about a trapped downstream volume.
13. LinuxCNC command, FPGA output register, and HMI lamp all say OFF while independent final-element feedback says ON.
14. A physical sensor and its `healthy` flag are counted as two witnesses even though the flag is calculated solely from that sensor's value.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC and the ordinary OpenPressBrake FPGA may provide valuable diversity for diagnostics, logging, stale-data rejection, command/feedback comparison, and ordinary-control inhibition. They may help reveal a safety-system fault.

They do not become personnel-safety authority merely because they disagree with or supervise a safety controller. A normal-control watchdog, HAL interlock, or FPGA comparison must not be credited as a safety-rated independent channel without an architecture and validation that actually justify that claim.

## Minimum review gate

Before calling two witnesses independent enough to support a stronger claim, the reviewer must be able to answer:

- What physical fact does each witness directly observe?
- What sensing elements are separate?
- What power/reference paths are shared?
- What wiring/connectors/routes are shared?
- What controller/network/software derivation is shared?
- What mechanical target or final element is shared?
- What freshness/session mechanism is shared?
- What configuration/calibration/maintenance action is shared?
- What environmental cause can affect both?
- What single fault or human error can make both agree falsely?
- What test or authoritative documentation supports the independence conclusion?

If the answer to a material item is missing, record it as `UNKNOWN`.

## Open OpenPressBrake facts

Remain `UNKNOWN` until final design/measurement/documentation establishes them:

- final safety-controller and I/O architecture;
- actual sensor types and channel topology;
- required PL/SIL/Category and quantitative reliability metrics;
- diagnostic coverage and common-cause scoring;
- stopping time and protective distance;
- hydraulic pressure/energy thresholds and trapped-volume behavior;
- final cable routing, power segregation, mechanical target arrangements, and environmental exposure;
- proof-test intervals and calibrated instrumentation requirements.

## Precise next independent work

If still independent of the primary lane, build a **diagnostic blind-spot / latent-fault accumulation worksheet**. Trace which single faults are immediately detected, which are detected only on demand/change of state, which can remain latent, and how a second fault could defeat the intended safety function. Keep diagnostic-coverage percentages `UNKNOWN` unless a validated architecture and quantitative method exist. If the primary lane occupies that topic, switch to an independent proof-test stimulus/observability study rather than editing overlapping files.
