# 4400-USB-PENDANT-01 — upstream LinuxCNC documentation review packet (not submitted)
**2026-10-30 | documentation/source discrepancy | no source code patch or machine test | NON-GRADUATED**

## Proposed upstream issue title
`xhc-whb04b-6 man page: RESET references nonexistent estop pins; clarify USB receiver vs wireless pendant connection`

## Concise maintainer report (ready to adapt, not posted)
The official `xhc-whb04b-6` man page's RESET button description refers to `whb.halui.estop.{activate,reset}`, but the actual component at **v2.9.10** and inspected development commit **24e84c4506b41634240f7087f0295e361a954886** does not register these `whb.halui.estop.*` pins. `Hal::setReset` asserts `whb.halui.machine.on` or `whb.halui.machine.off` according to the ordinary `whb.halui.machine.is-on` feedback, while the STOP button asserts `whb.halui.program.stop`. The supplied example configuration already connects the `machine.on/off` and `program.stop` pins.

The development `hal.h` header comment for `Hal::setReset` likewise still suggests connecting the reset pin to `halui.estop.activate` (around lines 385–391), despite the implemented machine-on/off toggle. This is an additional **source-comment-versus-implementation discrepancy**, not evidence that a real E-stop pin is registered. [Pinned header](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/user_comps/xhc-whb04b-6/hal.h#L385-L391).

The man page also describes `whb.pendant.is-connected` as tracking whether the remote is not sleeping. In the inspected `XhcWhb04b6Component::run` implementation, this bit is asserted after **USB initialization** and cleared on USB processing/disconnection; sleeping is separately derived from specific received packets. A USB transfer timeout resubmits the transfer without a protective stop. A receiver being connected is not demonstrated to prove the remote radio link is live.

Please correct the public descriptions to distinguish ordinary LinuxCNC machine-on/off and program-stop requests from an independently implemented personnel-safety E-stop, and distinguish USB receiver presence from validated radio freshness. This is a documentation clarification, **not** a proposal to treat USB/HAL as safety-rated hardware or to assert that an installed machine is unsafe.

## Exact source pointers
| Surface | Stable v2.9.10 evidence | Development evidence |
|---|---|---|
| RESET/STOP helpers | [`hal.cc` lines 721–746](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/user_comps/xhc-whb04b-6/hal.cc#L721-L746) blob `f38ff778995148fac3da1a5b3d048134d1405d83` | [`hal.cc` around 713–742](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/user_comps/xhc-whb04b-6/hal.cc#L713-L742) blob `f75611c6b0605cfd9dda8e99b482d5f6bab7d1d6` |
| Pin registration | [`hal.cc` 491–549](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/user_comps/xhc-whb04b-6/hal.cc#L491-L549) | [development `hal.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/user_comps/xhc-whb04b-6/hal.cc) |
| Receiver connected | [`xhc-whb04b6.cc` 430–463](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/user_comps/xhc-whb04b-6/xhc-whb04b6.cc#L430-L463) | [development receiver loop](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/user_comps/xhc-whb04b-6/xhc-whb04b6.cc) |
| Sleeping and USB timeout | [`usb.cc` 493–555](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/user_comps/xhc-whb04b-6/usb.cc#L493-L555) | [development `usb.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/user_comps/xhc-whb04b-6/usb.cc) |
| Documentation | [`xhc-whb04b-6.1.adoc` 304–314, 394–399](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/man/man1/xhc-whb04b-6.1.adoc) blob `0ffb738990104ce511407fa7cabd0cede2df1d42` | development docs blob `6cd5f625ab2e0d5ec0f731b013b6d4498cd4496e` |
| Shipped example | [`example-configuration.md` 45–55](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/user_comps/xhc-whb04b-6/example-configuration.md#L45-L55) blob `9d222f6df4d7743c86270b5fb0fc7bac290d8b1f` | Not separately inspected |

## Proposed minimal documentation wording (review before patch)
- `whb.button.reset`: “Button event for RESET. The component's built-in handler requests ordinary LinuxCNC machine ON or OFF via `whb.halui.machine.on/off`, depending on `whb.halui.machine.is-on`. This is **not** an independent E-stop, safety reset, or guard-rearm signal.”
- `whb.button.stop`: “Button event for STOP. The built-in handler requests ordinary program stop via `whb.halui.program.stop`; this does not establish physical standstill or isolation.”
- `whb.pendant.is-connected`: “USB receiver/session connected as reported by this userspace component. This is not a validated wireless remote heartbeat or safety-rated link-loss output.”
- `whb.pendant.is-sleeping`: “Status inferred from recognized pendant sleep/wake packets. Does not prove bounded RF-link fault detection or a safe machine state.”

## Review acceptance, not a lab request
1. Maintainer checks selected branch/source pins and man page; confirm no other supported variant intentionally exports `whb.halui.estop.*`.
2. Update documentation and example references only where source-backed; no invented safety promise, stop-time guarantee or automatic-restart behavior.
3. Prefer an ordinary documentation review over a hardware experiment. A future source code change for radio freshness requires a separate normal-control requirements review; it must **not** make LinuxCNC/HAL the sole personnel-safety path.
4. Existing upstream issue search (2026-10-30) returned a generic HALUI issue #3583 and a separate XHC assert() issue #2237, but no direct match for this exact documentation conflict in the bounded search. **Not exhaustive.** Check again before submission.
5. **No upstream issue/PR was created by this curriculum session.** Source review is documentary; no LinuxCNC runtime, radio hardware, machine or qualified independent safety validation.

## Field boundary
Use a separately rated hardwired E-stop/protective system with independently validated final elements for the selected machine. A cheap USB handwheel may be an excellent **normal operator interface**; its labels and ordinary HAL bits cannot be promoted to personnel-safety authority. OpenPressBrake installed pendant identity UNKNOWN; G0/G1 HOLD; independent evaluator OPEN.
