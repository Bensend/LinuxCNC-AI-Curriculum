# Guard-lock escape-release complete function-test acceptance trace

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Why this branch

Current primary work has materially advanced scanner/stand-behind physical acceptance and separately retains hydraulic/final-element work. The preceding Lane-B study established escape-release recommissioning from Pilz/SICK. This trace adds a different manufacturer and closes a more complete guard-lock functional acceptance sequence rather than repeating generic guard-lock definitions.

## Evidence labels

- **DOC-CONFIRMED** — directly supported by cited manufacturer documentation.
- **SOURCE-CONFIRMED** — directly supported by inspectable implementation/source.
- **TEST-CONFIRMED** — established by a recorded physical/executable test.
- **COMMUNITY-REPORTED** — reported by a community source but not independently verified.
- **INFERENCE** — engineering conclusion derived from confirmed evidence.
- **UNKNOWN** — machine-specific fact not established here.

No claims in this trace are TEST-CONFIRMED.

## Manufacturer acceptance sequence

### EUCHNER TZ safety switch with guard locking

**DOC-CONFIRMED:** EUCHNER operating instructions require a function test after manual release and a correct-function check after installation and after every fault. The mechanical test closes the guard repeatedly and checks manual-release function. The electrical test then requires:

1. apply operating voltage;
2. close all guards and activate guard locking;
3. verify the machine does **not** start automatically;
4. verify the guard cannot be opened;
5. start the machine function;
6. verify guard locking cannot be released while the dangerous machine function is active;
7. stop the machine function and release guard locking;
8. verify the guard remains locked until injury risk from overtravel/motion has ended;
9. verify the machine function cannot start while guard locking is released;
10. repeat the sequence for each guard.

Source: EUCHNER, *Operating Instructions — Safety Switch TZ*, section covering manual release, function testing, and inspection/service: https://assets2.euchner.de/Downloads/Betriebsanleitung/de/MAN_Betriebsanleitung-Sicherheitsschalter-TZ_Multilang_11_04-23_2088062.pdf

This is materially stronger than treating a closed/locked diagnostic bit as acceptance. It exercises automatic-restart prevention, physical opening prevention, unlock inhibition during hazardous function, overtravel/hazard-end timing, and start inhibition while unlocked.

### EUCHNER transponder-coded guard locking with escape release

**DOC-CONFIRMED:** EUCHNER's transponder-coded guard-lock instructions state that operating the escape release unlocks active guard locking and, for the applicable monitored configuration, switches the safety outputs off. Recovery requires pulling the escape-release knob back, closing the guard or removing solenoid voltage as specified, and checking correct device function.

Source: EUCHNER, *Operating Instructions — Transponder-Coded Safety Switches with Guard Locking*, escape-release section: https://assets2.euchner.de/Downloads/Betriebsanleitung/en/MAN_Operating-Instructions-Transponder-Coded-S%E2%80%A6_EN_MAN20001531.pdf

### Independent corroboration retained from prior Lane-B work

**DOC-CONFIRMED:** Pilz PSEN ml escape-release documentation requires pulling back the escape-release button, acknowledging the stop signal in the controller, and then carrying out an escape-release function test by qualified personnel before recommissioning.

Source: Pilz, *PSEN ml sa / DHM Operating Manual*, recommissioning section: https://www.pilz.com/download/open/PSEN_ml_sa_DHM_Op_Man__1005457-EN-05.pdf

## Architecture freezes

Preserve these distinctions:

- **GUARD CLOSED != GUARD LOCKED != DANGEROUS FUNCTION ENDED.**
- **GUARD-LOCK OUTPUT/STATUS HEALTHY != PHYSICAL GUARD OPENING PREVENTED.**
- **ESCAPE RELEASE RESTORED != DEVICE FUNCTION TEST PASSED.**
- **DEVICE FUNCTION TEST PASSED != PERSONNEL-CLEAR DETERMINATION COMPLETE.**
- **SAFETY OUTPUTS RESTORED != ORDINARY START AUTHORITY.**
- **GUARD RECLOSED/RELOCKED != AUTOMATIC RESTART PERMITTED.**

**INFERENCE:** A professional commissioning/recommissioning test should challenge the physical sequence, not merely inspect LinuxCNC/HAL/FPGA or safety-controller status bits. EUCHNER's test explicitly expects no automatic start after guard closure/locking and no start while guard locking is released.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC and an FPGA may display guard state, inhibit normal commands, log faults, and participate in ordinary machine sequencing. They must not be treated as proof that personnel-safety guard-lock behavior has been validated. A HAL `guard_locked=true` or equivalent ordinary-control bit is not evidence that:

- the guard physically resisted opening when required;
- unlock was inhibited while the dangerous function persisted;
- residual/overtravel hazard had ended before unlocking;
- escape release caused the required safety response;
- recommissioning/function testing after release or fault passed; or
- a fresh ordinary start is required after safety recovery.

Those remain properties of the validated safety architecture and physical machine acceptance.

## Question-driven commissioning worksheet

For each guarded access point, record evidence for:

| Challenge | Required observation | Evidence state |
|---|---|---|
| Close/lock guard with operating voltage present | Machine does not automatically start | DOC-CONFIRMED generic manufacturer requirement; machine result UNKNOWN |
| Attempt physical opening while lock should protect hazard | Guard cannot be opened | DOC-CONFIRMED generic requirement; machine result UNKNOWN |
| Run dangerous machine function, then request unlock | Unlock remains inhibited while dangerous function persists | DOC-CONFIRMED generic requirement; machine result UNKNOWN |
| Stop dangerous function | Guard remains locked until relevant injury risk has ended | DOC-CONFIRMED generic requirement; machine-specific timing/performance UNKNOWN |
| Release guard locking | Dangerous machine function cannot start while unlocked | DOC-CONFIRMED generic requirement; machine result UNKNOWN |
| Operate inside escape release | Guard unlocks and applicable safety outputs drop | DOC-CONFIRMED device behavior; machine result UNKNOWN |
| Restore escape release | Restoration alone is not acceptance; perform required function test | DOC-CONFIRMED |
| Reclose/relock after escape release or fault | Repeat physical/electrical function checks | DOC-CONFIRMED |
| Hold/preassert ordinary START/CYCLE/JOG through safety recovery | No hazardous restart without required fresh ordinary authority | INFERENCE; exact manufacturer combined test still UNKNOWN |
| Repeat for every guard | Each guard independently passes | DOC-CONFIRMED generic requirement; machine result UNKNOWN |

## What this does not establish

The following OpenPressBrake facts remain **UNKNOWN** and must not be invented: whether guard locking is required; guard geometry; locking principle; escape-release hardware; hazardous-motion/run-down time; unlock timing; stop category; PL/SIL/category/DC/CCF; hydraulic state; electrical/hydraulic final-element topology; reset location; retained-person controls; acceptance thresholds; and whether a particular guard physically withstands the required forces.

No simulation or executable verification was justified by this documentation question, so no runner compute was used.

## Information-gain result

The generic escape-release recovery branch is now substantially stronger: it has independent Pilz and EUCHNER recommissioning evidence plus a complete EUCHNER physical/electrical guard-lock test sequence. Repeating generic guard-lock catalog searches is now low value.

## Precise next Lane-B work

Prioritize the unresolved cross-cutting stale-command boundary: seek a manufacturer/OEM validation or safety-controller example that deliberately holds or preasserts an ordinary START/CYCLE/motion request across a safety demand and reset/requalification, and proves that restoration of the safety function cannot itself resume hazardous motion without a separate fresh start action. If authoritative evidence remains unavailable, rotate to another independent physical safety-function witness rather than manufacturing a synthetic test.