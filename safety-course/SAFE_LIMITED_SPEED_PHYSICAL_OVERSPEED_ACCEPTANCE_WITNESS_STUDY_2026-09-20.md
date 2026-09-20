# Safely-Limited Speed Physical Overspeed Acceptance Witness Study

Date: 2026-09-20
Active curriculum: 4000 safety course

## Why this branch

After the stale-start branch reached a generic information-gain stop, the next useful physical witness was safe-motion acceptance: does commissioning merely inspect a configured SLS status bit, or deliberately challenge the physical speed boundary and observe the safety response?

## Siemens SINUMERIK acceptance-test evidence

Source: Siemens, *SINUMERIK Operate acceptance test — Function Manual*, 01/2023, A5E39460574B AF.

Official source: https://cache.industry.siemens.com/dl/files/809/109820809/att_1141935/v1/828D_AT_fct_man_0123_en-US.pdf

Evidence classification: `DOC-CONFIRMED`.

Siemens defines the Safely-Limited Speed acceptance test as checking whether an overshoot of the configured SLS limit is detected. When the SLS limit is exceeded, the configured stop responses and alarms are expected to trigger for both monitoring channels, and response times/overtravel are part of the acceptance concern.

This is materially stronger than verifying configuration or an `SLS active` status bit. The safety boundary is deliberately violated and the reaction is observed.

The same manual defines a Safety Activation Test that traces the relationship from safety-relevant sensors, through the safety program, to the active axis/drive monitoring function and actuator control. This supports end-to-end commissioning rather than isolated function-block inspection.

## Siemens drive-level acceptance sequence

Source: Siemens CU240S operating instructions, acceptance log, function test “Safely-Limited Speed (SLS)”.

Evidence classification: `DOC-CONFIRMED`.

The documented sequence starts with the drive ready and SLS inactive, operates the drive — if the machine permits, above the parameterized safely limited speed — then selects SLS while a traversing command exists. The tester verifies the expected drive, speed reduction, the resulting speed relative to the configured limit, SLS active state, and expected fault/stop behavior for the configured SLS mode. The acceptance log then checks de-selection and continued expected drive operation.

This supplies a concrete physical/functional witness chain:

**DRIVE MOVING -> SLS DEMAND -> SPEED RESPONSE -> LIMIT/FAULT RESPONSE -> SLS ACTIVE -> RECOVERY CHECK.**

## Acceptance evidence hierarchy

The curriculum now separates these witnesses:

1. SLS configured.
2. SLS selection command generated.
3. SLS reports active.
4. Actual axis speed approaches/exceeds the relevant test boundary.
5. Overspeed is detected.
6. Configured safety stop response occurs.
7. Response time/overtravel is acceptable for the machine safety design.
8. Recovery/rearm behavior is correct.
9. Ordinary production authority is restored only after the complete machine-level restart conditions are satisfied.

No upstream item silently proves a downstream item.

## Durable freezes

**SLS CONFIGURED != SLS SELECTED != SLS ACTIVE != PHYSICAL SPEED LIMITED.**

**SLS ACTIVE BIT != OVERSPEED DETECTION PROVED.**

**OVERSPEED DETECTED != CONFIGURED STOP RESPONSE PHYSICALLY PROVED.**

**STOP RESPONSE OBSERVED != RESPONSE TIME/OVERTRAVEL ACCEPTABLE FOR THE MACHINE.**

**SLS TEST PASSED != ALL OTHER MACHINE SAFETY FUNCTIONS VALIDATED != PRODUCTION AUTHORITY.**

## OpenPressBrake / LinuxCNC boundary

A normal LinuxCNC velocity command, HAL limit, FPGA clamp, or HMI display is not automatically a safety-rated SLS implementation. LinuxCNC may request reduced speed, display measured speed and record acceptance traces, but personnel-safety authority must remain in the validated safety architecture.

For a future OpenPressBrake setup/service mode, do not claim “safe reduced speed” merely because ordinary motion is commanded slowly. If risk reduction depends on safely limited speed, the design needs an independently justified safety function and a machine-specific acceptance test that challenges its real physical limit and stop response.

OpenPressBrake-specific SLS speed limits, response times, overtravel, stopping distance, PL/SIL, encoder architecture and permitted setup motion remain `UNKNOWN` until the machine risk assessment and actual safety design establish them.

## Human-factors implication

A setup mode that is so inconvenient that operators seek to bypass guards is a design problem, but convenience cannot be obtained by renaming an ordinary low-speed command “safe speed.” A usable architecture should make the legitimate reduced-speed/setup path straightforward while keeping its independent safety monitoring and clear mode indication intact.

## Information-gain status

This branch has a strong manufacturer acceptance foundation. Further generic SLS catalog searching is low value. Reopen it for machine-specific physical acceptance evidence, especially a complete setup-mode chain combining mode selection, enabling device, SLS challenge, final stop response, exit/rearm and fresh production start.
