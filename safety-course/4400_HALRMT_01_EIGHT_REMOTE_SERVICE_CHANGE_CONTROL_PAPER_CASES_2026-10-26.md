# HALRMT-01 — Eight remote-service safety-boundary decisions

**PAPER ONLY / UNSCORED / NON-GRADUATED.** Based on [pinned optional HAL remote source audit](../research/4400_LINUXCNC_HALRMT_REMOTE_TOPOLOGY_CHANGE_AUTHORITY_AND_PHYSICAL_SAFETY_BOUNDARY_2026-10-26.md). No network access, credentials, scanning, energized tests or bypass procedures are authorized.

1. A builder assumes a remote HAL server is running because LinuxCNC source contains `halrmt`. What evidence is missing?
2. A remote client receives success after changing a writerless ordinary permissive. Does that certify a guard is closed or ram held?
3. A remote configuration session succeeds after HELLO but before ENABLE for one source-listed setter. How do you determine the actual source access tier rather than assuming all SET commands are equivalent?
4. A service operator confuses password protection with a safety-rated interlock. Separate configuration security from protective energy removal.
5. The local HMI is READY but the HAL graph changed during remote maintenance. Design a short, safe and practical local restoration/rearm workflow.
6. A remote maintenance tool is always left enabled for convenience. Suggest lower-friction diagnostics and access control without making safeguard defeat routine.
7. A qualified engineer requests a network check of a live press brake. What must be reviewed and authorized before any service inspection, and what physical tests remain prohibited?
8. A robot cell recovers connectivity and a remote client restores ordinary enables. What independent occupancy/guard/final-element and fresh-start evidence is required?

Each answer should cite the **pinned** source/manual, identify UNKNOWN selected-machine facts, distinguish diagnostics from personnel-safety authority, and offer a human-friendly design. These prompts are not hidden competency evidence. **G0/G1 HOLD; evaluator NOT RUN.**
