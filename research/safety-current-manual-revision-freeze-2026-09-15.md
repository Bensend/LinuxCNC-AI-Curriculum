# Safety Relay Current-Manual Revision Freeze — 2026-09-15

Session start: **2026-09-15T15:36:51Z**.

## Purpose

Close a revision-control weakness in the safety-relay research before numeric timing/rating claims are promoted into teaching material.

## Pilz PNOZ s4

**DOC-CONFIRMED:** Pilz's current product/document index exposes **Operating Manual PNOZ s4 (21396-23)**, dated **2026-06-22**, 2.3 MB. Older indexed revisions include 21396-22 (2025-05-07), 21396-21 (2023-05-22), 21396-20 (2022-11-24), 21396-18 (2022-02-25), 21396-17 (2020-12-10), 21396-16 (2018-01-16), and 21396-14 (2015-11-09).

Behavioral concepts already source-traced from older exact manuals — monitored manual start/restart, optional external-device feedback, S34 reset semantics, OUT/Y32 indication, and unexpected-restart warning for automatic/bridged start — remain useful as historical evidence. **Numeric timing, ratings, PL/SIL restrictions and wiring-sensitive claims are not frozen against revision 23 until the actual revision-23 tables are extracted.**

## Pilz PNOZ X3

**DOC-CONFIRMED:** Pilz's current product/document index exposes **Operating Manual PNOZ X3 (20547-17)**, dated **2026-04-29**, 1.7 MB. The index also exposes 20547-16 (2025-08-28), 20547-12 (2020-12-22) and 20547-10 (2017-11-22).

The existence and current revision are now frozen. **Response/recovery times, channel/cross-short behavior, output ratings/fusing, PL/SIL restrictions and exact model wiring remain OPEN** until extracted from 20547-17 itself. Do not substitute reseller summaries or transpose values from another PNOZ X3 variant.

## Curriculum rule

For safety devices, distinguish three evidence layers:

1. **stable concept evidence** — useful older exact manuals may establish enduring semantics;
2. **current revision evidence** — current manufacturer's exact manual must support revision-sensitive numeric/rating/wiring claims;
3. **application evidence** — machine wiring, risk assessment, calculations and validation are still required before claiming achieved Category/PL/SIL or safe stopping performance.

A current manual does not validate a machine, and an inspectable LinuxCNC configuration does not prove cabinet safety wiring.

## Source

Pilz official product/document indexes, inspected 2026-09-15. Current indexed manuals: PNOZ s4 21396-23 (2026-06-22); PNOZ X3 20547-17 (2026-04-29).
