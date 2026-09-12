# Press-brake 3600 — first-piece correction and acceptance workflow

Date: 2026-09-12
Status: OFFICIAL-DOCUMENTATION + FIELD-WORKFLOW SYNTHESIS

## Objective

Turn the calibration/correction ownership model into an operator workflow that can distinguish a normal first-piece product correction from evidence that machine calibration, tooling, or process assumptions are wrong.

This is a workflow contract, not a numeric bend-calculation recipe.

## Real controller workflows

### Cybelec CybTouch

Official CybTouch documentation describes semi-automatic mode as repeating the same sequence indefinitely while the operator applies corrections, advancing only when the bend is satisfactory. For angle correction, the operator physically measures the angle and enters the measured value; the controller calculates the Y-axis correction. Backgauge X correction is entered separately as a positive/negative positional correction.

This gives a clear production loop:

```text
position axes -> bend trial piece -> measure result -> enter correction -> repeat same BendStep -> accept -> advance
```

Crucially, the correction is not entered by rewriting the original angle/program step directly.

### Cybelec ModEva

The official ModEva user workflow is even more explicit: go to semi-automatic mode, position the first sequence, bend a trial product, measure the flange and obtained angle, then open corrections. The example applies a small X correction to the current bend after measurement.

This independently confirms the distinction between programmed geometry and measured-result correction.

### Delem DA family

Public DA-66T/DA-69T documentation describes Auto/Step production, per-bend corrections, general program corrections, and a measured-angle correction calculator. X-axis correction examples are expressed as the difference between programmed and measured values. Corrections are stored in the active bending program; optional correction databases can offer prior corrections for similar bends.

Delem therefore adds an important reuse boundary: a correction can remain product-specific or be promoted into a reusable correction database, but that reuse is a deliberate controller feature with similarity logic rather than an implicit global offset.

## Proposed operator state machine

```text
READY_FOR_TRIAL
    |
    v
POSITION_TARGETS
    |
    v
TRIAL_BEND
    |
    v
MEASURE_RESULT
    |
    +--> within acceptance -> ACCEPT_BEND
    |
    +--> plausible product/process deviation -> PROPOSE_CORRECTION
    |        |
    |        v
    |    REVIEW_SCOPE
    |        |
    |        +--> bend-specific
    |        +--> program/general
    |        +--> reusable material/tool-class candidate
    |        `--> reject as calibration/process fault
    |        |
    |        v
    |    APPLY_NEW_TARGET_GENERATION
    |        |
    |        v
    |    REPEAT_SAME_BEND
    |
    `--> implausible/systematic deviation -> CALIBRATION_REVIEW_REQUIRED
```

The operator must not silently advance the program while the current bend remains in an unaccepted correction trial.

## Acceptance record

For a traceable production workflow, acceptance should create durable evidence such as:

```text
BendAcceptance
  program_revision
  bend_id
  targetset_generation
  correction_revision
  measured_flange (optional)
  measured_angle (optional)
  measurement_method
  operator_id or source
  accepted_at
  result = ACCEPTED | REWORK | SCRAP | CALIBRATION_REVIEW
```

The measurement may be optional for workflows where acceptance is by a qualified operator/check fixture, but the source of acceptance should remain explicit.

## Scope decision

### Bend-specific correction

Use when the deviation is plausibly local to one bend/geometry/process state. This is the conservative default for first-piece tuning.

### Program/general correction

Use when multiple bends in the same product share a consistent deviation and the controller/process intentionally supports a product-wide correction. Preserve the individual bend evidence that justified broadening the scope.

### Reusable material/tool-class correction

Only consider when repeated accepted production evidence shows the correction is stable across a defined material/tool/process class. The correction must carry the class identity and dependency revisions. Delem's explicit correction-database concept demonstrates that reusable correction knowledge is a distinct data layer.

### Machine calibration review

Escalate rather than masking with product corrections when evidence suggests a machine/reference problem. Examples include:

- similar X error across unrelated programs and flange geometries;
- error appears after homing/reference maintenance or encoder/drive work;
- left/right or direction-dependent error suggests backlash/squareness/mechanical geometry;
- corrections grow rapidly with position, suggesting scale/geometry rather than a constant product tweak;
- known tooling geometry does not match installed tooling;
- correction required exceeds a configured engineering/commissioning limit;
- a previously stable set of unrelated products all shifts together.

These are diagnostic discriminators, not automatic fault proofs.

## Correction generation rule

Any accepted change to the effective target must create a **new TargetSet generation**. It must not mutate an already authorized runtime ExecutionEpisode in place.

```text
old nominal target + correction revision N
    -> accepted correction edit
    -> recompute/review
    -> TargetSet generation N+1
    -> fresh ExecutionEpisode
```

This preserves the PB-DXF/PB-BG generation/episode ownership work and prevents a GUI edit from silently changing an in-flight command.

## Same-target case

If a correction/provenance change happens to yield the same numeric X/Y/R value, the generation still changes. Equality of numbers is not equality of provenance.

## Abort/restart interaction

A pause that is genuinely resumable may preserve the current trial context. An abort, reference loss, controller restart, or invalidation of the active TargetSet ends the runtime ExecutionEpisode. The selected bend and unaccepted measurement may remain visible for operator context, but resumption requires reconciliation and a fresh authorized episode.

## Safety and process boundary

This workflow is ordinary production/control software logic. It does not replace safeguarding, machine inspection, tooling capacity checks, pressure/tonnage protection, safe setup procedures, or quality-system requirements. A measured bad part is not proof of a software target error; tooling, material, setup, mechanics and measurement method remain possible causes.

## Verification discriminator for future implementation

A future implementation should be tested on these cases before being considered mature:

1. first trial bend is accepted with zero correction;
2. X correction is applied and only that bend repeats;
3. measured-angle entry generates a new Y/angle correction generation;
4. operator rejects a proposed broad/general correction and keeps it bend-specific;
5. machine calibration revision changes while a product correction exists -> product correction becomes review-required;
6. application aborts between measurement and correction acceptance -> no stale runtime authority survives;
7. numeric target remains identical after dependency revision -> generation still changes;
8. reusable correction candidate cannot become class-wide without explicit review/qualification.

No new motor/hydraulic simulation is justified for these ownership cases; source/controller workflow evidence is currently the higher-information path.

## Next question

The next dependency-safe domain question is **correction diagnosis**: how to distinguish constant offset, scale error, backlash/direction error, tooling/material springback, and Y1/Y2/squareness effects using bounded production measurements without turning ordinary correction logic into a safety claim.
