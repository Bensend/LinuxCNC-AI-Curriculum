# 4400 — ENETR GuardLink diagnostic tag semantics, version drift and conflicting examples

**Status:** manufacturer-document source audit; not selected firmware verification or a safety-function validation. Investigated 2026-10-23 UTC. This is a follow-on to `4400_GUARDLINK_RESET_FAULT_RECOVERY_AND_SAFETY_AUTHORITY_2026-10-23.md`.

## Why this matters

An operator HMI can make a safety problem worse by displaying the wrong door, treating a first-event address as a complete state list, interpreting a bitmask as a count, or concealing a fault behind a single green 'healthy' light. These are ordinary diagnostic-system correctness failures; they do not grant the HMI personnel-safety authority. The safest low-cost design still needs a trustworthy, clearly qualified diagnostic display and independent safety-related final elements.

## Directly inspected current manufacturer document

Rockwell Automation **440R-UM009E-EN-P, February 2026**, official PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um009_-en-p.pdf . Table 5 p. 43 (rendered original) and Table 6 p. 44. Covers **440R-ENETR Series B**. `DOC-CONFIRMED` for the quoted table definitions; actual firmware interpretation is `UNKNOWN` without selected runtime.

| Tag | Documented meaning | What the display must NOT assume |
|---|---|---|
| `Active` | Whether GuardLink input mode is active; when false, remaining GuardLink tags zero | All-zero fields when inactive are **not** proof every guard is closed or healthy. |
| `Trip` | GuardLink chain Operational vs tripped | Does not say which gate or whether physical machine stopped. |
| `DiagnosticActive` | One or more taps in diagnostic state | Does not identify all devices. |
| `DeviceTrip` | DINT with **1 = operational node, 0 = tripped node** for configured node bits | Not a count and not the same as 432ES `DeviceTripAddress` first-event field. |
| `DeviceCount` | Despite name, examples use `15` for four nodes (binary `1111`) | Not a plain integer count of four. |
| `DeviceDiagnostic` | 2026 text says only one device indicated, not multiple | Not a complete multi-device diagnostic set. |
| `DeviceFault` | DINT for faulted nodes | Exact node-to-bit mapping conflicts with the manual's numeric example (below); **do not hard-code without verification**. |

### Arithmetic check of unambiguous `DeviceTrip` examples

Manufacturer Table 5 states four operational nodes give `DeviceCount=15` (`0b1111`) and `DeviceTrip=15`. Nodes **1 and 3** tripped give `DeviceTrip=10` (`0b1010`), so `DeviceCount XOR DeviceTrip = 5` (`0b0101`), bits 0 and 2. Node **2** tripped gives `DeviceTrip=13` (`0b1101`), XOR `2` (`0b0010`). This supports the stated **zero bits = tripped nodes** for those examples. It does **not** prove that a tripped node is faulted or that every diagnostic code is mapped by XOR.

### Conflicts and unresolved manufacturer ambiguities — DO NOT SILENTLY CORRECT

**Conflict C1 — `DeviceFault=6` example:** The same 2026 Table 5 says for four nodes value `6` means **nodes 1 and 4** faulted. Under the `DeviceTrip` example's least-significant-bit = node 1 mapping, `6 = 0b0110` would instead select nodes 2 and 3. This is an apparent internal inconsistency or a different undocumented bit mapping. **UNKNOWN** which interpretation the actual selected firmware uses. Do not publish an authoritative `DeviceFault` node map until resolved from manufacturer clarification or selected-interface runtime evidence.

**Conflict C2 — `DeviceDiagnostic` representation across editions:** A publicly available 2019 copy of Rockwell **440R-UM009C-EN-P, July 2019** describes `DeviceDiagnostic` as indicating **one or more taps** with active diagnostics (bitmask). The directly inspected **2026 440R-UM009E** p. 43 says it indicates **one device only** and recommends XOR `DeviceTrip` with `DeviceCount` to find all devices in diagnostic mode. This may reflect a real firmware/AOP behavior change or a documentation change; the cause is **UNKNOWN**. Moreover, XOR identifies tripped nodes in the shown examples; equating every trip with a diagnostic fault needs separate evidence. The older copy was not directly fetched from the current official Rockwell URL; treat the cross-edition contrast as **COMMUNITY/MIRROR-REPORTED pending official archived edition**. Current 2026 text itself is `DOC-CONFIRMED`.

**Conflict C3 — reset-duration units:** 2026 Table 6 p. 44, diagnostic code 03, says reset input held ON and prints `250...3000 s`, whereas 2026 Table 2 p. 39 specifies a **0.25–3 s** reset command. This appears to be a units typo in Table 6, but do **not** silently rewrite manufacturer text or infer safety behavior from the inconsistent unit. Use the selected product reset instructions and seek clarification if it affects configuration. No seconds-versus-milliseconds safety timing claim is accepted here.

**Conflict C4 — discrepancy durations:** 2026 Table 6 p. 44 lists diagnostic code 09 as input-channel discrepancy `>30 ms`. Rockwell GLINK-AT001A p. 5 describes OSSD-tap recoverable discrepancy after `>=3 s` and EMSS-tap 10 s simultaneity. These may concern different diagnostic layers/firmware/fault types; **UNKNOWN** exact relationship. Do not choose one value as a universal trip or stopping criterion.

## 432ES versus ENETR field-name trap

The separately researched **432ES-IG3** interface's `DeviceTripAddress` identifies the first device causing an operational-to-safe transition and need not update for subsequent trips. **440R-ENETR** instead documents a `DeviceTrip` bitmask of operational/tripped nodes. They are not interchangeable fields, despite similar names. A single first-event address cannot serve as a live all-open-doors list; a bitmask cannot be interpreted as a first-event address. Product/firmware identity must accompany any HMI decoder.

## Practical HMI design that does not invent safety authority

1. Label fields by exact product, firmware/AOP, diagnostic source and timestamp; display `UNKNOWN` when link inactive, stale, disconnected or tag semantics unverified.
2. Distinguish **tripped**, **diagnostic**, **faulted**, **guard locked**, **guard closed**, **relay output**, and **physical safe-state witness** as separate states. Do not reduce to one green/red boolean.
3. For `DeviceTrip`, decode only the documented current-version examples and keep the full raw DINT alongside a human-readable result. For `DeviceFault`, do not claim specific node numbers while C1 is unresolved.
4. Preserve raw tag transitions around reset/power cycling and record whether node count/topology/AOP changed. Do not let an automatic 'Reset all' command erase fault provenance or authorize motion.
5. Show a maintenance/inspection path that is easier than bypassing the guard. Correct recurring false alarms at the root; do not suppress them with an arbitrary debounce that can conceal a protective demand.
6. Safety-related decision logic, final elements and physical stopping/holding/occupancy proof remain outside the ordinary HMI/FPGA/LinuxCNC authority.

## Decision on tests

No GitHub Actions lab justified for arithmetic or manufacturer-document interpretation. A **selected-interface bench observation** becomes justified only if an actual selected ENETR firmware/AOP integration needs `DeviceFault`/`DeviceDiagnostic` decoding and manufacturer clarification cannot resolve C1/C2/C4. Freeze the exact question, predeclare input states, record raw tag words and firmware, and use only `[self-hosted, openpressbrake]`. Do not expose people to hazards or use the bench result as machine-level safety validation.

## Evidence labels

- `DOC-CONFIRMED`: 2026 manufacturer Table 5 tag text/examples, Table 2 reset command, Table 6 diagnostic code text; 2023 GLINK-AT001A tap family definitions.
- `COMMUNITY-REPORTED`: 2019 manual copy's different `DeviceDiagnostic` description; 2023 PLC community reports of unavailable guard-open-vs-unlocked auxiliary data (https://www.reddit.com/r/PLC/comments/14xpvsx/). Neither establishes installed runtime truth.
- `INFERENCE`: numerical bitmask consistency check; probable manufacturer typo; HMI hazard consequences.
- `UNKNOWN`: actual selected firmware/AOP mapping, C1/C2/C3/C4 resolution, installed machine final-element response, occupancy/stop/holding proof.
- `TEST-CONFIRMED`: none. `SOURCE-CONFIRMED` (LinuxCNC source): none for this manufacturer tag contract.

## Additional service topology trap — GuardLink tap is NOT the same as DIN-rail safety relay

Directly inspected **440R-UM009E p. 8** (PDF index 6) states that the ENETR interface compares actual relay number/type to its configured chassis size and refuses I/O connections until matched. A **safety relay removed under power** disrupts communications for other relays and the entire system (including interface) requires power cycling to readdress. More subtly, relays of **different types** returned to wrong locations fail electronic ID verification **if keying is enabled**, but relays of the **same type** returned to wrong locations can pass keying and accept controller connections. This is `DOC-CONFIRMED` manufacturer behavior for the documented ENETR Series B architecture.

**Adversarial inference:** A service technician swaps two physically identical relays from different machine zones. Their catalog types match, so electronic keying alone cannot prove the relay-to-zone mapping is unchanged. HMI labels, physical final-element mapping and fault localization may now be wrong. Treat the change as `CHG/DEP/HF/VAL`: require traceable slot/zone identity, physical wiring and functional verification, not merely a successful connection. The actual machine consequence is `UNKNOWN` without selected wiring/configuration.

**Critical distinction:** GLINK-AT001A p. 7 describes automatic **same-type tap** recovery on a powered GuardLink chain. 440R-UM009E p. 8 describes **DIN-rail safety relay** removal under power as a different, communication-disruptive event. Do not copy a hot-tap replacement procedure into relay service instructions. Neither manufacturer statement is permission to service hazardous equipment with exposed workers without separate energy control.
