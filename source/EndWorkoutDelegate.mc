//! Menu Dialog for the end of a workout

using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application;


//! This delegate handles input for the Menu pushed when the user
//! hits the stop button
class EndWorkoutDelegate extends Ui.MenuInputDelegate {

    hidden var controller;

    // Constructor
    function initialize() {
        MenuInputDelegate.initialize();
        controller = Application.getApp().controller;
    }

    // Handle the menu input
    function onMenuItem(item) {
        if (item == :resume) {
            controller.onStartStop();
        } else if (item == :save) {
            controller.save();
        } else if (item == :discard) {
            controller.discard();
        }
    }
}