abstract class GuiObject {

    protected PApplet _context;

    protected float _x = 0;
    protected float _y = 0;

    protected float _width = -1;
    protected float _height = -1;

    abstract public void draw();
    
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