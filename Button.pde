public class Button extends TextLayout {

    //==========   ПЕРЕМЕННЫЕ   ==========//

    protected PApplet _context;

    String _callback;

    protected color _buttonColor = color(0);
    protected color _buttonHoverColor = color(128);
    

    
    //==========   КОНСТРУКТОРЫ   ==========//

    public Button(PApplet context, float width, float height, String text, String callback) {
        super(width, height, text);
        _context = context;
        _context.registerMethod("mouseEvent", this);
        _callback = callback;
    }

    public Button(PApplet context, String text, String callback, float horIndent, float vertIndent) {
        super(text, horIndent, vertIndent);
        _context = context;
        _context.registerMethod("mouseEvent", this);
        _callback = callback;
    }

    public Button(PApplet context, String text, String callback) {        
        this(context, text, callback, 0, 0);
    }



    //==========   СОБЫТИЯ   ==========//

    public void mouseEvent(MouseEvent event) {
        if(!isMouseOver()){
            return;
        }

        switch (event.getAction()) {
            case MouseEvent.CLICK:
                method(_callback);
                break;
        }
    }



    //==========   PUBLIC МЕТОДЫ   ==========// 

    @Override
    public void draw(){
        if(_width == -1 && _height == -1){
            update();
        }

        // Фон кнопки
        if (isMouseOver() && _context.mousePressed) fill(color(_buttonHoverColor, 128));
        else if (isMouseOver()) fill(_buttonHoverColor);
        else fill(_buttonColor);
        
        noStroke();
        rect(_x, _y, _width, _height);

        // Текст
        if (isMouseOver() && _context.mousePressed) fill(color(_textHoverColor, 128));
        else if (isMouseOver()) fill(_textHoverColor);
        else fill(_textColor);

        textFont(_font, _textSize);
        textAlign(CENTER, BOTTOM);        
        text(_text, _x + _width / 2, _y + _height / 2 + _textSize / 2 + 1);
    }



    //==========   PUBLIC МЕТОДЫ: СЕТТЕРЫ   ==========//

    public void setButtonColor(color buttonColor){
        _buttonColor = buttonColor;
    }

    public void setButtonHoverColor(color buttonHoverColor){
        _buttonHoverColor = buttonHoverColor;
    }

    public void setTextHoverColor(color textHoverColor){
        _textHoverColor = textHoverColor;
    }

}