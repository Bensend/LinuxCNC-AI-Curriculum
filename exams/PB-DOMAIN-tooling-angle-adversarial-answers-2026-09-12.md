# PB-DOMAIN — Tooling / Material / Measured-Angle Adversarial Review — Answers and Score

Date: 2026-09-12
Frozen question artifact: `exams/PB-DOMAIN-tooling-angle-adversarial-2026-09-12.md`
Scope: dependency-safe 3600 preparation; not a formal 3600 graduation exam.

## 1. Die change with plausible old targets

**Answer:** Do not reuse the old TargetSet unchanged. Die identity/geometry is an upstream dependency of the nominal bend/process model and potentially of machine-specific target calculation. A die revision change invalidates a TargetSet generated from the prior tool-state provenance even when the old numeric coordinates still look plausible. Re-resolve tooling, recalculate and mint a new TargetSet generation; runtime authorization belongs to an ExecutionEpisode created from the accepted current generation.

**Score: 2/2.**

## 2. Same numeric K-factor rows, ANSI -> DIN header

**Answer:** The claim is invalid. In pinned FreeCAD SheetMetal, `KFactorLookupTable` treats K-factor standard as semantic state and rejects a missing/ambiguous/unsupported standard. The unfolder normalizes DIN differently—legacy/new paths divide the DIN-form value by two for the internal convention. Identical raw table numbers with a changed standard can therefore produce a different interpreted K-factor. Recalculation/provenance invalidation is required.

**Score: 2/2.**

## 3. Five repeated 90.0° values + green transport

**Answer:** The bounded conclusion is only that the observer repeatedly received/displayed the same reported measurement while the checked transport diagnostics were healthy. Equality with requested angle does not prove freshness or physical truth. Before calling the physical result current/correct, establish the sensor's mechanical coupling and scaling, source/config revision, current BendStep/ExecutionEpisode association, measurement phase validity, generation/freshness evidence, and—during commissioning or disputed cases—an independent physical reference. Recorder integrity is required for any trace-based continuity claim.

**Score: 2/2.**

## 4. Measurement-only scale represented as W axis

**Answer:** It is not automatically sound. A commanded joint/axis carries command/reference/mode semantics that a pure measurement channel does not own; the LinuxCNC press-brake community report already exposed this mismatch when a measurement-only scale was forced into W-joint semantics. A better default is hardware acquisition -> HAL measurement signal -> scaled/validated process-measurement object -> HMI/DRO. Promote it into commanded motion semantics only if the physical mechanism is actually commanded through LinuxCNC motion and the corresponding homing, limits, command/feedback, fault and trajectory ownership are intentionally defined.

**Score: 2/2.**

## 5. First-piece +2° correction -> global Overbend Factor?

**Answer:** No automatic global rewrite is justified. The local residual could come from material lot/thickness, punch/die condition, tool setup, machine calibration, temperature/process state, part geometry, sensor error, or true material springback. A bend/job-scoped correction is the conservative default; promotion to broader material/tool technology requires repeated qualified evidence and explicit review. Nominal material technology and empirical production correction remain separately revisioned.

**Score: 2/2.**

## 6. Toy `angle PID -> both Y valves` converges

**Answer:** Convergence is insufficient. A real sensor-bending topology must establish at least sensor latency/update/generation semantics; valid press-cycle phase; current-bend identity; where correction enters relative to common trajectory and Y1/Y2 differential synchronization; common versus per-side authority; downstream limiting/saturation/anti-windup; stale/fault behavior; unload/springback treatment; interaction with pressure/process states; abort/recovery/rearm behavior; and the ordinary-control versus functional-safety boundary. Without real source or a machine/sensor contract the generic topology stays UNKNOWN/SOURCE UNAVAILABLE.

**Score: 2/2.**

## 7. Technology revision changes while paused; recomputed number identical

**Answer:** The existing ExecutionEpisode must not remain authoritative merely because numeric equality survives recomputation. Its authority is bound to the prior TargetSet generation and dependency revisions. A material/tool/technology dependency revision invalidates that provenance. Recompute under the new revision, mint a new TargetSet generation, require the applicable acceptance/reconciliation step, and mint a fresh ExecutionEpisode. Numeric equality is not generation identity.

**Score: 2/2.**

## 8. Use HostMot2 `position-interpolated` for smoother angle control

**Answer:** The HostMot2 documentation explicitly states that `position-interpolated` is an interpolated estimate valid only under stated velocity/count-time conditions and says **not to use it for position control**. A press-brake angle loop therefore cannot justify using that signal merely because it appears smoother. The design needs the actual sensor/acquisition contract and an appropriate, validated measurement/filtering strategy whose delay/freshness semantics are known.

**Score: 2/2.**

## Result

**16/16 PASS.**

No answer required a curriculum correction. The review successfully discriminated several tempting but invalid shortcuts: numeric equality versus provenance identity; transport health versus sensor truth; display convenience versus motion semantics; local empirical correction versus global material technology; and toy-loop convergence versus real correction authority.

## Boundary

This pass verifies reasoning against the current source/documentation contracts only. It does not establish a physical target-machine springback model, live angle-control topology, safe stopping behavior, tooling limits, or functional-safety performance.
