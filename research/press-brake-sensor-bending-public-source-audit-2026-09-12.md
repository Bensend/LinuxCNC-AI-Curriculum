# 3600 Press Brake — Public Sensor-Bending Source Audit

Date: 2026-09-12
Status: BOUNDED SEARCH CLOSED — SOURCE UNAVAILABLE

## Search objective

After separating measured angle from commanded motion and from nominal/empirical correction state, search for an inspectable public implementation that exposes enough detail to justify a generic LinuxCNC sensor-bending control topology.

## Sources checked

- LinuxCNC community reports around press-brake measurement-only axes and angle measurement.
- Public Delem controller pages that advertise `Sensor bending & correction interface`, protractor correction, thickness measurement/compensation and frame-deflection compensation.
- Public Cybelec controller material describing angle measurement/correction capabilities.
- GitHub repository search for press-brake angle-sensor/LinuxCNC implementations.
- Broader GitHub code search for bend-angle sensor/correction implementations.

## Result

The bounded search found **feature documentation and community use cases**, but no inspectable public LinuxCNC press-brake implementation with enough source to establish all of the following:

- angle-sensor acquisition/update semantics;
- producer generation/freshness witness;
- press-cycle phase qualification;
- exact correction insertion point;
- relationship to Y1/Y2 differential synchronization;
- final output limiting/saturation ownership;
- stale/fault handling during an active bend;
- unload/springback treatment;
- abort/recovery and reauthorization behavior.

The broad GitHub code search produced unrelated sensor/correction matches rather than a press-brake controller implementation. Repeating broader keyword searches would have low expected information gain.

## Evidence classification

- Commercial sensor-bending / angle-correction feature existence: **DOC-CONFIRMED**.
- LinuxCNC field interest in measurement-only press-brake scales: **COMMUNITY-REPORTED**.
- LinuxCNC/HAL can represent encoder measurement independently of a commanded joint: **SOURCE/DOC-CONFIRMED** from the HostMot2/encoder interfaces inspected in the adjacent research artifact.
- A reusable generic realtime sensor-bending feedback topology for LinuxCNC: **SOURCE UNAVAILABLE / UNKNOWN**.

## Decision

Do not synthesize a canonical `angle PID`, correction gain, phase policy, filter, or insertion point from product-feature lists. Do not spend laboratory compute proving a toy loop can converge; that would not resolve the missing real implementation contract.

Resume this branch only if a new source appears that is concrete enough to trace acquisition, freshness, phase, correction authority, saturation and recovery. Until then, retain the measurement/provenance contract from `research/press-brake-measured-angle-sensor-boundary-2026-09-12.md` and keep active sensor correction machine/sensor-specific.
