# Press-brake 3600 — bounded commercial-controller target-workflow search

Date: 2026-09-12
Status: BOUNDED SEARCH / PARTIAL DOCUMENTATION EVIDENCE

## Question

Can a public mature press-brake controller source/manual establish a generic, inspectable mapping from finished bend/flange geometry plus a selected gauging datum to X/R/Z backgauge targets strongly enough to freeze a LinuxCNC numeric TargetSet contract?

## Sources checked

### Cybelec

Cybelec's official current download site exposes historical DNC60 documentation packages and numerous controller/user manuals. The public package inventory confirms that programming, machine-specific configuration and controller generations are separate document families.

A bounded attempt to inspect the nominal English DNC60 PS manual through the public download endpoint resolved to a different/legacy DNC60 G16 document rather than a trustworthy press-brake target-calculation reference. It was therefore rejected for the specific target-mapping question rather than treated as evidence by filename alone.

### Delem

Delem's public DA-66T product page confirms mature capabilities including 3D programming, tooling/product memory, X1/X2 backgauge programming, correction interfaces, thickness compensation and offline Profile-T software. This is good evidence that production controllers treat backgauge targets, tooling, corrections and material/thickness information as integrated but distinct configuration/programming concerns.

The public product page does not disclose a sufficiently explicit generic formula for deriving X/R/Z from a selected part datum. It therefore cannot justify copying a universal target equation.

### ESA / public programming walkthrough

A public ESA S829 programming walkthrough demonstrates a data-programming workflow in which material/thickness, bending length, tooling, bend angle and X-axis bending position are separately entered/selected, with some bending-depth values automatically calculated. This is useful workflow evidence, but it still does not expose the internal gauging-surface-to-X derivation or its correction/calibration model.

## Result

**No inspectable universal commercial-controller target formula was established in this bounded pass.**

That is a useful result rather than a reason to infer one. The evidence supports the layered contract already adopted:

`BendStep -> GaugePlan/datum -> target calculation method + material/tooling/calibration inputs -> TargetSet`

Production controllers clearly carry multiple inputs/corrections, but the precise mapping is controller/machine dependent and not sufficiently exposed by the checked public material.

## Implication for curriculum

Do not freeze a numeric X/R/Z TargetSet calculation yet.

Next research should use one of two discriminating routes:

1. find an inspectable open-source/offline press-brake project that calculates gauge targets from explicit part geometry and trace that implementation; or
2. if no such source is found after a bounded search, define only a generic target-calculation **interface/provenance contract** and leave the actual calculation method machine/tooling-specific until the 3600 implementation has verified geometry/calibration evidence.

## Evidence boundary

- Official product/download pages: DOCUMENTATION evidence for feature and document availability.
- Public programming walkthrough: COMMUNITY/SECONDARY workflow evidence.
- Universal gauging-surface-to-target formula: **SOURCE UNAVAILABLE in this bounded pass**.

No numeric target recommendation, machine calibration value, tooling offset, collision result or functional-safety claim is made.
