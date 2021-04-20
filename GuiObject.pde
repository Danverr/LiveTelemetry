abstract class GuiObject {

    protected PApplet _context;

    protected float _x = 0;
    protected float _y = 0;

    protected float _width = -1;
    protected float _height = -1;

    protected int _lastFrameCount = -1;
    protected boolean _isVisible = true;
    
    GuiObject(){
    }

    GuiObject(PApplet context){
        this(context, -1, -1);
    }

    GuiObject(PApplet context, float width, float height){
        _context = context;
        _width = width;
        _height = height;
    }

    public void draw() {        
        _lastFrameCount = _context.frameCount;
    };

    public boolean isVisible() {
        return _lastFrameCount >= _context.frameCount;
    }
    
    public float getWidth(){
        return _width;
    };
    
    public float getHeight(){
        return _height;
    };

    public void moveTo(float x, float y){
        if(_x == x && _y == y) return;
        _x = x;
        _y = y;
    };

}
