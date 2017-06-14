//! Delegates inputs to the controller

using Toybox.WatchUi as Ui;

class OTFWorkoutDelegate extends Ui.BehaviorDelegate {

    hidden var controller;

    //! Constructor
    function initialize() {
        // Initialize the superclass
        BehaviorDelegate.initialize();
        // Get the controller from the application class
        controller = Application.getApp().controller;
    }

    //! Back button pressed
    function onBack() {
        // Treat the back button like the start/stop button during workout
        controller.onStartStop();
        return true;
    }

    //! Menu button pressed
    function onMenu() {
        // Do not allow access to the menu while workout is running
        if ( !controller.isRunning() ) {
            Ui.pushView(new Rez.Menus.MainMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
        }
        return true;
    }

    //!
    function onKey(key) {
        Log.debug("Key Pressed: " + key.getKey());
        if (key.getKey() == Ui.KEY_ENTER) {
            // Pass the input to the controller
            controller.onStartStop();
        }
        return true;
    }

    //! Start the controller on initial tap, ignore a subsequent tap
    function onSelect() {
        // Taps on the screen toggle the backlight during a workout
        controller.turnOnBacklight();
        return true;
    }


    function setController(c) {
        controller = c;
    }

}