# C06-041 / C06-043 — sampler readiness diagnostic reconciliation

Status: **NON-AUTHORITATIVE DIAGNOSTIC; ROOT CAUSE CONFIRMED**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## C06-041 retained result

Workflow `34310509116`, job `102336017000`, artifact `10088240415`.

The staged diagnostic initially appeared to show:

- fixture-only: `halsampler_rc=0`, 10 parseable rows;
- full static P0 topology: `halsampler_rc=1`, zero rows, `hal_stream_attach: Invalid argument`.

The retained before-attach snapshots invalidate the naive topology conclusion. The readiness loop used commands such as `halcmd show pin sampler.0.enable >/dev/null`; at this pinned runtime a successful `show` command does not prove that a matching object exists. The full-P0 snapshot was taken before sampler objects/FIFO shared memory existed. The fixture-only case merely completed setup before the userspace attach happened to execute.

This is now **SOURCE-CONFIRMED** at the pinned revision: `src/hal/utils/halcmd_commands.cc::do_show_cmd()` dispatches `show pin` to `print_pin_info(...)` and returns `0` after the print function regardless of whether the requested pattern matched any pin. Only an unknown `show` type returns `-1`. Therefore command exit status is categorically the wrong existence predicate for this harness.

Therefore C06-038/041 did **not** falsify the startup-race hypothesis. Their existence predicate was itself defective.

## C06-043 corrected preflight

Workflow `34311305551`, job `102338355587`, artifact `10088513656`.

C06-043 replaced return-code readiness with actual-name evidence from complete HAL object listings and also required the `halrun` process to remain alive. Against the accepted C06-036 fixture, full static P0 topology, and exact `depth=30000 cfg=uubbbuuuub` sampler:

```text
ready=1 halsampler_rc=0 parseable_rows=20 overruns=0
PREFLIGHT PASS: real object readiness + accepted fixture + full static P0 topology + exact sampler attached and retained data.
```

This confirms that the earlier `hal_stream_attach: Invalid argument` failures were startup/readiness-harness failures, not evidence that the HostMot2 fixture, static P0 topology, stream depth, or stream type configuration is invalid.

## Evidence classification

- `do_show_cmd()` returning success independently of pattern match count: **SOURCE-CONFIRMED** at pinned revision `8bf4605...`, path `src/hal/utils/halcmd_commands.cc`.
- Correct sampler/fixture startup with actual object existence proof: **TEST-CONFIRMED** for the harness/preflight only.
- Frozen C06-030 behavioral Gates A–H: still not scored by these diagnostics.
- Prior claims that simple startup race was falsified by C06-038 are **RETRACTED/CORRECTED**.

## Correction rule

Any future C06 authoritative run must prove exact HAL object names and an active userspace sampler with retained baseline rows before the first fault-phase mutation. Command success from a filtered `halcmd show ...` invocation is not an existence proof.
