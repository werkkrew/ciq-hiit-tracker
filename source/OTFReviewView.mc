//! Default starting view

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application;
using Toybox.Lang;
using Toybox.System;
using Toybox.Timer;

class OTFReviewView extends Ui.View {

    hidden var mModel;
    hidden var mController;
    hidden var mTimer;

    hidden var elapsedTime = null;
    hidden var calories = null;
    hidden var averageHR = null;
    hidden var averageHRPct = null;
    hidden var peakHR = null;
    hidden var peakHRPct = null;
    hidden var splatPoints = null;
    hidden var zoneTimes = null;
    hidden var zoneColors = null;

    hidden var uiZoneBars = null;
    hidden var uiZone1Text = null;
    hidden var uiZone2Text = null;
    hidden var uiZone3Text = null;
    hidden var uiZone4Text = null;
    hidden var uiZone5Text = null;

    hidden var uiTime = null;
    hidden var uiCalories = null;
    hidden var uiSplat = null;
    hidden var uiAvgHR = null;
    hidden var uiMaxHR = null;

    function initialize() {
        View.initialize();
        // Get the model and controller from the Application
        mModel = Application.getApp().model;
        mController = Application.getApp().controller;
    }

    //! Load your resources here
    function onLayout(dc) {
        // Load the layout from the resource file
        setLayout(Rez.Layouts.ReviewSummaryScreen(dc));

        uiZoneBars = View.findDrawableById("SummaryZoneBars");
        uiZone1Text = View.findDrawableById("Summary_tz1_text");
        uiZone2Text = View.findDrawableById("Summary_tz2_text");
        uiZone3Text = View.findDrawableById("Summary_tz3_text");
        uiZone4Text = View.findDrawableById("Summary_tz4_text");
        uiZone5Text = View.findDrawableById("Summary_tz5_text");

        uiTime = View.findDrawableById("Summary_time_val");
        uiCalories = View.findDrawableById("Summary_calories_val");
        uiSplat = View.findDrawableById("Summary_splat_val");
        uiAvgHR = View.findDrawableById("Summary_avgHR_val");
        uiMaxHR = View.findDrawableById("Summary_maxHR_val");

        elapsedTime = mModel.getTimeElapsed();
        calories = mModel.calories;
        averageHR = mModel.averageHR;
        averageHRPct = mModel.averageHRPct;
        peakHR = mModel.peakHR;
        peakHRPct = mModel.peakHRPct;
        splatPoints = mModel.splatPoints;
        zoneTimes = mModel.zoneTimes;
        zoneColors = [ Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLUE, Gfx.COLOR_GREEN, Gfx.COLOR_ORANGE, Gfx. COLOR_DK_RED ];
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
        Ui.requestUpdate();
    }

    //! Update the view
    function onUpdate(dc) {
        var timeString = Lang.format("$1$:$2$", [elapsedTime / 60, (elapsedTime % 60).format("%02d")]);

        uiTime.setText( timeString );
        uiCalories.setText(Lang.format("$1$", [calories]));
        uiSplat.setText(Lang.format("$1$", [splatPoints]));
        uiAvgHR.setText(Lang.format("$1$% ($2$)", [averageHRPct.format("%.2d"), averageHR]));
        uiMaxHR.setText(Lang.format("$1$% ($2$)", [peakHRPct.format("%.2d"), peakHR]));

        drawSummaryBars(zoneTimes, zoneColors);

        uiZone1Text.setText(Lang.format("$1$", [Math.round(zoneTimes[0] / 60)]));
        uiZone2Text.setText(Lang.format("$1$", [Math.round(zoneTimes[1] / 60)]));
        uiZone3Text.setText(Lang.format("$1$", [Math.round(zoneTimes[2] / 60)]));
        uiZone4Text.setText(Lang.format("$1$", [Math.round(zoneTimes[3] / 60)]));
        uiZone5Text.setText(Lang.format("$1$", [Math.round(zoneTimes[4] / 60)]));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Calculate the height of the bars
    function drawSummaryBars(times, colors) {
        var regionHeight = uiZoneBars.regionHeight * 1.0;
        var barHeight = 0;

        uiZoneBars.colors = zoneColors;

        //times = [60, 300, 600, 1800, 3600];
        for( var i = 0; i < times.size(); i++ ) {
            barHeight = Math.round((regionHeight / 60) * (times[i] / 60));

            // Make very small bars more visible
            if ( barHeight > 0 ) {
                barHeight = barHeight + 5;
            }

            uiZoneBars.heights[i] = barHeight;
        }
    }
}