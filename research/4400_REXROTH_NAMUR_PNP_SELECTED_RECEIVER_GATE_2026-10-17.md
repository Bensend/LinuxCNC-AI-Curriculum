# 4400 — Monitored hydraulic valve feedback: NAMUR is not PNP

**Evidence:** DOC-CONFIRMED for the named manufacturer product families; actual machine interface UNKNOWN; all tests NOT RUN. Public curriculum only, not a machine safety approval.

Bosch Rexroth RE 21015, edition 2019-07, pp. 12–13 documents QM and Q6 valve position switches using 24 V PNP transistor outputs (400 mA and 200 mA listed output capacity respectively) and Q8 using 8.2 V NAMUR current signalling with separate required evaluation electronics. Both descriptions include four-pole M12 connections, but the pin functions and electrical signalling differ. A mechanically mating connector is not an interface qualification. The same manual, pp. 2–3, treats valve/cover/sensor as a factory-matched unit and requires replacement of the complete assembly rather than field exchange/adjustment of individual sensor parts. Page 79 lists application-dependent certificates available upon request; a listing is not proof that an installed valve or machine qualifies.

**Source:** Bosch Rexroth, *2-way cartridge valves with spool position monitoring, passively controlled*, RE 21015 (2019-07), manufacturer-authored PDF mirrored at https://www.leaderhydraulics.com/wp-content/uploads/2021/06/R900703383.pdf . Current official document lookup: https://www.boschrexroth.com/en/us/downloads/ .

**Independent receiver example:** Pepperl+Fuchs KFU8-SR-Ex2.W lists NAMUR inputs, configurable mode and line-fault detection. Its published breakage/short thresholds are product-specific, not an established cross-vendor compatibility guarantee. https://www.pepperl-fuchs.com/fi-fi/products-gp25581/103253 . The receiver's fault-detection configuration, safe polarity, safety output allocation and physical machine witness must be validated for a selected design.

**Adversarial checks (all NOT RUN):** wrong complete-assembly substitution; 24 V PNP receiver fed by NAMUR sensor; line break/short with diagnostic disabled; inverted receiver output; one receiver signal copied to two inputs and incorrectly credited as independent; healthy valve feedback contradicted by ram movement; power restoration with retained ordinary start; maintenance with trapped pressure/gravity.

**Eight-field SO witness:** record demanded action, physical final element, exact feedback target, narrow legitimate proposition, shared dependencies/CCFs, residual energy, independent machine-level physical witness and maintenance isolation/blocking. Map these to `SRS/PHY/AUTH/DEP/ARC/VAL/CHG/UNK` in the cumulative Safety Design Package. Any material replacement makes dependent validation STALE until reviewed.

**Freeze:** `M12 FIT != ELECTRICAL COMPATIBILITY`; `NAMUR != 24V PNP`; `LINE FAULT FEATURE PRESENT != SAFETY RESPONSE VERIFIED`; `DUPLICATED SIGNAL != INDEPENDENT SAFETY CHANNEL`; `VALVE POSITION EXPECTED != RAM SAFE STATE PROVED`.

No lab is justified for these documented electrical differences. Ordinary LinuxCNC/FPGA status is not independent personnel-safety authority. Personnel-exposed hazardous operation must remain prohibited until the machine's required independent physical safeguards are validated.