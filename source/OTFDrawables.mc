//! Classes for special drawables

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class WorkoutZoneBg extends Ui.Drawable {

    static var color;

    function initialize(params) {
        Drawable.initialize(params);

        if ( color == null ) {
            color = Gfx.COLOR_LT_GRAY;
        }
    }

    function draw(dc) {
        dc.setColor(color, color);
        dc.fillRectangle(0, 72, dc.getWidth(), 103);
    }

}

class WorkoutZoneBars extends Ui.Drawable {
    static var zone;

    function initialize(params) {
        Drawable.initialize(params);

        if ( zone == null ) {
            zone = 0;
        }
    }

    function draw(dc) {
        var color = Gfx.COLOR_TRANSPARENT;
        var points = null;

        if ( zone == 1 ) {
            color = Gfx.COLOR_LT_GRAY;
            points = [[16,174],[36,174],[34,180],[14,180]];
        } else if ( zone == 2 ) {
            color = Gfx.COLOR_BLUE;
            points = [[43,174],[63,174],[61,180],[41,180]];
        } else if ( zone == 3 ) {
            color = Gfx.COLOR_GREEN;
            points = [[70,174],[90,174],[88,180],[68,180]];
        } else if ( zone == 4 ) {
            color = Gfx.COLOR_ORANGE;
            points = [[97,174],[117,174],[115,180],[95,180]];
        } else if ( zone == 5 ) {
            color = Gfx.COLOR_DK_RED;
            points = [[124,174],[144,174],[142,180],[122,180]];
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

    function initialize(params) {
        Drawable.initialize(params);
    }

    function draw(dc) {
        dc.setColor(colors[0], colors[0]);
        dc.fillRectangle(4, (190 - heights[0]), 24, heights[0]);

        dc.setColor(colors[1], colors[1]);
        dc.fillRectangle(33, (190 - heights[1]), 24, heights[1]);

        dc.setColor(colors[2], colors[2]);
        dc.fillRectangle(62, (190 - heights[2]), 24, heights[2]);

        dc.setColor(colors[3], colors[3]);
        dc.fillRectangle(91, (190 - heights[3]), 24, heights[3]);

        dc.setColor(colors[4], colors[4]);
        dc.fillRectangle(120, (190 - heights[4]), 24, heights[4]);
    }
}