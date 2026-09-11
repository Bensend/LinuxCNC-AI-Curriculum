# PB-PREP-001 — pinned PID saturation-witness source check

LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Source: `src/hal/components/pid.c`
Evidence: **SOURCE-CONFIRMED**

This check validates an important PB-PREP-001 Gate-H assumption before the P2–P7 runner is implemented.

At the pinned revision, `hal_pid_t` exports `output`, `saturated`, `saturated-s`, and `saturated-count`. `calc_pid()` writes the final stock PID output and then derives the exported `saturated` state from the PID's own `limit_state`. The pin is therefore a witness of saturation inside the stock PID calculation/its configured output limit; it is not aware of arithmetic performed later by another HAL component.

That distinction is exactly why architecture B requires a separate downstream final-command saturation witness. B computes a post-PID effort correction after `pid.*.do-pid-calcs`; a PID output can remain inside the stock PID limit while `pid_out +/- corr_applied` exceeds the common final `U_MAX`. The fixture's `prelimit*` plus `final*_sat` must therefore be retained atomically. Treating `pid.*.saturated` as equivalent to final actuator-command saturation would erase the intended architecture-B discriminator.

The source also documents/implements `maxoutput` as the PID output limiter and exports `saturated` as a HAL output pin. With PB-PREP-001's stock PID `maxoutput=2.0`, the valid discriminator is not merely `pid.saturated != final_sat`; the retained row should demonstrate the causal arithmetic: stock PID output within its own final bound, downstream corrected prelimit beyond 2.0, and fixture final saturation asserted/clipped.

## Implementation consequence

The P2–P7 sampler schema must net both `pb-pid1.saturated` / `pb-pid2.saturated` and the fixture's independent final saturation bits. The analyzer must preserve at least one exact B/P6 row exhibiting downstream-only saturation or classify the frozen experiment INCONCLUSIVE as already required. This is a source-grounded instrumentation requirement, not a post-hoc threshold change.

## Safety/evidence boundary

Neither stock PID saturation nor fixture final saturation proves physical valve saturation, hydraulic authority, safe force, or safe stopping behavior. They are software-command-domain witnesses only.
