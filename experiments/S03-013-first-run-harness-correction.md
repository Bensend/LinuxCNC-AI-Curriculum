# S03-013 — First-run harness correction

Status: **HARNESS INVALID / corrected and rerun**  
Failed workflow: `34099929612`  
Failed source commit: `4069107dd0e38cad194d63fc24d037a6c8c5f034`  
Corrected source commit: `c754f19ffce37b01dbec8f9aeb71c8c4e576c90b`  
Corrected workflow: `34100737637`

## What failed

The first run successfully built the pinned LinuxCNC tree and successfully registered the synthetic one-IOPort HostMot2 board. The upstream-generated GPIO pins existed, proving that the IDROM/module-descriptor construction was at least sufficient for HostMot2 registration and IOPort export.

The run failed before Gate A could begin because the test-only mutable input control was not visible to `halcmd`:

`parameter or pin 'hm2_test.0.s03-input-word': not found`

The same compile also exposed an independent harness bug in the attempted `s03-io-error` alias. Pinned `hm2_lowlevel_io_t::io_error` is a `hal_bool_t *` owned/exported by HostMot2, not legacy `hal_bit_t` storage suitable for passing to `hal_param_bit_newf()`. HostMot2 already exports the canonical writable parameter as `<llio-name>.io_error`.

Therefore this run contains **no evidence for or against** the S03 stale-publication/write-suppression prediction. It is classified HARNESS INVALID exactly as predeclared.

## Correction

The rerun leaves the production HostMot2 path and all Gates A-D unchanged, but corrects test observability:

- mutable input and write-observation values are exported as ordinary HAL u32 pins using the legacy pointer-to-pointer pin API expected by this pinned tree;
- the lab uses HostMot2's own canonical `hm2_test.0.io_error` parameter instead of constructing an alias;
- the write callback still only observes actual LLIO callback entries and does not feed writes back into fake input state;
- registration and fresh baseline input/write behavior remain mandatory Gate A.

## Why the correction does not weaken the experiment

No expected state transition, timing allowance, assertion, or evidence boundary changed. The correction only repairs the control/observation surface that the test harness itself needs. In particular, stale HAL input under asserted `io_error`, zero LLIO-write-count advancement while faulted, and fresh publication/write resumption after clearing the error remain the same predeclared predictions.

## Next checkpoint

Inspect corrected workflow `34100737637` by its own artifact and `LATEST.exit_code.txt`. If Gate A fails, classify the rerun HARNESS INVALID and correct the fixture again. Only a valid Gate A permits interpreting Gates B-D.