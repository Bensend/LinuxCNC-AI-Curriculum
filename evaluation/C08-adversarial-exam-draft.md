# C08 — 1000-level adversarial exam draft

Status: **FROZEN BEFORE C08-052 RESULT REVIEW**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Score only after the authoritative C08-052 result is reconciled. Passing floor is 10/10 before 1000-level graduation. Each answer must distinguish evidence strength from physical/safety inference.

1. **Sequential-read trap:** A technician runs `halcmd getp axis.x.pos-cmd`, then `halcmd getp axis.x.pos-fb`, subtracts the two values, and says the difference proves the servo following error that existed on one realtime cycle. What is wrong with that evidence claim, and what acquisition method would support the same-cycle claim?
2. **Function-order adversary:** A `sampler` row contains `fault=1` and `output=0`. The sampler function ran before the component that updates `output`, but after the component that updates `fault`. Can the row prove fault assertion caused output zero in that same controller invocation? State the strongest justified interpretation.
3. **Collector-readiness trap:** `halcmd show pin sampler.0.pin.0` succeeds and a script immediately launches `halsampler`; the collector exits with `hal_stream_attach: Invalid argument`. Why was HAL-object presence not sufficient readiness evidence, and what must a valid diagnostic harness retain?
4. **No-loss trap:** A retained `halsampler` file has monotonically contiguous sample tags. At the pinned revision, why is that not by itself proof that every attempted realtime sample was retained? Identify the producer-side evidence needed and explain the `hal_stream_write()` mechanism.
5. **Documentation conflict:** Current `hal_stream(3)` prose says sample numbering advances even when a write fails, while the pinned implementation and bounded C08 test show a full-FIFO return before successful-enqueue numbering. How should an engineer document and act on this disagreement without either blindly trusting prose or pretending documentation is irrelevant?
6. **Same symptom, different causes:** Two fault episodes both leave a coarse userspace pin `symptom=TRUE`. In episode A the atomic trace shows `cause-a` and `symptom` assert together; in episode B it shows `cause-b` one sample before `symptom`. What has the trace established, and what causal/physical conclusions remain unproven?
7. **Cross-surface clock trap:** A process log prints an operator error at 12:00:00.123, an NML client receives `EMC_OPERATOR_ERROR`, and a HAL trace contains a realtime fault transition. Why can these not automatically be ordered as one atomic timeline? Give a defensible correlation strategy and its limits.
8. **Dropped-debug-data adversary:** A real machine intermittently faults only under load. Halscope looks clean, but a deep `sampler` trace records producer overruns. What may be concluded about the machine and about the diagnostic capture? What should happen before using the trace to exonerate or blame a controller path?
9. **Instrumentation perturbation:** Adding verbose realtime logging or extra HAL functions makes the original fault disappear. Why does that weaken rather than strengthen the diagnosis? State at least three ways instrumentation can perturb timing or scheduling and how to design a lower-intrusion capture.
10. **Novel press-brake scenario:** During a tandem ram descent, the UI reports “Y2 lag” and a later operator-error message says motion was stopped. You have: (a) a no-overrun realtime trace showing Y2 feedback divergence begins two servo cycles before a motion inhibit; (b) Task/NML error text arriving later; (c) no independent physical measurement of Y2 position; and (d) no safety-rated recorder. State the strongest justified software diagnosis, list at least four still-plausible physical/configuration causes, identify what additional evidence would discriminate them, and separate ordinary diagnostic reasoning from restart/safety authority.

## Handoff requirement

After scoring, construct a fresh scenario that combines at least three evidence surfaces from: realtime HAL trace, sampler producer-overrun telemetry, Halscope, Task command/status, typed NML error text, process logs, external physical measurement, and safety-system state. The fresh-AI handoff must preserve all of these distinctions:

- point observation vs same-cycle observation;
- producer event vs collector retention;
- function-order coherence vs cross-process correlation;
- software state vs physical plant truth;
- diagnostic evidence vs safety/restart authority.
