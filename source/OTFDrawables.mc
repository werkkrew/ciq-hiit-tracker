//! Classes for special drawables

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

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

    hidden var x, y, width;

    function initialize(params) {
        Drawable.initialize(params);

        regionHeight = params.get(:regionHeight);
        y = params.get(:y);
        width = params.get(:width);
    }

    function draw(dc) {
        dc.setColor(colors[0], colors[0]);
        dc.fillRectangle(4, (y - heights[0]), width, heights[0]);

        dc.setColor(colors[1], colors[1]);
        dc.fillRectangle(33, (y - heights[1]), width, heights[1]);

        dc.setColor(colors[2], colors[2]);
        dc.fillRectangle(62, (y - heights[2]), width, heights[2]);

        dc.setColor(colors[3], colors[3]);
        dc.fillRectangle(91, (y - heights[3]), width, heights[3]);

        dc.setColor(colors[4], colors[4]);
        dc.fillRectangle(120, (y - heights[4]), width, heights[4]);
    }
}