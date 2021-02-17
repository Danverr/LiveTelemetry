class Shape extends GuiObject {

    //==========   ПЕРЕМЕННЫЕ   ==========//

    protected PShape _shape;

    protected color _shapeColor = color(0);



    //==========   КОНСТРУКТОРЫ   ==========//

    public Shape(PApplet context, String filename) {
        _context = context;
        
        _shape = loadShape(filename);
        _shape.disableStyle();

        _width = _shape.width;
        _height = _shape.height;
    }

    public Shape(PApplet context, String filename, float width, float height) {
        this(context, filename);
        _width = width;
        _height = height;
    }



    //==========   PUBLIC МЕТОДЫ   ==========// 

    public void draw() {
        super.draw();

        shapeMode(CORNER);
        fill(_shapeColor);

        if(_width != -1 && _height != -1){
            shape(_shape, _x, _y, _width, _height);
        }else{
            shape(_shape, _x, _y);
        }
    }



    //==========   PUBLIC МЕТОДЫ: GETTERS   ==========//

    public float getWidth(){
        return _width;
    }

    public float getHeight(){
        return _height;
    }



    //==========   PUBLIC МЕТОДЫ: SETTERS   ==========//

    public void setColor(color shapeColor){
        _shapeColor = shapeColor;
    }

}
