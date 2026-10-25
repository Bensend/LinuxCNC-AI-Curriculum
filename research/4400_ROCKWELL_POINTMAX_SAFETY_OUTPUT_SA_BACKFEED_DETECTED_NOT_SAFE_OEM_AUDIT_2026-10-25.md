# 4400-OUT-01 — Safety-output positive-potential backfeed: detection does not guarantee load de-energization
**Original manufacturer documentary audit; 2026-10-25. No machine test or OpenPressBrake approval.**

## Precise question
If a safety-rated output reports a wiring fault, is its connected load necessarily de-energized? **Pre-source prediction:** a conductor shorted to the positive supply can energize a load independently of the output transistor; a diagnostic flag may detect but cannot physically interrupt that external bypass path. **INFERENCE before source review**; now supported in a specific manufacturer's documented application.

## Directly inspected manufacturer evidence
**Rockwell Automation, PointMax 5034-OB8S/5034-OB8SXT, "Wiring Diagrams for Safety Mode and Safety Pulse Mode"**, official online manual, accessed 2026-10-25: https://www.rockwellautomation.com/en-fi/docs/technical/i-o/current/5034-pointmax/_online/pointmax-i-o-modules-details-ditamap/digital---safety-i-o-modules/5034-ob8s-ob8sxt-details/safety-application-suitability-levels-output/5034-ob8s-ob8sxt-wiring-diagrams.html

The OEM's IMPORTANT notice says that when an external wire cross-circuit connects **SA+** to **SO_n**, **the load can no longer shut down**, even though the module detects the fault and sets a fault bit showing the channel cannot reach Safe State until the fault is cleared. This is an unusually explicit **DOC-CONFIRMED** counterexample to equating a safety-module fault LED or requested OFF with physical safe state.

The same page explicitly limits the listed safety level to the **module itself**; connected devices require their own status monitoring for the application safety level. It describes mode-/architecture-specific application conditions including different periodic safety-demand intervals in certain single-channel configurations and exact dual-channel pairings (0/1, 2/3, 4/5, 6/7). **Do not transfer these intervals or category labels to another module or the selected machine.** A safety-rated module does not automatically qualify a machine's complete safety function.

Related input-side companion: [4400-PULSE-01 same-test-source cross-short audit](4400_ROCKWELL_PILZ_TEST_PULSE_SHARED_SOURCE_CROSS_SHORT_AND_SAFETY_INPUT_VARIANT_AUDIT_2026-10-25.md), which shows a **different** failure: a cross-short may escape detection when two SI use the same test-output point.

## Physical failure argument
```text
safety controller SO_n ----> load/contactor/valve coil
          |                     ^
          | requested OFF       |
          +---- diagnostics     +---- unintended external SA+ short (bypass)
```
Even if the controller's intended output goes OFF, a positive-supply bridge can maintain the load energized. **DOC-CONFIRMED for the named Rockwell output mode/fault.** The consequence for a real press brake depends on the actual load, redundancy, hydraulic valve topology, monitoring and physical load holding; **UNKNOWN** here.

A useful four-way classification for any protective stop: (1) controller *commands* OFF, (2) electronics *detect* fault, (3) external energy path *actually opens*, (4) hazardous mechanical/hydraulic state *actually becomes safe*. The first two are not proof of the latter two.

## Design review implications (INFERENCE)
- Identify positive-supply and field-cable fault paths, load wiring, terminal insulation, short-circuit exclusions, conductor routing and protected cabinet boundaries.
- Determine whether independent monitored final elements can remove hazardous energy despite a single output backfeed; avoid guessing redundancy or safety performance from a module label.
- Review exact safety output model, pulse/safety mode, permitted channel pairing, monitoring/EDM and demand-test conditions.
- Preserve an independent **physical** press-brake Y1/Y2 stopping and gravity-holding case, not just valve coil-off or LinuxCNC HAL state.
- Do not use an ordinary FPGA watchdog, HMI red E-stop icon, or safety fault bit as the sole personnel-exposure interlock.
- Design easy terminal access, clear supply/output identification, protected routing and post-repair validation so temporary bypasses are unattractive.

## Evidence ledger
| Proposition | Class | Boundary |
|---|---|---|
| SA+ -> SO_n short can hold load energized while fault bit sets | **DOC-CONFIRMED** | Rockwell 5034-OB8S/XT official output wiring page |
| Module suitability rating automatically equals full machine PL/SIL | **DOC-CONFIRMED contrary** | OEM says external devices need their own status monitoring |
| Exact selected machine has this module, this fault, or a particular valve response | **UNKNOWN** | No as-built machine source |
| Normal LinuxCNC output OFF proves independent hydraulic safe state | **NOT ESTABLISHED** | No source/physical validation |
| Numerical stopping time, fault detection time, pressure, safety integrity | **UNKNOWN** | No measurement or design-specific calculation |
| Bench test or energized fault injection completed | **TEST-CONFIRMED none** | No Actions or physical execution |

**Information-gain gate:** only exact installed safety-output part/firmware/mode, circuit drawings, final-element identity and independently qualified G0/G1 physical hazard evidence can resolve the selected-machine case. No synthetic lab is warranted for an already explicit manufacturer statement. Public repository must not receive private machine drawings.
