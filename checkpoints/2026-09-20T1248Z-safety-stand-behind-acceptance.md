# Safety checkpoint — stand-behind acceptance evidence

Date: 2026-09-20T12:48Z

## Completed

Added physical protective-field commissioning study and SICK sBot Speed integrated stand-behind acceptance study. The previously inferred scanner stand-behind challenge now has direct manufacturer acceptance evidence: Automated mode, PF1/PF2 interruption, stand-behind/field approval challenge, actual robot stop, fields-free condition, reset requirement, plus physical field overlap/dimension verification.

## Evidence status

DOC-CONFIRMED for the SICK/Rockwell manufacturer procedures. The combined stale-command/fresh-ordinary-start challenge remains INFERENCE/UNKNOWN as one acceptance script.

## Information-gain decision

Generic scanner/restart-interlock searching is now branch-locally information-gain limited. Do not repeat it.

## Next work

Coordinate against the newest Lane-B guard-lock escape-release checkpoint before entering that branch. Prefer a genuinely new complete guard-lock retained-person recovery acceptance sequence; if unavailable or duplicative, rotate to another physical safety-function witness. Cross-cutting high-value gap: a manufacturer acceptance procedure deliberately preasserting/holding an ordinary start or motion request across safety reset/requalification and proving that stale authority cannot restart the machine without a fresh start action.

## Compute

No compute used. No GitHub-hosted runner used.
