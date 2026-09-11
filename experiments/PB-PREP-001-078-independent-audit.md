# PB-PREP-001 — 078 independent retained-artifact audit

Session start UTC: **2026-09-11T08:12:46Z** (automation runtime start; recorded durably after initial repository inspection, before accepting any behavioral verdict).

## Provenance

- Workflow: `34569046910`
- Job: `103167029904`
- Source commit: `928377ad1a7c70af7032e08dc9b5d30e1d22b16d`
- Artifact: `10188937382`, `linuxcnc-lab-078-pb-prep-001-arch-b-retained-render-34569046910-1`
- Artifact digest: `sha256:5df8c73d17fef395ad3efa67810e1c7547e5f9410cc807cd1374405cdde9ac90`
- Job started `2026-09-11T06:13:47Z`, completed `2026-09-11T07:23:57Z`; exact Actions runtime = **70.17 min**.
- Lab wrapper exit code: **124**.

## Independent raw-evidence inspection

The workflow is globally a failure because its execution budget expired. Nevertheless, unlike run 077's incomplete multi-architecture package, the retained architecture-B directory contains a complete `realtime.samples` file with **12,000 rows**, plus controller completion/readiness, topology/provenance, control-event, pin/signal, and overrun witnesses. `overruns-before.txt` and `overruns-after.txt` are both zero. Control events report machine-on/manual/homed/MDI PASS.

The packed state-word phase counts independently parsed from the raw trace are:

| phase | rows |
|---|---:|
| P2 | 2115 |
| P3 | 1553 |
| P4 | 1553 |
| P5 | 2053 |
| P6 | 2052 |
| P7 | 2674 |

Total = 12,000.

Most importantly, independent state-word decoding found **zero stock-PID saturation rows and zero downstream-final-saturation rows in P6**. P6 did exercise nonzero differential correction (`max(abs(corr_applied)) = 0.126316` in the independent parse), so this is not merely a phase-absence artifact.

## Classification

The pre-frozen discriminator was explicit: **if a valid architecture-B P6 trace does not contain downstream final saturation while corresponding stock PID saturation is false, the behavioral comparison is INCONCLUSIVE and P6 must not be strengthened after seeing the result.**

Run 078 therefore supplies useful complete-B evidence, but it already triggers that frozen discriminator. It cannot support an architecture preference. Because A/B/C provenance-matched comparison is not yet complete, Gates A–J remain unscored globally; however, no future C result can retroactively make the required B/P6 downstream-only saturation witness appear in this frozen B trace.

The global workflow timeout occurred after the full B trace was retained. It does not erase the raw B observation, but it does mean 078 is not itself a successful authoritative A/B/C run.

## Decision

**PB-PREP-001 behavioral outcome is now constrained to INCONCLUSIVE under the frozen contract unless the retained B evidence is later shown provenance/recorder invalid. Do not retune P6, gains, thresholds, phase timing, or saturation limits to force the discriminator.**

Architecture C may still be run only if useful for understanding the frozen experiment or validating the harness, but it is no longer necessary to establish that this frozen A/B/C experiment cannot yield a positive comparative verdict.

## Exact next-work checkpoint

1. Reconcile run 078's exact 70.17-minute Actions runtime into `LAB_COMPUTE_LOG.md` without dropping historical rows.
2. Update `PROGRESS.md` to replace the stale “078 active” checkpoint with this independent retained-B classification.
3. Preserve PB-PREP-001 as **INCONCLUSIVE / no architecture recommendation** unless B evidence is invalidated by a concrete provenance/recorder defect.
4. Do **not** strengthen P6 or change frozen thresholds after this result.
5. Continue dependency-safe 4600 source/community research while S02/E20/X01/X02 remain fresh-AI-handoff pending and F02 remains blocked.
