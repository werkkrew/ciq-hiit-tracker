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
            if (Log.isDebugEnabled()) {
                Log.debug("Menu item: AllowVibration");
            }
            Ui.pushView(new Rez.Menus.AllowVibrationMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
        }
        if (item == :HRProfile) {
            if (Log.isDebugEnabled()) {
                Log.debug("Menu item: HRProfile");
            }
            Ui.pushView(new Rez.Menus.HRProfileMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
        }

        // Allow Vibration
        if (item == :VibrationOn) {
            if (Log.isDebugEnabled()) {
                Log.debug("Menu item: Vibration On");
            }
            Prefs.setAllowVibration(true);
        }
        if (item == :VibrationOff) {
            if (Log.isDebugEnabled()) {
                Log.debug("Menu item: Vibration Off");
            }
            Prefs.setAllowVibration(false);
        }

        // Heart Rate Zones
        if (item == :OTFHR) {
            if (Log.isDebugEnabled()) {
                Log.debug("Menu item: Orange Theory HR");
            }
            Prefs.setHRProfile(Prefs.HR_OTFAPP);
        }
        if (item == :User) {
            if (Log.isDebugEnabled()) {
                Log.debug("Menu item: User HR");
            }
            Prefs.setHRProfile(Prefs.HR_USER_PROFILE);
        }
    }

}