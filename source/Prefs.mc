//! Preferences Module from 7-Minute App: https://bitbucket.org/obagot/connectiq-hict/

using Toybox.Application as App;
using Toybox.FitContributor as Fit;

//! Preferences utility.
module Prefs {

    //! List of activity types
    enum {
        OTF = 0,
        MANUAL = 1
    }

    //! Activity Types
    enum {
        ACT_DEFAULT = 0,
        ACT_TRAINING = 1,
        ACT_RUNNING = 2,
        ACT_WALKING = 3,
        ACT_ROWING = 4,
        ACT_CYCLING = 5,
        ACT_MANUAL = 6
    }

    //! Sub-Activity Types
    enum {
        SUB_CARDIO = 0,
        SUB_STRENGTH = 1,
        SUB_FLEXIBILITY = 2
    }

    //! Max HR Formulas
    enum {
        FORMULA_NEW = 0,
        FORMULA_OLD = 1
    }

    //! Store activity type
    function setActivityType(type) {
        App.getApp().setProperty(ACTIVITY_TYPE, type);
    }

    //! Get activity type
    function getActivityType() {
        var type = getNumber(ACTIVITY_TYPE, 0, 0, 100);
        return type;
    }

    //! Store activity sub-type
    function setActivitySubType(type) {
        App.getApp().setProperty(ACTIVITY_SUB_TYPE, type);
    }

    //! Get activity sub-type
    function getActivitySubType() {
        var subType = getNumber(ACTIVITY_SUB_TYPE, 0, 0, 100);
        return subType;
    }

    //! Store max HR formula
    function setMaxHRFormula(type) {
        App.getApp().setProperty(MAXHRFORMULA, type);
    }

    //! Get max HR formula
    function getMaxHRFormula() {
        var formula = getNumber(MAXHRFORMULA, 0, 0, 100);
        return formula;
    }

    //! Set vibration policy
    function setAllowVibration(value) {
        App.getApp().setProperty(ALLOW_VIBRATION, value);
    }

    //! Return boolean of vibration setting
    function getAllowVibration() {
        var value = getBoolean(ALLOW_VIBRATION, true);
        return value;
    }

    //! Set HR Stability
    function setHRStability(value) {
        App.getApp().setProperty(ALLOW_HRSTABILITY, value);
    }

    //! Return boolean of vibration setting
    function getHRStability() {
        var value = getBoolean(ALLOW_HRSTABILITY, true);
        return value;
    }

    //! Set TwentyFourHourClock
    function setTwentyFourHourClock(value) {
        App.getApp().setProperty(TWENTYFOURHOUR_CLOCK, value);
    }

    //! Return boolean of vibration setting
    function getTwentyFourHourClock() {
        var value = getBoolean(TWENTYFOURHOUR_CLOCK, true);
        return value;
    }

    //! Return the number value for a preference, or the given default value if pref
    //! does not exist, is invalid, is less than the min or is greater than the max.
    //! @param name the name of the preference
    //! @param def the default value if preference value cannot be found
    //! @param min the minimum authorized value for the preference
    //! @param max the maximum authorized value for the preference
    function getNumber(name, def, min, max) {
        var app = App.getApp();
        var pref = def;

        if (app != null) {
            pref = app.getProperty(name);

            if (pref != null) {
                // GCM used to return value as string
                if (pref instanceof Toybox.Lang.String) {
                    try {
                        pref = pref.toNumber();
                    } catch(ex) {
                        pref = null;
                    }
                }
            }
        }

        // Run checks
        if (pref == null || pref < min || pref > max) {
            pref = def;
            app.setProperty(name, pref);
        }

        return pref;
    }

    //! Return the boolean value for the preference
    //! @param name the name of the preference
    //! @param def the default value if preference value cannot be found
    function getBoolean(name, def) {
        var app = App.getApp();
        var pref = def;

        if (app != null) {
            pref = app.getProperty(name);

            if (pref != null) {
                if (pref instanceof Toybox.Lang.Boolean) {
                    return pref;
                }

                if (pref == 1) {
                    return true;
                }
            }
        }

        // Default
        return pref;
    }

    // Settings name, see resources/settings.xml
    const ACTIVITY_TYPE = "activityType";
    const ACTIVITY_SUB_TYPE = "activitySubType";
    const MAXHRFORMULA = "maxHRFormula";
    const ALLOW_VIBRATION = "allowVibration";
    const ALLOW_HRSTABILITY = "allowHRStability";
    const TWENTYFOURHOUR_CLOCK = "twentyFourHourClock";

}