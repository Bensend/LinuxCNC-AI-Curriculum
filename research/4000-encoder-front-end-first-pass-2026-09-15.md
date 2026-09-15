# 4000 encoder electrical front-end first pass — 2026-09-15

Status: RESEARCH / SOURCE — not yet schematic-frozen

## Evidence gathered

LinuxCNC/Mesa practice strongly favors differential encoder inputs for machine feedback. Mesa 7I77-class interfaces expose multiple encoder inputs, and 7I96 field guidance explicitly distinguishes its differential quadrature encoder input from generic RS-422 serial I/O: an encoder must actually provide quadrature A/B(/Z), not merely carry an `RS-422` label.

A servo-drive interface manual independently documents the conventional electrical contract: differential encoder outputs are driven with AM26LS31-class line drivers and received by AM26LS32-class receivers or equivalent, with line termination and a shared signal reference. This is useful as topology evidence, but exact termination value must follow the selected receiver/encoder/cable system rather than copying one manual's nominal value.

## Working architecture

The base controller should prioritize **differential A/A-, B/B-, Z/Z- encoder channels**. This is the robust industrial default and avoids forcing long machine cables into single-ended FPGA inputs.

Do not equate:

- differential electrical activity;
- valid A/B quadrature relationship;
- valid Z/index event;
- plausible velocity/position;
- fresh transport of the FPGA count to LinuxCNC.

These are separate states.

## Proposed per-channel electrical contract

`connector -> surge/ESD protection -> differential termination/bias as required -> RS-422 receiver -> FPGA A/B/Z inputs`

Use a current-production multi-channel differential receiver with adequate common-mode range, input hysteresis/failsafe behavior and edge rate for the maximum supported encoder frequency. AM26C32-class topology is a starting reference, not yet a frozen BOM part.

### Protection

- Put ESD/transient protection at the connector with capacitance low enough for the supported edge rate.
- Provide a deliberate signal-reference/ground strategy; differential signaling does not mean the receiver can tolerate arbitrary ground potential.
- Avoid optocouplers in the default high-speed quadrature path unless a selected high-speed isolator's propagation skew and edge-rate budget are explicitly proven.

### Termination

Termination belongs at the receiving end and must be selected for the encoder driver/cable characteristic impedance. Do not hard-freeze 120/330 ohms from generic convention without checking the supported encoder class. A selectable termination option is preferable if the board must support heterogeneous encoders.

## Single-ended support

Do **not** burden every base encoder channel with a compromised universal analog front end in the first revision. Preferred architecture:

- base board: differential industrial encoder inputs;
- optional adapter/interface for 5 V TTL single-ended DRO/encoder sources if needed.

This preserves signal integrity and makes the supported electrical contract clear. If later machine inventory shows single-ended encoders are common enough to justify native support, add a separately qualified path rather than silently accepting them on one side of a differential receiver.

## FPGA semantics

LiteX-CNC already contains an encoder firmware module. The hardware block should expose raw A/B/Z to FPGA fabric and let the FPGA own edge counting/index capture. LinuxCNC should receive count/index state plus an explicit feedback freshness/generation witness from the transport layer.

Recommended diagnostic additions for the custom controller:

- transport feedback generation counter;
- optional illegal-quadrature transition counter if implemented in FPGA;
- index-seen/index-latched state;
- per-channel count/velocity data;
- no claim of cable continuity merely because count is stationary.

A differential receiver generally cannot prove that an encoder is powered, mechanically coupled or producing correct phase order. Those remain commissioning/process diagnostics.

## Channel/rate decision still open

Do not freeze channel count or maximum edge rate until the machine/block inventory is reconciled. The press-brake baseline needs two ram linear encoders; the reusable controller should likely provide additional channels for spindle/auxiliary axes, but the number should come from the 4000 block map rather than arbitrary abundance.

Maximum edge rate must be budgeted end-to-end:

`encoder PPR/resolution x maximum mechanical speed -> A/B edge rate -> receiver bandwidth/skew -> FPGA synchronizer/counter clock -> transport update rate`

FPGA counting can run much faster than the LinuxCNC servo update; the host needs coherent accumulated position, not every physical edge as a network event.

## Next source work before freeze

1. Find an inspectable open hardware schematic for a production-used differential encoder receiver (Mesa if public schematic evidence is available; otherwise another open CNC/robotics controller).
2. Compare modern receiver choices and their failsafe/common-mode/ESD characteristics.
3. Reconcile required channel count and maximum edge rate against the controller machine targets.
4. Define connector pinout, encoder supply options and ground/shield termination policy.
5. Then write the block through `hardware/BLOCK_SPEC_TEMPLATE.md` and freeze the schematic topology.

No simulation justified yet.
