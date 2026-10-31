# 4000-LC-SSERIAL-55 — versioned DoIt mask and parameter-write acknowledgment failure

**Status:** SOURCE-CONFIRMED code paths; conditional runtime INFERENCE; NOT TESTED; NON-GRADUATED. First audited 2026-10-31.

## Exact revisions
Stable LinuxCNC **v2.9.10**, `src/hal/drivers/mesa-hostmot2/sserial.c`, blob `2d23131f41f25e0836db53fe2e77d09975a8c744`, [wait lines 61–79](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/sserial.c#L61-L79), [parameter states 1549–1690](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/sserial.c#L1549-L1690). Development **537cf2d765c96b6e75ae1db44e1dc0b9dba906a1**, blob `bf70a0cc307dfbae72de8b3fe8d790184923cf9c`, [wait lines 64–82](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/sserial.c#L64-L82), [parameter states 1460–1601](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/sserial.c#L1460-L1601).

## Mechanism A — stable bit-mask typo, corrected in inspected development
`hm2_sserial_wait` first waits for the DoIt command register to clear. On completion it checks the port data error word for the selected remote index. **Stable v2.9.10** uses `1 < inst->remotes[inst->r_index].index` (relational less-than), while **development** uses `1 << inst->remotes[inst->r_index].index` (bit shift). C comparison produces 0 for channel index 0 or 1, and 1 for channel index 2–7. The stable expression therefore tests no error bit for indices 0–1, and only bit 0 for indices 2–7. Development tests the selected channel bit.

**Scope:** this is the `hm2_sserial_wait` error-after-DoIt path, **not** proof that all Smart Serial error handling fails; `hm2_sserial_write_pins` has a separate low-byte transfer-error check. Reproduce with a fake register word: selected channel 1 and `data_reg_read=0x02` yields no wait error in stable, but error in inspected development.

## Mechanism B — error state overwritten in both versions
The parameter-update state machine `hm2_sserial_update_params` repeatedly calls `hm2_sserial_wait`. A negative return sets `state3=100` (comment: quit/tidy up), **then the same case assigns state3 to the next success state without a break/return**. The inspected development version contains explicit FIXME comments acknowledging this overwrite. In the critical state-5 DoIt acknowledgment, a negative wait result is followed by copying the requested value to `p->*_written`, then moving to state 7 or 8. Later comparisons skip unchanged requested/written values.

**SOURCE-CONFIRMED:** a failed wait can be recorded as a written parameter in the software shadow, and the intended error-recovery state is bypassed. **INFERENCE:** the physical remote parameter may remain unchanged even though the software shadow matches; whether a particular remote applied the command before the timeout is UNKNOWN. The 2.9 [Smart Serial documentation](https://linuxcnc.org/docs/2.9/html/man/man9/sserial.9.html) says unchanged values are not rewritten and nonvolatile values may need a power cycle; neither statement proves an acknowledgment occurred.

The normal run/stop transition also tests `if (hm2_sserial_wait(...) > 0) break;` and advances state on both zero and negative returns (stable states 2/5 at lines 1875–1894; development states 2/5 at lines 1793–1815). Do not equate `port_state=3` with a verified successful start.

## Minimal frozen acceptance matrix (not executed)
| Case | Input | Stable source prediction | Development source prediction |
|---|---|---|---|
| W1 | selected index 1, error word 0x02, command cleared | wait returns 0 | wait returns -1 |
| W2 | selected index 2, error word 0x04, command cleared | wait returns 0 | wait returns -1 |
| W3 | selected index 2, error word 0x01, command cleared | wait returns -1 (wrong channel) | wait returns 0 |
| P1 | state5, wait returns -1 | writes `*_written`, advances | same; FIXME in source |
| P2 | state2 startup, wait returns -1 | transitions to state3 | same |
| P3 | change same parameter after failed wait | shadow equality can suppress retry | same |

W1–W3 assume a valid `r_index` and initialized remote array; P1–P3 require a controlled fake wait return. These are **predeclared predictions**, not measured results.

## Function/authority boundary
The realtime `hm2_write` path queues port commands; it cannot certify the remote's nonvolatile memory or servo amplifier's actual behavior from a software shadow. Test only in an isolated unit harness; no drive-power, no safety claim. An upstream patch should first add error propagation and a failed-write retry oracle, rather than blindly changing state without a regression.

## Evidence ledger
- Stable comparison typo / development correction: **SOURCE-CONFIRMED**, exact revisions above.
- Error-state overwrite and premature shadow success in both: **SOURCE-CONFIRMED**; remote divergence **INFERENCE**.
- Existing upstream test coverage or real-machine incidence: **UNKNOWN**.
- TEST-CONFIRMED: **none**; no build, simulation, hardware or Actions compute.
