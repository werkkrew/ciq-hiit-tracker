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

class OTFModel
{
    // Internal Timer and monitoring variables
    hidden var mTimer;
    hidden var mSeconds;
    hidden var mSession;

    // Primary stats used during intervals
    hidden var mHeartRate;
    hidden var mHeartRatePct;
    hidden var mHeartRateZone;
    hidden var mMaxHR;
    hidden var mZones;
    hidden var mZoneTimes;
    hidden var mSplats;
    hidden var mSplatsField;
    hidden var mSecondsSplat;

    // Summarized and exposed statistics
    var elapsedTime;
    var calories;
    var averageHR;
    var averageHRPct;
    var peakHR;
    var peakHRPct;
    var splatPoints;
    var trainingEffect;
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

    // Define the HR Zones the same as OTF does (do not use the user zones)
    // min zone 1, max zone 1, max zone 2, max zone 3, max zone 4, max zone 5
    function setZones() {
        if (hrProfile == 1)
        {
            if (Log.isDebugEnabled()) {
                Log.debug("Setting user HR Zones");
            }
            mZones = Profile.getHeartRateZones(Profile.HR_ZONE_SPORT_GENERIC);
            mMaxHR = mZones[5];
        } else {
            if (Log.isDebugEnabled()) {
                Log.debug("Setting Orange Theory HR Zones");
            }
            var birthYear = Profile.getProfile().birthYear;
            var todayYear = Time.Gregorian.info(Time.today(), Time.FORMAT_SHORT).year;
            var gender = Profile.getProfile().gender;

            // Get the users age (will not be exact due to Garmin only providing users birth year)
            // If user has not provided a birth year or the device cannot get the current date
            // default back to the pre-defined zones
            if ( birthYear == null || todayYear == null ) {
                if (Log.isDebugEnabled()) {
                    Log.debug("User Birth Year or Current Date are null, falling back to default zones...");
                }
                mZones = Profile.getHeartRateZones(Profile.HR_ZONE_SPORT_GENERIC);
            } else {
                var userAge = ( todayYear - birthYear );
                // This is the formula OTF uses to get max HR
                if ( gender == 0 ) {
                    mMaxHR = ( 230 - userAge );
                } else {
                    mMaxHR = ( 225 - userAge );
                }

                mZones = [ (mMaxHR * z1pct), (mMaxHR * z2pct), (mMaxHR * z3pct), (mMaxHR * z4pct), (mMaxHR * z5pct), mMaxHR ];
                if (Log.isDebugEnabled()) {
                    Log.debug("OTF Calculated Zones Set!");
                }
            }
        }
        if (Log.isDebugEnabled()) {
            Log.debug("Max HR Set To: " +mMaxHR);
        }
    }

    // Initialize Activity
    function initialize() {
        if (Log.isDebugEnabled()) {
            Log.debug("Model Initialized");
        }
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
        // Create a new FIT recording session
        mSession = Recording.createSession({:sport=>Recording.SPORT_TRAINING, :subSport=>Recording.SUB_SPORT_CARDIO_TRAINING, :name=>"Orange Theory"});
        // Create the new FIT fields to record to.
        mSplatsField = mSession.createField("splat_points", 1, Fit.DATA_TYPE_UINT16, {:mesgType => Fit.MESG_TYPE_RECORD});
        // Set up the OTF HR Zones
        setZones();
    }

    // Start session
    function start() {
        // Allocate the timer
        mTimer = new Timer.Timer();
        // Process the sensors at 10 Hz
        mTimer.start(method(:splatCallback), 1000, true);
        // Start recording
        mSession.start();

        if (Log.isDebugEnabled()) {
            Log.debug("Workout Started!");
        }
    }

    // Stop sensor processing
    function stop() {
        // Stop the timer
        mTimer.stop();
        // Stop the FIT recording
        mSession.stop();

        if (Log.isDebugEnabled()) {
            Log.debug("Workout Stopped!");
        }
    }

    // Save the current session
    function save() {
        mSession.save();
    }

    // Discard the current session
    function discard() {
        mSession.discard();
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
                mSplatsField.setData( mSplats );
            } else {
                splatPoints = 0;
            }

            if ( activity.trainingEffect != null ) {
                trainingEffect = activity.trainingEffect;
            } else {
                trainingEffect = 0;
            }

            zoneTimes = mZoneTimes;
        }
    }

    // Process splat points
    function splatCallback() {
        if( mHeartRate == null ) {
            if (Log.isDebugEnabled()) {
                Log.debug("Heart Rate is null");
            }
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

        if (Log.isDebugEnabled()) {
            Log.debug("HR: " + mHeartRate);
            Log.debug("Zone: " + mHeartRateZone);
            Log.debug("HR Pct: " + mHeartRatePct);
        }

        // Seconds in splat point zone (HR Zone 4 and 5)
        mSecondsSplat = (tz4 + tz5);
        if (Log.isDebugEnabled()) {
            Log.debug("Splat Seconds: " + mSecondsSplat);
        }

        // Subtract 1 second from splat time, divide by 60 and round up
        mSplats = Math.round( ( mSecondsSplat - 1 ) / 60 );
        // Update the current splats field
        mSplatsField.setData( mSplats );

        // Increment timer
        mSeconds++;
    }
}