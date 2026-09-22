# BD40 — Configuration Provenance Attestations, Trust Boundaries, and Artifact Promotion

## Purpose

BD39 established that recoverability requires exact artifacts, identity, environment, and restoration evidence. BD40 addresses the authority problem that remains even when every byte is available:

`engineering evidence -> candidate artifact -> automated checks -> human release authority -> immutable release identity -> provenance/attestation -> promotion to programming/service artifact -> downstream consumption -> revocation/supersession`

This lesson develops both linked skills. **Block engineering** must publish exact generic contracts and evidence whose revision can be consumed by a release. **Board integration** must bind those revisions to the board, FPGA/resource map, LinuxCNC/HAL configuration, connection definitions, and the exact artifact authorized for programming or service.

OpenPressBrake is a current governance/worked-example source only. It is not represented as production-proven hardware or as having a released fleet.

## Hard student-material audit

The following current-main files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD39_CONFIGURATION_EVIDENCE_ESCROW_DISASTER_RECOVERY_AND_REPRODUCIBILITY.md` — exact-image recovery, artifact identity, environment and restore-evidence rules.
- Curriculum `hardware/4000-board-design/BD38_FLEET_CLOSURE_RESIDUAL_SUPPORT_AND_LEGACY_RETIREMENT.md` — support-state and retained-evidence context.
- Curriculum `WORK_SELECTION_POLICY.md` — independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — evidence-backed readiness and truthfulness gates.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block, adapter and board-integration ownership.
- OpenPressBrake `hardware/blocks/differential_encoder/manifest.yaml` — current reusable encoder contract, resource declarations, reference provenance and board-owned unknowns.
- OpenPressBrake `hardware/blocks/differential_encoder/REV1_3V3_POWER_HANDOFF.yaml` — current machine-readable board-power handoff and explicit ownership boundary.
- OpenPressBrake `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md` — current evidence inventory, real-image binding, open physical-machine facts and release gates.

The encoder material is not assigned as finished production hardware. It remains `SIMULATION-READY`; cable/termination selection, protected encoder field power, abnormal/transient work, schematic visual review, PCB integration, final cost, board integration and human Rev-1 release gates remain open. For a released-production claim it is `ENGINEERING_REVIEW_NEEDED`.

---

## 1. Integrity, provenance, and authority are different claims

A hash answers whether bytes match a recorded digest. Provenance answers where an artifact came from. Authority answers whether that artifact is permitted for a particular release, board, machine, or service action.

A cryptographically intact FPGA image built from an engineer's local branch may have excellent integrity and known provenance while still having **no release authority**.

> **INTEGRITY != RELEASE AUTHORITY**

Do not collapse these claims into a single `verified` flag.

## 2. Candidate artifacts are not programming artifacts

Treat outputs from engineering builds, CI, synthesis, local tests, or experimental HAL configurations as **candidates** until an explicit promotion decision binds them to a release identity and permitted use.

A candidate record should identify at least:

- source repository and exact commit/tree;
- dirty/uncommitted state;
- dependencies/submodules and external inputs;
- toolchain/environment identity;
- build settings and board/resource target;
- generated artifact digest;
- checks actually executed and their evidence;
- known skipped/deferred checks;
- block/adapter/board revisions consumed;
- machine facts still `VERIFY_AT_MACHINE`.

A filename such as `final.bit` or `release.bin` grants no authority.

> **CANDIDATE BUILT != ARTIFACT PROMOTED**

## 3. Automated checks establish bounded evidence, not human release authority

Automation can prove exact facts: schema validity, resource collisions, ERC/DRC results, synthesis success, test outcomes, hash generation, or that a candidate was built from a specified commit. It cannot silently convert open engineering gates into approval.

Promotion must state which automated evidence is required and which human decision remains authoritative. A green workflow is evidence for the checks it ran, not a substitute for release review.

> **CI PASS != RELEASE APPROVAL**

If executable verification is required for this curriculum, it must use only the self-hosted `[self-hosted, openpressbrake]` runner. BD40 itself requires no new executable verification.

## 4. Bind release authority to immutable identity

A promoted release artifact should be bound to an immutable release/configuration identity, not a mutable branch name, `latest` URL, or directory whose contents can change.

The release record should join:

`release ID <-> source revision <-> consumed block/adapter revisions <-> board/BOM/options <-> connection/resource map <-> FPGA image/hash <-> LinuxCNC/HAL configuration <-> evidence set <-> release authority`

If a board has assembly variants, the authorization must identify which variant(s) the artifact applies to.

> **MUTABLE LOCATION != IMMUTABLE RELEASE IDENTITY**

## 5. Attestation says who asserts what about which artifact

An attestation is useful only when its semantics are explicit. Record:

- exact subject artifact digest;
- claim being asserted;
- source/build/evidence identities supporting the claim;
- issuer/signer identity;
- issuer role/authority scope;
- time/version where relevant;
- verification method;
- revocation/supersession status.

A valid signature proves possession of the corresponding signing key. It does **not** prove that the signer was authorized to approve a Rev-1 controller, that the artifact passed required engineering gates, or that the key was used under the correct process.

> **SIGNATURE VALID != SIGNER AUTHORIZED FOR CLAIM**

Trust policy belongs beside release governance, not inside a reusable electrical block.

## 6. Promotion is a controlled state transition

Use explicit states rather than a shared folder convention. A practical model is:

- `ENGINEERING_CANDIDATE` — build exists; not authorized for released hardware.
- `EVIDENCE_COMPLETE_CANDIDATE` — required machine-checkable evidence is present; human gate still open.
- `PROMOTED_RELEASE` — human/defined release authority approved the exact identity and envelope.
- `SERVICE_AUTHORIZED` — permitted for specified service/as-maintained populations.
- `SUPERSEDED` — retained as historical evidence but not preferred/authorized for new builds except where policy explicitly permits it.
- `REVOKED` — authority withdrawn for stated scope/reason; historical evidence retained.
- `QUARANTINED` — identity/provenance/authority is uncertain; do not program.

Projects may use different names, but the state transitions and authority must be machine-readable enough that tools fail closed.

## 7. Programming tools must consume authority, not filenames

A service programmer or manufacturing station should not ask a technician to browse a folder and choose among similarly named bitstreams. The programming workflow should resolve the target's exact configuration identity, then admit only an artifact authorized for that target and action.

Before programming, reconcile:

1. target board/configuration identity;
2. allowed hardware/assembly variant;
3. artifact digest and promotion state;
4. FPGA/software/HAL compatibility;
5. service/new-build applicability;
6. revocation/supersession policy;
7. required `VERIFY_AT_MACHINE` facts;
8. resulting as-maintained identity.

> **PROGRAMMER CAN LOAD IT != PROGRAMMER MAY LOAD IT**

A manual override, if policy permits one, must create explicit exception evidence rather than silently bypassing the authority model.

## 8. Promotion cannot repair stale evidence

Suppose a candidate was built from commit A, then a power contract or pin allocation changed at commit B. Promoting the old artifact after reviewing the new source does not make the old artifact consume the new evidence.

Release promotion must bind evidence to the exact candidate inputs. If an upstream semantic facet changes, dependency tracking must mark affected candidates/releases stale or require a documented non-impact disposition.

> **NEWER REVIEW != OLDER ARTIFACT UPDATED**

This is where `SHOW WHERE USED` becomes operational release control rather than documentation convenience.

## 9. Supersession and revocation are not deletion

**Supersession** normally means a newer authorized configuration replaces an older one for some use. The older artifact may remain valid historical evidence and may even remain service-authorized for a bounded installed population.

**Revocation** withdraws authority because the artifact, evidence, signing authority, or supported envelope is no longer acceptable for a defined use.

Neither action should erase the artifact or its prior history when that history is needed for installed-population traceability, field action, failure analysis, or rollback evidence.

> **SUPERSEDED != HISTORICALLY INVALID**

> **REVOKED != DELETE THE EVIDENCE**

## 10. Trust boundaries must include people, automation, storage, and programming

Draw the trust flow, not merely the file flow. Typical boundaries include:

- developer workstation -> source control;
- source control -> controlled build environment;
- build -> test/evidence collector;
- evidence -> human release authority;
- release authority -> immutable artifact store;
- artifact store -> manufacturing/service programmer;
- programmer -> target hardware;
- target identity/result -> as-built/as-maintained record.

For each boundary ask what prevents substitution, stale input, unauthorized promotion, mutable references, wrong-target programming, and loss of negative evidence.

Do not assume that because two steps happen in the same GitHub repository they share the same authority.

## 11. Reusable blocks publish evidence; board releases consume it

The inspected OpenPressBrake encoder demonstrates the boundary well. Its reusable manifest owns one-encoder electrical semantics, receiver/protection choices, generic FPGA demand and reference provenance. Its 3V3 handoff publishes a 17 mA maximum receiver-source planning load and 100 nF local bypass per populated primitive while leaving instance count, aggregate rail sizing, FPGA pin allocation, physical connector, termination selection and machine field supply to board integration.

That handoff explicitly says its publication does **not** advance formal status. The current checklist likewise remains `SIMULATION-READY` and preserves open physical-machine and release gates.

A future board release may consume this evidence, but cannot turn it into `REV 1 READY` merely by producing a signed board bitstream. Conversely, the reusable block should not acquire the board's release signer, serial numbers, connector J-numbers, or service population.

This is the adversarial catalog lesson: **promotion metadata belongs to the release/configuration layer unless the claim is genuinely about the reusable block revision itself.**

## 12. Cross-machine reuse

The same authority model applies to mills, lathes, plasma tables, routers, robots, press brakes, and custom automation. Their artifacts differ, but all benefit from exact target identity, controlled promotion, fail-closed programming, and retained superseded evidence.

A small router may use a manually approved FPGA image while a fleet of automation cells uses signed release attestations. The scale differs; the distinction between candidate and authorized artifact does not.

## 13. Safety boundary

This lesson governs ordinary controller release/configuration authority. It does not create safety-rated development, validation, signing, or change-control authority.

An ordinary-controller release may monitor an independent safety system or command ordinary enable/STO interfaces where the architecture permits, but its promotion record does not validate PL/SIL/category, stopping performance, safety diagnostics, or final elements.

> **CONTROLLER ARTIFACT PROMOTED != SAFETY FUNCTION VALIDATED**

---

## Lab — eight adversarial promotion cases

Use a fictional controller family spanning a mill, router, robot, and press brake.

### Case 1 — local binary, exact source known

An engineer builds a bitstream locally from the correct commit and records its SHA-256. All tests that engineer normally runs pass. Decide what is known, what authority is absent, and whether manufacturing may use it.

### Case 2 — CI artifact from the wrong commit

A green workflow artifact has the expected filename, but provenance shows it came from the commit before a pin-map correction. Prevent filename familiarity from overriding exact source identity.

### Case 3 — valid signature, unclear signer authority

A digest is correctly signed by a developer key, but release policy grants approval authority to a different role. Separate cryptographic validity from release authorization.

### Case 4 — mutable `latest`

A service instruction points to `latest/controller.bit`. The contents changed after the instruction was written. Replace the mutable reference with an immutable identity and define how the service tool resolves it.

### Case 5 — unpromoted engineering image selected by programmer

A technician can see both `ENGINEERING_CANDIDATE` and `PROMOTED_RELEASE` artifacts. Design the programming gate so a convenient manual selection cannot silently install the candidate.

### Case 6 — evidence changed after candidate build

A shared 3V3 contract changes after the candidate bitstream and board package were generated. Determine whether the artifact is stale, what dependency facets matter, and what evidence is required before promotion.

### Case 7 — superseded but still installed

Release R2 supersedes R1 for new builds, but known machines remain on R1. Preserve R1 as historical/as-maintained evidence while preventing accidental new-build use outside its policy.

### Case 8 — revocation after field finding

A field defect causes authority for one FPGA/HAL pairing to be withdrawn. Define revocation scope, affected-population discovery, quarantine/programming behavior, replacement authority, and preservation of failure evidence.

For each case submit:

- exact candidate/artifact digest and source identity;
- consumed block/adapter/board/configuration revisions;
- integrity evidence;
- provenance evidence;
- automated checks actually passed;
- open/deferred evidence;
- issuer/release-authority identity and scope;
- promotion state;
- target/new-build/service applicability;
- supersession/revocation state;
- programming-tool behavior;
- stale-dependency impact;
- `VERIFY_AT_MACHINE` items;
- safety-authority statement.

### Lab pass criteria

A passing submission must distinguish integrity, provenance, and authority; candidate and promoted artifacts; CI evidence and human release authority; signing-key validity and signer authorization; supersession and revocation; reusable-block evidence and board/configuration release metadata; and ordinary-controller promotion from independent personnel-safety validation. Unknown authority must fail closed rather than being guessed.

---

## Catalog stress-test result

BD40 exposes a lifecycle/release infrastructure need above the reusable catalog: a future **artifact promotion/provenance record** should bind exact candidate and release identities to:

- subject artifact digests and artifact type;
- exact source/dependency/toolchain/environment identity;
- consumed reusable block, adapter, board, BOM, connection and resource revisions;
- automated check/evidence IDs and skipped/deferred gates;
- release/configuration ID and applicable assembly variants;
- issuer/signer identity, role and authority scope;
- human release decision/evidence;
- promotion state and timestamp/version;
- new-build/service/as-maintained applicability;
- programming-distribution authority;
- dependency/staleness status;
- supersession/revocation/quarantine state and reason;
- affected installed/as-maintained population links;
- retained negative evidence and rollback history.

This belongs in release/configuration infrastructure, not in reusable block manifests. A block may have its own revision approval/evidence, but board artifact authority must not leak machine-specific release metadata into generic circuitry.

Current OpenPressBrake does not establish such a released artifact-promotion system or released fleet. Keep this infrastructure need `ENGINEERING_REVIEW_NEEDED`; do not invent signing keys, release approvers, immutable stores, serial populations, or production authority.

## Durable freezes

- `INTEGRITY != RELEASE AUTHORITY`
- `CANDIDATE BUILT != ARTIFACT PROMOTED`
- `CI PASS != RELEASE APPROVAL`
- `MUTABLE LOCATION != IMMUTABLE RELEASE IDENTITY`
- `SIGNATURE VALID != SIGNER AUTHORIZED FOR CLAIM`
- `PROGRAMMER CAN LOAD IT != PROGRAMMER MAY LOAD IT`
- `NEWER REVIEW != OLDER ARTIFACT UPDATED`
- `SUPERSEDED != HISTORICALLY INVALID`
- `REVOKED != DELETE THE EVIDENCE`
- `CONTROLLER ARTIFACT PROMOTED != SAFETY FUNCTION VALIDATED`

## Next exact work

Build BD41 on **release dependency invalidation, semantic change impact, and controlled re-promotion**:

`released artifact -> upstream semantic change -> SHOW WHERE USED -> affected claim/evidence classification -> stale/quarantine decision -> bounded regression -> new candidate -> re-promotion or documented non-impact -> downstream fleet/service applicability`

Stress component substitutions that preserve topology but alter limits, FPGA resource-map changes with unchanged HAL names, board connector remaps hidden behind stable logical names, toolchain rebuilds that produce different binaries, and a generic block evidence correction that invalidates only one consumed semantic facet rather than every historical release.

Require students to invalidate by semantic dependency rather than filename proximity, preserve unaffected evidence, fail closed when dependency identity is unknown, and distinguish requalification of a reusable block from re-promotion of a board/configuration artifact.
