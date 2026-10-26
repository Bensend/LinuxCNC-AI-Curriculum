# ESTOP-MECH-01 — Mechanical, electrical and physical authority matrix

Status: documentary comparison, not a safety validation. **G0/G1 HOLD**.

| Scenario | Front actuator | Rear mounting/contact | Receiver may report | Physical motion/hold | Classification |
|---|---|---|---|---|---|
| Healthy, correctly assembled | Unpressed | NC permissive; mounting monitored if selected | Ready, subject to configured interlock | UNKNOWN until separately validated | DOC-CONFIRMED OEM principle; physical UNKNOWN |
| Intended E-stop demand | Pressed/latches | Correctly coupled NC opens | Stop demand if correct wiring | UNKNOWN until independently witnessed | DOC-CONFIRMED principle |
| Conventional holder detaches | Pressed/latches | NC may stay closed because actuator no longer drives it | Could appear ready if no mounting monitor | UNKNOWN; potentially hazardous | INFERENCE, device-specific |
| Siemens 3SU1400 monitored holder detaches | Any | OEM states mounting monitor triggers shutdown | Should demand stop with qualified circuit | UNKNOWN | DOC-CONFIRMED indexed Siemens p.149 |
| Siemens monitored module just installed | Initial state | OEM requires initial actuation test before ready | Initial permissive may be withheld | UNKNOWN | DOC-CONFIRMED indexed Siemens p.149 |
| Operator releases latched head | Released | NC may return closed | Input can become ready | UNKNOWN; no automatic restart authorized | DOC-CONFIRMED Rockwell Safebook 5 |
| Independent physical holding fails | Any | Input/receiver may correctly demand stop | Stop demand present | Hazardous motion can persist without independent restraint | INFERENCE; actual machine UNKNOWN |

**Proof separation:** mounting status ≠ NC actuation ≠ safety receiver response ≠ physical stop ≠ gravity hold ≠ energy isolation ≠ fresh start. A single common holder may defeat two nominal electrical channels; do not assume diagnostic coverage without exact-device analysis.

**Human factors:** prefer easy isolated access, robust captive attachment, positive part identification and usable fault messages; never solve nuisance trips by eliminating the mounting monitor.
