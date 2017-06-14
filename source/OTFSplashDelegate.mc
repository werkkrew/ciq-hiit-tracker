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
        if (key.getKey() == Ui.KEY_ENTER) {
            // Pass the input to the controller
            controller.confirmStart();
        }
        return true;
    }

    //! Start the controller on initial tap
    function onSelect() {
        controller.confirmStart();
        return true;
    }


    function setController(c) {
        controller = c;
    }

}