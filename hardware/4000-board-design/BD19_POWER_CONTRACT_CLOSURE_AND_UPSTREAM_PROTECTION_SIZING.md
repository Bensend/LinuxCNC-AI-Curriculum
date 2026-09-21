# BD19 — Power-Contract Closure and Upstream Protection Sizing Without Double Counting

**Lane:** independent LinuxCNC/OpenPressBrake board-design curriculum  
**Track:** BLOCK ENGINEERING -> BOARD INTEGRATION  
**Design-flow position:** reusable load contracts -> operating-mode aggregation -> derived-rail referral -> source/protection sizing -> physical distribution verification

## Purpose

A board power tree cannot be sized honestly by adding regulator ratings, component absolute maxima, field-load currents, and connector ratings until the number looks conservative. That creates both false margin and double counting.

BD19 teaches a strict ownership chain:

`block-owned load contract -> board instance count -> operating-mode simultaneity -> derived-rail referral -> source aggregate -> protection settings -> conductor/connector/copper/thermal checks -> fault coordination -> release evidence`

Core rule:

**CAPACITY IS NOT LOAD, AND THE SAME LOAD MUST NOT BE COUNTED ON BOTH SIDES OF A CONVERTER.**

## Learning outcomes

The student can:

1. distinguish operating demand from converter capacity, absolute maximum, fault current and field-load current;
2. require each reusable power-consuming block to publish its own steady/startup contract;
3. aggregate physical instances exactly once;
4. separate steady-state current from startup/inrush and fault-clearing transients;
5. apply board operating-mode and simultaneity assumptions explicitly;
6. refer downstream rail power upstream through a converter without counting both as independent loads;
7. keep separately sourced field domains out of an unrelated logic-source budget;
8. size eFuse/current-limit and dV/dt only after downstream evidence closes;
9. verify connector, conductor, PCB copper, voltage-drop and thermal constraints independently from source capacity;
10. preserve fault coordination between per-channel, branch and upstream protection;
11. record unresolved values as open gates rather than substituting convenient proxy numbers;
12. identify when a power-contract defect belongs to the reusable block rather than board integration.

## Student-facing source audit

The following CURRENT artifacts were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- OpenPressBrake `hardware/blocks/README.md` — reusable-block ownership, current/time/duty contract, shared-resource and board-assembly rules.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — truthfulness, baseline-vs-qualification, evidence and maintenance rules.
- OpenPressBrake `hardware/integration/REV1_CORE_LOAD_OWNERSHIP_HANDOFF.yaml` — current anti-double-counting ownership handoff for CORE low-voltage consumers.
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/design/REV47_CORE_POWER_CONTRACT_OWNERSHIP.md` — explicit reusable-core ownership of `5V_CORE_IN` hot/startup demand and board ownership of aggregate source/protection sizing.
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/manifest.yaml` — current core population/architecture and still-open post-core resource/power qualification context.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml` — positive example of a newly published reusable per-port 3V3 supply-demand contract.
- OpenPressBrake `hardware/blocks/machine_power/manifest.yaml` — current source domains, field-domain exclusions, provisional 5-V capacity and still-open TPS26633 logic-branch limit/startup gates.
- Curriculum `hardware/4000-board-design/BD18_WHOLE_BOARD_PARTIAL_POWER_AND_BACKPOWER_INTEGRATION_AUDIT.md` — reopened so BD19 preserves rather than collapses source-domain and lifecycle ownership.

These files do not prove the complete OpenPressBrake board production-ready.

## 1. Start with load ownership, not the upstream fuse

For every rail consumer, ask who owns the number.

A reusable block owns intrinsic electrical demand created by its implementation. Board integration owns instance count, operating modes, simultaneity, shared-resource composition and upstream referral. The upstream power block owns conversion/protection only after the downstream contract exists.

A valid load record should identify at least:

| Field | Meaning |
|---|---|
| consumer ID | stable block/instance identity |
| source rail | rail actually consumed |
| steady/hot current | evidence-backed operating bound |
| startup envelope | current vs time, energy, or effective capacitance as justified |
| duty/mode | condition under which demand occurs |
| physical count basis | device, primitive instance, grouped IC, etc. |
| provenance | datasheet/calculation/measurement/configured-image evidence |
| exclusions | currents already owned elsewhere |
| regression triggers | changes that reopen the contract |

Do not reconstruct a mature block from component maxima at board level.

## 2. Positive worked example: RS-485 port

Current OpenPressBrake `modbus_rtu_rs485` publishes a clean reusable handoff for the selected non-isolated THVD1450 port:

- source rail: 3V3;
- maximum steady supply demand: 0.003 A per populated physical transceiver;
- local decoupling: 100 nF per populated port;
- startup: no invented current pulse; board integration counts the known capacitance unless stronger manufacturer evidence or a named question justifies more;
- forbidden load proxies: output-short current, bus-fault rating, termination power and data-rate rating;
- optional 120-ohm A-B termination is not a 3V3 supply load in this baseline because no external failsafe-bias network is used.

This is a strong reusable contract because another board can consume it without knowing the internal RS-485 design history.

Freeze:

**TRANSCEIVER SHORT-CIRCUIT CAPABILITY != TRANSCEIVER SUPPLY DEMAND.**

## 3. Negative/open worked example: core power

The current FPGA-core ownership document correctly assigns responsibility but intentionally does not invent the final number. The reusable core must eventually publish:

- `5V_CORE_IN` hot/steady operating current;
- a bounded `5V_CORE_IN` startup/inrush envelope;
- internal rail budgets with enough provenance to avoid duplicate accounting;
- recalculation triggers tied to gateware/resource class, PHY/USB population, rail voltage, clocks and material support-circuit changes.

Board integration must consume that core contract once. It must not separately add FPGA, PHY, FTDI, flash and oscillator currents after the core contract already includes them.

Until the numerical core contract closes, upstream TPS26633 ILIM/dVdT cannot be frozen honestly.

Freeze:

**OWNERSHIP ASSIGNED != NUMERICAL CONTRACT CLOSED.**

## 4. Capacity is not operating demand

Examples of invalid substitutions:

- a 2-A buck rating used as a 2-A board load;
- FPGA absolute maximum current used as configured-image demand;
- output-driver short-circuit current used as logic-rail demand;
- connector ampacity used as expected current;
- field coil current inserted into a separately powered logic branch;
- fuse rating treated as continuous operating demand.

Capacity answers **can this element carry/provide it?** Load answers **what does the system actually demand under a defined condition?** They are different columns.

## 5. Aggregate steady state by operating mode

Do not blindly sum every theoretical maximum if those states cannot coexist, and do not assume diversity merely because simultaneous operation is inconvenient.

Create named board modes, for example:

- boot/configuration;
- idle/ready;
- communications/service active;
- maximum ordinary-control activity;
- commissioning/test mode;
- shutdown/brownout recovery.

For each mode, state which consumers can be active and why. If simultaneity is not constrained by a real contract, use full overlap for the relevant populated consumers.

For OpenPressBrake proportional channels, current machine-power authority uses the command envelope: five populated channels at 0.8 A each gives 4.0 A; six would give 4.8 A if PROP6 is populated. Those are field-domain operating envelopes, not TPS26633 CORE logic-branch loads and not protection trip settings.

## 6. Derived rails: refer, do not duplicate

Suppose a block consumes a downstream rail made by a converter. The upstream source sees converter input power/current, not an independent copy of every downstream ampere.

For a bounded steady-state calculation:

`Pout = sum(Vrail * Iload)`

`Pin >= Pout / eta`

`Iin = Pin / Vin`

Use an efficiency supported for the actual operating region. If efficiency is unresolved, keep the upstream referred value open or use a justified conservative bound and label it.

Do not do this:

`upstream total = converter input current + all downstream load currents`

when the first term already supplies the second.

Freeze:

**DOWNSTREAM LOAD REFERRED UPSTREAM != SECOND INDEPENDENT LOAD.**

## 7. Startup is a separate problem

Steady-state current does not size startup by itself. Record startup in a representation appropriate to the topology:

- current/time envelope;
- effective input capacitance where legitimate;
- bounded startup energy;
- regulator soft-start/inrush behavior;
- staged enable sequence actually enforced by hardware.

The FPGA-core authority explicitly warns not to reduce its startup to a naive sum of downstream capacitances divided by time because three downstream TPS62825 converters intervene. The upstream source sees converter input behavior.

Board integration may aggregate independently starting loads only after their timing relationship is known. If all can start together and nothing physically prevents it, assume overlap.

## 8. eFuse ILIM and dV/dt come after the load contract

For an upstream eFuse, distinguish:

1. normal steady operating current;
2. allowed startup current/energy;
3. current-limit setting tolerance;
4. load capacitance and desired ramp;
5. source impedance/capability;
6. fault-clearing behavior and SOA/thermal limits;
7. downstream branch protection.

A sensible ILIM must clear normal/startup demand with margin while still providing useful fault protection. A sensible dV/dt must control startup without creating an unsupported assumption about downstream converter behavior.

Current OpenPressBrake machine-power authority correctly leaves `logic_branch_current_limit_target_a` and `startup_inrush_a` TBD pending actual CORE aggregation. Preserve that gate.

## 9. Source capacity is only one gate

After aggregate demand is known, independently verify:

- source continuous capacity and derating;
- connector contact current and simultaneous-contact derating;
- harness conductor ampacity and voltage drop;
- PCB copper width/thickness and via transitions;
- temperature rise and enclosure ambient;
- regulator/eFuse MOSFET loss and thermal path;
- return-path capacity;
- branch protection;
- startup voltage sag;
- acceptable load-end voltage.

A 10-A source does not prove a 10-A connector pin, trace, return path, or branch protector is acceptable.

Freeze:

**SOURCE CAPACITY != DISTRIBUTION-PATH QUALIFICATION.**

## 10. Fault coordination must not be derived from normal load alone

Protection layers have different jobs. For a channelized field-power system, distinguish:

- device electronic protection;
- per-channel fuse/protection;
- shared field-branch fuse/breaker;
- upstream cabinet/source protection.

Select them from the weakest verified path, fault behavior, clearing energy/time-current evidence and desired selectivity—not by multiplying normal current by an arbitrary factor.

Current machine-power authority therefore keeps proportional upstream and per-channel protection open pending weakest-path and MAX22216 fault/startup evidence. That is the correct fail-closed behavior.

## 11. Anti-double-count audit

Before accepting a power budget, challenge every line item:

1. Is this an operating load or merely a rating?
2. Does another block already include it?
3. Is it a physical device count or a logical channel count?
4. Is it field-side energy that belongs to another source domain?
5. Is it a derived rail already referred upstream through a converter?
6. Is termination/passive dissipation actually drawn from this rail?
7. Is startup being mixed into steady state?
8. Is fault current being mixed into normal demand?
9. Is a shared converter/reference counted once or once per dependent channel?
10. Does the number have provenance and a regression trigger?

A line that cannot answer these questions is `ENGINEERING_REVIEW_NEEDED`.

## 12. Catalog stress-test result

The current OpenPressBrake architecture has the right ownership model but incomplete numerical closure.

Positive result: the RS-485 block now demonstrates the desired pattern by publishing an evidence-backed 3V3 steady load and known local capacitance without inventing startup current.

Open defects/gates:

- FPGA core owns but has not yet closed its final `5V_CORE_IN` hot/startup numerical contract;
- the integration handoff still identifies additional reusable owners whose supply-demand contracts must close before full CORE aggregation;
- machine-power cannot freeze TPS26633 ILIM/dVdT until downstream contracts are complete;
- physical connector/harness/copper/thermal and fault-coordination gates remain independent of arithmetic source capacity.

The curriculum must not hide those gaps by inserting regulator ratings or component maxima.

## 13. Adversarial lab

For a controller from any machine class:

1. inventory every power-consuming reusable block and shared resource;
2. assign each to its actual source rail/domain;
3. reject capacity, absolute-max and fault-current proxies;
4. build steady and startup contracts separately;
5. define at least three operating modes and simultaneity assumptions;
6. identify shared/grouped physical devices so logical channels are not double counted;
7. refer derived-rail demand upstream exactly once;
8. calculate source demand only where all required inputs are evidence-backed;
9. leave unresolved aggregates explicitly open;
10. propose eFuse/fuse settings only after normal/startup and weakest-path evidence exists;
11. verify connector/conductor/copper/thermal limits separately;
12. identify regression triggers for every frozen number.

A passing lab can conclude **protection setting remains TBD**. It cannot manufacture a setting from a converter rating.

## 14. Safety boundary

This lesson concerns ordinary controller power integrity, deterministic behavior and fault containment. It does not grant personnel-safety authority to LinuxCNC, FPGA logic, ordinary eFuses, watchdogs, field drivers or board power distribution. Independent safety architecture and validation remain separate.

## 15. Compute policy

No new executable compute is justified for this lesson. The current blocking questions are ownership, missing numerical contracts and physical distribution/fault-coordination evidence. When a configured-image power estimate, synthesis-derived activity/resource input, startup model or other executable verification is genuinely needed, it must run only on `[self-hosted, openpressbrake]`. No GitHub-hosted fallback is allowed.

## Durable freezes

- `CAPACITY != LOAD`.
- `ABSOLUTE MAXIMUM != OPERATING DEMAND`.
- `FAULT CURRENT != NORMAL SUPPLY CURRENT`.
- `FIELD LOAD != LOGIC-RAIL LOAD WHEN SOURCES ARE SEPARATE`.
- `PHYSICAL DEVICE COUNT != LOGICAL CHANNEL COUNT`.
- `DOWNSTREAM LOAD REFERRED UPSTREAM != SECOND INDEPENDENT LOAD`.
- `STEADY STATE != STARTUP/INRUSH != FAULT-CLEARING TRANSIENT`.
- `SOURCE CAPACITY != DISTRIBUTION-PATH QUALIFICATION`.
- `OWNERSHIP ASSIGNED != NUMERICAL CONTRACT CLOSED`.
- `PROTECTION SETTING TBD IS BETTER THAN A PROXY-DERIVED NUMBER`.

## Next lesson

BD20 should teach **board power-budget closure as a dependency graph and release gate**: block contract IDs -> instance counts -> operating modes -> converter edges -> source-domain totals -> unresolved dependency propagation -> protection settings -> physical-path qualification -> evidence invalidation on design change. The adversarial question is whether a machine-readable board configuration can identify exactly which missing block contract prevents a particular upstream protection or release claim, rather than presenting one deceptively complete total.