# 4400-RUNNER-BOUNDARY-01 — Local compute is not automatically a safe machine laboratory
**Technician / reviewer field card | 2026-10-28 | SOURCE/DOC-CONFIRMED process boundary; physical state UNKNOWN.**

**Question:** A reviewed LinuxCNC script will run on the OpenPressBrake panel PC using `[self-hosted, openpressbrake]`. Is it safe to press Run?

**No, not on that information alone.** The label identifies a runner, not an independent safety controller or disconnected I/O. A manual checkbox, SHA-256 match and GitHub success status prove neither absence of hazardous motion nor gravity-load holding. See [source/workflow audit](../research/4400_RUNNER_BOUNDARY_01_LOCAL_PANEL_PC_WORKFLOW_ISOLATION_AND_HOSTED_COMPUTE_ELIMINATION_AUDIT_2026-10-28.md).

| Before considering a job | Minimum defensible evidence | If missing |
|---|---|---|
| Engineering purpose | Specific unresolved question, frozen expected observation, reviewed script and version/hash | Do not run for routine smoke/curiosity |
| Compute route | Manual-only workflow and `[self-hosted, openpressbrake]`; **no hosted fallback** | Continue source/documentation work |
| Physical separation | Qualified independent confirmation that script, HAL, FPGA, network and I/O cannot energize machine actuators | **Do not run on a machine-connected PC** |
| People and energy | Selected independent stop/hold/guard/isolation arrangements; no personnel exposure; remote/isolated physical test requires separate approval | **HOLD** |
| Result meaning | Actual raw traces, job runtime, simulator provenance; no inferred machine safety from software exit | Mark NOT TESTED / UNKNOWN |

**Safer-by-default workflow change:** legacy `lab-runner.yml` no longer runs on push, has no default smoke job, targets only the local runner and requires explicit script, reviewed SHA-256 and manual disconnected-simulation attestation. `append-lab-compute.yml` also targets the local runner. **No workflow was dispatched or validated at runtime.** The attestation is a human process guard, not an interlock.

**Do not solve an isolation problem with an E-stop pin.** Normal LinuxCNC/HAL/FPGA outputs are ordinary control. Independent safety-related control must own personnel-protective decisions; physical final elements must actually stop/hold hazardous motion. If the machine cannot meet a basic minimum safe-to-operate threshold, no operation with people exposed.

**Current state:** local runner online/dispatch and physical isolation UNKNOWN; no compute. OpenPressBrake Stage A A–G UNKNOWN; G0/G1 HOLD; independent evaluator OPEN. The frozen G43.2 simulator remains NOT DISPATCHED.

Read next: [G0 evidence request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) and [existing local-runner predecessor inventory](../research/4400_LOCAL_COMPUTE_RUNNER_TRIGGER_GUARD_AUDIT_2026-10-28.md). Do not expand the owner A–G request with a new form.

**Lab token/evidence hardening:** the lab workflow now uses read-only repository permissions and serializes its own runs; it uploads artifacts but no longer commits from the panel PC. A separate reviewed commit is needed to preserve accepted raw evidence beyond artifact retention. This is software privilege reduction, **not** physical isolation; other self-hosted workflows remain separate security surfaces.

**Exact job allowlist:** the manual local lab now accepts only the four directly inspected pure-software fixtures 086–089. Historical 056/079 scripts contain privileged package/build/LinuxCNC operations and are **not** eligible on this panel-PC workflow. To test G43.2 or any other LinuxCNC runtime path, a new reviewed workflow and independent physical isolation proof are required first. This prevents the convenient but dangerous shortcut of dispatching any historical `lab-jobs/*.sh` by merely checking a box.

**Reviewed-content guard:** the four allowlisted job paths now also require exact pinned Git blob identity; a changed script cannot become approved just because someone enters its new SHA-256. This remains software provenance, not a safety-rated interlock or proof of physical isolation.
