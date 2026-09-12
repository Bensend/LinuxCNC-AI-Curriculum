# 3600 Press Brake — Measured-Angle / Sensor-Bending Boundary

Date: 2026-09-12
Status: DEPENDENCY-SAFE 3600 RESEARCH/SOURCE/COMMUNITY PASS

## Why this pass exists

The tooling/material/springback ownership pass established a clean separation between nominal bend technology and empirical correction. Commercial press-brake controllers also advertise angle measurement and sensor-bending/correction interfaces. That raises a distinct question: **how should a LinuxCNC-based press-brake architecture represent a measured bend angle without falsely turning a measurement channel into an ordinary commanded motion axis or treating a stale measurement as physical truth?**

## Evidence inspected

### Commercial controller surfaces

- Delem DA-69T / DA-66T / DA-69S product documentation advertises both protractor correction and a distinct “Sensor bending & correction interface,” plus optional thickness measurement/compensation and frame-deflection compensation.
- Cybelec ModEva 19T documentation explicitly lists angle measurement among supported sophisticated press-brake functions.
- Cybelec CybTouch/VisiTouch product families separately expose angle management/correction, tooling, material, pressure and crowning functions.

These establish that measured-angle feedback is a real production-controller surface, but the public product pages do not disclose a reusable control algorithm, timing contract or sensor protocol.

### LinuxCNC community evidence

A June 2026 LinuxCNC forum thread, “Measurement Only Axes,” describes a Promecam press-brake retrofit where a user added a linear scale to the moving bed specifically to correlate actual ram travel with achieved bend angle. The user attempted to model the sensor as a W axis/joint and ran into coordinate-zeroing semantics because the channel was not actually a commanded joint.

This is useful field evidence of a representation trap: **a measurement-only physical channel does not automatically belong in LinuxCNC’s commanded joint/axis model just because an operator wants a DRO value.**

Classification: COMMUNITY-REPORTED; not a source-level prescription.

### Pinned LinuxCNC measurement path

The current upstream HostMot2 documentation and source expose encoder measurement directly as HAL data. `hostmot2.9` defines encoder `position` as scaled counts and warns that `position-interpolated` is an estimate useful in narrow cases and should not be used for position control. `src/hal/drivers/mesa-hostmot2/encoder.c` updates the ordinary measured `position` and derives the interpolated value separately when appropriate.

This means LinuxCNC already has a natural representation for a measurement-only transducer: a **HAL signal sourced by the actual acquisition path**, without inventing a commanded motion joint.

For the curriculum’s pinned source discipline, any eventual implementation must re-check these semantics against the exact deployed LinuxCNC commit rather than relying on current-master behavior.

## Core architecture result

Measured bend angle should be modeled as a **process measurement channel**, not silently aliased to:

- Y/Y1/Y2 commanded position;
- a fake commanded W joint;
- the nominal requested BendStep angle;
- the nominal springback/overbend factor;
- an accepted empirical correction;
- a safety-rated physical limit.

A minimal ownership chain is:

```text
physical angle/geometry sensor
  -> hardware acquisition / HAL producer
  -> scaled raw measurement
  -> validity/freshness/provenance wrapper
  -> BendMeasurement record
  -> phase-qualified comparison against BendStep intent
  -> correction proposal / bounded sensor-bending policy
  -> new correction revision / TargetSet generation when accepted
```

## Required BendMeasurement fields

A reusable software contract should carry at least:

- measurement value and units;
- raw/scaled source identity;
- sensor/configuration revision;
- producer generation/cycle witness when available;
- acquisition timestamp/observer timestamp with semantics stated;
- validity/fault state;
- bend/program identity;
- current BendStep identity;
- current ExecutionEpisode identity;
- press-cycle phase in which the measurement is meaningful;
- tooling/material/TargetSet provenance against which it is being interpreted.

The last four items are essential. An angle value can be numerically plausible while belonging to the previous part, previous bend, previous target generation, or an invalid phase.

## Freshness and recorder lessons inherited from the 2000 series

This domain question inherits the already-established advanced diagnostics rules:

1. **Equal values do not prove freshness.** A stable angle can mean a stationary part or a stale/frozen measurement.
2. **Transport health does not prove physical truth.** A healthy encoder/read path only establishes the bounded transaction/measurement path it actually checks.
3. **Generation identity matters.** Observer time proximity between GUI, Python and HAL surfaces is not same-cycle identity.
4. **Recorder validity is prerequisite evidence.** Producer overruns or payload discontinuity invalidate claims that rely on complete retained coverage.
5. **Independent physical references remain necessary when validating physical truth.** Software agreement cannot bootstrap sensor correctness.

These are dependencies, not new claims invented for 3600.

## Phase qualification

A measured angle should not automatically participate in correction in every machine phase.

At minimum distinguish:

- **approach / pre-contact:** angle measurement may be geometrically meaningless or sensor-specific;
- **active bending:** sensor may be valid for live bending depending on its physical principle and placement;
- **hold / bottom:** measurement may represent loaded geometry rather than relaxed final angle;
- **decompression / unload:** angle evolves as elastic load is removed;
- **post-release / accepted measurement window:** this may be the appropriate final-angle observation for springback/correction, depending on the sensing system;
- **part removed / next episode:** prior value must not remain authoritative merely because it is still displayed.

The public evidence does not establish one universal phase policy. That must remain sensor/machine specific.

## Closed-loop versus correction-only use

Two distinct architectures must not be conflated:

### A. Measurement / correction-only

The sensor observes achieved angle. Software compares it with the requested final geometry after a valid measurement window and proposes or applies a correction for a later bend/attempt. This is compatible with the existing first-piece correction model.

### B. In-bend sensor correction

A sensor actively changes the current bend command while the bend is underway. Delem’s public material confirms commercial support for sensor bending/correction, but does not reveal enough implementation detail to define a LinuxCNC-generic control loop.

For architecture B, the curriculum would require evidence for:

- exact sensor latency and update semantics;
- current-bend generation identity;
- where correction enters relative to nominal trajectory, Y1/Y2 differential sync and final output limiting;
- saturation/authority arbitration;
- stale/fault behavior during an active bend;
- phase transitions and unload/springback treatment;
- recovery after sensor invalidation;
- whether correction is per side, common beam command, or process-level target adjustment.

Without this evidence, the correct status is **SOURCE/IMPLEMENTATION UNAVAILABLE**, not “use a PID on angle.”

## Adversarial checks

1. **“The angle sensor still reads 90.0°, so the current part is at 90°.”** Unsafe: value may be stale or belong to another ExecutionEpisode.
2. **“Put the angle encoder on a W joint so Axis can display it.”** Representation convenience does not make a measurement-only channel a commanded joint; community experience already exposed semantic friction.
3. **“HostMot2 encoder position changed, so the bent part angle changed.”** Only true if the sensor’s mechanical coupling, scaling, provenance and phase validity are independently established.
4. **“A post-release 2° error means increase global material overbend by 2°.”** Not justified; first determine correction scope and whether tooling, thickness, setup, calibration or sensor error explains the residual.
5. **“Sensor bending exists commercially, so a realtime angle PID is the obvious implementation.”** Unsupported. Public product material exposes the feature surface, not its control topology.
6. **“Use `position-interpolated` for smoother angle control.”** HostMot2 documentation explicitly warns not to use that interpolated encoder output for position control; a sensor-bending design needs a source-specific measurement/filtering contract instead.

## Evidence classification

- Commercial availability of protractor/angle/sensor-bending correction: **DOC-CONFIRMED**.
- LinuxCNC field desire for a measurement-only press-brake scale and difficulty forcing it into joint semantics: **COMMUNITY-REPORTED**.
- HostMot2 encoder measurement as independent HAL position output, and interpolation caveat: **SOURCE/DOC-CONFIRMED** for inspected upstream source/docs.
- Recommended `BendMeasurement` provenance wrapper: **ENGINEERING INFERENCE** derived from 2000-series freshness/generation evidence and current 3600 provenance contracts.
- Generic realtime closed-loop angle-correction topology: **UNKNOWN / SOURCE UNAVAILABLE** in this pass.

## Information-gain decision

Do **not** add a synthetic angle PID lab merely to have a simulation. The unresolved issue is not whether a toy controller can close a loop; it is the real sensor-bending ownership/timing/authority contract. A meaningful next step requires either:

1. inspectable public press-brake sensor-bending implementation/source; or
2. sufficiently detailed controller/sensor documentation exposing timing, phase and correction semantics.

If neither is found in a bounded search, preserve SOURCE UNAVAILABLE and move on.
