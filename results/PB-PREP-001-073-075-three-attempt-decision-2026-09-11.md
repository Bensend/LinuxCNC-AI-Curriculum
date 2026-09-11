# PB-PREP-001 073–075 three-attempt decision

Date: 2026-09-11

Decision: **ESSENTIAL NOW — retire the nested wrapper-on-wrapper construction family and flatten the rendered behavioral script before any further LinuxCNC execution**

## Attempt classification

Runs 073, 074, and 075 are **HARNESS INVALID / compute only**. None reached LinuxCNC behavioral execution and none may be pooled into A/B/C metrics.

- **073** structurally limited the intended sampler-tap replacements to `newnets`, but its post-edit immutability oracle re-parsed the wrong raw-string boundary and terminated before LinuxCNC.
- **074** replaced that re-parse with a byte-prefix proof, but inherited the same incorrect raw-string boundary and therefore correctly rejected the construction before LinuxCNC.
- **075** was the third attempt. Source inspection established that 068 closes both `oldnets` and `newnets` on the same line as their last HAL command (`...false'''`), whereas the helper searched for a newline followed by the triple quote. The attempted helper hot-patch itself did not match the nested quoted source and failed before rendering.

The repeated failure mechanism is now the construction layering itself: 068 generates a behavioral script, 070 rewrites 068, and 073–075 rewrite 070's embedded rewrite. Continuing another patch-on-patch attempt would violate the three-attempt rule even though the intended behavioral contract has not changed.

## ESSENTIAL NOW redesign

The next cycle must use a **single construction compiler** operating directly on retained `068-pb-prep-001-p2-p7-packed-stream.sh` and must stop before LinuxCNC execution on its first pass:

1. Apply 070's already-understood outer here-document and duplicate-terminal corrections directly to 068 in one transformer.
2. Parse `oldnets` and `newnets` using the actual same-line triple-quote terminator, prove `oldnets` is byte-for-byte unchanged, and edit only the eight invalid packed sampler joins in `newnets`.
3. Render the final behavioral script without executing LinuxCNC.
4. Run `bash -n` plus the 21-element schema, max-pin, frozen controller/plant/timing/disturbance tokens, eight corrected direct signal joins, and B/P6=>INCONCLUSIVE checks against that final rendered file.
5. Retain the fully rendered file and a cryptographic digest as the construction-preflight artifact.
6. Only after that flattened artifact passes should a separate execution job run the exact retained script, with no further source rewriting.

This is a material harness-construction redesign and starts a new attempt family. It does **not** change any A/B/C controller parameter, plant parameter, P2–P7 timing, threshold, Gate A–J criterion, or outcome rule.

## Evidence boundary

067–075 remain non-behavioral harness evidence. F02 remains blocked on genuinely information-separated fresh-AI handoffs for S02, E20, X01, and X02; PB-PREP-001 work does not alter that boundary.
