# HM01 — HostMot2 architecture and registration lifecycle (initial research)

Course level: 1000 foundations

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: RESEARCH / SOURCE

## Learning objective

A fresh AI should be able to explain the boundary between the generic HostMot2 core and a low-level transport/board driver, locate the board-registration entry point, trace the major initialization stages from an `hm2_lowlevel_io_t` to exported HAL objects/functions, identify important validation/failure boundaries, and recognize what later modules own (IDROM details, register-cycle timing, watchdogs, hm2_eth transport behavior).

## Official documentation pass

Current LinuxCNC documentation describes HostMot2 as the generic HAL driver for Mesa/litehm2 firmware. The core driver by itself does nothing useful without a board-specific low-level driver; supported transports include PCI, Ethernet, SPI, and EPP. Firmware exposes modules such as encoders, PWM generators, step/dir generators, and GPIO. This establishes the public architecture: generic HostMot2 module model above transport-specific board access.

Historical HostMot2 documentation states the same core/low-level split and describes the low-level driver as the part that registers an actual board with HostMot2. This terminology remains consistent with the pinned source.

## Community / field pass

A useful field boundary for later E01/HM08 work is LinuxCNC issue #2281 and its linked forum history: network latency can cause Mesa Ethernet read completion failures and board shutdown/restart requirements. This is **COMMUNITY-REPORTED / issue-reported** evidence for transport/timing failure investigation, not evidence about `hm2_register()` itself. Preserve it for hm2_eth/watchdog modules rather than contaminating HM01's registration conclusions.

## Pinned source architecture

`src/hal/drivers/mesa-hostmot2/README` gives a source-maintainer architecture sketch that matches the implementation. The intended sequence is:

1. load generic `hostmot2`;
2. load a board/transport low-level driver;
3. that driver builds an `hm2_lowlevel_io_t` and calls `hm2_register(llio, config)`;
4. HostMot2 allocates a per-board `hostmot2_t` and associates the LLIO;
5. configuration/optional FPGA programming occurs;
6. HostMot2 reads and validates firmware identity plus IDROM, pin descriptors, and module descriptors through LLIO callbacks;
7. module descriptors are parsed and per-module drivers allocate state, register TRAM regions, and export HAL objects;
8. TRAM storage is allocated, pin ownership/GPIO objects and raw interface are configured;
9. initial non-TRAM state is forced to hardware, initial TRAM read/write cycles initialize software/hardware state;
10. HostMot2 exports per-board HAL read/write functions, plus split-read or GPIO helpers when LLIO capability flags permit.

## `hm2_register()` boundary

Pinned `hostmot2.c` exports `hm2_register()` for low-level drivers. Before device allocation it validates the LLIO contract: non-null LLIO, printable/terminated name and connector names, connector count, and required `read`/`write` callbacks. Missing queued-I/O callbacks are replaced with synchronous dummy wrappers around the basic callbacks.

It allocates `hostmot2_t`, stores the LLIO pointer, initializes per-board TRAM lists, tentatively links the instance into the global HostMot2 list, and parses the board config string.

If the LLIO supports FPGA programming and firmware is requested, HostMot2 obtains and verifies the bitfile, checks the FPGA part when LLIO supplies a part number, optionally resets the board, and calls `llio->program_fpga()`.

The core then validates actual firmware identity through LLIO reads: HostMot2 IOCookie, ConfigName, IDROM type/header, pin descriptors, and module descriptors. IDROM consistency checks include port width versus LLIO connector width, total I/O width, number of connectors, descriptor bounds, and plausible clock frequencies. Invalid or failed reads abort registration.

After module-descriptor parsing and TRAM allocation, the driver configures pin ownership, exports GPIO/raw HAL objects, force-writes initial non-TRAM module state, performs first TRAM read/process/write initialization, rejects initialization if `io_error` is set, then exports `%s.read` and `%s.write`. LLIOs with `split_read` gain `%s.read-request`; LLIOs marked `threadsafe` gain `%s.read_gpio` and `%s.write_gpio`.

## Failure/unregister path

Most registration failures converge through `fail1`/`fail0`: module-specific cleanup runs when enough initialization occurred, the tentative instance is removed from the HostMot2 list, and its allocated `hostmot2_t` is freed.

`hm2_unregister(llio)` locates the per-board HostMot2 object by LLIO pointer. If a watchdog exists, it first enables it with a 1 ns timeout and force-writes it, explicitly attempting to safe the board immediately; it then cleans module state, unlinks the object, and frees it. If no matching board exists it logs and returns. The functional-safety significance of this action is not assumed; HM08/S-series own that analysis.

## Generic-core versus transport boundary

At foundation depth, the architectural contract is:

- transport/board driver owns discovery and populating an `hm2_lowlevel_io_t` with board identity/capabilities and hardware-access callbacks;
- generic HostMot2 owns firmware-model interpretation, module instantiation, HAL object/function export, TRAM organization, and generic read/write orchestration;
- generic runtime HAL functions call back through the board-specific LLIO for actual transport I/O.

This boundary is central to later `hm2_eth`: Ethernet behavior should be traced primarily by following the LLIO callbacks supplied by `hm2_eth`, not by attributing network semantics to HostMot2 core.

## Evidence ledger

| Claim | Classification | Scope |
|---|---|---|
| HostMot2 core requires a low-level board/transport driver | DOC-CONFIRMED + SOURCE-CONFIRMED | current docs + pinned source architecture |
| low-level driver supplies `hm2_lowlevel_io_t` and calls `hm2_register()` | SOURCE-CONFIRMED | pinned README / exported API |
| HostMot2 validates LLIO contract and firmware identity before completing registration | SOURCE-CONFIRMED | pinned `hostmot2.c` |
| module parsing/TRAM/HAL export occur in HostMot2 core, not the transport driver | SOURCE-CONFIRMED | pinned registration path |
| exported read/write functions eventually use board-specific LLIO operations | SOURCE-CONFIRMED foundation architecture | pinned README + implementation structure |
| Ethernet network latency can produce Mesa communication failures | COMMUNITY-REPORTED / issue-reported | later E-series verification; not HM01 registration evidence |
| watchdog-on-unregister is safety-rated protection | UNKNOWN / must not infer | HM08/S-series |

## Immediate next source work

1. Inventory `hostmot2-lowlevel.h` / `hm2_lowlevel_io_t` fields and classify required callbacks versus capability flags.
2. Trace one concrete low-level caller of `hm2_register()` at the pinned revision (prefer `hm2_eth` only far enough to establish registration ownership; defer network cycle mechanics to E01).
3. Trace `hm2_cleanup()` enough to document HAL/object lifetime and failure rollback.
4. Trace module-descriptor dispatch at foundation depth: how GTAG selects per-module parser and how rejected descriptors fail registration.
5. Then design a bounded HM01 architecture experiment using a simulation/test LLIO if available, rather than requiring physical Mesa hardware.

## Promotion queue

- Exact IDROM/module descriptor semantics — HM02 then 2000 depth, HIGH.
- TRAM registration and register-cycle ordering — HM03/HM09, HIGH.
- Ethernet callback internals, timeouts, packet loss/recovery — E01-E08, CRITICAL downstream.
- Watchdog register behavior and unregister safety consequences — HM08/S-series, CRITICAL.
- Hotplug/re-registration and unusual partial-failure lifetime behavior — 2000, MEDIUM/HIGH.
