# 4400 — GuardLink appended node may be physically present yet absent from the safety function

**Status:** manufacturer-documentary source trace, 2026-10-23 UTC; NOT a selected-machine installation, test, safety validation, or universal GuardLink behavior. Applicable source: Rockwell 432ES-IG3, **publication 432ES-UM001E-EN-P (June 2025)**. Do not transplant this exact topology procedure to 440R-ENETR or other products. Complements the separate series-contact masking and HMI semantic notes.

## High-consequence source discovery

**DOC-CONFIRMED — manufacturer manual Chapter 5, p. 58:** Rockwell warns that when appending a node to the 432ES GuardLink circuit, the installer must interrupt the previous last node's Link In before attaching the additional node/terminator, then restore the connection as instructed. The manual warns that otherwise the appended node **may not activate**, and operating its safety device **may not affect the safety function**, creating an injury risk. The same section requires a risk-assessment verification test after safety-system configuration changes. Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/432es-um001_-en-p.pdf (Chapter 5, *Append a Node*, p. 58).

**DOC-CONFIRMED — manufacturer manual Chapter 5, p. 49:** Rockwell says to verify and validate the safety-function performance for **all GuardLink topology modifications before production mode**. It distinguishes limited online node changes from modifications that require controller offline/configuration download, including changes to node numbering or node tags used in program routines. The fact that hardware may be changed while powered is not permission to operate an unvalidated safety function.

**DOC-CONFIRMED — manufacturer manual Chapter 5, p. 51:** In a documented broken-link/insertion example, `Ch0.Status` transitions 1→0, `Ch0.Fault` and `Ch0.UnverifiedDevice` set, `DeviceTripAddress=-2`, and the `DeviceCount` can temporarily remain at its earlier value. This demonstrates why one count or event code is not a sufficient topology-integrity witness. The exact tag timing is an example, not a universal guarantee.

## Documented online-change capability versus the validation requirement

The same Chapter 5 describes **some** changes to similar nodes/tags as possible with the controller online, and describes cases that require offline edits/download. It also gives the broad instruction to verify and validate the safety function for **all** topology modifications before production. **Do not silently collapse these statements into "hot change is always safe" or "every change must be offline."** They address different dimensions (configuration capability versus safety release). The precise permitted sequence for a selected controller mode, safety-lock state, node tag use and machine exposure remains `UNKNOWN` until the applicable manual and safety plan are reconciled. If the machine is already in hazardous production, do not assume that the online capability waives the separate physical safety-function verification requirement. This is a documentation-interpretation boundary, not a claim that the manufacturer permits personnel exposure during changes.

## The failure path and the physical proposition

| Step | Observable/documentary event | Claim supported | Claim **not** supported |
|---|---|---|---|
| Proposed guard/node addition | Drawing and configuration change record | A new guard is intended to participate | It actually participates in safety function |
| New node physically connected | Installation/inspection | Hardware is present | Node is activated/recognized/safety-valid |
| Existing channel remains operational | Channel status (if observed) | Selected channel reports its documented state | Newly appended guard is necessarily in the active safety chain |
| New guard actuated in a **controlled verification** | Independent recorded input/safety-output response | Specific selected protective demand path may be verified | Complete physical stopping/holding, occupancy, energy isolation |
| Final-element and physical witnesses observed | Machine-specific controlled validation with defined acceptance | The selected `PHY-*` proposition, only to extent measured | Unmeasured modes/faults or future unchanged validity |

**INFERENCE:** An unactivated newly installed protective device can create a **false sense of protection** because it is physically visible yet not participating in the safety-related control path. This is a commissioning and change-control hazard, not just a network troubleshooting issue. A normal LinuxCNC/FPGA/HMI indicator cannot substitute for a validated safety input→safety controller→final element→physical hazard path.

## Adversarial proof-test precondition: an already-active stop can mask an inactive new guard

**INFERENCE / generic logical counterexample, not a Rockwell timing specification.** Suppose a proposed newly added guard A is **not** participating in the safety function, while a different valid guard B is already open and has driven the selected safety output OFF. A technician opens A, observes that the output is OFF, and declares A passed. That is **invalid evidence**: the output was already OFF before A changed. Even closing and reopening A while B stays open cannot establish A's causal protective effect.

| Test situation | Observed safety output | Legitimate conclusion |
|---|---|---|
| B already demands stop; A not yet actuated | OFF | B or another demand may be responsible |
| B still demands stop; A is opened | OFF | **No proof** A participates; output did not distinguish A |
| All other demands controlled to a known nonmasking state in an approved isolated setup; A alone is actuated | Observe the selected input, safety-related output and final-element response | Evidence of A's path **only if** the predeclared causal transition and required physical witness occur |

A proof test must establish **causation**, not mere coexistence of `guard open` and `output OFF`. Its initial conditions, other active demands, diagnostic validity, fault memory and independent physical witnesses must be recorded. If the selected safety system cannot establish an unmasked proof without unacceptable hazard, the test is BLOCKED and the machine must not be released on an assumption. Do not defeat another guard to create a test condition; use an authorized isolated/low-energy commissioning plan.

## Required minimum selected-machine change transaction

1. Record `CHG-*` before modifying the topology: exact original/new node order, catalog and firmware, guard/zone identity, channel, safety-network/controller ownership, wiring/terminator, and routines that use the affected node tags. Preserve old evidence but mark dependent `ARC/DEP/VAL/PT` STALE.
2. Follow the exact manufacturer's current instructions for the **selected** product and revision. Do not infer that a generic hot-swap, auto-discovery, matching device type or stable node count validates the protective function.
3. Verify configuration and **physical** guard-to-node/zone mapping. A swapped same-type device or changed numbering can pass a superficial electronic identity check while protecting the wrong area.
4. With people outside the hazard zone and a properly approved isolated/low-energy or machine-safe validation method, verify that the newly added guard's intended demand actually reaches the selected safety controller/output. Record the actual signal/fault response and any receiver reset/rearm behavior; do not invent times.
5. Separately verify final-element response and the machine-specific physical stop/hold/access proposition. For press brakes include gravity/hydraulic residual-energy boundary; for robot cells include occupancy/restart; for lathes include spindle inertia; for saws include blade inertia.
6. Confirm deliberate rearm and **separate ordinary start**, power restoration, fault-memory, and bypass/service restoration behavior as required by the selected SRS. A diagnostic fault clear is not release authority.
7. Close `CHG-*` and restore production only when all affected `SRS/PHY/VAL/PT` evidence is current and the minimum safe-to-operate threshold is actually established. Otherwise prohibit personnel-exposed hazardous operation; isolated/remote experiments must keep people outside danger zones.

## Practical design improvement

Use a simple printed/onscreen *zone-to-node map* next to the physical guard, keyed to the as-built configuration. Use captive mounting hardware, a clear guard-restoration check and a quick diagnostic display distinguishing **current state**, **first trip event**, **unverified topology**, and **stale data**. This reduces the incentive to defeat an inconvenient guard during troubleshooting. The HMI remains a diagnostic aid, not the independent safety authority.

## Claim ledger and limits

- `DOC-CONFIRMED`: Rockwell 432ES-UM001E p. 49, 51, 58 manufacturer procedures and warnings, for the stated product/revision.
- `INFERENCE`: physical presence of an unactivated node can falsely reassure personnel; require independent physical protective-function validation.
- `UNKNOWN`: selected hardware/firmware, actual node state, as-built wiring, final elements, stopping distance/time, pressure/holding response, required PL/SIL and machine-level safe-state witnesses.
- `TEST-CONFIRMED`: **none**. No GitHub-hosted or self-hosted lab was dispatched. No machine test was performed.

**No bench experiment frozen.** The generic existence and severity of this failure path are explicitly documented by the manufacturer. Only a selected product/application with unresolved verification behavior could justify a bounded isolated test on `[self-hosted, openpressbrake]` or a separately authorized physical commissioning test; no compute merely to repeat the manual.
