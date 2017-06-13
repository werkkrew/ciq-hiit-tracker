//! Default starting view

using Toybox.WatchUi as Ui;
using Toybox.Application;
using Toybox.Lang;
using Toybox.System;
using Toybox.Timer;

class OTFSplashView extends Ui.View {

    hidden var mModel;
    hidden var mController;
    hidden var mTimer;

    //! UI Variables
    hidden var uiStatusTime;
    hidden var uiStatusHRText;
    hidden var uiStatusHRIconWhite;
    hidden var uiStatusHRIconRed;
    hidden var xOffset;

    function initialize() {
        View.initialize();
        // Start timer used to push UI updates
        mTimer = new Timer.Timer();
        // Get the model and controller from the Application
        mModel = Application.getApp().model;
        mController = Application.getApp().controller;

        // Get values from resources
        uiStatusTime = null;
        uiStatusHRIconWhite = null;
        uiStatusHRIconRed = null;
        uiStatusHRText = null;
        xOffset = null;
    }

    //! Load your resources here
    function onLayout(dc) {
        // Load the layout from the resource file
        setLayout(Rez.Layouts.SplashScreen(dc));

        uiStatusTime = View.findDrawableById("StatusTime");
        uiStatusHRText = View.findDrawableById("StatusHRText");
        uiStatusHRIconWhite = View.findDrawableById("StatusHRIconWhite");
        uiStatusHRIconRed = View.findDrawableById("StatusHRIconRed");

        xOffset = uiStatusHRIconWhite.locX;
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
        // Draw the splash screen
        drawSplash();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Handler for the timer callback
    function onTimer() {
        Ui.requestUpdate();
    }

    hidden function drawSplash() {
        var time = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [time.hour.format("%2.2d"),time.min.format("%2.2d")]);
        var heartrate = mModel.getHRbpm();

        uiStatusTime.setText( timeString );

        // Change the Heart Rate icon and text based on sensor data
        // Flashing White is no HR data
        // Steady Red is valid HR data
        if (heartrate == 0 || heartrate == null) {
            uiStatusHRIconRed.locX = -50;
            if (uiStatusHRIconWhite.locX == -50) {
                uiStatusHRIconWhite.locX = xOffset;
            } else {
                uiStatusHRIconWhite.locX = -50;
            }
            uiStatusHRText.setText("");
        } else {
            heartrate = Lang.format("$1$", [heartrate]);
            uiStatusHRIconRed.locX = xOffset;
            uiStatusHRIconWhite.locX = -50;
            uiStatusHRText.setText( heartrate );
        }

    }

}