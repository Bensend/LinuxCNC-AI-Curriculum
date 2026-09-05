# L01 — LinuxCNC Version Pinning and Reproducibility

## Baselines

### Current stable

- Release: LinuxCNC `2.9.10`
- Git tag: `v2.9.10`
- Annotated tag object: `4e7abeab3e764a42ef9def932333a1d4004e547b`
- Dereferenced commit: `86cdca76fa2a36274c432caa21952b23c267989a`
- Official LinuxCNC site identified 2.9.10 as the current release during this curriculum pass (2026-09-05).
- The LinuxCNC forum release announcement states 2.9.10 was released after 2.9.9 was withdrawn because a bug fix broke existing configurations that had been working around the prior behavior.

### Development baseline

- Branch context when pinned: `master`, LinuxCNC `2.10.0~pre1`
- Exact curriculum development commit: `8bf4605ae81042248add031e94c77300406e0413`

The mutable branch name is context only. All source conclusions and experiments must cite the exact commit.

## Why both baselines exist

The curriculum studies current development source deeply because later architecture and driver work needs the latest implementation. Stable remains a compatibility/reference baseline because field machines and packaged installations commonly run released versions. A claim established only on master must not silently be presented as 2.9 behavior, and a stable behavior must not be assumed unchanged on master.

## Tag dereference evidence

GitHub's `refs/tags/v2.9.10` points to annotated tag object `4e7abeab3e764a42ef9def932333a1d4004e547b`. That tag object's target is commit `86cdca76fa2a36274c432caa21952b23c267989a`. This two-step dereference matters because the tag ref does not point directly at a commit object.

Classification: `SOURCE-CONFIRMED` for repository identity/version mapping.

## Stable release context

The official LinuxCNC website listed 2.9.10 as the current release and dated the release July 9, 2026. The official 2.9 documentation landing page identifies itself as LinuxCNC version 2.9.10 documentation. LinuxCNC's downloads documentation also draws an important evidence boundary: `linuxcnc-uspace` can run on a standard kernel for simulation, but a realtime kernel is required to control machinery; running uspace on a stock kernel is not a hardware-control qualification.

The forum release announcement provides useful version-risk context. It states that 2.9.9 was briefly released and withdrawn because a bug fix broke existing configurations that had been relying on the earlier buggy behavior, and 2.9.10 followed. This is `COMMUNITY-REPORTED`/official-announcement context showing why exact version discipline is not bureaucratic detail: even bug-fix releases can expose compatibility assumptions.

References:

- https://linuxcnc.org/
- https://linuxcnc.org/docs/html/
- https://linuxcnc.org/downloads/
- https://forum.linuxcnc.org/29-forum-announcements/58966-2-9-10-release
- https://api.github.com/repos/LinuxCNC/linuxcnc/git/ref/tags/v2.9.10

## Reproducibility contract

Every source-level curriculum conclusion should retain:

1. exact LinuxCNC commit SHA;
2. tag/branch context when useful;
3. source path and significant symbol/function;
4. exact experiment job/configuration when behavior is tested;
5. relevant operating-system/runner and realtime mode;
6. expected behavior recorded before execution;
7. observed result, preserved output, and exit status;
8. explicit limits on what the evidence proves.

A branch name alone is inadequate because branches move. A marketing/release version alone is weaker than the dereferenced Git commit for source work. Conversely, a commit SHA alone can obscure whether the result represents a stable release or an arbitrary development snapshot, so both immutable identity and release/branch context are retained.

## First observed stable-vs-development source difference

At the two pinned revisions, `scripts/runtests.in` is version-sensitive:

- development contains `SHMERR`, a recognized shared-memory-key list, a pre-suite `test_shmem()` check, post-test `test_and_remove_shmem()` handling, and a shmem-error count in the summary;
- stable v2.9.10 lacks that inspected explicit shared-memory hygiene path and reports the older summary format.

This is `SOURCE-CONFIRMED` at the exact revisions above. It must not be generalized to every historical 2.9 or future 2.10 revision without checking.

## Stable experiment `003`

`lab-jobs/003-stable-v2.9.10-baseline.sh` is the bounded reproducibility test. It deliberately checks out the exact stable commit and uses the stable checkout's own Debian metadata, build system, RIP environment, `runtests` harness, and `tests/realtime-math` definition. It does not transplant development harness behavior into stable.

The selected upstream stable test is directly comparable to experiment `002`: stable `tests/realtime-math/test.sh` also executes `${SUDO} halcompile --install rtmath.comp` followed by `halrun dotest.hal`.

Result status: pending at creation of this guide; update only from preserved laboratory evidence.

## Evidence ledger

| Claim | Class | Scope |
|---|---|---|
| `v2.9.10` dereferences to `86cdca76fa2a36274c432caa21952b23c267989a` | SOURCE-CONFIRMED | tag object inspected 2026-09-05 |
| LinuxCNC site lists 2.9.10 as current stable | DOC-CONFIRMED | official site, 2026-09-05 |
| 2.9.10 release followed withdrawal of 2.9.9 due compatibility regression | COMMUNITY-REPORTED / official announcement | release announcement |
| development `8bf460...` builds in curriculum Actions lab | TEST-CONFIRMED | Ubuntu 24.04 uspace software lab |
| development representative realtime-math test passes in POSIX non-realtime fallback | TEST-CONFIRMED | experiment `002` |
| stable and development harnesses differ in explicit shared-memory hygiene path | SOURCE-CONFIRMED | exact two pinned revisions |
| stable `v2.9.10` builds/passes equivalent test in current runner | UNKNOWN pending `003` | do not infer until lab result is captured |

## Next checkpoint

Inspect experiment `003` result. If it passes, convert the stable build/test row to `TEST-CONFIRMED`, document observed stable summary/fallback behavior, and use the Phase-0 adversarial exam to drive corrections. If it fails, preserve the exact failure and diagnose it as a reproducibility/compatibility lesson rather than modifying the stable source until the cause is understood.
