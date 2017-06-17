//! OTFApp Model which handles the data processing of the activity

using Toybox.System;
using Toybox.Attention;
using Toybox.FitContributor as Fit;
using Toybox.Activity;
using Toybox.ActivityRecording as Recording;
using Toybox.UserProfile as Profile;
using Toybox.Time;
using Toybox.Timer;
using Toybox.Math;
using Toybox.WatchUi as Ui;

class OTFModel
{
    // Internal Timer and monitoring variables
    hidden var mTimer;
    hidden var mSeconds;
    hidden var mSession = null;
    hidden var mSplatsField = null;

    // Primary stats used during intervals
    hidden var mHeartRate;
    hidden var mHeartRatePct;
    hidden var mHeartRateZone;
    hidden var mMaxHR;
    hidden var mZones;
    hidden var mZoneTimes;
    hidden var mSplats;
    hidden var mSecondsSplat;

    // Summarized and exposed statistics
    var elapsedTime;
    var calories;
    var averageHR;
    var averageHRPct;
    var peakHR;
    var peakHRPct;
    var splatPoints;
    var zoneTimes;

    //Time in Zones
    hidden var tz1 = 0;
    hidden var tz2 = 0;
    hidden var tz3 = 0;
    hidden var tz4 = 0;
    hidden var tz5 = 0;

    //HR Zone Percentage settings, based on Orange Theory, override user
    hidden var z1pct = 0.50;
    hidden var z2pct = 0.61;
    hidden var z3pct = 0.71;
    hidden var z4pct = 0.84;
    hidden var z5pct = 0.92;

    // Initialize Activity
    function initialize() {
        // Sensor Heart Rate
        mHeartRate = 0;
        // Heart Rate as a Percentage
        mHeartRatePct = 0;
        // Current Heart Rate Zone
        mHeartRateZone = 0;
        // Max Heart Rate
        mMaxHR = 0;
        // Splat Points
        mSplats = 0;
        // Time elapsed
        mSeconds = 0;
        // Time HR is in Orange or Red range
        mSecondsSplat = 0;
        // HR Zones
        mZones = new [6];
        // HR Time in Each Zone
        mZoneTimes = new [5];
    }

    // Start session
    function start() {
        // Allocate the timer
        mTimer = new Timer.Timer();
        // Process the sensors at 10 Hz
        mTimer.start(method(:splatCallback), 1000, true);
        // Start the FIT recording
        if ( mSession != null ) {
            mSession.start();
        }
    }

    // Stop sensor processing
    function stop() {
        // Stop the timer
        mTimer.stop();
        // Stop the FIT recording
        if ( mSession != null ) {
            mSession.stop();
        }
    }

    // Save the current session
    function save() {
        if ( mSession != null ) {
            mSession.save();
            mSession = null;
        }
    }

    // Discard the current session
    function discard() {
        if ( mSession != null ) {
            mSession.discard();
        }
    }

    // Return the splat points
    function getSplats() {
        return mSplats;
    }

    // Return the current calories burned
    function getCalories() {
        var activity = Activity.getActivityInfo();
        if (activity.calories != null){
            return activity.calories;
        } else {
            return 0;
        }
    }

    // Return the current heart rate in bpm
    function getHRbpm() {
        return mHeartRate;
    }

    // Return the current heart rate in bpm
    function getHRpct() {
        return Math.round(mHeartRatePct);
    }

    // Return the current heart rate zone number
    function getHRzone() {
        return mHeartRateZone;
    }

    // Return the total elapsed recording time
    function getTimeElapsed() {
        return mSeconds;
    }

    function setSensor(sensor_info) {
        if( sensor_info has :heartRate ) {
            if( sensor_info.heartRate != null )
            {
                mHeartRate = sensor_info.heartRate;
            } else {
                mHeartRate = 0;
            }
        }
    }

    function setStats() {
        var activity = Activity.getActivityInfo();
        if (activity != null){

            if ( activity.elapsedTime != null ) {
                elapsedTime = activity.elapsedTime;
            } else {
                elapsedTime = 0;
            }

            if ( activity.calories != null ) {
                calories = activity.calories;
            } else {
                calories = 0;
            }

            if ( activity.averageHeartRate != null ) {
                averageHR = activity.averageHeartRate;
                averageHRPct = ( averageHR / mMaxHR ) * 100;
            } else {
                averageHR = 0;
                averageHRPct = 0;
            }

            if ( activity.maxHeartRate != null ) {
                peakHR = activity.maxHeartRate;
                peakHRPct = ( peakHR / mMaxHR ) * 100;
            } else {
                peakHR = 0;
                peakHRPct = 0;
            }

            if ( mSplats != null ) {
                splatPoints = mSplats;
                if ( mSession != null ) {
                    mSplatsField.setData( mSplats );
                }
            } else {
                splatPoints = 0;
            }

            zoneTimes = mZoneTimes;
        }
    }

    // Process splat points
    function splatCallback() {
        if( mHeartRate == null ) {
            return;
        }

        if ( mHeartRate < mZones[1] ) {
            tz1++;
            mHeartRateZone = 1;
        } else if ( mHeartRate > mZones[1] && mHeartRate < mZones[2] ) {
            tz2++;
            mHeartRateZone = 2;
        } else if ( mHeartRate > mZones[2] && mHeartRate < mZones[3] ) {
            tz3++;
            mHeartRateZone = 3;
        } else if ( mHeartRate > mZones[3] && mHeartRate < mZones[4] ) {
            tz4++;
            mHeartRateZone = 4;
        } else if ( mHeartRate > mZones[4] ) {
            tz5++;
            mHeartRateZone = 5;
        }

        mHeartRatePct = ( mHeartRate / mMaxHR ) * 100;
        mZoneTimes = [ tz1, tz2, tz3, tz4, tz5 ];

        // Seconds in splat point zone (HR Zone 4 and 5)
        mSecondsSplat = (tz4 + tz5);
        mSplats = Math.round( ( mSecondsSplat ) / 60 );

        // Update the current splats field
        if ( mSession != null ) {
            mSplatsField.setData( mSplats );
        }

        // Increment timer
        mSeconds++;
    }

    // Define the HR Zones as per user preference
    // If user selects OTF as the mode, we create a custom set of zones
    // min zone 1, max zone 1, max zone 2, max zone 3, max zone 4, max zone 5
    function setZones(profile) {
        if (profile == 1) {
            mZones = Profile.getHeartRateZones(Profile.HR_ZONE_SPORT_GENERIC);
            mMaxHR = mZones[5];
        } else if (profile == 2) {
            mZones = Profile.getHeartRateZones(Profile.HR_ZONE_SPORT_RUNNING);
            mMaxHR = mZones[5];
        } else if (profile == 3) {
            mZones = Profile.getHeartRateZones(Profile.HR_ZONE_SPORT_BIKING);
            mMaxHR = mZones[5];
        } else if (profile == 4) {
            mZones = Profile.getHeartRateZones(Profile.HR_ZONE_SPORT_SWIMMING);
            mMaxHR = mZones[5];
        } else {
            var birthYear = Profile.getProfile().birthYear;
            var todayYear = Time.Gregorian.info(Time.today(), Time.FORMAT_SHORT).year;
            var gender = Profile.getProfile().gender;

            // SDK 2.3.x Simulator Bug?
            if ( birthYear < 1900 ) {
                birthYear += 1900;
            }

            // Get the users age (will not be exact due to Garmin only providing users birth year)
            // If user has not provided a birth year or the device cannot get the current date
            // default back to the pre-defined zones
            if ( birthYear == null || todayYear == null ) {
                mZones = Profile.getHeartRateZones(Profile.HR_ZONE_SPORT_GENERIC);
            } else {
                var userAge = ( todayYear - birthYear );
                // This is the formula OTF uses to get max HR
                // The * 1.0 is a hack to force the maxHR type into a float or double because im bad
                if ( gender == 0 ) {
                    mMaxHR = ( 230 - userAge ) * 1.0;
                } else {
                    mMaxHR = ( 225 - userAge ) * 1.0;
                }

                mZones = [ (mMaxHR * z1pct), (mMaxHR * z2pct), (mMaxHR * z3pct), (mMaxHR * z4pct), (mMaxHR * z5pct), mMaxHR ];
            }
        }
        Log.debug("Heart Rate Zones Set: " + profile);
    }

    // Set the recording activity type as per user preferences
    function setActivity(type, subType) {
        if(Toybox has :ActivityRecording) {

            // Default and Treadmill Running
            if ( type == 0 || type == 2) {
                type = Recording.SPORT_RUNNING;
                subType = Recording.SUB_SPORT_TREADMILL;
            } else if ( type == 1 ) {
                type = Recording.SPORT_TRAINING;
                if ( subType == 0 ) {
                    subType = Recording.SUB_SPORT_CARDIO_TRAINING;
                } else if ( subType == 1 ) {
                    subType = Recording.SUB_SPORT_STRENGTH_TRAINING;
                } else if ( subType == 2 ) {
                    subType = Recording.SUB_SPORT_FLEXIBILITY_TRAINING;
                }
            } else if ( type == 3 ) {
                type = Recording.SPORT_WALKING;
                subType = Recording.SUB_SPORT_TREADMILL;
            } else if ( type == 4 ) {
                type = Recording.SPORT_ROWING;
                subType = Recording.SUB_SPORT_INDOOR_ROWING;
            } else if ( type == 5 ) {
                type = Recording.SPORT_CYCLING;
                subType = Recording.SUB_SPORT_INDOOR_CYCLING;
            }

            // Create a new FIT recording session
            mSession = Recording.createSession({:sport=>type, :subSport=>subType, :name => Ui.loadResource(Rez.Strings.orangetheory)});
            // Create the new FIT fields to record to.
            mSplatsField = mSession.createField("splat_points", 0, Fit.DATA_TYPE_UINT16, {:mesgType => Fit.MESG_TYPE_SESSION, :units => Ui.loadResource(Rez.Strings.splat_units)});

            Log.debug("Activity Recording Type: " + type + " Sub: " + subType);
        }
    }

}