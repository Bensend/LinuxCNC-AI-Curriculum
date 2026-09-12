# 3600 Press Brake Checkpoint — Actuator Authority / Extra-Joint Fault Witnesses

Date: 2026-09-12

## Critical path

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains **PREPARED / UNSCORED**. No correctly routed independent result was found in this session. It remains the sole known 2000-series graduation gate. Do not self-score or expose evaluator-forbidden answer/audit material.

## New information gained

### 1. Downstream actuator authority is not PID saturation

`research/press-brake-actuator-unavailable-pid-authority-audit-2026-09-12.md` combines:

- Ursviken field evidence of a mechanically braked R axis continuing to receive PID effort until a DC servo motor overheated;
- official stock-PID semantics;
- pinned `pid.c::calc_pid()` source.

Source-confirmed result: `pid.N.saturated` reports the stock PID block's own `maxoutput` clipping only. It is not a generic witness for a locked brake, disabled amplifier, unavailable hydraulic path, downstream limiter or physical stall.

### 2. LinuxCNC has distinct requested and observed authority surfaces

`research/linuxcnc-joint-amplifier-authority-callflow-2026-09-12.md` traces:

`amp-fault-in -> JOINT_FAULT_FLAG -> check_for_faults() -> enabling=0 -> joint enable cleared -> amp-enable-out=0`

while standard servo HAL connects `joint.N.amp-enable-out` to `pid.enable`. An independent historical in-tree Mazak config separately observes amplifier-running and uses that observed state for Z-brake release. This is evidence for keeping command, physical readiness and fault feedback distinct—not a universal brake-sequencing prescription.

### 3. Homed extra joints lose ordinary MOTMOD following-error supervision

`research/extra-joint-fault-witness-boundary-2026-09-12.md` records the explicit pinned source branch:

`IS_EXTRA_JOINT(joint_num) && get_homed(joint_num) -> joint->ferror = 0`.

Hard-limit and amplifier-fault inputs remain separate, but post-home extra-joint tracking/stall/completion supervision must come from the external planner/controller/drive-feedback architecture. Do not teach `joint.N.f-error` as the post-home X/R/Z tracking monitor.

### 4. Version check

`research/pid-downstream-authority-version-check-2026-09-12.md` now covers both `pid.c` and `motion/control.c`. Their GitHub blob SHAs are identical between pinned revision `8bf4605ae81042248add031e94c77300406e0413` and upstream master as retrieved on 2026-09-12. These specific authority/fault-witness conclusions are therefore current upstream behavior at this checkpoint.

### 5. Tandem-source availability

`research/3600-tandem-source-availability-recheck-2026-09-12.md` rechecked the Ursviken and 2018 hydraulic-press-brake public histories. Intermediate development attachments/configs existed, but no mature final tandem Y1/Y2 configuration exposing correction insertion, final saturation, addf order, per-side ferror and disable/recovery behavior was found. The old forum ZIP attachment URLs are no longer retrievable through the available public path.

Classification remains **COMMUNITY-REPORTED FIELD SUCCESS / FINAL SOURCE UNAVAILABLE** for Ursviken, and **COMMUNITY-REPORTED / DEVELOPMENT SOURCE PARTIAL** for the 2018 project.

## Compute maintenance

The exact PB-PREP-001 073–077 runtime artifact had already recovered an additional **70.427147 min** of historical Actions compute without integrating it into the canonical ledger. This session used the repository's race-safe `LAB_COMPUTE_APPEND_REQUEST.md` path to queue those five exact rows rather than rewriting `LAB_COMPUTE_LOG.md` directly.

Expected integrated arithmetic total, once the append workflow is present on main, is **338.56 min (5.64 h)**; evidence classifications remain unchanged and PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**.

## Information-gain decision

No new synthetic lab was justified. The new questions were source/field-evidence ownership questions, and direct source plus real failure evidence resolved them more strongly than a toy actuator model would.

## Precise next-work checkpoint

1. Re-check the independent F02 handoff result first. PASS/no corrections => graduate F02 and close 2000; never self-certify it.
2. Confirm the queued PB-PREP-001 073–077 compute append reached `LAB_COMPUTE_LOG.md`; if so, use the integrated total rather than the old 268.13-min figure.
3. Keep PB-PREP-001 INCONCLUSIVE and do not retune its frozen discriminator.
4. Keep mature tandem Y1/Y2 and sensor-bending branches at SOURCE UNAVAILABLE unless genuinely new source appears.
5. For backgauge extra joints, carry the explicit post-home fault matrix forward: reference validity, limits, amplifier/drive fault, external episode validity, external tracking/convergence, feedback freshness and at-position are distinct witnesses.
6. Do not invent brake delays, stall thresholds, thermal limits, hydraulic authority timing, safety performance or machine acceptance tolerances.
