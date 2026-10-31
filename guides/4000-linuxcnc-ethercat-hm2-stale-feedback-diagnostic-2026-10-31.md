# 4000 LinuxCNC field diagnostic card — stale EtherCAT and Mesa feedback

**2026-10-31 | source-grounded engineering exercise | not a validated machine configuration.**

This card contrasts [EtherCAT ECAT-13](../research/4400_LINUXCNC_ETHERCAT_13_WKC_FRESHNESS_CROSS_THREAD_SOURCE_AUDIT_2026-10-31.md) and [HostMot2 HM2-ETH-14](../research/4400_LINUXCNC_HM2_ETH_14_PPOLL_IRQ_TIMEOUT_COUNTER_SOURCE_AUDIT_2026-10-31.md).

## Two distinct failure surfaces

| Mechanism | Ordinary control observation | What to inspect | Misleading shortcut |
|---|---|---|---|
| EtherCAT Sync Unit has no new generation | `fresh=0`; previous complete image may still run through `proc_read` | Per-unit `stale-count`, `wkc-state`, master/slave state, thread phase, `addf` order | Assuming `proc_read` implies fresh physical input |
| EtherCAT new generation, incomplete exchange | `fresh=1` is possible even when per-unit WKC incomplete | WKC and generation separately; timestamp their sampling threads | Treating `fresh=1` as a complete exchange certificate |
| EtherCAT slow unit not due this bus tick | Master WKC includes last state for that unit | XML cycle divider/phase and per-unit WKC | Treating master COMPLETE as all units exchanged this tick |
| HostMot2 UDP soft read failure | HAL feedback may remain at last published value | `packet-error-total`, `read.tmax`, `io-error`, network/IRQ affinity | Calling unchanged encoder feedback a fresh measurement |
| HostMot2 late full-length wrong read count | Conditional source path may return success | Read-count and write-count fields, exact receive timestamp | Assuming no packet error proves payload belongs to current request |

## Hands-on review without running a machine

Given a real INI/HAL/XML set, draw the chain from physical encoder/slave to HAL pin, then through the realtime consumer to actuator output. Mark every `addf` thread and read/write order. On a timing diagram, put the EtherCAT fast bus tick and slow unit tick on separate rows; place `ecrt_domain_process`, image publish, WKC update, `fresh` update and `proc_read` in their source order. Separately, place Mesa `read-request`, socket receive, `read`, control consumer and `write` in the servo period.

For an adversarial review, ask: can `fresh=1` coexist with incomplete WKC? Can master COMPLETE include an unscheduled unit's old state? Can a packet-error counter stay unchanged on a full-length mismatched-read-count branch? Why do these observations not prove a safety-rated stop? The answer requires citing the exact source branches, not guessing from pin names.

**No installation authority:** Do not change production NIC IRQ affinity, drive PDOs, timeouts, safety wiring or motion limits based solely on this card. Record actual firmware/driver versions and isolate any experiments. Existing OpenPressBrake G0/G1 HOLD remains unchanged.
