# E01 checkpoint — transport source trace complete

Session start: `2026-09-06T16:11:01Z`.
Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

E01 has substantively advanced from initial RESEARCH into **SOURCE** depth. Durable call flow: `call-flows/E01-hm2-eth-transport.md`.

Source-confirmed this lesson: backend callback selection; probe-to-`hm2_register()` ownership; fixed 200-ms initialization/direct-read timeout versus cyclic period-derived queued-read timeout; realtime write enqueue behavior; queued read/write batching; read/write counter confirmation; wrong-size/stale-response handling; weighted soft-error accumulation; `llio.io_error` threshold propagation; `needs_soft_reset`; watchdog-bite reset mechanism; and startup/unload cleanup ownership.

Important correction/boundary: a correctly sized UDP response is not alone sufficient for cyclic validity. The pinned path also uses echoed read/write counters. Conversely, direct `hm2_eth_read()` is not forbidden in realtime; it warns because it adds packets/performance cost. Neither the software error policy nor reset callback is a safety-rated claim.

Exact next work: inspect existing upstream hm2_eth tests/fixtures. Design the least-invasive bounded no-hardware experiment capable of driving the queued receive state machine through (1) confirmed success, (2) stale read-count retry, (3) wrong-size receive soft error, (4) threshold assertion of `io_error`, and (5) successful-cycle decrement. If static-function isolation would require invasive source rewriting, record that as harness cost and prefer an upstream fixture or narrow compile-time test seam. Then run exactly one bounded experiment, reconcile artifacts, and proceed to E01 adversarial exam only after semantic evidence is accepted.

Repository-state note: `PROGRESS.md` still labels E01 RESEARCH because the available connector replaces whole files and this session prioritized a durable call-flow/checkpoint without risking collateral loss. A subsequent safe full-file update should change E01 to SOURCE before experiment launch.
