//! Classes for special drawables

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Math;

class WorkoutZoneBg extends Ui.Drawable {

    static var color;

    hidden var x, y, width, height;

    function initialize(params) {
        Drawable.initialize(params);

        if ( color == null ) {
            color = params.get(:color);
        }

        x = params.get(:x);
        y = params.get(:y);
        width = params.get(:width);
        height = params.get(:height);
    }

    function draw(dc) {
        dc.setColor(color, color);
        dc.fillRectangle(x, y, width, height);
    }

}

class WorkoutZoneBars extends Ui.Drawable {

    static var zone;

    hidden var points_1, points_2, points_3, points_4, points_5;

    function initialize(params) {
        Drawable.initialize(params);

        if ( zone == null ) {
            zone = 0;
        }

        points_1 = params.get(:points_1);
        points_2 = params.get(:points_2);
        points_3 = params.get(:points_3);
        points_4 = params.get(:points_4);
        points_5 = params.get(:points_5);
    }

    function draw(dc) {
        var color = Gfx.COLOR_TRANSPARENT;
        var points = null;

        if ( zone == 1 ) {
            color = Gfx.COLOR_LT_GRAY;
            points = points_1;
        } else if ( zone == 2 ) {
            color = Gfx.COLOR_BLUE;
            points = points_2;
        } else if ( zone == 3 ) {
            color = Gfx.COLOR_GREEN;
            points = points_3;
        } else if ( zone == 4 ) {
            color = Gfx.COLOR_ORANGE;
            points = points_4;
        } else if ( zone == 5 ) {
            color = Gfx.COLOR_DK_RED;
            points = points_5;
        } else {
            color = Gfx.COLOR_TRANSPARENT;
            points = [[0,0],[0,0],[0,0],[0,0]];
        }

        dc.setColor(color, color);
        dc.fillPolygon(points);
    }

}

class SummaryZoneBars extends Ui.Drawable {
    static var heights = new [5];
    static var colors = new [5];

    var regionHeight;

    hidden var x1, x2, x3, x4, x5, y, width;

    function initialize(params) {
        Drawable.initialize(params);

        regionHeight = params.get(:regionHeight);
        x1 = params.get(:x1);
        x2 = params.get(:x2);
        x3 = params.get(:x3);
        x4 = params.get(:x4);
        x5 = params.get(:x5);
        y = params.get(:y);
        width = params.get(:width);
    }

    //! Bar heights for the given zone times. The longest zone fills the
    //! region and the others are drawn relative to it. A bar with any time
    //! gets 5 px extra so very small bars stay visible.
    static function scaleHeights(times, regionHeight) {
        var result = new [times.size()];
        var maxTime = 0;

        for (var i = 0; i < times.size(); i++) {
            if (times[i] > maxTime) {
                maxTime = times[i];
            }
        }

        for (var i = 0; i < times.size(); i++) {
            result[i] = 0;
            if (maxTime > 0) {
                result[i] = Math.round((regionHeight - 5.0) * times[i] / maxTime).toNumber();
                if (result[i] > 0) {
                    result[i] += 5;
                }
            }
        }
        return result;
    }

    function draw(dc) {
        dc.setColor(colors[0], colors[0]);
        dc.fillRectangle(x1, (y - heights[0]), width, heights[0]);

        dc.setColor(colors[1], colors[1]);
        dc.fillRectangle(x2, (y - heights[1]), width, heights[1]);

        dc.setColor(colors[2], colors[2]);
        dc.fillRectangle(x3, (y - heights[2]), width, heights[2]);

        dc.setColor(colors[3], colors[3]);
        dc.fillRectangle(x4, (y - heights[3]), width, heights[3]);

        dc.setColor(colors[4], colors[4]);
        dc.fillRectangle(x5, (y - heights[4]), width, heights[4]);
    }
}