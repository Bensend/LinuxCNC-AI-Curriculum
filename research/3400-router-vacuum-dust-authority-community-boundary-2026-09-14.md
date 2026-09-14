# 3400 Router / Woodworking — vacuum and dust authority community boundary

Date: 2026-09-14
Status: community evidence integrated; vacuum-achieved proof remains source-poor

## Community evidence

Two LinuxCNC router discussions provide useful authority patterns without establishing a universal production implementation.

### Vacuum clamping: program/manual/UI authority

LinuxCNC forum thread `Options` (2016) describes a router operator combining custom M1xx commands with a VCP/manual interface to control vacuum clamping. The discussion explicitly wrestles with keeping GUI indication synchronized when both program and operator can change the same output. Suggested approaches include direct HAL UI control and explicit logic/arbitration between command sources.

Durable lesson: vacuum clamping is not merely `one G-code -> one relay`; it commonly needs **program/manual authority arbitration plus an operator-visible state model**.

But a GUI button or command mirror is not proof that vacuum has actually been achieved.

### Dust collection: machine-local versus shop-level authority

LinuxCNC forum thread `Method of Controlling Dust Collector for CNC Router` (2020) documents multiple ordinary-control patterns:

- tie a dust-collector output to spindle enable;
- use `timedelay` for delayed shutoff;
- repurpose M7/M8 coolant commands for explicit process control.

In the same discussion, Todd Zuercher notes that the dust collector in a larger shop runs continuously, while vacuum clamping is controlled through custom M-codes and manual/VCP buttons.

Durable lesson: the chip-extraction system may have a **shop-level authority** that is intentionally independent of machine-cycle control, while a movable dust foot or local blast gate remains machine-local. Do not assume all dust hardware should start/stop with M3/M5.

## Reconciliation with real DCNC source

The inspectable `Funkenjaeger/fj-lcnc-cfg` machine supplies a stateful movable dust-shoe implementation with a retract-position sensor, timed actuator sequence and ATC prior-state restoration. That is stronger evidence for **dust-foot positioning** than the generic forum suggestions are for collector airflow.

Together the evidence supports separating:

`dust collector / extraction availability`

from

`local dust-foot position / blast gate`

from

`vacuum workholding request`

from

`vacuum achieved / part-hold confidence`.

## Source-availability gap

The bounded search in this lesson did not surface a trustworthy public LinuxCNC router configuration that combines all of:

- multiple vacuum zones/pods;
- real vacuum/pressure feedback;
- a qualified `vacuum ready` condition before cutting;
- loss-of-vacuum response while cutting;
- restart/recovery after a vacuum fault;
- explicit manual/program arbitration.

Therefore do **not** freeze a universal vacuum threshold, lead time, zone sequence or restart policy from generic examples.

## Playbook contract

Until stronger field source appears, model router workholding as:

`program/operator hold request -> zone/pump/valve command authority -> physical vacuum generation -> independent achieved/healthy witness -> cutting permissive -> continuous loss monitoring -> defined pause/abort/recovery`

Every arrow after command authority remains machine-specific unless an inspectable implementation establishes it.

## Adversarial review

1. Does a VCP button illuminated ON prove the part is clamped? **No.**
2. Does pump command prove vacuum reached? **No.**
3. Is a dust collector always machine-owned? **No.** Real shops may run centralized collection continuously.
4. Is a dust-foot sensor equivalent to airflow proof? **No.** It proves position only.
5. Can timedelay provide useful lead/lag? **Yes**, but it does not prove extraction or vacuum effectiveness.
6. Can M7/M8 or M1xx be used as ordinary command authority? **Yes**, but the downstream hardware/readiness contract still matters.
7. Did this search justify a universal loss-of-vacuum recovery sequence? **No.** Public evidence remains insufficient.

Result: **7/7 boundary checks passed.**

## Evidence URLs

- LinuxCNC forum, `Method of Controlling Dust Collector for CNC Router`: https://forum.linuxcnc.org/38-general-linuxcnc-questions/39488-method-of-controlling-dust-collector-for-cnc-router
- LinuxCNC forum, `Options` thread (vacuum/VCP/custom M-code authority): forum evidence reviewed during this lesson; preserve as community evidence rather than source-level contract.

## Promotion decision

Promote the authority separation above. Keep production vacuum-ready/loss/recovery logic **OPEN / SOURCE-POOR** until a real inspectable implementation appears.
