# C06-030 — `hm2_test` Fixture Construction Notes

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: pre-implementation source audit; frozen Gates A–H in `C06-030-transport-watchdog-fault-plan.md` remain unchanged.

## Existing fixture inventory

`src/hal/drivers/mesa-hostmot2/hm2_test.c` is expressly a hardware-free pretend low-level driver. At the pinned revision its selectable patterns are numbered 0 through 14. The inspected pattern construction populates IO cookie/config/IDROM fields and, in later patterns, pin descriptors and module-descriptor offsets for parser testing. A repository search of pinned `hm2_test.c` found no explicit `HM2_GTAG_WATCHDOG` construction.

Therefore C06-030 should not assume an existing test pattern already instantiates a watchdog. The authoritative implementation must first prove a watchdog exists after fixture load. If no existing pattern produces one, add a new **lab-only test pattern** rather than modifying an existing upstream pattern, so the curriculum patch is isolated and auditable.

## Minimal watchdog descriptor requirements from pinned source

`watchdog.c:hm2_watchdog_parse_md()` accepts only a descriptor consistent with the watchdog parser's expected shape: one watchdog is used; the descriptor exposes three 32-bit register roles at base + 0*stride (timer), base + 1*stride (status), and base + 2*stride (reset). The parser registers the status address in read TRAM and reset address in write TRAM.

The new fixture pattern therefore needs, at minimum:

- valid HostMot2 cookie/config/IDROM header and clocks;
- module-descriptor-list offset;
- one valid watchdog Module Descriptor with `gtag=HM2_GTAG_WATCHDOG` and a usable clock source;
- base address, register stride, instance count and multiple-registers fields accepted by `hm2_md_is_consistent_or_complain(..., 0, 3, 4, 0)`;
- a terminating zero/invalid descriptor according to the ordinary HostMot2 MD scan rules;
- in-memory timer/status/reset register storage covered by the `hm2_test` register image.

Before an authoritative behavioral run, a preflight must show `hm2_test.0.watchdog.has_bit` and `hm2_test.0.watchdog.timeout_ns` exist. Failure to instantiate them is fixture construction failure, not behavioral evidence.

## Fault injection design boundary

Do not emulate hm2_eth packet-error pins inside generic HostMot2; C06-030's hardware-free experiment is testing the distinction between the **low-level communication contract** (`io_error`) and the **generic HostMot2 watchdog state**. hm2_eth-specific counter escalation remains source/documentation evidence unless a dedicated low-level hm2_eth mock is later justified.

The lab-only `hm2_test` extension should expose deterministic fixture controls with names clearly identifying them as test injections, and should make failed reads set the existing low-level `io_error` state only according to the predeclared fixture rule. It must not add synthetic production-facing pins to `hostmot2.c` or `watchdog.c`.

## Implementation preflight

Before launch, inspect the retained diff and mechanically verify that production files `hostmot2.c`, `tram.c`, `watchdog.c`, and `hostmot2-lowlevel.h` are unchanged from the pinned SHA. The only LinuxCNC-source modification permitted by the frozen design is the fixture/instrumentation patch under `hm2_test` (plus build glue only if strictly necessary to expose the existing test driver in the laboratory build).
