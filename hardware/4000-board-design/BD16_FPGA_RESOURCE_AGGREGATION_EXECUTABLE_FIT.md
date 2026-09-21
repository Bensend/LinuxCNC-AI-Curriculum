# BD16 — FPGA Resource Aggregation and Executable Fit Evidence

**Lane:** independent LinuxCNC/OpenPressBrake board-design curriculum  
**Track:** BOARD INTEGRATION with BLOCK ENGINEERING feedback  
**Design-flow position:** block resource contracts -> board allocation -> FPGA implementation -> executable fit/timing evidence

## Purpose

A spreadsheet saying that an FPGA has enough pins or LUTs is useful planning evidence, but it is not implementation proof. BD16 teaches how reusable-block resource contracts become a complete board allocation and then become exact-image synthesis, place-and-route, timing, and regression evidence.

The working chain is:

`block resource contract -> board instance count -> semantic resource allocation -> package/bank/pin plan -> LUT/FF/BRAM/PLL/clock/bus aggregation -> arithmetic headroom -> exact configured image -> synthesis -> place-and-route -> timing -> evidence binding -> regression trigger`

Core rule:

**RESOURCE ARITHMETIC IS A PLANNING GATE; THE CURRENT EXACT IMAGE IS THE FIT/TIMING AUTHORITY.**

## Learning outcomes

By the end of BD16, the student can:

1. distinguish semantic resource demand from physical package-pin allocation;
2. aggregate GPIO, buses, clocks, LUT/FF/BRAM/PLL and other shared resources across block instances;
3. check bank, voltage, dedicated-pin and clock-resource legality rather than merely counting pins;
4. distinguish arithmetic headroom from synthesized utilization;
5. distinguish synthesis success from place-and-route success and timing closure;
6. bind executable evidence to an exact source/configuration/tool/constraint revision;
7. identify when an older successful image is stale after a board-resource change;
8. preserve reusable block ownership while performing board-level resource allocation;
9. treat missing resource metadata as a catalog defect rather than unwritten integrator knowledge;
10. keep ordinary FPGA watchdog/output-inhibit functions outside personnel-safety authority.

## Student-facing source audit

The following current OpenPressBrake `main` artifacts were opened directly during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used below:

- `hardware/blocks/fpga_core_ecp5_25/manifest.yaml` — current reusable FPGA-core architecture, nominal/package resource contract, core reservations, current resource unknowns, and selected ECP5-25 device.
- `hardware/blocks/fpga_core_ecp5_25/STATUS_CHECKLIST.md` — exact current maturity boundary plus retained real-image utilization and routed-timing evidence.
- `hardware/integration/REV1_FPGA_CORE_RECONCILIATION.md` — board-integration precedence: current reusable ECP5/RGMII/FT2232H core supersedes the stale KSZ8081/RMII board snapshot.
- `hardware/integration/REV1_BOARD_INTEGRATION_RECONCILIATION.yaml` — current whole-board reconciliation, including current proportional serial architecture and explicit stale-resource quarantine.

These artifacts are not proof that the complete controller is released. The current core status explicitly leaves the exact Rev46 timing rerun, routed RGMII/USB/JTAG physical qualification, final power/current/thermal work, schematic review and Rev-1 release open.

## 1. Five different questions called “does it fit?”

Treat these as separate gates:

1. **Semantic fit** — does every instantiated function have a defined FPGA-side resource contract?
2. **Package fit** — can those resources be assigned to legal package balls without collision with configuration, JTAG, clocks or other fixed functions?
3. **Bank/electrical fit** — are I/O standards, bank voltages, differential/special-pin requirements and direction constraints legal together?
4. **Logic fit** — does the synthesized image fit LUT/FF/BRAM/PLL and other fabric resources?
5. **Timing/routing fit** — can the actual image be placed/routed while meeting its real constraints?

Passing an earlier gate never implies a later one.

**PIN COUNT FIT != LEGAL PACKAGE/BANK FIT != LOGIC FIT != TIMING CLOSURE.**

## 2. Resource contracts belong at the reusable-block boundary

A reusable block should expose the resources needed to instantiate its function without embedding a machine-specific pin assignment. Depending on the block, this may include:

- semantic GPIO inputs/outputs;
- differential or clock-capable requirements;
- I/O voltage and standard;
- SPI/I2C/UART/bus membership and chip-select demand;
- PWM/counter/encoder/stepgen logical modules;
- clock/domain requirements;
- expected FPGA-side buffering or filtering;
- estimated or measured fabric demand where useful;
- hard IP, PLL, BRAM or SERDES requirements;
- default/fault-state behavior and output-authority dependencies.

Board integration owns instance count, sharing decisions allowed by contract, package-ball assignment, bank allocation and the complete configured image.

A block must not quietly claim a dedicated SPI bus merely because its first worked example used one. Conversely, board integration must not merge independent buses or chip selects unless the block contracts permit that topology.

## 3. Count semantics before counting pins

Start with named resources, not a number such as “needs 12 GPIO.” A semantic inventory catches errors that a scalar count cannot:

- input versus output direction;
- shared bus versus per-instance select;
- clock-capable input;
- differential pair;
- tri-state/open-drain behavior;
- startup/default level;
- asynchronous fault/enable path;
- ordinary runtime signal versus dedicated configuration/JTAG pin.

Only after those properties are explicit should the integrator reduce the inventory into arithmetic totals.

## 4. Current OpenPressBrake planning example

The inspected current FPGA-core manifest selects `LFE5U-25F-6BG256I` / CABGA256 and records a conservative runtime-user-I/O planning capacity of 191 after reserving six dual-purpose QSPI/user-I/O positions. It separately records 32 core-runtime GPIO reservations: 15 Ethernet RGMII/management signals, 12 FTDI Channel-B asynchronous-FT245 signals, four watchdog/reset/power-good signals and one system-clock input. Dedicated JTAG signals are explicitly not counted in that runtime-user-I/O number.

That is useful planning authority because it states what was counted and what was excluded. It is not enough to prove a legal image.

The current status checklist records progressively stronger evidence:

- machine-required configuration: 86 runtime GPIO;
- first board with reserved sixth proportional channel: 90 runtime GPIO;
- full reusable architecture: 143 runtime GPIO;
- arithmetic full-architecture spare: 48 GPIO / 25.13%;
- Rev27 exact package allocation maps all 143 runtime signals without package-ball collision;
- a real LiteX-CNC image has successfully packed on ECP5-25.

Each statement answers a different question. Preserve those distinctions in reviews.

## 5. Stale resource assumptions are dangerous

The current board reconciliation explicitly rejects older proportional-resource assumptions. The active architecture uses two MAX22216 devices on shared SPI with per-device chip selects and current feedback through that serial interface. Board capture must not recreate the retired per-channel proportional command resources or ADS7953 proportional-current consumers.

This illustrates why a resource spreadsheet must have source precedence and revision identity.

**AN OLD COMPLETE RESOURCE TABLE CAN BE MORE DANGEROUS THAN AN EXPLICIT TBD.**

When architecture changes, invalidate downstream resource evidence that depended on the old semantic allocation.

## 6. Package and bank fit

After semantic allocation, verify every physical assignment against the selected device/package:

- unique package ball ownership;
- legal I/O capability for the signal;
- bank voltage compatibility;
- dedicated/configuration/JTAG ownership;
- clock-input requirements;
- differential-pair requirements where applicable;
- startup/configuration behavior;
- reserved pins and dual-purpose pin modes.

A board with 20 free GPIO can still be unroutable or illegal if the remaining balls are in the wrong bank or lack the required special function.

**UNUSED GPIO != USABLE GPIO.**

The OpenPressBrake core's Rev27 allocation is stronger evidence than a scalar pin budget because it maps the full 143-signal reusable architecture while preserving the fixed Colorlight-derived clock/RGMII resources and package ownership.

## 7. Arithmetic fabric budget versus synthesis

Before implementation, aggregate expected fabric demand to detect obviously impossible designs and preserve headroom. Track at least:

- LUT/COMB;
- FF/registers;
- BRAM/DP16KD;
- PLL/clock resources;
- hard multipliers/DSP where used;
- generated clock domains;
- cross-domain structures;
- bus/interconnect overhead;
- debug/service features that remain in the production image.

But estimates are not synthesis results. Tool inference, optimization, interconnect, CDC structures and generated logic can materially change actual usage.

The current OpenPressBrake manifest deliberately leaves `luts_available_after_core`, `registers_available_after_core`, `bram_bits_available_after_core`, and `plls_available_after_core` as values to capture from a real synthesis report rather than pretending nominal device capacity minus hand estimates is authoritative.

**ARITHMETIC HEADROOM != SYNTHESIZED HEADROOM.**

## 8. Current real-image utilization: what it proves

The inspected current status checklist retains a real-image report from workflow `34904495381`:

- IO: `141 / 197`;
- DP16KD: `4 / 56`;
- FF: `7338 / 24288`;
- COMB: `17717 / 24288`;
- the image successfully packed a bitstream.

This is executable evidence that the corresponding exact image fit those reported resources and could be packed. It is not a timeless statement that every future OpenPressBrake configuration fits.

Record with utilization evidence:

- repository commit;
- configuration/image identity;
- selected device/package;
- toolchain/pinned dependency identity;
- constraint set;
- resource report;
- build/place-route/pack result;
- timestamp/workflow/run artifact;
- known exclusions or later-invalidating changes.

## 9. Synthesis, place-and-route, and timing are different gates

A useful progression is:

`source/config validates -> elaborates -> synthesizes -> places -> routes -> packs -> timing report satisfies every required domain`

Synthesis proves that logic can be elaborated/mapped under that tool/configuration. It does not prove legal physical placement/routing. Successful place-and-route/pack proves a physical solution was found. It does not prove that solution meets required timing unless the required domains are correctly constrained and pass.

**SYNTHESIS PASS != PLACE/ROUTE PASS != TIMING PASS.**

## 10. Adversarial timing example: a green build with insufficient authority

The current core status contains an excellent failure-of-interpretation example. Run `34904495381` successfully synthesized, placed/routed and packed the image and reported:

- `eth_rx = 135.81 MHz`, passing its 125-MHz target;
- `soc_crg_clkout = 40.08 MHz`, but the tool had targeted only 12 MHz for that domain.

The repository explicitly rejects that sys-domain result as final timing proof because the production image was under-constrained. Rev46 changes the generated-system-clock constraint to 25 ns / 40 MHz and requires a new exact-image run.

Therefore the correct status is not “timing passed because 40.08 > 40.” The relevant run did not prove the required 40-MHz domain against a 40-MHz constraint.

**MEASURED FMAX ABOVE INTENDED FREQUENCY != TIMING CLOSURE WHEN THE INTENDED CONSTRAINT WAS NOT APPLIED.**

This is precisely why constraints are part of evidence identity.

## 11. Exact-image evidence and regression triggers

Invalidate or re-evaluate fit evidence when a change can affect any relevant stage. Examples:

- block instance count changes;
- semantic interface/resource contract changes;
- bus-sharing or chip-select topology changes;
- package pin/bank allocation changes;
- FPGA device/package/speed-grade changes;
- module enable/disable changes;
- clock frequency/domain changes;
- timing constraint changes;
- toolchain or pinned LiteX/LiteX-CNC dependency changes;
- HDL/firmware changes affecting generated gateware;
- retained debug/service logic changes;
- placement/routing constraints change.

Classify the response rather than saying only “rerun FPGA.” Static semantic allocation may need `RECALCULATE` or `REVIEW`; deterministic validators may need `RERUN`; changed implementation needs new synthesis/place-route/timing evidence; physical SI changes may require `REQUALIFY` beyond FPGA tools.

## 12. Board-level aggregation ledger

For a new board, create a ledger with one row per instantiated function/resource. Minimum useful fields:

| Field | Purpose |
|---|---|
| instance | stable board instance identity |
| reusable block + revision | source resource contract |
| semantic resource | named function, not merely GPIO count |
| direction/electrical class | input/output/bidir/clock/diff/open-drain/etc. |
| bus/domain | sharing and clock ownership |
| package ball | board allocation |
| bank + VCCIO | electrical legality |
| startup/default | de-energized/configuration behavior |
| logical FPGA module | gateware ownership |
| estimated fabric | planning only |
| exact-image evidence | synthesis/P&R/timing revision |
| status | VERIFIED / REVIEW / TBD |

The ledger is board integration data. Do not copy machine-specific package assignments back into reusable primitive definitions.

## 13. Lab — break the fit evidence on purpose

Start from a verified resource ledger and current evidence. Perform three hypothetical changes:

### Change A — add one more ordinary digital input

Determine whether scalar GPIO headroom is enough to approve the change. It is not. The student must also establish a legal ball/bank/default-state allocation and regenerate the exact image before implementation evidence is current.

### Change B — move a function onto a shared SPI bus

Do not simply subtract pins. Verify that the reusable block permits sharing, clock/mode/electrical requirements are compatible, chip-select/default behavior is explicit, and gateware ownership supports the topology.

### Change C — increase a generated clock

Pin allocation may remain unchanged and resource utilization may barely change, yet prior timing evidence becomes stale. Update constraints and obtain exact-image timing evidence.

For each change, identify which evidence remains valid, which must be recalculated/reviewed/rerun, and which physical qualification is unaffected.

## 14. Catalog stress-test findings

A reusable block catalog is weak if board integration needs tribal knowledge to answer any of these:

- how many semantic FPGA resources one instance consumes;
- whether resources are shareable;
- required I/O voltage/standard;
- clock/differential/special-pin requirements;
- startup/default state;
- logical module ownership;
- expected hard-resource needs;
- regression triggers when the contract changes.

Record those as catalog defects. Do not solve them only in a board-specific spreadsheet.

A useful future machine-readable schema should separate:

1. **semantic demand** — what one block instance requires;
2. **board allocation** — how instances are mapped/shared;
3. **physical package allocation** — exact balls/banks/standards;
4. **configured-image identity** — exact enabled modules and clocks;
5. **implementation evidence** — synthesis/P&R/timing results and constraints;
6. **invalidation edges** — which changes stale which evidence.

## 15. Safety boundary

FPGA watchdogs, output enables, default-low command paths and ordinary-control inhibits are valuable fault-containment mechanisms. They do not become personnel-safety functions merely because they are deterministic hardware or because timing is proven.

For OpenPressBrake, Pilz/AKAS/SICK personnel-safety authority remains external and independent. FPGA/LinuxCNC resource planning must not consume or represent that independent safety authority as if ordinary gateware were safety-rated.

## 16. Compute policy for this lesson

No new synthesis/place-and-route run was needed to teach BD16 because current repository evidence already contains both a successful real-image resource-fit result and an explicitly rejected under-constrained timing result. Re-running an unchanged historical image would add little evidence.

When a future lesson or engineering change genuinely requires executable FPGA verification, dispatch only to the OpenPressBrake panel runner labeled `[self-hosted, openpressbrake]`. Never substitute GitHub-hosted Actions minutes. If that runner cannot be dispatched, preserve the gate as open.

## 17. Release questions

Before accepting FPGA fit evidence for a board revision, answer all of these:

- Is every instantiated block's semantic FPGA demand explicit?
- Is the board instance count current?
- Are shared buses/resources contractually shareable?
- Are all package balls unique and legal?
- Are bank voltages and I/O standards compatible?
- Are dedicated/configuration/JTAG/clock pins protected from accidental reuse?
- Does the exact configured image match the board allocation?
- Did that exact image synthesize?
- Did it place and route?
- Did every required clock domain have the intended constraint?
- Did timing pass those intended constraints?
- Are resource and timing reports bound to exact source/config/tool revisions?
- Are regression triggers recorded?
- Are physical SI/power/thermal qualification gates kept separate from FPGA fit?
- Is ordinary-control logic kept outside personnel-safety authority?

If any answer is unknown, keep the corresponding gate open.

## Durable rules

- **RESOURCE ARITHMETIC IS A PLANNING GATE; THE CURRENT EXACT IMAGE IS THE FIT/TIMING AUTHORITY.**
- **PIN COUNT FIT != LEGAL PACKAGE/BANK FIT != LOGIC FIT != TIMING CLOSURE.**
- **UNUSED GPIO != USABLE GPIO.**
- **ARITHMETIC HEADROOM != SYNTHESIZED HEADROOM.**
- **SYNTHESIS PASS != PLACE/ROUTE PASS != TIMING PASS.**
- **A PACKED BITSTREAM != TIMING CLOSURE.**
- **MEASURED FMAX ABOVE INTENDED FREQUENCY != TIMING CLOSURE WHEN THE INTENDED CONSTRAINT WAS NOT APPLIED.**
- **AN OLD COMPLETE RESOURCE TABLE CAN BE MORE DANGEROUS THAN AN EXPLICIT TBD.**
- **BOARD PACKAGE ALLOCATION DOES NOT BELONG INSIDE A REUSABLE FUNCTIONAL BLOCK.**
- **FPGA FAULT CONTAINMENT != PERSONNEL-SAFETY AUTHORITY.**

## Next lesson

BD17 should return to block engineering and study **startup, default, reset, partial-power and de-energized-state contracts** across reusable blocks. It should ask whether a board integrator can determine, without tribal knowledge, what every output/input does before configuration, during brownout, with field power present but logic power absent, with logic power present but field power absent, after watchdog expiry, and during connector hot-plug. Any missing behavior becomes a block-catalog defect rather than a lesson assumption.