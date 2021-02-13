abstract class GuiObject {

    protected float _x = 0;
    protected float _y = 0;

    protected float _width = -1;
    protected float _height = -1;

    abstract public void draw();
    abstract public float getWidth();
    abstract public float getHeight();

    public void moveTo(float x, float y){
        if(_x == x && _y == y) return;
        _x = x;
        _y = y;
    };

}