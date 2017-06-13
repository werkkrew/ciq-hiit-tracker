using Toybox.Application as App;
using Toybox.WatchUi as Ui;

//! Application menu delegate
class OTFMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        // Main
        if (item == :AllowVibration) {
            Ui.pushView(new Rez.Menus.AllowVibrationMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return true;
        }
        if (item == :HRProfile) {
            Ui.pushView(new Rez.Menus.HRProfileMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return true;
        }

        // Allow Vibration
        if (item == :VibrationOn) {
            Prefs.setAllowVibration(true);
            return true;
        }
        if (item == :VibrationOff) {
            Prefs.setAllowVibration(false);
            return true;
        }

        // Heart Rate Zones
        if (item == :OTFHR) {
            Prefs.setHRProfile(Prefs.HR_OTFAPP);
            return true;
        }
        if (item == :User) {
            Prefs.setHRProfile(Prefs.HR_USER_PROFILE);
            return true;
        }
        return false;
    }

}