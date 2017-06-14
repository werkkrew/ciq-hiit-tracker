//! Preferences Module from 7-Minute App: https://bitbucket.org/obagot/connectiq-hict/

using Toybox.Application as App;

//! Preferences utility.
module Prefs {

    //! List of activity types
    enum {
        OTF = 0,
        MANUAL = 1
    }

    //! List of HR Profiles
    enum {
        HR_OTFAPP = 0,
        HR_USER_PROFILE = 1
    }

    //! Store activity type
    function setActivityType(type) {
        App.getApp().setProperty(ACTIVITY_TYPE, type);
    }

    //! Store Heart Rate Profile
    function setHRProfile(profile) {
        App.getApp().setProperty(HR_PROFILE, profile);
    }

    //! Get Heart Rate Profile
    function getHRProfile() {
        var profile = getNumber(HR_PROFILE, 0, 0, 999);
        return profile;
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
    const HR_PROFILE = "hrProfile";
    const ALLOW_VIBRATION = "allowVibration";

}