# 4400-HYD-SURGE-01 — Technician card: normal gauge ≠ proven safe pressure peak
**Documentary review only · 2026-10-28 · Not a live-test procedure or OpenPressBrake release**

**The trap:** a steady pressure gauge reads normal, a replacement hose advertises a high burst rating, and the mechanic plans to stand beside a pressurized line to watch for leaks. These are **three different safety questions**, none resolved by a green LinuxCNC screen.

**Check the claims before touching the machine:**
1. **Gauge location:** which exact port and isolated volume does it witness? A check valve or internal cushion may hide another pressure state.
2. **Gauge time response:** a mechanical gauge can show ordinary pressure while missing a short peak. If dynamic rating matters, require a qualified sensor/recording plan for that *specific* line; do not invent a universal sample rate.
3. **Assembly rating:** check the lowest published **working** rating of the actual hose, fittings and adapters, plus fluid/temperature, routing and installation. **Burst-test rating is not operating permission.**
4. **Test-station safety:** pressure testing creates its own stored-energy, flying-fitting, hose-whip and injection hazards. Use qualified written isolation, rated connectors, remote/segregated observation, safe drain and independently verified pressure release. **Do not improvise a live test on the press.**
5. **Maintenance convenience:** keep approved labeled test points, compatible connector kits, rejected-part bins, remote readouts and easily restored guards; eliminate the reason a rushed mechanic would loosen a fitting or reach into a spray path.
6. **Release boundary:** an acceptable hose/pressure record is **not** proof of independent Y1/Y2 stopping, gravity-load holding, guards, reset or restart. Keep those proofs separate.

**Emergency:** if fluid may have entered skin, seek immediate emergency medical assessment even if the wound seems tiny. Do not delay for symptoms or finish the shift. HSE FOD 4-2014 documents a fatal high-pressure fitting incident.

**Counterexample:** a calibrated pressure sensor on the pump manifold may be accurate, yet unable to observe a separate cylinder volume behind a check valve. A fast sensor can still be at the wrong place; a correctly located slow gauge can still miss the transient. These are *independent* defects.

**References:** [Original Parker/HSE audit](../research/4400_HYD_SURGE_01_PARKER_GS4_PEAK_PRESSURE_GAUGE_BLIND_SPOT_AND_TEST_RIG_SAFETY_SOURCE_AUDIT_2026-10-28.md); [existing hose-injection lesson](../research/4400_HYDRAULIC_PINHOLE_INJECTION_HOSE_FAILURE_ISOLATION_SOURCE_AUDIT_2026-10-24.md); [existing internal-cushion lesson](../research/4400_HYD_CUSH_02_AGGRESSIVE_HYDRAULICS_INTERNAL_CUSHION_PRESSURE_VS_PORT_GAUGE_AUDIT_2026-10-27.md). No physical validation, test or release; G0/G1 HOLD.
