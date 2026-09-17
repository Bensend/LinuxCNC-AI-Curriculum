# Safety document provenance / supersession checkpoint — 2026-09-17

- UTC start: 2026-09-17T09:34:08Z
- Compute: NONE. No GitHub-hosted Actions minutes consumed; no executable question justified self-hosted compute.
- Status: CHECKPOINTED — safety course remains active.

## Durable work

Added `safety-course/SAFETY_DOCUMENT_PROVENANCE_AND_SUPERSESSION_REGISTER.md` in commit `b76b1da`.

The register binds safety evidence at claim level through:

`installed identity -> installed firmware/configuration -> applicable document identity/revision -> applicability range -> exact claim -> machine mapping -> physical verification`

It adds explicit supersession states, archived-copy identity, change-impact review, conflict handling, firmware/configuration coupling, and a release gate that leaves safety-critical applicability conflicts `UNKNOWN — NOT CLEARED`.

## Evidence gain

Current Rockwell GuardLogix documentation confirms that safety behavior/document applicability can be firmware-version-sensitive, that hardware/firmware incompatibility is an explicit safety status, and that controller/application safety signatures have bounded semantics. Firmware change therefore belongs in safety change control rather than being treated as a transparent maintenance action.

Pilz documentation confirms that wiring, firmware, device configuration/address and parameter changes are integrity risks and recommends unique device identification plus testing/logging recommissioning. Pilz product documentation pages also demonstrate why generic product-family bookmarks are inadequate: multiple operating-manual document identities/revisions can coexist for one family.

## Exact next work

Build a `SAFETY_CHANGE_IMPACT_AND_REVALIDATION_SCOPE_MATRIX.md` that converts concrete change classes—manual revision, firmware update, safety-controller logic/configuration, safety-I/O replacement, contactor/valve replacement, wiring/plumbing change, guard/protective-field change, LinuxCNC/HAL/FPGA change—into the evidence that must be re-opened and the minimum scoped revalidation decision. Keep PL/SIL/DC and machine-specific physical acceptance values UNKNOWN unless actual design evidence establishes them.

Then apply the matrix to one professional documented change/replacement example if authoritative evidence exposes enough of the chain.
