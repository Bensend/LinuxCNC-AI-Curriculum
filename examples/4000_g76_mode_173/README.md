# 4000-LC-LATHE-173 — four review-only RS274 G76 mode-transition controls

**NOT RUN. NOT FOR A CONNECTED MACHINE.** These are proposed inputs to the offline `rs274` interpreter. They intentionally generate a threading canonical trajectory, so do not load them into a live LinuxCNC GUI or lathe.

A: `g8_separate.ngc` G8 radius before G76. B: `g7_separate.ngc` G7 diameter before G76. C: `g7_same_block.ngc` G7 and G76 same line. D: `g8_same_block.ngc` G8 and G76 same line.

All cases are intended to represent radial X=10 mm, I=-1 mm, J=0.2 mm, K=1 mm after exactly one G7 diameter conversion. Predicted original canonical first-feed X: A=8.8, B=8.8, C=9.4, D=7.6. These are not measured. See [research](../../research/4400_LINUXCNC_LATHE_173_G76_G7_G8_SAME_BLOCK_DOUBLE_SCALING_SOURCE_AUDIT_2026-11-02.md) and [guide](../../guides/3200-4000-linuxcnc-g76-g7-g8-same-block-reproduction-2026-11-02.md).