# MOTION-220 — EtherCAT HAL AL-state pins: exact exports and mixed-state trap (4000, NON-GRADUATED)

Date: 2026-11-04. Scope: source-only investigation; no EtherCAT hardware, build, runtime, or CI. Prerequisite: [MOTION-219](4400_LINUXCNC_MOTION_219_LCEC_PDO_VALIDITY_AND_STATE_CADENCE_2026-11-04.md).

## Pinned evidence

Third-party archived `sittner/linuxcnc-ethercat`, commit `225d5a3589a7cf8ccb8ee9edc894c1ddad4a7b13`. [src/master.c](https://github.com/sittner/linuxcnc-ethercat/blob/225d5a3589a7cf8ccb8ee9edc894c1ddad4a7b13/src/master.c#L33-L42), blob `e6b984b4a647ec1a1211d4c857521b3e52873856`; [src/slave.c](https://github.com/sittner/linuxcnc-ethercat/blob/225d5a3589a7cf8ccb8ee9edc894c1ddad4a7b13/src/slave.c#L32-L39), blob `f92bcba1aeb601d2566e1c2e0dd5dcc9c6e93541`; [src/lcec.h](https://github.com/sittner/linuxcnc-ethercat/blob/225d5a3589a7cf8ccb8ee9edc894c1ddad4a7b13/src/lcec.h), blob `e5a5a6a92c8599c8cb8ccd43fa9c69419ad23005`. Not LinuxCNC core. Archived revision is not a maintained deployment recommendation.

## Exact HAL export contract (SOURCE-CONFIRMED at pinned revision)

`master_global_pins` defines `%s.slaves-responding`, `%s.state-init`, `%s.state-preop`, `%s.state-safeop`, `%s.state-op`, `%s.link-up`, `%s.all-op`. `lcec_init_master_hal(pfx,global)` applies the provided prefix. Per-master PLL pins `%s.pll-err`, `%s.pll-out`, `%s.pll-reset-count` are **conditional on RTAPI_TASK_PLL_SUPPORT**, and are not added to the aggregate global master.

`slave_pins` defines `%s.%s.%s.slave-online`, `slave-oper`, `slave-state-init`, `slave-state-preop`, `slave-state-safeop`, `slave-state-op` with that same three-component prefix. `lcec_init_slave_state_hal` passes `LCEC_MODULE_NAME`, master name and slave name; the latter two are configuration-dependent. Do not substitute a guessed slave address for its configured name. Inspect the loaded instance with `halcmd show pin lcec` before wiring.

## Important semantic distinction

`lcec_update_master_hal` sets `state-op = (ms->al_states & 0x08) != 0`, while `all-op = (ms->al_states == 0x08)`. Therefore `state-op` can be true **even if another AL-state bit is set**. For example, `al_states=0x0c` (OP and SAFEOP bits) yields `state-op=1`, `state-safeop=1`, `all-op=0`. The code's bitmask expresses presence of an AL state, not proof that every slave is OP. In contrast `all-op` requires the AL-state mask to contain *only* OP. The `lcec.h` prose describing `state_op` as all-slaves OP is inconsistent with this implementation: for this pinned revision the executable assignment is authoritative. `all-op` remains a sampled AL-state summary, **not** a per-cycle PDO working-counter or freshness assertion.

`lcec_update_slave_state_hal` sets `slave-online=ss->online`, `slave-oper=ss->operational`, and the four `slave-state-*` flags by masking `ss->al_state` with 1/2/4/8. These values are populated from the slave-state poll path documented in MOTION-219; they are not a guaranteed current-cycle PDO success signal.

## Disconnected reproduction / interpretation exercise

Inspect the pinned functions above and evaluate the following truth table without running a machine:

| AL mask | state-init | state-preop | state-safeop | state-op | all-op |
|---|---:|---:|---:|---:|---:|
| 0x08 | 0 | 0 | 0 | 1 | 1 |
| 0x0c | 0 | 0 | 1 | 1 | 0 |
| 0x04 | 0 | 0 | 1 | 0 | 0 |
| 0x00 | 0 | 0 | 0 | 0 | 0 |
| 0x0a | 0 | 1 | 0 | 1 | 0 |

This is an **analytical oracle**, not a runtime observation. A candidate diagnostic HAL fragment is **not yet deployment validated**: `net ec-al-summary lcec.0.all-op => some-diagnostic-component.in`. Confirm the actual master prefix and target component pin in the running configuration; do not connect this alone as a safety-rated permissive.

## Failure and evidence boundaries

MOTION-219 established that top-level `lcec_read_master` calls receive/process then slave callbacks without a visible `ecrt_domain_state` working-counter gate. The newly verified pin names and AL bit semantics **do not** resolve whether IgH retains old PDO image bytes after a missing frame, nor whether a specific slave's `proc_read` modifies those bytes. No `pdo-fresh` or `working-counter` HAL pin is established by these descriptors. IgH `ec_domain_state_t`, its update timing, device callbacks, and maintained-fork differences remain **UNKNOWN**. Do not infer a working-counter value from `all-op`.

## Review questions (not blind evaluation)

1. If `state-op=1` and `state-safeop=1`, must every slave be OP? **No**: see 0x0c.
2. If `all-op=1`, did the most recent PDO cycle succeed? **Not established**: sampled AL state is not WC.
3. If `slave-oper=1` but motion feedback does not change, is the drive stationary? **Unknown** without independent physical feedback and PDO validity.
4. Which names can safely be hardcoded? Descriptor suffixes are source-confirmed; instance prefixes and device-specific PDO pins must be discovered from actual config.

## Evidence ledger

| Finding | Classification | Scope |
|---|---|---|
| Exact master/slave descriptor suffixes | SOURCE-CONFIRMED | archived commit above |
| `state-op` bitmask versus `all-op` equality | SOURCE-CONFIRMED | `master.c:lcec_update_master_hal` |
| Contradiction with `lcec.h` prose for `state_op` | SOURCE-CONFIRMED conflict | implementation controls |
| Working-counter/PDO freshness semantics | UNKNOWN | IgH/device/maintained fork uninspected |
| Real-time and hardware behavior | NOT TESTED | no execution |

## Next

Inspect IgH `ecrt_domain_state` / `ec_domain_state_t` and the maintained linuxcnc-ethercat fork at immutable revisions; compare `proc_read` of one real device. If inaccessible, rotate to trajectory planner or homing source rather than speculate. No changes to graduated levels, blind gates, independent personnel-safety authority, or physical-machine permissions.
