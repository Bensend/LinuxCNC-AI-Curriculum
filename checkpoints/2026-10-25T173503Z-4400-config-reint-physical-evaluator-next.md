# 4400 safety continuation — signed safety config, replacement and short-dip reintegration
**Session UTC start:** `2026-10-25T17:35:03.913Z`, captured before substantive research and durably committed in [start marker](2026-10-25T173503Z-session-start-safety.md). This checkpoint supersedes [16:38Z PULSE/OUT checkpoint](2026-10-25T163828Z-4400-pulse-out-physical-next.md) **for work selection**, not historical evidence.

## Governance and state
Read START_HERE first; MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, evaluation/BLIND_FEEDBACK_PROTOCOL, FEEDBACK_SCORE_LOG, LAB_COMPUTE_LOG, latest safety checkpoint, safety index, IO module, selected-machine G0 intake and cumulative design package. **1000/2000/F02/3000 GRADUATED/CLOSED**. Primary priority **4400 safety**; routine board development separate. 2520–25F0 external information-separated evaluation OPEN; no sealed answers or self-score. OpenPressBrake **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD**; physical Y1/Y2 stop/hold/guard/hydraulic isolation/fresh rearm UNKNOWN.

## Eight original artifacts (independently fetched first seven; final review to verify)
1. [Rockwell/Siemens safety signature, version and 2012 download audit](../research/4400_ROCKWELL_SIEMENS_SAFETY_SIGNATURE_SCOPE_ONLINE_OFFLINE_REDOWNLOAD_AUDIT_2026-10-25.md).
2. [Rockwell safety I/O SNN, replacement and electronic-keying audit](../research/4400_ROCKWELL_SAFETY_IO_AUTO_REPLACEMENT_SNN_AND_FUNCTIONAL_RETEST_AUDIT_2026-10-25.md).
3. [CONFIG-01 learner module](../safety-course/4400_CONFIG_01_SIGNATURE_SCOPE_CHANGE_CONTROL_AND_FRESH_REARM_MODULE_2026-10-25.md).
4. [16 unscored PAPER CONFIG cases](../safety-course/4400_CONFIG_01_SIXTEEN_SIGNATURE_REPLACEMENT_TECHNICIAN_CASES_2026-10-25.md).
5. [12-gate NOT RUN CONFIG G0 documentary review](../safety-course/4400_CONFIG_01_TWELVE_GATE_NO_ENERGY_CHANGE_RELEASE_REVIEW_2026-10-25.md).
6. [Siemens V20/V21 F-I/O short-supply-dip S012 audit](../research/4400_SIEMENS_V20_FIO_SHORT_POWER_LOSS_AUTO_REINTEGRATION_VS_COMM_FAULT_ACK_AUDIT_2026-10-25.md).
7. [12 unscored PAPER REINT cases](../safety-course/4400_REINT_01_TWELVE_POWER_DIP_COMM_FAULT_AND_FRESH_START_PAPER_CASES_2026-10-25.md).
8. [Seven-gate adversarial signed/connected/ACK/READY review](../safety-course/4400_CONFIG_REINT_CROSS_LAYER_ADVERSARIAL_RELEASE_REVIEW_2026-10-25.md).

## High-information original OEM conclusions
- **DOC-CONFIRMED** Rockwell GuardLogix 5580 safety signature covers safety portion **not standard application**. Logix Designer v36+ can change certain IP/slot settings without changing safety signature; EtherNet/IP mode change may require deleting and regenerating signature with same value. Do not treat matching signature as deployment or physical identity proof.
- **DOC-CONFIRMED** Siemens V20 requires confirming correct target F-CPU, comparing online/offline collective F-signature against accepted summary and checking F-block version/status.
- **DOC-CONFIRMED 2012 product scope only** GuardLogix Table 34: matching safety signature on unlocked legacy controllers can allow standard-only download and safety tag reinitialization; not generalized to 5580.
- **DOC-CONFIRMED** Rockwell 5580 auto I/O replacement depends on SNN/DeviceID, keying, module configuration signature and selected policy. OEM explicitly prohibits relying on affected device during replacement/functional test and requires prescribed functional retest.
- **DOC-CONFIRMED** Siemens V20 and V21 S012: short F-I/O supply loss below configured monitoring time can cause **automatic reintegration despite manual ACK_NEC setting**; detected communication fault follows different passivation/acknowledgment path. No monitoring time invented.
- **INFERENCE:** signed, network-connected, fault-free and manually acknowledged are **separate** from physical Y1/Y2 stop/hold/guarding and **fresh ordinary motion command**. **UNKNOWN:** actual selected controller, wiring, hydraulic behavior, PL/SIL, stopping distance, pressure and evaluator. **SOURCE-CONFIRMED new LinuxCNC source:** none; **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none relied on.

## Integration and compute
CURRICULUM, PROGRESS, SAFETY_COURSE_RESEARCH, safety-course index, selected-machine conditional **IN-03e/f, IN-05f, IN-09d, IN-10e/f**, and Safety Design Package **§§11FC–11FE** updated. 28 PAPER scenarios UNSCORED; 12 documentary + seven adversarial gates NOT RUN. No simulation, build, synthesis, benchmark, physical test or GitHub Actions dispatch; **0 hosted minutes, 0 self-hosted lab minutes, no new authoritative job runtime**. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Previously reported local runner-access blocker not retested because no compute justified; **no hosted fallback**. No personnel-exposed operation authorized.

## Exact next work
1. **Highest priority qualified restricted G0 evidence:** actual OpenPressBrake as-built machine/controller ID, safety project/firmware/signature, I/O configuration and approved replacement policy, guards, E-stop, foot/reset, independent Y1/Y2 final elements and gravity hold, hydraulic pressure isolation, service restraint, rescue, occupancy, power-return/fresh-start. Obtain qualified review status **without publishing proprietary drawings**. G0 documentary HOLD until complete; G1 isolated-test permission and G2 physical validation separate; G3/G4 not authorized.
2. **Information-separated external evaluation:** obtain genuine evaluator results for 2520–25F0 and prepared 4400 transfer; do not self-score public scenarios or inspect sealed answers.
3. **If A/B remain blocked:** rotate to a **distinct** original-OEM safety failure-path question. First check existing index to avoid redundant 4400 material. Candidate: exact manufacturer **safety-network connection timeout vs final output state and restart** on another device family, if an unexamined failure distinction exists. Avoid synthetic labs. Keep ordinary LinuxCNC/FPGA out of personnel-safety authority.
4. **Compute rule:** only for a frozen question not answerable from standards/OEM/source, and only local runner labeled `[self-hosted, openpressbrake]` if dispatchable; otherwise source/doc work and record blocker. Never use hosted runners.

## Study-process note
This session used two high-information source counterexamples rather than expanding generic checklists: a safety signature can remain unchanged when deployment/standard logic changes; an F-I/O module can reintegrate without the anticipated manual channel acknowledgment after a short supply dip. A combined PAPER adversarial review tests whether a fresh engineer still distinguishes **identity, configuration, diagnostics, physical energy and fresh start**. No independent learner evaluation or physical test is claimed.
