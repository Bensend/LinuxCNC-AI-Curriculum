# Checkpoint — HM01 graduated; E01 started

Session start UTC: `2026-09-06T15:12:24Z`

## HM01 result

HM01 is **GRADUATED**.

Accepted corrected experiment:

- Actions run `34038328272`
- job `101500386969`
- curriculum SHA `b3cdebcd51653aaf415d2c9032cc045518a966d0`
- LinuxCNC SHA `8bf4605ae81042248add031e94c77300406e0413`
- artifact digest `sha256:913e4d08c5202745b40b390b9d0420c84815f4214e55ddd78b770ec025e2b615`
- artifact exit code `0`

Artifact reconciliation observed `expected-patterns=15 observed-pattern-lines=15`, representative malformed cookie/config/IDROM/clock/pin diagnostics, independent bad-cookie `halrun` rc=1 with explicit rejection, and the terminal completion marker. The earlier run `34035539216` remains HARNESS INVALID and is excluded from semantic evidence.

HM01 adversarial exam/answer key passed. Fresh-AI handoff is `guides/HM01-graduation-handoff.md`.

## E01 work begun

Created `guides/E01-hm2-eth-initial.md` from official documentation, community failure history used only as an adversarial lead, and pinned source inspection.

Initial bounded facts:

- `hm2_eth` is the LLIO-side Ethernet driver beneath generic HostMot2;
- official documentation requires uspace and recommends a dedicated wired interface;
- pinned `hm2_eth.c` contains separate non-realtime receive timeout handling (`RECV_TIMEOUT_NON_RT_NS` = 200 ms), so initialization and cyclic receive behavior must be traced separately;
- concrete synchronous and queued-read helpers exist beneath the HM01 LLIO boundary;
- current-master EVL/firewall options must not be backported conceptually to the pinned revision without source comparison.

## Exact next checkpoint

Continue E01 at pinned `hm2_eth.c` and its network backend. Trace, with function-level call flow:

1. board IP/identity selection and interface/socket setup;
2. `hm2_eth_read()` and `hm2_eth_write()` packet construction/send/receive validation;
3. enqueue/send/receive queued read/write helpers and split-I/O behavior;
4. every receive timeout/length/sequence/error branch that affects communication state or LLIO `io_error`;
5. reset/recovery behavior after an I/O error;
6. module cleanup/unload ownership;
7. the exact path back into `hm2_register(&board->llio, config[boards_count])`.

Then write `call-flows/E01-hm2-eth-transport.md`, reconcile current documentation against pinned behavior, and design a no-hardware or loopback experiment only if it can discriminate packet/error semantics without pretending to qualify physical Ethernet timing.