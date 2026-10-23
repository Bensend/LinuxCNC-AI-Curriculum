# 4400 — LinuxCNC 2.9.10 network-command authority, status freshness, and independent safety boundary

**Original source-trace research | 2026-10-23 | R&D only; no machine validation.**

## Specific engineering question
Can a remote LinuxCNC UI be safely treated as a read-only diagnostic channel or a personnel-safety reset/stop authority merely because its network protocol has a handshake, an enable password, and an E-stop command? **No.** The actual source shows a broad command surface, a software-level enable gate, optional stale status, and network connection lifecycle that is not a safety lifecycle. A small press-brake R&D design should keep these propositions separate.

## Pinned primary sources and evidence classes
- **SOURCE-CONFIRMED:** LinuxCNC tag **v2.9.10**, `src/emc/usr_intf/emcrsh.cc`, fetched as Git blob **`81b387c20f297d43b7fb63ad26fcf4d25ec0aa62`**, https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/emcrsh.cc . Line ranges below refer to this exact blob.
- **DOC-CONFIRMED:** official LinuxCNC 2.9 `linuxcncrsh(1)` manual, https://linuxcnc.org/docs/2.9/html/man/man1/linuxcncrsh.1.html (especially options, `enable`, `update`, `estop`, `machine`, `mdi`, `run`, `override_limits`).
- **DOC-CONFIRMED, separate policy:** NIST SP 800-82 Rev.3 (September 2023), §6.2.10 on OT remote access, https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-82r3.pdf ; previously scoped in [the 4400 remote-support contract](../safety-course/4400_REMOTE_SUPPORT_WEB_UI_AUTHORITY_AND_INDEPENDENT_SAFETY_CONTRACT_2026-10-23.md).
- **TEST-CONFIRMED:** none in this study. **COMMUNITY-REPORTED:** not used for the safety conclusion. **UNKNOWN:** OpenPressBrake installed remote interfaces, access controls, physical final elements, stopping/holding/guard/escape behavior.

## Source-level execution path

| Observation | Pinned source | Evidentiary boundary |
|---|---|---|
| Listener opens IPv4 TCP socket, binds `INADDR_ANY` and configured port, then listens. | `initSockets()`, lines 542–563 | **SOURCE-CONFIRMED** for this build. Does not prove a deployed firewall allows access; **does** mean the program itself is not localhost-only. |
| Built-in connection/enable passwords are `EMC` and `EMCTOO`; `--connectpw` and `--enablepw` replace them. | lines 470–475, 2925–2939 | **SOURCE-CONFIRMED**. The official manual says both are transmitted in cleartext; they are not a safety or strong network-authentication boundary. |
| Each accepted client gets a context and worker thread. `HELLO` checks the connection password and marks `linked=true`. | `sockMain()` lines 2842–2883; `commandHello()` lines 603–621 | **SOURCE-CONFIRMED**. This is a network session, not an independent local operator-presence witness. |
| `SET ENABLE` compares a second password and writes **global** `enabledConn=context->cliSock`; privileged SET checks socket equality. | `setEnable()` lines 764–779; `commandSet()` lines 1307–1333 | **SOURCE-CONFIRMED**. This gate is ordinary software authorization; no physical key, reset, or safety-relay proof occurs here. |
| Network SET dispatch includes `ESTOP`, `MACHINE`, `MODE`, `HOME`, `JOG`, `MDI`, `RUN`, `OVERRIDE_LIMITS`, etc. | lines 428–441, 1334–1410; `setJog()` 1075–1101; `setMDI()` 1012–1019; `setRun()` 1175–1187 | **SOURCE-CONFIRMED**. A proxy that merely exposes the original interface is not a read-only diagnostics service. |
| `setEStop()` calls `sendEstop()` or `sendEstopReset()`; `setMachine()` calls `sendMachineOn/Off()`. | lines 839–856 | **SOURCE-CONFIRMED**: normal LinuxCNC command helpers. **UNKNOWN:** whether any selected machine has an independent physical safety reset; these calls do not establish one. |
| `GET ESTOP` and `GET MACHINE` read `emcStatus->task.state`, not a direct load/guard/valve physical witness. | lines 1518–1525, 1592–1599 | **SOURCE-CONFIRMED**. HMI words “E-stop off” or “machine on” are software state indications only. |
| `SET UPDATE NONE` selects `EMC_UPDATE_NONE`; GET refreshes status only when `emcUpdateType==EMC_UPDATE_AUTO`. | lines 885–892, 2388–2405 | **SOURCE-CONFIRMED**. Official manual explicitly warns that `none` returns stale values. Fresh software status still does not prove physical safety. |
| Socket EOF/read failure goes to `finished`, closes socket and frees context; no stop or independent reset appears in this path. | `readClient()` lines 2777–2835 | **SOURCE-CONFIRMED** for this function. **INFERENCE:** a lost diagnostic connection must not be assumed to trigger a protective stop or revoke all ordinary control states. Inspect wider integration before asserting machine behavior. |

### Important adversarial observation — authorization lifetime
`enabledConn` is a process-global integer (line 470); `setEnable()` assigns it a socket descriptor (lines 764–779), while `readClient()` closes client sockets without clearing `enabledConn` (lines 2830–2835). **SOURCE-CONFIRMED** is the missing explicit revocation in this path. **INFERENCE/UNTESTED:** descriptor reuse or concurrency may produce unexpected command-authority attribution in some lifecycles. Do **not** claim an exploit, guaranteed unauthorized command, or machine-specific vulnerability without an independently reviewed, isolated test. The safe architectural decision does not depend on exploiting this hypothesis: **never expose this command service as a personnel-safety authority or directly to untrusted networks**. Source code and protocol were studied without executing the service.

### Another scope trap — command acknowledgment
`setMachine()` returns `rtNoError` after sending `sendMachineOn/Off()` (lines 839–847); `commandSet()` can send an ACK on `rtNoError` (lines 1413–1431). **SOURCE-CONFIRMED:** the handler's ACK is not a witnessed contactor, drive, valve, stopped load, or protective-device state. The deeper Task/NML command-completion semantics are outside this narrow trace. A web adapter must not relabel protocol ACK as physical actuation or safety acceptance.

## Minimal practical architecture derived from the evidence (INFERENCE)
1. **Prefer not running `linuxcncrsh`** when remote diagnostics are unnecessary. If running for development, keep the command-capable endpoint inaccessible from the general network, with a separately controlled local development boundary. Changing its password is not a safety solution.
2. Use a **distinct read-only telemetry exporter** with explicit allowlisted fields, timestamps, sample age, provenance, and no pass-through arbitrary `SET`, MDI, program, reset, jog, or limit-override commands. Do not merely hide controls in the browser: enforce denial in the backend.
3. Require **local operator authority for normal motion**, and a **separate independent safety system and physical energy-control measures** for protective stop, reset/rearm, guard functions, ram holding, and maintenance isolation. Local reset must not itself initiate motion.
4. On network outage, process crash, client reconnect, stale status, or host reboot, ordinary software may enter a defined normal-control state, but **the independent personnel-safety function must remain effective without this software or network**.
5. Display ordinary `TASK ESTOP`, physical safety input, physical final-element feedback, load restraint, guard status, diagnostic freshness and motion authorization as **different** fields. Where actual physical evidence is unavailable, say `UNKNOWN`, not “safe.”

## Failure-path review, not a simulation
- **Loss of connection:** closing a TCP socket is not proof of stopping, holding, or isolation.
- **Stale status:** `GET ESTOP OFF` may be an old task state if updates are disabled; even fresh status is not a physical safe-state witness.
- **Credentialed remote user:** successful `HELLO` and `ENABLE` allow a broad ordinary command surface, including reset/motion requests; they do not imply a person is physically at the machine.
- **Command acknowledgment:** `SET ... ACK` does not demonstrate protective stop performance, contactor opening, brake engagement, or safe access.
- **Service replacement:** moving from this protocol to REST/WebSocket changes transport, not the underlying safety boundary; permission enforcement must be explicit and server-side.

## Evidence needed to advance
- Selected OpenPressBrake architecture: whether `linuxcncrsh` is deployed at all; local/network interfaces, allowed API commands, process ownership and network isolation; independently wired safety chain and reset/restart mechanism.
- For **non-hazardous** source-level verification, first freeze a concrete protocol/lifecycle question, then consider a bounded self-hosted test on `[self-hosted, openpressbrake]` only if documentary/source analysis is insufficient. No GitHub-hosted runner and no physical machine motion.
- Physical stopping, holding, guarding, escape, isolation, rearm and machine acceptance remain **UNKNOWN/NOT RUN**. The selected machine is **not authorized for personnel-exposed hazardous operation** on this evidence. Remote/isolated experimentation still requires personnel exclusion and explicit residual-risk review.

## Transfer question for the learner
A remote screen shows `GET ESTOP OFF`, the browser has reconnected, and the operator sees `SET MACHINE ACK`. Identify **three independent propositions** still unproved, the source paths explaining why, and the lowest-friction way to make the interface useful without making it a safety authority. See [technician card](../safety-course/4400_LINUXCNCRSH_REMOTE_COMMAND_STALE_STATE_AND_REARM_FIELD_CARD_2026-10-23.md).
