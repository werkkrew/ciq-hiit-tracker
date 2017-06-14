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

    //! Button Pressed
    function onKey(key) {
        Log.debug("Button Pressed: " + key.getKey());
        if (key.getKey() == Ui.KEY_ENTER) {
            // Pass the input to the controller
            controller.onStartStop();
        }
        return true;
    }

    //! Screen Tap
    function onTap(type) {
        Log.debug("Screen Tapped: " + type.getType());
        if (type.getType() == Ui.CLICK_TYPE_TAP) {
            controller.turnOnBacklight();
        }
    }


    function setController(c) {
        controller = c;
    }

}