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

var activityType;
var hrProfile;
var allowVibration;

class OTFController
{
    var mTimer;
    var mModel;
    var mRunning;
    var mStarted;

    hidden var backlightTimer;

    //! Initialize the controller
    function initialize() {
        var AppName = Ui.loadResource(Rez.Strings.AppName);
        var AppVersion = Ui.loadResource(Rez.Strings.AppVersion);
        if (Log.isDebugEnabled()) {
            Log.debug("Controller Initialized: App: " + AppName + " Version: " + AppVersion);
        }

        // Connect to Heart Rate Sensor
        Sensor.enableSensorEvents(method(:onSensor));
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);

        // Allocate a timer
        mTimer = null;
        // Get the model from the application
        mModel = App.getApp().model;

        // We are not running (yet)
        mRunning = false;
        mStarted = false;
        backlightTimer = null;

    }

    //! Start the recording process
    //! If it was not previously started confirm the presense of a HR
    function startWorkout() {
        // grab current heart rate
        var heartrate = mModel.getHRbpm();

        if ((heartrate == 0 || heartrate == null) && !mStarted ) {
            var dialog = new Ui.Confirmation(Ui.loadResource(Rez.Strings.start_session_no_hr));
            var delegate = new StartConfirmationDelegate();
            delegate.setController(self);
            Ui.pushView(dialog, delegate, Ui.SLIDE_UP );
        } else {
            mStarted = true;
            mRunning = true;

            var delegate = new OTFDelegate();
            var view = new OTFWorkoutView();
            delegate.setController(self);

            Ui.switchToView(view, delegate, Ui.SLIDE_LEFT);
            mModel.start();
            notifyShort();
        }
    }

    //! Start the Model
    function resumeWorkout() {
        mRunning = true;
        mModel.start();
        notifyShort();
    }

    //! Stop/Pause the Model
    function stopWorkout() {
        mRunning = false;
        mModel.stop();
        notifyShort();
        WatchUi.pushView(new Rez.Menus.EndWorkoutMenu(), new EndWorkoutDelegate(), WatchUi.SLIDE_UP);
    }

    //! Save the recording
    function save() {
        // Set final statistic variables for review
        mModel.setStats();

        // Save the recording
        mModel.save();
        if (Log.isDebugEnabled()) {
            Log.debug("Saving Activity");
        }
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
        if (Log.isDebugEnabled()) {
            Log.debug("Activity: Discarding");
        }
        // Give the system some time to discard the recording. Push up a progress bar
        // and start a timer to allow all processing to finish
        Ui.pushView(new Ui.ProgressBar("Discarding...", null), new OTFProgressDelegate(), Ui.SLIDE_DOWN);
        mTimer = new Timer.Timer();

        // After data is discarded, exit the app
        mTimer.start(method(:onExit), 3000, false);
    }

    //! Are we running currently?
    function isRunning() {
        return mRunning;
    }

    //! Get the recording time elapsed
    function getTime() {
        return mModel.getTimeElapsed();
    }

    //! Handle the start/stop button
    function onStartStop() {
        if(mRunning) {
            stopWorkout();
        } else if (!mStarted) {
            startWorkout();
        } else {
            resumeWorkout();
        }
    }

    //! Handle Sensor Events
    function onSensor(sensor_info) {
        mModel.setSensor(sensor_info);
    }

    //! Handle timing out after exit
    function onExit() {
        System.exit();
    }

     //! Review the stats of the activity when finished
    function onFinish() {
        if (Log.isDebugEnabled()) {
            Log.debug("Activity Finished - Disable Sensors and Review");
        }

        var delegate = new OTFReviewDelegate();
        var view = new OTFReviewView();
        delegate.setController(self);

        Ui.pushView(view, delegate, Ui.SLIDE_UP);
    }


    //! Load preferences for the view from the object store.
    //! This can be called from the app when the settings have changed.
    function loadPreferences() {
        hrProfile = Prefs.getHRProfile();
        allowVibration = (Attention has :vibrate) && (System.getDeviceSettings().vibrateOn) && (Prefs.getAllowVibration());
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
    hidden function backlight(on) {
        if (Attention has :backlight) {
            Attention.backlight(on);
        }
    }

    hidden function notifyShort() {
        turnOnBacklight();
        if (allowVibration) {
            Attention.vibrate([
                new Attention.VibeProfile(100, 400)
            ]);
        }
    }

    function vibrate(duty, length) {
        if (allowVibration) {
            Attention.vibrate([
                new Attention.VibeProfile(duty, length)
            ]);
        }
    }
}