public class LeftSidebar extends Layout {

    PApplet _context;

    private Timer _timer;
    private FlightStages _flightStages;

    private boolean _isFlight = false;

    LeftSidebar(PApplet context) {
        super(SIDEBAR_WIDTH, context.height - STATUS_BAR_HEIGHT, 4);
        
        _context = context;
        _context.registerMethod("mouseEvent", this);
        
        setOrientation(VERTICAL);
        setBackgroundColor(color(255, 255 * 0.2));
        setAlignType(SPACE_EVENLY);
        moveTo(0, STATUS_BAR_HEIGHT);
        
        // Таймер
        _timer = new Timer(_context);
        add(_timer);

        // Стадии полета
        _flightStages = new FlightStages(_context);
        add(_flightStages);
    }

    public void mouseEvent(MouseEvent event) {
        switch (event.getAction()) {
            case MouseEvent.CLICK:
                if(!_isFlight){
                    _isFlight = true;
                    _timer.setStartTime();
                }
                
                _flightStages.nextStage(_timer.getMissionTime());                
                break;
        }
    }

}
