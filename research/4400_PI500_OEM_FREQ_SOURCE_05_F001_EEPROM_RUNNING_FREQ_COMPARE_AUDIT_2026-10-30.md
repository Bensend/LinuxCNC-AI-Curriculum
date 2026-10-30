# 4400-PI500-OEM-FREQ-05 — Frequency-source selection, EEPROM writes and the wrong comparison signal

**2026-10-30 | 4400 safety-course source-depth | NON-GRADUATED | no physical validation | no safety authority assigned to Modbus**

## Question and predecessor check

The 11:37Z [PI500-FREQ-04 audit](4400_PI500_FREQ_04_ZERO_NEGATIVE_NONFINITE_COMMAND_AND_RETAINED_RUN_SOURCE_AUDIT_2026-10-30.md) established that zero/negative/invalid normal frequency can coexist with an ordinary RUN request. This follow-on asks a *different* cross-layer question: **does the frequency register that LinuxCNC writes control the frequency source the OEM says the drive may actually use, and can the driver's compare/write loop repeatedly write a nonvolatile parameter?** Direct full-index/research/progress/maintainer scans for `EEPROM`, `0x0001`, `F0.03`, `0x1000` found no prior PI500 treatment. This is a new exact OEM/source interaction, not a new scored safety competency.

## Direct, edition-bounded sources

1. **SOURCE-CONFIRMED** — LinuxCNC development commit `e1c6a557c0e1c61961f17ee35a1ba188e7db275f`, [`src/hal/user_comps/pi500_vfd/pi500_vfd.comp`](https://github.com/LinuxCNC/linuxcnc/blob/e1c6a557c0e1c61961f17ee35a1ba188e7db275f/src/hal/user_comps/pi500_vfd/pi500_vfd.comp), blob `92cc57bdf5214bbb3fb92103837539e42a76d452`. Relevant functions: `pi500_setFrequency`, `pi500_getStatus`, `user_mainloop`. Stable v2.9.10 source was previously confirmed to retain the same F001 write/running-frequency comparison (blob `b77f6e0241d3bf9db44edd97ddbb229af184dd18`); not retested in this session.
2. **DOC-CONFIRMED in manufacturer-authored, third-party-hosted March 2018 PI500 manual, not a selected machine:** [Appendix I, printed p. 89, viewer p. 93](https://www.manualslib.com/manual/1658524/Powtran-Pi500-Series.html?page=93): writing `F0.01` via `0xF001` is the keyboard frequency setting when `F0.03=0/1`; RAM-only alternative `0x0001`; `F0.03=9` selects the *different* communication frequency reference `0x1000`, expressed as ±10000 corresponding to ±100% of maximum `F0.19`. `0x1001` is **running frequency**, not the accepted frequency setpoint. The same page warns that frequent EEPROM storage shortens its life.
3. **DOC-CONFIRMED** — [2018 manual, printed p. 30, viewer p. 34](https://www.manualslib.com/manual/1658524/Powtran-Pi500-Series.html?page=34) identifies `F0.01` keyboard frequency, `F0.02` resolution and `F0.03` source selections 0/1 keyboard versus 9 remote communication. [Viewer p. 33](https://www.manualslib.com/manual/1658524/Powtran-Pi500-Series.html?page=33) distinguishes running frequency and set frequency.
4. **Independent same-manufacturer-edition corroboration** — [older 166-page PI500 manual, Appendix I printed pp. 151–152](https://www.manualslib.com/manual/1344397/Powtran-Pi500-Series.html?page=155) repeats EEPROM/RAM mapping and [p. 156](https://www.manualslib.com/manual/1344397/Powtran-Pi500-Series.html?page=156) repeats two distinct frequency-setting routes. These are not runtime tests or proof of 2025 V5.1 behavior.
5. **Edition limit:** Powtran's [official download landing page](https://en.powtran.com/Download_1/33.html) lists V5.1 dated 2025-06-16, posted 2025-12-18; the complete V5.1 PDF was **not** retrieved. No exact installed model, firmware, `F0.03`, `F0.11`, `F0.12`, `F0.19` or nonvolatile write behavior has been established.

## Cross-layer source trace

```c
// pi500_getStatus:
modbus_read_registers(ctx, 0xF001, 1, &speed_setting); // value is never used
modbus_read_registers(ctx, 0x1000, 8, status_params);
status->frequency = status_params[1];                 // OEM 0x1001 RUNNING frequency

// user_mainloop:
if (commanded_frequency > 0
    && calculated_frequency != status.frequency
    && !pi500_setFrequency(ctx, calculated_frequency)) { /* error */ }

// pi500_setFrequency:
modbus_write_register(ctx, 0xF001, frequency);         // OEM F0.01 keyboard parameter
```

**SOURCE-CONFIRMED:** there is no source check of `F0.03`, `F0.11`, `F0.12` or `F0.19`; `0x1000` is read into `status_params[0]` but not used to establish selected command source; `speed_setting` is read but unused. The comparison is **requested setpoint versus measured running frequency**, not requested versus accepted setpoint. `run` is independently processed after this write logic. The driver can therefore attempt an F001 write even with `run=false` and a stopped motor, provided `enable=true`, no alarm, positive requested frequency and a successful status read.

**DOC-CONFIRMED, configuration-dependent:** on the 2018 OEM mapping, F001 is a keyboard setting and 1000 is the separate communication reference. Writing F001 is **not equivalent** to commanding 1000 when the selected frequency source is remote communications. A command-source binding (`F0.12`) or other selected-model setting could alter which frequency the drive actually uses; do not claim all PI500 machines ignore F001.

**INFERENCE with explicit conditional:** with a stopped drive reporting running frequency zero and a positive nonzero request, the loop can repeatedly *attempt* F001 writes while run is false. The OEM warns against frequent EEPROM writes and provides the RAM-only F-group address `0x0001`; this establishes a **credible endurance risk**, not a measured flash/EEPROM failure, write count or exact persistence implementation. During acceleration, running frequency may differ from the requested setpoint for legitimate reasons and provoke additional writes. An accepted write response alone does not prove that the selected frequency source changed.

## Adversarial state matrix (source prediction only; NO EXECUTION)

| Frozen status/configuration | Source prediction | Crucial unresolved physical/OEM question |
|---|---|---|
| Stopped; running frequency 0; request 50 Hz; `run=0`, `enable=1`, no alarm | F001 write attempted on each completed iteration if running frequency remains unequal. | Does this model store every F001 write to EEPROM, coalesce writes or reject repeats? |
| F0.03=9 remote frequency source; F001 write succeeds; run later requested | Driver does not write OEM `0x1000`; F001 success cannot establish selected communication setpoint. | Does the installed F0.12 command binding override source selection, and what frequency is actually used? |
| F0.03=0/1 keyboard frequency source; motor accelerating toward requested frequency | F001 write may repeat while `0x1001` running frequency lags requested. | Is a repeated F001 write durable, volatile, rate-limited or otherwise handled by exact firmware? |
| `speed_setting` read equals requested, `0x1001` running differs | Source still attempts F001 write; accepted-setting read is ignored. | Is F001 readback meaningful for the selected model and source? |
| Communication loss, alarm, disabled enable | Existing PI500-VFD-01/OEM-COMM-02/MULTI-03 failure paths still govern. | No ordinary Modbus result establishes a protective stop or machine safe state. |

## Upstream review disposition and safer engineering boundary

**Priority HIGH for ordinary-control correctness/reliability review, not an established field failure.** Before patching: identify supported model/firmware and configured frequency source; specify separate keyboard F0.01 and communication `0x1000` modes; confirm whether RAM-only `0x0001` is supported and when persistent writes are justified; compare requested command against the correct accepted setpoint (not motor running frequency); define bounded write/retry behavior; validate finite range/resolution and independent RUN/restart policy from PI500-FREQ-04. Avoid a blind `F001→1000` substitution because `0x1000` uses *percent-of-F0.19* units, not raw Hz. No numerical `F0.19`, cycle rate, endurance lifetime or physical motor behavior is assumed.

**Personnel protection remains outside this path.** Normal LinuxCNC/FPGA/Modbus may command and diagnose the drive, but independent safety logic and proven physical energy-removal/holding mechanisms must protect people. The OpenPressBrake Stage A A–G evidence and independent 2520–25F0 evaluator remain open. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed hazardous operation.

## Verification and next question

No build, simulation, test, workflow, GitHub-hosted or self-hosted compute, machine operation, independent evaluation, or upstream submission. **TEST-CONFIRMED none**. Exact selected drive and physical responses **UNKNOWN**. A future pure-software mock, only if a maintainer-defined contract leaves an unresolved control question and the self-hosted `[self-hosted, openpressbrake]` panel PC is independently isolated, would count attempted F001/1000 writes and enforce mode-specific invariants; never dispatch without qualified isolation. Next best information gain: selected OEM/firmware confirmation and upstream maintainer review, not another speculative physical test.

## Same-session source-depth: F0.11/F0.12 is an additional command-to-frequency binding gate

The [March 2018 OEM F0 table, printed p. 31 / viewer p. 35](https://www.manualslib.com/manual/1658524/Powtran-Pi500-Series.html?page=35) independently confirms **F0.11** selects keyboard, terminal, communications, or mixed *run-command* channels, while **F0.12** separately binds frequency source by channel (hundreds digit for communications; 0 no binding, 1 keyboard, 9 communications, with other choices). Thus a maintainer cannot infer the active frequency source from F0.03 alone; the selected command channel and any binding are a second discriminator. This tightens the conditional claim above: F001 writes may control frequency in a configured keyboard/bound mode, but may not in a remote-frequency mode. The driver inspects neither parameter. **DOC-CONFIRMED at the 2018 table, SOURCE-CONFIRMED at the pinned driver, actual precedence for any installed firmware UNKNOWN.** No machine motion, parameter edit, test or safety release.
