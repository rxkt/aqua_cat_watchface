import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

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

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Clear the screen buffer
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
        // Update the contents of the time layer
        updateTimeLayer();
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

