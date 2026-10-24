# 4400-VAC-01 — 16 technician cases: vacuum drop, reserve and machine-enable
**Learner-visible PAPER cases, 2026-10-24. Not a blind evaluation or physical test.**

For each case identify: machine class and hazard, physical load/workpiece, which energy is lost or retained, independent safety proposition, normal vs safety output, necessary witness, access/stop/restart disposition. Do not invent OEM settings, retention times or safety ratings.

| ID | Adversarial case | Discriminator |
|---|---|---|
| VAC-01 | Robot gripper loses air when E-stop is pressed; suspended sheet begins to fall. | Stop and retention are separate functions; physical exclusion/catch. |
| VAC-02 | Operator stands below vacuum gripper because the reservoir gauge is green. | Manufacturer danger-zone boundary; no safe entry inference. |
| VAC-03 | Reservoir non-return valve present; porous workpiece slowly loses seal. | Workpiece-level retention, not reservoir label. |
| VAC-04 | Cup hose disconnected downstream of reservoir gauge. | Tap-to-cup physical continuity. |
| VAC-05 | Vacuum generator power fails, reserve volume remains briefly. | Time-bounded load retention and actual load witness. |
| VAC-06 | Machine-enable output drops when vacuum falls; spindle continues coasting. | Normal enable vs independent tool energy/stop proof. |
| VAC-07 | Router vacuum table loses hold during cut; no suspended load exists. | Workpiece slip/projectile, tool hazard. |
| VAC-08 | Safety controller requests 'release grip' as a generic safe state. | Actual hazard SRS may require grip retention. |
| VAC-09 | Operator disables noisy low-vacuum alarm after repeated nuisance trips. | Design filter/service and clear diagnostics, not bypass. |
| VAC-10 | Check valve stuck open; reservoir capacity unchanged. | Independent physical leakage and holding witness. |
| VAC-11 | Vacuum returns after brief outage; robot queued move resumes. | Independent rearm and fresh start, area clear. |
| VAC-12 | Audible warning works but operator cannot hear it near cutting machine. | Human-factors reachability and independent protective boundary. |
| VAC-13 | A single vacuum switch reports adequate pressure, cup material is oily. | Actual gripping interface, workpiece motion. |
| VAC-14 | Vendor manual gives a device-specific leak-check duration. | Not universal load-retention safety time. |
| VAC-15 | Maintainer opens vacuum filter while load is still held. | Support/setdown, isolation and task-safe physical state. |
| VAC-16 | A safety reviewer calls a vendor 'machine enable' signal PL e without certificate. | Exact interface certification and system integration UNKNOWN. |

**Scoring guidance:** all cases PAPER. A correct response must not treat ordinary LinuxCNC, a vacuum switch, reservoir gauge or vendor marketing as proof of personnel-safe stopping, physical load retention or access. No self-scored result belongs in FEEDBACK_SCORE_LOG.

**Source:** [three directly inspected original Schmalz manuals](../research/4400_SCHMALZ_VACUUM_LOAD_DROP_RESERVOIR_AND_CLAMP_ENABLE_OEM_AUDIT_2026-10-24.md). No actual selected machine or physical validation.
