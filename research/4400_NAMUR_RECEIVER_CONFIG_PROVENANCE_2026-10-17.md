# 4400 — Receiver configuration provenance gate (2026-10-17)

Status: DOC-CONFIRMED product features; selected machine UNKNOWN; no physical tests.

Turck IMX12-DI01-2S-2T-0/24VDC (7580020) supports two-channel or signal-doubling mode, NO/NC output mode and selectable line-fault monitoring: https://www.turck.us/en/product/7580020 . Turck IMX12-DI03-1S-2R-S/24VDC (7580008) offers alarm-output or signal-doubling selection: https://www.turck.us/en/product/7580008 . Pepperl+Fuchs KFU8-SR-Ex2.W publishes product-specific NAMUR line-break/short thresholds and reversible output mode: https://www.pepperl-fuchs.com/fi-fi/products-gp25581/103253 . Bosch Rexroth RE 21015 (2019-07) distinguishes 24 V PNP QM/Q6 and 8.2 V NAMUR Q8 sensors.

The selected safety evidence must capture sensor origin, exact receiver identity, mode/polarity, line-fault enable, alarm mapping, output destinations, common dependencies and physical safe-state witness. Two outputs in doubling mode do not prove two independent sensors. Feature availability does not prove the feature is enabled. A receiver indication does not prove physical ram safe state.

Acceptance remains blocked until exact installed component/configuration and independent physical evidence are obtained. Do not infer a hydraulic truth table, stopping limits, safety integrity, or fault-output truth table. Ordinary LinuxCNC/FPGA monitoring is not personnel-safety authority.
