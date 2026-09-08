# C04-027 — accepted source-corrected recovery result

Status: **TEST-CONFIRMED / ACCEPTED**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Authoritative execution:

- source commit: `4a9412e0d83dedfcd32bd6543cd0cf00231d40bf`
- workflow: `34244865738`
- job: `102124147558`
- artifact: `10063683101`
- artifact digest: `sha256:92ac51305fe827fa3f18ac7d4131b42798effe9103adb121df1e35f69159a33a`
- retained raw trace SHA-256: `2e4a924e10766a2cc8b4c5834cb89a94c5c423968a2965f1104889e597edec73`
- raw trace: `14268` rows, `2427798` bytes
- inner exit: `0`

All frozen C04-027 Gates A–H passed.

## Decisive metrics

- phase-1 `S1 = 0 in`
- phase-2 `S2 = 0.230824132 in`
- phase-3 `S3 = 1.477344334 in`
- phase-4 `S4 = 0 in`
- phase-3 longest B-saturated-at-`+1.0` interval: `3018` consecutive rows
- PID A unsaturated fraction over that interval: `1.0`
- phase-4 B unsaturated fraction, final 500: `1.0`
- phase-4 B saturated-count-zero fraction, final 500: `1.0`
- phase-4 B output nonbinding fraction against `maxoutput=1000`: `1.0`
- same-stage cross-coupling arithmetic residuals: exactly zero

## Raw realtime verification

End-of-phase-3 rows prove the local authority condition directly in one servo observation: plant gains A/B are `1.0/0.35`, `pidB.output=1.000000`, `pidB.saturated=1`, `saturated-count` exceeds 3000, and B `maxoutput=1.000000` while PID A remains unsaturated.

The first scored phase-4 rows immediately show the source-corrected state transition: plant gains are restored to `1.0/1.0`, B `maxoutput=1000.000000`, `pidB.saturated=0`, and `saturated-count=0`. The initial recovery PID-B output is only about `11.8`, already far below the 1000 sentinel. By the end of phase 4 both feedbacks and both outputs have converged exactly while saturation remains clear.

## Reconciliation with C04-026

C04-027 does not overwrite C04-026. C04-026 remains a valid behavioral failure that discovered a pinned-source transition property: an enabled PID moving directly from a binding nonzero `maxoutput` to zero skips the `limit_state` update block, so saturation telemetry can remain stale.

C04-027 tests the same physical-control proposition while using a finite nonbinding phase-4 sentinel. Because `maxoutput != 0`, `calc_pid()` traverses the branch that explicitly sets `limit_state=0` when the calculated output is inside the bound. The raw trace proves that happened and that the sentinel itself never bound.

## Durable C04 conclusions

1. A shared trajectory plus explicit cross-coupling does not guarantee equal achieved position when one side has weaker plant response or less local software output authority.
2. Local PID output saturation can coexist with a correctly signed active cross-coupler and sustained A/B disagreement.
3. Same-cycle `pid.output`, `saturated`, duration telemetry, current limit setting, corrected commands, and feedback are required to make the software-authority observation auditable.
4. At the pinned revision, saturation telemetry is not memoryless across a dynamic `maxoutput -> 0` transition. Interpret it with current configuration, enable state, transition history, and pinned source.
5. Recovery of this deterministic fixture after restoring plant symmetry and a source-aware nonbinding authority setting proves reversibility of the toy condition, not physical-machine stability or fault diagnosis.

Safety boundary remains:

```text
PID software saturation
!= physical actuator stall
!= drive current limit
!= hydraulic pressure/flow limit
!= sensor fault diagnosis
!= safety-rated fault decision
```
