# 4000-LC-QTPLASMAC-HAL-02 — Real Mesa torch path, HAL addf order and debounced arc feedback
**2026-10-30 | Session start 2026-10-30T19:32:52Z | SOURCE-CONFIRMED / DOC-CONFIRMED / community-config inspection | NO RUNTIME TEST | NON-GRADUATED**

## Bounded question, novelty and prerequisite
In a real QtPlasmaC/Mesa machine configuration, where does the ordinary `M3` torch request go, and can the placement of `db_arc-ok` after `plasmac` in the realtime thread change when arc feedback becomes visible? **Yes, the order creates a one-servo-iteration pipeline boundary in the inspected configurations.** This extends [4000-LC-QTPLASMAC-01](4400_LINUXCNC_QTPLASMAC_M190_M66_MATERIAL_HANDOFF_SOURCE_AUDIT_2026-10-30.md), which traced material selection and the upstream `plasmac.torch-on` output but explicitly left downstream real HAL wiring UNKNOWN. It does **not** reopen graduated 3300 or create a safety-course competency.

## Pinned evidence (paths, versions and limitations)
- **Upstream LinuxCNC development** commit `24e84c4506b41634240f7087f0295e361a954886`:
  - [`lib/hallib/qtplasmac_comp.hal`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/lib/hallib/qtplasmac_comp.hal), blob `35356761267aa42519ecc08e142edd2169985843`: `spindle.0.on => plasmac.cutting-start`, `db_arc-ok.out => plasmac.arc-ok-in`, `plasmac.torch-on` is the source of signal `plasmac:torch-on`.
  - [`src/hal/components/plasmac.comp`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/components/plasmac.comp), blob `b0204b17da65c9de90247fc9dfc7c11921bb054a`: `tool=CUTTING` when `cutting_start && !dry_run` (~560); `torch_on_set(TRUE)` in `TORCH_ON` under `torch_enable` (~1513–1545); `arc_ok_in` consumed for modes >0 while torch on (~874–909); `ARC_OK` waits for arc feedback or configured ignore before entering `PIERCE_DELAY` (~1550–1590).
  - [`src/hal/components/dbounce.comp`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/components/dbounce.comp), blob `d517deacf7d85427c0ed59d809f1ee9a1f19cc79`: `FUNCTION(_)` increments/decrements an integer state and updates `out` only when already at the threshold/zero.
  - [`src/emc/usr_intf/pncconf/build_HAL.py`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/usr_intf/pncconf/build_HAL.py), blob `6be9cd53fc5c5c07c3384af2b3d8423215f6f9c9`: generic `addf plasmac` at ~355, QtPlasmaC-specific `qtplasmac_connections` invoked later (~386) and prints `addf db_float/db_ohmic/db_breakaway/db_arc-ok` (~1916). **Do not confuse the earlier generic `dbouncenames` block (probe/estop) with these four QtPlasmaC instances.**
  - [`docs/src/hal/twopass.adoc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/hal/twopass.adoc), blob `7fdc48fae2cbaf1464620211263d983905aae330`: `addf` commands execute in appearance order on second pass; ordering can matter.
  - [`docs/src/hal/tools.adoc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/hal/tools.adoc), blob `882cf6023960ca9ef912166d23ea02fc8c502116`: `halreport` records function/thread/`addf` order and flags signal connections.
  - [`docs/src/man/man9/hostmot2.9.adoc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man9/hostmot2.9.adoc), sections OutM (~1274), watchdog (~1339), `read`/`write` (~1428): output-pin behavior and watchdog semantics.
  - [`configs/sim/qtplasmac/sim_postgui.hal`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/configs/sim/qtplasmac/sim_postgui.hal), blob `f9196162591dc6c49b30b23c671e7c0300b43dad`: `plasmac:torch-on` feeds simulated torch/UI, **not** physical output.
- **Stable v2.9.10** pinned commit `86cdca76fa2a36274c432caa21952b23c267989a`: [`pncconf/build_HAL.py`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/usr_intf/pncconf/build_HAL.py), blob `11376b4e044b010d989515f3ca93850c4ecf09b7`, also prints the dedicated QtPlasmaC `db_*` addf block separately after its generic `plasmac` addf. This is a **static generator ordering observation**, not a claim that every generated configuration runs successfully.
- **Inspectable community machine configuration, not upstream or a tested installation:** [`freemoore/linuxcnc` 7i96s HAL](https://github.com/freemoore/linuxcnc/blob/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac/7i96s_qtplasmac.hal), blob `5fd0a37c8e99868dec26c881abcd205a514570da`; [INI](https://github.com/freemoore/linuxcnc/blob/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac/7i96s_qtplasmac.ini); [custom.hal](https://github.com/freemoore/linuxcnc/blob/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac/custom.hal). INI comments report PNCconf generation on 2025-08-29; no physical wiring or operational validation was supplied.
- **Independent topology contrast:** [Sector67 fiber-laser HostMot2 7i92 HAL](https://github.com/Sector67/fiber-laser-control/blob/938b501bfd092505170af8146c1b77a8564754d1/config/laser_cutter.hal), blob `6434408fc31859a51998e3229ba80f5e58a84935`: `plasmac:torch-on => hm2_7i92.0.gpio.025.out` with `gpio.025.is_output true`. **Laser application is not interchangeable with plasma hardware**, but shows a different HostMot2 output family.
- [Official QtPlasmaC documentation](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/plasma/qtplasmac.adoc) calls `plasmac.torch-on` a required process output wired to the power supply's torch-on input; this is **DOC-CONFIRMED intended use**, not proof of a selected electrical circuit.

## Actual configuration chain (ordinary process control)
The inspected community 7i96s INI has `[EMCMOT] SERVO_PERIOD=1000000` (nominal 1 ms), `[HAL] HALFILE=7i96s_qtplasmac.hal`, then `HALFILE=qtplasmac_comp.hal`, then `HALFILE=custom.hal`, plus `POSTGUI_HALFILE`. Its HAL declares `loadrt hostmot2`, `loadrt hm2_eth board_ip=10.10.10.10 ...`, `loadrt plasmac`, and the servo-thread sequence:

```text
hm2_7i96s.0.read
motion-command-handler
motion-controller
pid.x / pid.y / pid.z / pid.s
plasmac
hm2_7i96s.0.write
db_float
db_ohmic
db_breakaway
db_arc-ok
```

**SOURCE-CONFIRMED configuration text:** The machine's `plasmac:torch-on` is connected to `hm2_7i96s.0.outm.00.out-04` (HAL ~68), an OutM input pin in HostMot2 terminology. The common QtPlasmaC HAL provides the producer `plasmac.torch-on` and routes `spindle.0.on` to `plasmac.cutting-start`. The physical output module, relay polarity, power-supply interface, torch voltage and actual arc behavior are **UNKNOWN**. The upstream simulation instead connects the same signal to `sim-torch.start`; that cannot establish physical actuation.

**Return path:** `hm2_7i96s.0.inm.00.input-06-not -> plasmac:arc-ok-in -> db_arc-ok.in -> db_arc-ok.out -> plasmac.arc-ok-in`. In `custom.hal`, `db_arc-ok.delay=5`. `plasmac.comp` in mode >0 uses `arc_ok_in` to update `arc_ok_out` while `torch_on` is active; `ARC_OK` state can then progress to `PIERCE_DELAY` when arc OK or a separately configured ignore condition is satisfied. Other state, mode, timing and fault gates still apply.

## The one-iteration latency and non-obvious debounce semantics
In the inspected HAL, `plasmac` runs **before** `db_arc-ok`. Consequently `plasmac` at servo iteration `k` cannot see a `db_arc-ok.out` change calculated later in the **same** iteration. It can first consume that updated output at `k+1` (assuming normal execution). This is a deterministic **ordering dependency**, not a measured wall-clock response.

The `dbounce.comp` source is a saturating up/down state machine, not a strict consecutive-sample counter. For an initially low state=0, delay=5 and continuously high input sampled by `db_arc-ok`, the state/output sequence is:

| `db_arc-ok` invocation | state after call | output after call | `plasmac` in that same iteration sees |
|---:|---:|---|---|
| 1 | 1 | false | previous false |
| 2 | 2 | false | previous false |
| 3 | 3 | false | previous false |
| 4 | 4 | false | previous false |
| 5 | 5 | false | previous false |
| 6 | 5 | true | previous false |
| 7 | 5 | true | **true** |

The reverse transition similarly decrements state to zero before a **subsequent** invocation clears the output. Intermittent input can retain partial state; it is **not** accurate to call `delay=5` “five consecutive true readings.” A 1 ms nominal servo period does **not** prove an exact physical 7 ms arc-OK response: input sampling phase, Ethernet transport, thread jitter, `arc_lost_delay`, and selected electrical interface remain unmeasured.

The inspected real HAL also puts `db_float`, `db_ohmic`, and `db_breakaway` after `plasmac`. Their updated values likewise cannot influence that iteration's `plasmac` execution. This does not by itself prove a functional bug or unsafe behavior; it is a source-visible latency term and a reason to inspect actual `addf` ordering.

## Hardware watchdog is not a process-safe-state witness
The community HAL sets `hm2_7i96s.0.watchdog.timeout_ns=5000000` (5 ms). The official HostMot2 manual says that if the firmware includes the watchdog and it trips, I/O pins become high-impedance inputs (pulled high); the internal PWM/stepgen modules may keep running but are disconnected from physical pins. Reset can restore configured I/O pin modes. **DOC-CONFIRMED generic HostMot2 semantics**, **NOT** a test of the selected 7i96s output circuitry or plasma power supply. High impedance/pulled high must not be equated with a guaranteed off/isolated torch, and a software/HAL watchdog is not an independent personnel-safety function.

## Practical integrator walk-through (no live actuation)
1. Read the actual `[HAL] HALFILE` and `POSTGUI_HALFILE` order and all sourced Tcl/HAL files; verify whether `qtplasmac_comp.hal` or `plasmac.tcl` is used for that LinuxCNC version. Do not silently mix both.
2. Trace **producer → signal → consumer** separately for `spindle.0.on`, `plasmac.cutting-start`, `plasmac.torch-on`, `plasmac:torch-on`, the exact Mesa output pin, raw arc-OK input, `db_arc-ok.in/out` and `plasmac.arc-ok-in`.
3. On an **already validated, physically isolated** LinuxCNC instance, `halreport /tmp/halreport.txt` can report actual function ordering and signals; `halcmd show thread`, `halcmd show sig`, `halcmd show pin`, `halmeter` and `halscope` can inspect state. Do not issue `setp` to an actual torch output or bypass a sensor to “prove” wiring on a personnel-exposed machine.
4. If reducing one-cycle input latency is an engineering requirement, **review** placing `db_*` after `hm2.read` but before `plasmac`, while retaining `plasmac` before `hm2.write`; check other dependent consumers and startup/twopass ordering. This is a **proposed design change**, not a tested patch, not automatically an improvement for every machine, and not a reason to run a live torch experiment.
5. Preserve process-output polarity, material selection, G-code post ID, HAL/INI revision and machine-specific electrical interface separately. `M190` acknowledgement, `M3` request, `plasmac.torch-on`, FPGA pin state and physical arc are **different observations**.

## Evidence ledger and unresolved questions
| Proposition | Class | Boundary |
|---|---|---|
| `spindle.0.on -> plasmac.cutting-start -> plasmac.torch-on` conditional ordinary-control path | SOURCE-CONFIRMED | Pinned development common HAL + component |
| 7i96s `plasmac:torch-on => outm.00.out-04` and arc feedback via `inm.00.input-06-not` | SOURCE-CONFIRMED configuration | Public community config; not physical wiring |
| `plasmac` precedes `db_arc-ok` in real config and inspected PNCconf QtPlasmaC generation path | SOURCE-CONFIRMED | Pinned revisions/config; startup runtime untested |
| One-iteration stale debounced value and delay=5 state/output sequence | SOURCE-CONFIRMED / INFERENCE | Derived from addf ordering and `dbounce.comp` code; no timing measurement |
| HostMot2 OutM and watchdog described behavior | DOC-CONFIRMED | Generic driver/manual, selected electrical load UNKNOWN |
| Correct electrical polarity, actual arc response, physical output state on watchdog, LinuxCNC runtime timing | UNKNOWN | Requires exact hardware/config/isolated evidence |
| New executable/physical result | TEST-CONFIRMED **none** | No compute dispatched |

**Next discriminating question:** Compare the source of the QtPlasmaC `M190/M66` material-handshake `motion.digital-in-03` acknowledgement with the above **realtime** `db_arc-ok` path in one fully pinned sim configuration, to avoid confusing userspace material-ready with arc-ready; or investigate an inspectable DXF LWPOLYLINE bulge/INSERT transform implementation if QtPlasmaC source depth reaches an information-gain stop. A bounded local-runner fixture would only be justified if an unresolved runtime assertion remains after source tracing and physical isolation/runner access are proven. Never dispatch hosted Actions. Graduated levels and independent safety/evaluator gates remain unchanged.
