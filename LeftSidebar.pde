public class LeftSidebar {
  
    private PApplet _context;

    Layout _layout;
    private Timer _timer;
    private FlightStages _flightStages;
    private Shape _logo;

    private boolean _isFlight = false;

    LeftSidebar(PApplet context) {
        _layout = new Layout(context, SIDEBAR_WIDTH, context.height - STATUS_BAR_HEIGHT, 4);
        
        _context = context;
        _context.registerMethod("mouseEvent", this);
        
        _layout.setOrientation(VERTICAL);
        _layout.setBackgroundColor(color(255, 255 * 0.2));
        _layout.setAlignType(SPACE_EVENLY);
        _layout.moveTo(0, STATUS_BAR_HEIGHT);
        
        // Таймер
        _timer = new Timer(_context);
        _layout.add(_timer);

        // Стадии полета
        _flightStages = new FlightStages(_context);
        _layout.add(_flightStages);

        // Лого
        _logo = new Shape(_context, "GALAKTIKA.svg");
        _logo.setColor(color(128));
        _layout.add(_logo);
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

    public void draw(){
        _layout.draw();
    }

}
