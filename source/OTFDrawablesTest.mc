//! Unit tests for the custom drawables. Run with "Monkey C: Run Tests" in VS Code.

using Toybox.Test;

(:test)
function zoneBarsScaleToLongestZone(logger) {
    // The longest zone fills the region; the others are relative to it,
    // plus 5 px so small bars stay visible. An empty zone draws no bar.
    var h = SummaryZoneBars.scaleHeights([600, 900, 1500, 1200, 0], 140);
    Test.assertEqual(h[2], 140);
    Test.assertEqual(h[0], 59);
    Test.assertEqual(h[1], 86);
    Test.assertEqual(h[3], 113);
    Test.assertEqual(h[4], 0);

    // A workout with no zone time draws no bars
    h = SummaryZoneBars.scaleHeights([0, 0, 0, 0, 0], 140);
    Test.assertEqual(h[2], 0);

    return true;
}
