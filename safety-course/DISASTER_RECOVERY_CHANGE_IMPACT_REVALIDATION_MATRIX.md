# Disaster-Recovery Change-Impact / Revalidation Matrix

Date: 2026-09-16
Status: DURABLE INDEPENDENT SAFETY STUDY
Lane: Safety Curriculum B

## Purpose

This matrix answers a narrow recovery question: **after a safety-relevant component, configuration, firmware, wiring, calibration, or recovery artifact changes, which earlier evidence can still support a claim and which affected physical paths must be established again?**

Frozen rule:

> `unchanged file` does not mean `unchanged safety function`, and `changed component` does not automatically invalidate every unrelated proof. Revalidation scope must follow the changed dependency to the claims it can affect.

This is a change-impact method, not a machine-specific commissioning procedure. It does not assign PL/SIL, stopping distance, pressure, proof-test interval, response time, or hydraulic truth-table values.

## Evidence vocabulary

Use these labels literally:

- `SOURCE-CONFIRMED` — directly established from inspectable source/code/artifact.
- `DOC-CONFIRMED` — established by authoritative manufacturer/standards documentation.
- `TEST-CONFIRMED` — established by a controlled test whose real stimulus and observations support the stated claim.
- `COMMUNITY-REPORTED` — practitioner report not independently established here.
- `INFERENCE` — engineering conclusion derived from evidence; assumptions remain visible.
- `UNKNOWN` — evidence is insufficient; do not substitute a convenient value.

## 1. Claim-relative invalidation

For every recovery change, identify the dependency chain rather than declaring the whole machine either `VALID` or `INVALID`:

`changed item -> affected configuration/physical path -> affected safety-function claim -> prior evidence touching that dependency -> correspondence checks -> physical re-challenge where needed -> reset/restart/rearm test -> bounded conclusion`

A prior artifact survives only for the claim it still actually supports.

Examples:

- A retained drawing can remain valid evidence of the intended wiring while becoming insufficient evidence of the wiring that is physically present after repair.
- An unchanged controller safety signature can remain evidence of application identity while saying nothing by itself about a replaced contactor, rewired terminal, changed hydraulic valve, guard alignment, or drive-local safety parameter.
- A previously measured stop result is not automatically transferable across a changed drive, brake, final element, protective-device geometry, load condition, or other dependency that participated in that result.

## 2. Minimum impact decision

For each change ask, in order:

1. **What changed?** Record hardware, firmware, application, parameter, wiring, calibration, mechanical arrangement, hydraulic/pneumatic arrangement, or recovery artifact identity.
2. **What can that item influence?** Trace both safety logic and the physical hazardous-energy path.
3. **Which retained evidence depends on it?** Do not invalidate unrelated evidence merely because it is old.
4. **Can correspondence be established without hazardous operation?** Identity, version, terminal, continuity, parameter and drawing checks may close some claims.
5. **Which claims require a real physical challenge?** Any claim about actual protective-device detection, final-element action, energy removal/control, feedback, stopping/holding, or restart behavior must be supported by an observation that reaches that physical path.
6. **What remains UNKNOWN?** Physical facts not observed after the change stay `UNKNOWN`.

## 3. Change-impact / revalidation matrix

| Recovery/change event | Prior evidence that may remain usable | Evidence automatically suspect/invalid for affected claim | Required correspondence checks | Physical re-challenge scope | Reset/restart/rearm scope | If not established |
|---|---|---|---|---|---|---|
| Controller replacement, same intended application/runtime family | Hazard analysis; requirements; drawings not dependent on controller identity; historical test method | Controller identity, runtime identity, download/restore identity, any proof assuming the old controller is still installed | machine/controller identity; hardware catalog/revision as applicable; firmware; application/signature; safety-network/device ownership | affected safety inputs/outputs and final-element paths whose authority passes through replacement controller | demand-clear-reset-rearm and power-cycle/recovery behavior affected by controller replacement | `UNKNOWN` for restored physical safety-function correspondence |
| Controller firmware/compiler revision change | Hazard boundaries; physical device inventory; unaffected wiring evidence | prior runtime-equivalence assumption; preserved-signature claim if platform says signature is removed/not preservable; tests dependent on changed runtime behavior | manufacturer compatibility/release/change guidance; firmware/compiler/project identity; signature state | functions identified by change-impact analysis; do not assume compile/download success proves behavior | affected fault persistence, reset, restart and rearm paths | `UNKNOWN` until documented impact is resolved and affected functions tested |
| Safety-I/O module/device replacement | Requirements; upstream logic evidence not dependent on replaced device; wiring drawing as intended design | device identity/configuration, actual channel correspondence, tests proving old device's physical I/O path | exact device identity/keying; node/IP; safety-network identity; configuration signature/parameters; terminal correspondence | every affected input/output channel through the real sensor/final element as applicable | faults/discrepancy/reset behavior involving replaced channels | `UNKNOWN` for replaced-channel operation |
| Protective-device replacement (guard switch, light curtain, scanner, etc.) | Hazard definition; intended safety logic if unchanged; unrelated final-element evidence | sensing geometry/alignment, device configuration, channel wiring, detection behavior, old device-specific validation | exact model/configuration; mounting/alignment; field wiring; device-local parameters; muting/blanking/restart settings if applicable | real protective-device demand through affected safety path to required final elements, with appropriate independent observations | demand clearance must not itself create hazardous restart; manual reset/rearm behavior as designed | `UNKNOWN`; do not infer protection from an HMI icon alone |
| Field-wiring repair/terminal replacement | Requirements; software identity; drawings as intended design | actual conductor/terminal correspondence and any test relying on the repaired path | wire/terminal IDs; continuity/inspection where appropriate; polarity/channel separation; feedback correspondence | repaired signal path and the safety function(s) that depend on it | affected diagnostic/fault-clear/reset behavior | `UNKNOWN` for repaired physical path |
| Restore from backup/memory image | Hazard analysis and design documentation if baseline correspondence is known | current-machine suitability of the artifact; runtime/device-local state not proven by restore success | artifact provenance/baseline; machine identity; application signature/hash; controller/firmware; distributed-device identity; device-local configs | all functions invalidated by baseline gap or changed hardware/configuration since that backup | recovery startup, fault persistence, reset/rearm and absence of restored forces/bypasses | `UNKNOWN` until current physical machine is rebound to the validated baseline |
| Safety-related calibration/teach data lost or re-established | Hazard requirements; logic independent of calibration; unrelated safety tests | any proof whose acceptance depends on lost position/zone/timing/tool/device calibration | authoritative calibration procedure; equipment identity; calibration/teach artifact identity; configuration binding | affected position/zone/protective function using the newly established calibration | relevant reset/rearm and boundary-transition behavior | `UNKNOWN`; never reconstruct missing values by guess |
| Drive replacement / drive safety firmware or safe-motion parameters changed | Hazard analysis; upstream demand logic; unrelated safeguards | drive-local safety parameter identity, STO/safe-motion response of old drive, feedback tied to old drive | drive model/firmware; safety parameter set/signature where available; wiring; STO/safety inputs; encoder/feedback dependencies | every safety function that relies on changed drive-local safe behavior, through actual drive/final motion path | power-cycle, fault-clear, reset/rearm, unexpected-start prevention | `UNKNOWN` for drive-dependent safety behavior |
| Contactor/relay/final electrical isolating element replacement | Upstream safety-demand logic; hazard definition | old final-element actuation/feedback proof; EDM correspondence | device identity/rating per design; coil/contact wiring; mechanically linked/feedback contact correspondence as applicable | actual demand causing final element to change state plus independent observation appropriate to the claim | welded/stuck/fault detection and reset prohibition/recovery behavior where designed | `UNKNOWN`; output bit state is not physical contact proof |
| Hydraulic/pneumatic final element replaced or plumbing repaired | Upstream logic and electrical command evidence; hazard definition | prior proof of physical fluid-power response through changed element/path | exact component/drawing correspondence; port/plumbing identity; feedback/sensor mapping; manufacturer procedure | affected safety function through real fluid-power path under a controlled safe test boundary | relevant fault/reset/rearm path | `UNKNOWN`; no valve truth table, pressure state, or holding behavior may be invented |
| Guard/mechanical restraint/interlock actuator mounting changed | Logic identity; unrelated electrical final-element evidence | geometry/alignment/actuation and defeat-resistance proof tied to old mounting | physical mounting; fasteners; actuator/target alignment; drawings/instructions | real guard/restraint demand and affected hazardous-motion path | opening/closing must not silently authorize hazardous restart; reset/rearm as designed | `UNKNOWN` for mechanical correspondence |
| Safety-network topology/address/SNN change | Hazard analysis; device requirements | old connection/device identity assumptions; safety-I/O correspondence affected by identity change | topology; node/IP; SNN/device identity; ownership; signatures/configuration | affected distributed safety I/O paths after identity/configuration is re-established | network fault recovery and rearm behavior | `UNKNOWN` for affected networked safety paths |
| Ordinary LinuxCNC/HAL/FPGA/HMI update only, independent safety authority physically unchanged | Independent safety-system validation may remain usable if no dependency crosses into it | ordinary-control functional evidence and any safety claim that actually depended on changed normal-control interface | prove architectural boundary really remained independent; compare normal request/diagnostic interface; verify no safety configuration changed | safety re-challenge only where the update can influence a safety demand, reset, mode, restart, shared sensor/final element, or physical hazard exposure | ordinary rearm plus any affected safety reset/restart interface | `UNKNOWN` if independence cannot be demonstrated |

## 4. Authoritative product evidence — GuardLogix example

`DOC-CONFIRMED`: Rockwell Automation states that after download/restore, application testing is required unless a safety signature exists; verifying that the intended application was downloaded/restored requires manually comparing the safety signature to the original safety documentation. If a mismatch requires unlocking/downloading, the safety signature is deleted and the application must be revalidated.

`DOC-CONFIRMED`: Rockwell states that a safety-I/O replacement must be configured correctly and its operation user-verified. Current GuardLogix documentation says a replacement safety-I/O device is identified/configured using attributes including node/IP address and Safety Network Number, and that following replacement proper operation must be validated before using the affected safety functions.

`DOC-CONFIRMED`: Rockwell states that a safety-I/O device configuration signature uniquely identifies the device configuration. That is configuration evidence, not proof of arbitrary field wiring or physical final-element behavior.

Transferable `INFERENCE`: recovery scope should preserve separate claims for application identity, device identity/configuration, field correspondence, and physical functional validation. Product-specific GuardLogix mechanisms must not be copied as universal requirements for unrelated safety platforms.

## 5. Maintenance/energy-control boundary

`DOC-CONFIRMED`: OSHA 29 CFR 1910.147 requires hazardous stored/residual energy to be relieved, disconnected, restrained, or otherwise rendered safe and requires verification that isolation/deenergization has been accomplished before servicing. Before release from lockout/tagout, the work area must be inspected and machine/equipment components must be operationally intact.

`DOC-CONFIRMED`: OSHA also requires lockout-capable energy-isolating devices when replacement or major repair, renovation, or modification of covered machines/equipment is performed under the cited condition.

Transferable `INFERENCE`: a recovery/replacement activity can create two distinct validation questions: **is the machine safe to service now?** and **has the affected operational safety function been restored for production?** One does not prove the other.

## 6. Evidence survival rules

### Evidence can survive when

- its claim does not depend on the changed item;
- its configuration identity still corresponds to the current machine;
- no affected physical dependency was altered;
- the retained raw artifact and provenance remain trustworthy;
- applicable manufacturer guidance does not explicitly require regeneration/revalidation.

### Evidence must be narrowed or invalidated when

- a changed component participated in the measured behavior;
- field correspondence can no longer be established;
- a safety signature/configuration identity was deleted, changed, or belongs to another baseline;
- device-local parameters, calibration, geometry, wiring, network identity, final elements, or feedback paths changed;
- an earlier test did not stimulate the newly changed physical path;
- current observations conflict with the historical baseline.

Never average old and new evidence to make a conflict disappear. A contradiction is a fault/investigation trigger.

## 7. Minimum recovery record

For each change retain:

- change ID/date and reason;
- machine identity and before/after baseline identities;
- changed hardware/firmware/software/wiring/calibration/mechanical/fluid-power items;
- affected safety functions and hazardous-energy boundaries;
- prior evidence explicitly retained, narrowed, or invalidated, with reason;
- correspondence checks and raw observations;
- actual physical challenge(s) performed and independent witness(es);
- fault/reset/restart/rearm result;
- temporary tools/forces/jumpers/bypasses restoration evidence;
- unresolved `UNKNOWN`s and operating restrictions;
- authorization/release evidence required by the selected organization/system.

## 8. OpenPressBrake / LinuxCNC authority boundary

Ordinary LinuxCNC, HAL, normal FPGA logic, and HMI may help inventory versions, display diagnostic mismatch, inhibit ordinary motion requests, log recovery status, and require an ordinary-control rearm.

They do not become personnel-safety authority by declaring a recovery record complete. The safety claim remains tied to the independent safety architecture and the physical sensors/final elements that control the hazard.

Therefore prefer wording such as `configuration correspondence incomplete` or `ordinary motion inhibited pending validation`, not `machine safe`, when the software only knows configuration/diagnostic state.

## 9. Compute decision

No simulation, synthesis, benchmark, or executable verification is justified for this artifact. The open questions are change provenance, dependency tracing, physical correspondence, and bounded revalidation scope. No GitHub-hosted or self-hosted compute was consumed.

## 10. Sources

Authoritative sources consulted:

- Rockwell Automation, GuardLogix 5580 / Compact GuardLogix 5580, `Download/Upload a Safety Application Program`: https://www.rockwellautomation.com/en-no/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-applications/download-upload-a-safety-application-program.html
- Rockwell Automation, `Safety I/O Replacement Options`: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-replacement-options.html
- Rockwell Automation, `Safety I/O Device Replacement`: https://www.rockwellautomation.com/en-ca/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-i-o/safety-i-o-device-replacement.html
- Rockwell Automation, `Safety I/O Device Signature`: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-device-signature.html
- OSHA, 29 CFR 1910.147, `The control of hazardous energy (lockout/tagout)`: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147
- OSHA, Machine Guarding eTool, `Additional Safety Considerations`: https://www.osha.gov/etools/machine-guarding/introduction/safety-considerations

## 11. Precise next independent work

If the primary safety lane remains focused on professional OEM safety wiring / electrical-fluid energy-boundary tracing, Lane B should next build a **safety-relevant replacement-parts equivalence / substitution worksheet**.

It should distinguish exact replacement, manufacturer-approved successor, functionally similar part, and undocumented substitute; trace safety-related ratings/configuration/diagnostics/feedback/mechanical/fluid-power dependencies; and define what correspondence and revalidation evidence is required before an alternate part can inherit any prior safety claim.

Do not create a generic purchasing whitelist, claim that matching voltage/current means safety equivalence, or invent machine-specific performance.