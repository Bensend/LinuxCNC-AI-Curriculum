# Safety Verification Instrument Trust-Chain Worksheet

Date: 2026-09-17
Status: SAFETY COURSE / 4000 / independent Lane B

## Purpose

Turn the existing rule `command != proof` into a practical rule for the proof device itself. A voltage tester, pressure gauge, valve-position switch, mechanical observation, auxiliary contact, or software diagnostic can only support the claim that its measurement path is capable of revealing the hazardous state being tested.

This worksheet does **not** define machine-specific safe voltage, pressure, force, stopping distance, discharge time, hydraulic truth table, PL/SIL, or proof-test interval. Those remain `UNKNOWN` until applicable machine/device evidence exists.

## Frozen rule

> A reading is not stronger than its complete trust chain: correct hazard -> correct test point -> suitable instrument/witness -> proven usable measurement path -> fresh observation -> interpretation bounded to what that observation can actually prove.

One green HMI indication, one dark lamp, one pressure gauge at the wrong side of a valve, one auxiliary contact, or one failed try-start must never silently become universal proof of zero hazardous energy.

## Evidence provenance

- **SOURCE-CONFIRMED:** OSHA 29 CFR 1910.147 defines electrical, mechanical, hydraulic, pneumatic, chemical, thermal and other energy as possible energy sources; control-circuit devices are not energy-isolating devices.
- **SOURCE-CONFIRMED:** 1910.147(d)(5) requires hazardous stored/residual energy to be relieved, disconnected, restrained or otherwise rendered safe and continued verification where hazardous reaccumulation is possible.
- **SOURCE-CONFIRMED:** 1910.147(d)(6) requires verification that isolation and deenergization were accomplished before covered servicing begins.
- **SOURCE-CONFIRMED:** OSHA lockout guidance states that verification may require a combination of methods and gives monitoring instruments as an example.
- **SOURCE-CONFIRMED:** OSHA's 2012 LED interpretation says relying solely on an LED indication does not satisfy the affirmative verification requirement of 1910.147(d)(6).
- **SOURCE-CONFIRMED:** OSHA 1910.333(b)(2)(iv) requires electrical deenergization verification before exposed circuits/equipment are treated as deenergized; a qualified person uses test equipment to test exposed circuit elements and also checks for induced/backfeed voltage. For circuits over 600 V nominal, that rule explicitly requires the test equipment to be checked for proper operation immediately before and after the test.
- **INFERENCE:** For OpenPressBrake teaching, every claimed physical witness should have an explicit trust-chain review even when the exact OSHA electrical instrument rule is not directly applicable to that other energy domain.
- **UNKNOWN:** The actual instruments, test points, ranges, accuracy, calibration requirements, pressure decay criteria, electrical categories, hydraulic architecture and mechanical restraint requirements for a particular machine until installed documentation and inspection establish them.

## Trust-chain columns

For every hazardous-energy verification claim, fill in:

| Field | Required question |
|---|---|
| Hazard / task | What physical harm or unexpected movement is being controlled for this task? |
| Energy domain | Electrical / hydraulic / pneumatic / gravity / spring / rotational / thermal / other? |
| Isolation boundary | Which physical device or boundary is supposed to prevent transmission/release? |
| Stored/reaccumulating energy | What can remain or return after isolation? |
| Test point / observation location | Where is the state actually observed, and is it on the hazardous side of the boundary? |
| Witness | Meter, gauge, test port, mechanical block inspection, auxiliary contact, try-start, direct observation, etc. |
| Suitability basis | Why is this witness suitable for the expected energy/type/range/environment? |
| Usability proof | What demonstrates the witness and its measurement path are functioning rather than silently failed? |
| Freshness | Is this a current observation, or a cached/stale/latched value? |
| Independence/common cause | Can the same failure make both the commanded isolation and the supposed proof look safe? |
| What it proves | State the narrow physical claim actually supported. |
| What it does **not** prove | Explicitly name adjacent hazardous states that remain unproven. |
| Continued verification | Can energy reaccumulate, migrate, backfeed, leak or be restored during the work? |
| Provenance | SOURCE-CONFIRMED / DOC-CONFIRMED / TEST-CONFIRMED / COMMUNITY-REPORTED / INFERENCE / UNKNOWN |
| Result | PASS / FAIL / UNKNOWN / NOT APPLICABLE |

## Failure-path challenges

### 1. Dark voltage indicator

The panel voltage-presence lamp is dark after the disconnect is opened.

Reject: `lamp dark -> circuit deenergized`.

Challenge the lamp supply, lamp/LED failure, wiring, location relative to all feeds, backfeed paths and whether an appropriate direct electrical test is required for the exposed work. A failed indicator can produce the same visual state as absent voltage.

### 2. Meter reads zero at the wrong point

A meter reads zero on the control-transformer secondary while the task exposes the main DC bus.

Result: the reading may be valid and still irrelevant. Correct instrument operation does not rescue a test point that does not witness the hazard.

### 3. Pressure gauge isolated from trapped pressure

A gauge reads zero upstream of a closed valve while a cylinder/accumulator branch can retain pressure downstream.

Result: `UNKNOWN` for the trapped branch. Do not invent the hydraulic topology or a safe pressure value. Identify the actual hazardous volume and machine-specific test/bleed/restraint evidence required.

### 4. Pressure sensor shares the failed supply

The same 24-V supply powers a valve output and the pressure transmitter. Loss of that supply closes/deenergizes the valve command but also drives the transmitter signal to a value interpreted as zero.

Result: common-cause concern. A plausible safe-looking signal may be produced by loss of the witness itself. Review diagnostics, signal-failure behavior, independent physical evidence and installed architecture.

### 5. Auxiliary contact says contactor open

EDM/auxiliary feedback reports the contactor released.

Bound the claim to what the specific feedback architecture can establish. It is not automatically proof of absence of voltage, absence of a secondary feed, discharged DC bus, hydraulic safe state, or mechanical restraint.

### 6. Try-start does nothing

Normal START produces no motion after lockout.

Useful evidence, but not universal proof. The ordinary control path may itself be faulty, disabled, stale, or unable to exercise another energy path. Combine verification methods where the hazard requires it and return normal controls to neutral/off after the challenge.

### 7. HMI pressure is zero

LinuxCNC displays `0 psi` from a field sensor.

Before using it as evidence, ask: freshness? scaling? sensor power? broken wire behavior? stale network image? test-point location? sensor isolation valve? range? common reference? The HMI is an observation surface, not independent personnel-safety authority.

### 8. Mechanical block is visible

A ram block is physically present.

That proves presence, not capacity or correct load path. Capacity, placement, support points, condition and whether hazardous load can bypass/eject the restraint remain machine-specific evidence obligations.

### 9. Zero once, hazardous later

Pressure/voltage is initially absent but can reaccumulate or backfeed during the task.

A correct initial measurement does not satisfy the later state. Define the continued-verification or physical prevention method appropriate to the machine and task.

### 10. Test device fails silently

A portable or installed witness gives the expected safe reading because its probe, lead, supply, reference, sensor, input module or communication path failed.

Require an explicit usability check appropriate to the witness. Do not generalize the >600-V OSHA before/after instrument-operation rule into a universal numeric procedure for every instrument; instead capture the engineering principle and follow the applicable manufacturer/workplace procedure.

## OpenPressBrake architecture application

Keep these layers distinct:

1. LinuxCNC/HAL requests ordinary stop or neutral command.
2. FPGA transport/watchdog removes ordinary output authority.
3. Independent safety system removes or controls personnel-safety authority as designed.
4. Final elements change state.
5. Feedback reports final-element state.
6. Independent physical witness tests the hazardous-energy state where required.
7. Mechanical restraint/blocking controls gravity or stored mechanical hazard where required.
8. Task-level verification decides whether personnel exposure is permitted.

A failure or stale value at layers 1-5 must not be hidden by a green summary at layer 8. Conversely, a valid physical measurement for one energy domain must not be promoted into proof for another.

## Commissioning / maintenance prompts

For each credited witness, ask:

- Can an open circuit, short, loss of power, loss of reference, frozen input or stale network image produce a safe-looking reading?
- Is the test point downstream/upstream of the actual isolating element in the way the hazard analysis assumes?
- Can a valve, check valve, accumulator, cross-port path, transformer, UPS, regenerated bus, secondary supply or external machine create energy on the hazardous side?
- Does the witness remain valid when the controller is rebooting, powered down, faulted or disconnected?
- Is the witness accessible enough that workers will actually use it instead of inferring safety from the HMI?
- Is there a practical way to demonstrate witness operation without creating a new hazard?
- If the witness is unavailable or ambiguous, does the procedure preserve `UNKNOWN` and keep personnel outside the exposure zone rather than guessing?

## Result discipline

Use only:

- `PASS — evidence supports the bounded claim`
- `FAIL — evidence contradicts the required claim`
- `UNKNOWN — evidence cannot establish the required claim`
- `NOT APPLICABLE — hazard/claim is outside this task`

Never convert `UNKNOWN` to `PASS` because production ran normally, a controller shows no fault, or no incident has occurred.

## Curriculum exercise

Build one row for each applicable energy domain on a press brake and then one transfer example on a mill, plasma table and robot/cell. For every row, deliberately inject on paper one witness failure that produces a falsely reassuring indication. The learner must state what independent observation or design feature would expose that failure.

No executable simulation is required unless a later machine-specific question can actually be answered by compute. Hardware measurements belong on the installed machine with appropriate procedures and qualified personnel.

## Exit criteria

The learner can:

- distinguish isolation command, final-element feedback and physical verification;
- trace a measurement from the hazard through the test point and complete witness path;
- identify stale, miswired, unpowered and common-reference false-safe readings;
- explain why one verification method may be insufficient;
- preserve `UNKNOWN` when a test point or instrument cannot establish the claim;
- keep LinuxCNC/HAL/FPGA diagnostic value without promoting ordinary control into personnel-safety authority;
- avoid inventing machine-specific acceptance thresholds or physical behavior.