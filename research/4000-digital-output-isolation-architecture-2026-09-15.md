# 4000 digital-output isolation architecture — 2026-09-15

Status: WORKING ARCHITECTURE — enough to freeze the logical topology; isolated field-side supply part remains open.

## Problem

The selected TPS4H160-Q1 high-side drivers are field-ground referenced. We need galvanic separation from FPGA logic while preserving deterministic OFF behavior on reset/watchdog and returning electrical fault diagnostics.

## Working architecture

Use a **group-isolated output domain**:

`FPGA 3.3 V -> watchdog/output-authority AND gate -> quad digital isolators (default LOW field-side outputs) -> field-side 3.3/5 V logic -> TPS4H160-Q1 IN pins -> 24-V sourcing outputs`

Return each smart-switch package's global fault/diagnostic across the isolation barrier into FPGA diagnostics.

This avoids one optocoupler per semantic path with CTR/aging concerns while keeping the field-driver ground separate from FPGA ground.

## Isolator family

TI ISO674x/ISO774x families are suitable working references because they support 2.25-5.5-V logic domains and provide explicit **F-suffix default-LOW** variants. Manufacturer documentation states that when input power/signal is lost, the F variant defaults its isolated output LOW.

Reference:
- https://www.ti.com/product/ISO6741
- https://www.ti.com/product/ISO7741

For command-only groups, prefer an all-forward four-channel F-suffix member (`ISO6740F` class) rather than wasting reverse channels. Exact package/suffix must be checked during schematic capture.

## Critical invariant

Default-LOW isolator behavior is a second containment layer, not a replacement for the FPGA watchdog. The FPGA shall already compute:

`effective_output = requested_output AND global_output_authority`

before the isolation barrier.

Thus:
- host stale but FPGA alive -> watchdog removes `global_output_authority` -> OFF;
- FPGA/reset-side power loss -> isolator F default -> OFF;
- field-side logic supply loss -> smart-switch input/output behavior must be verified from datasheet, but normal output cannot be claimed active;
- communications return -> explicit system rearm required before `global_output_authority` returns.

## Field-side logic power

A small isolated 3.3/5-V field-side logic supply is required for the output isolator secondary and diagnostic circuitry. This is **not** the 24-V load power itself. Select the isolated DC/DC only after calculating isolator + driver-logic current and creepage/EMC requirements.

Do not power the FPGA side from field power or defeat the isolation barrier with a shared signal ground.

## Diagnostics

At minimum expose one diagnostic/fault result per TPS4H160 package (four groups for 16 outputs). If the final A-version wiring permits richer per-channel discrimination without excessive analog overhead, preserve it; otherwise a group fault plus commanded-output state is still better than no electrical witness.

Diagnostic freshness is separate from driver state. A stale fault bit after Ethernet loss must be marked stale by the same FPGA/transport generation scheme used elsewhere.

## Why this is preferable to a field-side I/O MCU

A field-side MCU/serial expander could reduce isolation-channel count, but it creates another command-age/watchdog/firmware/rearm subsystem. The present 16-output bank does not justify that complexity. Direct FPGA-to-isolator-to-smart-switch preserves simpler timing and ownership.

The 24 ISO1212 inputs independently provide their own isolation and do not require a shared field-side input MCU or input power domain.

## Remaining schematic tasks

1. Select exact `ISO6740F`/equivalent all-forward default-low isolator and reverse diagnostic isolator arrangement.
2. Select isolated field-side 3.3/5-V DC/DC with adequate isolation/EMC/current margin.
3. Calculate TPS4H160 current limit and simultaneous-channel thermal envelope.
4. Verify field-side supply-loss behavior and diagnostic truth table.
5. Define connector fuse/group power segmentation and inductive-load constraints.

No simulation is justified yet; these are datasheet/calculation tasks followed by bench fault injection.
