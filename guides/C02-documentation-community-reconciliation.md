# C02 — documentation and community reconciliation

Pinned source baseline for behavioral claims: `8bf4605ae81042248add031e94c77300406e0413`.

## Official documentation corroboration

Current LinuxCNC stable PID documentation describes each PID channel in terms of its own `command`, `feedback`, `error`, `output`, and `enable` pins. It explicitly states that disabling a loop resets its integrators and forces its output to zero. Current `sampler(9)` documentation separately describes `sampler` as the realtime half of the `sampler`/`halsampler` pair: realtime HAL data are captured into a FIFO and later copied by userspace.

These documentation statements corroborate, but do not replace, the pinned-source C02 claims:

- one PID instance operates on its own command/feedback/control state;
- disabled PID output is a software-loop behavior, not actuator-isolation evidence;
- simultaneous-state assertions should be observed in the realtime sampling domain rather than reconstructed from sequential userspace reads.

Sources consulted 2026-09-08:

- LinuxCNC stable HAL realtime components / PID documentation: <https://www.linuxcnc.org/docs/stable/html/hal/rtcomps.html>
- LinuxCNC stable PID man page: <https://www.linuxcnc.org/docs/stable/html/man/man9/pid.9.html>
- LinuxCNC sampler man page: <https://www.linuxcnc.org/docs/master/html/en/man/man9/sampler.9.html>

## Community-reported machine patterns

Community examples are **COMMUNITY-REPORTED**, not normative source evidence. They are useful because real tandem/gantry configurations repeatedly expose separate per-side PID and feedback paths rather than an implied peer comparison inside stock PID.

Examples reviewed:

- A tandem/gantry configuration shows a distinct `pid.y2` command, feedback, output, and step-generator path for the second side: <https://forum.linuxcnc.org/49-basic-configuration/33079-how-to-2-or-more-motors-on-one-axis-gantry-linuxcnc-2-8-master?start=40>
- A YY2 gantry troubleshooting thread asks for both joints' following-error and encoder-velocity traces independently, illustrating that side-specific evidence matters when one side behaves unexpectedly: <https://forum.linuxcnc.org/38-general-linuxcnc-questions/40073-velocity-tuning-of-yy2-gantry>
- A servo-gantry example contains distinct `y1servo_pid` / `y2servo_pid` style control paths and encoder feedback, again showing that separate loops must be wired explicitly: <https://forum.linuxcnc.org/38-general-linuxcnc-questions/28170-yaskawa-servomotors>

## Reconciled teaching

The documentation, community configurations, pinned source, and C02 laboratory design all point to the same narrow statement:

> Sharing a motion command between two control loops does not itself create feedback comparison or cross-coupled synchronization.

That statement does **not** imply that independent loops are the correct final architecture for a physical tandem machine. C03 exists specifically to study explicit synchronization/cross-coupling. Safety-rated disagreement detection, actuator isolation, hydraulic/mechanical interaction, and acceptable fault response remain separate engineering and safety questions.
