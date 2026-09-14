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
            return;
        }
        if (item == :AllowVibration) {
            Ui.pushView(new Rez.Menus.AllowVibrationMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return;
        }
        if (item == :HRStability) {
            Ui.pushView(new Rez.Menus.HRStabilityMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return;
        }
        if (item == :MaxHRFormula) {
            Ui.pushView(new Rez.Menus.MaxHRFormulaMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return;
        }
        if (item == :TwentyFourHourClock) {
            Ui.pushView(new Rez.Menus.TwentyFourHourClockMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return;
        }

        // Activity Type
        if (item == :activity_default) {
            Prefs.setActivityType(Prefs.ACT_DEFAULT);
            return;
        }
        if (item == :activity_training) {
            Prefs.setActivityType(Prefs.ACT_TRAINING);
            Ui.pushView(new Rez.Menus.ActivitySubTypeMenu(), new OTFMenuDelegate(), Ui.SLIDE_UP);
            return;
        }
        if (item == :activity_running) {
            Prefs.setActivityType(Prefs.ACT_RUNNING);
            return;
        }
        if (item == :activity_walking) {
            Prefs.setActivityType(Prefs.ACT_WALKING);
            return;
        }
        if (item == :activity_rowing) {
            Prefs.setActivityType(Prefs.ACT_ROWING);
            return;
        }
        if (item == :activity_cycling) {
            Prefs.setActivityType(Prefs.ACT_CYCLING);
            return;
        }

        // Activity Sub-type
        if (item == :activity_sub_cardio) {
            Prefs.setActivitySubType(Prefs.SUB_CARDIO);
            return;
        }
        if (item == :activity_sub_strength) {
            Prefs.setActivitySubType(Prefs.SUB_STRENGTH);
            return;
        }
        if (item == :activity_sub_flexibility) {
            Prefs.setActivitySubType(Prefs.SUB_FLEXIBILITY);
            return;
        }

        // Max HR Formula
        if (item == :maxhrformula_new) {
            Prefs.setMaxHRFormula(Prefs.FORMULA_NEW);
            return;
        }
        if (item == :maxhrformula_old) {
            Prefs.setMaxHRFormula(Prefs.FORMULA_OLD);
            return;
        }
        if (item == :max_hr_from_user_profile) {
            Prefs.setMaxHRFormula(Prefs.FORMULA_USER_PROFILE);
            return;
        }

        // Allow Vibration
        if (item == :VibrationOn) {
            Prefs.setAllowVibration(true);
            return;
        }
        if (item == :VibrationOff) {
            Prefs.setAllowVibration(false);
            return;
        }

        // HR Stabilizer
        if (item == :HRStabilityOn) {
            Prefs.setHRStability(true);
            return;
        }
        if (item == :HRStabilityOff) {
            Prefs.setHRStability(false);
            return;
        }
        
        // TwentyFourHourClock
        if (item == :TwentyFourHourClockOn) {
            Prefs.setTwentyFourHourClock(true);
            return;
        }
        if (item == :TwentyFourHourClockOff) {
            Prefs.setTwentyFourHourClock(false);
            return;
        }

        return;
    }

}