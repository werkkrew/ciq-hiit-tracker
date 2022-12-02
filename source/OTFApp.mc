/*
HIIT Tracker

Created by Bryan Chain, Copyright 2022
Personal Homepage: https://bryanchain.com

*/

using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class OTFApp extends App.AppBase {

    var model;
    var controller;

    //! Initialize App
    function initialize() {
        AppBase.initialize();

        model = new OTFModel();
        controller = new OTFController();
    }

    //! Return the initial view of your application here
    function getInitialView() {
        var view = new OTFSplashView();
        var delegate = new OTFSplashDelegate();

        return [ view, delegate ];
    }

    //! New app settings have been received
    function onSettingsChanged() {
        controller.loadPreferences();
        Ui.requestUpdate();
    }

}
