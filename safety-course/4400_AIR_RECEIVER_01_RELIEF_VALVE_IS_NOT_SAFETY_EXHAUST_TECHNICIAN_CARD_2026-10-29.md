# 4400 AIR-RECEIVER-01 — Pressure relief is not safety exhaust
**2026-10-29 | technician field card | no live vessel/valve testing**

A shop air tank can be a pressure-vessel hazard **even when every downstream CNC valve is OFF**. Conversely, a tank's relief valve can prevent vessel overpressure without venting a clamped cylinder or making maintenance safe.

**Keep three jobs separate:** receiver overpressure protection (proper spring-loaded relief and vessel rating); pneumatic safety exhaust (selected downstream hazardous volumes); and qualified energy isolation/verification (receiver, check valves, branches, trapped zones, mechanically held loads). LinuxCNC/HMI “AIR OK” is only a normal diagnostic.

**Practical field review:** Identify exact tank/nameplate and jurisdiction. Keep relief connected as the applicable rule requires, with no casual shutoff valve between vessel and relief. Make gauge, drain and inspection reachable without guard defeat. Condensate/corrosion is a structural hazard, not just a nuisance; never plug a leaking relief or disable a drain. For an exact SMC VBAT tank, inspect the manufacturer's variant and accessories; the SMC USA VBAT-X105 ASME-stamped option explicitly includes a relief valve, but other configurations differ.

**Avoid two rule traps:** OSHA 1910.169 requires periodic **relief-valve testing**, but a 2008 OSHA interpretation says the federal section does **not** require periodic **receiver pressure retesting**. Its general prohibition on a shutoff between receiver and relief has a narrowly discussed 1981 authority-approved exception—not an ordinary builder workaround. A 1978 OSHA directive also recognizes a qualified side-drain construction alternative; draining remains essential. Local/state and OEM requirements may be stricter.

**No DIY demonstration:** Do not lift a relief valve under pressure, hydrotest a receiver, defeat a pressure switch, or deliberately overpressure a tank for this curriculum. Obtain qualified documentary review, approved maintenance and independent physical proof where applicable. No personnel-exposed operation if the required basic protection is unresolved.

[Original OSHA/SMC source audit](../research/4400_AIR_RECEIVER_01_OSHA_1910_169_SMC_VBAT_RELIEF_DRAIN_AND_SAFE_EXHAUST_BOUNDARY_AUDIT_2026-10-29.md). DOC-CONFIRMED named regulation/OEM; installed machine UNKNOWN; TEST-CONFIRMED none. **G0/G1 HOLD; evaluator OPEN.**
