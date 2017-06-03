//! Delegates inputs to the controller

using Toybox.WatchUi as Ui;

class OTFDelegate extends Ui.BehaviorDelegate {

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
        Log.debug("Back button pressed.");
        // Do not quit if activity is running, pause the workout instead
        if ( controller.isRunning() ) {
            controller.stopWorkout();
        } else {
            Ui.popView(Ui.SLIDE_RIGHT);
        }
        return true;
    }

    //! Menu button pressed
    function onMenu() {
        if ((controller != null) && !controller.isRunning()) {
            Ui.pushView(new Rez.Menus.MainMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return true;
        }
        return false;
    }

    //!
    function onKey(key) {
        if (key.getKey() == Ui.KEY_ENTER) {
            // Pass the input to the controller
            controller.onStartStop();
        }
        return true;
    }

    //! Start the controller on initial tap, ignore a subsequent tap
    function onSelect() {
        // Pass the input to the controller
        if ( controller.isRunning()) {
            controller.turnOnBacklight();
        } else {
            controller.startWorkout();
        }
        return true;
    }


    function setController(c) {
        controller = c;
    }

}