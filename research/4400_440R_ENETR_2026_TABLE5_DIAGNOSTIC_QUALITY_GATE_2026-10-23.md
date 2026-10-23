# 4400 — 440R-ENETR 2026 Table 5: diagnostics are not a safety-state oracle

**Scope:** manufacturer-documentary review of Rockwell Automation `440R-UM009E-EN-P`, February 2026, Series B `440R-ENETR`, pp. 8, 43–44, 62–63. Not a selected-machine implementation or firmware test. Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um009_-en-p.pdf . Companion learner exercise: `safety-course/4400_GUARDLINK_DIAGNOSTIC_DECODER_ADVERSARIAL_WORKSHEET_2026-10-23.md`.

## Source-confirmed data-validity trap

**DOC-CONFIRMED:** Table 5 defines `Active=0` as an IN1 circuit configured for ordinary OSSD/EMSS inputs rather than GuardLink, with the remaining GuardLink tags set to zero. Therefore `DeviceTrip=0` while `Active=0` is not a valid basis to display "all guards tripped" or "all guards healthy." The HMI must first qualify which interface mode and source data are actually valid. This is an **INFERENCE** for proposed HMI behavior, not a claim that a particular HMI has implemented it.

**DOC-CONFIRMED:** For four nodes, Table 5 uses `DeviceCount=15`, `DeviceTrip=15` for all operational, `DeviceTrip=10` for nodes 1 and 3 tripped, and `DeviceTrip=13` for node 2 tripped. The manual defines zero bits in `DeviceTrip` as tripped nodes. `DeviceCount` is therefore **not a simple arithmetic node count** in these examples; a decoder must preserve the raw bit pattern and exact selected documentation. No generalized firmware-specific decoder is approved here.

**DOC-CONFIRMED documentation conflict:** Table 5 also says `DeviceFault=6` means nodes 1 and 4 faulted. The apparent bit ordering from the `DeviceTrip` examples would map nodes 1 and 4 to `1001` (decimal 9), not `0110` (decimal 6). The document does **not** establish that `DeviceFault` shares the same mapping as `DeviceTrip`; do not silently repair the manual by applying one field's convention to another. Preserve raw values and mark the `DeviceFault` mapping **UNKNOWN** pending selected-firmware/manufacturer clarification.

**DOC-CONFIRMED separate timing conflict:** Table 6 describes reset-held code 03 with `250…3000 s`, while the manual's reset-command discussion elsewhere uses subsecond/seconds timing. Do not turn the apparent table-unit error into a design value. The exact selected function, firmware and authoritative correction remain UNKNOWN.

## Distinguish three propositions

| Evidence | Narrow legitimate proposition | Cannot prove |
|---|---|---|
| `Active`, `DeviceTrip`, `DeviceFault` tags | Documented diagnostic/interface state when current, correctly decoded and qualified | Independent safety controller output, physically open contactor/valve, stopped/held beam, empty safeguarded space |
| Safety relay's own selected safety circuit | Only the safety-related function supported by its exact design and validated wiring | Maintenance energy isolation or every residual-energy path |
| Independent physical `PHY/VAL` witness | Selected physical stopping/holding/energy proposition to extent measured | Unmeasured modes, later changes or absent maintenance isolation |

**DOC-CONFIRMED:** The manufacturer's Series B ENETR description is a communications interface to Guardmaster safety relays. Do not conflate it with the separate **432ES-IG3** CIP Safety interface and its `DeviceTripAddress` first-event semantics. Product-family names and tag similarities do not confer safety authority on an HMI or ordinary LinuxCNC/FPGA.

## Human-factors and adversarial release gate

A practical diagnostic display should show **raw value, decoded interpretation, product/firmware/manual edition, node/zone mapping, validity/freshness and UNKNOWN state**. It should distinguish "event occurred" from "currently open" and avoid green defaults on communication loss. This proposed display contract is **INFERENCE**, not a safety-certified implementation.

After replacement or node/relay rearrangement, open `CHG`, review `DEP/ARC/AUTH` mapping, mark dependent `VAL/PT` STALE, and independently verify actual guard→safety demand→final element→physical hazard behavior under a justified isolated commissioning plan. Do not manipulate a hazardous machine to satisfy a dashboard test; if the minimum physical safe-state proposition is unproved, block personnel-exposed operation.

**Evidence ledger:** manufacturer manual `DOC-CONFIRMED`; bitwise counterexample and HMI contract `INFERENCE`; selected-firmware mapping, wiring, physical machine response and PL/SIL `UNKNOWN`; `TEST-CONFIRMED` **none**. No compute lab is justified to recheck printed truth-table arithmetic; only a selected-firmware ambiguity that affects a real design could motivate a bounded, isolated test on `[self-hosted, openpressbrake]`, never GitHub-hosted runners.
