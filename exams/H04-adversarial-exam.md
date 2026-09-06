# H04 adversarial exam — HAL execution ordering

Use the pinned-source and accepted `007` evidence. Answer without assuming properties not demonstrated.

1. A HAL thread lists `read-encoder`, `controller`, `write-output` in that order. What ordering claim can be made inside one dispatch pass, and what claim cannot be made about a second HAL thread?
2. `halcmd show funct` lists a function, but `show thread` does not. Will it execute cyclically? Explain export versus scheduling.
3. A function at position 1 writes signal `x`; position 2 reads `x`. Can position 2 observe the new value in the same pass? What evidence supports the answer?
4. Two different HAL threads both access a signal. Can H04 assign a deterministic cross-thread first/second order from each thread's local `addf` positions?
5. `hal stop` is issued and threadbeat stops changing. Does that prove the RTAPI task was deleted? What does the pinned call flow say actually changes?
6. Why did `addf sum2.0 h04-thread` fail when `sum2.0` was already scheduled? What state enforces this for a non-reentrant function?
7. After `delf`, the same non-reentrant function can be added again in the tested stopped configuration. Which source-side accounting change permits that?
8. An engineer wants to reorder functions using live `delf`/`addf` while the thread is executing because configuration routines take the HAL mutex. Is H04 sufficient evidence that this is safe? Explain the missing synchronization evidence.
9. Phase 1 of lab 007 reports A=37, B=38 with A-before-B; phase 2 reports A=77, B=76 after reversing the order. Why is this stronger evidence than `show thread` alone?
10. The lab ran under POSIX non-realtime fallback. Which H04 ordering conclusions remain useful, and which realtime/physical claims remain unproven?
11. A slow first function causes the thread to finish late. Does H04's sequential-order guarantee imply the deadline was met?
12. `hal stop` leaves the cyclic task looping through `rtapi_wait()`. What happens to ordinary function-list traversal while the run gate is clear, and what observation in 007 corroborates it?

## Passing standard

A passing answer must preserve all of these boundaries:

- deterministic sequential traversal within one thread;
- no inferred total order between threads;
- export is not scheduling;
- stop/start is a dispatch gate, not task lifetime management;
- negative duplicate-add behavior is intentional evidence;
- stopped delete/re-add does not validate live mutation;
- non-realtime CI evidence does not qualify physical realtime behavior or safety.