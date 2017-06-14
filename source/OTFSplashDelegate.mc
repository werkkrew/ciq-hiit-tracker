//! Delegates inputs to the controller

using Toybox.WatchUi as Ui;

class OTFSplashDelegate extends Ui.BehaviorDelegate {

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

    //! Menu button pressed
    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

    //!
    function onKey(key) {
        //Log.debug("Button Pressed: " + key.getKey());
        // Enter key toggles start/stop
        if (key.getKey() == Ui.KEY_ENTER) {
            controller.confirmStart();
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