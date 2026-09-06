# IO01 — HostMot2 quadrature encoder register-to-HAL source guide

Course level: 1000
Status: SOURCE
Primary LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Stable compatibility baseline remains `86cdca76fa2a36274c432caa21952b23c267989a`; this artifact does not silently generalize the pinned development behavior to stable.

## Objective and scope

Trace the normal HostMot2 incremental/quadrature encoder host path from module-descriptor parsing and TRAM registration through count extension, reset/index handling, scale application, velocity estimation, and HAL publication. Keep three layers distinct:

1. FPGA quadrature capture/filter/timestamp semantics;
2. HostMot2 host-side sampling and state reconstruction in `encoder.c`;
3. physical encoder signal integrity/electrical behavior.

This 1000-level module does not claim physical encoder correctness, electrical noise immunity, FPGA timing verification, or safety-rated feedback.

## Official documentation pass

Current HostMot2 documentation describes encoder instances with HAL `rawcounts`, `count`, `position`, `velocity`, `reset`, and bidirectional `index-enable`. `rawcounts` is the total un-zeroed count, while `count`/`position` are affected by reset/index. `scale` converts counts to position units. `vel-timeout` controls how long the driver waits for another edge at low speed before declaring the encoder stopped. Current documentation also exposes filtered A/B/index states and quadrature-error reporting. See LinuxCNC stable HostMot2 driver documentation, encoder section, and `hostmot2(9)`.

Evidence: **DOC-CONFIRMED**.

## Source inventory

### `src/hal/drivers/mesa-hostmot2/encoder.c`

Key symbols:

- `hm2_encoder_parse_md()` — validates Encoder/Muxed-Encoder module descriptors, selects instance count, records register addresses, allocates host/HAL state, registers TRAM regions, and exports HAL interface.
- `hm2_encoder_tram_init()` — seeds host state from the already-read FPGA count/timestamp image and establishes a zeroed logical count without pretending the physical counter is zero.
- `hm2_encoder_instance_update_rawcounts_and_handle_index()` — extends the 16-bit FPGA count into the host accumulator, publishes `rawcounts`, and handles index/probe latch completion.
- `hm2_encoder_instance_update_position()` — applies reset/index zero offset, publishes logical count/latch count and scaled position.
- `hm2_encoder_instance_process_tram_read()` — per-instance STOPPED/MOVING velocity/state machine.
- `hm2_encoder_process_tram_read()` — module-level post-TRAM publication entry point.
- `hm2_encoder_read_control_register()` — publishes filtered A/B/index state and quadrature-error state from the control/latch register.
- `hm2_encoder_write()` / `hm2_encoder_force_write()` — maintain control/filter/timestamp/DPLL configuration; these are configuration/output-side paths, not the normal count-publication calculation itself.

Evidence: **SOURCE-CONFIRMED** at pinned revision.

## Descriptor and TRAM registration

`hm2_encoder_parse_md()` accepts documented Encoder and Muxed-Encoder descriptor versions and rejects inconsistent descriptors or a configured encoder count exceeding firmware instances. It assigns register blocks from the module base plus descriptor stride.

The important read ordering is explicit in source comments and registration order:

1. timestamp-count register is registered first;
2. counter/timestamp registers for encoder instances are registered after it;
3. latch/control registers are registered afterward.

The source states that the timestamp counter must be read before the counter/timestamp registers. This ordering matters because event timestamps are interpreted relative to the sampled timestamp counter.

Evidence: **SOURCE-CONFIRMED**.

## HAL interface relevant to IO01

Per-instance exports include at least:

- `rawcounts` — un-zeroed host-extended count;
- `rawlatch` — extended latched raw count;
- `count` — reset/index-adjusted logical count;
- `position` — logical count scaled by `scale` (internally using the 64-bit count accumulator for float position);
- `velocity` and `velocity-rpm`;
- reset/index/latch controls and status;
- current filtered A/B/index input state;
- quadrature-error enable/status on supporting firmware.

Module-wide encoder controls include sample frequency and timestamp-resolution selection; muxed encoders can expose skew and DPLL-related controls when supported.

## Count reconstruction

The FPGA-facing register count is 16 bits. The host does not simply publish that 16-bit value. `hm2_encoder_instance_update_rawcounts_and_handle_index()` calls `hal_extend_counter(..., 16)` against the previous 64-bit accumulator. Therefore ordinary wrap of the 16-bit register is reconstructed into a continuous host-side accumulator as long as the sampling assumptions of the extension algorithm are respected.

The public s32 `rawcounts` pin receives a cast of that 64-bit accumulator, while internal position calculation retains 64-bit state (`rawcounts_64`, `zero_offset_64`, `count_64`) to avoid prematurely losing long-travel precision in the float-position calculation.

Evidence: **SOURCE-CONFIRMED**.

Important boundary: this does not prove arbitrarily large count jumps between host reads can be reconstructed. Exact ambiguity bounds of `hal_extend_counter()` and physical maximum-safe edge rate versus servo/network sampling should be studied at 2000 level or IO03 if needed for fault analysis.

## Reset and index semantics

### Reset

When HAL `reset` is true, `hm2_encoder_instance_update_position()` does not reset the physical FPGA counter. It moves the host zero offset to the current accumulated raw count, then computes logical `count = rawcounts - zero_offset`. Position is derived from the 64-bit equivalent. The reset input is not automatically cleared by this logic.

### Index

When the previous control word says the FPGA was armed to latch on index and the returned latch/control word shows that latch arm has cleared, the driver treats that as an index event. It reconstructs the latched 16-bit value against the pre-update rawcount history. Unless `no-clear-on-index` is active, the resulting extended latch becomes the new zero offset. The driver publishes the raw latch and clears HAL `index-enable` to acknowledge occurrence.

This is a handshake across cycles: host configuration arms FPGA behavior, a later TRAM read returns latch/control state, and host publication turns that into zero-offset and HAL state changes.

Evidence: **SOURCE-CONFIRMED**.

## Position publication

After rawcount/index work, logical count is formed from raw count minus zero offset. Float `position` uses the internal 64-bit logical count divided by `scale`. If `scale == 0`, the processing path diagnoses it as bogus and repairs the parameter to 1.0 rather than dividing by zero.

Evidence: **SOURCE-CONFIRMED**.

## Velocity state machine

The encoder has explicit `STOPPED` and `MOVING` host states.

### STOPPED

If the newly sampled register count equals the previous count and no index/probe search is active, only reset-sensitive position work is needed and the instance returns as stopped. A new edge (or active latch search) transitions processing into MOVING and initializes event timestamp/count history.

### MOVING with a new edge

The host updates rawcount/position, gets the captured event timestamp, extends timestamp rollover accounting, computes count displacement and elapsed timestamp clocks, and derives scaled velocity. A one-edge reversal is treated specially: the code sets velocity to zero to avoid a misleading spike when the encoder is effectively balancing around one edge.

### MOVING with no new edge

No new edge does **not** immediately mean zero velocity. The driver uses the current timestamp counter to calculate elapsed time since the last event. Until `vel-timeout`, it can reduce the magnitude of the reported velocity to the largest value still consistent with there having been no new pulse, and it updates interpolated position. Once elapsed time reaches `vel-timeout`, velocity and rpm are set to zero and state returns to STOPPED.

This explains the documentation statement that low-speed velocity estimation waits several `hm2_read()` iterations rather than dropping to zero after one edge-less read.

Evidence: **SOURCE-CONFIRMED + DOC-CONFIRMED**.

## Quadrature error and input-state publication

The returned latch/control register also carries filtered A/B/index state. `hm2_encoder_read_control_register()` publishes those as HAL pins. Quadrature-error reporting is gated by its enable pin and uses an enable-edge/reset mechanism; disabling reporting clears the published error state. A reported quadrature sequence error is a diagnostic indication from the HostMot2 path, not by itself proof of which physical fault caused it.

Evidence: **SOURCE-CONFIRMED**.

## Failure and reliability boundaries

- Descriptor inconsistency or impossible requested encoder count blocks module setup.
- `scale == 0` is repaired to 1.0 with an error message during runtime processing.
- A quadrature error identifies an invalid sequence reported by the firmware path; electrical noise, wiring, edge rate, signal-level problems, and firmware behavior require separate diagnosis.
- Host count extension assumes sufficient sampling to disambiguate wrapping; exact bounds require explicit analysis/experiment.
- Physical encoder plausibility/redundancy is outside this host-path proof.
- No HAL encoder signal should be described as safety-rated merely because it is realtime or hardware-backed.

## Community research notes

Current community search was used for failure-mode leads around Mesa encoder errors, index behavior, and velocity anomalies. No community-only claim was necessary to establish this 1000-level call path, so no field report is promoted to fact here. Community reports should be used later in IO03 to design fault injection around invalid quadrature sequences, missed/extra counts, index configuration, and stale feedback.

## Evidence ledger

| Claim | Classification | Evidence |
|---|---|---|
| HostMot2 encoder public pins include raw/logical count, scaled position, velocity, reset/index controls | DOC-CONFIRMED | current HostMot2 docs/man page |
| Timestamp TRAM is registered before counter/latch TRAM | SOURCE-CONFIRMED | pinned `hm2_encoder_parse_md()` |
| FPGA 16-bit counts are extended into a 64-bit host accumulator | SOURCE-CONFIRMED | pinned `hm2_encoder_instance_update_rawcounts_and_handle_index()` |
| Reset changes host zero offset rather than resetting raw FPGA count | SOURCE-CONFIRMED | pinned `hm2_encoder_instance_update_position()` |
| Position calculation uses internal 64-bit logical count divided by scale | SOURCE-CONFIRMED | pinned source |
| No new edge while MOVING does not immediately force zero velocity | SOURCE-CONFIRMED + DOC-CONFIRMED | pinned velocity state machine + `vel-timeout` docs |
| A one-edge direction reversal is forced to zero velocity to suppress edge-balancing spikes | SOURCE-CONFIRMED | pinned MOVING/new-event branch |
| Physical electrical integrity or safe-machine feedback is established by these source paths | UNKNOWN / NOT CLAIMED | requires hardware/safety work |

## Promotion / uncertainty queue

| Item | Evidence | Destination | Priority | Blocks IO01? |
|---|---|---|---|---|
| Exact `hal_extend_counter()` ambiguity limit under large inter-sample count jumps | source use identified, not yet independently bounded | IO03 / 2000 | HIGH | No for normal-path 1000 architecture, but important for fault/rate limits |
| FPGA implementation of quadrature decode/filter/timestamp capture | host interface traced only | HM05 / 2000 | HIGH | No |
| Physical maximum reliable edge rate versus transport/servo sampling | not hardware-tested | advanced hardware / 2000 | HIGH | No |
| Quadrature-error causality under injected illegal A/B sequences | source path only | IO03 / 2000 | HIGH | No |
| Index timing relative to control-word write and subsequent TRAM read | source handshake established; precise cycle latency not yet tested | IO02 / 2000 | MEDIUM | No |
| Stable-v2.9.10 behavioral comparison | not yet completed | 2000 | MEDIUM | No |
| Physical encoder plausibility/redundancy/safety architecture | not addressed by HostMot2 encoder driver alone | S04/S05/advanced safety | CRITICAL | No if boundary remains explicit |

## Next step

Build `call-flows/IO01-encoder-register-to-hal.md` around the generic `hm2_read()` completion boundary and inspect upstream fake-LLIO fixtures for whether production `hm2_encoder_process_tram_read()` can be exercised by mutating only the TRAM image. A valid no-hardware lab should test host reconstruction semantics (wrap extension, reset offset, scale, low-speed timeout) without pretending to test FPGA electrical/quadrature capture.
