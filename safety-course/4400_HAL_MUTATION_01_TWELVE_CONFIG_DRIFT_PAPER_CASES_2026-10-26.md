# HAL-MUTATION-01 — Twelve adversarial technician cases

**PAPER ONLY; UNSCORED; NOT a blind benchmark or permission to energize.** Answer each with: predicted normal-control observation; what source/documentation establishes; what is conditional/UNKNOWN; what independent physical safety witness is needed; and a practical low-friction fix. Do not conduct live fault injection on hazardous machinery.

1. A BIT process permissive is TRUE when its HAL input is unlinked. A sensor subsequently goes FALSE. Is the disconnected input guaranteed FALSE? Identify the relevant source function.
2. A technician attempts `setp` on an input still attached to a signal. Explain the documented failure and what would be required to make that pin writable **without** recommending a production bypass.
3. A writerless BIT signal shows TRUE on the HMI. Does it prove a guard switch is healthy? Distinguish signal value from physical origin.
4. A signal has a valid output writer. A `sets` command is attempted. Which check should reject it, and what does that check **not** establish?
5. An unlinked HAL_PORT pin is compared with an unlinked BIT input. Why must the scalar last-value rule not be generalized?
6. A HAL configuration is locked. An operator claims the entire machine is safety-certified. Identify the missing physical safety evidence.
7. A service technician reconnects a pin to a different signal of the same type. Which invariants does HAL check and which safety propositions remain unproven?
8. A diagnostic dashboard reads TRUE for `normal-enable` while an independent guard safety output is OFF. Which layer has personnel-safety authority and what must the machine physically do?
9. After power restoration, the normal HMI shows ready, but an independent safety reset has not occurred. Describe a safe operator workflow with distinct reset and start.
10. A lathe door is opened after LinuxCNC spindle command reaches zero. What independent evidence is required before entry?
11. A plasma table loses its ordinary torch-enable writer. How would you distinguish HAL process command failure from verified high-voltage isolation?
12. A press brake's Y1 and Y2 normal-control permissives look identical after service. What independent evidence must be obtained before any personnel-exposed operation, and how can service diagnostics discourage bypass?

**Evaluation:** These are open practice prompts with no hidden key and no score. An independent evaluator must use a novel, sealed challenge and precommitted learner response before revealing the oracle. Selected-machine tests require separate authorization, exclusion zones, physical energy isolation and residual-risk review. **G0/G1 HOLD.**
