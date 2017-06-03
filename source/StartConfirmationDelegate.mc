using Toybox.WatchUi as Ui;

class StartConfirmationDelegate extends Ui.ConfirmationDelegate {

    hidden var controller;

    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(value) {
        if (value == Ui.CONFIRM_YES) {
            if (Log.isDebugEnabled()) {
                Log.debug("Start activity confirmed");
            }
            controller.mStarted = true;
            controller.startWorkout();
        } else {
            if (Log.isDebugEnabled()) {
                Log.debug("Start activity declined");
            }
        }
    }

    function setController(c) {
        controller = c;
    }
}