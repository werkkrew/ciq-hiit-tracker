//! View during workout

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application;
using Toybox.Lang;
using Toybox.System;
using Toybox.Timer;

class OTFWorkoutView extends Ui.View {

    hidden var mModel;
    hidden var mController;
    hidden var mTimer;

    //! UI Variables
    hidden var uiTimer;
    hidden var uiHRbpmText;
    hidden var uiCaloriesText;
    hidden var uiSplatText;

    hidden var uiHRpctText;
    hidden var uiHRZoneBackground;
    hidden var uiHRZoneBars;
    hidden var uiHRZoneColor;

    hidden var prevZone;


    function initialize() {
        View.initialize();
        // Start timer used to push UI updates
        mTimer = new Timer.Timer();
        // Get the model and controller from the Application
        mModel = Application.getApp().model;
        mController = Application.getApp().controller;

        uiTimer = null;
        uiHRbpmText = null;
        uiCaloriesText = null;
        uiSplatText = null;
        uiHRpctText = null;

        uiHRZoneBackground = null;
        uiHRZoneBars = null;
        uiHRZoneColor = [ Gfx.COLOR_LT_GRAY, Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLUE, Gfx.COLOR_GREEN, Gfx.COLOR_ORANGE, Gfx. COLOR_DK_RED ];
        prevZone = 0;
    }

    //! Load your resources here
    function onLayout(dc) {
        // Load the layout from the resource file
        setLayout(Rez.Layouts.PrimaryWorkoutScreen(dc));

        // Load UI resources
        uiHRbpmText = View.findDrawableById("WorkoutHRbpmText");
        uiTimer = View.findDrawableById("WorkoutTimer");
        uiCaloriesText = View.findDrawableById("WorkoutCaloriesText");
        uiSplatText = View.findDrawableById("WorkoutSplatText");
        uiHRpctText = View.findDrawableById("WorkoutHRpctText");

        uiHRZoneBackground = View.findDrawableById("WorkoutZoneBg");
        uiHRZoneBars = View.findDrawableById("WorkoutZoneBars");
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
        mTimer.start(method(:onTimer), 1000, true);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
        mTimer.stop();
    }

    //! Update the view
    function onUpdate(dc) {
        var curZone = mModel.getHRzone();

        if( curZone != null ) {
            uiHRZoneBackground.color = uiHRZoneColor[ curZone ];
            uiHRZoneBars.zone = curZone;
            zoneCheck(curZone);
        }

        var time = mModel.getTimeElapsed();
        var timeString = Lang.format("$1$:$2$", [time / 60, (time % 60).format("%02d")]);

        uiTimer.setText( timeString );
        uiHRpctText.setText(Lang.format("$1$", [mModel.getHRpct().format("%.0d")]));
        uiHRbpmText.setText(Lang.format("$1$", [mModel.getHRbpm()]));
        uiSplatText.setText(Lang.format("$1$", [mModel.getSplats()]));
        uiCaloriesText.setText(Lang.format("$1$", [mModel.getCalories()]));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Handler for the timer callback
    function onTimer() {
        Ui.requestUpdate();
    }

    function zoneCheck(zone) {
        // Transitioned into orange
        if ( prevZone <= 3 && zone == 4 ) {
            mController.vibrate(100,1000);
        // Transitioned into red
        } else if ( prevZone <= 4 && zone == 5 ) {
            mController.vibrate(100,2000);
        // Transitioned below green
        } else if ( prevZone >= 3 && zone <= 2 ) {
            mController.vibrate(100,400);
        }
        prevZone = zone;
    }

}