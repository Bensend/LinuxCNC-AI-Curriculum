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

The stable source also confirms that its `run_tests()` summary ends after the skipped count and that test discovery/dispatch still recognizes `test.hal`, `test.sh`, and `test`, with shell tests run through `bash -x` and `.hal` tests using the overrun-specific retry path. This makes the summary-format difference a harness-version issue rather than evidence that the stable test failed.

## Stable experiment `003` — TEST-CONFIRMED

`lab-jobs/003-stable-v2.9.10-baseline.sh` checked out exact commit `86cdca76fa2a36274c432caa21952b23c267989a` and used the stable checkout's own Debian metadata, build system, RIP environment, `runtests` harness, and `tests/realtime-math` definition. It did not transplant development harness behavior into stable.

GitHub Actions run `33952061943` completed successfully. Preserved observations:

- workflow conclusion: success; curriculum lab exit code: `0`;
- exact checkout reported `HEAD is now at 86cdca76f 2.9.10 Release`;
- `tests/realtime-math` executed through the stable upstream harness;
- stable summary: `Runtest: 1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped`;
- `runtests exit status: 0`;
- `halcompile --install rtmath.comp` compiled/linked `rtmath.so` and installed it into the stable RIP `rtlib`;
- `halrun dotest.hal` succeeded;
- the runner reported `Note: Using POSIX non-realtime`, so this remains a software/reproducibility test rather than realtime scheduling evidence;
- the wrapper's post-test `ipcs -m` observation showed no System V shared-memory segments, but this does not convert stable's harness into development-style automatic shared-memory hygiene.

Prediction and observation matched. The experiment experimentally confirms the stable side of the reproducibility baseline while preserving the source-confirmed harness difference.

## Stable-vs-development comparison

| Property | Stable `v2.9.10` | Development `8bf4605...` | Evidence |
|---|---|---|---|
| Exact representative test passes | yes, 1/1 | yes, 1/1 | TEST-CONFIRMED |
| Runner scheduling mode in Actions | POSIX non-realtime | POSIX non-realtime fallback | TEST-CONFIRMED |
| Harness summary includes shmem-error count | no | yes (`0 shmem errors` in observed run) | SOURCE + TEST-CONFIRMED |
| Explicit harness pre/post recognized-shmem cleanup path | absent in inspected harness | present | SOURCE-CONFIRMED |
| Post-test wrapper `ipcs -m` observed clean state | yes | yes | TEST-CONFIRMED, observation only |

Important distinction: a clean `ipcs -m` snapshot after a stable test does not prove the stable harness performs the development harness's explicit cleanup. It only proves no System V shared-memory segment remained in this bounded run.

## Evidence ledger

| Claim | Class | Scope |
|---|---|---|
| `v2.9.10` dereferences to `86cdca76fa2a36274c432caa21952b23c267989a` | SOURCE-CONFIRMED | tag object inspected 2026-09-05 |
| LinuxCNC site lists 2.9.10 as current stable | DOC-CONFIRMED | official site, 2026-09-05 |
| 2.9.10 release followed withdrawal of 2.9.9 due compatibility regression | COMMUNITY-REPORTED / official announcement | release announcement |
| development `8bf460...` builds in curriculum Actions lab | TEST-CONFIRMED | Ubuntu 24.04 uspace software lab |
| development representative realtime-math test passes in POSIX non-realtime fallback | TEST-CONFIRMED | experiment `002` |
| stable and development harnesses differ in explicit shared-memory hygiene path | SOURCE-CONFIRMED | exact two pinned revisions |
| stable `v2.9.10` builds and passes the equivalent representative test | TEST-CONFIRMED | experiment `003`, run `33952061943` |
| stable representative test demonstrated realtime scheduling | FALSE / contradicted by observation | runner explicitly used POSIX non-realtime |

## Phase-0 correction result

No contradiction was found between the pre-experiment source analysis and experiment `003`. The experiment strengthened one adversarial lesson: human-readable harness summaries are version-sensitive interfaces and must not be parsed as if development output were universal. Realtime-sounding test names also remain an evidence trap; both pinned baselines passed while running non-realtime in Actions.

## Next checkpoint

L01 is ready for Phase-0 graduation once the cross-module adversarial/fresh-AI handoff record is committed. Future modules must continue to carry both exact revisions where version comparison matters and must never reuse these cloud tests as evidence for realtime scheduling or physical-machine suitability.
