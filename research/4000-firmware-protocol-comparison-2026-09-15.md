# 4000 FPGA firmware/protocol comparison — 2026-09-15

Status: SOURCE / ARCHITECTURE DECISION SUPPORT

## Scope

Compare three distinct LinuxCNC FPGA paths for the reusable OpenPressBrake/general CNC controller core:

1. upstream HostMot2 + `hm2_eth`;
2. ColorCNC/Lcnc-style Colorlight Etherbone architecture already traced in this curriculum;
3. LiteX-CNC.

Do not call LiteX-CNC or Lcnc HostMot2. Similar HAL concepts do not make the protocols or firmware architectures identical.

## HostMot2 / hm2_eth

Pinned upstream LinuxCNC evidence shows a mature Ethernet realtime transport with explicit socket receive timeout handling, packet-error diagnostics and an accumulated packet-error level/limit. The driver exposes `packet-error` for the most recent cycle and maintains total/error-level state rather than silently treating communication as valid. HostMot2's watchdog is tied to periodic hm2 write execution; prior source tracing in this curriculum established bite state, explicit recovery/rearm and FPGA-state reconstruction behavior.

HostMot2 has mature native encoder/stepgen/PWM/GPIO semantics and broad LinuxCNC configuration/documentation. Its principal cost for this project is architectural: adding a genuinely new proportional-current/valve FPGA function means extending the HostMot2 module ecosystem, descriptors, firmware and LinuxCNC driver rather than simply dropping a project-local register module into a generator framework. ECP5 portability is possible engineering work, but upstream HostMot2 is not itself an ECP5/Colorlight firmware generator.

## LiteX-CNC

Current upstream LiteX-CNC explicitly supports Colorlight 5A-75B/5A-75E with the open-source toolchain and describes its driver structure as inspired by HostMot2 rather than being HostMot2.

The Ethernet path is Etherbone over Gigabit Ethernet. The LinuxCNC component exports separate `read` and `write` HAL functions and recommends read-before-write ordering. The write cycle prepares one aggregate write buffer containing watchdog/wallclock plus each registered custom module, then sends it. The read cycle performs a request/response transaction for one aggregate read buffer and then dispatches data to watchdog/wallclock and registered modules.

Important transport evidence: the Colorlight Ethernet driver explicitly waits for the TX buffer to empty before both reads and writes because packets arriving too close together can crash the LiteEth core. A read sends a request and then waits for a response of the exact expected length. A write sends the aggregate write packet. This is a concrete implementation constraint that must be considered in servo-period/jitter testing rather than assuming ideal Gigabit behavior.

Important freshness weakness in the inspected revision: `litexcnc_read()` calls the board read function and then contains a source TODO saying not to process read data when the read has failed; it proceeds to process the read buffer. The Ethernet read routine itself does return failure for send failure or unexpected response length, but the generic read loop currently does not visibly gate module processing on that return value. Therefore input VALUE and input VALID/FRESH must not be conflated in our architecture.

LiteX-CNC has a strong project fit for custom functions. Its firmware/driver model explicitly registers custom modules, allocates configuration/read/write buffer requirements per module, and invokes module-specific configure/process-read/prepare-write hooks. That is a natural insertion point for a proportional-current/valve module with command, measured current, saturation/fault, enable, freshness and diagnostic registers.

Prior curriculum source tracing established that LiteX-CNC implements an FPGA watchdog and that at least its PWM module removes PWM enable on reset/watchdog. Before selecting it, output gating must be audited across every output-producing module we intend to use, not inferred from PWM alone.

## ColorCNC / Lcnc-style Etherbone

The already-preserved curriculum trace shows a lightweight Colorlight-native ECP5/Etherbone route with explicit enable request/confirmation, FPGA watchdog and hardware reset semantics. It is attractive because it starts close to the exact Colorlight hardware being copied/adapted and leaves firmware ownership highly local.

The cost is maintenance and ecosystem depth: compared with upstream HostMot2, more protocol/module behavior becomes project-owned; compared with LiteX-CNC, less reusable generator/module infrastructure is available. This path is best treated as the minimal-control/reference architecture, not automatically the long-term choice merely because it is small.

## Decision matrix

| Criterion | HostMot2/hm2_eth | Lcnc/ColorCNC style | LiteX-CNC |
|---|---|---|---|
| LinuxCNC maturity/native semantics | strongest | project/community-specific | good, separate driver |
| Colorlight/ECP5 fit | requires port/integration | native target | native supported target |
| Open toolchain on 5A-75B/E | not inherent | yes in Colorlight ecosystem | explicit upstream support |
| Ethernet diagnostics | mature packet error/timeout accounting | bounded/custom | Etherbone errors exist; generic failed-read freshness handling needs strengthening |
| Watchdog model | mature bite/rearm/reconstruction | explicit enable/watchdog/reset | FPGA watchdog; verify all output modules |
| Custom proportional-current module | possible but highest integration burden | easy if project-owned | strong modular insertion model |
| Encoder/stepgen/PWM/GPIO maturity | strongest | narrower/custom | existing modular implementations |
| Maintenance burden for us | low for standard modules, high for novel firmware port/module | highest project ownership | moderate; generator/module framework helps |

## Architecture recommendation

**Preferred implementation baseline: LiteX-CNC, with HostMot2 behavior used as the maturity/reference standard and Lcnc/ColorCNC retained as a minimal known-working Colorlight reference.**

This is not yet an irreversible freeze. It is the working selection for the next hardware/firmware design pass because it best combines:

- direct ECP5/Colorlight open-toolchain support;
- a reusable custom-module mechanism suited to the proportional-current driver;
- LinuxCNC realtime read/write integration;
- an FPGA-local watchdog;
- less project-owned protocol machinery than the Lcnc route.

### Conditions before final freeze

1. Add/require explicit read-valid/freshness handling so failed Etherbone reads cannot be consumed as valid current-cycle feedback.
2. Audit watchdog/reset gating for GPIO, stepgen and every analog/PWM/current output, not only PWM.
3. Define an explicit generation/heartbeat or equivalent freshness witness for command and feedback frames.
4. Measure worst-case Ethernet transaction time/jitter on the selected PHY/board implementation before declaring a supported servo period.
5. Keep watchdog recovery explicit: communications returning must not automatically reauthorize stale machine outputs.

If those conditions become disproportionately invasive, HostMot2 becomes the fallback despite the ECP5/custom-module integration cost.

## Hardware consequence

The protocol comparison does **not** justify two Ethernet PHYs or SDRAM. One dedicated Gigabit PHY is sufficient for the working LiteX-CNC control architecture. A second PHY and SDRAM remain omit-by-default unless a later concrete requirement appears. USB-C remains service/program/debug only unless a separate control-transport decision is deliberately made.

## Lab decision

No simulation/lab is needed yet. The next justified experiment is a later hardware/firmware transport measurement: servo-period transaction latency/jitter, dropped/delayed packet freshness behavior, watchdog bite, and explicit rearm. That should run only after the core board/firmware target is concrete enough to make the measurement authoritative.
