# 4400 diagnostic decoder adversarial worksheet — do not turn ambiguous tags into safety authority

**Not a machine-control program or approved decoder.** Manufacturer: Rockwell 440R-ENETR Series B, manual 440R-UM009E-EN-P (February 2026), Table 5 p. 43. This exercise uses only the explicitly documented `DeviceTrip` examples and flags unresolved `DeviceFault` ambiguity.

## Exercise 1: interpret without overclaiming

| `DeviceCount` raw | `DeviceTrip` raw | Arithmetic only | Documented interpretation | Does it prove every guard closed/locked or hazard stopped? |
|---:|---:|---|---|---|
| 15 | 15 | 15 XOR 15 = 0 | All four nodes operational (documented example) | **No** |
| 15 | 10 | 15 XOR 10 = 5 (`0101`) | Nodes 1 and 3 tripped (documented example) | **No** |
| 15 | 13 | 15 XOR 13 = 2 (`0010`) | Node 2 tripped (documented example) | **No** |
| 15 | 0 | 15 XOR 0 = 15 | All four bits indicate tripped if same bit convention applies; **INFERENCE**, not independently tested | **No** |

If `Active=0`, the manufacturer says remaining GuardLink tags become zero. A decoder that displays all nodes tripped or healthy from those zeros without checking `Active` is wrong. Record **inactive / no valid GuardLink data** instead.

## Exercise 2: find the manufacturer contradiction

The same manual says `DeviceFault=6` means nodes 1 and 4 faulted, but `6` is binary `0110`. The `DeviceTrip` examples imply node 1 is bit 0 and node 4 bit 3, which would produce `1001` (decimal 9) for nodes 1 and 4 under that mapping. **Do not guess** that the `DeviceFault` field uses the same bit mapping. Record `UNKNOWN`, retain raw value, check manufacturer clarification/selected firmware and do not allow the ordinary HMI to authorize safety rearm.

## Exercise 3: detect version drift and conflation

- A 2019 manual copy describes `DeviceDiagnostic` as one-or-more bitmask; the directly inspected 2026 manual says only one device. Treat as **unresolved version/document difference** until exact AOP/firmware evidence.
- `DeviceTripAddress` from a **432ES** first-event field is not `DeviceTrip` from a **440R-ENETR** node bitmap. Do not share a decoder based on a similar name.
- Diagnostic code 09 `>30 ms` versus tap-family 3 s/10 s windows is **not** a universal machine stop time. Investigate diagnostic-layer scope and exact firmware.
- The 2026 diagnostic code 03 table prints `250...3000 s` while the reset command definition says `0.25...3 s`. Preserve the discrepancy; do not silently convert a documentation inconsistency into a machine timing guarantee.

## Evidence and physical release gate

The HMI may display raw tags, qualify data freshness, and help locate a fault. It must not declare the safeguarded space empty, a spindle stopped, a press beam held, a robot restrained, or hydraulic energy isolated. For real commissioning, require selected-machine `SRS/PHY/AUTH/DEP/ARC/VAL/PT/CHG/UNK` evidence. If minimum physical protection is unproved, no personnel-exposed hazardous operation.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um009_-en-p.pdf (pp. 39, 43–44). This worksheet is public learner practice, **not** a blind evaluator answer key.

## Exercise 4: two identical safety relays swapped in the cabinet

Two same-type DIN-rail Guardmaster relays are removed and accidentally returned to each other's locations. ENETR's electronic keying can accept connections when both relay types match (440R-UM009E p. 8). The HMI still says `Zone A` and `Zone B` based on expected slot mapping.

**Required answer:** successful electronic keying proves only the checked type/identity criterion, not physical zone correctness. Treat slot-to-machine mapping as `UNKNOWN`, verify actual wiring/final elements, guard-to-zone response and labels under an authorized isolated commissioning plan; mark dependent evidence `STALE` until revalidated. Do not run the machine with people exposed while zone protection is unproved.

**Contrast:** hot replacement of a **GuardLink tap** with the same type can automatically recover the GuardLink chain (GLINK-AT001A p. 7); removal of a **DIN-rail safety relay** under power disrupts other communications and requires a full power-cycle/readdress sequence (440R-UM009E p. 8). These are not interchangeable service procedures.
