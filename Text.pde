class Text extends GuiObject {

    //==========   ПЕРЕМЕННЫЕ   ==========//

    protected String _text = "";
    protected float _textSize = 24;
    protected color _textColor = color(0);
    protected PFont _font = Roboto_reg;



    //==========   КОНСТРУКТОРЫ   ==========//

    public Text(PApplet context, String text) {
        _context = context;
        _text = text;
    }



    //==========   PUBLIC МЕТОДЫ   ==========// 

    public void draw() {
        super.draw();

        fill(_textColor);
        textAlign(LEFT, TOP);
        textFont(_font, _textSize);
        text(_text, _x, _y);
    }



    //==========   PUBLIC МЕТОДЫ: GETTERS   ==========//

    public float getWidth(){
        textFont(_font, _textSize);
        return textWidth(_text);
    }

    public float getHeight(){
        return _textSize;
    }



    //==========   PUBLIC МЕТОДЫ: SETTERS   ==========//

    public void setText(String text){
        _text = text;
    }

    public void setTextSize(float textSize){
        _textSize = textSize;
    }

    public void setColor(color textColor){
        _textColor = textColor;
    }

    public void setFont(PFont font){
        _font = font;
    }

}
