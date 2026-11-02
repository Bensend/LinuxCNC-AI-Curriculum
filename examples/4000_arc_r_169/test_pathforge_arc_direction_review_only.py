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


def test_builder_connected_line_reverses_major_arc_without_changing_sweep():
    """Full DXF -> component -> greedy arrangement -> R-post witness; NOT RUN.

    The leftmost LINE starts the component and ends at the ARC's natural end.
    The ARC must therefore be traversed backward (CW 270 degrees).
    """
    import ezdxf

    from pathforge.codegen.builder import GcodeBuilder
    from pathforge.models import ConversionParams

    doc = ezdxf.new("R2010")
    msp = doc.modelspace()
    msp.add_line((-1.0, -1.0), (0.0, -1.0))
    msp.add_arc(center=(0.0, 0.0), radius=1.0, start_angle=0, end_angle=270)

    result = GcodeBuilder(ConversionParams()).build(doc)
    arcs = [
        line.strip()
        for line in result.gcode.splitlines()
        if line.startswith(("G2 ", "G3 "))
    ]
    assert result.entity_count == 2
    assert result.component_count == 1
    assert len(arcs) == 1, arcs
    assert arcs[0].startswith("G2 X1.000 Y0.000 R-1.000 "), arcs
