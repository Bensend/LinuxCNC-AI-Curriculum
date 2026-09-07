# S03-013 — Accepted Mutable LLIO Communication-Loss Result

Status: **PASS / TEST-CONFIRMED within stated host-side scope**  
Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Curriculum source commit: `baf93443d1e8793640c58f81050cdb9a53be0979`  
Workflow run: `34102334339`, attempt 1  
Lab UTC: `2026-09-07T08:45:58Z` — `2026-09-07T08:49:19Z`  
Artifact digest: `sha256:d1862d5642924ee63b7f4efce8c2c73cad93177e4b15d12b514a798c8c03424f`

## Predeclared prediction

After a known fresh IOPort publication, persistent LLIO `io_error` will leave the previous HAL input visible even when the fake backing register changes, and normal HostMot2 writes will stop reaching the LLIO write callback. Clearing `io_error` will permit fresh host publication and LLIO write activity to resume when the fake LLIO itself succeeds.

## Harness validity

This run used the materially redesigned test-only `hm2_test` derivative documented in `S03-013-harness-attempts-and-redesign.md`:

- production `hostmot2.c` was not patched;
- the fake board registered through normal `hm2_register()`;
- test hook pointer storage was allocated from `hal_malloc()`, satisfying the pinned HAL API requirement;
- one fake IOPort input word was mutable at LLIO level;
- LLIO writes were counted/captured below HostMot2;
- persistent error used the HostMot2-owned `hm2_test.0.io_error` parameter.

The lab's own exit code was **0**.

## Gate A — fresh baseline: PASS

Observed after changing the fake input backing word to `1`:

- `hm2_test.0.gpio.000.in = TRUE`
- baseline LLIO write count after an output transition = `1067`

The write count then advanced to `1069` before the fault-window count was captured. This establishes that registration, input publication, and write observability were live before fault injection.

## Gates B/C — persistent error: PASS

With `hm2_test.0.io_error = TRUE`:

- the fake backing input was changed from 1 to 0;
- visible `hm2_test.0.gpio.000.in` remained `TRUE`;
- LLIO write count before output change = `1069`;
- LLIO write count after output change and fault interval = `1069`.

Therefore the previously published HAL input remained visible while fresh backing state differed, and ordinary LLIO write-callback activity did not advance during persistent `io_error`.

This independently confirms the central S03 host-side prediction at the pinned revision.

## Gate D — host recovery after clear: PASS

After clearing `hm2_test.0.io_error`:

- the changed fake backing input became visible as `hm2_test.0.gpio.000.in = FALSE`;
- LLIO write count advanced from `1069` to `1126`.

This establishes that clearing the persistent error permitted normal HostMot2 host processing to resume against a successful fake LLIO.

It does **not** establish that a real FPGA, remote I/O device, drive, or machine has resynchronized safely.

## Result classification

### TEST-CONFIRMED at this revision

- Persistent LLIO `io_error` can leave a previously published HostMot2 HAL input visible while fake backing state has changed.
- Persistent LLIO `io_error` suppresses normal HostMot2 write delivery to the LLIO write callback.
- Clearing the error permits later normal HostMot2 read/publication and LLIO write activity to resume when the LLIO succeeds.

### SOURCE-CONFIRMED + independently supported

The result matches pinned `hostmot2.c` early-return behavior in `hm2_read_request()`, `hm2_read()`, and `hm2_write()` and the low-level API contract for `io_error`.

### Explicitly NOT established

This no-hardware fixture does not test or certify:

- actual Ethernet UDP loss, duplication, reordering, NIC behavior, or timeout timing;
- the exact physical hm2_eth packet-error escalation timing;
- FPGA register contents or firmware watchdog timing/state;
- board connector electrical state;
- Smart Serial remote state;
- drive enable/STO/torque/brake behavior;
- machine motion or stopping time;
- automatic or safe resynchronization of real hardware;
- functional-safety performance.

## Adversarial interpretation

A frozen HAL value during persistent communication failure is **last-published state**, not proof of a fresh unchanged measurement. Likewise, a changed host-side output command during `io_error` is not evidence that the changed command reached LLIO/hardware. After error clear, resumed host processing is necessary evidence of recovery but is not sufficient evidence of machine-safe recovery.

## Experiment conclusion

**Prediction matched.** The S03 independent-verification blocker is satisfied for the intended 1000-level generic HostMot2 host behavior. Remaining physical/network-specific recovery questions belong to the promotion queue rather than overturning this result.