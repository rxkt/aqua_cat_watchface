using Toybox.WatchUi;

class aqua_cat_animation_controller {
    private var _animation;
    private var _textLayer; // for time
    private var _dateLayer; 
    private var _dayLayer;
    private var _stepsLayer;
    private var _heartrateLayer;
    private var _batteryLayer;
    private var _playing;
    var delegate;

    function initialize() {
        _playing = false;
    }

    function handleOnShow(view) {
        if( view.getLayers() == null ) {
            // Initialize the Animation
            _animation = new WatchUi.AnimationLayer(
                Rez.Drawables.saga,
                {
                    :locX=>0,
                    :locY=>0,
                }
                );

            // Build the time overlay
            _textLayer = buildTextLayer();
            _dateLayer = buildDateLayer();
            _dayLayer = buildDayLayer();
            _stepsLayer = buildStepsLayer();
            _heartrateLayer = buildHeartrateLayer();
            _batteryLayer = buildBatteryLayer();
            view.addLayer(_animation);
            view.addLayer(_textLayer);
            view.addLayer(_dateLayer);
            view.addLayer(_dayLayer);
            view.addLayer(_stepsLayer);
            view.addLayer(_heartrateLayer);
            view.addLayer(_batteryLayer);
        }

    }

    function handleOnHide(view) {
        view.clearLayers();
        _animation = null;
        _textLayer = null;
        _dateLayer = null;
        _dayLayer = null;
        _stepsLayer = null;
        _heartrateLayer = null;
        _batteryLayer = null;
    }

    // Function to initialize the time layer
    private function buildTextLayer() {
        var info = System.getDeviceSettings();
        // Word aligning the width and height for better blits
        // may have to reliang considering we are putting multiple text on a layer
        var width = 180;
        var height = (info.screenHeight * .25).toNumber();
        // System.println(Lang.format("initializing time(textlayer) $1$ width $2$ height", [width, height]));
        // var width = info.screenWidth;
        // var height = info.screenHeight;
        var options = {
            :locX => ( (info.screenWidth - width) / 2 ).toNumber() & ~0x03,
            :locY => (info.screenHeight - height),
            // :locX => 0,
            // :locY => 0,
            :width => width,
            :height => height,
            :visibility=>true
        };
        // Initialize the Time over the animation
        var textLayer = new WatchUi.Layer(options);
        return textLayer;
    }

    private function buildDateLayer() {
        var width = 200;
        var height = 30;
        // System.println(Lang.format("initializing dateLayer $1$ width $2$ height", [width, height]));
        var options = {
            :locX => 200,
            :locY => 130,
            // :locX => 0,
            // :locY => 0,
            :width => width,
            :height => height,
            :visibility=>true
        };
        return new WatchUi.Layer(options);
    }

    private function buildDayLayer() {
        var width = 72;
        var height = 30;
        // System.println(Lang.format("initializing DayLayer $1$ width $2$ height", [width, height]));
        var options = {
            :locX => 280,
            :locY => 160,
            // :locX => 0,
            // :locY => 0,
            :width => width,
            :height => height,
            :visibility=>true
        };
        return new WatchUi.Layer(options);
    }

    private function buildHeartrateLayer() {
        var width = 80;
        var height = 30;
        // System.println(Lang.format("initializing HeartrateLayer $1$ width $2$ height", [width, height]));
        var options = {
            :locX => 10,
            :locY => 160,
            // :locX => 0,
            // :locY => 0,
            :width => width,
            :height => height,
            :visibility=>true
        };
        return new WatchUi.Layer(options);
    }

    private function buildBatteryLayer() {
        var width = 80;
        var height = 30;
        // System.println(Lang.format("initializing BatteryLayer $1$ width $2$ height", [width, height]));
        var options = {
            :locX => 260,
            :locY => 100,
            // :locX => 0,
            // :locY => 0,
            :width => width,
            :height => height,
            :visibility=>true
        };
        return new WatchUi.Layer(options);
    }

    private function buildStepsLayer() {
        var width = 100;
        var height = 30;
        // System.println(Lang.format("initializing StepsLayer $1$ width $2$ height", [width, height]));
        var options = {
            :locX => 0,
            :locY => 130,
            // :locX => 0,
            // :locY => 0,
            :width => width,
            :height => height,
            :visibility=>true
        };
        return new WatchUi.Layer(options);
    }

    // modify this to return array of text layers, each with a specific area of the screen
    // returns specific order: hh:mm, DoM, MMM-DD, HB, BAT, STEPS.
    function getTextLayer() { return _textLayer; }

    function getDateLayer() { return _dateLayer; }

    function getDayLayer() { return _dayLayer; }

    function getHeartrateLayer() { return _heartrateLayer; }

    function getBatteryLayer() { return _batteryLayer; }

    function getStepsLayer() { return _stepsLayer; }

    function play() {
        if(!_playing) {
            delegate = new aqua_cat_animation_delegate();
            delegate.setController(self);
            _animation.play({:delegate => delegate});
            _playing = true;
        }
    }

    function loop() {
        if (delegate == null || !_playing) {
            play();
        } else {
            _animation.play({:delegate => delegate});
        }
    }

    function stop() {
        if(_playing) {
            _animation.stop();
            _playing = false;
        }
    }

}