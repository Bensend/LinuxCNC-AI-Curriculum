# HM01 checkpoint — first 009 run harness-invalid; corrected retry launched

Session start: `2026-09-06T14:09:13Z`.

## Reconciliation

Run `34035539216`, job `101492796989`, curriculum SHA `84a65ff98d495001a487b8df33853791d1ee3387` is **HARNESS INVALID** for HM01 semantic evidence.

The job reached the pinned-source preflight, confirmed upstream SHA `8bf4605ae81042248add031e94c77300406e0413`, the upstream README statement that this tests `hm2_register()`, and `hm2_test`'s no-hardware module description. It then exited before configure/build/test execution. The log ends immediately after those first two greps. The third preflight grep required the exact source spelling `r = hm2_register(this, config[0]);`; that brittle text assertion failed. Therefore none of the 15 malformed-IDROM gates ran and no runtime HostMot2 claim is promoted from this attempt.

## Correction

Commit `b3cdebcd51653aaf415d2c9032cc045518a966d0` changes only that source-presence preflight to a whitespace/local-variable-insensitive expression matching an actual `hm2_register(...);` call. All semantic experiment gates remain unchanged.

The push launched exactly one materially corrected retry: Actions run `34038328272`, head SHA `b3cdebcd51653aaf415d2c9032cc045518a966d0`. It was queued at inspection time. Do not launch another run merely because a new lesson starts.

## Exact next work

Inspect run `34038328272` first. Require fresh metadata and the unchanged malformed-IDROM/adversarial gates. If it passes, write accepted-result evidence, grade the HM01 adversarial exam, perform corrections/fresh-AI handoff, and decide graduation. If it fails, classify from the preserved log before deciding whether another materially redesigned attempt is justified under the three-attempt rule.
