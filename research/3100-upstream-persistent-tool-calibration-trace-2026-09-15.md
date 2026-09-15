# 3100 — upstream persistent tool calibration trace — 2026-09-15

## Scope

Follow-up to the real SebastianMusser toolsetter audit. Inspected upstream LinuxCNC `nc_files/remap-subroutines/qt_auto_probe_tool.ngc` at pinned revision `6c207a9f01dfbab656ab25a0b47995802b6e1f38` to establish a persistent tool-table calibration/reference workflow and contrast it with the real machine's WCO-writing macro.

## Source-grounded flow

The upstream remap explicitly supports machines without repeatable holders and performs:

`capture selected/current tool + start coordinates -> interpreter/unit/search-velocity/return-option checks -> G53 toolchange position -> G49 -> builtin M6 -> probe-enable/probe-velocity checks -> G53 safe/toolsetter approach -> fast G38.2 -> backoff -> #5070 check -> slow G38.2 -> second #5070 check -> calculate offset from touch result / calibrated probeheight / blockheight -> G10 L1 tool-table write -> G43 -> return tool tip to original local position`.

SOURCE-CONFIRMED distinctions:

- Both coarse and fine probe attempts have explicit `#5070` checks.
- `G10 L1 P#<tool>` updates the tool-table Z offset; the source comments explicitly distinguish this from `G10 L2` coordinate-system writes.
- `G43` is applied only after the new tool-table value is written.
- Probeheight and blockheight are separate calibration/reference quantities. The workflow depends on prior establishment of those values.
- The remap checks interpreter context, unit consistency, search velocity, return-option validity, tool-probe enable and fine-probe velocity before the relevant operations.

## Important remaining boundary

Despite stronger software checks, the inspected NGC does not itself test a dedicated 'toolsetter initially clear/not stuck' HAL witness before beginning the first G38.2. Native G38.2 has its own probe-state semantics, but a production architecture should still distinguish electrical health/source identity from the mere existence of a probe result where multiple devices share `motion.probe-input`.

## Comparison with real machine macro

| Concern | SebastianMusser real config | upstream qt_auto_probe_tool |
|---|---|---|
| double touch | yes when slow feed enabled | yes |
| explicit #5070 after first touch | yes | yes |
| explicit #5070 after fine touch | no separate macro branch | yes |
| result authority | #5063 + setter height | #5063 + probeheight + blockheight |
| persistent tool table | no | yes, G10 L1 |
| current WCO write | yes, G10 L2 | no |
| apply compensation | macro cancels G49; purpose is WCO zeroing | G43 after G10 L1 |
| initial sensor-source health | not explicit | not explicit in this NGC |

## Curriculum rule

Teach three separate tool-setting products:

1. **workpiece/WCO touch-off** — changes coordinate-system relationship;
2. **persistent tool-length calibration** — changes tool-table geometry and then applies compensation;
3. **measurement validity/electrical health** — proves the measurement path is trustworthy enough to authorize either write.

A double-touch sequence alone does not establish which product is being produced.

## Adversarial review

- If `#5070` is true, is the tool table necessarily changed? **No; that depends on subsequent G10 authority.**
- Does G10 L1 immediately imply G43 is active? **No; the remap explicitly executes G43 afterward.**
- Can a WCO-setting macro and tool-table-setting macro both use the same G38.2 touch mechanics? **Yes.**
- Does prior toolsetter calibration become unnecessary because the touch is repeatable? **No; the offset formula depends on calibrated reference quantities.**
- Does software probing make the setter safety-rated? **No.**

5/5 pass.

## Lab decision

No lab: the source directly resolves the G10 L1/G43 sequencing and dual-#5070 question. The remaining initial-state/source-health issue is configuration-specific and should be tested only when a real implementation claims that authority.
