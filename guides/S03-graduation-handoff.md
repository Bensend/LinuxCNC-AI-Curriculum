# S03 — Communication-Loss Behavior Graduation Handoff

Status: **GRADUATION READY at 1000 level**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## What a fresh AI must know

Communication loss has several different layers and they must not be collapsed into one claim:

1. hm2_eth detects bad/missing transport responses and updates packet-error state;
2. accumulated errors can reach the configured limit and assert persistent LLIO `io_error`;
3. generic HostMot2 host read/write functions observe `io_error` and return before normal fresh publication/write delivery;
4. previously published HAL feedback can therefore remain visible but stale;
5. the HostMot2 firmware watchdog is a separate mechanism that may react when normal servicing stops;
6. FPGA, remote I/O, drive, STO/brake, mechanics, and functional safety require their own evidence.

The central diagnostic rule is:

> **Visible does not mean fresh. Commanded does not mean delivered. Error clear does not mean resynchronized.**

## Evidence chain

### Source

`call-flows/S03-hm2-eth-loss-to-host-stale-state.md` traces the pinned hm2_eth soft-error escalation into `llio.io_error`, then joins it to generic HostMot2 `hm2_read_request()`, `hm2_read()`, and `hm2_write()` failure branches.

### Documentation

Current official `hm2_eth(9)` documentation explicitly discusses stale position feedback during packet loss and documents `packet-error`, accumulated `packet-error-level`, `packet-error-limit`, persistent `io-error`, and manual reset.

### Community

Historical forum evidence shows older hm2_eth revisions had materially different dropped-packet/realtime behavior. This is retained as a debugging lead and as evidence that version pinning matters, not as current-version authority.

### Independent experiment

S03-013 run `34102334339`, source `baf93443d1e8793640c58f81050cdb9a53be0979`, passed with lab exit code 0:

- Gate A: fake IOPort backing `1` published `gpio.000.in=TRUE`; LLIO writes were live.
- B/C: while persistent `io_error=TRUE`, backing changed to `0`, but visible HAL input stayed TRUE and LLIO write count remained exactly `1069` across a host output change.
- D: after error clear, visible HAL input became FALSE and LLIO write count advanced to `1126`.

This TEST-CONFIRMS the generic HostMot2 host-side stale-publication/write-suppression/restart behavior against the test-only mutable LLIO. It is not Ethernet/FPGA/drive/safety evidence.

## Failure-path reasoning

A persistent communication failure does not replace a HAL feedback value with an explicit `UNKNOWN`. Instead, the normal publication path can stop before module state is copied into HAL. That creates a dangerous diagnostic ambiguity: a numerical value can look normal while no longer representing a fresh sample.

A robust diagnostic consumer must carry a freshness/validity state separately from the numerical value.

Likewise, `hm2_write()` early return means a changed HAL command can exist only as host intent. Do not infer a corresponding physical output transition until the delivery path and hardware state are independently established.

## Recovery reasoning

Clearing `io_error` can permit the HostMot2/LLIO host path to attempt processing again. S03-013 proves host publication/write activity can resume against a successful fake LLIO. A real machine recovery policy still needs evidence that relevant board/remote/drive state is fresh, coherent, expected, and safe before ordinary machine enable is restored.

## Adversarial exam result

`exams/S03-communication-loss-adversarial.md` was checked against the completed source and experiment evidence.

A passing answer must reject all of the following shortcuts:

- unchanged encoder value ⇒ axis stationary;
- changed host command ⇒ board received it;
- `io_error` ⇒ firmware watchdog definitely bit;
- watchdog bite ⇒ STO/zero torque;
- cleared `io_error` ⇒ machine resynchronized;
- a historical forum timing report ⇒ pinned revision behaves identically.

The supplied answer key preserves those distinctions and requires an explicit freshness-validity design rather than fabricated feedback.

## Fresh-AI novel scenario

### Scenario

A controller last published axis position `125.0`. Persistent `io_error` then becomes TRUE. A software fault requests drive disable, and the position display remains at `125.0` for several hundred cycles.

### Required reasoning

A fresh AI must conclude:

- `125.0` is the last published HostMot2 value and may now be stale;
- the software disable request proves host-side intent/state only;
- generic HostMot2 may be suppressing new command delivery while `io_error` is set;
- actual motion, FPGA output state, drive enable/STO, torque, brake state, and stopping remain unknown without independent fresh evidence;
- the controller should mark affected feedback invalid/stale rather than present it as a fresh stationary measurement.

This scenario is not answered by one memorized sentence; it requires combining the read, write, fault, and safety boundaries. The handoff passes if the fresh AI reaches those conclusions.

## Promotion / uncertainty queue

| Item | Evidence now | Destination | Priority | Blocks graduation? | Why safe to promote |
|---|---|---|---|---|---|
| Real hm2_eth packet loss/duplication/wrong-size fault injection | source/docs only for transport; S03-013 tests generic host boundary | E03/E06 or 2000 | HIGH | No | generic HostMot2 stale/write-suppression behavior is independently verified without making physical transport claims |
| Exact scheduler/NIC timeout distribution and worst-case detection latency | docs/source architecture only | E05/E07/2000 | HIGH | No | no latency bound is taught by S03 |
| Combined HostMot2 watchdog + Smart Serial remote watchdog + `io_error` recovery ordering | separate source knowledge only | S06/2000 | HIGH | No | S03 explicitly treats mechanisms as distinct and makes no combined-ordering guarantee |
| Real board/drive state resynchronization after communication recovery | not physically tested | commissioning/2000 | CRITICAL | No | course explicitly refuses to teach cleared `io_error` as safe resynchronization |
| Physical STO/brake/torque/stopping behavior | outside host fixture | safety/commissioning | CRITICAL | No | no physical or safety-rated claim depends on it |

## Counterfactual promotion test

If every promoted item behaved differently from current expectation, the central 1000-level claims would remain valid:

- pinned generic HostMot2 stale publication/write suppression under persistent `io_error` is source- and test-confirmed;
- clearing the error only establishes permission/resumption at the host boundary, not safe machine synchronization;
- all physical safety claims remain explicitly outside scope.

Therefore no promoted item can overturn the central teaching, invalidate a downstream prerequisite, invalidate the evidence chain, or weaken an important safety boundary.

## Minimum graduation evidence floor

- [x] Core mechanism identified and traced from actual pinned source
- [x] Behaviorally significant path traced end-to-end
- [x] Independent verification beyond source rereading: S03-013 PASS
- [x] Representative failure path understood
- [x] Predeclared prediction checked and matched
- [x] Fresh-AI novel scenario solved from artifacts
- [x] Three-attempt safeguard applied to invalid harness attempts before material redesign
- [x] Safety/recovery uncertainty explicitly preserved
- [x] Counterfactual promotion test passed

## Graduation decision

**S03 is sufficient to graduate at 1000 level.** The central stale-feedback and write-delivery lessons are now independently verified at the generic HostMot2 host boundary. Deeper transport timing, remote-device recovery, and physical-machine behavior are intentionally promoted with conservative safety boundaries rather than silently assumed.