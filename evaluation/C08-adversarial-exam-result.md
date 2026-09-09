# C08 — scored 1000-level adversarial exam

Frozen source: `evaluation/C08-adversarial-exam-draft.md`

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Score: **10/10 — PASS**

The exam was frozen before C08-052 result review. Scoring incorporates the accepted C08-052 evidence without rewriting the questions after output was known.

1. **1/1.** The two `halcmd getp` calls occur at different userspace times and can straddle one or more realtime updates. Subtracting them therefore does not prove a same-servo-cycle following error. For that claim, acquire command and feedback in one realtime observation boundary—e.g. one correctly ordered `sampler` invocation—with retained function order, sample provenance, collector validity and no-loss evidence.

2. **1/1.** The row does not prove that the sampled fault caused the sampled zero output in one common producer invocation because the sampler crossed two different producer boundaries: it observed the updated fault but potentially the previous output. The strongest claim is only that, at the sampler invocation, `fault=1` and the currently visible `output=0` coexisted. Causal same-cycle ordering requires placing the sampler after both relevant producers (or another explicitly synchronized scheme) and retaining that order.

3. **1/1.** A visible sampler HAL pin proves component/object publication, not that the corresponding `hal_stream` shared-memory object has become attachable and type-compatible to the userspace collector. A valid harness must prove an actual collector attachment/lifecycle, retain stderr and exit status, obtain nonempty tagged data, and independently retain producer validity/overrun state. C08's earlier collector failure is exactly why object presence alone is rejected as readiness evidence.

4. **1/1.** At the pinned implementation, a full FIFO causes `hal_stream_write()` to increment `num_overruns` and return `-ENOSPC` before reaching the successful-enqueue sample-number increment. Thus dropped producer attempts need not create consumer-tag gaps. A no-loss claim requires producer-side overrun telemetry (`overruns==0` for the authoritative interval), plus collector/trace integrity. C08-052 demonstrated the adversary directly: 32 rejected writes coexisted with retained contiguous tags `[0,1,2]`.

5. **1/1.** Record the disagreement explicitly with version boundaries and inspect both mechanism and bounded executable behavior. For the pinned revision, source plus C08-051/C08-052 support the early-return-before-numbering behavior, so that is the course's implementation-specific conclusion. Preserve the contradictory current manual statement as a documentation hazard rather than deleting it or generalizing that manuals are untrustworthy. Recheck both source and behavior after revision changes.

6. **1/1.** The trace establishes that the tested deterministic fixture has two distinguishable realtime histories despite the same coarse later symptom: Cause A is already asserted with symptom at the chosen sampler boundary; Cause B becomes visible in a sampled row before its symptom. This demonstrates diagnostic discrimination under the retained function order. It does not prove an arbitrary real-machine symptom has either physical cause, that the software cause labels are truthful proxies for plant truth, or that one history is inherently safer.

7. **1/1.** The process log timestamp, typed NML error delivery, Task status and realtime HAL sample are produced and transported through different clocks/queues/scheduling paths. Receipt or print order is not automatically event order. A defensible correlation scheme preserves each source's native sequence/serial/timestamp, records known producer boundaries, uses a shared monotonic clock or explicit correlation marker when available, and quantifies latency/uncertainty. Without that synchronization, describe the surfaces as correlated, not atomically ordered.

8. **1/1.** The producer overruns prove the diagnostic capture lost attempted realtime records; a clean-looking retained plot can therefore hide decisive transitions. They do not prove the machine fault was caused by logging, nor do they identify the machine cause. Before exonerating or blaming a controller path, repair capture capacity/draining or use a lower-rate/triggered recorder, rerun with producer overruns zero for the decisive interval, retain collector status, and confirm relevant producer/sampler ordering. Physical cause still needs independent evidence.

9. **1/1.** If instrumentation removes the fault, it has changed the experimental system. Extra realtime work can lengthen execution, change function ordering or cache behavior, increase scheduler load/jitter, alter FIFO/consumer timing, and perturb userspace scheduling/I/O. A lower-intrusion design samples only decisive signals in one bounded realtime recorder, uses preallocated lock-free/bounded transport, avoids realtime formatting or disk I/O, drains asynchronously, and records its own overrun/timing validity.

10. **1/1.** Strongest software conclusion: in the no-overrun ordered realtime trace, measured Y2 feedback begins diverging two servo observations before the sampled motion-inhibit transition; the later Task/NML error is consistent with a subsequent supervisory response but is not an atomic timestamp for the original divergence. Plausible causes still include true Y2 actuator/load/hydraulic lag, encoder freeze/scale/offset/noise, wiring/transport corruption, command-path asymmetry, drive/valve limitation, mechanical compliance/binding, or incorrect configuration. Discrimination needs independent position plausibility/reference, actuator/drive effort or valve/pressure/flow evidence, command-path telemetry, transport diagnostics, synchronized timestamps and physical inspection as appropriate. Ordinary diagnostics may establish software chronology and hypotheses; they do not establish true ram position, prove a safety function worked, or authorize restart.

## Promotion note

The exam rejects these attractive but invalid equivalences:

```text
sequential point reads == one realtime state
HAL object exists == collector ready
contiguous consumer tags == no producer loss
same symptom == same cause
process/NML/HAL timestamps == one atomic global clock
clean diagnostic trace == physical truth
fault diagnosed == safe restart authorized
```

C08 competency therefore depends as much on proving the **validity and ordering of the recorder** as on interpreting the values it retained.
