# HAL-SNAPSHOT-01 — Eight change-control and restoration cases

**PAPER ONLY / UNSCORED / NON-GRADUATED.** [Pinned source audit](../research/4400_LINUXCNC_HAL_SAVE_ALL_VS_ALLU_UNCONNECTED_INPUT_RESTORATION_AUDIT_2026-10-26.md). No live machine tests or hidden answer.

1. An unconnected HAL input reads TRUE. Which `save` mode includes a command to restore its dummy value, and which omits it?
2. A saved `all` file has no explicit `setp` for a disconnected input. Can the engineer claim its value after reconstruction without reading the component's startup behavior?
3. A saved `allu` file restores an input TRUE. Does that prove the original physical sensor is present, healthy or safe?
4. A technician compares two HAL file hashes and calls the machine safe. What independent safety-controller, final-element and physical load evidence is still needed?
5. A lathe's spindle-enable process net is recreated correctly, but drive parameters were changed. Explain the difference between HAL snapshot fidelity and safe stop/standstill validation.
6. A press brake returns from service with an unchanged HAL graph but unknown Y1/Y2 hydraulic holding. Can the G0/G1 physical release gate pass?
7. A small shop complains that approved restoration takes too long. Design a read-only report of unconnected pins, writers, hashes and required local rearm that is faster than bridging interlocks.
8. A remote technician restores an ordinary HAL file while the local operator has not inspected guards. Who may authorize fresh hazardous motion, and what physical prerequisites remain?

Answers must distinguish **SOURCE-CONFIRMED** file serialization from **UNKNOWN** machine behavior and explicitly preserve independent safety authority. Public practice only; independent evaluator still NOT RUN; G0/G1 HOLD.
