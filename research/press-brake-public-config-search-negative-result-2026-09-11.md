# Press-brake public LinuxCNC configuration search — 2026-09-11

## Purpose

Dependency-safe 4600 preparation while F02 remains blocked. The current checkpoint requested at least one downloadable public press-brake HAL/COMP/config set suitable for mapping against the layered ownership contract.

## Search and verification

A current web/GitHub search surfaced `hardwork-machines/Linuxcnc-Press-Brake`, whose README describes an open-source press-brake effort and says the next step is to design the controller in LinuxCNC.

The repository tree was then inspected recursively rather than assuming the project name implied a usable control configuration. At tree `40017cee5f4fd923d84c8a0b2f3daf41fd0e55c4`, the repository contains only:

- `README.md`
- `CAD/fusion360.f3d`
- `renders/.gitignore`
- `renders/press brake v4.png`

There is no HAL, INI, COMP, Python controller, ladder, or other LinuxCNC runtime configuration in that tree.

## Result

**Negative result, useful for source quality control:** this project is relevant community context but is not a downloadable implementation artifact and must not be cited as evidence for press-brake control ownership, valve sequencing, Y1/Y2 synchronization, or safety behavior.

This narrows the continuing search: require actual machine-readable HAL/INI/COMP/config artifacts before promoting a community project from contextual evidence to implementation evidence.

## Architectural implication

The layered ownership contract remains supported by LinuxCNC source analysis and community architecture observations, but no newly found public press-brake repository in this search provides code-level corroboration. Do not fill that evidence gap by extrapolating from CAD-only projects or generic single-axis proportional-valve examples.

## Next research checkpoint

Continue searching public forum attachments/repositories for an actual downloadable press-brake HAL/INI/COMP/config. Accept it as implementation evidence only after recursively inspecting the files and identifying explicit signal ownership. Until then, keep machine-specific hydraulic decoding and functional safety outside generic conclusions.
