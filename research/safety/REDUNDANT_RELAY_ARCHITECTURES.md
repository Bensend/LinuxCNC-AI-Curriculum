# Redundant Low-Cost Safety Relay Architectures — Prior Art Survey

This note captures existing industrial and open designs relevant to a low-cost safety architecture based on multiple independently driven relays, series safety contacts, direct electrical feedback, startup/proof testing, and an independent hardwired E-stop path.

## Executive finding

The proposed architecture is not an oddball idea. Several commercial SIL/PL products use closely related principles:

- multiple relay contacts in series so any one healthy contact can break the hazardous-enable path;
- separate relay coils or independently controlled switching elements;
- deliberate sequencing of individual relays during tests;
- electrical or auxiliary-contact monitoring to detect welded contacts;
- redundant processors or independent logic paths in higher-rated products;
- a de-energize-to-safe final output chain.

The most direct precedent found is Fisher-Rosemount / Emerson US7582989B2, “Safety relay having independently testable contacts.” It describes multiple relay coils controlled independently, their associated relay contacts connected in series, and testing each contact by switching its individual coil while measuring an electrical characteristic such as voltage/potential or current. The explicit purpose is to identify inoperable/welded contacts. This is extremely close to the proposed three-relay + node-voltage-sensing idea.

## 1. Fisher-Rosemount / Emerson — independently testable series contacts

Patent: US7582989B2, priority 2006, granted 2009.

Relevant architecture:

- multiple relay coils;
- coils connected in parallel to the control side;
- one independently controlled switch/driver per coil;
- associated relay contacts connected in series in the safety path;
- each contact can be deliberately opened independently;
- the controller measures an electrical characteristic of the contact chain, explicitly including electric potential/voltage or current;
- the measured state is used to determine whether a particular contact is welded or otherwise inoperable.

This is the closest match found to the proposed architecture.

Research implication: study the patent schematics and claims carefully before settling our sensing-node placement and test sequence. The patent is active until 2027 according to Google Patents, so it is a useful technical source but should not simply be copied into a commercial product without a separate IP review.

Source:
https://patents.google.com/patent/US7582989B2/en

## 2. Weidmüller SAFESERIES — three relays, contacts in series, SIL 3

Weidmüller SAFESERIES safety-relay manuals describe three elementary relays in the input/actuation section with their output contacts wired in series. The stated reason is that shutdown is still available when one contact sticks/welds. Published manuals claim SIL 3 for applicable devices and provide test terminals/proof-test instructions.

A 2023 safety manual states:

- three relays are connected in parallel in the input circuit;
- their output contacts are connected in series;
- the series arrangement maintains safety-related shutdown even with a welded contact;
- relay switching status can be checked through a monitoring/test contact.

Older SCS/SafeSeries documentation also describes three series contacts and test terminals intended to verify relay contacts.

Research implication: three-relay series output is already a commercial SIL3 pattern in process safety. Our differentiator would be low-cost implementation, direct node sensing, FPGA-driven automatic proof testing, and transparent fault evidence rather than the basic redundancy topology itself.

## 3. Pepperl+Fuchs KFD2-RSH — 1oo3 with sequential diagnostics

Pepperl+Fuchs describes a “1oo3” safety-relay architecture with three elementary relay contacts in series for de-energized-to-safe applications.

Important details:

- the safety function remains available if up to two contacts fail closed;
- diagnostics are performed by moving contacts in sequence with time delays;
- during restart, the device uses the order of contact closure and the presence or absence of current to identify a relay that no longer disconnects the circuit;
- the manufacturer emphasizes reduced proof-test effort compared with unmonitored 1oo3 arrangements.

This is particularly relevant because it demonstrates that sequentially actuating individual relays to diagnose the series chain is established industrial practice.

Research implication: compare their sequence against our proposed startup test. Determine whether adding voltage-sense nodes between all three contacts provides better fault localization than the commercial approach.

## 4. Phoenix Contact — 1oo3 standard relays versus 1oo2 force-guided relays

Phoenix Contact explicitly discusses two accepted families of safe coupling-relay architectures:

- 1oo3 using three standard elementary relays in series;
- 1oo2 using two force-guided elementary relays in series.

Their explanation says the force-guided 1oo2 arrangement is easier to proof-test because the mechanically linked NC monitoring contact reveals the state of the load contact. The 1oo3 architecture remains a recognized approach, but proof testing standard relays is more labor intensive unless extra diagnostics are added.

Research implication: this supports the core hypothesis that ordinary relays can provide strong redundant interruption if we solve the diagnostics problem. Our direct voltage-sensing and individual actuation may provide exactly the missing diagnostic layer.

## 5. Siemens SM 1226 F-DQ relay module — independent coils, series contacts, dual processors

Siemens’ fail-safe S7-1200 relay-output module uses an architecture with two relay contacts in series in each circuit. The contacts are controlled by independent relay coils and different microcomputers. Each microcomputer monitors mechanically linked sense contacts associated with the other path. Siemens also switches the series contacts in sequence to reduce/common-mode welding risk.

Important principles to reuse:

- series contacts driven independently;
- independent logic ownership of separate relay coils;
- cross-monitoring rather than one controller trusting itself;
- sequential switching to avoid common-mode contact stress;
- mechanically linked feedback where formal rating is required.

Research implication: if OpenPressBrake uses an FPGA as the main safety monitor, an external watchdog or second tiny controller could provide independent supervision without needing a full dual-CPU safety PLC.

## 6. Allen-Bradley / Rockwell — three-relay redundant self-monitoring circuit

Rockwell’s older safety-relay technical literature shows a three-relay redundant, self-monitoring circuit and explains that it can still remove power if a contact welds and will refuse a subsequent restart until the fault is corrected.

This demonstrates that three mutually monitored ordinary electromechanical relays are longstanding safety-relay practice, not merely a theoretical construction.

Research implication: recover the exact ladder logic and analyze which contact combinations perform self-checking versus cross-monitoring. Compare its diagnostic coverage against direct voltage sensing after each relay.

## 7. Historical patent precedent — three-relay monitoring circuits

DE19930994B4 describes safety circuits involving at least three customer relays with monitoring contacts arranged so controllers can distinguish safe and unsafe states. Other older patents classify explicitly under “monitoring or fail-safe circuits using plural redundant serial connected relay operated contacts.”

Research implication: there is a substantial prior-art family around mutually monitored series relay chains. We should mine these patents for failure cases and test methods, not for proprietary implementation copying.

## 8. Open-source safety projects worth studying

### OpenVVVF

OpenVVVF is an open high-power inverter project using dual MCUs / an independent safety coprocessor, isolated gate drives, HARA, and an extensive fault-injection plan. It does not implement our exact relay topology, but it is a strong model for publishing safety goals, assumptions, architecture, and tests without claiming certification that has not been performed.

### Open Source Safety Consortium — Protective Stop

The Protective Stop project is open hardware/software with two independent per-core input channels on an ESP32-S3, heartbeat-based fail-safe communication, ROS 2 integration, and published safety evidence. It is explicitly a protective stop rather than an energy-removing E-stop, but its evidence-first approach is useful for our curriculum.

### openAMRobot

The openAMRobot carrier-board discussion describes an architecture where an MCU monitors E-stop/safety-edge diagnostic contacts but has no electrical or firmware path capable of actuating the E-stop relays. This is a useful example of deliberately separating diagnostics from final safety authority.

## 9. What appears genuinely promising for our design

A first reference architecture worth analyzing is:

24 V safety supply -> K1 contact -> sense A -> K2 contact -> sense B -> K3 contact -> sense C -> downstream safety enable

with:

- K1/K2/K3 independently driven;
- each node read through a protected 24 V digital-sense circuit;
- startup/proof test that actuates one relay at a time;
- fault latching if the observed node pattern does not match the commanded pattern;
- a hardwired E-stop path that mechanically removes coil power independently of FPGA/software state;
- downstream feedback from the final contactor/STO/valve where available;
- a hardware watchdog independent of the FPGA logic;
- default-off relay drivers during FPGA configuration/reset/power loss.

The literature strongly suggests that the basic 1oo3 series-relay idea is sound. The engineering question is therefore not “does anyone do this?” but rather:

1. How much diagnostic coverage does direct node sensing provide compared with force-guided auxiliary contacts?
2. Which single failures remain dangerous?
3. Which common-cause failures defeat multiple channels at once?
4. Can the sensing network itself be self-tested?
5. Does one FPGA create an unacceptable common-cause control failure, and how cheaply can an external watchdog or second logic device reduce that risk?
6. What loads should the PCB relay chain switch directly versus only commanding STO, contactor coils, or valve-enable power?
7. What proof-test interval is justified by relay duty and manufacturer B10/B10d data?

## 10. Immediate next experiments / analysis

1. Reconstruct the Fisher-Rosemount three-relay independently testable-contact circuit from the patent and map it to our proposed A/B/C voltage nodes.
2. Reconstruct the Rockwell three-relay self-monitoring ladder and enumerate its detectable and undetectable faults.
3. Model Pepperl+Fuchs 1oo3 sequential diagnostics as a state machine.
4. Compare three architectures under the same fault matrix:
   - three ordinary relays + direct node-voltage sensing;
   - two force-guided relays + NC feedback/EDM;
   - three force-guided relays + node sensing.
5. Estimate BOM cost for each at single-unit and small-quantity pricing.
6. Build a fault table covering welded contacts, coil open, coil short, transistor short/open, sense input stuck high/low, short-to-24 V, short-to-0 V, broken trace, FPGA output stuck high, FPGA freeze, watchdog failure, common 24 V failure, and downstream contactor/valve failure.

## Bottom line

The strongest finding is that commercial safety systems already use almost every individual principle being proposed: three series relays, independent actuation, sequential testing, measurement of electrical state, redundant processors, and hardwired de-energize-to-safe outputs. The exact combination of inexpensive PCB relays + per-node voltage sensing + FPGA diagnostics + hardwired E-stop coil-power removal appears to be a credible low-cost research direction worth formal fault analysis and bench testing.
