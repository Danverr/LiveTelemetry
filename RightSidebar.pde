class RightSidebar {
    
    private PApplet _context;
    
    Layout _layout;
    
    RightSidebar(PApplet context) {
        _context = context;
        
        _layout = new Layout(context, SIDEBAR_WIDTH, context.height - STATUS_BAR_HEIGHT, 4);
        _layout.setOrientation(VERTICAL);
        _layout.setBackgroundColor(color(255, 255 * 0.2));
        _layout.setDistribution(SPACE_EVENLY);
        _layout.moveTo(context.width - SIDEBAR_WIDTH, STATUS_BAR_HEIGHT);
        
        // График высоты
        GraphWrapper heightGraph = new GraphWrapper(
            context,
            PLOT_WIDTH, PLOT_HEIGHT,
            "Высота", "м",
            new String[]{ "height" }
        );
        _layout.add(heightGraph);

        // График скорости
        GraphWrapper velocityGraph = new GraphWrapper(
            context,
            PLOT_WIDTH, PLOT_HEIGHT,
            "Скорость", "м/c",
            new String[]{ "xVelocity", "yVelocity", "zVelocity" }
        );
        _layout.add(velocityGraph);

        // График ускорения
        GraphWrapper accelerationGraph = new GraphWrapper(
            context,
            PLOT_WIDTH, PLOT_HEIGHT,
            "Ускорение", "м/c^2",
            new String[]{ "xAcceleration", "yAcceleration", "zAcceleration" }
        );
        _layout.add(accelerationGraph);
    }
    
    public void draw() {
        _layout.draw();
    }
    
}
