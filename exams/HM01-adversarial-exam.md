# HM01 adversarial exam — HostMot2 architecture and registration lifecycle

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

1. Correct this premise: “`hm2_eth` is HostMot2, so generic HostMot2 code owns Ethernet packet transport.” Identify the actual ownership boundary and the object passed across it.
2. A new low-level driver wants to register a board. Which LLIO capabilities are foundational requirements, which are optional/capability-dependent, and why must generic HostMot2 validate that contract before parsing board contents?
3. Trace the successful registration path at foundation depth from a low-level driver's `hm2_register()` call through cookie/IDROM validation, module-description parsing, HAL/TRAM initialization, initial synchronization, and exported board-cycle functions.
4. Failure-path question: distinguish failures that can jump directly to the earliest failure exit from failures after substantial HostMot2/module state exists. What cleanup obligation changes?
5. Misleading premise: “Any unknown module GTAG makes HostMot2 reject the board.” Correct it. Contrast an unknown GTAG with a recognized parser returning an error or an LLIO I/O error.
6. Explain why checking the HostMot2 cookie is more than cosmetic. What did lab 009 demonstrate when the fake register image supplied `0x00000000` instead of `0x55AACAFE`?
7. Lab 009's upstream matrix printed 15 rejection diagnostics and exited successfully. Why is that stronger evidence than a green GitHub workflow status but still weaker than a successful real Mesa-board registration test?
8. The standalone bad-cookie check confirmed registration failed. Why did the harness also reject evidence of exported `.read`/`.write` board-cycle functions in that failure path?
9. A developer says, “Because `hm2_unregister()` can trigger a watchdog action, HM01 proves safe machine shutdown if the driver dies.” Identify the invalid inference and the additional evidence domains required before making a safety claim.
10. Version/scope question: which HM01 conclusions are pinned-source conclusions versus `TEST-CONFIRMED` runtime conclusions, and what must be repeated before claiming identical behavior for a different LinuxCNC revision or different realtime flavor?
11. Debugging scenario: a physical Ethernet Mesa board fails registration after the IDROM is read. Give a bounded diagnostic sequence that separates low-level transport/read failure, generic cookie/IDROM/descriptor validation, module-parser failure, and later initialization/cleanup without immediately blaming `hm2_eth` or HostMot2 generically.
12. Fresh-AI handoff test: in one concise explanation, describe why HostMot2 can support multiple transport drivers without duplicating the generic firmware/module/HAL model, and name the exact boundary E01 must descend into next.