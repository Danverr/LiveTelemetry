public class Button extends TextLayout {

    //==========   ПЕРЕМЕННЫЕ   ==========//

    String _callback;

    protected color _buttonColor = color(0);
    protected color _buttonHoverColor = color(128);
    

    
    //==========   КОНСТРУКТОРЫ   ==========//

    public Button(PApplet context, float width, float height, String text, String callback) {
        super(context, width, height, text);
        _context.registerMethod("mouseEvent", this);
        _callback = callback;
        _isInteractive = true;
    }

    public Button(PApplet context, String text, String callback, float horIndent, float vertIndent) {
        super(context, text, horIndent, vertIndent);
        _context.registerMethod("mouseEvent", this);
        _callback = callback;
        _isInteractive = true;
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
        super.draw();
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