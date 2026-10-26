# 4400-SS1E-01 — Eight braking-authority / timer cases

**Open-book PAPER scenarios / UNSCORED / NON-GRADUATED.** Read [original Siemens S210 SS1E audit](../research/4400_SIEMENS_S210_SS1_EXTERNAL_STOP_NO_RAMP_MONITORING_AND_TIMER_SOURCE_AUDIT_2026-10-26.md). Answer each with normal deceleration owner, independent safety stop owner, physical load state, unresolved evidence, and HOLD/qualified action. Never prescribe timing values or execute these faults on a personnel-exposed machine.

1. **External stop, LinuxCNC freezes:** safety SS1E request occurs but the ordinary motion setpoint stays unchanged. Which component is actually supposed to brake? What occurs at the safety delay?
2. **SS1-t OFF3 commanded:** a drive ramps down slower than expected. Does time-controlled SS1-t inherently monitor that ramp? Is STO at delay expiry proof of standstill?
3. **Extended SS1 external stop:** an integrator selects SBR in another configuration screen and assumes external-stop mode will monitor SBR. What does the OEM actually say?
4. **Short SS1 pulse:** external-stop SS1 is selected and deselected before its configured extended delay. Does this necessarily cancel the timer? What delayed STO/SBC event does the manual describe?
5. **Vertical mill axis:** the motor coasts after timed STO and the mechanical holding brake is worn. Why is this not solved by an HMI “SS1 complete” lamp?
6. **Coupled-axis motion:** two drives share a material web. Why might one independent OFF3 ramp damage the web, and why does selecting external-stop shift responsibility rather than automatically solve safety?
7. **Press brake Y1/Y2:** a developer proposes LinuxCNC synchronized deceleration as the sole protective stop while the hydraulic final element is unknown. What independent stop/hold and hydraulic energy evidence is missing?
8. **Maintenance/return:** after a controller fault, an operator repeatedly resets SS1E while a worker is servicing the machine. Distinguish qualified service LOTO, timed protective stop, emergency rescue and fresh motion authority.

**Review boundary:** no answer may equate timer expiry, fault bit, commanded OFF3 or STO with actual load-side standstill/hold or service isolation. This exercise does not establish selected-machine safe-stop performance. G0/G1 HOLD; physical tests/evaluator NOT RUN; 0 compute.
