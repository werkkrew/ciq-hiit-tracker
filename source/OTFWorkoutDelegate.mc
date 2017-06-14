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
        controller.turnOnBacklight();
        return true;
    }

    //! Button Pressed
    function onKey(key) {
        if (key.getKey() == Ui.KEY_ENTER) {
            controller.onStartStop();
        }
        // All other buttons toggle backlight
        if (key.getKey() == Ui.KEY_LIGHT || key.getKey() == Ui.KEY_UP || key.getKey() == Ui.KEY_DOWN) {
            controller.turnOnBacklight();
        }
        return true;
    }

    //! Screen Tap
    function onTap(type) {
        if (type.getType() == Ui.CLICK_TYPE_TAP) {
            controller.turnOnBacklight();
        }
    }


    function setController(c) {
        controller = c;
    }

}