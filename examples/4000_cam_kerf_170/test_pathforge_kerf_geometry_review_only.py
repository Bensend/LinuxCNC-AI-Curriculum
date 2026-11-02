"""Review-only PathForge kerf geometry regression; NOT RUN.

Requires pinned PathForge f3574ec, ezdxf and pytest in a disconnected
environment. These tests intentionally express geometric/immutability
invariants NOT asserted by the existing upstream scaling tests.
"""
import ezdxf
import pytest

from pathforge.codegen.builder import GcodeBuilder
from pathforge.models import ConversionParams


def _square_doc():
    doc = ezdxf.new("R2010")
    msp = doc.modelspace()
    for start, end in [
        ((100, 100), (110, 100)),
        ((110, 100), (110, 110)),
        ((110, 110), (100, 110)),
        ((100, 110), (100, 100)),
    ]:
        msp.add_line(start, end)
    return doc


def _xy_bounds(doc):
    points = [
        point
        for entity in doc.modelspace()
        for point in (entity.dxf.start, entity.dxf.end)
    ]
    return (
        min(p.x for p in points),
        max(p.x for p in points),
        min(p.y for p in points),
        max(p.y for p in points),
    )


def test_translated_square_center_is_not_moved_by_kerf():
    doc = _square_doc()
    GcodeBuilder(ConversionParams(kerf=1.0)).build(doc)
    xlo, xhi, ylo, yhi = _xy_bounds(doc)
    # Any symmetric constant-distance offset preserves the part centroid.
    assert (xlo + xhi) / 2 == pytest.approx(105.0)
    assert (ylo + yhi) / 2 == pytest.approx(105.0)


def test_circle_only_component_does_not_silently_skip_kerf():
    doc = ezdxf.new("R2010")
    circle = doc.modelspace().add_circle(center=(100, 100), radius=5)
    GcodeBuilder(ConversionParams(kerf=1.0)).build(doc)
    assert circle.dxf.radius != pytest.approx(5.0)


def test_repeated_build_does_not_mutate_source_dxf():
    doc = _square_doc()
    original = _xy_bounds(doc)
    builder = GcodeBuilder(ConversionParams(kerf=1.0))
    builder.build(doc)
    after_first = _xy_bounds(doc)
    builder.build(doc)
    after_second = _xy_bounds(doc)
    assert after_first == pytest.approx(original)
    assert after_second == pytest.approx(original)
