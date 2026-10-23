# 4400 — Whole-body access, personnel keys and maintenance LOTO: technician challenge

**Open-book learner exercise, 2026-10-23.** Read [the source study](../research/4400_PERSONNEL_KEY_WHOLE_BODY_ACCESS_VS_LOTO_SOURCE_AUDIT_2026-10-23.md) first. Not a blind evaluator answer, real-machine test procedure or authority to energize a machine.

## The scenario

A small LinuxCNC-supervised automated cell has two gates. A technician removes a mechanical access key and enters. A second worker follows without taking an individual key. The gate is shut by someone outside. The HMI says `Guard closed`, `Reset permitted`, and `Motor disabled`. A hydraulic clamping cylinder and an elevated part are present. An operator wants to restart quickly after a jam. The key switch controls a safety relay, but the as-built drawings and energy-isolator details are unavailable.

## Work to submit

1. Identify **three separate** things the key sequence might prove, and **six** physical propositions it cannot prove without more evidence. Explain whether the HMI can be safety authority.
2. Draw a two-worker key-accounting timeline. Which single action by worker A could leave worker B unprotected if the design permits one shared personnel key? Specify a robust correction and its own residual limitation.
3. Separate `guard access`, `independent safe stop/hold`, `occupied rearm inhibit`, `emergency escape`, `maintenance isolation`, and `fresh ordinary start`. Allocate each to the correct safety controller, physical final element, ordinary control, and human role.
4. Compare a mechanical dual-key access lock, an electronic coded-key adapter and a key-operated PLC selector. For each, identify the **narrowest** proposition supported by its documented behavior; do not infer whole-machine PL/SIL from a component label.
5. A supervisor says, “Everyone is out because all keys are back.” Construct a counterexample involving duplicate keys, unaccounted entrants or another entrance; propose a physical/procedural witness for an occupancy check.
6. During maintenance, someone padlocks the control-circuit key switch but leaves the hydraulic accumulator charged. State why this is not automatically 1910.147 energy isolation; identify the required energy-zone map, isolators, stored-energy treatment, individual control and verification.
7. During a power failure, the guard unlocks before a lathe spindle stops; in a different installation the guard remains locked with a worker inside. Explain the **different** hazards and evidence needed for each, without inventing stopping times.
8. A press-brake foot pedal remains pressed through a reset. Identify the independent prevention-of-restart behavior and the fresh action that must be demonstrated before operation.
9. Give three human-factors changes that make correct key removal, return and guard reinstallation easier than bypass, without weakening protection. Record which proposed benefit requires actual worker observation.
10. Complete the evidence table; mark unknown machine facts `UNKNOWN` and physical trials `NOT RUN`, not `PASS`.

| ID | Needed evidence | Evidence reference / claim class | Status |
|---|---|---|---|
| `BND/HAZ` | Each entrant, task, gate, blind zone and hazardous energy | | |
| `SF/SRS` | Stop/hold, key inhibit, release, escape, fresh reset/start | | |
| `AUTH` | Normal LinuxCNC/FPGA vs independent safety vs isolator | | |
| `DEP/ARC` | Exact key variants, exchange, duplicates, shared power and failure paths | | |
| `PHY` | Independent stop/hold/access/escape/energy/restart witness | | |
| `HF` | Observed workflow friction and practical anti-defeat design | | |
| `VAL/PT/CHG` | Qualified plan, negative cases, changes/stale evidence | | |

**Release disposition:** with no selected-machine `IN-01..10` and no physical witnesses, the correct decision is `HOLD / NOT AUTHORIZED` for personnel-exposed hazardous operation and maintenance entry. This is a written engineering challenge only; do not test entrapment, defeat interlocks, or energize hazardous machinery to answer it.
