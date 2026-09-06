# H04 adversarial exam — answer key and grading

1. Inside one `thread_task()` dispatch pass, the listed function entries are called sequentially in list order: `read-encoder` then `controller` then `write-output`. That says nothing about when a function in another HAL thread runs relative to those calls because the other thread has its own RTAPI task.
2. No cyclic execution follows merely from export. Export creates the HAL function object/callable; `addf` creates a function-list entry under a HAL thread. `thread_task()` traverses only scheduled entries.
3. Yes, for the ordinary scalar dataflow tested here. The pinned dispatcher makes direct sequential calls, and lab 007's cross-coupled `sum2` network changed its same-cycle directional relationship when order changed.
4. No. Local positions order functions only inside their own thread. H04 deliberately leaves cross-thread scheduling and memory visibility unpromoted.
5. No. `hal_stop_threads()` clears `hal_data->threads_running`; it does not delete each RTAPI task. `thread_task()` continues to reach its periodic wait path.
6. `sum2.0` is non-reentrant. `hal_add_funct_to_thread()` rejects it when `funct->users > 0` and `reentrant == 0`. Lab 007 observed rc=1 and the explicit 'may only be added to one thread' diagnostic.
7. Removing the function entry routes through the free-entry path that decrements the owning exported function's `users` count, permitting a later add.
8. No. Configuration mutation takes the HAL mutex, but the realtime dispatcher traverses the function list without that mutex, and the traced add/delete paths did not provide a `threads_running == 0` guard establishing safe concurrent mutation. H04 therefore performs mutation only while stopped and promotes live mutation to 2000/HIGH.
9. `show thread` proves configured order. The feedback values prove behavior depends on that order: A-before-B produced `B-A=1`, while B-before-A produced `A-B=1`. Reversing order and seeing the predicted directional reversal tests actual execution/dataflow rather than presentation alone.
10. Sequential intra-thread call order, stop-gating behavior, duplicate non-reentrant rejection, and stopped delete/re-add remain useful software-behavior evidence. Scheduler latency, jitter, deadlines, physical I/O timing, hardware qualification, and safety properties remain unproven.
11. No. Sequential ordering says which call happens first, not whether the collection of calls completes by the nominal period. Deadline/overrun behavior belongs to deeper realtime study.
12. Ordinary cyclic list traversal is skipped while the run gate is clear, while the task continues its periodic loop/wait behavior. In 007, threadbeat remained exactly `19` across two stopped observations and advanced to `39` after restart.

## Grade

**PASS — 12/12.**

The answer set preserves the H04 evidence boundary and does not convert a local list-order guarantee into cross-thread, realtime-deadline, live-mutation, or safety claims.

## Correction pass

No correction to the central H04 source model is required after lab 007. One interpretation trap is explicitly corrected in the durable record: the expected duplicate-add error in stderr is a successful negative test, not evidence that the lab failed. Another is that stable threadbeat under `hal stop` means dispatch is gated; it does not imply destruction or suspension of the underlying RTAPI task.

Unresolved live-list mutation and cross-thread memory/scheduler ordering remain escalated rather than guessed.