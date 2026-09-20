# 4000 safety checkpoint — safety-input deliberate fault insertion

Date: 2026-09-20

## Completed

Added `safety-course/SAFETY_INPUT_DELIBERATE_FAULT_INSERTION_AND_TEST_SOURCE_SEPARATION_STUDY_2026-09-20.md`.

The Lane-B test-pulse branch now has a real manufacturer-directed installation fault insertion: Pilz PNOZ p1p deliberately shorts S12/S22 and requires an observable fault/fuse response followed by removal and recovery. Rockwell documentation adds the important topology limitation that two safety inputs sharing the same test output can mask a short between those channels.

## Durable freeze

`TWO INPUT WIRES != TWO DIAGNOSTICALLY INDEPENDENT CHANNELS != DIFFERENT TEST SOURCES != REQUIRED CROSS-SHORT COVERAGE PROVED`.

`FAULT REMOVED != SAFETY REQUALIFIED != FRESH ORDINARY START`.

## Compute

No executable lab justified; no GitHub-hosted or self-hosted compute used.

## Exact next work

Make one bounded attempt to find a current manufacturer commissioning/validation fault table covering multiple deliberate field faults and explicit safe-output plus reset/restart disposition. If it adds no material evidence, mark this input-diagnostics sub-branch information-gain limited and rotate to the highest-value open 4000 safety topic. Do not manufacture a lab solely to exercise the local runner.
