public class TextLayout {

    //==========   ПЕРЕМЕННЫЕ   ==========//

    protected float _x = 0;
    protected float _y = 0;

    protected float _width = -1;
    protected float _height = -1;

    protected String _text = "";
    protected int _textSize = 24;
    public color _textColor = color(255);
    public color _textHoverColor = color(255);

    protected float _horIndent = -1;
    protected float _vertIndent = -1;



    //==========   КОНСТРУКТОРЫ   ==========//

    public TextLayout(float width, float height, String text) {
        _width = width;
        _height = height;
        _text = text;
    }

    public TextLayout(String text, float horIndent, float vertIndent) {
        _text = text;
        _horIndent = horIndent;
        _vertIndent = vertIndent;
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
        }else{
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
        textSize(_textSize);
        textAlign(CENTER, BOTTOM);
        text(_text, _x + _width / 2, _y + _height / 2 + _textSize / 2);        
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

    public void moveTo(float x, float y){
        _x = x;
        _y = y;
    }

    public void setText(String text){
        _text = text;
        update();
    }

    public void setTextSize(int textSize){
        _textSize = textSize;
        update();
    }

}
