# Pneumatic safe exhaust, residual-pressure, and restart boundary study

Date: 2026-09-19
Lane: independent safety curriculum B

## Why this lane

The primary safety lane is currently advancing hydraulic holding-valve component proof, installed drift witnessing, and press-brake post-service retention/revalidation. This study deliberately selects a different energy domain and different evidence package: pneumatic hazardous-energy removal, residual-pressure witnessing, redundant exhaust-valve diagnostics, and repressurization/restart authority.

## Architecture question

When a machine uses compressed air for clamping, tooling, material handling, guarding, brakes, or actuators, what evidence actually establishes that a safety demand removed the relevant pneumatic hazardous energy, and what must be true before pressure may be deliberately restored?

The curriculum must not collapse commanded valve state, valve-position diagnostics, pressure state, actuator mechanical state, and restart authority into one Boolean.

## Authoritative professional evidence

### SMC VP/VG residual-pressure release family

SMC documents ISO 13849-1-certified 3-port residual-pressure release valves with main-valve-position detection. SMC states that main-valve-position detection identifies inconsistency between input signals and valve operation. Its dual-valve arrangements provide redundancy: if one residual-pressure release valve fails to operate, the other releases residual pressure. SMC explicitly warns that the product is a component of a safety system and does not by itself guarantee safety of the whole machine.

Source:
- https://www.smcworld.com/newproducts/en-sg/vpvg/

### SMC VPX400 safe exhaust valve

SMC documents the VPX400 as a dual-channel safe exhaust valve combining dual residual-pressure release, soft start, and main-valve inconsistency detection. Its published signal diagram distinguishes the two solenoid commands, a main-valve error sensor, a Port 2 pressure-monitoring sensor, and actual Port 2 pressure. That is valuable architectural evidence that valve-command agreement, valve fault detection, and downstream pressure are distinct witnesses.

Sources:
- https://www.smcworld.com/newproducts/en-jp/024/vpx400/
- https://ca01.smcworld.com/catalog/New-products-en/mpv/ES11-121-VPX400/data/ES11-121-VPX400.pdf

### Festo MS6-SV safe exhaust / soft-start family

Festo documentation treats safe de-energization (SDE) and prevention of unexpected restart (PUS) as distinct pneumatic safety sub-functions. The MS6-SV instructions also require both electrical operating voltage and compressed air to be switched off for disassembly, and warn that an inappropriate/clogged silencer can reduce exhaust performance and create back pressure. The same instructions expose pressure monitoring as a diagnostic object rather than treating an electrical command alone as proof of pneumatic state.

Sources:
- https://www.festo.com/cz/cs/e/reseni/bezpecnost-a-udrzitelnost/bezpecnost-stroju/bezpecna-pneumatika-id_4562
- https://media.festo.com/assets/attachment-files/388270b485e773185e6ca6f6fbb5534a8351569a0954c1d2c389fe5420de40070f6148c0ae4309e8d3db1d1855992d5a04527136c670fe204abe7b25df4afafe/MS6%28N%29-SV-_-E-ASIS_instruction_2019-05a_8111060g1.pdf

## Evidence classification

### SOURCE-CONFIRMED

- SMC publishes redundant residual-pressure-release architectures and main-valve inconsistency detection.
- SMC VPX400 exposes separate solenoid, valve-error, downstream-pressure-sensor, and pressure behavior in its published functional diagram.
- Festo publishes safe pneumatic sub-functions including safe de-energization and prevention of unexpected restart.

### DOC-CONFIRMED

- A redundant safe-exhaust component can tolerate a single valve failing to operate by using the companion exhaust path, subject to the documented architecture and application.
- Valve-command state and downstream pressure are not the same witness.
- Exhaust performance can be degraded by the exhaust path itself; Festo specifically warns about silencer restriction/back pressure.
- Pneumatic service can require isolation of both electrical and compressed-air energy.

### TEST-CONFIRMED

None for OpenPressBrake.

### COMMUNITY-REPORTED

None used.

### INFERENCE

- For a machine safety function whose claim depends on pneumatic energy removal, commissioning should witness the relevant downstream pressure or physical hazardous state rather than accepting only a de-energized coil or valve-position indication.
- A dual exhaust valve's diagnostic agreement does not by itself prove that downstream pressure has fallen sufficiently for the machine-specific hazard; blocked exhaust, trapped branches, check valves, accumulators/receivers, or mechanical load can remain separate concerns.
- Soft-start/repressurization is a distinct transition. Restoring pressure must not silently become production restart authority.

### UNKNOWN

For OpenPressBrake, all pneumatic hazards and even whether safety-related pneumatics are present are UNKNOWN. Also UNKNOWN are: valve topology; required exhaust path; downstream volumes; trapped branches; pressure thresholds; exhaust time; silencer specification; sensor thresholds; actuator behavior; stored mechanical energy; acceptable repressurization sequence; PL/SIL/category/DC/CCF; and any machine-specific acceptance criterion.

## Durable freezes

`SAFETY OUTPUT OFF != EXHAUST VALVE COMMANDED OFF != VALVE PHYSICALLY SHIFTED != DOWNSTREAM PRESSURE REMOVED != ACTUATOR/LOAD PHYSICALLY SAFE != PERSONNEL SAFE`

`DUAL VALVE COMMAND AGREEMENT != EXHAUST PATH CLEAR != DOWNSTREAM PRESSURE SAFE`

`PRESSURE SENSOR SAFE STATE != ALL TRAPPED PNEUMATIC/MECHANICAL ENERGY CONTROLLED`

`SAFE EXHAUST COMPLETE != REPRESSURIZATION AUTHORIZED != SAFETY REARM != FRESH ORDINARY START`

## Failure-path / commissioning questions

For any future machine where pneumatic safe exhaust is safety-related, challenge at least these questions using the device and machine manufacturer's approved methods:

1. Does each safety demand remove ordinary pneumatic actuation authority independently of LinuxCNC/HAL state?
2. If one redundant exhaust element fails to shift, does the safety evaluator detect the disagreement and does the companion path still produce the intended safe function?
3. Is downstream pressure independently witnessed where the safety claim depends on pressure removal?
4. Can a restricted silencer/exhaust path, closed downstream valve, check valve, receiver, trapped branch, or other pneumatic element leave hazardous energy after the electrical command appears correct?
5. Does a pressure witness represent the actual hazardous branch, rather than merely a convenient upstream point?
6. If pneumatic pressure falls but gravity, spring, clamp, stored mechanical energy, or another energy domain can still move the hazard, is that separately controlled?
7. After a fault or maintenance intervention, are valve diagnostics, pressure behavior, and physical machine behavior re-proved before safety authority is restored?
8. Does soft-start/repressurization occur as a deliberate bounded transition, with stale LinuxCNC START/CYCLE/JOG unable to cause automatic hazardous motion?
9. Is ordinary LinuxCNC/FPGA telemetry treated as diagnostic visibility only unless that path is itself part of the validated personnel-safety architecture?

## OpenPressBrake boundary

This study does **not** assert that OpenPressBrake needs a pneumatic safe-exhaust valve. If the machine has only nonhazardous ancillary air, this architecture may not apply. If pneumatics can create or retain hazardous motion/force, the hazard must first be traced physically before choosing a safety function or device.

## Compute

No simulation, synthesis, benchmarking, or executable verification was justified. No GitHub-hosted runner was used.

## Precise next Lane-B checkpoint

Find a complete professional machine or pneumatic safety implementation exposing:

`protective demand -> independent safety evaluator -> dual safe-exhaust final elements -> individual valve diagnostic -> downstream pressure witness -> deliberate one-valve failure or exhaust restriction -> fault/inhibit disposition -> physical actuator/load safe-state witness -> correction -> repressurization/soft-start -> safety rearm -> fresh ordinary start`

Prefer an OEM commissioning or validation procedure that includes an exhaust-path restriction, valve disagreement, or downstream-pressure test. Preserve machine-specific pressure/time/flow acceptance values only when the source actually states them; never transplant them to OpenPressBrake.