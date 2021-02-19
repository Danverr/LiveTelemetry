class LeftSidebar {
    
    private PApplet _context;
    
    Layout _layout;
    
    LeftSidebar(PApplet context) {
        _context = context;
        
        _layout = new Layout(context, SIDEBAR_WIDTH, context.height - STATUS_BAR_HEIGHT, 4);
        _layout.setOrientation(VERTICAL);
        _layout.setBackgroundColor(color(255, 255 * 0.2));
        _layout.setDistribution(SPACE_EVENLY);
        _layout.moveTo(0, STATUS_BAR_HEIGHT);
        
        // Таймер
        timer = new Timer(_context);
        _layout.add(timer);
        
        // Стадии полета
        flightStages = new FlightStages(_context, timer, stages);
        _layout.add(flightStages);
        
        // GPS Координаты
        gpsCoordinates = new GpsCoordinates(context);
        _layout.add(gpsCoordinates);
        
        // Лого
        Shape logo = new Shape(_context, "galaktika.svg");
        logo.setColor(color(0, 128));
        _layout.add(logo);
    }
    
    public void draw() {
        _layout.draw();
    }
    
}
