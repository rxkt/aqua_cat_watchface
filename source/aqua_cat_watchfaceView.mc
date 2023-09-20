import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.ActivityMonitor;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Position;

class aqua_cat_watchfaceView extends WatchUi.WatchFace {

    var aquaAnimation; // AnimationLayer extends Layer
    var _animationDelegate = null;
    var _playing;

    function initialize() {
        WatchFace.initialize();
        // var dev = System.getDeviceSettings();
        // var x = ( dev.screenWidth - aquaAnimation.getWidth() ) / 2;
        // var y = ( dev.screenHeight - aquaAnimation.getHeight() ) / 2;
        // create a new AnimationLayer with resource, then add it to view 
        // as WatchUi.Layer?
        // aquaAnimation = new WatchUi.AnimationLayer(Rez.Drawables.aqua, {:locX=>0, :locY=>0});
        // View.addLayer(aquaAnimation);
        _animationDelegate = new aqua_cat_animation_controller();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // setLayout(Rez.Layouts.WatchFace(dc));   
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        _animationDelegate.handleOnShow(self);
        _animationDelegate.play();
    }

        // Build up the time string
    private function getTimeString() {
        var clockTime = System.getClockTime();
        var info = System.getDeviceSettings();
        var hour = clockTime.hour;
        if( !info.is24Hour ) {
            hour = clockTime.hour % 12;
            if (hour == 0) {
                hour = 12;
            }
        }
        return Lang.format("$1$:$2$", [hour, clockTime.min.format("%02d")]);
    }

    private function getStepsString() {
        var steps = ActivityMonitor.getInfo().steps;
        // if (steps == 0) {
        //     steps = 15000;
        // }
        if (steps == null) {
            steps = 0;
        }
        return Lang.format("$1$", [steps]);
    }

    private function getHeartrateString() {
        var heartrateString = Activity.getActivityInfo().currentHeartRate;
        if (heartrateString == null) {
            heartrateString = 0;
        }
        return Lang.format("$1$", [heartrateString]);
    }

    private function getBattery() {
        var batteryString = (System.getSystemStats().battery).toNumber();
        return Lang.format("$1$%",[batteryString]);
    }

    private function getLocalDayDateString() {
        var curLoc = Activity.getActivityInfo().currentLocation;
        if (curLoc == null) {
            curLoc = new Position.Location(
                {
                    :latitude => 32.7157, 
                    :longitude => -117.1611,
                    :format => :degrees
                }
            ); 
        }
        if (curLoc != null) {
            var nowLocalMoment = Gregorian.localMoment(curLoc, Time.now());
            var today = Gregorian.info(nowLocalMoment, Time.FORMAT_MEDIUM);
            var timeString = Lang.format("$1$:$2$:$3$", [today.hour, today.min.format("%02d"), today.sec.format("%02d")]);
            var dayString = Lang.format("$1$", [today.day_of_week]);
            var dateString = Lang.format("$1$ $2$", [today.day, today.month]);
            return [timeString, dayString, dateString];
        } else {
            return null;
        }
    }

    private function getDay() {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        return Lang.format("$1$", [today.day_of_week]);
    }

    private function getDate() {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        return Lang.format("$1$ $2$", [today.day, today.month]);
    }

    private function getTime() {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        return Lang.format("$1$:$2$:$3$", [today.hour, today.min.format("%02d"), today.sec.format("%02d")]);
    }


    // Function to render the time on the time layer
    private function updateTimeLayer() {
        var dc = _animationDelegate.getTextLayer().getDc();
        var width = dc.getWidth();
        var height = dc.getHeight();

        // Clear the layer contents
        var timeString = getTimeString();
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        // Draw the time in the middle
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height / 2, Graphics.FONT_NUMBER_MEDIUM, timeString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }



    // Function to render all text on screen
    // includes steps, day, date-month-year, heartrate?
    private function updateTextLayer(timeString) {
        var dc = _animationDelegate.getTextLayer().getDc();
        var width = dc.getWidth();
        var height = dc.getHeight();
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        // draw based on localDayDate
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT); // using alternative text rendering
        // tests for these to make sure they are valid?
        dc.drawText((width / 2) & ~0x3, height / 2, Graphics.FONT_LARGE, timeString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function updateDateLayer(dateString) {
        var dc = _animationDelegate.getDateLayer().getDc();
        var width = dc.getWidth();
        var height = dc.getHeight();
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT); // using alternative text rendering
        dc.drawText(width*0.5, height*0.5, Graphics.FONT_TINY, dateString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
    function updateDayLayer(dayString) {
        var dc = _animationDelegate.getDayLayer().getDc();
        var width = dc.getWidth();
        var height = dc.getHeight();
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT); // using alternative text rendering
        dc.drawText(width/2, height/2, Graphics.FONT_TINY, dayString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
    function updateHeartrateLayer() {
        var heartrateString = getHeartrateString();
        var dc = _animationDelegate.getHeartrateLayer().getDc();
        var width = dc.getWidth();
        var height = dc.getHeight();
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT); // using alternative text rendering
        dc.drawText(width/2, height/2, Graphics.FONT_TINY, heartrateString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
    function updateBatteryLayer() {
        var dc = _animationDelegate.getBatteryLayer().getDc();
        var batteryString = getBattery();
        System.println(Lang.format("battery string obatined:$1$", [batteryString]));
        var width = dc.getWidth();
        var height = dc.getHeight();
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT); // using alternative text rendering
        dc.drawText(width/2, height/2, Graphics.FONT_TINY, batteryString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
    function updateStepsLayer() {
        var stepsString = getStepsString();
        var dc = _animationDelegate.getStepsLayer().getDc();
        var width = dc.getWidth();
        var height = dc.getHeight();
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT); // using alternative text rendering
        dc.drawText(width/2, height/2, Graphics.FONT_TINY, stepsString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Clear the screen buffer
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
        // var localDayDate = getLocalDayDateString();
        // if localDayDate
        // var timeString = localDayDate[0];
        // var dayString = localDayDate[1];
        // var dateString = localDayDate[2];
        // if (localDayDate == null) {
        //     updateTimeLayer();
        // } else {
        System.println("running onUpdate");
        updateTimeLayer();
        updateTextLayer(getTime());
        updateDayLayer(getDay());
        updateDateLayer(getDate());
        updateStepsLayer();
        updateHeartrateLayer();
        updateBatteryLayer();
        // }
        return;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        _animationDelegate.handleOnHide(self);
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        _animationDelegate.play();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        _animationDelegate.stop();
    }


}

