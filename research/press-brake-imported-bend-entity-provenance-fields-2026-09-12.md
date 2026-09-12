# Press-brake 3600 — minimal imported bend-entity provenance fields

Date: 2026-09-12
Purpose: define the smallest source-neutral records needed before building a metadata-only importer fixture.
Status: research contract, not production file format

## Design goal

The importer must be able to answer two questions later:

1. **What source evidence caused this internal bend candidate to exist?**
2. **Is this still the same source feature after reimport/revision, or merely geometrically similar?**

It does not need to calculate backgauge targets, bend allowance, tooling or machine motion at this stage.

## `SourceDocumentRef`

Minimum fields:

- `source_uri_or_name` — diagnostic source identity, not necessarily a filesystem path;
- `source_revision` — hash/version/timestamp token when available;
- `format` — e.g. DXF, FreeCAD-sidecar, other normalized source;
- `units` — explicit or UNKNOWN;
- `coordinate_frame_id` — identifies the imported coordinate convention;
- `importer_version` — enough to reproduce normalization behavior.

Rationale: geometry alone cannot establish whether two imports came from the same revision or importer rules.

## `SourceEntityRef`

Minimum fields:

- `source_document_revision` reference;
- `entity_locator` — original entity handle/index/path when the format provides one;
- `layer_or_group` — raw source grouping metadata;
- `entity_type` — LINE/ARC/POLYLINE/etc.;
- `raw_semantic_tag` — vendor/source tag if present, otherwise UNKNOWN;
- `raw_style_class` — optional color/linetype/style evidence retained as provenance, not truth.

Important: `entity_locator` is diagnostic provenance, **not automatically a durable bend ID across source revisions**.

## `NormalizedGeometryFingerprint`

Purpose: support duplicate diagnostics and controlled reimport matching without pretending geometry is identity.

Minimum conceptual content:

- normalized endpoints/curve parameters in the imported part frame;
- geometry type;
- declared normalization tolerance/version;
- orientation-insensitive fingerprint for coincident-line detection;
- optionally an orientation-sensitive form when direction becomes meaningful.

Two source entities may share a fingerprint and still remain distinct until the importer/human resolves whether they are duplicates or separate intended bends.

## `BendCandidate`

Minimum fields:

- newly assigned internal `bend_candidate_id` scoped to the normalized import revision;
- one or more `SourceEntityRef` records;
- normalized geometric representation/fingerprint;
- classification state: `CANDIDATE`, `CONFIRMED_BEND`, `REJECTED`, `AMBIGUOUS`;
- angle: value + provenance + confidence, or UNKNOWN;
- direction/orientation: value + provenance + confidence, or UNKNOWN;
- radius: value + provenance + confidence, or UNKNOWN;
- deduplication/reconciliation diagnostics.

The importer must never silently assign zero/default values to unknown angle/radius/direction.

## `BendIdentity`

Only after confirmation should the application create a stable internal bend identity for the current imported part revision.

Minimum fields:

- `bend_id`;
- confirmed candidate reference(s);
- source-document revision;
- normalized geometry fingerprint;
- confirmation provenance (operator or trusted sidecar rule);
- status: active/stale/reconciliation-required.

On source revision change, old bend IDs should become **stale until explicitly remapped**, not silently rebound to the nearest line.

## Reimport matching levels

A useful deterministic order is:

1. exact source-document revision + exact source entity locator -> same import evidence;
2. trusted sidecar stable ID under a verified sidecar/source revision contract -> candidate for direct remap;
3. unique normalized geometry + compatible metadata -> **proposed** remap requiring policy/operator confirmation;
4. multiple geometric matches, changed geometry or conflicting metadata -> AMBIGUOUS;
5. no match -> new feature / old feature stale.

Do not make level 3 equivalent to identity merely because endpoint coordinates happen to match.

## Duplicate-line diagnostics

The FreeCAD SheetMetal public issue history justifies an explicit duplicate class. If multiple source bend entities normalize to coincident geometry within the declared tolerance:

- retain all source refs;
- emit `COINCIDENT_CANDIDATES` diagnostic;
- do not create multiple recipe bends automatically;
- do not delete one silently;
- allow a source-specific trusted rule or human confirmation to collapse them into one BendIdentity.

This keeps duplicate cleanup auditable.

## Distinct collinear bends

Coincidence and collinearity are different. Two non-overlapping or partially overlapping collinear bend segments can legitimately represent different bends/features. The fingerprint/deduplication rule must not merge all lines sharing an infinite line equation.

## Optional sidecar contract

A richer CAD-side exporter may supply, per bend:

- generated source-side bend UUID;
- line geometry;
- angle;
- radius;
- direction;
- source feature provenance.

The sidecar itself must carry the CAD document revision/hash and exporter version. Without that binding, a stale sidecar is worse than explicit UNKNOWN metadata.

## Fixture cases now ready to freeze later

A future metadata-only test can use synthetic entity records for:

- clean separate bend layer;
- coincident duplicate bend lines;
- two distinct collinear bends;
- ambiguous cut/bend layer;
- missing direction/angle metadata;
- same geometry reordered on reimport;
- source geometry modified between revisions;
- stale sidecar revision;
- trustworthy sidecar stable ID.

Expected outputs are classification/provenance/reconciliation records only. No machine commands or numeric backgauge targets belong in this fixture.

## Evidence boundary

These fields are an engineering data-integrity contract informed by FreeCAD SheetMetal source/issue behavior, BenDFM's explicit sequence metadata and the curriculum's runtime episode-identity work. They are not a standard mandated by LinuxCNC or DXF.

## Next checkpoint

If F02 remains externally blocked on the next session, freeze a tiny importer metadata fixture around these cases only if source-neutral parser semantics still need experimental verification. Otherwise continue documentation/source work; do not run a lab merely because a fixture can be written.
