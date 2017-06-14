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

    //! Button Pressed
    function onKey(key) {
        if (key.getKey() == Ui.KEY_ENTER) {
            //Exit the app
            controller.onExit();
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