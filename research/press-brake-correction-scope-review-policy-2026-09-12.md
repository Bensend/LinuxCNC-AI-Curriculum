# Press-brake 3600 — correction scope review policy

Date: 2026-09-12
Status: evidence-driven operator/data-governance contract

## Purpose

Define the evidence required to keep a correction bend-specific, broaden it to a program, reuse it for a material/tool class, or reject it and require machine-calibration review.

The policy is built from the first-piece workflows documented in Cybelec and Delem controller families, the LinuxCNC machine-compensation boundaries already traced, and the correction-diagnosis matrix in this curriculum.

## Governing rule

A correction starts at the **narrowest justified scope**. Broader reuse requires new evidence. A convenient numeric fit is not enough.

```text
single BendStep correction
        |
        | repeated compatible evidence
        v
program/general correction
        |
        | repeated across qualified material/tool/process class
        v
reusable class correction
```

At every transition, evidence may instead route to `MACHINE_CALIBRATION_REVIEW_REQUIRED`.

## Bend-specific default

Keep a correction bend-specific when any of the following is true:

- evidence exists only for one BendStep;
- geometry/gauging datum is unique;
- correction depends on a particular local bend sequence or orientation;
- material/tool/process similarity has not been demonstrated;
- other bends in the program have not shown the same signed residual;
- the independent machine-coordinate check is still UNKNOWN.

This is the safest ordinary-production default because it minimizes unintended propagation.

## Program-wide promotion

A bend-specific correction may be proposed as program/general only when:

1. multiple bends in the same product show a consistent residual pattern;
2. the residual sign/magnitude is compatible within an explicitly recorded tolerance or review rule;
3. machine-coordinate diagnostics do not indicate a scale/reference/backlash/squareness problem;
4. the same installed tooling/material/configuration revision applies where relevant;
5. the operator or engineering workflow explicitly accepts the broader scope;
6. a new program/correction revision and TargetSet generation are created.

The original per-bend evidence must be preserved so the broader correction can be audited or rolled back.

## Material/tool-class reuse

Reusable correction knowledge requires a stronger qualification set. At minimum record:

- material identity/class and thickness range;
- punch/die/tooling identities and revisions;
- bend type/geometry similarity discriminator;
- relevant angle/radius/process range;
- machine/calibration revision compatibility;
- number of accepted observations and their residual spread;
- excluded/outlier cases;
- date/revision of the learned correction;
- explicit review/approval status.

Delem's documented correction-database concept is evidence that reusable corrections are a distinct controller data layer. The curriculum should preserve that separation instead of silently turning yesterday's operator tweak into a global machine offset.

## Mandatory machine-calibration review triggers

Do not broaden product corrections when evidence instead points toward machine state. Trigger review when, for example:

- the same coordinate error appears across unrelated products;
- residual grows systematically with axis travel;
- approach direction changes the residual materially;
- error appeared after homing/reference/encoder/drive/mechanical service;
- left/right or multi-point measurements indicate squareness/differential error;
- controller feedback and independently measured physical position disagree;
- a correction database suddenly proposes similar large corrections across unrelated product classes;
- the required correction exceeds an engineering-configured review threshold.

The threshold values themselves are machine/process-specific and are intentionally not invented here.

## Review outcomes

```text
CorrectionReview
  KEEP_BEND_SPECIFIC
  PROMOTE_TO_PROGRAM
  QUALIFY_REUSABLE_CLASS
  RETIRE_CORRECTION
  MACHINE_CALIBRATION_REVIEW_REQUIRED
  INSUFFICIENT_EVIDENCE
```

`INSUFFICIENT_EVIDENCE` is a valid result. The system should not force an offset simply because production is waiting.

## Provenance required for every promotion

A promotion record should bind:

- source correction IDs;
- accepted bend/part measurement records;
- program revision;
- material/tool revisions;
- machine calibration revision;
- calculation method revision;
- reviewer/source identity;
- review timestamp;
- old and new correction scope;
- resulting TargetSet generation(s).

If these dependencies change, previously qualified corrections become `REVIEW_REQUIRED`, not silently trusted.

## Runtime interaction

Correction review happens outside an active motion episode. Editing or promoting a correction invalidates any not-yet-executed effective TargetSet derived from the old correction state. The next motion uses a newly generated TargetSet and a fresh ExecutionEpisode.

A correction edit must never modify an already-running command in-place.

## Adversarial examples

### Same 0.4 mm X correction on three bends

This does **not** automatically justify program scope. First determine whether the physical backgauge is actually 0.4 mm off across positions. If it is, this is machine-calibration evidence, not a product-wide correction.

### Same angle correction on two parts using the same material/tool set

This is evidence for a reusable-class candidate, but not enough to qualify it by itself. Repeated accepted evidence over the declared class and stable machine calibration is still required.

### Old reusable correction after tooling revision

Even if the correction number is unchanged, the dependency revision changed. Mark it `REVIEW_REQUIRED` and regenerate/review rather than carrying it forward silently.

### One product shifted after re-home

Do not immediately alter HOME_OFFSET or the product. Check unrelated machine-coordinate references and other products first; either layer could be responsible.

## Evidence sufficiency / experiment decision

No new laboratory simulation is justified for this policy now. The question is data scope/provenance and diagnostic routing, and current official-controller plus pinned-source evidence already discriminates the relevant ownership layers. A synthetic pass/fail fixture would mostly restate the contract rather than answer a LinuxCNC-specific ambiguity.

Future implementation testing becomes useful once there is executable UI/state code whose revision, invalidation and promotion transitions can be exercised directly.

## Next work

With the correction ownership, first-piece acceptance, diagnosis and scope-promotion chain now documented, the next dependency-safe 3600 work should return to a different missing real-machine domain surface rather than iterate this same abstraction. Good candidates are pressure/tonnage/crowning ownership or backgauge homing/commissioning field evidence, chosen from the active dependency map after re-checking F02 status.
