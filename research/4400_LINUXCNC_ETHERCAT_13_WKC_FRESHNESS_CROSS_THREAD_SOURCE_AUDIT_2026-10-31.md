# 4000-LC-ECAT-13 — EtherCAT Sync Unit WKC is not an atomic freshness certificate

**2026-10-31 | LinuxCNC-first continuation | NON-GRADUATED | static source analysis.** Extends [ECAT-12](4400_LINUXCNC_ETHERCAT_12_SYNC_UNIT_FRESHNESS_LATE_OUTPUTS_SOURCE_AUDIT_2026-10-30.md) without repeating its basic generation/stall findings.

## Question and pinned provenance

When a slow EtherCAT Sync Unit is threaded separately from the fast bus, does `fresh=1` certify that its **same** input image passed a complete working-counter exchange, and does the master WKC represent only the current bus tick?

Inspected maintained external [linuxcnc-ethercat/linuxcnc-ethercat](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat), release commit [`56515f4aac313551346289d9c227193f50e9602a`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/commit/56515f4aac313551346289d9c227193f50e9602a), published 2026-10-29. This is an external HAL driver, **not** LinuxCNC core or a generic EtherCAT master guarantee.

- [`src/lcec_main.c` lines 1663–1700](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec_main.c#L1663-L1700), blob `85fc4a195c1e7c83d27835285e50a9c744e7eecf`.
- [`src/lcec_main.c` lines 1705–1747](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec_main.c#L1705-L1747), master state and aggregate WKC.
- [`src/lcec_main.c` lines 1834–1841](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec_main.c#L1834-L1841), startup/OP scheduling.
- [`src/lcec_main.c` lines 2451–2509](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec_main.c#L2451-L2509), unit read and `fresh`.
- [`src/lcec_syncunit.h` lines 151–174](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec_syncunit.h#L151-L174), blob `7cee2b17e334ec295dcbf2f9cb4b28a8b4035147`, generation/seqlock.
- [`documentation/master-pins.md`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/documentation/master-pins.md), blob `7129de28867f5677883ffbf15e4faa84479e9ccb`, `fresh` and WKC descriptions.

## Source-level causal trace

1. Fast bus `lcec_read_master` receives and, for a Sync Unit whose `queued` flag is set, calls `ecrt_domain_process`. It **publishes the process image to the threaded unit before querying** `ecrt_domain_state`. There is no WKC-complete predicate around `lcec_su_rx_publish`. **SOURCE-CONFIRMED.**
2. The bus then samples that domain's `working_counter` and `wc_state`; only processed units update their per-unit WKC pins. Unscheduled slow units retain the last domain state, which is nevertheless included in the master **aggregate** WKC and aggregate `wkc-state`. Thus master `wkc-state=COMPLETE` can describe a composite of different domain exchange ages, not necessarily a simultaneous all-domains-this-tick exchange. **SOURCE-CONFIRMED implementation semantics; no claim about any physical device.**
3. The slow unit's `lcec_read_sync_unit` fetches a consistent image generation and sets `fresh=1` when generation changed. Its copy is protected by a seqlock, but WKC is **not part of the copied image or generation**. The fast bus publishes the image, then later updates WKC HAL pins; a slow thread may run between those steps. Consequently, pairing a particular `fresh` sample with a WKC HAL sample is not an atomic same-exchange certificate. **SOURCE-CONFIRMED ordering; INFERENCE for actual scheduling interleaving.**
4. `sync_units_started` latches true after the master reaches `EC_AL_STATE_OP` once (the code only assigns true). `force_cycle = !sync_units_started` then ceases; a later loss of OP does not itself re-enable all-domain startup cycling in this path. The regular divider/phase schedule continues subject to other conditions. **SOURCE-CONFIRMED**, not a claim about drive restart or recovery.
5. The `fresh=0` same-generation case can still call slave `proc_read` on the old complete image, as ECAT-12 established. `fresh=1`, `wkc-state=COMPLETE`, `slave-oper=1`, and `phase-locked=1` describe different propositions; none alone establishes physical actuator feedback validity.

## Worked diagnostic cases (source-derived, not executed)

| Scenario | Fresh image? | WKC interpretation | What cannot be concluded |
|---|---|---|---|
| Processed domain has incomplete WKC but bus publishes image | May be 1 if unit fetches new generation | Per-unit state can be INCOMPLETE | New generation does **not** prove complete PDO exchange |
| Unit thread repeats an unchanged nonzero generation | 0 | Last per-unit WKC may remain COMPLETE | `proc_read` can still process old values; no new sample proved |
| Slow domain not scheduled this bus tick | No new generation from that tick | Master aggregation includes its **previous** domain state | Master COMPLETE is not proof all domains exchanged this tick |
| Master once OP, then loses OP | Not determined by OP flag alone | Monitor master/slave states and unit WKC | Do not infer force-startup cycling, successful drive rearm or safe stop |

## Implementation and instrumentation lesson

For a real machine, retain its actual XML PDO/DC/slave configuration, HAL thread periods and `addf` order, then record `lcec.<m>.syncunit.<u>.fresh`, `wkc-state`, `stale-count`, `late-count`, master `wkc-state`, slave operational/state pins and a monotonic timestamp. The exported pins are useful **diagnostics**, but independent HAL reads are not a transactionally latched WKC+image tuple. If same-exchange proof is needed, the implementation would need a generation-tagged WKC/status snapshot published atomically with the image, or an external timestamped bus trace; this is a **design suggestion, not an existing feature**. Record whether a value was observed on the bus thread or the unit thread.

**Evidence:** SOURCE-CONFIRMED code ordering, WKC aggregation, OP latch and HAL freshness definition; DOC-CONFIRMED pin semantics; INFERENCE cross-thread observation window; TEST-CONFIRMED none; UNKNOWN actual partial PDO bytes, master/kernel exchange details, slave watchdog and physical response.

**Safety boundary:** WKC/freshness, normal LinuxCNC, EtherCAT and FPGA are not independent personnel-safety authorities. No machine-specific stopping distance, watchdog action or safety integrity claimed. No tests, workflows or hosted/self-hosted compute. Runner dispatch/physical isolation UNKNOWN.

**Next discriminating question:** check whether any maintained driver offers an exchange-generation-tagged WKC+image snapshot; otherwise compare LinuxCNC HostMot2 error observability or a real multi-rate configuration before proposing instrumentation. No lab is justified just to confirm source ordering.
