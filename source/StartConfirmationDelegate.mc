using Toybox.WatchUi as Ui;

class StartConfirmationDelegate extends Ui.ConfirmationDelegate {

    hidden var controller;

    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(value) {
        if (value == Ui.CONFIRM_YES) {
            controller.mStarted = true;
            controller.startWorkout();
        } else {
            Ui.popView(Ui.SLIDE_DOWN);
        }
    }

    function setController(c) {
        controller = c;
    }
}