#!/usr/bin/env bash
set -euo pipefail

# Harness-only repair for run 068.
# Run 068's outer Python here-document used delimiter PY while the embedded
# analyzer template also contains a standalone PY terminator. The shell therefore
# ended the outer here-document before Python saw the closing triple quote.
# This revision changes only that wrapper delimiter. Frozen PB-PREP-001 behavior,
# disturbances, phase timing, thresholds, Gates A-J, and the B/P6
# missing-discriminator => INCONCLUSIVE rule are unchanged.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/068-pb-prep-001-p2-p7-packed-stream.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-069-delimiter-fixed.sh"
cp "$SRC" "$FIXED"

python3 - "$FIXED" <<'PATCH'
from pathlib import Path
import sys

p = Path(sys.argv[1])
s = p.read_text()

open_old = "python3 - \"$FIXED\" <<'PY'\n"
open_new = "python3 - \"$FIXED\" <<'PYFIX'\n"
if s.count(open_old) != 1:
    raise SystemExit(f"HARNESS_INVALID: expected one outer heredoc opener, found {s.count(open_old)}")
s = s.replace(open_old, open_new, 1)

close_old = "\nPY\nchmod +x \"$FIXED\"\nprintf '%s\\n' 'PB-PREP-001 revision 2: 29 logical witnesses packed into stock sampler 21-element ceiling; behavioral contract unchanged.'"
close_new = "\nPYFIX\nchmod +x \"$FIXED\"\nprintf '%s\\n' 'PB-PREP-001 revision 2: 29 logical witnesses packed into stock sampler 21-element ceiling; behavioral contract unchanged.'"
if s.count(close_old) != 1:
    raise SystemExit(f"HARNESS_INVALID: expected one outer heredoc closer context, found {s.count(close_old)}")
s = s.replace(close_old, close_new, 1)

# Adversarial static checks: the generated analyzer's own PY terminator must remain,
# while the outer wrapper must now have a distinct delimiter pair.
if s.count("<<'PYFIX'") != 1 or s.count("\nPYFIX\n") != 1:
    raise SystemExit("HARNESS_INVALID: PYFIX delimiter pair not unique")
if "cat > /tmp/analyze_pb.py <<'PY'\n" not in s:
    raise SystemExit("HARNESS_INVALID: inner analyzer heredoc unexpectedly changed")

p.write_text(s)
PATCH

chmod +x "$FIXED"
printf '%s\n' 'PB-PREP-001 revision 3: repaired only the 068 outer heredoc delimiter collision; frozen experiment contract unchanged.'
exec "$FIXED"
