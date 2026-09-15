# 4000 encoder electrical reference and receiver selection — 2026-09-15

Status: SOURCE/DATASHEET PASS — enough to freeze the base electrical direction; exact connector/TVS part remains PCB-stage work.

## Question

What encoder electrical front end should the reusable LinuxCNC controller use before schematic capture?

## Proven open hardware reference

Expatria Technologies' FlexiHAL 2350 is an inspectable open-hardware CNC controller (CERN-OHL-S-2.0) with two differential encoder ports. Its published README states that all machine-facing I/O is galvanically isolated from the MCU/user side and that the two encoder ports provide differential external-encoder connections suitable for lathe/high-speed LinuxCNC use. The design explicitly targets EMI-resistant CNC wiring and points to a complete published schematic PDF.

Reference:
- https://github.com/Expatria-Technologies/FlexiHAL_2350
- pinned repository tree observed 2026-09-15: `ffff1401cf488ce69c09fb86e919862a9e50691d`
- schematic blob: `2293e8192c6ede8bb06f7be228d44d6a4446e035`

The available connector/API path cannot text-decode the binary schematic PDF in this session, so this pass does **not** claim the exact FlexiHAL receiver IC or component values. The reference is used to establish that differential machine-facing encoder ports are a real current open CNC implementation, not to invent unread component details.

## LinuxCNC/Mesa field compatibility

Mesa/LinuxCNC practice strongly supports differential A/B/index encoder interfaces. LinuxCNC community guidance for Mesa encoder interfaces explicitly distinguishes A+/A-, B+/B-, IDX+/IDX- and permits single-ended use by driving only the `+` inputs on hardware designed to support that mode. That is useful compatibility evidence, but it does not justify burdening this base board with a native single-ended mode when an adapter can perform that conversion cleanly.

## Receiver selection

Working receiver: **TI AM26LV32E**, 3.3-V quad differential RS-422 receiver.

Datasheet-supported reasons:
- TIA/EIA-422-B receiver class;
- 3.3-V supply, directly compatible with a 3.3-V FPGA I/O bank;
- up to 32-MHz switching rate;
- +/-7-V common-mode range;
- +/-200-mV differential sensitivity;
- internal open-circuit fail-safe;
- bus-pin ESD protection, including IEC ratings on the E variant;
- partial-power-down/Ioff behavior;
- four receivers per package.

Primary manufacturer reference:
- https://www.ti.com/product/AM26LV32E

The older 5-V AM26C32 is also proven and common, but the 3.3-V AM26LV32E removes an unnecessary logic-level translation/supply dependency for the ECP5 design.

## Termination and protection direction

Each differential A, B and Z pair SHALL have a **120-ohm differential termination option at the receiving end**. Make it independently DNP/configurable per pair so the board can be used correctly when it is not the only load or when field topology requires a different termination decision. Do not add arbitrary bias resistors by habit: the selected receiver already provides open-circuit fail-safe behavior, and any external bias network changes line loading/common-mode behavior and must be justified against the actual encoder driver.

Use low-capacitance machine-side ESD/transient protection selected for RS-422 signal integrity. Place protection at the connector before long PCB routing. The exact TVS array remains a PCB/BOM selection task because working voltage, capacitance and surge environment must be checked together.

Provide encoder signal common/reference at the connector. Treat cable shield separately from signal common: shield gets a deliberate chassis/functional-earth termination strategy at the connector boundary rather than being silently tied into FPGA digital ground through a signal pin.

## Isolation decision

**Base-board working decision: do not put digital isolation in each A/B/Z path by default.**

Reasoning:
1. RS-422 differential signaling already addresses the primary signal-integrity/common-mode problem and is the normal industrial encoder electrical interface.
2. Per-channel isolation multiplies cost, propagation skew, isolated-power complexity and channel count.
3. The controller's machine-power/ground and connector/shield architecture still needs deliberate EMC design.
4. Where a machine requires galvanic isolation because of long ground offsets or encoder-domain constraints, use an isolated encoder interface daughterboard/adapter or promote an isolated variant after machine inventory proves it is broadly required.

FlexiHAL demonstrates that full isolation is a valid stronger architecture; this project is intentionally not copying that cost/complexity into every encoder channel without a requirement.

## Channel/rate freeze

Base board SHALL provide **4 native differential quadrature encoder channels**, each with A+/A-, B+/B-, Z+/Z-.

Why four:
- covers two independent linear scales plus spindle and one spare/auxiliary feedback channel on demanding machines;
- remains compact: 12 differential receivers = three quad receiver ICs;
- avoids immediately consuming FPGA/connector area for 6-8 channels that many machines will never use;
- expansion can remain a future board/interface concern.

Electrical design target: **10 MHz maximum input transition rate per A/B/Z input** for the supported contract. The selected 32-MHz-class receiver leaves substantial electrical bandwidth margin. The FPGA encoder logic must be verified at a clock/routing constraint that safely exceeds this input contract. Do not advertise the receiver's 32 MHz as the board's guaranteed encoder count rate without end-to-end timing verification.

For quadrature A/B at 10 MHz edge/event rates, document the distinction between signal frequency, transition rate and x4 count rate in the eventual user specification; do not conflate them.

## Index behavior

Z/index is a first-class differential input on every native channel, not a shared or optional FPGA-only pin. FPGA/HAL semantics must preserve LinuxCNC-style index-enable/latch behavior while also exposing raw/diagnostic index state where useful.

Open-circuit fail-safe HIGH is **not** a valid encoder-health witness. A disconnected cable can therefore produce static logic states that are electrically deterministic but semantically invalid.

## Diagnostics / authority semantics

The block must keep these layers separate:

1. differential receiver logic A/B/Z;
2. legal quadrature transitions and direction;
3. index observation/latch;
4. motion plausibility/activity diagnostics;
5. FPGA sample generation/freshness;
6. host transport VALID/FRESH state.

The receiver cannot prove cable presence merely because its output is a defined logic level. Firmware should count illegal A/B transitions and expose them diagnostically. A lack of illegal transitions also does not prove encoder health: a disconnected or stationary encoder can look static.

For safety- or process-critical feedback, plausibility/disagreement monitoring belongs above this electrical receiver and may require independent sensing. This encoder block is normal-control feedback hardware, not a safety-rated feedback subsystem.

## Single-ended compatibility

**Differential-only on the base connector.** Single-ended TTL/open-collector encoder support belongs on an external adapter that creates a valid differential pair and handles the source's pull-up/voltage requirements. This keeps the main-board receiver topology predictable and prevents ambiguous field wiring modes from weakening the industrial default.

## Verification classification

- Differential RS-422 topology: REFERENCE-PROVEN / DATASHEET.
- AM26LV32E electrical suitability: DATASHEET + CALCULATION.
- 120-ohm termination option: STANDARD INTERFACE ENGINEERING; verify against each encoder/cable topology.
- 10-MHz board contract: requires INTEGRATION timing test on final FPGA/PCB before final production claim.
- ESD robustness: exact TVS selection + BENCH/EMC testing later.
- Cable-disconnect detection: NOT PROVIDED by receiver; higher-level diagnostic only.

## Result

The encoder block no longer needs a broad schematic hunt before architecture freeze. Use four 3-channel differential A/B/Z inputs, AM26LV32E-class 3.3-V receivers, configurable 120-ohm termination, connector-edge low-capacitance transient protection, explicit signal common and separate shield/chassis strategy. Keep single-ended and galvanically isolated variants outside the base path unless a real machine requirement promotes them.
