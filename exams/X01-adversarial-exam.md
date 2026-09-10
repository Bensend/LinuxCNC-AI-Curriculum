# X01 adversarial exam — recorder integrity and perturbation

Status: **FROZEN BEFORE ANSWERS**  
Course level: 2000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Use the corrected X01 guide, call flow, frozen experiment, retained evidence review, and referenced pinned LinuxCNC source. Do not use a hidden/fresh-handoff answer key.

Scoring: 20 points total, 2 points each. Critical traps are Q1, Q3, Q5, Q8, and Q10. Any critical-trap miss prevents technical exam acceptance even if the numeric score otherwise passes.

## Questions

1. **Misleading premise — clean tags.** A 20-minute diagnostic file has perfectly contiguous `halsampler -t` prefixes and no printed `overrun` lines. An engineer concludes that the realtime sampler lost no records. Is that conclusion established? Give the minimum additional evidence needed for a stronger recorder-integrity claim and explain why.

2. Trace one enabled invocation of `sampler.c::sample()` at the pinned revision from configured HAL input pins through either a successful FIFO write or a full-FIFO failure. Identify the state mutations on the failure branch.

3. **Version-sensitive trap — `sample-num`.** A patch reads `sampler.0.sample-num` and asserts it equals the numeric prefix printed by `halsampler -t`. Is that relationship established at the pinned revision? Cite the source path that produces the `-t` value and explain the exported pin's status.

4. In X01-002 P3, retained stream tags are contiguous but the deterministic payload jumps from 79 to 286 and producer overruns are nonzero. What does this prove, and what important machine/control claim does it *not* prove?

5. **Failure-path trace.** The userspace reader is killed while the realtime producer is still enabled and the FIFO contains unread records. The resulting file ends cleanly on a syntactically valid row. List the distinct evidence-integrity failure that must be considered and describe a safer terminal-capture procedure.

6. Explain why one sampler row can be a stronger correlation observation than two sequential `halcmd getp` calls, but why it still does not prove electrical simultaneity or make thread function order irrelevant.

7. X01 P4 measured a higher `servo-thread.time` and `tmax` for the wide capture than the narrow capture. State one justified conclusion and two conclusions that would overclaim the evidence.

8. **Configuration/code task.** You need to add two more HAL values to an X02 diagnostic recorder. Give a minimal evidence-preserving change plan: what must remain retained/checked so that increasing width cannot silently turn a correlation trace into trusted evidence after recorder loss?

9. The P5 sustained test retained 10,000 contiguous rows with producer overruns zero. What exact claim is supported, and name at least three retention/durability claims that remain outside the evidence.

10. **Adversarial inference.** During a fault, `sampler.0.overruns` rises by 50 while the deterministic source counter continues advancing. A later machine position appears to jump in the retained file. Rank the evidence needed before attributing that apparent jump to (a) recorder loss, (b) a realtime control-loop skip, or (c) physical motion, and identify the safest immediate classification if no other evidence exists.

## Pass rule

- Numeric pass: at least 18/20.
- All critical traps Q1, Q3, Q5, Q8, Q10 must receive full credit.
- Any answer that treats recorder overrun alone as proof of a missed control cycle fails Q4/Q10.
- Any answer that treats clean `-t` output alone as proof of producer integrity fails Q1.
- Any answer that self-certifies a fresh-AI handoff from this exam fails the graduation-process requirement even if this exam passes.
