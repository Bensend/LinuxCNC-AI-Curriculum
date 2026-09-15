# 4000 digital field I/O first pass — 2026-09-15

Status: RESEARCH — architecture narrowed; exact input/output topology not frozen yet.

## Proven LinuxCNC field-I/O baseline

Mesa's production LinuxCNC interfaces provide a strong functional baseline:

- 7I76/7I77 class: 32 isolated 5-32 V inputs + 16 isolated 5-32 V outputs; typical 24-VDC control use.
- 7I76E: 32 sinking inputs + 16 sourcing outputs, isolated field power, 300-mA output class, short-circuit protection.
- 7I95/7I97 class: inputs support roughly 3-36 V and can use positive or negative common for sourcing/sinking sensor applications; isolated output arrangements are available at higher current.

Mesa's 7I77 manual gives a useful design rationale: sourcing outputs are less likely to cause unintended device actuation from the common field-wiring fault of a short to ground, while sinking outputs improve retrofit compatibility and mixed-voltage use. It also shows that production field outputs should expose short-circuit and overtemperature fault behavior rather than merely switch a transistor.

References:
- https://www.mesanet.com/fpgacardinfo.html
- https://www.mesanet.com/pdf/parallel/7i77man.pdf

## Open-hardware comparison

Expatria FlexiHAL 2350 explicitly targets EMI-resistant CNC field wiring, uses 12-24 V machine power, and galvanically isolates machine-facing I/O. Its general inputs support powered 3-wire inductive switches and its high-current outputs include short-circuit/overcurrent/thermal protection. This independently supports treating industrial 24-V I/O as a protected field-power subsystem rather than direct FPGA GPIO.

Reference: https://github.com/Expatria-Technologies/FlexiHAL_2350

## Working requirements

1. 24-VDC nominal field I/O; useful operating envelope should cover at least common 12-24 V machine controls.
2. Galvanic isolation between field I/O and FPGA logic is the preferred base architecture for ordinary discrete I/O.
3. Inputs should support both common industrial PNP and NPN sensor ecosystems without per-channel rewiring tricks. A grouped selectable/common-reference architecture is preferable to doubling every input circuit.
4. Outputs need explicit OFF state on FPGA reset/watchdog/communications loss through FPGA-local output-authority gating.
5. Outputs need short-circuit/overtemperature protection and diagnostic feedback where the selected driver permits it.
6. A software command bit is not a physical output witness. Driver fault/diagnostic status must remain separate from command state.
7. External safety-rated circuits remain external; ordinary isolated field I/O is not safety I/O.

## Channel-count direction

Do not freeze channel count solely by copying Mesa. Working packaging target for the reusable single-board controller is **24 general isolated digital inputs + 16 protected digital outputs**, subject to FPGA pin/bank and connector-space reconciliation. Twenty-four inputs better matches limit/home/probe/drive-fault/operator/auxiliary-heavy machines while avoiding the connector footprint of 32 inputs on the first integrated board.

## Output polarity question remains open

Defaulting all outputs to sourcing/high-side has a real fault-containment advantage for ground-short field faults and matches the Mesa 7I76/7I77 pattern. However, retrofit compatibility may justify some sinking/low-side outputs or a separately grouped configurable output bank.

Do not freeze this until a current-production protected high-side/low-side driver comparison is completed. The next source/BOM pass should compare:
- protected high-side industrial switches;
- protected low-side switches;
- diagnostic behavior on open load/short/thermal fault;
- inductive-load energy handling;
- watchdog/reset gating behavior independent of the host command register.

## Input topology question remains open

The next pass should select a current-production input front end that can tolerate field transients and gives predictable thresholds across the intended 12-24 V range. Optocouplers are proven and provide straightforward isolation but have CTR/aging/speed/current tradeoffs. Modern isolated/digital-input receiver approaches may reduce variability. Standard engineering and datasheet reference circuits should decide this; no simulation is justified yet.

## Authority/freshness rule

For every input preserve:
`field voltage/current -> input receiver state -> FPGA sampled bit -> feedback generation -> host VALID/FRESH`

For every output preserve:
`host request -> FPGA command register -> watchdog/output-authority gate -> field driver command -> driver diagnostic -> physical load state (only if independently sensed)`

Neither input isolation nor protected output drivers prove the external mechanism reached its commanded state.

## Exact next work

Select the protected output-driver family/polarity strategy first, then the isolated 24-V input receiver. Only then freeze `4300-DIO` schematic contract and channel grouping.
