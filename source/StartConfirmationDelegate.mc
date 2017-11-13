using Toybox.WatchUi as Ui;

class StartConfirmationDelegate extends Ui.ConfirmationDelegate {

    hidden var mController;

    function initialize() {
        ConfirmationDelegate.initialize();
        // Get the controller from the application class
        mController = Application.getApp().controller;
    }

    function onResponse(value) {
        if (value == Ui.CONFIRM_YES) {
            mController.confirmed = true;
        } 
    }

}