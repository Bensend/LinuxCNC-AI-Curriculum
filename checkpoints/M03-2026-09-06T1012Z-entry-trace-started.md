# M03 checkpoint — servo-period trace started

Session start: `2026-09-06T10:12:59Z`

## Completed this session

- Reconciled and accepted H04 lab 007, run `34024102367` / job `101461896527`, with fresh SHA/job metadata and every predeclared semantic gate passing.
- Created H04 accepted lab result, adversarial exam, passing answer key/correction pass, fresh-AI handoff, and graduated H04.
- Advanced the dependency graph to M03.
- Began M03 documentation, community, and pinned-source analysis in `guides/M03-servo-period-trace-initial.md`.

## Exact next work

Continue M03 at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`:

1. Trace the top-level call sequence of `emcmotController()` in `src/emc/motion/control.c`.
2. Locate and place the HAL-input sampling of `joint.N.motor-pos-fb` and HAL-output publication of `joint.N.motor-pos-cmd` in that sequence.
3. Trace the public `emcmotCommandHandler()` nonblocking command-mutex wrapper and command number/echo/ack behavior, including the exact deferred-command case.
4. Inventory the mode-dependent trajectory/kinematics calls necessary to explain one ordinary coordinated servo period without expanding into every motion mode.
5. Compare one canonical sim servo-thread order with one HostMot2-style servo-thread order, recording which ordering is configuration-specific.
6. Design a bounded M03 runtime experiment only after the source trace identifies a genuinely discriminating same-cycle/next-cycle behavior.

Do not reopen H04 live list-mutation or cross-thread memory-ordering questions in M03; they remain 2000/HIGH unless they become necessary to keep the servo-period foundation trace correct.