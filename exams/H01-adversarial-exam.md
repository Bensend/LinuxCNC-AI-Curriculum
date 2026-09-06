# H01 Adversarial Exam — HAL Architecture and Object Model

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

1. A component calls `hal_ready()`. Does this freeze global HAL configuration? Explain what it actually changes and what component-owned registrations are thereafter rejected.
2. A `HAL_IN` float pin contains 1.25 before it is linked to a newly created signal. What value should the signal initially acquire, and why? Identify the storage/pointer transition rather than answering only from `halcmd` syntax.
3. The signal is changed to 2.5, then the pin is unlinked, then the signal changes to 3.5. What should the pin read after each operation? Explain the unlink snapshot behavior.
4. Misleading premise: “HAL signals are just names that make two pin variables mirror one another.” Correct the premise using the shared signal value and pin pointer model.
5. Why must a second `HAL_OUT` pin be rejected when a signal already has a writer? Distinguish readers, writers, and bidirectional pins and state why this invariant matters.
6. `hal_export_funct()` succeeds. Does that mean the function executes periodically? Trace the additional scheduling steps through `addf`/`hal_add_funct_to_thread()` and the thread dispatcher.
7. Debugging scenario: `show funct` lists a function, but its state never advances. Give at least three checks in the correct conceptual order.
8. Version-sensitive reasoning: which claims in this module are safe to apply to another LinuxCNC revision without rechecking source, and which must remain pinned to the studied SHA?
9. Bounded modification task: write the HAL command sequence that creates a 1 ms thread, loads `siggen`, adds `siggen.0.update` to the thread, starts HAL execution, and then verifies that the function is scheduled. State what this test does *not* prove about realtime determinism.
10. Failure/safety boundary: explain why successful HAL connectivity and periodic function execution in a cloud uspace test do not establish physical I/O correctness, deadline performance, or safety-rated behavior.

Passing requires correct storage ownership/pointer reasoning, writer-invariant reasoning, export-versus-scheduling separation, explicit revision/evidence boundaries, and no realtime/safety overclaim.
