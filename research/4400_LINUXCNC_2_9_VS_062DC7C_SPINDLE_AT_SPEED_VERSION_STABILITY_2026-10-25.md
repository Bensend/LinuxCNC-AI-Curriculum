# 4400 — LinuxCNC 2.9 vs pinned development: ordinary spindle-at-speed permissive default persists
**2026-10-25 | Direct pinned source comparison | SOURCE-CONFIRMED only for two recorded commits | No runtime**

## Question
Was the permissive unwired `spindle.N.at-speed` behavior or command-ramp readiness merely a development-branch anomaly, or does the 2.9 branch show the same safety boundary?

## Revisions and directly inspected source
- **LinuxCNC 2.9 branch head on 2026-10-25:** `a33293f46575c809e082e0806e79ab996f982513`. Pin this SHA; the name `2.9` can advance.
- **Development comparison:** `062dc7c097693bb68e76192516cd92878dd5ecdf`.
- Stable 2.9 `src/emc/motion/motion.c:735–738`: HAL bit input `spindle.%d.at-speed` is created and then **explicitly set to 1**. Source comment explains an unwired input must not block normal motion. [Pinned 2.9 source](https://github.com/LinuxCNC/linuxcnc/blob/a33293f46575c809e082e0806e79ab996f982513/src/emc/motion/motion.c#L735-L738).
- Development `src/emc/motion/motion.c:739–742`: newer typed HAL constructor `hal_pin_new_bool(...,1,...)` performs the **same initial true behavior**. [Pinned development source](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/motion/motion.c#L739-L742).
- Stable 2.9 `src/hal/components/spindle_monitor.comp:20–48`: level-0 idle clears outputs, level-1 sets at-speed on strict `abs(command-feedback)<threshold`, level-2 can set underspeed without clearing at-speed; source-level latch behavior matches the reviewed development `spindle_monitor.comp` despite HAL type/API spelling differences. [Pinned 2.9 component](https://github.com/LinuxCNC/linuxcnc/blob/a33293f46575c809e082e0806e79ab996f982513/src/hal/components/spindle_monitor.comp#L20-L48).
- Stable 2.9 `docs/src/examples/spindle.adoc:148–163`: shipped spindle soft-start example wires `spindle.0.speed-out` into `limit2`, then compares **command** to **ramped command** using `near` for `spindle.0.at-speed`. The example's phrase about actual spindle speed does not turn the HAL signal into physical feedback. [Pinned 2.9 example](https://github.com/LinuxCNC/linuxcnc/blob/a33293f46575c809e082e0806e79ab996f982513/docs/src/examples/spindle.adoc#L148-L163).

## Comparison verdict
| Mechanism | 2.9 pinned source | Development pinned source | Engineering implication |
|---|---|---|---|
| Unwired `at-speed` initial state | true via assignment | true via constructor argument | **SOURCE-CONFIRMED same functional default** in these revisions |
| `spindle_monitor` readiness | strict absolute difference threshold | same | ordinary process readiness; not safety |
| `spindle_monitor` underspeed latch | level 2 sets underspeed, no at-speed clear | same | status bits need exact interpretation |
| Official soft-start example | command vs ramped command | same | no physical sensor proof from this example |

**No TEST-CONFIRMED behavior**: no build, HAL execution, real spindle or selected OpenPressBrake was run. Other versions, custom configs and drive-specific components remain UNKNOWN. The branch snapshots are pinned, so this comparison does not claim every 2.9 release is identical.

## Safety consequence
A CNC wait-for-spindle-ready condition is an ordinary scheduling convenience. Even where it is connected to an actual encoder estimate, it cannot substitute for selected independently qualified speed/standstill safety monitoring, guard authority, final physical stop, gravity holding, electrical/hydraulic isolation, or fresh restart. Do not convert either version's permissive HAL default into a safety function. The [MON-01 integrated lesson](../safety-course/4400_MON_01_SAFE_SPEED_MODE_SELECTION_ENCODER_CCF_AND_PHYSICAL_STOP_MODULE_2026-10-25.md) remains non-graduated pending external evaluation and selected physical evidence.

## Claim classification
SOURCE-CONFIRMED: exact pinned 2.9/development file comparisons. DOC-CONFIRMED: official examples as shipped. TEST-CONFIRMED none; COMMUNITY-REPORTED none; INFERENCE safety implications; UNKNOWN selected wiring and physical performance. No compute or physical test; G0/G1 HOLD, G3/G4 NOT AUTHORIZED.

## Additional pinned trajectory-planner cross-check
Stable 2.9 `src/emc/tp/tp.c` blob `5768d6e6880569f72156ed9a761b5eee531c9fcf`, **lines 2819–2827 and 2897–2903**, iterates `s=0..numSpindles-1` and returns `TP_ERR_WAITING` if a configured spindle's `at_speed` is false. Development `tp.c` blob `2b4024c9ab131f708cc22760300231878c9b0fdc`, **lines 3467–3476 and 3549–3563**, retains the same configured-spindle wait pattern. Stable 2.9 `command.c` blob `f6f92c9f8f41f9dc4929a2699f27ff76c07a6b15`, **lines 1690–1692**, explicitly comments that at-speed defaults true when unwired. **SOURCE-CONFIRMED at these snapshots**, not proof of a safety-related stop; a false ordinary at-speed may hold feed scheduling, and an unwired true may allow it. Selected application and actual machine state UNKNOWN.
