//! Delegates inputs to the controller

using Toybox.WatchUi as Ui;

class OTFReviewDelegate extends Ui.BehaviorDelegate {

    hidden var mController;

    //! Constructor
    function initialize() {
        // Initialize the superclass
        BehaviorDelegate.initialize();
        // Get the controller from the application class
        mController = Application.getApp().controller;
    }

    //! Back button pressed
    function onBack() {
        //Exit the app
        mController.onExit();
        return true;
    }

    //! Button Pressed
    function onKey(key) {
        if (key.getKey() == Ui.KEY_ENTER) {
            //Exit the app
            mController.onExit();
        }
        // All other buttons toggle backlight
        if (key.getKey() == Ui.KEY_LIGHT || key.getKey() == Ui.KEY_UP || key.getKey() == Ui.KEY_DOWN) {
            mController.turnOnBacklight();
        }
        return true;
    }

    //! Screen Tap
    function onTap(type) {
        if (type.getType() == Ui.CLICK_TYPE_TAP) {
            mController.turnOnBacklight();
        }
    }

}