# S07-017 — fresh-runtime homing-state reset

Status: **FROZEN BEFORE IMPLEMENTATION**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Prediction

For the stock `tests/linuxcncrsh/linuxcncrsh-test.ini` ordinary-homing fixture, runtime A can establish `joint.0.homed=TRUE`. After orderly launcher shutdown and independent proof that both the linuxcncrsh service endpoint and representative motion/HAL namespace have disappeared, runtime B started from the same unchanged INI will initially expose `joint.0.homed=FALSE` before any new homing command. A new `set home 0` can then re-establish `joint.0.homed=TRUE`.

The same INI surviving both runtimes is a deliberate contrast: persistent configuration is not persistent runtime homing state.

## Gates

A. **Fixture validity / initial state:** runtime A becomes reachable; `joint.0.homed` is observable and initially false before any home request. If it is already true, classify HARNESS_INVALID.

B. **Establish state in A:** enable through the normal linuxcncrsh command path, issue `set home 0`, and observe `joint.0.homed=TRUE` within a bounded wait. Record launcher PID and a representative HAL component/pin listing.

C. **Independent teardown barrier:** request orderly launcher termination. Before starting B, require all three: A launcher PID absent, TCP port 5007 closed, and `halcmd show pin joint.0.homed` no longer succeeds with that pin. Failure to prove all three is HARNESS_INVALID, not evidence of persistence.

D. **Fresh identity:** start runtime B from the same INI only after Gate C. Require a distinct launcher PID and reachable port/HAL pin. PID distinction is supporting identity evidence, not the teardown oracle by itself.

E. **No inherited homed bit:** before any B homing request, require `joint.0.homed=FALSE`. If true, the central prediction is falsified provided Gates C/D passed.

F. **Revalidation:** enable B, issue `set home 0`, and require `joint.0.homed=TRUE` within a bounded wait. This proves the state is re-establishable rather than merely absent.

G. **Configuration contrast:** hash the INI before A and after B and require equality.

## HARNESS_INVALID conditions

Ambiguous teardown; port/HAL namespace surviving the barrier; inability to observe `joint.0.homed`; runtime B not demonstrably distinct; fixture semantics that force homed true without a home request; or INI mutation during the experiment.

## Evidence boundary

PASS demonstrates lifecycle behavior of this pinned software fixture. It does not prove physical position, encoder freshness, drive retention, absolute-encoder semantics, abnormal-crash cleanup, or functional safety. A successful process restart is not machine recovery evidence.
