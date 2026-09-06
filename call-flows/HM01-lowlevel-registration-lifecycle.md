# HM01 — low-level driver to HostMot2 registration lifecycle

Course level: 1000 foundations  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

This guide joins the transport/board-facing `hm2_lowlevel_io_t` contract to generic `hm2_register()` initialization, module-descriptor dispatch, rollback, HAL function export, and unregister. It deliberately does not teach Ethernet packet mechanics, detailed IDROM field semantics, TRAM cycle timing, or watchdog safety claims; those belong to E01, HM02/HM03/HM09, and HM08/S-series.

## 1. The LLIO contract

Source: `src/hal/drivers/mesa-hostmot2/hostmot2-lowlevel.h`.

`hm2_lowlevel_io_t` is the abstraction passed upward by a concrete board/transport driver. The structure is better understood as one low-level board instance than as a driver class.

### Identity / ownership fields

- `name[HAL_NAME_LEN+1]`: HostMot2-facing board name; must be valid/terminated before registration.
- `comp_id`: HAL component ID owned by the low-level driver.
- `private`: low-level-driver private instance pointer.
- connector metadata: `num_ioport_connectors`, `pins_per_connector`, connector names, optional per-I/O pin names.
- optional `fpga_part_number` and `num_leds` metadata.

### Required hardware-access callbacks

`read(self, addr, buffer, size)` and `write(self, addr, buffer, size)` are required. The header contract says success is nonzero; failure is zero and must set `*io_error` true. Generic HostMot2 cannot register a board without these callbacks.

### Optional setup callbacks

- `program_fpga()` allows HostMot2 to program requested firmware.
- `reset()` lets HostMot2/low-level paths reset hardware where supported.

### Optional queued / latency-hiding I/O

The LLIO interface can split servo-cycle bulk reads into queue, send, and receive phases:

- `queue_read()`
- `send_queued_reads()`
- `receive_queued_reads()`

It can similarly split writes into:

- `queue_write()`
- `send_queued_writes()`

If queued callbacks are omitted, `hm2_register()` installs synchronous dummy wrappers around required `read`/`write`, preserving one generic HostMot2 orchestration model. `split_read` advertises that a separate HAL read-request phase is useful. `set_force_enqueue()`/`force_enqueue` support grouping writes on transports that can benefit from it.

### Runtime error/recovery state

- `io_error` is a HAL parameter allocated by HostMot2. The low-level driver sets it on I/O failure; HostMot2 checks it and stops calling normal LLIO operations while set. A user may clear the parameter to allow recovery attempts.
- `needs_reset` / `needs_soft_reset` request reset/recovery behavior after I/O or watchdog failures.
- `read_requested`, `period`, and `read_time` support split-read bookkeeping.
- `threadsafe` controls whether HostMot2 additionally exports GPIO-only read/write functions; it is not a safety certification.

**Evidence:** SOURCE-CONFIRMED at the pinned revision.

## 2. Concrete caller: `hm2_eth` only through the registration boundary

Source: `src/hal/drivers/mesa-hostmot2/hm2_eth.c`.

The Ethernet driver owns board discovery/network setup and an `hm2_eth_t` containing `hm2_lowlevel_io_t llio`. Once a board instance is known, the driver fills the generic contract rather than teaching HostMot2 about sockets:

1. generate `llio.name`;
2. assign the low-level driver's `comp_id`;
3. assign `hm2_eth_read` / `hm2_eth_write`;
4. assign queued read callbacks (`hm2_eth_enqueue_read`, send, receive);
5. assign queued write callbacks;
6. on applicable boards assign `hm2_eth_set_force_enqueue`;
7. assign `hm2_eth_reset`;
8. populate board metadata/capability state around this setup;
9. call `hm2_register(&board->llio, config[boards_count])`;
10. propagate nonzero registration failure back to the low-level load path.

This is the architectural handoff. Ethernet transaction protocol, packet timing, timeout behavior, firewall setup, and discovery details are deferred to E01+.

**Evidence:** SOURCE-CONFIRMED.

## 3. Generic registration path

Entry: exported `hm2_register(hm2_lowlevel_io_t *llio, char *config_string)` in `hostmot2.c`.

Foundation flow:

1. **Validate the LLIO contract.** Reject missing/invalid identity, connector metadata, or required read/write callbacks. Install dummy queued-I/O wrappers where permitted.
2. **Allocate per-board generic state.** Allocate `hostmot2_t`, associate the LLIO, initialize per-board lists/state, tentatively add it to global `hm2_list`, and parse the config string.
3. **Optional firmware phase.** If requested and supported, obtain/check the bitfile, optionally compare FPGA part number, reset if required, and invoke `program_fpga()`.
4. **Firmware identity / IDROM reads.** Generic HostMot2 uses LLIO reads to validate the IOCookie, config name, IDROM type/header, pin descriptors and module descriptors. Invalid reads/data abort registration.
5. **Parse module descriptors.** IOPort descriptors are handled first. Remaining recognized GTAGs dispatch to module-specific parsers such as encoder, PWMGen, StepGen, watchdog, Smart Serial, buffered SPI, UART/PktUART, DPLL, InMux/InM, LED, SSR, OutM, OneShot, PeriodM and related parsers.
6. **Reject parser/I/O failures.** Any module parser returning negative aborts. If `io_error` becomes set while parsing, the parser layer returns `-EIO`.
7. **Complete generic objects.** Allocate TRAM storage, assign pin ownership, export GPIO/raw objects and module HAL state, and perform initial hardware/software synchronization.
8. **Export board-cycle HAL functions.** Successful registration exports `<board>.read` and `<board>.write`; `split_read` can add `<board>.read-request`; `threadsafe` can add GPIO-only functions.

### Unknown GTAG nuance

At this revision, an unrecognized module descriptor GTAG is warned/ignored by the generic parser rather than automatically aborting registration. A *recognized* GTAG whose module-specific parser rejects the descriptor does abort registration. This distinction matters: “unknown descriptor always fails load” is too strong.

**Evidence:** SOURCE-CONFIRMED.

## 4. Module parser ordering and why IOPort is special

`hm2_parse_module_descriptors()` first scans descriptors for `HM2_GTAG_IOPORT` and invokes `hm2_ioport_parse_md()` before the broad GTAG switch. It then scans the descriptor list again, silently skips IOPort entries already handled, dispatches other known GTAGs to their module parser, and ends on GTAG zero.

At each parser call:

- LLIO `io_error` is checked and converts to registration failure;
- `md_accepted >= 0` is success (including a module choosing zero instances);
- negative `md_accepted` is fatal for registration;
- unknown GTAGs take the warning/ignore path.

The detailed meaning and compatibility rules of each descriptor belong to HM02; HM01 only requires understanding the dispatch/rollback boundary.

## 5. Rollback and object lifetime

`hm2_cleanup(hostmot2_t *hm2)` is the generic cleanup aggregator for state allocated while parsing/initializing a board. It frees the pin table when allocated, invokes each module-specific cleanup routine, and cleans TRAM entries/storage and other generic allocations established during registration.

In `hm2_register()`, failures after module initialization converge on `fail1`:

`fail1 -> hm2_cleanup(hm2) -> fail0 -> rtapi_list_del(&hm2->list) -> rtapi_kfree(hm2) -> return r`

Earlier failures can jump directly to `fail0` when module cleanup is not yet required. Thus the tentative `hm2_list` membership is not proof that registration completed; failed registration removes the instance before returning.

**Evidence:** SOURCE-CONFIRMED.

## 6. Unregister boundary

`hm2_unregister(llio)` searches the global HostMot2 list for the instance whose `hm2->llio` equals the caller's LLIO pointer. For a matching registered board it performs the HostMot2 shutdown path, including the already-documented immediate watchdog action when a watchdog instance exists, then generic cleanup, list removal and object free. A missing match logs and returns.

The watchdog action is functional machine-control behavior only in HM01. No claim is made here that it is safety-rated or sufficient for a machine hazard-control function.

## 7. Upstream no-hardware test vehicle

The pinned upstream tree contains `tests/hm2-idrom`, whose README explicitly states that it tests `hm2_register()` using `hm2_test`, a fake AnyIO low-level driver with a static register file and no hardware.

`hm2_test.c` demonstrates the same contract from the opposite direction:

- calls `hal_init()` for the low-level component;
- zeroes its LLIO structure;
- provides connector metadata;
- selects compiled-in register-file test patterns;
- sets LLIO `read`, `write`, optional program/reset and private state;
- invokes `hm2_register()`;
- reports registration failure for intentionally malformed patterns.

The upstream `tests/hm2-idrom/test.sh` enumerates malformed firmware/IDROM cases and requires specific diagnostics (invalid cookie, config name, IDROM type/width/port/clock/pin inconsistencies). In userspace, `check-dmesg.py` deliberately reads captured `halrun-stderr` rather than kernel `dmesg`, making this suitable for the curriculum's Actions uspace lab.

This is a better HM01 experiment than inventing a fake transport: it exercises LinuxCNC's own fake LLIO and its own expected rejection paths at the exact pinned revision.

## 8. Function/symbol map

| Symbol | Layer/context | Foundation responsibility |
|---|---|---|
| `hm2_lowlevel_io_t` | low-level/generic interface | board identity, capabilities, callbacks, error state |
| `hm2_eth_*` callback population | low-level Ethernet driver | populate LLIO then call generic registration |
| `hm2_register()` | generic HostMot2 init | validate LLIO, interpret firmware model, instantiate modules/HAL, export cycle functions |
| `hm2_parse_module_descriptors()` | generic HostMot2 init | IOPort-first parse, GTAG dispatch, propagate parser/I/O failures |
| module `*_parse_md()` | generic module drivers | validate/instantiate one firmware module type |
| `hm2_cleanup()` | generic teardown/rollback | free module/TRAM/pin state created during registration |
| `hm2_unregister()` | generic teardown | find registered LLIO, shutdown/cleanup/unlink/free |
| `hm2_test_read/write()` | fake low-level driver | provide static no-hardware register access for tests |

## 9. Claims to test now

The bounded HM01 lab should test only architecture/validation claims that the fake board can establish:

1. the pinned upstream no-hardware `hm2_test` path genuinely reaches `hm2_register()`;
2. malformed firmware/IDROM patterns are rejected with the declared diagnostics rather than silently registering;
3. the complete upstream `hm2-idrom` matrix passes in the same userspace build used by this curriculum;
4. no conclusion is drawn about Ethernet timing, physical hardware, realtime deadlines, watchdog safety, or successful hardware registration.

A successful invalid-IDROM test matrix is useful evidence for registration *validation and failure propagation*, not for successful operational I/O.

## 10. Promotion / uncertainty queue

| Item | Destination | Priority | Blocks HM01? | Reason |
|---|---|---:|---|---|
| exact IDROM and descriptor compatibility semantics | HM02 / 2000 | HIGH | no | dispatch boundary is sufficient here |
| TRAM address packing and read/write cycle order | HM03/HM09 | HIGH | no | downstream module |
| Ethernet discovery/packet/timeout/recovery mechanics | E01-E08 | CRITICAL downstream | no | LLIO handoff now established |
| watchdog register and safety consequence | HM08/S-series | CRITICAL | no | no safety claim is needed for HM01 |
| hotplug, re-registration and unusual partial-failure lifetime edges | 2000 | MEDIUM-HIGH | no | foundation rollback path is clear |
| experimentally observing successful fake-board registration | 2000 or HM02 fixture extension | MEDIUM | no | upstream fixture is rejection-oriented; successful-path architecture is source-confirmed |
