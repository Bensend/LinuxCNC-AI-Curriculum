# Setup-Mode Safe-Speed Authority and Acceptance-Timeout Trace

Date: 2026-09-20
Active curriculum: 4000 safety course

## Question

What evidence prevents a setup/commissioning mode from becoming a generic bypass, and what happens when an acceptance test itself remains active too long?

## Manufacturer evidence

### Siemens CPU 317TF / SINAMICS S120 commissioning trial

Source: Siemens, `CPU 317TF-3 PN/DP: Controlling a SINAMICS S120 with Safety Functions — Getting Started`.
Official source: https://support.industry.siemens.com/cs/attachments/82107138/s7300_cpu_317t_f_3_pndp_s120_getting_started_en-US_en-US.pdf
Evidence classification: `DOC-CONFIRMED`.

Siemens provides a concrete SLS trial sequence rather than merely describing a mode bit. The drive first traverses at normal commanded speed. A commissioning key switch is selected. Opening the safety door while commissioning is selected does not preserve unrestricted production behavior: the drive continues only with speed reduced to the safely limited speed and the commissioning/safety status changes accordingly. Closing the door does not silently restore normal operation; a safety acknowledgement is required. After acknowledgement/reintegration, the drive can return to the original velocity when no safety event remains.

This yields:

**COMMISSIONING MODE SELECTED != UNRESTRICTED MOTION AUTHORITY.**

**GUARD OPEN IN COMMISSIONING != NORMAL PRODUCTION SPEED PERMITTED.**

**GUARD RECLOSED != NORMAL SPEED AUTOMATICALLY RESTORED WITHOUT THE DEFINED ACKNOWLEDGEMENT PATH.**

The example does not by itself prove an enabling-device requirement, a fresh production START edge after exiting commissioning, or an OpenPressBrake-specific safe speed. Those remain `UNKNOWN`.

### Siemens acceptance-test mode has a bounded lifetime

Source: Siemens, `Help for the acceptance test in SINUMERIK Operate`.
Official source: https://support.industry.siemens.com/cs/attachments/109748864/840Dsl_ATW_fct_man_0517_en-US.pdf
Evidence classification: `DOC-CONFIRMED`.

Siemens states that acceptance-test mode is activated only for particular tests and may remain active only for a limited time. When the configured time expires, the drive automatically resets acceptance-test mode and the test is canceled even if unfinished.

This is a valuable anti-bypass pattern:

**ACCEPTANCE/TEST MODE ENTERED != INDEFINITE TEST AUTHORITY.**

**TEST TIMEOUT != TEST PASS.**

**TEST CANCELED != SAFETY FUNCTION ACCEPTED.**

A service/acceptance state that weakens or changes ordinary restrictions should therefore be deliberately bounded, observable, and fail toward loss of test authority rather than becoming a forgotten persistent machine state.

### Pilz PNOZ s30 — setup and automatic speed limits are separate safety states

Source: Pilz, `PNOZ s30 Operating Manual`, 1001715-EN-24.
Official source: https://www.pilz.com/download/open/PNOZ_s30_Operat_Man_1001715-EN-24.pdf
Evidence classification: `DOC-CONFIRMED`.

Pilz documents separate `Setup` and `Automatic` operating-mode selection inputs with different monitored overspeed limits in its worked configuration. Overspeed in the selected mode switches the relevant safety output off; standstill and feedback-loop monitoring are separate functions.

The numeric frequencies in the Pilz example are product/example-specific and are **not** OpenPressBrake design values.

Architecture lesson:

**MODE SELECTED != SPEED SAFE.**

**SETUP SPEED THRESHOLD CONFIGURED != PHYSICAL SPEED MONITORED BELOW THRESHOLD.**

**SETUP MODE != AUTOMATIC MODE WITH A DIFFERENT HMI LABEL.**

## Combined acceptance contract

The following is a reusable `INFERENCE`, bounded by the manufacturer examples above and earlier enabling-switch evidence in the course:

1. a deliberate, access-controlled mode selection requests setup/commissioning authority;
2. independent safety logic identifies that mode and suppresses ordinary unrestricted production authority;
3. if safeguarded access is opened under the permitted setup architecture, motion remains subject to the task-specific safe-motion function rather than reverting to normal control authority;
4. physical speed/motion is challenged against the active safety limit during validation;
5. overspeed or invalid mode/safety state causes the defined safe reaction;
6. any special acceptance-test authority is time-bounded; timeout cancels the test and is not a pass;
7. closing a guard/removing the test condition does not silently erase required acknowledgement/requalification;
8. leaving setup mode should remove setup-specific motion authority before ordinary production authority is restored;
9. production restart should require the separately validated reset/rearm/fresh-start semantics rather than inheriting a stale motion request.

## Human-factors / adversarial review

A setup mode is defective if the easiest way to perform normal production is to leave the machine in setup. Practical design review should ask:

- Can the key/credential be left permanently selected?
- Does setup unnecessarily cripple legitimate adjustment work, motivating bypass?
- Can the operator obtain unrestricted speed with the guard open through ordinary LinuxCNC/FPGA commands?
- Does a timeout actually remove special authority, or merely hide an indicator?
- Can closing the guard restore high-speed motion while a stale command remains asserted?
- Is the transition back to production conspicuous and deliberate?
- Are diagnostic/status messages clear enough that technicians can use the proper mode rather than defeating a safeguard?

## OpenPressBrake boundary

No OpenPressBrake safe speed, timeout, PL/SIL, guard architecture, enabling-device topology, or acknowledgement sequence is assigned here. Those require the actual risk assessment and safety design.

LinuxCNC/normal FPGA may request a mode, display its status, and provide diagnostic context. They must not become the sole personnel-safety authority deciding that guarded access plus reduced-speed motion is safe.

## Information-gain status

The mode-selection + guard-open + SLS-reduction + acknowledgement chain and the bounded acceptance-test timeout are now materially documented. The remaining high-value gap is a single manufacturer acceptance sequence that additionally includes a three-position enabling device and explicit transition from setup exit through rearm to a **fresh** production START. Reopen only for that stronger integrated witness; otherwise rotate to another physical safety-function branch.
