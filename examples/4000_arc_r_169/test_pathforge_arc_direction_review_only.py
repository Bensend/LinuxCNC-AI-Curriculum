"""Review-only regression for pinned PathForge f3574ec; NOT RUN in curriculum.

Run only in a disconnected Python environment with the pinned PathForge package
and pytest installed. This is a source-level post regression, not machine proof.
"""
from types import SimpleNamespace

import pytest

from pathforge.codegen.entity_writers import write_arc_entity


@pytest.mark.parametrize(
    "start_angle,end_angle,arranged_start,arranged_end,expected_g,expected_r",
    [
        (0, 90, (1.0, 0.0), (0.0, 1.0), "G3", "R1.000"),
        (0, 90, (0.0, 1.0), (1.0, 0.0), "G2", "R1.000"),
        (0, 270, (1.0, 0.0), (0.0, -1.0), "G3", "R-1.000"),
        # Critical missing upstream case: reverse a CCW major arc.
        (0, 270, (0.0, -1.0), (1.0, 0.0), "G2", "R-1.000"),
    ],
)
def test_arc_direction_preserves_reversed_major_sweep(
    start_angle, end_angle, arranged_start, arranged_end, expected_g, expected_r
):
    entity = SimpleNamespace(
        dxf=SimpleNamespace(
            center=(0.0, 0.0),
            radius=1.0,
            start_angle=start_angle,
            end_angle=end_angle,
        ),
        start_point=(1.0, 0.0),
        end_point=(0.0, 1.0 if end_angle == 90 else -1.0),
    )
    output = "".join(
        write_arc_entity(
            entity=entity,
            arranged_start=arranged_start,
            arranged_end=arranged_end,
            precision=3,
            feed_rate=100.0,
            dwell_time=0.5,
            is_first=False,
            entry_point=None,
        )
    )
    assert output.startswith(expected_g + " "), output
    assert expected_r in output, output
