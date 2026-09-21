# BD04 — Default State, Output Authority, Watchdog, and Fault Containment

## Purpose

This block-engineering lesson asks a harder question than “can the output turn on?”: **what physical state results when command authority, logic power, field power, communications, or a component disappears or faults?**

Design flow:

`FUNCTION -> AUTHORITY -> DEFAULT STATE -> POWER-DOMAIN LOSS -> WATCHDOG/INHIBIT -> FAULT PATH -> EVIDENCE -> RELEASE GATE`

A reusable output block is not complete merely because its active-state topology works. Its contract must make inactive, startup, reset, tri-state, power-loss, diagnostic, and abnormal-condition behavior explicit enough that board integration does not depend on unwritten assumptions.

## Learning outcomes

Students will be able to:

1. distinguish a circuit's local deterministic OFF mechanism from a board/system watchdog;
2. trace output authority from FPGA command through translation/isolation to the field switching element;
3. define startup, reset, tri-state and de-energized behavior at each power domain;
4. distinguish ordinary-control fail-off behavior from personnel-safety authority;
5. trace fault current and inductive-energy paths instead of writing generic “protected” claims;
6. identify which abnormal conditions are device-supported, calculated, simulated, bench-qualified, or still unknown;
7. write a verification matrix that separates structural checks from physical qualification;
8. reject device headline ratings as board/application ratings without connector, copper, thermal, load and simultaneous-use evidence.

## Student-facing evidence audit

The following current OpenPressBrake files were opened and inspected during construction of this lesson:

- `hardware/blocks/digital_output_24v/engineering.yaml` — **VERIFIED_FOR_LESSON** for reusable ownership, semantic interfaces, deterministic command-loss invariant, machine-input unknowns, calculation structure and safety boundary.
- `hardware/blocks/digital_output_24v/manifest.yaml` — **VERIFIED_FOR_LESSON** for declared interfaces, default/watchdog state, FPGA-resource declaration, fault requirements and explicit unresolved board/application ratings.
- `hardware/blocks/digital_output_24v/design/REV1_ISOLATED_INTERFACE_CONTRACT.md` — **VERIFIED_FOR_LESSON** for the first-machine board-integration delta, separated logic/field domains, field-side OFF authority and loss-of-domain reasoning. It is **not** a released production implementation.
- `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for present maturity and release limits. The reusable non-isolated variant is simulation-ready; the first-machine isolated path is explicitly not yet schematic-ready.

These labels apply only to the claims used by BD04. Re-open current files before future lessons rely on them.

## 1. Draw the authority chain

For every ordinary output, draw an authority chain from software intent to field energy. A useful abstract chain is:

`LinuxCNC/HAL intent -> FPGA output state -> translation/isolation -> local command node -> field switch -> load -> return`

Then add every independent condition required for energy to reach the load:

- logic rail present;
- field rail present;
- translation/isolation rail present;
- watchdog/inhibit permissive if implemented at board/system level;
- command actively asserted;
- output device not in a protective shutdown state.

Do not collapse these into one Boolean named `ENABLE`. The schematic and machine-readable contract should make each authority boundary visible.

## 2. Local OFF authority is not the watchdog

The verified OpenPressBrake primitive requires loss, reset or tri-state of `OUTPUT_COMMAND` to resolve OFF. Its reusable circuit uses a physical pull-down at the command node. That is a local electrical default-state mechanism.

A watchdog is different. A watchdog answers whether the controller remains authorized to continue commanding outputs after software/FPGA/communications failure. It may force the FPGA command inactive or remove an enable elsewhere in the board architecture.

Therefore:

`COMMAND PULL-DOWN != WATCHDOG`

and

`WATCHDOG REQUESTS OFF != PHYSICAL OUTPUT PROVED OFF`.

A robust integration must prove both the watchdog authority path and the downstream electrical response it depends on.

## 3. Build a state table before schematic release

For each output block create a state table at minimum like this:

| Condition | Command source | Logic domain | Field/isolator domain | Required output state | Evidence needed |
|---|---|---|---|---|---|
| normal inactive | driven low | present | present | OFF | structural + functional |
| FPGA reset | reset/tri-state | present | present | OFF | circuit default + test |
| logic power lost | undefined/unpowered | absent | present | OFF | domain-loss analysis + test |
| field-side translation power lost | may be active upstream | present | absent | OFF | topology + test |
| field power lost | command may exist | present | absent | de-energized | topology + physical test |
| watchdog expired | system forces inactive | present | present | OFF | integration logic + physical output test |
| output short | active | present | present | bounded/protected behavior, diagnostics as declared | datasheet + qualification |
| inductive turn-off | transitions inactive | present | present | energy handled inside declared envelope | calculation/test |

Do not fill unknown cells with “safe.” State the expected physical state and the evidence required to prove it.

## 4. Worked architecture: separated field domain

The first-machine OpenPressBrake integration is useful because it exposes why board-specific deltas must remain outside the reusable primitive.

The current isolated integration contract keeps `LOGIC_3V3/LOGIC_GND` separate from the switched L7/L07 field domain. Command and diagnostics cross isolation; the IPS1025H field stage remains field-side. The field-side command node has deterministic pull-down authority, and the isolation supply belongs to the same switched field-domain family as the output stage.

This supports a useful design property: removing field permission does not leave an independently powered field-side command source able to assert an otherwise de-energized stage.

But the same current file explicitly leaves production BOM completion, exact KiCad mappings, board connectivity enforcement, ERC/net comparison, and PCB thermal qualification open. Students may use it to study **architecture and authority**, not to claim a released OpenPressBrake output circuit.

## 5. Protection claims require a path and an envelope

Never write only `short-circuit protected`, `inductive protected`, or `surge protected`.

For each abnormal condition record:

1. initiating fault;
2. current/energy source;
3. path through the circuit;
4. limiting/clamping/protective element;
5. return path;
6. device limit being relied upon;
7. declared application envelope;
8. repetitive versus one-time basis;
9. thermal consequence;
10. diagnostic behavior;
11. restart behavior;
12. verification evidence.

The OpenPressBrake output contract intentionally leaves steady load current, inrush, load inductance, simultaneous channel count and several board thermal/current-path values unresolved. That is correct. The IPS1025H device capability is not automatically the connector, copper, branch, thermal, or application rating.

## 6. Fault containment crosses ownership boundaries

A reusable block may own the local protected-switch behavior, but board integration owns shared branch protection, simultaneous-current assumptions, copper/vias, connector ratings and return-domain topology. Machine configuration owns the actual load current, inrush, inductance and duty.

That gives three separate questions:

- **Block:** can this topology survive/detect the declared local fault envelope?
- **Board:** can the shared source, branch protection, copper, connector and return path contain that fault without invalidating neighboring functions?
- **Machine:** is the installed load actually inside the declared envelope?

If any answer is unknown, the release gate remains open.

## 7. Diagnostics are evidence, not authority

Overload and overtemperature indications are ordinary status signals. They can support fault reporting, maintenance and control policy. They do not prove that the load is physically de-energized, and they do not become personnel-safety feedback merely because the FPGA monitors them.

Freeze:

`FAULT BIT != PHYSICAL SAFE STATE`

and

`ORDINARY OUTPUT FAIL-OFF != SAFETY-RATED OUTPUT FUNCTION`.

Independent safety equipment remains authoritative unless a separately safety-rated architecture and validation says otherwise.

## 8. Verification matrix

A reusable output block should carry a matrix such as:

| Requirement | Structural evidence | Calculation/simulation | Bench evidence | Machine evidence |
|---|---|---|---|---|
| reset/tri-state resolves OFF | pull-down/net contract | optional node analysis | command-source disconnect/reset test | integration witness |
| watchdog expiry resolves OFF | watchdog-to-command connectivity | logic test if needed | expire watchdog and measure output | machine response if relevant |
| output short contained | device/protection topology | current/thermal bounds | controlled short/restart test | installed branch coordination if needed |
| inductive turn-off contained | demag path | energy/repetition calculation | representative inductive load | installed load inductance/duty |
| simultaneous channels acceptable | board resource contract | aggregate current/thermal | multi-channel load test | actual duty/load inventory |
| power-domain loss resolves OFF | domain topology | back-power analysis | remove each rail independently | board commissioning witness |

Simulation is question-driven. A manufacturer-reference topology does not need gratuitous simulation merely to reproduce a known digital isolation function. Conversely, simulation cannot replace missing load, harness, thermal, or machine evidence.

## 9. Adversarial lab

Given an ordinary 24 V output design, the student must produce:

1. an authority-chain diagram;
2. a domain-loss/default-state table;
3. a watchdog-to-physical-output trace;
4. a fault-current/energy path for short circuit and inductive turn-off;
5. a typed list of machine inputs still required;
6. a board-level simultaneous-use/current-return ledger;
7. a verification matrix with evidence class and acceptance criterion;
8. a release statement naming every open gate.

Then challenge the design with these review questions:

- What happens if the FPGA pin floats during configuration?
- What happens if logic power disappears while field power remains?
- What happens if the field-side translation supply disappears while logic remains active?
- Can any clamp/protection current return through a domain not sized for it?
- Does a short on one channel disturb shared power for neighboring channels?
- Can an ordinary diagnostic falsely be interpreted as proof of de-energization?
- Does watchdog expiry actually reach a physical OFF mechanism, or only change a software bit?
- Which values came from the installed machine rather than the semiconductor datasheet?

A passing submission may contain `TBD` and `VERIFY_AT_MACHINE`. It may not substitute device headline ratings or vague “fails safe” prose for evidence.

## 10. Catalog stress-test result

The current output catalog passes the lesson's architectural test better than a simple schematic-only block would: ownership, semantic interfaces, deterministic command-loss behavior, FPGA resources, machine-input unknowns and safety boundary are explicit.

The lesson also exposes a useful integration distinction that must remain visible in future catalog work: the reusable primitive's local deterministic OFF mechanism is not itself the board watchdog. The manifest states that watchdog expiry must resolve OFF at system integration, so a later whole-board lesson must trace the actual watchdog/inhibit path end-to-end rather than assuming the block provides it internally.

No OpenPressBrake engineering file is changed by BD04 because the current catalog already records that boundary and the first-machine isolated implementation is actively incomplete. Inventing the missing production capture or machine load envelope would violate the evidence policy.

## Next lesson

BD05 should switch back to board integration: **power-domain and current-return tracing across multiple block instances**, including shared rails, fault-current returns, chassis/PE/shield boundaries, connector returns, startup/inrush aggregation and cross-block back-power paths. Candidate OpenPressBrake power/integration files must be opened in their current form before being assigned. If those files are actively changing, use them read-only or choose an independent verified example.