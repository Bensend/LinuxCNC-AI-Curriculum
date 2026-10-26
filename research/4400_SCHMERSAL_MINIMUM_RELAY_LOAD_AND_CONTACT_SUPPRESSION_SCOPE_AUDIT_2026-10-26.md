# 4400-LOAD-01 — Safety relay contact ratings have a lower boundary too
**2026-10-26 | OEM product catalog, product-specific | NON-GRADUATED**

## Source
Schmersal, **AES 2335 UE 24...230 V AC/DC**, exact article **101180843**, official product catalog https://products.schmersal.com/en_CA/aes-2335-ue-24230v-acdc-101180843 ; directly read 2026-10-26; site shows **generated 2026-08-26**, product **phased out**. The catalog is not an as-built machine inspection. Compare the independent Rockwell original-document [LEAK-01 audit](4400_ROCKWELL_INTELLIVAC_OFF_STATE_LEAKAGE_SNUBBER_POWER_UP_AND_DELAY_OEM_AUDIT_2026-10-26.md).

## Exact manufacturer facts
- **DOC-CONFIRMED:** safe relay output *minimum switching capacity* **10 VDC / 10 mA**, for **this article only**. Its catalog also specifies AC-15 and DC-13 load classes and separate upper ratings; a relay marked 'safety' is not guaranteed suitable for arbitrarily small signal currents.
- **DOC-CONFIRMED:** catalog requires suitable suppression of inductive loads such as contactors and relays. It does not prescribe one universal suppressor, its placement or exact switching transient for a different circuit.
- **DOC-CONFIRMED:** the same catalog has example wiring with bridges that change behavior, including an example that states a particular bridge renders short-circuit detection inoperative. **These are manufacturer example configurations, not instructions for bypassing protections**; any installed configuration needs independent safety validation.
- **DOC-CONFIRMED:** the product's own performance-level, PFH and duty-cycle conditions refer to its defined application and do not establish system PL or machine physical stopping.

## Two opposite interface hazards
**Insufficient wetting / low-energy switching:** a very low-current logic input may be below the manufacturer's stated minimum relay switching specification. This can create an unreliable indication or contact behavior, but **the catalog does not quantify a failure probability or prescribe a field resistor**. **INFERENCE** about failure mechanism; exact compatibility requires a product-specific analysis.

**Excessive or misplaced suppression:** inductive coil switching needs correctly selected suppression, but a snubber **across an open control contact** can form a leakage path into a high-impedance input. That latter failure is **DOC-CONFIRMED for the Rockwell IntelliVAC interface**, not established for the Schmersal output alone. Do not conflate these two separate OEM devices.

## Practical replacement and safety lesson
A physically fitting replacement can change minimum contact load, utilization category, suppression compatibility, drop-out behavior, diagnostics and feedback. Require exact part numbers and original circuit intent, then qualified documentary compatibility review, isolated inspection and later independent physical proof. Ordinary LinuxCNC I/O is monitoring/command, not personnel-safety authority. **UNKNOWN:** any Schmersal AES device on OpenPressBrake, actual circuit current, safe-state final elements, stop/hold and PL/SIL. **TEST-CONFIRMED none**; no live test. G0/G1 HOLD.
