# CYCLE-174 — six review-only canonical termination-mode fixtures

All programs are **disconnected interpreter-only** examples, not approved machine programs. Pinned source: stable `v2.9.10` and development `67437d8865e431a9a33f74cee912dbf891d3b4c5`. Do not load on hardware.

A: G61.1 then valid G81; B: G64 P0.1 then valid G81; C: G61 then valid G81; D: G61.1 then G82 missing P with Z5 above R2; E: same missing-P error with Z0 below R2; F: G61.1 then valid G82 P0.1. Compare canonical mode and traverse/feed lines with [guide](../../guides/3100-3400-4000-linuxcnc-canned-cycle-exact-stop-error-commissioning-2026-11-02.md). No expected file is marked TEST-CONFIRMED.

Source predictions: A/F STOP→EXACT→STOP, B BLEND→EXACT→BLEND, C remains EXACT, D/E fail before restore; E emits preliminary canonical R traverse before parameter validation, **not proof of physical motion**. Record `rs274 -g` outputs and exit codes before asserting any result.
