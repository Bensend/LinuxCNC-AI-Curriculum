# HM01 graduation handoff — HostMot2 architecture and registration lifecycle

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Status: **GRADUATED at 1000-level foundation depth**

## Mental model

HostMot2 is a generic Mesa firmware/module/HAL layer above transport- or board-specific low-level drivers. A low-level driver owns how registers are physically reached and exposes that access through `hm2_lowlevel_io_t`; generic HostMot2 consumes the LLIO contract to identify/validate the board image, parse supported firmware modules, construct the generic runtime/HAL representation, synchronize initial state, and expose normal board-cycle functions.

A concrete pinned example is `hm2_eth`: it fills LLIO read/write, queued-I/O and reset capabilities, then hands that interface to generic HostMot2 with `hm2_register(&board->llio, config[boards_count])`. Ethernet discovery/socket/packet behavior is deliberately E01 scope.

## Registration lifecycle

At foundation depth:

1. low-level driver prepares a valid `hm2_lowlevel_io_t` and calls `hm2_register()`;
2. HostMot2 validates the LLIO contract and establishes tentative per-board state;
3. it parses config and, where applicable, programming/firmware state;
4. register reads validate the HostMot2 cookie, IDROM and descriptors;
5. IOPort is handled first, then recognized GTAGs dispatch to module-specific parsers;
6. module/TRAM/HAL objects are initialized and initial state is synchronized;
7. successful registration exposes normal board read/write cycle functions.

Unknown GTAGs at the pinned revision are warned and ignored, not automatically fatal. A recognized module parser returning negative or an LLIO `io_error` is an abort condition in the traced descriptor flow.

Failure lifetime matters. Very early failures can leave via the earliest failure path. Once substantial module state exists, registration failure converges through `hm2_cleanup()` before list removal/free. `hm2_unregister()` performs generic teardown; its watchdog action is a software-lifecycle fact, not a safety certification.

## Runtime evidence

Accepted lab: `009`, Actions run `34038328272`, job `101500386969`, curriculum SHA `b3cdebcd51653aaf415d2c9032cc045518a966d0`.

The pinned upstream no-hardware `tests/hm2-idrom` / `hm2_test` fixture completed its malformed registration matrix. Curriculum gates observed 15 expected diagnostic lines. The independent bad-cookie case returned rc=1 and reported `invalid cookie` plus `hm2_test fails HM2 registration`. Artifact exit code was 0 after the explicit completion marker.

This promotes the exercised fake-LLIO malformed-registration rejection behavior to `TEST-CONFIRMED` for the pinned userspace build. The earlier run `34035539216` is HARNESS INVALID and contributes no semantic evidence.

## Evidence boundaries

HM01 does not prove:

- successful physical Mesa-board registration;
- Ethernet packet correctness or latency;
- TRAM cycle ordering/timing;
- realtime deadlines/jitter;
- physical watchdog effectiveness;
- electrical fail-safe behavior;
- functional safety.

These need later source modules and/or representative hardware evidence.

## Fresh-AI self-check

A fresh agent is ready to leave HM01 if it can explain, without conflating layers:

- why `hm2_eth` and generic HostMot2 have different ownership;
- what `hm2_lowlevel_io_t` accomplishes;
- the success and rollback shape of `hm2_register()`;
- why unknown GTAG != automatic fatal error;
- exactly what lab 009 confirms and does not confirm.

The adversarial answer key passes those requirements.

## Next critical-path module

**E01 — hm2_eth architecture and board discovery/registration ownership.** Descend below the LLIO boundary: board discovery/selection, socket/interface setup, concrete read/write packet path, queued/split I/O, timeout/error/reset handling, and how those events surface through LLIO to generic HostMot2. Preserve transport timing and physical watchdog claims as separate evidence domains.