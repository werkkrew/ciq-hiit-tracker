using Toybox.WatchUi as Ui;

class StartConfirmationDelegate extends Ui.ConfirmationDelegate {

    hidden var controller;

    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(value) {
        if (value == Ui.CONFIRM_YES) {
            confirmation = true;
        } else {
            confirmation = false;
        }
    }

    function setController(c) {
        controller = c;
    }
}