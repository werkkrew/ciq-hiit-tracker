using Toybox.Application as App;
using Toybox.WatchUi as Ui;

//! Application menu delegate
class OTFMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        // Main
        if (item == :ActivityType) {
            Ui.pushView(new Rez.Menus.ActivityTypeMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return true;
        }
        if (item == :HRProfile) {
            Ui.pushView(new Rez.Menus.HRProfileMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return true;
        }
        if (item == :AllowVibration) {
            Ui.pushView(new Rez.Menus.AllowVibrationMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return true;
        }
        if (item == :HRStability) {
            Ui.pushView(new Rez.Menus.HRStabilityMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return true;
        }

        // Activity Type
        if (item == :activity_default) {
            Prefs.setActivityType(Prefs.ACT_DEFAULT);
            return true;
        }
        if (item == :activity_training) {
            Prefs.setActivityType(Prefs.ACT_TRAINING);
            Ui.pushView(new Rez.Menus.ActivitySubTypeMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return true;
        }
        if (item == :activity_running) {
            Prefs.setActivityType(Prefs.ACT_RUNNING);
            return true;
        }
        if (item == :activity_walking) {
            Prefs.setActivityType(Prefs.ACT_WALKING);
            return true;
        }
        if (item == :activity_rowing) {
            Prefs.setActivityType(Prefs.ACT_ROWING);
            return true;
        }
        if (item == :activity_cycling) {
            Prefs.setActivityType(Prefs.ACT_CYCLING);
            return true;
        }

        // Activity Sub-type
        if (item == :activity_sub_cardio) {
            Prefs.setActivitySubType(Prefs.SUB_CARDIO);
            return true;
        }
        if (item == :activity_sub_strength) {
            Prefs.setActivitySubType(Prefs.SUB_STRENGTH);
            return true;
        }
        if (item == :activity_sub_flexibility) {
            Prefs.setActivitySubType(Prefs.SUB_FLEXIBILITY);
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

        // HR Stabilizer
        if (item == :HRStabilityOn) {
            Prefs.setHRStability(true);
            return true;
        }
        if (item == :HRStabilityOff) {
            Prefs.setHRStability(false);
            return true;
        }

        // Heart Rate Zones
        if (item == :OTF) {
            Prefs.setHRProfile(Prefs.HR_OTFAPP);
            return true;
        }
        if (item == :user_generic) {
            Prefs.setHRProfile(Prefs.HR_USER_GENERIC);
            return true;
        }
        if (item == :user_running) {
            Prefs.setHRProfile(Prefs.HR_USER_RUNNING);
            return true;
        }
        if (item == :user_biking) {
            Prefs.setHRProfile(Prefs.HR_USER_BIKING);
            return true;
        }
        if (item == :user_swimming) {
            Prefs.setHRProfile(Prefs.HR_USER_SWIMMING);
            return true;
        }

        return false;
    }

}