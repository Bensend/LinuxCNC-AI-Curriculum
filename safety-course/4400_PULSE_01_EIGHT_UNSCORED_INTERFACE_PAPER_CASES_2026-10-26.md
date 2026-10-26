# 4400-PULSE-01 — Eight unscored interface cases
**2026-10-26 | PAPER ONLY / UNSCORED / no hidden key**

For each case identify exact OEM manual/port, safety function, evidence class, unsafe shortcut, and documentary discriminator. No live wiring, simulation or fault injection.

1. A safety light curtain's OSSD briefly goes low during a self-test while its protective field remains clear. The PLC reports nuisance stops.
2. A technician copies a 5 ms safety-controller test-source timing specification into an unrelated OSSD receiver design.
3. A LinuxCNC input is labeled `safety-ok` and connected directly to a curtain OSSD without an independent safety controller.
4. A guard receiver is changed to a different part number with a longer diagnostic pulse; the old input compatibility statement is assumed valid.
5. A test-source output is proposed to energize a contactor coil to save one output.
6. A safety mat and unrelated interlock share one test-pulse source, despite the selected OEM's assignment restriction.
7. A new beam-coding setting improves interference immunity but changes the response-time specification; no protective-distance review is performed.
8. A curtain and safety controller both show green, but the hydraulic Y1/Y2 ram can still drift under gravity after the normal command is removed.

**Status:** eight public practice cases UNSCORED, not independent blind evaluation. G0/G1 HOLD; no physical machine test or release.
