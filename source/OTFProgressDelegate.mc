using Toybox.WatchUi;

//! This handles input while the progress bar is up
class OTFProgressDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Block the back button handling while the progress bar is up.
    function onBack() {
        return true;
    }

}