# HALCMD-149 — minimal Python HAL ready fixture (NOT RUN)

This file is a **software-only**, deliberately non-motion userspace HAL component. It has one `heartbeat` output pin and no physical outputs. It uses the Python `hal.component(name)` constructor, `newpin`, `ready()` and `exit()` APIs traced to pinned stable [`src/hal/halmodule.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/halmodule.cc), blob `b37a3c940705f8c4df0a7cf03b4d1a8470c91bdc`, lines 181–207, 456–479 and 541–560. The fixture was **written but never executed**; syntax, runtime and expected results remain unverified.

In a **positively qualified, physically disconnected** LinuxCNC `halrun` session, with an **external timeout** controlling the whole session, substitute the actual absolute path for `/path/to`:

```hal
# A: component name matches and calls ready; -W should return
loadusr -Wn fixture python3 /path/to/hal_ready_fixture.py --name fixture --ready-delay 0.05
# Later, after observing the fixture heartbeat, cleanly unload it
unloadusr fixture
```

For **B**, run a *separate isolated session* using `-Wn missing` while the program still registers `--name fixture`. This intentionally exercises the no-timeout name mismatch; the **external** timeout must terminate the test. For **C**, pass `--exit-before-ready` and expect child exit code 7 and `-W` failure. For **D**, pass `--exit-after-ready 1.0`; `-W` may report readiness before the child exits. Never chain the hanging case into the same HAL script as other cases. Do not use this fixture on a physical machine, and do not dispatch a hosted runner.

Cases E–G in the [guide](../../guides/3100-3400-4000-linuxcnc-loadusr-w-component-readiness-commissioning-2026-11-02.md) need separate harnesses for `-w`, preexisting-component identity and fork-failure injection. No claims of PID spoofing or actual LinuxCNC failure are made.

[Source audit](../../research/4400_LINUXCNC_HALCMD_149_LOADUSR_W_READY_NAME_PID_TIMEOUT_SOURCE_AUDIT_2026-11-02.md) · [checkpoint](../../checkpoints/20261102T0446Z-4000-linuxcnc-hal-loadusr-next.md).
