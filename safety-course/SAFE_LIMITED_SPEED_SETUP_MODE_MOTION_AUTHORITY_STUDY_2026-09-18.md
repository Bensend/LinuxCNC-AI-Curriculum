# Safe Limited Speed / setup-mode motion authority study

Date: 2026-09-18
Lane: independent safety curriculum Lane B

## Why this branch

The primary lane is currently advancing linked-machine E-stop span/propagation and final-element witness. This study deliberately uses different files and evidence and addresses a separate open architecture question: when access/setup operation permits intentional motion, what establishes that the motion remains within the safety function's permitted envelope, and what happens when that envelope is violated?

## Evidence-status vocabulary

- **SOURCE-CONFIRMED** — directly supported by cited manufacturer/standards-oriented source.
- **DOC-CONFIRMED** — confirmed by project/repository documentation.
- **TEST-CONFIRMED** — established by a reproducible physical or executable test.
- **COMMUNITY-REPORTED** — reported by a practitioner/community source but not independently proven here.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence; not a quoted requirement.
- **UNKNOWN** — machine-specific fact not established by available evidence.

## Architecture freeze

`SETUP MODE SELECTED != SLS ACTIVE/VALID != ACTUAL SPEED WITHIN LIMIT != SAFE DIRECTION/POSITION ESTABLISHED != MOTION COMMAND AUTHORIZED != PHYSICAL MOTION SAFE.`

`ORDINARY LINUXCNC VELOCITY LIMIT != SAFELY LIMITED SPEED.`

`SLS LIMIT VIOLATION DETECTED != HAZARD ALREADY ABSENT != FINAL ELEMENT REACTED != SAFE STATE PROVEN != RESET/REARM AUTHORIZED != FRESH ORDINARY START.`

The safety function must own the safety-relevant motion envelope and its fault reaction. LinuxCNC/HAL/ordinary FPGA may request jog/setup motion and display diagnostics, but an ordinary software velocity clamp is not a substitute for independent safety evaluation where personnel protection relies on limited motion. **INFERENCE**.

## Source trace

### Pilz — SLS and safe motion monitoring

**SOURCE-CONFIRMED:** Pilz describes Safely Limited Speed (SLS) per EN/IEC 61800-5-2 as monitoring a defined maximum speed. A transition from normal operating speed to reduced setup speed must be established; if the monitored limit is violated, the drive must be shut down safely. Pilz gives SS1 followed by removal of power-generating energy as a preferred example reaction, while making clear the exact reaction depends on the application.

Source: https://www.pilz.com/en-US/lexicon/sicher-begrenzte-geschwindigkeit-sls

**SOURCE-CONFIRMED:** Pilz's PNOZ s30 material distinguishes multiple motion-safety concepts rather than treating "slow" as one state: SLS (maximum speed), SSM (signal that speed is below a threshold), SSR (speed corridor), SDI (direction), and SOS (operating-stop monitoring). It explicitly presents safely limited setup speeds and direction monitoring as means to work with guards open in appropriate applications.

Source: https://www.pilz.com/en-US/products/applications/safe-motion-monitoring/safe-speed-monitor-pnoz-s30

**SOURCE-CONFIRMED:** Pilz also distinguishes normative safe motion functions from monitoring-only variants: a monitoring-only function may report a limit violation without itself performing the error reaction; a complete safety function then requires the appropriate safe reaction path.

Source: https://www.pilz.com/en-US/support/lexicon/articles/200448

### Rockwell — separate safe-motion instructions

**SOURCE-CONFIRMED:** Rockwell GuardLogix drive-safety documentation treats SLS, SOS, SS1 and SS2 as distinct safety instructions. SLS monitors axis speed against an active limit; SOS monitors deviation from standstill; SS1 monitors a deceleration to zero and controls an output to initiate STO. This reinforces that "speed below limit," "standstill," and "torque removed" are different claims.

Source: https://www.rockwellautomation.com/en-no/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-application-instructions/drive-safety-instructions.html

### SICK — independent speed-monitor implementation

**SOURCE-CONFIRMED:** SICK's Speed Monitor is a standstill/speed safety monitor covering SLS and SSM and supports monitoring using two independent initiator signals or a diverse arrangement. This is useful architecture evidence that safety-relevant speed evaluation can be separate from the ordinary motion controller.

Source: https://www.sick.com/cz/de/catalog/produkte/safety/sichere-bewegungsueberwachung-und-steuerung/speed-monitor/c/g202352

## Practical OpenPressBrake boundary

The curriculum should draw at least four independent concepts when setup motion is considered:

1. **Ordinary motion intent** — LinuxCNC/HAL/HMI requests jog or setup movement.
2. **Safety mode authority** — independent safety logic determines whether the mode permits hazardous motion under reduced safeguards.
3. **Safety motion witness** — safety-rated/integrity-appropriate sensing/evaluation establishes speed/direction/position/standstill claims required by the safety function.
4. **Safety reaction/final element** — a violated or invalid safety-motion claim produces the required safe reaction through the physical final elements.

The actual OpenPressBrake implementation of items 2–4 is **UNKNOWN** and must not be inferred from ordinary encoder feedback, commanded velocity, FPGA state, or LinuxCNC's displayed speed.

## Failure-path analysis

| Challenge | Unsafe shortcut to reject | Required commissioning question |
|---|---|---|
| LinuxCNC commands a reduced jog speed | Commanded speed assumed to equal physical speed | What independent witness detects overspeed? |
| SLS monitor loses/invalidates feedback | Keep moving because commanded speed is low | What safe reaction occurs on invalid safety feedback? |
| Speed exceeds SLS threshold | Alarm only | Does the configured safety function command the required safe reaction and is the final element witnessed? |
| Motion reverses unexpectedly | Speed magnitude still below SLS | Is direction itself safety-relevant and, if so, independently monitored? |
| Axis stops but torque remains | "Zero speed" treated as STO | Which claim is actually required: SOS/standstill, STO, brake/load retention, or another state? |
| STO becomes active | Gravity/load hazard assumed controlled | What mechanical/hydraulic/gravity energy remains? Preserve UNKNOWN until physically established. |
| Mode selector changes while jogging | Ordinary jog remains latched | What removes setup-motion authority and requires fresh intent? |
| Safety permission returns after fault | stale JOG/START resumes motion | What rearm and fresh-intent boundary prevents unexpected restart? |
| Safety speed sensor disagrees with ordinary encoder | ordinary encoder wins because LinuxCNC trusts it | Which safety-side logic owns the personnel-protection decision? |
| Safety monitor configuration changed | machine returns to production after download | What configuration verification and functional validation are required before rearm? |

## Question-driven commissioning plan

No simulation is justified yet. These questions depend on the eventual safety architecture and physical machine measurements, so executable verification now would manufacture assumptions.

When a real implementation exists, validation should answer:

- Can setup motion occur without the independent safety mode being valid?
- Can ordinary control request a speed above the safety limit, and does the safety function independently detect/respond?
- Does loss, disagreement, or implausibility of the safety motion witness cause the intended safe reaction?
- Is the reaction path traced from safety evaluator through drive/contactor/valve/brake as applicable to a physical witness?
- If direction matters, is wrong-direction motion detected independently of LinuxCNC command state?
- Are standstill, STO, brake engagement, hydraulic isolation, and load retention tested as separate claims where relevant?
- After a limit violation or feedback fault, can acknowledgement alone restore motion, or is deliberate safety rearm plus fresh ordinary motion intent required?
- Does a power cycle with JOG/START asserted preserve a non-hazardous state until safety authority and fresh intent are re-established?

## Machine-specific UNKNOWNs

Do **not** assign values here for OpenPressBrake safe setup speed, permitted force, stopping time/distance, encoder architecture, discrepancy limits, safety reaction time, safe direction, safe position window, hydraulic state, pressure, gravity retention, PL/SIL/category/DC, or required stop function. Those require the actual risk assessment, selected hardware architecture, manufacturer constraints, and physical validation.

## Exact next work

Find a professional press/press-brake or comparably hazardous setup-mode implementation that exposes the full chain:

`mode selection -> safeguard reduction/suspension -> enabling/jog intent -> independent SLS/SDI/SOS witness -> safety evaluator -> limit violation -> safe stop/reaction -> physical final-element witness -> fault latch -> reset/rearm -> separate fresh motion intent`.

Prefer a source that includes a sensor disagreement or overspeed commissioning test. Preserve **UNKNOWN** wherever the public documentation stops.