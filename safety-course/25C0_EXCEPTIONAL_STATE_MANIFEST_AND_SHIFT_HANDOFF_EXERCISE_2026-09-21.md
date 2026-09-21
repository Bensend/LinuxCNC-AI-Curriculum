# 25C0 adversarial exercise — exceptional-state manifest and shift handoff

## Scenario
A high-energy automated machine has completed commissioning work. The safety application is locked and its independent safety functions show ready. The ordinary controller is in RUN. Maintenance says the I/O forces were “turned off.” The outgoing technician is leaving the site.

The controller reports I/O forces **Disabled, Installed**. A temporary mechanical test fixture has also been removed according to the technician, but there is no positive recorded inspection. The incoming operator wants to resume automatic production.

## Learner task
1. Decide whether ordinary production may be released now.
2. Separate personnel-safety readiness from ordinary production-configuration readiness.
3. Identify what evidence is still missing.
4. Propose a low-friction handoff design that makes this failure harder to create.
5. State what must remain UNKNOWN rather than being inferred.

## Expected reasoning boundary
A strong answer should recognize that disabled forces can remain installed/latent and therefore ordinary production configuration is not yet demonstrated clean. It should require positive removal/disposition rather than relying on the outgoing technician's memory. It should also treat the unverified physical test fixture as a separate exceptional-state class: controller force status cannot prove physical temporary aids are absent.

The safety application being ready does not authorize collapsing these concerns into the safety system. Conversely, a production-readiness inhibit based on ordinary controller force state is not automatically a safety-rated function.

## Preferred architecture pattern
Use an exceptional-state manifest at handoff. Machine-readable exception classes should be automatically summarized where practical; non-machine-readable temporary physical states require explicit inspection/signoff. Normal automatic production should be difficult or impossible to select while known exceptional states remain unresolved, but personnel safety must remain independently enforced.

## Adversarial traps
- “Disabled” is not synonymous with “removed.”
- RUN mode is not proof of production cleanliness.
- A valid safety signature does not prove ordinary-control force state.
- A force-clean controller does not prove temporary jumpers, fixtures or bypass hardware were removed.
- A production-readiness interlock is not automatically a safety function.
- Reboot/power-cycle must not be assumed to sanitize exceptional state without platform-specific evidence.

## Transfer variant
The controller reports no I/O forces, but a robot subsystem still has simulated I/O active and a hydraulic service valve remains in a manually overridden test condition. Explain why a single controller's force-clean bit cannot be promoted into a global `MACHINE_CLEAN=true` assertion without dependency-specific evidence.
