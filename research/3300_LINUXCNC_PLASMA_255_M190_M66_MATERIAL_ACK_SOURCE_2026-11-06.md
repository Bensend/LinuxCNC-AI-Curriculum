# PLASMA-255 — QtPlasmaC M190 / M66 material acknowledgement (2026-11-06)

**Status:** source-confirmed, bounded, non-graduated; no executable or physical-machine test. **Scope:** LinuxCNC tag `v2.9.10`.

## Provenance (immutable Git blob IDs)
- [M190 userspace remap](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/M190), blob `825ebe01292346d78580422d871264f5393644a6`.
- [QtPlasmaC GUI handler](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/share/qtvcp/screens/qtplasmac/qtplasmac_handler.py), blob `bbfff1eaa906a496aad19f1602464e8ff2828695`.
- [QtPlasmaC G-code filter](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py), blob `4cdae156b94b607bd2514b1573baabc83f396f23`.
- [QtPlasmaC circle generator](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/python/plasmac/circle.py), blob `f22a91d119d120fa3123628b482df3c6e6750ed6` (predecessor PLASMA-254).
- [QtPlasmaC HAL component includes](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/qtplasmac_comp.hal), blob `f3fc216a4932b02a2fe9e8de95cb7c08ced5931e`.

## Exact mechanism

The GUI handler lines 124–132 copies the `M190` program into the machine configuration directory when absent; thus **M190 is not a built-in generic G-code material selector**. Deployment depends on the remap/program setup and configuration path, which must be checked on a real machine.

The `M190` script parses its first argument as `int(float(sys.argv[1]))`, reads `qtplasmac.material_change_number` with `halcmd getp`, and compares the requested material. When different, it writes `material_change=1`, then `material_change_number=<requested>`; when equal, it writes `material_change=3`. It polls while the state is 1 or 3 with a **0.5-second userspace timeout**; on expiry it sets `material_change_timeout=1`, breaks, and then sets `material_change=0`. The script catches all exceptions without reporting them and exits, so a successful process exit is **not** proof of successful material selection.

The GUI handler creates the material-change pins at lines 806–810. Its `material_change_number_pin_changed` callback (4824–4841) selects the requested material in the GUI when present; `material_changed` (4791–4812) responds to automatic selection by driving `motion.digital-in-03` low, applying material settings and setting `material_change=2`, then driving `motion.digital-in-03` high. The `material_change_pin_changed` callback (4817–4822) also sets the digital input low for state 0, and high for state 3 before resetting state to 0. The timeout callback (4843–4852) emits an operator error and clears digital-in-03. **This is a GUI/HAL userspace handshake, not a realtime hardware safety channel.**

The filter `qtplasmac_gcode.py` recognizes M190 at lines 339–344, checks the material number and material dictionary in `do_material_change` (959–987), and flags M66 under incompatible G4x offset mode in `material_change_wait` (988–993). Filter validation does not replace runtime GUI/halcmd acknowledgment. The conversational generator emits `M190 Pn` followed by `M66 P3 L3 Q1` (PLASMA-254). **M66 P3 L3 Q1 is an input-3 high-level wait with Q1 timeout; it is not equivalent to the M190 script's 0.5-second polling timeout.** An M190 timeout followed by an M66 wait can still leave the material selection unacknowledged. Do not infer a successful cut or safe failure solely from these source paths.

## Failure discriminators / implementation exercise

1. **Already-selected material:** M190 sets state 3, GUI drives digital-in-03 high, then resets to 0. Confirm M66 sees the high signal rather than assuming a new GUI selection must occur.
2. **New material present:** M190 requests state 1 and material number; GUI selection drives low→high and state 2. Confirm material-dependent cut feed actually updates before the first torch start.
3. **Unknown material:** filter can reject it at load; GUI callback can reject runtime selection. Keep those as distinct failure boundaries.
4. **GUI stalled or pin not writable:** M190 can time out after 0.5 s and silently exit; M66 has its own Q1 deadline. Capture `material_change`, `material_change_timeout`, `material_change_number`, `motion.digital-in-03`, interpreter error, and effective feed. Never claim that an M190 exit code is a material-change oracle.
5. **Input already high:** check the difference between level wait (`L3`) and edge waits; a stale high signal can satisfy a level condition without proving a fresh material transition. This is a diagnostic prediction, **not runtime-confirmed**.

Reproduce source inspection with `git -C linuxcnc checkout v2.9.10`, `git -C linuxcnc ls-tree -r v2.9.10 -- src/emc/usr_intf/qtplasmac/M190 share/qtvcp/screens/qtplasmac/qtplasmac_handler.py src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py`, and `git -C linuxcnc grep -n -E 'material_change|digital-in-03|M190|M66' v2.9.10 -- src/emc/usr_intf/qtplasmac share/qtvcp/screens/qtplasmac`. These are **instructions, not commands executed in this session**.

## Evidence / limits / next
**SOURCE-CONFIRMED:** script state transitions, timeout, GUI pin callbacks, filter validation. **INFERENCE:** stale-high material acknowledgement risk and exact event ordering under GUI latency. **UNTESTED:** remap activation on a real INI, M66 runtime timing, missing-material behavior, and any machine actuation. No hosted Actions, lab compute, simulator, or machine used. Independent personnel-safety authority and all blind/graduation gates remain unchanged.

**Next:** verify actual remap INI and M66 interpreter/motion input semantics at the same tag; inspect one nesting library's source, transforms, polygon validity and license, and select a bounded offline fixture only if it adds information. Do not turn nesting into a compulsory product build.
