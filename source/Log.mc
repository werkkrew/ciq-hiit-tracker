//! Logging Module from 7-Minute App: https://bitbucket.org/obagot/connectiq-hict/

using Toybox.Lang as Lang;
using Toybox.System as Sys;

//! Logging utility
module Log {

    //! Returns true if debug is enabled
    function isDebugEnabled() {
        return DEBUG;
    }

    //! Writes a debug message on system console
    function debug(text) {
        if (DEBUG) {
            var clock = Sys.getClockTime();
            var msg = Lang.format("$1$:$2$:$3$ - [DEBUG] - $4$", [
                clock.hour.format("%02d"),
                clock.min.format("%02d"),
                clock.sec.format("%02d"),
                text
            ]);
            Sys.println(msg);
        }
    }

    const DEBUG = false;
}