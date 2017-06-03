//! Delegates inputs to the controller

using Toybox.WatchUi as Ui;

class OTFReviewDelegate extends Ui.BehaviorDelegate {

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
        //Exit the app
        controller.onExit();
        return true;
    }

    function onKey(key) {
        if (key.getKey() == Ui.KEY_ENTER) {
            //Exit the app
            controller.onExit();
        }
        return true;
    }

    function onSelect() {
        //Turn on backlight
        controller.turnOnBacklight();
        return true;
    }

    function setController(c) {
        controller = c;
    }

}