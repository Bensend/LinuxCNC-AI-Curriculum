# 4000 — LinuxCNC/Mesa Smart Serial diagnostic and implementation acceptance guide

**Audience:** fresh AI engineer reviewing a Mesa 7I76/7I77/8I20 or other Smart Serial machine. **Evidence:** source/documentation only; all tests below **NOT RUN**. **Version pins:** LinuxCNC v2.9.10 and development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. Do not run on powered machinery or infer personnel-safety authority.

## Source map and entry points
- [SSERIAL-54](../research/4400_LINUXCNC_SSERIAL_54_MULTI_REMOTE_FAULT_SCAN_EARLY_RETURN_SOURCE_AUDIT_2026-10-31.md): per-remote fault scanner and [review-only one-line patch](../patches/4000_LINUXCNC_SSERIAL_54_REMOTE_FAULT_SCAN_v2.9.10_REVIEW_ONLY.patch).
- [SSERIAL-55](../research/4400_LINUXCNC_SSERIAL_55_WAIT_MASK_PARAMETER_ACK_FAILURE_SOURCE_AUDIT_2026-10-31.md): version-sensitive DoIt mask, parameter acknowledgment and shadow.
- [SSERIAL-56](../research/4400_LINUXCNC_SSERIAL_56_REAL_8I20_7I77_HAL_ORDER_FRESHNESS_SOURCE_AUDIT_2026-10-31.md): Smithy 8I20 HAL, 7I77 architecture, read/write freshness and port counter.
- Original source: [stable sserial.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/sserial.c), [development sserial.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/sserial.c), [stable hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.c), [real Smithy HAL](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/1240combined.hal), [2.9 Smart Serial manual](https://linuxcnc.org/docs/2.9/html/man/man9/sserial.9.html).

## Reconstruct the servo transaction before diagnosing
```text
FPGA/board TRAM -> hm2.read (board-level io_error / EAGAIN gate)
  -> hm2_sserial_process_tram_read -> each remote's CS + input pins
  -> motion / PID / machine-specific HAL components
  -> hm2.write -> hm2_sserial_prepare_tram_write
      -> port state machine -> check_remote_errors
      -> DoIt/transfer fault counter -> pack eligible channel outputs
  -> TRAM write to FPGA -> remote serial transport
```
A port `fault-count`, a remote fault bit, a HostMot2 board `io_error`, and a fresh application sensor observation are **four different witnesses**. They must not be conflated.

## Frozen acceptance cases (software-only, disconnected)
| ID | Setup / injected state | Predeclared source prediction / oracle |
|---|---|---|
| R1 | Two remotes, CS0=0, CS1=0x01000100, seen masks 0 | Current checker returns before CS1; proposed `continue` patch logs channel-1 watchdog once |
| R2 | CS0=0x01000100, CS1=0 | Current checker logs CS0 but returns 0 on CS1; patch preserves nonzero return |
| R3 | R1 patched, call twice with unchanged status | Only first call logs; `seen_remote_errors` suppresses repeat |
| W1 | wait selected channel 1, data error=0x02, DoIt cleared | Stable comparison mask misses; development bit-shift mask catches |
| W2 | selected channel 2, error=0x04 | Stable misses; development catches |
| W3 | selected channel 2, error=0x01 | Stable spuriously catches bit0; development does not |
| P1 | parameter update state5, fake wait=-1 | Both revisions advance and set `*_written` despite failed wait |
| P2 | port startup state2, fake wait=-1 | Both advance to state3 despite failed wait; actual port readiness not established |
| P3 | repeat unchanged parameter after P1 | Shadow equality can prevent retry; do not assume nonvolatile write |
| F1 | completed-but-failed transfer every servo cycle, defaults 10/1/200 | Counter rises by net 9/call, reaches 207 after 23, stop check on 24th |
| F2 | remote fault bit set but no DoIt/transfer error | Fault scanner can log fault without incrementing port counter |
| F3 | channel transfer error but board TRAM read succeeds | `process_tram_read` still calls channel reader; no per-channel freshness guard in inspected code |
| O1 | Smithy BLDC current changes after `hm2.write` | New BLDC value not packed by that same iteration's write |
| D1 | Copy `.run_state` or `.error-count` from 2.9 prose | Inspected driver actually exports `.port_state` / `.fault-count`; installed HAL enumeration is oracle |

**Do not mark any PASS** from this source prediction table. R/W/P require a fake-remote or fake-register harness with deterministic initialization, exact revision, raw return codes, and captured error log. F3 needs an explicit per-channel transfer-error image plus before/after HAL input snapshots; it must distinguish *stale retained value* from *invalid updated value* rather than assume either. O1 needs a timestamped software trace of BLDC output, packet packing and write calls; no live current command.

## Minimal mock pseudocode for R1/R2 (not compiled)
```text
init port with two remotes (indices 0 and 1)
set each status and seen_remote_errors=0
capture HM2_ERR messages and return value
call hm2_sserial_check_remote_errors(port)
assert the predicted message count and seen masks
repeat after one-line change; keep all other inputs fixed
```
Build stubs for `hostmot2_t`, `hm2_sserial_instance_t`, `hm2_sserial_remote_t`, and logging; do not assert the full `sserial.c` driver can compile standalone without its RTAPI/HAL dependencies. For W1–W3, stub command/data registers and `r_index` and isolate `hm2_sserial_wait` rather than guessing FPGA behavior. For P1, drive a controllable wait result through the parameter state machine; confirm shadow and state3 independently.

## Practical machine-config inspection (read-only)
On a *qualified, already installed, de-energized/disconnected* machine or software HAL, inspect (do not alter) `halcmd show pin hm2_*.sserial.*`, `halcmd show param hm2_*.sserial.*`, and `halcmd show pin hm2_*.8i20.*` or `hm2_*.7i77.*`. Record actual HAL names, `port_state`, `fault-count`, remote `fault`/status pins, firmware ID and port mode. Verify `addf` ordering from the actual HAL file; do not copy Smithy's PCI/8I20 wiring onto a 7I77 analog servo or a 7I76 stepgen machine. A 7I77 analog command is not a measured encoder position or verified drive enable.

## Acceptance evidence packet
Freeze exact source commit and file blobs, mocked register/status inputs, expected results before execution, test harness SHA, runner identity/isolation, output logs, exit status, observed/expected comparison, and classification. A qualified Actions run must use **only** `[self-hosted, openpressbrake]` with positively established disconnected isolation; never a GitHub-hosted runner, and never modify legacy trigger paths to launch compute. Keep `LAB_COMPUTE_LOG.md` unchanged until authoritative job timestamps exist.

## Failure and authority boundaries
A missing error log is not a clean bus certificate; a decayed counter is not proof that remote status is healthy; `port_state=3` is not a remote parameter-write acknowledgment; a HAL output command is not a physical actuator witness. None is independent personnel-safety authority.

## Fresh-AI adversarial exercise (UNSCORED)
A port has two remotes. Channel 0 has no bit-8 fault; channel 1 has bit-8 and bit-24 set. The operator sees `fault-count=0`, no new remote error log, and unchanged HAL input. Identify **three independent reasons** the evidence cannot certify channel 1 is healthy, then propose a minimal regression with a negative control. Do not consult a hidden answer key or claim blind evaluation. Follow source links above; mark unverified behavior explicitly.

## Promotion/uncertainty queue
| Item | Why deferred | Priority | Blocks this non-graduated source handoff? |
|---|---|---|---|
| Compile and run R1–R3 regression | No verified disconnected self-hosted runner | HIGH | No; blocks TEST-CONFIRMED claim |
| Prove P1/P2 shadow vs remote state | Requires mock driver/RTAPI harness | HIGH | No; blocks runtime/remote assertion |
| Determine F3 exact remote register retention | Needs controlled hardware/FPGA fixture | HIGH | No; source finding is only missing gate |
| Test physical output, watchdog and independent safety | Requires qualified machine evidence | CRITICAL for machine release | Not a software-research graduation claim; physical release remains HOLD |
