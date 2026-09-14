//! Unit tests for OTFModel. Run with "Monkey C: Run Tests" in VS Code.

using Toybox.Sensor;
using Toybox.Test;

(:test)
function heartRateHoldAndDropout(logger) {
    var model = new OTFModel();
    var info = new Sensor.Info();

    // A live reading is reported as-is
    model.setStability(true);
    info.heartRate = 120;
    model.setSensor(info);
    Test.assertEqual(model.getHRbpm(), 120);

    // HR Stabilizer holds the last reading through a missing one
    info.heartRate = null;
    model.setSensor(info);
    Test.assertEqual(model.getHRbpm(), 120);

    // Without the stabilizer a missing reading zeroes HR immediately
    model.setStability(false);
    model.setSensor(info);
    Test.assertEqual(model.getHRbpm(), 0);

    return true;
}
