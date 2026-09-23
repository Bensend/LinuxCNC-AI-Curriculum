# 2540 — Five-family safety-relay comparison and relay/contactor physics bridge

Date: 2026-09-23

## Purpose

This is a source-preparation artifact, not a component-selection approval. It compares current/currently documented commercial safety-relay families using manufacturer evidence and reverse-maps each documented feature to the fault or proposition it can actually support. `UNKNOWN` means the reviewed manufacturer evidence did not establish the field; it is not permission to infer it.

## Comparison

| Family / exact representative | Documented integrity data | Timing | Outputs / load | Reset / start | Input / cross-fault behavior | EDM / feedback | Reliability / mission assumptions | What the evidence actually proves |
|---|---|---|---|---|---|---|---|---|
| Pilz PNOZ X3 | Exact PL/SIL/PFH value: UNKNOWN in evidence reviewed here | Exact release/response time: UNKNOWN here | Three safety contacts are shown in the operating manual application diagrams; exact load rating not captured here | Automatic and monitored start are documented | Dual-channel operation with detection of shorts across contacts is explicitly distinguished in technical data | External contactor contacts are shown in the feedback loop | UNKNOWN here | The module can monitor covered two-channel input faults and use external feedback in its restart permission chain. This does not prove the external contactor interrupted hazardous energy or that the machine reached a physical safe state. |
| Allen-Bradley Guardmaster SI 440R-S12R2 | Up to Cat. 4, PL e; SIL claim limit 3; PFHd 3.98e-9; DCavg 99%; HFT 1 | Release delay 0 s; exact input-to-output response time UNKNOWN here | AC-15 1.5 A/250 VAC; DC-13 2 A/24 VDC; aggregate output current 6 A | Reset behavior is configurable by application; exact mode details not re-derived in this pass | One- and two-channel evaluation inputs | Application-dependent external-device monitoring; exact terminal behavior UNKNOWN in reviewed product page | MTTFd 262 y; mission time 20 y; high-demand mode; 365 d/y, 24 h/d listed | The published numbers characterize the relay under stated assumptions. They do not transfer to sensors, wiring, contactors, brakes, valves, mechanics, or the complete safety function. |
| Phoenix Contact PSRclassic PSR-SCP-24UC/ESAM4/8X1/1X2 (2963912) | Up to SIL 3; Cat. 4 / PL e | Typical response <140 ms monitored/manual start, <120 ms autostart; release <20 ms via sensor circuit, <50 ms via A1 | 8 enabling current paths; exact utilization ratings not captured here | Manual monitored start and autostart are documented; manual start pulse >=500 ms | 1- or 2-channel; force-guided internal contacts per IEC/EN 61810-3 | Exact external-feedback wiring: UNKNOWN in reviewed page | Mechanical service life approx. 10^7 cycles; mission assumptions for PL/PFH calculation UNKNOWN here | Start mode and timing are properties of the module. Force-guided internal contacts improve diagnosability of covered internal contact faults; they do not witness the external hazardous process. |
| Omron G9SE-201 | PL/SIL/PFH exact value: UNKNOWN in reviewed specification page | Operate <=100 ms normally; response ON-to-OFF <=15 ms | Contact safety outputs, 250 VAC 5 A / 30 VDC 5 A resistive | Feedback-reset input participates in output enabling; exact manual/auto mode detail UNKNOWN here | Exact cross-fault coverage UNKNOWN here | Feedback-reset input documented; exact external-device coverage depends on wiring | Mechanical/electrical life and environmental limits published; no PL/PFH mission assumptions captured here | The response time and contact rating bound the module's own behavior under specified conditions. They are not a machine stopping-time or contactor interruption proof. |
| ABB Sentry SSR10 | Up to PL e/Cat.4, SIL3/SILCL3 | Activation 50 ms; deactivation 20 ms; power-on delay 1.5 s | 3NO+1NC representative; 5 A AC-1 catalog value | Manual or automatic reset selectable; manufacturer requires reset position with entire danger zone visible and outside danger zone | 1/2-channel equivalent contacts and OSSD devices; T1/T2 test outputs documented | Feedback/reset architecture exists; exact external-device diagnostic claim must follow selected wiring | Manufacturer states replacement within 20 years; exact PFHd/B10d values UNKNOWN in reviewed sources | The relay's claimed capability applies only when selected/configured/installed under its instructions. Reset ergonomics and visibility are part of application safety; the relay cannot prove zone clearance itself. |

## Source provenance

- Pilz PNOZ X3 operating manual 20547-EN-10: https://www.pilz.com/download/open/PNOZ_X3_Operating_Manual_20547-EN-10.pdf
- Rockwell 440R-S12R2 current product page: https://www.rockwellautomation.com/en-us/products/details.440R-S12R2.html
- Phoenix Contact 2963912 current product page: https://www.phoenixcontact.com/en-us/products/safety-relays-psr-scp-24ucesam48x11x2-2963912
- Omron G9SE specifications: https://www.ia.omron.com/products/family/3419/specification.html
- ABB Sentry SSR10 manual / family documentation: https://library.e.abb.com/public/9ab5ac5f40dd4601acc8e2c8bec9e409/Sentry%20SSR10%20Product%20Manual%20%28EN%29%20revG%202TLC010063M0201.pdf

Evidence classification for the table: `DOC-CONFIRMED` where the manufacturer page/manual states the item; `UNKNOWN` otherwise. No `TEST-CONFIRMED` claim is made.

## Feature -> fault/proposition reverse map

| Feature | Covered fault/proposition | What it does **not** establish |
|---|---|---|
| Two-channel input evaluation | Can expose disagreement/loss of one covered input channel when the selected architecture actually monitors it | Mechanical independence of two actuators; correct guard geometry; absence of a shared cable/mounting/common-cause fault |
| Test pulses / cross-short detection | Can expose specified wiring shorts/cross-circuits within documented pulse/filter limits | Physical operation of the E-stop or guard; correctness of the protected-zone geometry |
| Force-guided internal contacts | Makes specified contradictory contact states mechanically constrained/diagnosable after covered welding/failure | That an external contactor, valve, brake or process reached the safe state |
| Manual/monitored reset | Can require a deliberate reset transition and reject some static/stuck reset conditions | Personnel clear; safe process state; permission to restart ordinary production motion |
| EDM / external feedback | Can witness the particular auxiliary/contact state wired into the feedback loop before re-enable | Main-contact current actually zero under every failure; spindle stopped; pressure exhausted; gravity load held; personnel clear |
| Published PL/SIL/PFH for relay | Bounds the relay/subsystem contribution under stated architecture/use assumptions | Complete safety-function PL/SIL/PFH; sensor/final-element integrity; machine-specific risk reduction |
| Response/release time | Bounds the relay's documented internal contribution to response under stated conditions | Machine stopping time or safety distance |
| Contact current/utilization rating | Establishes allowed switching duty only for stated voltage/load/utilization conditions | Suitability for a different inductive/DC load; electrical life under an unspecified duty cycle |

## Physics bridge — why the relay table is not enough

### 1. Welding and force guidance

TE Connectivity's current IEC/EN 61810-3 force-guided-relay material explains the key diagnostic mechanism: NO and NC contacts are mechanically linked so antivalent contacts cannot both assume the normal closed state after covered welding/failure; the complementary contact can therefore be monitored to inhibit restart. TE also explicitly warns that a force-guided relay is not intrinsically immune to relay failure or end-of-life. This is the correct teaching boundary: **force guidance creates a diagnosable relationship; it does not create an infallible switch.**

Manufacturer source: https://www.te.com/fr/products/relays-and-contactors/electromechanical-relays/intersection/relays-in-safety-related-control-systems.html

### 2. AC/DC and inductive interruption

Omron's relay data demonstrates why a headline ampere rating is unsafe shorthand. Its MM family has different resistive and inductive ratings, and for DC inductive loads with larger L/R it warns that arc-breaking time can extend to 50 ms. ABB's contactor guidance likewise states that DC arc suppression is harder than AC and worsens as voltage and time constant rise; series poles may be required for DC breaking.

Manufacturer sources:
- https://www.ia.omron.com/products/family/959/specification.html
- ABB AF contactor utilization-category catalog, `1SXU100109C0201`.

**Freeze:** `CONTACT CARRY CURRENT >= LOAD CURRENT` is not a valid switching-suitability proof.

### 3. Suppression is part of the timing/lifetime problem

Omron recommends suitable contact-protection/surge suppression for inductive loads because arcing erodes/contaminates contacts. ABB Sentry BSR23 documentation states that arc suppression can prolong electrical life but may increase response time at inactivation. A suppression network therefore cannot be treated as a harmless afterthought in a safety stopping path: its effect on release timing and final-element behavior belongs in the validated safety function.

### 4. B10d / cycle dependence

B10d or mechanical/electrical life is an input to reliability reasoning, not a machine-level safety rating. A switching element's load type, utilization category, operations rate, ambient conditions and suppression affect real life. Therefore the learner must preserve the chain:

`documented component reliability data + actual duty/use profile + architecture/diagnostics/CCF + mission assumptions -> subsystem calculation -> complete safety-function evidence`

Never shorten it to `B10d present -> PL achieved`.

### 5. Logic relay versus hazardous-energy final element

A safety relay may directly switch a permitted load, drive force-guided expansion relays, or command contactors/drive safety inputs. Which is appropriate depends on the actual hazardous energy, utilization category, current/voltage, required isolation, fault behavior and safety architecture. A relay's internal safe output changing state is only a command/proposition at that boundary. The machine still needs evidence that the final element produced the required physical effect.

## Learner adversarial exercise

A retrofit uses a commercial module whose datasheet says `PL e / SIL 3`. It monitors a dual-channel E-stop and drives one ordinary contactor that removes a 480 VAC spindle motor. The contactor's auxiliary contact is returned to EDM. The spindle has significant stored rotational energy. The designer writes: “Safety relay is PL e, EDM proves the contactor opened, therefore the E-stop function is PL e and the spindle is safe when EDM closes.”

Required learner response:

1. Separate what is `DOC-CONFIRMED` about the relay from what is merely inferred about the complete safety function.
2. Identify at least one input/common-cause question, one final-element fault question, one contactor utilization/life question, and one physical-process proposition still unproved.
3. Explain exactly what EDM can and cannot witness.
4. State what machine-specific evidence is required before claiming standstill or a stopping time.
5. Refuse to assign a complete-function PL/SIL until the risk target, architecture, component reliability/use assumptions, diagnostics/CCF and validation evidence are established.

Expected reasoning principle (not a hidden evaluation answer): **COMMERCIAL SAFETY RELAY INSTALLED != COMPLETE SAFETY FUNCTION RATED OR PHYSICALLY PROVED.**

## New freezes

- **FORCE-GUIDED CONTACTS ENABLE COVERED DIAGNOSTICS; THEY DO NOT MAKE A RELAY INFALLIBLE.**
- **CONTACT CARRY CURRENT != SWITCHING SUITABILITY.**
- **RESISTIVE RATING != INDUCTIVE AC/DC INTERRUPTION RATING.**
- **ARC SUPPRESSION MAY CHANGE RELEASE BEHAVIOR; IT BELONGS IN VALIDATION.**
- **EDM AUXILIARY STATE != HAZARDOUS ENERGY REMOVED.**
- **RELAY RESPONSE TIME != MACHINE STOPPING TIME.**
- **COMPONENT PL/SIL/PFH != COMPLETE SAFETY-FUNCTION PL/SIL/PFH.**

## Next information-gain step

Build 2540's machine-level final-element lesson around contactor/drive-STO/valve examples: derive when a safety relay can directly switch a load versus when it is only logic feeding final elements; trace welded-main-contact and misleading-auxiliary-contact cases; and connect utilization category, suppression, feedback and physical proof to the 2520 verification/validation matrix. Do not invent a universal contactor topology or safety rating.
