# 4400-HALRMT-01 — Remote HAL service is configuration authority, not personnel-safety authority

**2026-10-26 | SOURCE-CONFIRMED pinned LinuxCNC development `062dc7c097693bb68e76192516cd92878dd5ecdf`; DOC-CONFIRMED official manual; no network probe, no selected-machine evidence.**

## Distinct question
Could an *optional* LinuxCNC remote HAL maintenance interface change normal-control topology or values? What access checks exist? Can their success be treated as a safe restart, physical isolation, or a verified independent safety state? This is distinct from [ordinary local HAL stale-input behavior](4400_LINUXCNC_HAL_UNLINK_STALE_TRUE_AND_SETS_WRITER_BOUNDARY_SOURCE_TRACE_2026-10-26.md) and the earlier `linuxcncrsh` Task-command study: `halrmt` operates on **HAL graph/control**, not merely NML Task commands.

## Pinned implementation
- [`src/hal/utils/halrmt.cc` blob `25f3785`](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/hal/utils/halrmt.cc), `accessLevelType` ~198–214 defines no-auth, HELLO and ENABLE tiers.
- `setEnable` ~1877 checks configured enable password; `getsetList` ~2456–2508 marks `UNLINKP`, `SETP`, `SETS`, `STOP`, `START`, `LOCK`, `UNLOCK` as ENABLE-tier operations; `NET` setter is HELLO-tier in this pinned table. **This is a source-specific access-level distinction, not a universal security guarantee.**
- Dispatch ~2538–2573 checks successful HELLO for HELLO-tier and an enabled connection for ENABLE-tier operations, then calls the setter. `setSetS` ~2273–2283 calls `hal_set_s`; `setNet` ~2048–2117 calls `hal_link`; `setStop` ~2410–2425 calls `hal_stop_threads`.
- [Official LinuxCNC halrmt(1) manual](https://www.linuxcnc.org/docs/stable/html/man/man1/halrmt.1.html) documents an optional socket-based interface, connection/enable password options, and remote HAL `SET`/`GET` commands. It also documents defaults; this note deliberately does not republish credentials or instruct how to reach a machine.
- No source/config evidence was obtained that **OpenPressBrake runs `halrmt`**, that a port is exposed, or that any authentication is configured. Treat all as UNKNOWN.

## Causal chain and limits
An authorized maintenance client (if this optional service is deliberately enabled) may request a permitted normal HAL edit. That edit passes through ordinary HAL setters/link functions and their type/writer/lock restrictions. A successful protocol acknowledgement means only that the requested **software operation** was accepted. It does not prove a safety controller has rearmed, final elements are deenergized, Y1/Y2 are independently held, trapped pressure is isolated, guards are effective, or a worker is outside the hazard zone.

**Counterexample:** A remote service session changes a normal-control writerless permissive to TRUE while the local HMI says READY. The source establishes that `SETS` can set a writerless signal, subject to permissions and type checks. It does **not** establish actual motion, selected-machine installation, or defeat of an independent safety circuit. A separately qualified physical safety path must remain authoritative.

## Practical inexpensive architecture (INFERENCE)
- **Default OFF** for optional remote configuration service; enable only for a documented maintenance purpose, with network isolation, individual access control, change records and expiry/revocation.
- Prefer read-only diagnostics for routine remote support; a remote edit requires local machine ownership, explicit service state, personnel exclusion, and independently verified safe physical conditions. No remote UI should bypass independent safety inputs or directly authorize hazardous motion.
- Preserve the current normal-control graph/hash, writer provenance, service change diff and verified restoration. A single HMI READY light must not mask `HAL graph changed`, `safety reset needed`, or `fresh local start needed`.
- Make on-site maintenance simple: easy isolation, captive guards, obvious diagnostics and a short restoration procedure. If troubleshooting requires bypassing safety devices, redesign the service workflow.
- **HAL lock/password/network control are defense in depth for configuration**, not rated personnel-safety devices. A separate safety-related controller/final-element and mechanical/hydraulic restraint must establish the actual safe state.

## Evidence status
| Proposition | Class | Scope |
|---|---|---|
| Optional `halrmt` source supports HAL topology/value/thread-control setters with access tiers | SOURCE-CONFIRMED | Pinned development only |
| Official manual documents remote service and authentication options | DOC-CONFIRMED | Manual edition may differ from pinned source |
| `NET` HELLO tier versus `SETS` ENABLE tier in inspected table | SOURCE-CONFIRMED | Exact pinned code, not a security certification |
| Selected machine has service enabled or externally reachable | UNKNOWN | No private deployment evidence or scan |
| Successful HAL remote edit authorizes personnel-exposed machine motion | NOT ESTABLISHED / unsafe allocation | Requires independent machine safety and local deliberate start |
| Actual stopping/holding/pressure, PL/SIL, measured safety response | UNKNOWN / NOT TEST-CONFIRMED | Qualified machine-specific validation |

## Next-work and compute
Do not scan production machinery. A **read-only** selected-machine service inventory is justified only with owner/qualified maintainer authorization; keep details private. A laboratory network test is unnecessary for the source-semantic claim and would not prove physical safety. **0 hosted/local compute; G0/G1 HOLD; no personnel-exposed operation.**
