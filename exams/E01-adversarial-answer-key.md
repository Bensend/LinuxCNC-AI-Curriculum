# E01 adversarial exam — answer key and correction pass

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Result: **PASS at 1000-level E01 scope**, subject to the experiment boundary below.

1. `hm2_eth` is a low-level I/O transport driver. It owns Ethernet/socket/backend transaction mechanics and fills `hm2_lowlevel_io_t`; generic HostMot2 owns cookie/IDROM/module interpretation and HAL module construction after `hm2_register()`.
2. `rtapi_app_main()` establishes HAL ownership and network backend/board state. `init_board()` installs backend callbacks; probe communicates with the board, identifies/maps it, fills LLIO callbacks/capabilities/metadata, then calls `hm2_register()`. Generic registration therefore begins only after a usable LLIO abstraction exists.
3. The 200 ms `RECV_TIMEOUT_NON_RT_NS` belongs to direct/non-realtime reads such as probing/initialization. Cyclic queued receive derives a deadline from `packet-read-timeout` and LLIO period (with a minimum effective timeout); it is not the same path or timeout.
4. Expected byte count is necessary but not sufficient. Cyclic read also checks an echoed host read counter to reject stale/out-of-sequence responses. After writes have begun, the board-confirmed write counter detects failure/non-confirmation of the preceding queued write.
5. Wrong-size receive immediately invalidates the aggregate layout, resets queued bookkeeping and records a soft error. A correctly sized but stale read-counter response can be discarded while the receive loop waits for a current response until its deadline; expiration then becomes a communication error path.
6. `record_soft_error()` marks `needs_soft_reset`, packet-error state and increments weighted error accounting. At the configured limit it asserts LLIO `io_error`/packet-error-exceeded. Successful confirmed cycles call the decrement path, reducing accumulated error state rather than treating one prior fault as permanently fatal.
7. A copied-function mock can validate a model of selected branch logic, but it does not execute the production static function, production socket/backend callbacks, layout assumptions, compiler context, or HostMot2 integration. It cannot be labeled TEST-CONFIRMED production hm2_eth behavior.
8. Reset sends a watchdog-register write intended to force a HostMot2 watchdog bite quickly. Source establishes that software mechanism only. Physical output state, watchdog effectiveness, machine hazard response and functional safety require HM08/hardware/safety evidence.
9. Split diagnosis at the LLIO boundary. If probe/identity/`hm2_register()` succeeded, later packet-error/io_error evidence belongs first to queued transport/counter/timeout analysis rather than IDROM discovery. Conversely, a failure before registration completion is not evidence of cyclic packet-loss behavior.
10. Instrument inside production `hm2_eth_receive_queued_reads()` immediately at the wrong-size branch, stale-read-counter comparison, and confirmed-write-counter comparison. Record expected/actual byte count, host and echoed `read_cnt`, host and confirmed `write_cnt`, deadline/remaining-time context, and soft-error level. Compile-time guard the trace and leave branch outcomes unchanged.
11. Require source comparison at both revisions plus documentation/version context, and ideally a bounded experiment when behavior is operationally significant. Do not project current-master backend/firewall controls backward from documentation alone.
12. Safe no-hardware teaching: layer ownership; LLIO handoff; source-defined direct-vs-queued timeout/error/counter logic. Do not promote: physical Ethernet latency/jitter; actual Mesa-board recovery/watchdog output behavior; functional-safety or realtime qualification.

## Adversarial correction result

The exam exposed one scope-control issue: the source trace already reaches deeply into material that later E03/E05/E06/E07 modules will own. E01 should graduate only the architectural/discovery/ownership conclusions. Detailed cyclic timeout, packet-loss and recovery behavior remains source-grounded context and becomes prerequisite material for those later modules, not an excuse to claim they have already graduated.

## Experiment sufficiency decision

No upstream pinned no-hardware hm2_eth transport fixture was found in the inspected test surface. The production receive helpers are static and tightly coupled to board/socket/HAL state. Copying them into a standalone model would not execute production code and would create misleading `TEST-CONFIRMED` evidence. Physical board discovery cannot be reproduced faithfully in the cloud without Mesa hardware/network behavior.

For E01's 1000-level objective (driver architecture and board discovery), a new runtime experiment is therefore **PROMOTED / not graduation-blocking**: retain source-confirmed architecture now; E03/E06 should build fault-injection evidence when a production-path fixture or hardware-capable lab exists. This is not a claim that transport behavior is runtime-confirmed.