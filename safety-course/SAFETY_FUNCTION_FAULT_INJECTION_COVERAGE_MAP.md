# Safety-Function Fault-Injection Coverage Map

Status: SAFETY CURRICULUM WORKING CONTRACT — machine-agnostic; no PL/SIL/DC claim

Purpose: turn the broad fault catalog into the smallest meaningful adversarial set for each safety/control function. This map is about **claim coverage**, not percentage coverage. Test counts SHALL NOT be converted into diagnostic coverage, Category, PL, SIL, PFHd, stopping-distance, or machine-suitability claims.

## Evidence vocabulary

Use only the curriculum evidence classes: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`. An untested or unobservable failure mode remains `UNKNOWN`; it is not a pass.

## Coverage method

For every safety function define, before testing:

1. hazard and person/exposure boundary;
2. initiating protective device or demand;
3. independent safety-related evaluator/logic;
4. final physical interruption/removal element;
5. feedback/diagnostic witness and exactly what it proves;
6. reset eligibility;
7. separate production restart/rearm owner;
8. stored/reaccumulating energy that can survive the represented stop;
9. smallest adversarial set that challenges each claimed layer;
10. known unobservable or machine-specific failure modes.

A function is not adequately exercised merely because its nominal demand test passes. The minimal set must challenge input integrity, final-element integrity, feedback integrity, restoration/restart behavior, and any normal-control boundary the function claims to supervise.

## Coverage map

| Function | Minimum meaningful adversarial set | Claims exercised | Explicit non-claims / UNKNOWNs |
|---|---|---|---|
| E-stop / emergency interruption | FI-01 single input open; FI-05 cross-channel fault where test-pulse topology claims detection; FI-09 or FI-10 one final element welded; FI-11 both final elements fail closed; FI-12 broken feedback; FI-15 held reset; FI-16 held normal start through restoration; FI-28 power cycle with latent fault | demand reaches independent evaluator; documented input-fault behavior; redundant final interruption; EDM/restart inhibition; deliberate reset; no automatic normal restart | stopping distance/time; hydraulic safe state; spindle/ram standstill; residual energy; PL/SIL/DC; faults the exact evaluator cannot diagnose |
| Guard / interlock | FI-01 one channel open; FI-06 one contact stuck closed during guard actuation; FI-08 common-cause plausible state; FI-15 held reset; FI-16 held start; FI-25 mechanical guard defeat; FI-30 healthy indicator contradicting independent witness | required channel transitions; discrepancy handling; guard restoration does not equal restart; physical safeguard effectiveness is separate from switch state | reach distance, guard strength/geometry, exact interlock performance level, defeat resistance not established by electrical simulation |
| Final-element EDM / contactor feedback | FI-09 K1 welded; FI-10 K2 welded; FI-11 both welded; FI-12 feedback conductor open; FI-13 feedback bypass/short; FI-14 wrong auxiliary-contact semantics; FI-28 power cycle with latent weld | commanded OFF versus physical main-pole state; documented mirror/feedback relationship; reset inhibition when required feedback is wrong/missing | feedback contact does not prove all machine energy is absent; no claim for a contact not documented as suitable witness |
| Reset / restart / rearm | FI-15 held reset; FI-16 held start; FI-17 safety-device power loss/restore; FI-21 stale nonzero command after communications restore; FI-22 forged HMI `SAFETY_OK`; FI-28 latent fault through power cycle | reset is deliberate and eligibility-gated; reset is not production start; restored power/comms do not replay stale demand; normal software cannot manufacture independent safety permission | exact reset timing/edge semantics remain device-specific; no assumption that every machine requires the same reset architecture |
| Hazardous-energy isolation for servicing | FI-26 residual energy after outputs open; FI-27 credible reaccumulation; FI-25 defeated physical safeguard where task relies on it; FI-29 changed isolation configuration; plus deliberate alternate/backfeed-source challenge from the energy inventory | control-circuit stop is not LOTO; each energy source has physical isolation; stored energy is rendered safe; reaccumulation is controlled/verified; configuration identity matters | zero-energy state cannot be inferred from LinuxCNC, FPGA, relay LED, E-stop or contactor state alone; exact machine sources/magnitudes remain VERIFY_AT_MACHINE |
| Ordinary LinuxCNC / FPGA watchdog and communications containment | FI-19 FPGA watchdog expiry; FI-20 host communications loss; FI-21 stale command after reconnect; FI-22 forged software safety status; FI-24 frozen feedback where freshness is claimed | stale normal commands lose ordinary actuator authority; explicit rearm/fresh generation required; telemetry contradictions remain visible | watchdog is not personnel-safety authority; watchdog trip does not prove physical energy isolation or independent safety action |
| Feedback disagreement / freshness monitoring | FI-23 channel disagreement; FI-24 frozen last-good value; FI-30 indicator contradicts independent witness | raw observations remain distinct; disagreement/freshness is not averaged away; missing freshness remains UNKNOWN | diagnostic response does not itself stop the hazard unless an independently justified safety function consumes it |
| Maintenance temporary test/override | FI-16 held start; FI-21 stale command; FI-22 forged permission; FI-25 safeguard defeat; FI-28 reboot with latent override/fault; FI-29 configuration change | override scope is bounded; indication/authorization survives or fails closed appropriately; return to isolation/restoration proof precedes production | no generic software bypass is treated as an acceptable safety architecture; task-specific alternative protection remains design-specific |

## Why this is the minimum, not a complete test universe

The set is intentionally small enough to teach and repeat, but each selected fault attacks a different assumption. Removing a case requires stating which claim is no longer challenged. Adding ten variants of the same open-wire fault does not improve coverage of a welded final element, a false feedback witness, residual energy, or unexpected restart.

Use pairwise symmetry selectively. For example, FI-01 and FI-02 are both useful during initial wiring validation, but a curriculum evaluator may use one channel-open case when channel symmetry is already established by exact documentation and configuration identity. Never use symmetry to skip a fault where the two channels use different hardware, wiring, test pulses, routing, or logic.

## Cross-function adversarial scenarios

Single-function tests miss dangerous interactions. The Safety Sandbox should eventually include these compound cases:

### CF-01 — E-stop succeeds electrically, residual energy remains
- Open final electrical interruption devices successfully.
- Preserve a credible stored hydraulic/mechanical/electrical energy source.
- Expected lesson: E-stop/interruption may PASS its defined electrical claim while maintenance zero-energy remains FAIL/UNKNOWN.

### CF-02 — one contactor weld + false EDM witness
- Hold one main pole closed.
- Bypass/short the feedback witness so diagnostics look healthy.
- Expected lesson: redundancy may still interrupt via the other element, but proof-of-restoration is corrupted and production rearm cannot be justified from the false witness.

### CF-03 — communications loss + reconnect + held start
- Expire normal command freshness.
- Restore communications with a cached nonzero command/start request.
- Expected lesson: ordinary output authority requires fresh command generation and explicit rearm; safety restoration is not restart.

### CF-04 — guard switch electrically satisfied while guard is mechanically defeated
- Keep electrical guard input plausible.
- Mark physical safeguard ineffective.
- Expected lesson: a switch state is not proof of effective guarding; physical inspection/change control matters.

### CF-05 — power cycle while latent physical fault remains
- Introduce welded contact, defeated guard, or bypassed feedback.
- Power-cycle normal controller/HMI and, where appropriate, evaluator model.
- Expected lesson: reboot cannot promote missing/contradictory evidence to healthy.

### CF-06 — maintenance isolation verified once, then energy reaccumulates
- Establish initial energy-specific verification.
- Allow a modeled source to reaccumulate.
- Expected lesson: where reaccumulation is credible, continued verification/control is required; a stale `verified` bit is insufficient.

## Hazardous-energy source basis

For servicing/maintenance, the curriculum shall retain the OSHA hazardous-energy distinction: the energy-control program addresses unexpected energization/startup or release of stored energy; energy isolation is physical rather than a control-circuit stop; stored/residual energy must be rendered safe; and where stored energy can reaccumulate, verification must continue until servicing is complete or reaccumulation is no longer possible. OSHA also requires periodic inspection of the energy-control procedure at least annually and correction of deviations/inadequacies. These requirements support the **procedure/evidence discipline** here; they SHALL NOT be misrepresented as a universal annual proof-test interval for every safety component.

Source: OSHA 29 CFR 1910.147, especially (c)(6) periodic inspection and (d) application of control. Preserve exact applicability analysis outside this generic curriculum artifact.

## Evaluator scoring contract

A learner answer FAILS if it:

- claims `safe machine` from one green diagnostic bit;
- calls E-stop, LinuxCNC ESTOP, watchdog expiry, zero command, or open contactors proof of maintenance isolation;
- treats two channels as proof that all common-cause faults are detectable;
- treats an arbitrary auxiliary contact as equivalent to documented mirror/forced-guided feedback;
- converts number of passed injections into diagnostic-coverage percentage, PL, SIL, PFHd or certification;
- permits automatic production restart merely because a safety input, power, network, or watchdog becomes healthy again;
- silently changes `UNKNOWN` to PASS;
- invents press-brake valve safe states, stopping distance, pressure thresholds, accumulator behavior or hydraulic truth tables.

A strong answer identifies which physical claim each test challenges, what witness establishes it, what remains unknown, and what additional machine-specific evidence would be needed.

## Machine-family adaptation

Apply this map after defining the real hazard boundary. A mill may need spindle standstill/enclosure considerations; a lathe retains rotational kinetic energy; plasma adds torch/gas/fire/fume energy; a robot adds large reachable multi-axis motion; a press brake adds gravity/stored hydraulic energy and the tooling pinch/crush zone. The generic contactor/EDM fixture is a teaching component, never a declaration that the whole machine has reached a safe state.

## Practical human-factors rule

Fault coverage should make the safer path easier to use correctly. If a guard, reset process, maintenance isolation step, or diagnostic workflow is so inconvenient that operators predictably defeat it, treat the inconvenience as a design defect to solve. Bypass/defeat must be visible as a first-class fault, not normalized into routine production.

## Next independent branch

Build a **Safety Sandbox learner/evaluator contract** that consumes this coverage map and the machine-family hazard-boundary map: define exactly what the learner sees, what fault controls the evaluator may inject, what observations are hidden versus visible, acceptable evidence language, and automatic failure conditions for overclaiming. Keep it separate from the primary lane's simulator implementation files unless main explicitly promotes a shared interface.