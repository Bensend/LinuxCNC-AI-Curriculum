# BD12 — Full-Board Kitchen-Sink Integration Review

## Purpose

BD12 is an adversarial BOARD INTEGRATION exercise. The question is not whether each reusable block looks reasonable by itself. The question is:

> Can the current catalog, board-specific connection molds, resource authorities, power/return rules, and output-authority contracts be assembled into one controller without an engineer supplying unwritten electrical knowledge?

The review flow is:

`machine functions -> selected block instances -> canonical connection owners -> FPGA/pin/bus resources -> power/current/return domains -> output authority -> hidden-glue search -> partial-power matrix -> capture hierarchy -> unresolved-gate ledger`

A missing edge, return, resource quantity, enable, connector fact, or proof is not filled from experience. It becomes a named integration gate.

## Learning outcomes

A student completing BD12 can:

1. perform a cross-block integration review without redesigning reusable primitives;
2. distinguish electrical net identity from PCB current-path permission;
3. detect stale monolithic integration data that conflicts with newer point authorities;
4. prove one semantic owner per instantiated machine-facing connector before capture;
5. keep FPGA/LinuxCNC ordinary control separate from independent personnel-safety authority;
6. aggregate known FPGA, bus, power, connector, and return demands while preserving unknowns;
7. build a partial-power/default-state matrix across block boundaries;
8. identify hidden glue that belongs in board integration rather than a reusable block;
9. define a capture hierarchy that consumes authority rather than inventing circuitry; and
10. produce an unresolved-gate ledger that permits schematic assembly without falsely declaring release readiness.

## Hard student-facing artifact audit for this run

Every OpenPressBrake artifact named below was opened and inspected on current `main` during this run. The readiness label is limited to the stated teaching use.

| Artifact | Readiness | Safe teaching use | Do not claim |
|---|---|---|---|
| `hardware/integration/REV1_BOARD_INTEGRATION_RECONCILIATION.yaml` | `VERIFIED_FOR_LESSON` | authority precedence; quarantine of stale core/comms, ADC, proportional, X-axis and return assumptions | that every full-board gate is closed |
| `hardware/integration/REV1_FIELD_PIN_SEMANTIC_OWNERSHIP.yaml` | `VERIFIED_FOR_LESSON` | one canonical connection owner per currently instantiated machine endpoint; explicit non-instantiated endpoints | rendered-net uniqueness or connector mechanics |
| `hardware/integration/REV1_POWER_DOMAIN_RENDERER_AUTHORITY.yaml` | `VERIFIED_FOR_LESSON` for semantic domain separation | four machine-facing 24-V classes and non-collapse rules | regulator/protection/copper/connector physical design |
| `hardware/integration/REV1_RETURN_DOMAIN_GROUNDING_AUTHORITY.yaml` | `VERIFIED_FOR_LESSON` for current return-domain semantics | Rev14 `CTRL_0V` identity, L07 prohibition, high-current/quiet-current routing constraints, explicit open joins | final PCB geometry, chassis/PE bonds, encoder return bond, PVR6 X2 physical existence |
| `hardware/integration/REV1_OUTPUT_INHIBIT_AUTHORITY.yaml` | `VERIFIED_FOR_LESSON` for ordinary-control permit architecture | four-prerequisite fail-low hardware permit and MAX22216 enable fanout | safety-rated behavior, finished Pilz field conditioning, rendered implementation proof |
| `hardware/integration/REV1_SCHEMATIC_RELEASE_GATE_MATRIX.md` | `VERIFIED_FOR_LESSON` | owner/evidence/closure model and explicit open gates | production release or qualification |

The current OpenPressBrake board is **not** production-proven. These files are integration authorities and bounded examples, not evidence that the complete rendered PCB has passed release.

## 1. Start with functions, not sheets

Build a function inventory before drawing hierarchy. For a press-brake example the inventory can include:

- controller/core and communications;
- machine 24-V inputs and outputs;
- differential encoders;
- valve-position measurement;
- proportional-valve command/current regulation;
- X-axis command/direction interface;
- field and core power;
- watchdog/configured/power-good output permission;
- service/debug interfaces; and
- retained independent safety-system interface status/permission.

For another machine the functions differ, but the method does not. A mill may substitute spindle/VFD and toolchanger interfaces; a plasma table may add torch-height and arc interfaces; a robot may add more encoder/servo interfaces. Do not start by cloning OpenPressBrake sheets.

### Freeze

`MACHINE FUNCTION INVENTORY PRECEDES SCHEMATIC HIERARCHY`

## 2. Resolve authority before resolving nets

Whole-board integration often fails because an older broad file looks more complete than a newer narrow authority. The inspected Rev1 reconciliation file explicitly quarantines stale RMII/KSZ8081 core assumptions, retired proportional ADC ownership, obsolete per-channel proportional control assumptions, unsupported direct ±10-V Commander-SK assumptions, and stale return-domain assumptions.

For every board-level decision, record:

| Decision | Current owner | Superseded source present? | Action |
|---|---|---|---|
| core/comms | current core-comms authority | yes | reject stale fields |
| ADC consumers | current ADC allocation authority | yes | do not recreate retired consumers |
| proportional command/current feedback | MAX22216/SPI authorities | yes | reject old PWM/ADC path |
| X-axis command profile | current X-axis authority | yes | keep installed parameterization open |
| return identity | current Rev14/Rev1 return authority | yes | consume `CTRL_0V`; preserve routing constraints |

### Freeze

`MOST COMPLETE-LOOKING FILE != HIGHEST-PRECEDENCE AUTHORITY`

## 3. Canonical connection ownership

Before cross-block wiring, enumerate every physical machine-facing connector and require exactly one connection-definition owner. The current Rev1 owner index provides this pattern for DNC I/O, three encoders, X drive, power feeds, proportional coils, valve-position sensors, and the retained enable boundary.

It also demonstrates fail-closed absence: `J_PVR_VALVE_GND` is not instantiated because PVR6 X2 physical harness existence is not proven. Pressure endpoints remain non-instantiated for the same evidence reason.

The student must produce a table with:

`physical endpoint | connection owner | semantic class | reusable consumer(s) | machine evidence state | capture disposition`

A physical endpoint with zero owners is an integration defect. More than one owner is competing authority. An endpoint explicitly withheld by evidence is not a defect if the release gate is recorded.

### Freeze

`CONNECTOR EXISTS IN LEGACY DRAWING != CONNECTOR MAY BE INSTANTIATED`

## 4. Resource aggregation must expose unknowns

Create one board resource ledger with separate columns for:

- FPGA package pins by I/O standard/bank;
- logical GPIO count;
- SPI buses, chip selects and interrupt/diagnostic lines;
- clocks/PLLs;
- LUT/FF/BRAM or equivalent logic resources;
- communications PHY/service resources;
- rail current by domain;
- connector contacts/current classes; and
- shared ADC/DAC channels.

Each quantity must carry an evidence class: calculated from a block contract, board configuration, machine configuration, synthesis/place-route evidence, `VERIFY_AT_MACHINE`, or `TBD_ENGINEERING`.

Do not convert a missing LUT/BRAM/timing number into an estimate merely to make the spreadsheet total. Logical pin allocation is not proof of routed FPGA fit. A board may proceed to semantic capture while synthesis/resource closure remains an explicit later gate.

### Freeze

`UNKNOWN RESOURCE COST IS A LEDGER ENTRY, NOT ZERO`

## 5. Power and return kitchen-sink review

The current Rev1 power authority deliberately keeps four machine-facing classes separate:

- `CORE_24V`;
- `PVR_SENSOR_24V`;
- `PROP_FIELD_24V`; and
- `SWITCHED_IO_24V`.

The newer return authority adds an important refinement: ordinary non-isolated controller/converter returns are one electrical `CTRL_0V` net mapped to machine L06. That does **not** authorize proportional or switched load current through quiet converter/reference copper.

Build two graphs, not one:

1. **electrical identity graph** — which nodes are electrically the same net; and
2. **current-path graph** — where normal, startup, fault and switched currents are permitted to flow physically.

The review must preserve these current constraints:

- L07 may not be bridged to `CTRL_0V`/L06 on the board;
- proportional current gets a deliberate high-current path to its supported return entry;
- low-current sensor excitation/loop current stays out of the quiet ADC reference region;
- encoder field return remains open until its provider/receiver integration supports a bond;
- X-axis field return is not promoted into generic board return without machine evidence; and
- chassis/PE is not generic signal return.

### Freeze

`SAME ELECTRICAL NET UPSTREAM != PERMISSION TO SHARE SENSITIVE PCB CURRENT PATH`

This corrects a common overreaction: avoiding noisy current paths does not automatically mean inventing split grounds, ferrites, zero-ohm links, or star points.

## 6. Output authority across blocks

Trace every energy-commanding output from host intent to physical actuator and identify every independent prerequisite.

For the current proportional path, the inspected ordinary-control permit is:

`HARDWARE_OUTPUT_ENABLE = PILZ_VALVE_ENABLE_LOGIC AND WATCHDOG_OK AND FPGA_CONFIGURED AND CORE_POWER_GOOD`

The board-level aggregation is fail-low, has explicit pull-downs, and fans out to both populated MAX22216 `ENABLE` pins. It has no software bypass and no personnel-safety credit.

The kitchen-sink review must ask:

- Who generates each prerequisite?
- What happens if that source is absent, tri-stated or unpowered?
- Is the field signal conditioned before logic-domain use?
- Can service/debug/LinuxCNC software bypass the physical permit?
- What happens after permit reassertion—can a stale command return automatically?
- Is implementation proof available, or only the semantic contract?

Current OpenPressBrake still has open Pilz field-to-logic conditioning and rendered-schematic proof. Those are release gates, not details to infer.

### Freeze

`ORDINARY HARDWARE INHIBIT != INDEPENDENT PERSONNEL-SAFETY AUTHORITY`

## 7. Hidden-glue search

Search explicitly for integration knowledge that exists only in an engineer's head. Categories include:

- implicit voltage-level translation;
- unnamed pull-up/pull-down/default networks;
- undocumented power-good or reset dependencies;
- hidden return joins;
- connector shield/chassis assumptions;
- FPGA signal aliases without an owner;
- bus chip-select allocation not represented in the resource plan;
- shared reference/clamp resources with no board owner;
- service/debug paths that bypass normal output authority; and
- machine facts copied from labels but not verified.

For every discovery choose exactly one disposition:

`BLOCK DEFECT | BOARD-INTEGRATION DEFECT | CONNECTION-MOLD DEFECT | MACHINE VERIFY_AT_MACHINE | DEPRECATED/SUPERSEDED`

Do not fix a board-specific mapping by contaminating a reusable primitive with machine names.

## 8. Partial-power matrix

A complete board creates states no single-block review sees. At minimum challenge:

| State | Required question |
|---|---|
| core off / field power on | can field interfaces back-power logic or assert commands? |
| core on / proportional field off | do diagnostics or command pins enter unsafe/undefined states? |
| 3.3 V logic absent / permit source present | does output permission remain low? |
| FPGA unconfigured / rails valid | are all energy outputs inhibited? |
| switched I/O domain off / core on | can I/O paths inject into L07-side circuitry? |
| encoder 5 V present / core receiver rail absent | is receiver/input back-power behavior defined? |
| service/debug connected during machine power transitions | can service paths source unintended rails or bypass authority? |

Answers require block partial-power data plus board-level joins. If either is missing, record a gate.

## 9. Capture hierarchy

A useful hierarchy follows ownership, not merely page aesthetics:

1. core/FPGA/comms;
2. core power and board distribution;
3. reusable input/output block instances;
4. proportional-driver instances and shared SPI/permit resources;
5. analog/shared-converter resources;
6. board-specific connection blocks;
7. explicit board-owned shared resources/joins; and
8. service/test interfaces.

The renderer/capture process may select structure from authority. It may not choose electrical design details. Missing primitive exact connectivity blocks that primitive's capture; it does not authorize the board renderer to synthesize a plausible circuit.

## 10. Unresolved-gate ledger

A kitchen-sink review succeeds when it makes uncertainty explicit. The current Rev1 release matrix demonstrates this: schematic assembly may proceed, while exact block connectivity, ERC, rendered field-pin uniqueness, implementation proof for output gating, field-power coordination, physical return paths, X-axis installed parameterization, connector mechanics and other gates remain open or partial.

Use this minimum ledger:

| Gate | Owner | Evidence required | State | Blocks capture? | Blocks schematic release? | Blocks PCB release? |
|---|---|---|---|---|---|---|
| exact primitive connectivity | reusable block | production connectivity | OPEN/PASS | per primitive | yes | yes |
| field-pin uniqueness | board integration | rendered-net comparison | OPEN/PASS | no | yes | yes |
| ERC | full-board capture | ERC report + triage | NOT RUN/PASS | no | yes | yes |
| FPGA fit/timing | FPGA integration | synthesis/P&R/timing evidence | OPEN/PASS | no | policy-dependent | yes |
| connector mechanics/ampacity | connection/physical design | selected parts + derating | OPEN/PASS | semantic capture may proceed | yes where electrically required | yes |
| machine-only facts | machine configuration | physical trace/measurement | VERIFY_AT_MACHINE/PASS | only affected endpoint | yes if topology depends on it | yes |
| output permit implementation | board integration | rendered connectivity + startup/power-loss proof | OPEN/PASS | semantic capture may proceed | yes | yes |
| current-return geometry | PCB integration | layout/current-path review | OPEN/PASS | no | not necessarily | yes |

### Freeze

`SCHEMATIC ASSEMBLY MAY PROCEED != SCHEMATIC RELEASED != PCB RELEASED != PRODUCTION PROVEN`

## 11. Adversarial lab

Create a kitchen-sink board review for a machine that contains at least:

- one differential encoder;
- two ordinary 24-V inputs;
- two ordinary 24-V outputs;
- one serial smart actuator/driver;
- one analog measurement;
- one independent retained safety-system status/permission interface;
- one service interface; and
- at least three power/return classes.

Deliver:

1. machine-function inventory;
2. reusable-block instance table;
3. canonical connection-owner table;
4. FPGA/bus/resource ledger with unknowns preserved;
5. electrical-identity graph;
6. current-path graph;
7. output-authority chain;
8. partial-power matrix;
9. hidden-glue defect list with ownership classification;
10. capture hierarchy; and
11. unresolved-gate ledger.

Then perform three adversarial changes:

- move an actuator from a simple output to a serial smart driver;
- discover that two nominally common 0-V functions require different physical current paths even though they remain one electrical net upstream; and
- discover that a legacy connector shown in drawings is not physically present.

The student must update only the owning layers. Reusable blocks must remain reusable unless their electrical contract genuinely changed.

## 12. Catalog stress-test result

The current OpenPressBrake catalog/integration approach passes an important architectural test: it can express canonical connector ownership, stale-authority quarantine, semantic power-domain separation, current-return constraints, and a fail-low ordinary-control output permit without melding reusable primitives into the board definition.

The kitchen-sink review also exposes remaining catalog/integration pressure points:

1. whole-board FPGA resource aggregation is still distributed; a single board-owned machine-readable ledger should eventually aggregate package pins, bank/I/O standards, bus resources, clocks, LUT/FF/BRAM/PLL evidence and synthesis status without pretending unknown quantities are zero;
2. electrical-net identity and PCB current-path permission need to remain separate first-class concepts throughout renderer and PCB handoff—the Rev14 `CTRL_0V` correction demonstrates why;
3. partial-power/back-power behavior is not yet uniformly machine-readable across every reusable block; and
4. release-gate dependency edges should eventually be machine-readable so a changed block/connection can invalidate the correct board-level evidence automatically.

These are catalog stress-test findings, not permission to patch active OpenPressBrake integration files from this lesson. Current return-domain and board-integration work is active, so BD12 consumes it read-only.

## 13. Readiness classification

For this lesson:

- the six audited integration artifacts above are `VERIFIED_FOR_LESSON` only for their bounded claims;
- the complete OpenPressBrake board remains `INCOMPLETE_NOT_STUDENT_MATERIAL` if presented as a finished/production-qualified controller;
- any stale field explicitly quarantined by the reconciliation authority is `DEPRECATED_OR_SUPERSEDED`; and
- unresolved physical connector, machine harness, chassis/PE, return-geometry and implementation-proof items remain `ENGINEERING_REVIEW_NEEDED` or `VERIFY_AT_MACHINE` as their owning authority specifies.

## 14. Compute decision

No simulation, synthesis/place-and-route, timing run or executable regression is required to teach this authority/ownership review. Do not run unchanged verification merely to make the lesson look more complete. When a later named gate genuinely requires executable evidence, it must run only on `[self-hosted, openpressbrake]`; hosted Actions minutes are not an allowed fallback.

## 15. Durable rules

- `MACHINE FUNCTION INVENTORY PRECEDES SCHEMATIC HIERARCHY`.
- `MOST COMPLETE-LOOKING FILE != HIGHEST-PRECEDENCE AUTHORITY`.
- `CONNECTOR EXISTS IN LEGACY DRAWING != CONNECTOR MAY BE INSTANTIATED`.
- `UNKNOWN RESOURCE COST IS A LEDGER ENTRY, NOT ZERO`.
- `SAME ELECTRICAL NET UPSTREAM != PERMISSION TO SHARE SENSITIVE PCB CURRENT PATH`.
- `ORDINARY HARDWARE INHIBIT != INDEPENDENT PERSONNEL-SAFETY AUTHORITY`.
- `MISSING CROSS-BLOCK KNOWLEDGE -> NAMED DEFECT OR RELEASE GATE`.
- `SCHEMATIC ASSEMBLY MAY PROCEED != SCHEMATIC RELEASED != PCB RELEASED != PRODUCTION PROVEN`.
