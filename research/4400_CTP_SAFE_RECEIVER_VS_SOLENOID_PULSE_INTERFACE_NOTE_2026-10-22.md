# 4400 — CTP interface pulse semantics: do not transfer the 5 ms number across ports

**Scope:** EUCHNER CTP-I.-AP doc 2126290-08-07/24 §10.9, and CTP-L.-AP doc 2124217-08-06/21 §10.10. Manufacturer `DOC-CONFIRMED` interface notes; no selected receiver compatibility claim.

## Two distinct directions of signal

1. **CTP FO1A/FO1B -> safety controller input.** Both manuals say the receiving safe inputs must be suitable for **pulsed safety/OSSD signals**, and the controller must tolerate the switch's output test pulses. The precise switch pulse duration comes from the selected switch's technical data; receiver filter/diagnostic configuration must come from the selected controller. Matching 24 V nominal supply is insufficient.
2. **Safety controller outputs -> CTP locking solenoid (IMP/IMM).** Both manuals separately describe dual-channel control of solenoid voltage, recommend disabling output pulsing if possible, and state tolerance for controller pulses **up to 5 ms** in that specific solenoid-control context. This is **not** a blanket 5 ms permissible FO/OSSD input filter and does not establish safe unlocking under all pulse patterns.
3. **Supply UB -> switch.** The manuals separately describe tolerable brief supply interruptions (up to 5 ms) on UB and supply routing. Supply dropout tolerance is neither a machine safe-stop response time nor a lock-release timing guarantee.

## Interface qualification record

| Port / direction | Exact selected part and connector | Pulse producer | Pulse width/interval/polarity evidence | Receiver/filter/diagnostic evidence | Safety proposition | Status |
|---|---|---|---|---|---|---|
| FO1A/FO1B -> safe inputs | UNKNOWN | CTP selected variant | selected data sheet required | receiver safety manual/config required | I1 guard position vs L1 lock state | SCHEMATIC-BLOCKING |
| safety output(s) -> IMP/IMM | UNKNOWN | external safety controller | documented controller pulse mode required | CTP manual §10.9/§10.10 and variant wiring | external lock/unlock command authority | SCHEMATIC-BLOCKING |
| UB supply -> electronics | UNKNOWN | supply/control output | supply dip/startup evidence | selected CTP manual and supply design | switch operation only | SCHEMATIC-BLOCKING |

**Adversarial question:** A technician reads “5 ms tolerated” in the CTP manual and sets the safety receiver's OSSD input filter to 5 ms without checking the input manufacturer's manual. Is that justified? **No.** The cited 5 ms applies to a different interface direction/target. The actual receiver's allowed pulse shape, diagnostics, fault reaction and required safety integrity are UNKNOWN until documented.

**Boundary:** This is a source/design question. No lab is frozen; no person-exposed electrical or machine test is warranted. Normal LinuxCNC/FPGA diagnostics cannot become personnel-safety authority through a compatible pulse configuration.

## Direct source navigation (publication-review addition)

- [EUCHNER CTP-I.-AP 2126290-08-07/24](https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Operating-Instructions-Transponder-Coded-S%E2%80%A6_EN_08_07-24_2126290.pdf)
- [EUCHNER CTP-L.-AP 2124217-08-06/21](https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Transponder-Coded-Safety-Switch-With-Guard%E2%80%A6_EN_08_06-21_2124217.pdf)

These links identify source families/editions used by the companion investigation; they do **not** make this qualitative note an as-built machine design or a physical validation result. Verify exact selected product/manual and the proposition each source supports before publication.
