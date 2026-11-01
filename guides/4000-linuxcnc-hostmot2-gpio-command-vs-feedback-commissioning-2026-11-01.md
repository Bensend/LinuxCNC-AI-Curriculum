# 4000 — Mesa HostMot2 GPIO commissioning: command, connector level and independent feedback

**2026-11-01. NON-GRADUATED. NOT RUN.** Source companion: [HM2-GPIO-132](../research/4400_LINUXCNC_HM2_GPIO_132_DDR_LATCH_READBACK_CACHE_SOURCE_AUDIT_2026-11-01.md). Applies to ordinary LinuxCNC machine I/O on mills, routers, plasma systems and press-brake **normal control**, not safety-rated actuation.

## Do not collapse four different facts

1. **HAL request:** `hm2_*.gpio.N.out` is the desired output bit for a full GPIO. It does not itself prove DDR is configured or the FPGA has applied the request.
2. **FPGA configuration:** `is_output`, `invert_output`, `is_opendrain` select direction/polarity/driver behavior. A special-function pin belongs to its StepGen/PWMGen/etc module, not free GPIO.
3. **Connector electrical state:** A push-pull pin drives the requested level (possibly inverted); an open-drain `out=1` **releases** the line, not actively drives high. A pull-up, external circuit and wiring determine the observed level.
4. **Physical actuator state:** A valve, relay, spindle contactor, torch relay or backgauge actuator needs an **independent appropriate feedback signal** if the controller must know what happened. The HostMot2 manual explicitly leaves `gpio.N.in` undefined for normal push-pull outputs.

## Source-grounded servo-thread map

`hm2_*.read` → transport receive → `hm2_ioport_gpio_process_tram_read` → `gpio.N.in/in_not` HAL updates. Then normal control logic reads those inputs. Later `hm2_*.write` → `hm2_ioport_gpio_prepare_tram_write` → data TRAM write → `hm2_ioport_write` updates changed open-drain/invert/DDR registers. Forced startup writes DDR last. This ordering must be checked against the actual HAL `addf` list; it is not guaranteed merely by a net connection.

## Minimal review checklist for an existing HAL/INI

| Question | Evidence to capture | Reject this inference |
|---|---|---|
| Which connector pin is this? | HostMot2 firmware IDROM/module pin map and `dmesg` pin ownership | `gpio.N` number always means a free physical GPIO |
| Is it an input or output? | `is_output`, module ownership and actual DDR register | `out=1` automatically means the connector drives high |
| Is the output inverted/open drain? | `invert_output`, `is_opendrain`, pull-up and board electrical manual | `out=1` always actively sources voltage |
| Does `gpio.N.in` report the physical output? | Official HostMot2 manual's mode-specific semantics | Push-pull `in` is verified contact/actuator feedback |
| Was a config write accepted? | Transport return/status and actual FPGA readback when supported | `written_ddr` software cache equals hardware acknowledgement |
| Is feedback fresh? | Read/write thread order, last successful transport cycle, watchdog/error status | HAL signal existence implies freshness |

## Disconnected acceptance exercises

**G132-A:** In a fake low-level IO environment, start with `is_output=0,out=1`; capture output data word and DDR. Then set `is_output=1`, capture the order of TRAM data and DDR write. Expected by source: data first, DDR last in the normal write path.

**G132-B:** Simulate `llio->write` failing for a DDR change. Capture return, `written_ddr`, requested DDR, `io_error` and next-cycle writes. Expected by source: cache updated unconditionally in `hm2_ioport_force_write_ddr`; any actual recovery behavior depends on the broader transport path. Do not claim a physical FPGA fault from fake IO alone.

**G132-C:** Verify `gpio.N.in/in_not` decode against a synthetic data register, then distinguish this digital decode from an actual physical contact or open-drain bus measurement. All three cases are **NOT RUN**.

No self-hosted job should run until independent physical disconnection of the `[self-hosted, openpressbrake]` runner is positively established. Never use GitHub-hosted Actions or a live connected Mesa/FPGA/machine for these fault injections.

## Transfer boundary

For plasma arc-ok, use a real isolated input wired to the arc-ok circuit rather than assuming a torch-command output's `in` proves arc established. For a mill tool changer, separate drawbar command from clamp/seat confirmation. For a press brake, separate normal-control valve output from independent safeguarding and actual axis/pressure/valve feedback. **Do not** infer or modify OpenPressBrake G0/G1 personnel-safety gates from this software-only GPIO audit.

**Evidence:** pinned stable/development source and official HostMot2 manual; no executable result, firmware readback, electrical measurement or machine acceptance. Keep the [next checkpoint](../checkpoints/20261101T194000Z-4000-linuxcnc-homing-failure-sequence-next.md) as the Home All verification priority until replaced by a later checkpoint.
