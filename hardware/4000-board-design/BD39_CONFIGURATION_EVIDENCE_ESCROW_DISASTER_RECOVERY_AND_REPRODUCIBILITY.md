# BD39 — Configuration Evidence Escrow, Disaster Recovery, and Long-Horizon Reproducibility

## Purpose

BD38 established that a support claim requires retained capability, not merely an archived filename. BD39 turns that principle into an engineering recovery method:

`released/as-maintained identity -> authoritative artifact inventory -> integrity verification -> redundant archive/escrow -> toolchain/environment capture -> restore drill -> programming/test recovery -> reproducibility evidence -> loss/degradation disposition`

This lesson develops both linked skills. **Block engineering** must preserve generic contracts, exact provenance, calculations, evidence, machine-readable interfaces, source and qualified artifacts needed to understand and reproduce a reusable block revision. **Board integration** must preserve the exact board/BOM/connection definitions, FPGA image/resource map, LinuxCNC/HAL configuration, programming path, test capability and as-maintained identity needed to recover an actual controller configuration.

OpenPressBrake is a governance/worked-example source only. It is not represented as production-proven hardware or as having a released fleet.

## Hard student-material audit

The following current-main files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD38_FLEET_CLOSURE_RESIDUAL_SUPPORT_AND_LEGACY_RETIREMENT.md` — support capability, artifact retention, reproducibility and retirement rules.
- Curriculum `WORK_SELECTION_POLICY.md` — independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — evidence-backed readiness and truthfulness gates.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block, adapter and board-integration ownership.
- OpenPressBrake `hardware/blocks/digital_input_24v/manifest.yaml` — current reusable interface/resource/provenance-style contract and explicit board-owned unknowns.
- OpenPressBrake `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md` — current evidence inventory and remaining release gates.

The OpenPressBrake digital-input material is not assigned as finished production hardware. It remains `SIMULATION-READY`; fault/abnormal-condition work, rendered-schematic review, PCB/layout review, complete cost/shared-resource resolution and human Rev-1 signoff remain open. For production/release claims it is `ENGINEERING_REVIEW_NEEDED`.

---

## 1. Possession is not recoverability

A backup is useful only if the required configuration can be identified, restored, verified and—when the support claim requires it—programmed or rebuilt.

An archive may contain a file named `release.bit` yet still fail recovery because its provenance is unknown, its hash is absent, the programmer is unavailable, the board mapping is missing, or the matching HAL configuration cannot be identified.

> **FILE EXISTS != CONFIGURATION RECOVERABLE**

Recovery starts from an exact released or as-maintained identity, not from a folder name such as `latest`.

## 2. Build an authoritative artifact inventory

For every supportable configuration, inventory the artifacts actually needed to establish and restore its identity. Depending on the design, that normally includes:

- release/configuration ID and immutable revision references;
- reusable block and adapter revisions;
- board schematic, PCB, BOM/options and connection-block definitions;
- machine-readable connectivity/resource maps;
- FPGA source, generated image and image hash;
- exact FPGA pin/bank/clock/resource assignment;
- LinuxCNC version, INI, HAL and machine configuration;
- firmware/software binaries and source where applicable;
- build scripts, lockfiles, submodules and external dependency identities;
- compiler/synthesis/toolchain version and material settings;
- programmer/debug hardware and driver requirements;
- calibration constants/data and their serial/configuration binding;
- production/commissioning test procedures, limits and fixture identities;
- qualification and negative evidence needed to understand the supported envelope;
- required `VERIFY_AT_MACHINE` facts.

Do not archive every transient build artifact indiscriminately. Identify which artifacts are authoritative and why.

## 3. Hashes prove identity only when the artifact also exists

A cryptographic digest is excellent evidence that a recovered file matches a recorded file. It is not a substitute for the file.

Likewise, possessing a binary without a trusted recorded digest or release binding may prove that *a* file survived, not that it is the released image.

Where practical preserve:

- artifact digest;
- digest algorithm;
- release/configuration relationship;
- creation/source provenance;
- signature/attestation when the project uses one;
- independent copy of the metadata needed to interpret the digest.

> **HASH WITHOUT ARTIFACT != RECOVERY**

> **ARTIFACT WITHOUT TRUSTED IDENTITY != RELEASE PROOF**

## 4. Redundancy must include failure independence

Three copies on one workstation are not a disaster-recovery strategy. Preserve authoritative material in failure-independent locations appropriate to the project.

Consider loss modes such as:

- workstation/storage failure;
- accidental deletion or repository rewrite;
- account/credential loss;
- ransomware/corruption;
- cloud/provider loss;
- inaccessible encrypted archive;
- physical-site loss;
- license server or proprietary-download disappearance.

Record archive authority, retention policy and access/recovery ownership. Do not put secrets or private license material into a public repository merely to satisfy an escrow checklist.

> **MULTIPLE COPIES != INDEPENDENT ESCROW**

## 5. Capture the environment, not just source

Long-horizon reproducibility frequently fails at the environment boundary. Source may depend on:

- exact toolchain versions;
- device support packages;
- Python/packages or OS libraries;
- git submodules;
- generated IP cores;
- proprietary synthesis/compiler components;
- license entitlements;
- environment variables/settings;
- scripts that fetch mutable URLs;
- programmer/debug drivers;
- USB/JTAG hardware no longer stocked.

Use containers/VMs where they genuinely capture dependencies, but do not mistake a container recipe for a preserved environment if its base image or package sources are mutable or gone.

> **SOURCE ARCHIVED != BUILD ENVIRONMENT RECOVERABLE**

## 6. Preserve both immutable binaries and rebuild knowledge when justified

Two different recovery claims are useful:

1. **Exact-image recovery** — retrieve and verify the exact released binary/configuration artifact.
2. **Rebuild reproducibility** — reconstruct the artifact from preserved source/environment with a defined equivalence criterion.

Not every historical FPGA flow will produce bit-for-bit identical output across tool versions. State the required criterion rather than claiming reproducibility from a successful compile.

Possible criteria include:

- bit-for-bit hash equality;
- tool/vendor-supported deterministic equivalence;
- independently verified functional/configuration equivalence within an explicitly bounded release process.

If exact immutable binary recovery is the support policy and rebuilding is not required, say so. Preserve the programming and verification path anyway.

> **BUILD SUCCEEDS != RELEASE REPRODUCED**

## 7. A restore drill must cross the real support boundary

A backup system reporting `success` proves only what that backup system checked. Periodically perform a bounded restore drill from the escrowed material.

A useful drill asks whether a fresh recovery environment can:

1. locate the exact target configuration from its identity;
2. recover authoritative artifacts without relying on the working copy;
3. verify hashes/signatures/provenance;
4. recover the required toolchain/environment;
5. rebuild when rebuild support is claimed;
6. identify the exact released FPGA/software/HAL artifacts;
7. recover programmer/test-fixture instructions and required hardware identity;
8. demonstrate the verification step appropriate to the support claim;
9. record every dependency that had to be guessed, downloaded from an unpreserved mutable source or borrowed from tribal knowledge.

Do not perform physical programming merely to make the lesson look complete. A physical programming/test drill is justified only when that capability is part of the claimed recovery boundary and the correct controlled hardware is available.

> **BACKUP JOB PASSED != RESTORE DRILL PASSED**

## 8. Booting is not identity proof

A restored controller may boot LinuxCNC and move through a simulation while still carrying the wrong FPGA image, pin map, HAL file or machine configuration.

Recovery evidence must bind the configuration layers together:

`board identity <-> FPGA image/resource map <-> firmware/software <-> LinuxCNC/HAL/machine config <-> connection/harness definition`

A successful boot or application launch is a useful test but not a substitute for exact configuration reconciliation.

> **SYSTEM BOOTS != RELEASED CONFIGURATION PROVED**

## 9. Programmer and fixture hardware are configuration dependencies

A legacy image may be perfectly archived but practically unrecoverable if the only compatible programmer, cable, fixture or calibration interface is gone.

Record:

- programmer/debugger model and revision;
- cable/pinout/adapter requirements;
- drivers and host requirements;
- fixture schematic/BOM/firmware/software;
- fixture calibration requirements;
- fixture-to-board mapping;
- known compatible substitutes and their evidence.

If a fixture contains meaningful transformation/protection circuitry, it deserves engineering identity and qualification; do not hide it as undocumented fixture wiring. Board-only pin mapping remains board/manufacturing integration.

## 10. Calibration and test evidence must remain interpretable

Preserving a CSV of calibration numbers is insufficient if nobody can determine:

- which serial/configuration it belongs to;
- units and scaling;
- procedure/fixture revision;
- calibration reference identity/status;
- applicable limits;
- whether the value is raw, compensated or programmed;
- how it is restored and verified.

Preserve enough schema/procedure identity that future engineers can interpret the evidence without reconstructing tribal knowledge.

## 11. Treat recovery loss as a configuration condition

When a required artifact, toolchain, license, fixture or identity link is lost, record the loss explicitly. Do not continue to label the configuration fully supported simply because it once was.

Useful dispositions include:

- recover from another authoritative escrow copy;
- reconstruct with new evidence and qualify the delta;
- narrow the support claim to exact archived binaries only;
- mark rebuild capability lost but programming capability retained;
- mark service/test capability degraded;
- require `VERIFY_AT_MACHINE` before further service;
- move the configuration to unsupported/service-restricted/retirement-pending state.

The correct disposition depends on the claimed support boundary.

> **RECOVERY CAPABILITY LOST != SUPPORT CLAIM UNCHANGED**

## 12. Keep reusable engineering and configuration escrow separate but joinable

A reusable block should retain its generic contract and evidence. It should not absorb machine serial numbers, backup locations or fleet service history.

Board/configuration escrow joins exact reusable revisions to board-specific connection/resource/programming identities. If recovery reveals a generic block defect—such as an undocumented required dependency in every use—fix the generic contract. If it reveals only that one board's FPGA pin map was not archived, fix board/configuration governance instead.

Do not contaminate reusable circuitry to make archival composition easier.

## 13. OpenPressBrake worked governance example

The inspected `digital_input_24v` block demonstrates why recovery has multiple layers. Its current manifest publishes the generic protected 24 V field-input and 3.3 V logic interfaces, FPGA resource needs, return-domain requirements, component identities and verification artifacts while explicitly leaving physical connector selection and several PCB/board details to integration.

Its current checklist remains `SIMULATION-READY`, not `REV 1 READY`, and lists both concrete evidence and open release gates. A future archive that retained only the block manifest would therefore not reproduce an OpenPressBrake controller: the board connection mapping, PCB, exact FPGA allocation/image, LinuxCNC/HAL configuration and final release evidence would still be required. Conversely, a board image without the block evidence would not explain the generic electrical envelope that image consumes.

The correct recovery package joins those layers without merging their ownership.

No released OpenPressBrake fleet, escrow system or disaster-recovery capability is asserted here.

## 14. Cross-machine reuse

The same method applies to mills, lathes, plasma tables, routers, robots, press brakes and custom automation. Toolchains and fixtures differ, but all require recoverable identity, interpretable evidence and explicit disposition when recovery capability degrades.

## 15. Safety boundary

This lesson governs ordinary controller configuration evidence and recovery. It does not establish PL/SIL/category, safety diagnostic coverage, stopping performance or independent personnel-safety authority.

A recovered ordinary-controller image must not be treated as recovery/validation of an independent safety controller merely because the two systems exchange status or inhibit signals.

> **CONTROLLER RECOVERY != SAFETY FUNCTION VALIDATION**

---

## Lab — eight adversarial recovery cases

Use a fictional multi-machine controller family.

### Case 1 — hash but no binary

The release ledger contains a SHA-256 value for an FPGA image, but all known copies of the image are gone. Classify what evidence remains and what support claims must change.

### Case 2 — binary with uncertain identity

Several `.bit` files survive on a service laptop, but none has a trustworthy release binding. Define how to prevent a successful programming operation from becoming false release evidence.

### Case 3 — source without dependencies

The correct git commit exists, but one submodule revision and a generated vendor IP package are unavailable. Decide whether rebuild reproducibility exists and how to disposition the gap.

### Case 4 — VM drift

A saved VM boots, but package repositories changed and the FPGA tool now updates a device database on launch. Define the recovery evidence needed before calling the environment reproducible.

### Case 5 — proprietary tool/license loss

Source and released binary are intact, but the old proprietary tool license cannot be reissued. Separate exact-image support, rebuild support and future engineering capability.

### Case 6 — undocumented programmer

The exact image is available and verified, but the legacy board requires a programmer/cable combination not documented in the release package. Treat the missing physical programming path as a support dependency.

### Case 7 — fixture cannot be recreated

A production fixture schematic exists, but its firmware, calibration procedure and one active conditioning circuit are undocumented. Determine which production/service evidence can still be claimed and whether the conditioning circuit belongs in a reusable adapter.

### Case 8 — restore boots with wrong FPGA/HAL pairing

A disaster-recovery image boots and LinuxCNC starts, but reconciliation finds a different FPGA image than the HAL mapping was released against. Reject boot success as configuration proof and define the evidence needed for recovery closure.

For each case submit:

- exact target released/as-maintained identity;
- authoritative artifact inventory;
- missing or degraded artifacts/dependencies;
- integrity/provenance evidence;
- escrow/failure-independence assessment;
- toolchain/environment status;
- programmer/fixture/calibration dependencies;
- exact-image and rebuild-reproducibility status separately;
- restore-drill evidence;
- changed support/lifecycle disposition;
- block/adapter/board-integration ownership;
- `VERIFY_AT_MACHINE` items;
- safety-authority statement.

### Lab pass criteria

A passing submission must distinguish possession from recoverability; hashes from artifacts; exact-image recovery from rebuild reproducibility; backup success from restore proof; boot success from configuration identity; reusable engineering evidence from board/configuration records; and ordinary-controller recovery from independent personnel-safety validation. Unknowns remain explicit rather than guessed.

---

## Catalog stress-test result

BD39 exposes a lifecycle infrastructure need above the reusable catalog: a future **configuration evidence escrow/recovery manifest** should join exact release/as-maintained identity to:

- authoritative artifact IDs and cryptographic digests;
- repository commits/tags and external dependency/submodule identities;
- board/BOM/adapter/connection revisions;
- FPGA source, toolchain, settings, image and resource-map identity;
- firmware/software and LinuxCNC/HAL/machine configuration;
- environment/container/VM/base-image provenance;
- programmer/debugger/fixture hardware and drivers;
- calibration/test procedure and evidence schema;
- archive/escrow locations and failure domains;
- access/retention authority without exposing secrets;
- last successful restore-drill evidence;
- exact-image recovery status;
- rebuild-reproducibility status and equivalence criterion;
- known lost/degraded dependencies;
- resulting support/retirement restrictions.

This information belongs in configuration/release/lifecycle infrastructure, not in reusable block manifests. Reusable blocks continue to own generic engineering contracts and evidence.

Current OpenPressBrake does not establish a released fleet or such an escrow/recovery system. Keep this infrastructure need `ENGINEERING_REVIEW_NEEDED`; do not invent archive locations, credentials, serial assets or reproducibility claims.

## Durable freezes

- `FILE EXISTS != CONFIGURATION RECOVERABLE`
- `HASH WITHOUT ARTIFACT != RECOVERY`
- `ARTIFACT WITHOUT TRUSTED IDENTITY != RELEASE PROOF`
- `MULTIPLE COPIES != INDEPENDENT ESCROW`
- `SOURCE ARCHIVED != BUILD ENVIRONMENT RECOVERABLE`
- `BUILD SUCCEEDS != RELEASE REPRODUCED`
- `BACKUP JOB PASSED != RESTORE DRILL PASSED`
- `SYSTEM BOOTS != RELEASED CONFIGURATION PROVED`
- `RECOVERY CAPABILITY LOST != SUPPORT CLAIM UNCHANGED`
- `CONTROLLER RECOVERY != SAFETY FUNCTION VALIDATION`

## Next exact work

Build BD40 on **configuration provenance attestations, trust boundaries, and artifact promotion**:

`engineering evidence -> candidate artifact -> automated checks -> human release authority -> immutable release identity -> provenance/attestation -> promotion to programming/service artifact -> downstream consumption -> revocation/supersession`

Stress locally built binaries with no release provenance, CI artifacts from the wrong commit, signed hashes whose signer authority is unclear, mutable `latest` URLs, a programmer selecting an unpromoted engineering image, and superseded artifacts that remain valid historical evidence but are no longer authorized for new programming.

No simulation, synthesis, place-and-route, timing run or other executable engineering verification is justified by BD39. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.