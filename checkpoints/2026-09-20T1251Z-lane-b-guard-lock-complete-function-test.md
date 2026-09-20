# Lane-B safety checkpoint — guard-lock complete function-test evidence

Date: 2026-09-20T12:51Z

## Completed

Added `safety-course/GUARD_LOCK_ESCAPE_RELEASE_COMPLETE_FUNCTION_TEST_ACCEPTANCE_TRACE_2026-09-20.md` without touching the primary lane's scanner/stand-behind, hydraulic, gravity-axis, or final-element evidence files.

EUCHNER manufacturer instructions materially extend the prior Pilz/SICK escape-release recovery study with a complete physical/electrical guard-lock test: no automatic start after close/lock, physical opening prevented, unlock inhibited while dangerous function is active, lock retained until overtravel/injury risk has ended, machine start inhibited while unlocked, manual-release function tested, and the sequence repeated for each guard. Separate EUCHNER escape-release documentation requires restoration and a correct-function check; Pilz independently requires qualified-person function testing during recommissioning.

## Evidence state

- DOC-CONFIRMED: manufacturer guard-lock and escape-release behaviors/test sequence.
- INFERENCE: LinuxCNC/HAL/FPGA status cannot substitute for physical guard-lock acceptance; stale ordinary command should be challenged separately.
- TEST-CONFIRMED: none in this pass.
- SOURCE-CONFIRMED: none newly required.
- COMMUNITY-REPORTED: none relied upon.
- UNKNOWN: all OpenPressBrake-specific guard architecture, timing, performance, reset/restart and hydraulic/final-element facts not physically established.

## Information-gain decision

Generic guard-lock/escape-release catalog searching is now low value. The branch has multi-manufacturer recovery evidence and a complete manufacturer physical/electrical function-test sequence.

## Precise next Lane-B work

Seek authoritative manufacturer/OEM validation that deliberately preasserts or holds an ordinary START/CYCLE/motion request across a safety demand and reset/requalification and proves safety restoration cannot itself resume hazardous motion without a separate fresh start action. If that combined evidence remains unavailable, rotate to another independent physical safety-function witness rather than inventing a synthetic acceptance result.

## Compute

No simulation/build/test compute was justified. No GitHub-hosted runner was used.