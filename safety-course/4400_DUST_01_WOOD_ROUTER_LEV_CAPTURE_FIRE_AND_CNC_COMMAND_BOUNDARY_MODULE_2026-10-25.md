# 4400-DUST-01 — A running dust collector is not proof of safe wood cutting
**2026-10-25 | 4000 safety course | NON-GRADUATED / documentary and pinned-source only**

## Prerequisites and outcome
Use 2520 hazard/SRS, 2580 energy isolation, 2590 guarding, 25F0 plasma process-energy transfer, 3400 router vacuum/dust authority, 4400-RST-01 reset. A fresh engineer should distinguish wood-dust occupational exposure, collector fire/deflagration, rotating-cutter guarding and machine restart as **different hazards with different physical witnesses and authority**. See [original OSHA/NFPA/CSB + LinuxCNC source audit](../research/4400_OSHA_NFPA660_CSB_WOOD_DUST_LEV_FIRE_VS_CNC_COOLANT_PIN_SOURCE_AUDIT_2026-10-25.md) and [12 adversarial paper cases/blank evidence](4400_DUST_01_TECHNICIAN_SCENARIOS_AND_BLANK_WITNESS_2026-10-25.md).

## Safety architecture: four independent propositions
1. **Normal CNC:** LinuxCNC M7/M8, custom M-code, spindle enable or shop PLC requests extraction or dust-foot motion. `iocontrol.0.coolant-flood` is an ordinary *requested* output, not a sensor or personnel-safety controller. A central collector may be controlled at shop level.
2. **Dust exposure control:** physically adequate capture at the tool/hood, intact ducting, suitable filter/airflow, correct maintenance and exposure assessment. A running fan, switch closure or nominal pressure alone may be insufficient; use qualified capture evidence for selected material/process.
3. **Fire/explosion prevention/mitigation:** dust combustibility and accumulation, ignition controls, collector placement, vent/suppression/isolation and return-air strategy require a selected facility hazard analysis and applicable NFPA 660/locally adopted code review. Running the fan can coexist with a dangerous collector.
4. **Machinery personnel safety:** guard access, spindle/axis stopping, emergency stopping, energy isolation, tool coast and deliberate fresh start remain independently justified. Ordinary LinuxCNC HAL/FPGA commands do not acquire safety authority because they participate in an extraction sequence.

## Practical interface contract (DESIGN INFERENCE, not a certified wiring diagram)
Inputs: `LEV_REQUEST` (ordinary), `LEV_AVAILABILITY_WITNESS` (qualified source/health/capture), `COLLECTOR_FIRE_FAULT` (separate engineered system), `DUST_FOOT_POSITION` (machine local), `GUARD_SAFE` and `MOTION_SAFE` (independent safety authority as required), `FRESH_START` (deliberate new operator action).

Outputs: `CUTTING_PERMITTED` is an *engineering proposition*, not a single LinuxCNC bit. For loss of capture, prevent new cutting and reach the selected risk-assessed stopped condition. For fire/spark/deflagration, follow the collector's engineered protection/isolation strategy; **never prescribe fan ON or OFF universally**. For E-stop, protect against cutter/axis hazard and coordinate other process hazards without treating the ordinary flood bit as the physical final element. For maintenance, use isolation/LOTO, not an M9 command.

## Six-step selected design review (no energy)
1. Inventory exact router, tool materials, dust species/particle behavior, hood, duct, fan, filters, cyclone, collector placement, return-air, other connected machines, ignition sources and installed fire/explosion protection. Record unknowns, not guesses.
2. Map distinct hazards: inhalation, flash fire, deflagration propagation, rotating tool, flying workpiece, combustible accumulations, collector servicing and power-return/restart.
3. Draw normal control, monitoring/diagnostic, qualified safety-related functions and physical energy/fire mitigation as **separate layers**. Label the shop-level collector ownership versus CNC blast gate/dust foot.
4. Specify how loss of actual capture is distinguished from mere loss of command; avoid a single fan contactor auxiliary signal as a surrogate for capture. Define acceptable operating and maintenance evidence with qualified industrial-hygiene/process-safety input.
5. Review E-stop, extraction fault, collector fire, power loss, partial network failure, bypass, shared duct and restart independently. An E-stop should not silently disable a needed exposure-control system; a fire response must not blindly keep a dangerous collector running.
6. Validate as-built and physical capture/fire-protection functions through qualified site procedures. Record actual results and change controls; no personnel-exposed operation where basic safeguards or required controls are absent.

## Human factors
Use an accessible dust-foot adjustment and cleaning port; put fault messages at the machine where operators can act; make replacement filters and duct inspection easy; avoid nuisance alarms that invite bridging airflow switches. Provide a **clear pause/recovery workflow** that never requires bypassing a guard to clear a blocked hood. Do not clean accumulated combustible dust with compressed-air blowdown. An ordinary fan indicator should say *requested/running*, never *dust safe*. Where a collector serves several machines, stopping one CNC should not inadvertently disrupt protection for the others.

## Cross-machine transfer
Wood routers: wood-dust inhalation plus combustible collector hazards. Metal grinding/combustible-metal dust: different material-specific analysis; do **not** assume wood-collector compatibility. Plasma: fumes/hot work/arc and gas hazards; existing 25F0 transfer, not a wood-dust explosion model. Press brakes: hydraulic/gravity/rear access remain priority; this module does **not** assert OpenPressBrake has wood extraction.

## Graduation and verification
**SOURCE-CONFIRMED** pinned LinuxCNC flood-request path; **DOC-CONFIRMED** OSHA and NFPA publisher scope, CSB incident; **INFERENCE** control contract; **UNKNOWN** selected collector and hazard analysis, capture measurements, installed protection, PL/SIL and independent evaluation. **TEST-CONFIRMED none**; no new compute question. Twelve paper cases are NOT independent scores. G0/G1 HOLD for any unverified selected machine; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 OPEN. If the minimum machine/collector safety threshold is unproved, no people-exposed operation.

## DUST-02/03 deeper source and human-factors extension
[LinuxCNC pinned 2.9/development comparison](../research/4400_LINUXCNC_2_9_VS_DEVELOPMENT_COOLANT_REQUEST_AND_ESTOP_VERSION_BOUNDARY_2026-10-25.md): development directly turns `coolant-flood` OFF in Task ESTOP/OFF/ON/RESET. 2.9 Task ESTOP/OFF/RESET instead routes `emcIoAbort` -> `EMC_TOOL_ABORT` to the separate iocontrol implementation, which clears flood; ON lacks the corresponding direct Task OFF call. Version-specific command path, not a guaranteed external fan state.

[Donaldson CPC Rev6/HSE original evidence](../research/4400_DONALDSON_POWERCORE_FILTER_DELTA_P_VENT_AND_SPRINKLER_OEM_AUDIT_2026-10-25.md) adds four physical checks: collector filter Delta-P is not hood capture proof; vent discharge must not endanger occupied areas; fire sprinklers can add structural water load; collector compressed-air pulse valves require separate isolation. HSE calls for competent LEV commissioning and hood-specific performance benchmarks; UK examination intervals are not transplanted into US law. Use [14-gate no-energy review](4400_DUST_01_NO_ENERGY_COLLECTOR_CAPTURE_AND_FIRE_DESK_VERIFICATION_PLAN_2026-10-25.md) before any selected protected test. [Technician card](4400_DUST_01_TECHNICIAN_SCENARIOS_AND_BLANK_WITNESS_2026-10-25.md) now contains 16 PAPER scenarios, no score.

## DUST-04 normal request timing is not safety response timing
[Pinned M8/M9 interpreter queue/remap trace](../research/4400_LINUXCNC_M8_M9_INTERP_QUEUE_REMAP_VS_PHYSICAL_LEV_READINESS_SOURCE_TRACE_2026-10-25.md): M8 may be remapped, and normal flood ON/OFF may enqueue until canonical queue processing; interpreter `settings->flood`, Task status and HAL output do not prove a ready hood. A delay in G-code is not an independently validated LEV safety permissive. The [technician card](4400_DUST_01_TECHNICIAN_SCENARIOS_AND_BLANK_WITNESS_2026-10-25.md) now has **18 PAPER cases**.
