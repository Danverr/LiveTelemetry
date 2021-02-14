class TextLayout extends GuiObject {

    //==========   ПЕРЕМЕННЫЕ   ==========//

    protected PApplet _context;

    protected String _text = "";
    protected float _textSize = 24;
    protected color _textColor = color(255);
    protected color _textHoverColor = color(255);
    protected PFont _font = Roboto_reg;
    protected boolean _isInteractive = false;

    protected float _horIndent = -1;
    protected float _vertIndent = -1;



    //==========   КОНСТРУКТОРЫ   ==========//

    public TextLayout(PApplet context, float width, float height, String text) {
        _context = context;
        _width = width;
        _height = height;
        _text = text;
        _horIndent = -1;
        _vertIndent = -1;
    }

    public TextLayout(PApplet context, String text, float horIndent, float vertIndent) {
        _context = context;
        _width = -1;
        _height = -1;
        _text = text;
        _horIndent = horIndent;
        _vertIndent = vertIndent;
    }

    public TextLayout(PApplet context, String text) {
        this(context, text, 0, 0);
    }



    //==========   PROTECTED ПОЛЯ   ==========//

    protected boolean isMouseOver(){
        return mouseX >= _x && mouseX <= _x + _width && mouseY >= _y && mouseY <= _y + _height;
    }

    protected void update() {
        textFont(_font, _textSize);
        float textWidth = textWidth(_text);

        if(_horIndent != -1 && _vertIndent != -1){
            _width = textWidth + 2 * _horIndent;
            _height = _textSize + 2 * _vertIndent;
        }else if(_width != -1 && _height != -1){
            _horIndent = (_width - textWidth) / 2;
            _vertIndent = (_height - _textSize) / 2;
        }
    }



    //==========   PUBLIC МЕТОДЫ   ==========// 

    public void draw() {      
        if(_width == -1 && _height == -1){
            update();
        }

        if(_isInteractive){
            if (isMouseOver() && _context.mousePressed) fill(color(_textHoverColor, 128));
            else if (isMouseOver()) fill(_textHoverColor);
            else fill(_textColor);
        }else{
            fill(_textColor);
        }        
        
        textAlign(CENTER, BOTTOM);
        textFont(_font, _textSize);
        text(_text, _x + _width / 2, _y + _height / 2 + _textSize / 2 + 1);
    }



    //==========   PUBLIC МЕТОДЫ: ГЕТТЕРЫ   ==========//

    public float getWidth(){
        update();
        return _width;
    }

    public float getHeight(){
        update();
        return _height;
    }



    //==========   PUBLIC МЕТОДЫ: СЕТТЕРЫ   ==========//

    public void setText(String text){
        _text = text;
        update();
    }

    public void setTextSize(float textSize){
        _textSize = textSize;
        update();
    }

    public void setTextColor(color textColor){
        _textColor = textColor;
    }

    public void setFont(PFont font){
        _font = font;
        update();
    }

}
