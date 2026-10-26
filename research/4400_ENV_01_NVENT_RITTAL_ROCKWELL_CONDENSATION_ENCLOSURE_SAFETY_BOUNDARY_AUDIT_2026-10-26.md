# 4400 ENV-01 — control-cabinet condensation, thermal cycling and independent safety integrity

**Study date:** 2026-10-26. **Status:** original manufacturer-source study; no machine-specific environmental diagnosis or test. **Distinct novelty:** prior safety-course index contained no condensation/washdown/cabinet-dew-point lesson; existing power, electrical isolation, sensor and restart modules remain prerequisites.

## Engineering question

Can a cabinet marketed as high ingress-protection still accumulate moisture, and how should the machine remain safe when a safety relay or ordinary controller's environment is no longer qualified? **Ingress rating, dry-looking exterior, green controller diagnostics and a running enclosure heater do not establish that the safety-related circuit remains valid.**

## Primary manufacturer evidence

1. **nVent HOFFMAN**, *Technical information* (manufacturer original PDF, 25 PDF pages), https://www.nvent.com/sites/default/files/acquiadam/assets/Technical_Information_nVent_HOFFMAN.pdf . Directly inspected PDF **p. 9 (printed pp. 16–17)**, sections **Outdoor installation**, **Abrupt temperature changes**, **Condensation**, and **p. 10** special service conditions. Source itself says technical information subject to change; **not** a machine-specific design standard.
2. **Rittal**, official *Enclosure heater with fan* product-family page, https://www.rittal.com/com-en/products/PG20231215KLI101/PG20231245KLI1006/PRO0308 . Direct manufacturer page states enclosure heaters regulate relative humidity and keep internal temperature above dew point to reduce condensation, corrosion and electrical shorts. Product-family description, not a selected heater performance test.
3. **Rockwell Automation**, official exact **440R-N23114 Guardmaster MSR126.1T Safety Relay** product specification, https://www.rockwellautomation.com/en-us/products/details.440R-N23114.html . Directly inspected **Construction / Compliance & Environment**: **35-mm DIN rail in an enclosure to minimum IP54**, relay housing **IP40**, terminal protection **IP20**, **pollution degree 2**, listed operating **relative humidity 90%**. These are exact-product catalog claims, **not** evidence of an installed OpenPressBrake safety relay, nor permission for water droplets or conductive contamination on its terminals.
4. **nVent HOFFMAN** official heater product page, https://www.nvent.com/en-de/hoffman/products/encehg045 . Manufacturer describes a self-regulating PTC enclosure heater intended to prevent condensation when ambient temperature drops sharply. Product-specific feature only.

## DOC-CONFIRMED mechanisms

- **Cooling-induced pressure difference:** nVent p. 9 explicitly warns that rapid enclosure internal cooling can create sub-ambient internal pressure in a high-IP enclosure and **draw moisture around gaskets**. High IP alone does not guarantee no moisture ingress over thermal cycles.
- **Internal condensation without visible leak:** nVent p. 9 states that differences between inside and outside surface temperatures can condense moisture on internal components and cause corrosion/defects.
- **Protection versus corrosion are different:** nVent p. 9 distinguishes IP ingress protection from corrosion resistance (separate salt-spray/humidity evidence). Do not treat a cabinet's IP label as a corrosion-resistance certificate.
- **Mitigation is application-dependent:** nVent discusses ventilation and thermal management; Rittal and nVent heater pages describe dew-point management. **An unqualified hole or fan added to a rated cabinet may undermine ingress protection** (INFERENCE); a selected breather, drain, vent, heater, thermostat, gasket and gland must be evaluated as an assembly.
- **Safety component is not a cabinet:** Rockwell's exact MSR126.1T housing/terminal ratings are lower than the specified minimum mounting enclosure rating. **IP54 for that exact relay's installation is not a universal cabinet requirement for all devices**.
- **No transfer of humidity numbers:** Rockwell's catalog **90% operating RH** does not specify the humidity/condensation profile for OpenPressBrake, and this study does not establish a permissible liquid-water exposure, derating curve or failure probability.

## Failure-path reasoning — explicitly INFERENCE until exact circuit analysis

| Initiator | Possible common-cause consequence | What would discriminate it |
|---|---|---|
| Machine cools rapidly after warm production shift | Condensation or gasket moisture drawn in; possible correlated faults in safety and normal I/O | Environmental/maintenance history, selected enclosure/gland/vent specification, qualified inspection without energizing |
| Coolant spray or washdown enters a compromised cable gland | Terminal corrosion/contamination; may affect safety inputs and normal monitoring together | Exact gland/gasket rating and routing, observed residue, terminal/component manufacturer's instructions |
| Cabinet heater fails or thermostat sticks | Moisture risk rises; heater can itself be an electrical/thermal hazard if improperly installed | Selected heater/thermostat protection and wiring, maintenance records, thermal inspection plan |
| Technician props door open to dry cabinet | IP protection defeated and safety wiring exposed; guard-bypass/LOTO risk | Ergonomic redesign: accessible filter/vent/drain/service points, qualified energy isolation and resealing |
| HMI reports “all inputs normal” | Ordinary controller may not see contamination, degraded insulation or common-mode wiring effects | Independent safety-system fault detection and qualified physical stop/hold proof |

**No assertion that condensation always energizes or always de-energizes a safety output.** Failure polarity, leakage, diagnostic coverage and required protective reaction depend on the selected circuit, components and contamination; record **UNKNOWN** until engineering evidence.

## Architecture and human-factors lesson

- **Normal control:** LinuxCNC/HAL/FPGA may log cabinet temperature/humidity, report alarm and inhibit normal commands; not personnel-safety authority.
- **Monitoring:** climate sensors and heater status are maintenance indicators unless a separately justified safety-related design proves otherwise. Their readings are not proof of dry safety terminals or physical machine state.
- **Safety-related control:** selected independent safety device must be qualified for actual installation environment and faults. Loss of its valid protective function is a machine **HOLD**, not a prompt to bypass the sensor.
- **Physical mechanisms:** qualified drive torque removal, mechanical/gravity load retention, hydraulic isolation and guards remain necessary independent of cabinet dryness.
- **Low-cost safer-by-default choices:** correct enclosure/glands and drip paths, accessible protected heater/vent with rated components, labeled replacement seals, captive covers, moisture inspection during service, fault labels explaining *why* motion is inhibited. Avoid putting the heater, drain or humidity sensor where access requires defeating a guard.
- **Change control:** new gland hole, filter fan, washdown procedure, enclosure heater, cable replacement, relocated cabinet, coolant mist, gasket or door modification invalidates relevant `DEP/ARC/VAL` evidence until re-reviewed. IP label is not unchanged assembly proof.

## Machine transfer and safety gates

Plasma/laser coolant or waterjet spray, woodworking conductive dust/humidity, outdoor conveyors, farm retrofits, mills/lathes coolant, and press-brake hydraulic mist create **different** exposure profiles. Do not infer a selected OpenPressBrake cabinet is wet or has a particular relay. For OpenPressBrake, independent Y1/Y2 stop/hold, gravity restraint, hydraulic isolation, guarding and deliberate restart remain **UNKNOWN**, **G0/G1 HOLD**.

**Evidence:** DOC-CONFIRMED OEM statements above; INFERENCE failure chains/design patterns; SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none relied on; UNKNOWN selected cabinet/component/environment, fault polarity, PL/SIL, physical stop/hold. **No simulation, humidity injection, electrical/physical test or Actions compute**. Do not open or energize suspect wet cabinets; qualified personnel must isolate, verify and remediate before any return to service.
