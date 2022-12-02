## HIIT Tracker
#### Formerly Orange Theory Fitness App
**For Garmin Connect IQ**

**This App is Unofficial and was not created by [Orange Theory Fitness](http://www.orangetheoryfitness.com)**

![Capture](dist/graphics/ciq-badge.png)

### Description

This Garmin Connect IQ App provides a display on your Garmin Device which closely matches the display seen on the screens in Orange Theory Fitness studios.  It is intended to be used in-studio along with any of the official OTF heart rate monitors.  Devices equipped with internal HRM's can use this sensor as well but it is not as accurate.  By default the app will record an activity of type Training with sub-type Cardio but this can be changed by the user in the app settings.  This activity and it's FIT data can be saved and sync'd with Garmin Connect just as any other fitness tracking app does.

* [HIIT Tracker App on the Connect IQ Store](https://apps.garmin.com/en-US/apps/b886d2ac-2f94-4f9d-a7bd-85a59b99e639)

### Calculations and Accuracy

The output of this app should very closely match that of the OTF Workout Summary.  It may not be exact in all cases and is meant to be as close as possible.

* Max HR is calculated as per Orange Theory's method which is: (230 - Age) for Females and (225 - Age) for Males
* HR Zone Thresholds are: Blue - 61%, Green 71%, Orange 84%, Red 92%
* Calories Burned are calculated using Garmin's algorithms, not OTF's.  This is because I do not know how to override that field in the FIT recording file.
* Splat Points are the total time in seconds in the Orange + Red Zones, rounded to the nearest minute.
* Splat Points are usually 1-2 low for the duration of the workout.  I believe this is because I use BPM to calculate time in zone and OTF might use percentage which is rounded.

Heart Rate Stability

During particularly crowded sessions my Vivoactive HR has trouble staying connected to my Scosche Rhythm+.  I believe it is due to interference with so many ANT devices in one room, but this is not something I can solve in my app, as the sensor connectivity is a base feature of the device.  To compensate I have added a "Heart Rate Stabilizier" feature which is on by default but can be disabled.  Essentially this will continue to use the last known heart rate for up to 10 seconds if the sensor disconnects.  Generally speaking when the sensor disconnects it seems to reconnect quite quickly so hopefully this feature will help the app produce more stable results during crowded sessions.

### Screenshots

**Tall**

![Capture](dist/graphics/capt_tall_02.png)
![Capture](dist/graphics/capt_tall_03.png)

**Rectangle**

![Capture](dist/graphics/capt_rect_01.png)
![Capture](dist/graphics/capt_rect_02.png)

**Semi-Round**

![Capture](dist/graphics/capt_semi_01.png)
![Capture](dist/graphics/capt_semi_02.png)

**Round**

![Capture](dist/graphics/capt_circ_02.png)
![Capture](dist/graphics/capt_circ_03.png)

### Supported Devices

* Approach® S60
* Approach® S62
* Captain Marvel
* First Avenger
* D2® Series
* Descent® Series
* fenix® 5 and up
* ForeRunner® Series
* MARQ® Series
* vivoactive® Series
* venu® Series

### How-To

**Menu Options and Settings**
*The menu can only be accessed while on the splash screen*

* Activity Type - Select the type of activity the workout will be recorded as.  The Activity Sub-Type setting only applies to the "Training" Activity.
* Heart Rate Zones - Choose between the official Orange Theory Zone model or your User Profile Defined Models
* Allow Vibration - Enable or Disable Vibration.  Enabling presents cues at start/stop of workout and when falling into the blue zone or going up into the orange/red zone
* Heart Rate Stability - Enable or Disable, default is on.

**Buttons and Interactions**
* On touchscreen devices tapping the screen will toggle the device back light (if equipped).
* Any button other than Back and Enter pressed outside of menus / prompts will toggle the backlight (if equipped).
* Back button on splash screen will exit the app
* Back button when the workout is active will pause the workout
* Back button on review page will exit the app
* Enter / Primary button on splash screen will start the workout
* Enter / Primary button during workout will pause the workout
* Enter / Primary button on review page will exit the app

**Prompts**
* If a Heart Rate is not detected upon starting the workout, user will be confirmed if they want to proceed.  App does not function without a heart rate but this assumes the user will attach their heart rate monitor after starting the workout.  This prompt will not be displayed on subsequent start/stop actions during a workout session.
* Upon stopping / pausing the workout a menu will be presented: Resume / Save / Discard.  These are fairly self-explanatory.  A back button pressed defaults to resume.
* Upon saving the activity a workout summary screen will be displayed.  The back or enter button on this screen will exit the app.

### To Do and Planned Features

* Allow the 4 statistics shown during a workout to be user selectable from a list of desirable stats
* Potentially allow for manual activity selection / switching during a workout
* Add background step tracking

### Bugs and Feature Requests

To report a bug or request a feature please use the Github issue tracker associated with this repository. 

### Development

Source code is made available under the [MIT license](https://opensource.org/licenses/MIT).

Pull requests and translations are welcomed!

### Version History and Changelog

*This app is tested on a Garmin Vivoactive® HR*

**v1.5.0 - 12/02/2022**
* Updated code-base to work with SDK version 4.1.x
* Added support for many new devices
* Fixed max HR issue (PR #11), thanks Supersmo!
* Updated icons for use on larger screen devices
* Cleaned up some layouts
* Removed support for: Fenix 3 series, ForeRunner 55
  
**v1.4.0 - 09/10/2019**
* Updated code-base to work with SDK version 3.1.x
* Added support for many new devices (fenix 6, etc.)
* Minor layout tweaks to various devices

**v1.3.3 - 05/06/2019**
* Changed default activity type from "Treadmill Running" to "Training" to avoid some user confusion
* Updated code-base to work with SDK version 3.x
* Added support for some additional devices
* Minor layout tweaks to various devices
* Cleaned up resources in code base

**v1.3.2 - 11/13/2017**
* Attempted bug fixes related to Fenix 3 HR
* Bumped minimum SDK support to 1.4.x from 1.3.x
* Adjusted some core code for optimizations and cleanup
* Adjusted some UI element positions

**v1.3.1 - 10/3/2017**
* Added support for Vivoactive3

**v1.3.0 - 10/3/2017**
* Removed all branding references to Orange Theory Fitness due to a copyright claim
* Laid groundwork for additional often requested features
* Updated to support SDK 2.3.4

**v1.2.6 - 7/22/2017**
* HR Zone options removed.  Uses only the official OTF zone definition now (previously the default) to prevent confusion.  Many people seemed to ask about why things didn't line up as they expected.
* HR Zone calculation adjustment, hopefully it's more accurate and splat points line up better now.

**v1.2.5 - 7/21/2017**
* Attempt to address bug on some devices where the HR Percentage does not show up.  

**v1.2.4 - 6/19/2017**
* Heart Rate Stability Feature (See description for additional details)

**v1.2.3 - 6/16/2017**
* Removed "Training Effect" statistic from summary.  It did not seem to return a useful value most of the time.

**v1.2.2 - 6/16/2017**
* Added Fenix 5S and Fenix Chronos Support
* Added Round 240x240 Watch support including Approach S60

**v1.2.1 - 6/16/2017**
* Added Fenix 3 and other round watch support
* Fixed an issue with incorrect version build uploaded for 1.2.0

**v1.2.0 - 6/15/2017**
* Added setting to allow user selection of the activity recording type.  Now defaults to Treadmill Running
* Vibration Updates, changed vibration profiles to be more easily recognizable as to what they mean
* Prevent back-to-back vibration events when heart rate is going between two zones relatively quickly

**v1.1.2 - 6/15/2017**
* Forerunner 630 Support
* Corrections to custom FIT field for Splat Points
* Additional HR profile settings
* Memory optimizations
* Fix reloading of changes to settings

**v1.1.1 - 6/14/2017**
* Fixed a bug in the review screen where test bars were left in place
* Improved button handling

**v1.1.0 - 6/13/2017**
* Updated code to be compatible with CIQ SDK 2.3.1
* Memory footprint optimizations
* Added support for Vivoactive
* Added support for Forerunner 920XT, 230, 235, 735XT

**v1.0.3 - 6/11/2017**
* Memory optimizations
* Re-factored a lot of code to be more portable across various devices

**v1.0.2 - 6/9/2017**
* Removed an un-needed permission
* Fixed a bug when closing/clearing sensors
* Added some additional logging points for debugging

**v1.0.1 - 6/5/2017**
* Fixed a type casting issue on HR percentage
* Changed the splat point calculation to be more accurate
* Updated screenshots

**v1.0.0 - 6/3/2017**
* Initial Release

