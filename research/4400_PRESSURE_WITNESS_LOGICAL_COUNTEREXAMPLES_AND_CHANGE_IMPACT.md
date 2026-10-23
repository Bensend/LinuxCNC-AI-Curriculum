# 4400 — Formal pressure-witness counterexamples and change-impact lesson

**Status:** engineering reasoning from published HYDAC family diagrams, not simulation or physical test. Use with `4400_HYDAC_SAF_GAUGE_TOPOLOGY_ZERO_READING_PHYSICAL_WITNESS_2026-10-22.md` and the existing `SAFETY_VERIFICATION_INSTRUMENT_TRUST_CHAIN_WORKSHEET.md`. No machine-specific hydraulic truth table is asserted.

## Why a zero can be true but misleading

Define separate propositions for an *example* SAF-family topology:

- `G0`: gauge at the S-side fluid tap indicates zero.
- `S0`: actual hydraulic pressure at the S-side node is acceptably low for a defined task.
- `P0`: pressure on the isolated P-side/consumer path is acceptably low.
- `N0`: accumulator gas-side stored energy has been made safe for the intended task.
- `H0`: gravity/external-load hazardous motion is prevented by an adequately verified holding/restraint path.
- `M0`: the exposed maintenance task is safe to begin after required isolation and verification.

The unsafe inference is `G0 -> S0 AND P0 AND N0 AND H0 AND M0`. This implication is invalid **even if the gauge is calibrated and genuinely reads its own connected volume**.

### Counterexample A — manufacturer-documented precharge measurement

HYDAC PN#02068196 §3.2 describes a fluid-side gauge dropping abruptly to zero at the end of a controlled precharge measurement, while the reading just before the drop corresponds to gas precharge. This directly refutes `G0 -> N0`: the measured fluid-side pressure is not the gas pressure. The example requires no speculative sensor fault.

### Counterexample B — source-confirmed isolation boundary

The 2009 SAF/DSV diagram shows the main shutoff between S and P. With that shutoff closed, a gauge on the S side cannot logically be treated as a direct observation of P. Thus `G0 -> P0` is not warranted; **the actual P pressure is UNKNOWN**, not automatically high or low. Any real machine may add check valves, accumulators, other pumps, pilot feeds, cylinders or relief paths; inspect its as-built schematic.

### Counterexample C — a correctly operating gauge cannot measure gravity

Even if `S0` and `P0` were independently established, neither entails `H0` for a vertically loaded member. Hydraulic pressure, holding capacity, drift, support geometry and the possibility of external force are different propositions. If a physical witness shows motion, `H0` fails irrespective of green controller diagnostics. This is a conditional failure-path challenge, not a report that any particular press brake moved.

### Counterexample D — loss of the measurement path

A gauge can be correctly calibrated yet disconnected from the hazardous volume by an isolating cock, blocked sensing passage or changed plumbing. Then `G0` does not even entail `S0`. The existing curriculum's instrument trust-chain and test-point maintainability worksheets already address this general failure; the new HYDAC source trace provides an actual published fluid-side node and exact model-dependent port nomenclature. Do not duplicate those worksheets; link to them.

## Witness allocation table

| Proposition | Controller/status evidence | Legitimate independent evidence class | Unacceptable shortcut |
|---|---|---|---|
| SAF main shutoff position | position monitor, if installed and qualified | selected-valve position/mechanism verification | 'lock present means closed' |
| S-side pressure | calibrated S-side gauge or transducer with verified tap | actual S volume reading under qualified configuration | assuming reading covers gas and P side |
| P-side pressure | separate P-side sensor if installed | qualified P-side and other trapped-volume test points | relying on S-side zero |
| Gas-side energy | selected accumulator/gas-side product method | competent-person manufacturer-prescribed gas-side verification | assuming fluid-side zero = no gas precharge |
| Physical beam/ram holding | motion/valve status may be diagnostic | justified mechanical/hydraulic holding or restraint proof | pump off or valve healthy |
| Maintenance isolation | controller may display status | energy-isolating devices, worker protection, stored-energy disposition and verification | production E-stop, STO or ordinary LinuxCNC reset |

## Change-impact and stale evidence

A replacement of the pressure gauge with the same range is **not automatically** a like-for-like validation event. The following can change the witness meaning without changing the displayed units: moving a tap from S to P, adding a gauge isolating valve, changing a snubber, plugging M1/M2, replacing an `M` block with `E/Y` or `E/Z`, changing the return hose, or reusing a pressure channel name after rewiring. Each is a `CHG-*` candidate because it can alter `DEP-*` and invalidate `PHY/SRS/VAL/PT` evidence. The exact affected IDs must be resolved from the current package dependency graph; no blanket 'retest everything' claim.

A practical inspection aid is a durable tag showing **which physical volume** the gauge/test point observes, a protected accessible connection, a diagram revision and an obvious safe restoration state. These features reduce the incentive to trust the HMI alone or improvise a dangerous test. They do not replace independent safety architecture, rated restraint or maintenance energy isolation.

## Machine transfer without false equivalence

- **Press brake:** S/P/gas/ram holding and die/workpiece/helper sweep are separate hazard boundaries; actual circuit unknown.
- **Vertical mill:** a counterbalance accumulator or pneumatic spring and Z-axis brake require separate gas/pressure/vertical-load propositions; do not transplant SAF port labels.
- **Robot/automated cell:** pneumatic reservoir zero at one sensor does not prove all trapped gripper/tooling pressure or gravity brake state; distinguish the actual circuit.
- **Plasma table:** gas-pressure and process-energy isolation remain separate from LinuxCNC torch inhibit; do not confuse one instrument with all hazardous energy.

## Review decision

This is an **information-gain stop** for generic documentary topology: the counterexamples are established by manufacturer source and logic. No simulation is needed. An actual machine `VAL` requires selected hardware and physical witnesses. Keep the safety course active and rotate to another source-evidenced safety question if those facts remain unavailable.

## Direct source navigation (publication-review addition)

- [HYDAC Accumulators Operating and Installation Instructions ACU1107-1367/09.11](https://betterfit-us.hydac.com/wp-content/uploads/Operating%20and%20Installation%20Instructions%20for%20HYDAC%20Accumulators.pdf)

These links identify source families/editions used by the companion investigation; they do **not** make this qualitative note an as-built machine design or a physical validation result. Verify exact selected product/manual and the proposition each source supports before publication.
