# Hydraulic Safety Actuator Repair, Recommissioning, and Safety-Time Revalidation

Date: 2026-09-20
Course: 4000 safety / professional machine implementation

## Question

When a hydraulic final element is repaired or safety-related components are replaced, is restoration of assembly/configuration enough to return it to safety service, or must the safety function and its physical timing be revalidated?

## Evidence

### Bosch Rexroth hydraulic actuator maintenance guidance

**DOC-CONFIRMED.** Bosch Rexroth's technical paper *Hydraulic Actuators for Gas and Steam Valves* states that after actuator repair the final examination should include the safety functionality and be documented. It further states that proof testing includes inspection/replacement of safety-related components and a functional test according to commissioning instructions and safety-function documentation; before recommissioning, the safety function, including the safety period of the safety system, is to be validated and traceably documented.

Source: Bosch Rexroth Corporation, *Hydraulic Actuators for Gas and Steam Valves*, section 3, 2023 technical paper. Public source: https://dc-mkt-prod.cloud.bosch.tech/us/media/trends_and_topics/media_center/technical_papers/2023_11/ush00395_2023-04_media-2.pdf

This is valuable because it reaches beyond a logic/configuration check into the time-dependent physical safety function of a hydraulic actuator.

### Bosch Rexroth hydraulic commissioning guidance

**DOC-CONFIRMED.** Rexroth hydraulic commissioning material requires leak testing, pressure checks and a machine/system functional test according to the machine/system manufacturer's instructions. Generic hydraulic guidance also calls for testing all functions and comparing measured pressure/velocity values with permissible or specified data.

These sources establish that hydraulic recommissioning can require physical measurements, but they do not define an OpenPressBrake acceptance state or threshold.

## Curriculum conclusions

Freeze the following distinctions:

**HYDRAULIC SAFETY COMPONENT REPAIRED != SAFETY FUNCTION REVALIDATED.**

**SAFETY FUNCTION OPERATES != REQUIRED SAFETY TIME PHYSICALLY REVALIDATED.**

**RECOMMISSIONING FUNCTION TEST COMPLETE != MACHINE-SPECIFIC PRODUCTION RELEASE unless the machine/OEM acceptance authority says so.**

**VALVE/ACTUATOR CONFIGURATION RESTORED != PHYSICAL HYDRAULIC PERFORMANCE RESTORED.**

A safety-related hydraulic final element can therefore invalidate at least three different evidence layers: component identity/configuration, functional response, and quantitative physical response time/performance. The affected layers must be re-established according to the actual safety function and machine/OEM requirements.

## Four-class validation mapping

- Class A — normal-demand functional test: applicable when the repaired actuator must demonstrate the intended safety response.
- Class B — fault injection: only when required by the device/system safety validation; this source does not prescribe a generic fault set.
- Class C — quantitative physical performance: explicitly implicated because Rexroth calls for validation of the safety period before recommissioning.
- Class D — periodic proof test: explicitly present in the source, but its example interval is product/application-specific and must not be copied into OpenPressBrake.

## Human-factors / maintenance consequence

A repaired actuator that moves correctly can create false confidence if the safety response has become too slow. Return-to-service paperwork should therefore make the quantitative witness visible when the safety function depends on response time, rather than allowing a simple `FUNCTION OK` checkbox to hide that dependency.

## OpenPressBrake boundary

**UNKNOWN:** applicable hydraulic safety architecture, final elements, safety time, stopping time, decompression time, holding criteria, pressure thresholds, measurement points, allowed movement, proof-test interval, PL/SIL, diagnostic coverage, and machine-specific production-release procedure.

Do not derive any of these from the Rexroth actuator example. A press brake has different hazards, load retention, hydraulic topology and safeguarding geometry.

## Information-gain stop / next evidence

This source materially strengthens the repair -> recommission -> physical timing witness chain, but it is not a complete press/press-brake OEM partial-acceptance matrix. Continue searching for a machine-level procedure that explicitly maps a safety-related change to the affected safeguard/final-element tests and production release. If no such public procedure is exposed, mark that machine-level branch source-limited and rotate to another open 4000 safety module rather than inventing a hydraulic truth table.
