# 4000 LinuxCNC HostMot2 Ethernet watchdog and soft-error recovery — disconnected verification

**Status:** review-ready, **ALL CASES NOT RUN**. Prerequisite [WD-84](../research/4400_LINUXCNC_HM2_WD_84_SOFT_PACKET_RECOVERY_REPLAY_ACK_SOURCE_AUDIT_2026-10-31.md), [WD-85](../research/4400_LINUXCNC_HM2_WD_85_FORCE_ENQUEUE_1400_BYTE_CAPACITY_VERSION_AUDIT_2026-10-31.md), [ETH-82](../research/4400_LINUXCNC_HM2_ETH_82_LATE_STALE_REPLY_SEQUENCE_ACCEPTANCE_SOURCE_AUDIT_2026-10-31.md). Do not touch any real Mesa Ethernet network, machine, drive, spindle, hydraulic circuit or physical safety channel. Use only independently qualified disconnected `[self-hosted, openpressbrake]` if execution is justified; never hosted Actions.

## Minimal inspectable execution model
Read [stable watchdog.c](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/watchdog.c#L252-L302), [stable hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hostmot2.c#L94-L174), [stable hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L871-L961). A mock `llio` must record queue_write, set_force_enqueue, flush/send result, `io_error`, `needs_reset`, `needs_soft_reset`, watchdog `has_bit`, and read/write counters **separately**. Do not fake a device acknowledgment by returning send success.

A useful test fixture compiles only necessary source with stubs, or uses an equivalent deliberately labeled **model**, not a claim that an independent LinuxCNC binary ran. Keep source and model outcomes distinct. No test has been executed in this session.

## Frozen cases and expected *source-branch* results
| ID | Injected state/event | Expected branch/result (not observed) | Required evidence |
|---|---|---|---|
| W1 | Healthy queued read, no reset flags | TRAM consumers run; no forced replay solely due to soft-reset | call trace and HAL snapshot |
| W2 | One timed-out read, level=0, default increment=2/limit=10 | `needs_soft_reset=1`, level=2, `-EAGAIN`, no TRAM feedback refresh | status + per-function call order |
| W3 | W2 then `hm2.write`, no `io_error`, no `has_bit` | `hm2_force_write` invoked; configuration writes queued and attempted | exact register write list |
| W4 | W3 forced send fails but does not set `io_error` | forced-flush failure ignored by caller; reset flags can be cleared | send return vs flags after watchdog write |
| W5 | Packet level reaches limit, `io_error=1` | normal `hm2.read/write` blocked pending external clear | error and output witnesses |
| W6 | `watchdog.has_bit=1`, `io_error=0` | watchdog write returns without recovery; manual clear required | has-bit and reset flags |
| W7 | `needs_reset=1`, `has_bit` manually cleared, no io-error | force write attempted; status shadow cleared; no proof of physical output | reset/has-bit/packet ack separated |
| W8 | No watchdog module | watchdog recovery function returns without replay | module descriptor and call trace |
| B1 | Stable enqueue total with trailer exceeds 1400 | no stable size guard before writes (memory consequence only conditional) | address/size and guard-path trace |
| B2 | Development per-write append exceeds capacity | enqueue returns failure, no append | buffer pointer and return |
| B3 | Development trailer would exceed capacity | drops queued packet and returns failure | pointer reset and send count |
| B4 | B2/B3 during forced recovery | caller ignores flush return; no guaranteed `io_error` latch | return propagation trace |

## Numerical, machine-configured walkthrough
The [public MR-1 7i96S HAL](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.hal#L9-L38) specifies watchdog=5 ms; [INI](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.ini#L100-L114) specifies servo=1 ms. A default 80%-period Ethernet read deadline is nominally 0.8 ms. Ask the learner to explain why **one** missed read is neither automatically a watchdog bite nor automatically safe to ignore. Then require a diagram of `read -> motion/PID -> write -> recovery` and separate *feedback freshness*, *driver bookkeeping*, *UDP delivery*, *FPGA watchdog state* and *physical drive authority*.

## Evidence capture and acceptance rules
Freeze the source tag, stub semantics, fault injection timing, expected branches and case IDs **before** running. Capture compiler/toolchain and exit codes; raw call traces, packet sizes, simulated FPGA acknowledgment, and an independent analyzer report. A model-only run can be marked MODEL-TEST, never LinuxCNC TEST-CONFIRMED. Source inspection alone remains SOURCE-CONFIRMED. Any unisolated runner or unexpected network interface => do not execute.

**Failure policy:** At most three materially similar harness failures before ESSENTIAL NOW / PROMOTE / DROP. No physical-machine test, safety claim, upstream submission or graduation follows from passing these cases.

## Adversarial handoff prompts
1. "The watchdog reset flag cleared, so the 7i96S must have accepted every register." Identify the missing acknowledgment.
2. "The development buffer check means a 1401-byte forced replay is successful." Identify the return-propagation gap.
3. "A 5-ms watchdog guarantees five consecutive 1-ms packet losses are harmless." Identify timing and state assumptions.
4. "An `io_error` clear and a `has_bit` clear are the same operation." Trace the two gates.

**Next checkpoint:** [2026-10-31 watchdog recovery handoff](../checkpoints/20261031T234000Z-4000-linuxcnc-hm2-watchdog-recovery-next.md).
