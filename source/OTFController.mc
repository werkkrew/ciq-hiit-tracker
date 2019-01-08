//! Controller class for OTFApp
//! Controls overall flow of app, settings and processing

using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as System;
using Toybox.Timer as Timer;
using Toybox.Activity as Activity;
using Toybox.Attention as Attention;
using Toybox.Time as Time;
using Toybox.Lang as Lang;

class OTFController
{
    hidden var mModel;

    hidden var mRunning;

    hidden var mTimer;
    hidden var backlightTimer;
    hidden var allowVibration;
    
    var confirmed;

    //! Initialize the controller
    function initialize() {
        var AppName = Ui.loadResource(Rez.Strings.AppName);
        var AppVersion = Ui.loadResource(Rez.Strings.AppVersion);

        Log.debug("App: " + AppName);
        Log.debug("Version: " + AppVersion);

        // Connect to Heart Rate Sensor
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
        Sensor.enableSensorEvents(method(:onSensor));

        Log.debug("Heart Rate Sensor Enabled");

        // Allocate a timer
        mTimer = null;
        // Get the model from the application
        mModel = App.getApp().model;

        // We are not running (yet)
        mRunning = false;
        backlightTimer = null;
        confirmed = false;
    }

    //! Start the recording process
    //! If it was not previously started confirm the presense of a HR
    function startWorkout() {
        mRunning = true;

        var delegate = new OTFWorkoutDelegate();
        var view = new OTFWorkoutView();

        Ui.switchToView(view, delegate, Ui.SLIDE_LEFT);

        mModel.start();
        notifyShort();
    }

    //! Start the Model
    hidden function resumeWorkout() {
        mRunning = true;
        mModel.start();
        notifyShort();
    }

    //! Stop/Pause the Model
    hidden function stopWorkout() {
        mRunning = false;
        mModel.stop();
        notifyShort();
        WatchUi.pushView(new Rez.Menus.EndWorkoutMenu(), new EndWorkoutDelegate(), WatchUi.SLIDE_UP);
    }

    //! Handle the start/stop button
    function onStartStop() {
        if (mRunning) {
            stopWorkout();
        } else {
            resumeWorkout();
        }
    }

    //! Confirmation of no HR
    function confirmStart() {
        // grab current heart rate
        var heartrate = mModel.getHRbpm();

        // If there is no heart rate detected and the prompt has not previously been confirmed
        // confirm if the user still wishes to start the workout
        if (heartrate == 0 || heartrate == null) {
            var dialog = new Ui.Confirmation(Ui.loadResource(Rez.Strings.start_session_no_hr));
            var delegate = new StartConfirmationDelegate();

            // Open the HR confirmation dialog
            Ui.pushView(dialog, delegate, Ui.SLIDE_UP );
        } else {
            startWorkout();
        }
    }

    //! Save the recording
    function save() {
        // Set final statistic variables for review
        mModel.setStats();

        // Save the recording
        mModel.save();

        // Give the system some time to finish the recording. Push up a progress bar
        // and start a timer to allow all processing to finish
        Ui.pushView(new Ui.ProgressBar("Saving...", null), new OTFProgressDelegate(), Ui.SLIDE_DOWN);
        mTimer = new Timer.Timer();

        // After data is saved, proceed to screens to review the stats of the workout
        mTimer.start(method(:onFinish), 3000, false);
    }

    //! Discard the recording
    function discard() {
        mModel.discard();

        // Give the system some time to discard the recording. Push up a progress bar
        // and start a timer to allow all processing to finish
        Ui.pushView(new Ui.ProgressBar("Discarding...", null), new OTFProgressDelegate(), Ui.SLIDE_DOWN);
        mTimer = new Timer.Timer();

        // After data is discarded, exit the app
        mTimer.start(method(:onExit), 3000, false);
    }

     //! Review the stats of the activity when finished
    function onFinish() {
        var delegate = new OTFReviewDelegate();
        var view = new OTFReviewView();

        Ui.switchToView(view, delegate, Ui.SLIDE_UP);
    }

    //! Are we running currently?
    function isRunning() {
        return mRunning;
    }

    //! Get the recording time elapsed
    function getTime() {
        return mModel.getTimeElapsed();
    }

    //! Handle Sensor Events
    function onSensor(sensor_info) {
        mModel.setSensor(sensor_info);
    }

    //! Handle timing out after exit
    function onExit() {
        System.exit();
    }

    //! Load preferences for the view from the object store.
    //! This can be called from the app when the settings have changed.
    function loadPreferences() {
        Log.debug("Preferences Loading");
        // Set Activity Recording Type
        mModel.setActivity(Prefs.getActivityType(), Prefs.getActivitySubType());
        // Check HR Max Formula
        Log.debug("MaxHRFormula: " + Prefs.getMaxHRFormula());
        // Set HR Stability
        mModel.setStability(Prefs.getHRStability());
        Log.debug("HR Stability: " + Prefs.getHRStability());
        // Set Vibration Policy
        allowVibration = (Attention has :vibrate) && (System.getDeviceSettings().vibrateOn) && (Prefs.getAllowVibration());
        Log.debug("Allow Vibration: " + allowVibration);
    }

    //! Turn on backlight.
    //! Trigger a timer to turn off backlight after 3 seconds.
    function turnOnBacklight() {
        if (backlightTimer == null) {
            backlight(true);
            backlightTimer = new Timer.Timer();
            backlightTimer.start(method(:onBacklightTimer), 3000, false);
        }
    }

    //! Action on backlight timer, turn off backlight and invalidate timer.
    function onBacklightTimer() {
        backlight(false);
        backlightTimer = null;
    }

    //! Turn on/off backlight based on given flag.
    function backlight(on) {
        if (Attention has :backlight) {
            Attention.backlight(on);
        }
    }

    hidden function notifyShort() {
        turnOnBacklight();
        vibrate(0);
    }

    function vibrate(style) {
        if (allowVibration) {
            var VibeData = null;
            if ( style == 0 ) {
                // Single Short
                VibeData =
                [
                    new Attention.VibeProfile(100, 250)
                ];
            } else if ( style == 1 ) {
                // Single Long
                VibeData =
                [
                    new Attention.VibeProfile(100, 2000)
                ];
            } else if ( style == 2 ) {
                // Two Short
                VibeData =
                [
                    new Attention.VibeProfile(100, 250),
                    new Attention.VibeProfile(0, 250),
                    new Attention.VibeProfile(100, 250)
                ];
            } else if ( style == 3 ) {
                // Three Short
                VibeData =
                [
                    new Attention.VibeProfile(100, 250),
                    new Attention.VibeProfile(0, 250),
                    new Attention.VibeProfile(100, 250),
                    new Attention.VibeProfile(0, 250),
                    new Attention.VibeProfile(100, 250)
                ];
            }
            Attention.vibrate(VibeData);
        }
    }
}