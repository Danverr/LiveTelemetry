public class Button extends GuiObject {

    //==========   ПЕРЕМЕННЫЕ   ==========//

    Layout _layout;

    String _callback = "";

    protected color _buttonColor = color(0);
    protected color _buttonHoverColor = color(128);
    
    Text _text;
    Shape _icon;
    protected color _contentColor = color(0);
    protected color _contentHoverColor = color(0);


    
    //==========   КОНСТРУКТОРЫ   ==========//

    public Button(PApplet context, float width, float height, String text, String icon) {
        _context = context;
        _context.registerMethod("mouseEvent", this);

        _width = width;
        _height = height;

        int size = 0;

        if(icon != "") {
            _icon = new Shape(context, icon);
            size++;            
        }

        if(text != ""){
            _text = new Text(context, text);
            size++;
        }
        
        if(_width != -1 && _height != -1){
            _layout = new Layout(context, width, height, size);
            _layout.setAlignType(SPACE_EVENLY);
        }else{
            _layout = new Layout(context, size);
        }

        if(_icon != null) _layout.add(_icon);
        if(_text != null) _layout.add(_text);
    }

    public Button(PApplet context, String text, String icon) {
        this(context, -1, -1, text, icon);
    }



    //==========   СОБЫТИЯ   ==========//

    public void mouseEvent(MouseEvent event) {
        if(_callback == "" || !_layout.isMouseOver()){
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
        boolean isMouseOver = _layout.isMouseOver();
        
        if (isMouseOver && _context.mousePressed){             
            _layout.setBackgroundColor(color(_buttonHoverColor, 128)); // Нажата кнопка мыши над кнопкой
            if(_text != null) _text.setTextColor(color(_contentHoverColor, 128));
            if(_icon != null) _icon.setColor(color(_contentHoverColor, 128));
        } else if (isMouseOver) {
            _layout.setBackgroundColor(_buttonHoverColor);             // Курсор сверху кнопки
            if(_text != null) _text.setTextColor(_contentHoverColor);
            if(_icon != null) _icon.setColor(_contentHoverColor); 
        } else {
            _layout.setBackgroundColor(_buttonColor);                  // Обычное состояние
            if(_text != null) _text.setTextColor(_contentColor);
            if(_icon != null) _icon.setColor(color(_contentColor));
        }

        _layout.draw();
    }

    public void moveTo(float x, float y){
        _layout.moveTo(x, y);
    }



    //==========   PUBLIC МЕТОДЫ: GETTERS   ==========//
    
    public float getWidth(){
        return _layout.getWidth();
    } //<>//

    public float getHeight(){
        return _layout.getHeight();
    }



    //==========   PUBLIC МЕТОДЫ: SETTERS   ==========//

    public void setButtonColor(color buttonColor){
        _buttonColor = buttonColor;
    }

    public void setButtonHoverColor(color buttonHoverColor){
        _buttonHoverColor = buttonHoverColor;
    }

    public void setContentColor(color contentColor){
        _contentColor = contentColor;
    }

    public void setContentHoverColor(color contentHoverColor){
        _contentHoverColor = contentHoverColor;
    }

    public void setCallback(String callback){
        _callback = callback;
    }

    public void setSpacing(float spacing){
        _layout.setSpacing(spacing);
    }

    public void setPadding(float mainBeg, float mainEnd, float crossLeft, float crossRight){
        _layout.setPadding(mainBeg, mainEnd, crossLeft, crossRight);
    }

    public void setPadding(float mainPadding, float crossPadding){
        _layout.setPadding(mainPadding, crossPadding);
    }

    public void setPadding(float padding){
        _layout.setPadding(padding);
    }

    public void setText(String text){
        _text.setText(text);
    }

    public void setTextSize(float textSize){
        _text.setTextSize(textSize);
    }

    public void setFont(PFont font){
        _text.setFont(font);
    }

}
