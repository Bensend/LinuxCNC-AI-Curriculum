# 4400-ACC-FIRE-01 — Fire-actuated accumulator gas vent is not hydraulic stop/hold proof

**Status:** direct original manufacturer source audit, NON-GRADUATED, 2026-10-25. Separate from ACC-SAF-01 normal electrical power-loss bleed polarity. **Question:** can a thermal safety accessory intentionally release accumulator gas energy during a fire, changing a machine's stored-energy or load-holding assumptions?

## Original source, inspected directly

HYDAC, *Accumulator Accessories*, PN 02068195 / 4.21 / ACU1808-2025, printed **H2–H3**, PDF pp. 1–2, https://betterfit-us.hydac.com/wp-content/uploads/Accumulator-Accessories.pdf .

- **H2 Thermal Fuse Cap, order 00363501:** original HYDAC text says a temperature-sensitive support ring melts and a spring depresses the **version-4 gas-valve core**, venting **gas** through side bleed ports. Printed fusing range **320–340°F (160–171°C)** is an **exact accessory specification**, not a universal fire detection threshold or machine safe-stop requirement. **DOC-CONFIRMED**.
- **H3 GMP6 Thermal Fuse Plug:** separate product uses a meltable internal ring/plug to vent gas; installation differs by accumulator construction. HYDAC describes direct piston mounting versus a permanent gauging block for bladder/diaphragm applications. Its printed fusing range **320–356°F** belongs to that product, not the cap. **DOC-CONFIRMED**.
- Neither product description asserts that it isolates pump power, bleeds every **hydraulic** volume, holds a press-brake ram, inhibits LinuxCNC motion, or independently proves fire-safe human access. Those are **UNKNOWN** for any machine.

## Failure-path discrimination

A design may assume a charged accumulator is always available for emergency lowering, a controlled protective stop, or load counterbalance. A thermal fuse that intentionally vents the **gas side** under fire conditions can invalidate that assumption. **INFERENCE:** the machine safety analysis must separately consider loss of stored protective energy, unintended load movement, fire exposure and residual hydraulic pressure. The direction and magnitude of any motion are **not derivable** from this accessory brochure.

Do not reverse the safety objective and conclude the fuse should be removed: it addresses a different pressure-vessel fire hazard. The correct engineering action is to compose both functions and demonstrate that the overall machine remains acceptably safe under the relevant fault/fire conditions, with independent mechanical restraint and evacuation/access control as appropriate.

## Practical human-factor and maintenance boundary

Keep the exact accessory and accumulator type on the as-built energy map; label the gas-vent region and avoid placing normal operator access where a high-pressure discharge could occur. Qualified maintenance must distinguish the one-shot thermal device, fluid-side bleed, gas-side vessel energy, and gravity restraint. If a replacement or retrofit changes gas venting, create **CHG**, re-review fire response and stored-energy-dependent safety functions, and preserve the no-people-exposed restriction until physical validation.

## Provenance and status

**DOC-CONFIRMED:** original HYDAC H2–H3 cap and GMP6 function, installation differences and *product-specific* thermal ranges. **INFERENCE:** protective-energy loss and load-holding common-cause implications. **SOURCE-CONFIRMED new LinuxCNC:** none; **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none. **UNKNOWN:** any installed OpenPressBrake accumulator or fuse, machine fire strategy, pressure/gas volumes, actual load motion, safety integrity, physical validation and independent evaluation. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD**. No physical fire test, energized experiment, simulation or GitHub-hosted/local compute.
