class TextLayout extends GuiObject {

    //==========   ПЕРЕМЕННЫЕ   ==========//

    protected String _text = "";
    protected float _textSize = 24;
    protected color _textColor = color(255);
    protected color _textHoverColor = color(255);
    protected PFont _font = Roboto_reg;

    protected float _horIndent = -1;
    protected float _vertIndent = -1;



    //==========   КОНСТРУКТОРЫ   ==========//

    public TextLayout(float width, float height, String text) {
        _width = width;
        _height = height;
        _text = text;
        _horIndent = -1;
        _vertIndent = -1;
    }

    public TextLayout(String text, float horIndent, float vertIndent) {
        _width = -1;
        _height = -1;
        _text = text;
        _horIndent = horIndent;
        _vertIndent = vertIndent;
    }

    public TextLayout(String text) {
        this(text, 0, 0);
    }



    //==========   PROTECTED ПОЛЯ   ==========//

    protected boolean isMouseOver(){
        return mouseX >= _x && mouseX <= _x + _width && mouseY >= _y && mouseY <= _y + _height;
    }

    protected void update() {        
        textSize(_textSize);
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

        fill(_textColor);        
        textFont(_font, _textSize);
        textAlign(CENTER, BOTTOM);
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
