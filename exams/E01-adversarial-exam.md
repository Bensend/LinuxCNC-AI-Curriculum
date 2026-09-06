# E01 adversarial exam — hm2_eth architecture and board discovery

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Questions

1. A review says: “hm2_eth is HostMot2, just over UDP.” Correct the ownership model. Identify which layer owns Ethernet transaction mechanics, which layer interprets HostMot2 firmware/module metadata, and the concrete boundary between them.
2. Trace startup from `rtapi_app_main()` through board setup/probe to `hm2_register()`. Which state must exist before generic HostMot2 registration can begin?
3. Misleading premise: “All hm2_eth reads have a 200 ms timeout, so a servo thread can block for 200 ms every cycle.” Explain why this is false at the pinned revision and distinguish synchronous initialization/direct reads from cyclic queued receive.
4. A UDP datagram arrives with exactly the expected byte count. Is that sufficient to accept the cyclic read as current/valid? Explain the read-counter and write-counter checks and what problem each detects.
5. Explain why a stale read counter is not equivalent to a wrong-sized packet. What does the receive path do in each case, and what role does the deadline play?
6. Explain the soft-error policy. Which state is set on an error, how can successful cycles reduce the accumulated level, and when is LLIO `io_error` asserted?
7. A maintainer proposes to prove E01 by copying `hm2_eth_receive_queued_reads()` into a standalone C test and mocking every dependency. What would such a test prove, and what would it fail to prove about the production driver?
8. Why is `hm2_eth_reset()` not evidence that a machine reaches a safe state after communication loss? State the mechanism that source does establish and the claim that remains outside E01.
9. Debugging scenario: initialization can identify a board, but cyclic operation later reports communication errors. Give a source-grounded diagnostic split that avoids confusing board discovery/registration failure with queued transport failure.
10. Bounded modification task: add instrumentation for a laboratory build that distinguishes (a) wrong-size receive, (b) stale `read_cnt`, and (c) mismatched confirmed `write_cnt`, without changing production decision logic. Describe where to instrument and what fields to record.
11. Version-sensitive reasoning: current documentation contains networking/backend options absent or different at the pinned revision. What evidence is required before teaching current-master behavior as applicable to `8bf4605...`?
12. Fresh-AI boundary: list three conclusions E01 can safely teach without physical Mesa hardware and three conclusions it must not promote from source/cloud evidence alone.

## Pass standard

A passing answer must preserve the LLIO/generic-HostMot2 ownership boundary, distinguish direct and cyclic timeout models, understand counter-confirmed cyclic validity and soft-error propagation, reject safety inference, and state the limits of a no-hardware harness.