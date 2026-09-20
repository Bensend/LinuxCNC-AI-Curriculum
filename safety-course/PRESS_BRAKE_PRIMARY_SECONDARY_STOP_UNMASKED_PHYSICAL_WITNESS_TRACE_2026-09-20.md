# Press-brake primary/secondary stop — unmasked physical witness trace

Date: 2026-09-20

## Question

Can a real hydraulic press-brake implementation deliberately keep the normal stopping path active/ineffective while proving the independent secondary stopping path from an actual physical beam-stop witness, rather than merely checking valve command/contact agreement?

## Evidence

### FoldSafe press-brake implementation

**DOC-CONFIRMED.** The PB-series hydraulic press-brake manual includes the FoldSafe press-brake safety system. The manual describes FoldSafe as dual redundant, using a primary stop backed by a secondary stop with integrated speed and stop-distance monitoring. It states that on malfunction of one valve, FoldSafe executes the secondary stop. It further says the preferred secondary stop is a secondary valve arranged so that a pipe burst will not allow the beam to fall.

Source: PB SERIES HYDRAULIC PRESS BRAKE instructions manual, FoldSafe section, pp. 48–51, hosted at t4i.co.nz / product S902.

### Deliberately unmasked secondary stop test

**DOC-CONFIRMED.** At initial power-up, FoldSafe performs a secondary stop test. The documented sequence requires the pump running and a down command. Crucially, the test does **not** stop through the normal Down valve: the normal Down valve is kept open while FoldSafe closes either the secondary safety valve or stops the pump. FoldSafe then measures the physical distance the beam takes to stop. The manual explains that this result matters because the secondary stop is needed if the primary stop fails.

This is strong evidence for an engineering pattern the curriculum had previously kept partly UNKNOWN: a redundant stopping path can be challenged while deliberately preventing the normal path from masking the result, and the witness can be actual beam stopping distance rather than only electrical state.

### Failure disposition

**DOC-CONFIRMED.** A failed secondary stopping-distance test is not silently accepted as normal operation. The manual permits reset/repetition; if it fails again, it directs investigation by an authorised service technician. A passed secondary test with unobstructed safety curtains leads to the normal working display.

The manual's fault table also states that the footswitch must be held until the beam is completely stopped to ensure the secondary stop works, reinforcing that the relevant witness is physical stop completion, not merely an output transition.

### Periodic integrity boundary

**DOC-CONFIRMED.** The same machine manual says presence-sensing safeguarding must receive regular safety-integrity tests with records retained. It explicitly lists stop-time measurements, safety-distance calculations/inspections, operator checks, and periodic maintenance checks. This establishes that the physical stopping witness is not only a one-time commissioning concern.

**UNKNOWN.** The accessible manual does not say that replacement of the secondary safety valve itself is the trigger for rerunning the FoldSafe secondary-stop test, nor does it provide a named post-replacement static holding-valve retention test. Do not infer either trigger.

## Evidence boundary

This source closes a **dynamic unmasked stop-path proof** gap. It does **not** establish all of the harder post-service holding-valve chain.

Freeze:

**SECONDARY STOP COMMAND ISSUED != NORMAL DOWN PATH MASKED OUT != SECONDARY FINAL ELEMENT ACTED != BEAM PHYSICALLY STOPPED != STOPPING DISTANCE ACCEPTABLE != NORMAL OPERATION AUTHORIZED.**

For this documented test, the normal Down valve is intentionally kept open, so the test specifically prevents that ordinary path from supplying a false pass for the secondary path.

Also freeze:

**UNMASKED DYNAMIC SECONDARY-STOP PASS != STATIC LOAD-RETENTION PASS != SERVICED HOLDING-VALVE INDIVIDUALLY LOAD-PROVED.**

The FoldSafe test demonstrates stopping capability under a commanded moving-beam condition. It does not, from the accessible text, specify a static drift/load-holding acceptance test for a named serviced retaining valve.

## Practical curriculum consequence

A reusable safety-validation worksheet should require the engineer to identify, for each redundant final element or stopping path:

1. which companion path could mask its failure;
2. how the documented test prevents that masking;
3. what physical quantity is witnessed (beam stop distance/time, retained load, pressure, position, etc.);
4. the documented pass/fail criterion;
5. failure disposition; and
6. what additional proof remains necessary before production authority.

This prevents a common validation error: proving that the machine stopped while failing to prove **which independent path actually stopped it**.

## Human-factors consequence

A built-in automatic test is valuable because it makes the safer verification path easier than an improvised maintenance test. But repeated reset must not become a way to normalize a persistent failure. The documented second failure requires service investigation.

## OpenPressBrake boundary

**UNKNOWN:** OpenPressBrake's final hydraulic architecture, primary/secondary stop elements, companion-path masking method, acceptable stopping distance/time, test point, static load-retention requirement, valve-specific service procedure, reset/rearm sequence, and production-initiation sequence. None are inferred from FoldSafe.

Do not transplant FoldSafe's numerical settings or hydraulic topology into OpenPressBrake without matching machine-specific engineering evidence.

## Next evidence target

Continue looking for a press-brake OEM/manifold service procedure that connects a **named serviced holding/safety valve** to an **individual post-reassembly retaining/load test**, including companion-path isolation/masking control, physical ram/load witness, pass/fail disposition, and then any required dynamic stopping re-proof/rearm. The FoldSafe evidence should be used as the dynamic-stop analogue, not as a substitute for static retention proof.
