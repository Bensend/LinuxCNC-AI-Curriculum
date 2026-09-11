# PB-PREP-001 three-attempt harness decision

Date: 2026-09-11

Decision: **ESSENTIAL NOW — materially redesign construction before another behavioral attempt**

No A/B/C behavioral verdict is taken from attempts 067–069.

## Attempt family

1. **067 — direct 29-element sampler schema:** invalid because pinned LinuxCNC limits one HAL stream to 21 elements. This discovered a real source-level instrumentation constraint, not a controller result.
2. **068 — pre-result 21-element packed redesign:** invalid before LinuxCNC because the wrapper's outer `PY` here-document delimiter collided with the embedded analyzer's `PY` terminator.
3. **069 — delimiter-only correction:** passed the previous failure point and built pinned LinuxCNC, then failed while rendering the generated fixture because the 068 `section()` replacement retained an original `EOF` even though the replacement text already supplied an `EOF`; the generated shell therefore contained an extra standalone `EOF` command.

These are construction failures, but they have now reached the Master Mission's three-attempt ceiling for the current harness family. Blind reruns are prohibited.

## Why ESSENTIAL NOW

PB-PREP-001's purpose is to compare observability and control consequences of three synchronization insertion points under one frozen software plant. Without one coherent atomic recorder and identical frozen execution contract, any architecture ranking or saturation/ferror interpretation would be unsound. Therefore the harness cannot be promoted or dropped while claiming the experiment answered its question.

The experiment is specialization preparation and does not block F02; however, *this experiment's* next execution requires a materially safer construction path.

## Material redesign boundary

The next attempt begins a new construction cycle and must use a **render-then-validate** wrapper rather than stacking another one-line runtime repair on the failed generated script.

Before LinuxCNC build/execution, the redesigned wrapper must:

- start from the frozen 068 packed-stream source, not from behavioral results;
- apply both known mechanical rendering corrections in one deterministic transformation: unique outer Python delimiter and single ownership of the component/analyzer here-document terminators;
- retain the frozen 21-element packed physical schema and 29 logical witnesses unchanged;
- render the final behavioral script to a file;
- run `bash -n` on the rendered final script;
- reject consecutive duplicate standalone `EOF`, `PY`, or replacement-boundary markers;
- verify there is no `sampler.0.pin.21` or higher reference;
- verify the packed sampler config has exactly 21 types;
- verify frozen constants remain `ROWS=12000`, `U_MAX=2.0`, `SYNC_GAIN=1.0`, `DIFF_MAX=0.25`, `PGAIN=6.0`;
- only after these static checks execute the rendered script once.

No P2–P7 duration, disturbance, controller/plant constant, metric, Gate A–J criterion, or outcome rule may change. In particular, failure to observe B/P6 downstream-only final saturation remains `INCONCLUSIVE`, not permission to strengthen the disturbance.

## Evidence-integrity lesson

Nested source-rewriters with reused here-document delimiters create a class of failures that ordinary source review can miss because the outer shell parses markers before the embedded Python sees them, and replacement functions can accidentally leave both old and new terminators. Future lab harness generation should render generated shell before expensive LinuxCNC setup and validate the rendered artifact, not only the generator source.
