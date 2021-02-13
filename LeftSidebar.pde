class LeftSidebar {

    PApplet _context;

    private float _x = 0;
    private float _y = 0;

    private float _width = SIDEBAR_WIDTH;
    private float _height = -1;

    private Layout _layout;
    Timer _timer;

    LeftSidebar(PApplet context) {
        _context = context;
        _height =  _context.height - STATUS_BAR_HEIGHT;
        
        _layout = new Layout(_width, _height, 4);
        _layout.setOrientation(VERTICAL);
        _layout.setIndents(64);
        _layout.moveTo(0, STATUS_BAR_HEIGHT);
        
        // Таймер
        _timer = new Timer(_context);
        _layout.add(_timer);
    }

    public void draw() {  

        // Фон
        noStroke();
        fill(255, 255 * 0.2);
        rect(0, STATUS_BAR_HEIGHT, _width, _height);

        // Внутренние компоненты
        _layout.draw();
        
    }

}
