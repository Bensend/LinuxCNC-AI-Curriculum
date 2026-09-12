# PB-DXF-001 — metadata-only bend importer fixture

Date frozen: 2026-09-12
Status: FROZEN BEFORE IMPLEMENTATION
Scope: deterministic data-integrity fixture only; no machine target calculation, motion, tooling selection, collision solving, or automatic bend sequencing.

## Question

Can the normalized import contract preserve source provenance and ambiguity while producing order-independent candidate identities, diagnosing coincident duplicates without merging distinct collinear bends, and invalidating stale BendStep references across source revision changes?

## Frozen input model

Each synthetic source document carries:

- source name
- source revision token
- units (`MM`, `INCH`, or `UNKNOWN`)
- coordinate-frame ID
- importer-version token

Each source entity carries:

- entity locator
- entity type (`LINE` only for this fixture)
- layer/group
- endpoints
- optional raw semantic tag
- optional angle, radius, direction metadata with provenance
- optional trusted sidecar bend UUID plus sidecar-bound source revision

Normalization uses endpoint quantization to a declared fixture tolerance and an orientation-insensitive segment fingerprint. Candidate identity is derived from normalized evidence, not input list position. Entity locator remains provenance and must not by itself become cross-revision bend identity.

## Frozen cases

P0 — clean separation
- one CUT line and two BEND lines;
- expect two bend candidates, no duplicate diagnostic.

P1 — coincident duplicate
- two separate source entities normalize to the same finite segment;
- expect both source refs retained under a `COINCIDENT_CANDIDATES` diagnostic;
- do not silently delete one and do not automatically create two confirmed bends.

P2 — distinct collinear bends
- two non-coincident finite segments lie on the same infinite line;
- expect two distinct candidates and no coincident diagnostic.

P3 — UNKNOWN preservation
- bend-tagged line lacks angle/radius/direction;
- expect all three values explicitly UNKNOWN, never zero/default.

P4 — order independence
- re-run P0 with source entity list permuted while source revision is unchanged;
- expect identical normalized candidate IDs and fingerprints.

P5 — changed revision, same geometry without trusted stable ID
- source revision changes while geometry remains identical;
- expect old BendIdentity/BendStep reference to become STALE or RECONCILIATION_REQUIRED; geometry may propose a remap but must not silently assert identity.

P6 — changed revision with geometry modification
- one confirmed bend moves beyond tolerance;
- expect old reference stale and new candidate distinct.

P7 — stale sidecar
- sidecar bend UUID is present but sidecar source revision does not match imported source revision;
- expect sidecar metadata rejected for identity/angle/radius/direction authority and diagnostic `STALE_SIDECAR`.

P8 — trusted sidecar stable ID
- source revision changes, sidecar is correctly bound to the new source revision, and stable bend UUID matches prior trusted identity;
- expect direct remap eligibility while preserving new source provenance.

## Frozen Gates A–J

A. P0 yields exactly two bend candidates and preserves CUT evidence separately.
B. P1 emits `COINCIDENT_CANDIDATES`, retains both source refs, and does not silently collapse provenance.
C. P2 yields two distinct bend candidates despite collinearity.
D. P3 preserves angle/radius/direction as explicit UNKNOWN values.
E. P4 candidate IDs/fingerprints are invariant to entity ordering.
F. P5 does not silently reuse the old bend identity; old BendStep reference is stale/reconciliation-required.
G. P6 creates a distinct new candidate and invalidates the old reference.
H. P7 emits `STALE_SIDECAR` and does not trust stale sidecar semantic values.
I. P8 permits stable-ID remap only because the sidecar/source revision binding is valid.
J. Output contains no gauge target, axis command, tooling choice, bend-order optimization, or machine-motion field.

All gates must pass unchanged. Any implementation defect is corrected without weakening a gate after observing results.

## Evidence boundary

PASS would validate only deterministic metadata/provenance/reconciliation semantics of this synthetic normalized importer contract. It would not validate DXF parser correctness for arbitrary files, CAD geometric tolerance policy, actual bend direction, machine setup, collision avoidance, backgauge target calculation, or functional safety.
