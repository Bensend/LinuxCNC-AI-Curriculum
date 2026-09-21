# Safety course checkpoint — enabling permission freshness

Session start recorded: 2026-09-21T07:33:51Z.

## Durable result

ABB/KUKA professional documentation establishes that safety-related enabling permission can depend on transition history rather than current input level alone. ABB's three-position enabling implementation requires fresh released->center establishment and does not accept overtravel->center as renewed enabling authority. KUKA independently separates operating mode, enabling state, safeguard state and motion command.

New freezes are in `safety-course/ABB_KUKA_ENABLING_DEVICE_REARM_AND_MODE_TRANSITION_FRESHNESS_2026-09-21.md`; adversarial exercise is `safety-course/25C0_ENABLING_DEVICE_TRANSITION_FRESHNESS_ADVERSARIAL_EXERCISE_2026-09-21.md`.

## Exact next work

Find an authoritative professional implementation exposing the complete setup/manual -> safeguarded automatic return sequence, especially explicit handling of an ordinary start/jog request that remains physically true while safety permission or operating mode changes. Prefer OEM/safety-controller documentation with actual transition semantics. Distinguish safety-related permission freshness from ordinary command freshness. Do not infer that selecting automatic mode is a start command and do not universalize ABB's exact enabling state machine.

If this narrow source path becomes repetitive/source-limited, rotate to another open 25C0/25E0 professional implementation rather than inventing semantics.

No compute was justified; no GitHub-hosted runner was used.