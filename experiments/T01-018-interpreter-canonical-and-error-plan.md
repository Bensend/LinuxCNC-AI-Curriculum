# T01-018 — interpreter canonical output and error propagation

Status: FROZEN / NOT YET EXECUTED

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Independently verify two 1000-level T01 claims without relying on source rereading:

1. a valid representative RS274 block produces the expected canonical operation;
2. a deliberately invalid block returns a real interpreter error and does not silently translate as valid motion.

This experiment uses the standalone `rs274` interface first because it isolates interpreter semantics from Task/motion timing. A later Task-level experiment may be added if needed to verify queue-buster/read-ahead ordering.

## Frozen prediction — record before execution

For a minimal valid file containing a rapid move, the standalone interpreter's canonical trace will contain `STRAIGHT_TRAVERSE` corresponding to that move and exit successfully.

For a separate file containing an invalid/unsupported G-code or syntactically malformed required expression selected after confirming it is invalid for the pinned revision, `rs274` will return nonzero/error status and report an interpreter diagnostic; the invalid line will not produce a valid canonical traverse/feed corresponding to the malformed command.

Prediction classification before run: SOURCE-GROUNDED PREDICTION, not TEST-CONFIRMED.

## Anti-circularity rule

The oracle must be process exit status plus emitted canonical/error output from the built pinned LinuxCNC executable. The experiment may not call the same parser/conversion helper directly and then claim that helper's return as independent verification.

## Setup

- Build/use the repository laboratory at the pinned revision.
- Use `rs274` from that pinned build, not a host distro version.
- Record `rs274 --help`/version provenance where practical and the LinuxCNC git SHA.
- Use deterministic local test files committed with the harness.

## Gate A — provenance

PASS only if the executed interpreter is tied to pinned revision `8bf4605ae81042248add031e94c77300406e0413` or the lab's already-validated build artifact for exactly that SHA.

## Gate B — valid canonical behavior

PASS only if:
- process exit indicates success;
- output contains a canonical rapid operation (`STRAIGHT_TRAVERSE`) for the selected valid G0 block;
- no interpreter error is reported for that block.

## Gate C — invalid-input behavior

PASS only if:
- the invalid fixture is independently shown invalid by the pinned executable;
- the process/error channel reports interpreter failure;
- no canonical motion corresponding to the invalid command is falsely treated as successful output.

## Gate D — separation control

Run valid and invalid fixtures in separate interpreter invocations so canonical output from the valid program cannot be mistaken for output after the invalid block. This deliberately avoids ambiguity about already-generated commands in a mixed file.

## Gate E — reproducibility

Harness prints fixture contents or hashes, pinned SHA, command lines, exit codes, and selected stdout/stderr evidence.

## Harness-invalid conditions

- wrong/unproven LinuxCNC revision;
- command resolves to a distro `rs274` rather than the pinned build;
- invalid fixture turns out to be legal at the pinned revision;
- output capture loses stderr/exit status;
- canonical output is produced by a mock rather than the pinned interpreter.

## Follow-up decision

If Gates A-E pass, T01 gains independent verification for parse/execute -> canonical output and interpreter failure behavior. This does **not** by itself TEST-CONFIRM Task read-ahead timing. Freeze a separate bounded Task/remap queue-buster experiment only if source/doc evidence plus the T01 graduation floor still require it.
