final int HORIZONTAL = 0; 
final int VERTICAL = 1;

final int FORWARD = 0;
final int BACKWARD = 1;

final int LEFT_ALIGHT = 0;
final int RIGHT_ALIGN = 1;
final int CENTER_ALIGN = 2;

public class Layout extends GuiObject {

    //==========   ПЕРЕМЕННЫЕ   ==========// 

    protected GuiObject[] _list;

    protected float _spacing = 0;
    protected float _indents = 0;
    protected int _size = 0;

    protected int _orientation = HORIZONTAL;
    protected int _direction = FORWARD;
    protected int _align = CENTER_ALIGN;

    protected color _backgroundColor = color(0, 1);



    //==========   КОНСТРУКТОРЫ   ==========// 

    Layout(float width, float height, int size){
        this(size);
        _width = width;
        _height = height;
    }
    
    Layout(int size){
        _list = new GuiObject[size];
    }



    //==========   PROTECTED МЕТОДЫ   ==========// 

    protected PVector update(){        
        PVector pos = new PVector(_x, _y);
        PVector layoutSize = getSize();
        PVector mainAxis = getMainAxis(true);
        PVector crossAxis = getCrossAxis();

        pos.add(mainAxis.copy().mult(_indents));

        for(int i = 0; i < _size; i++){
            PVector itemSize = new PVector(_list[i].getWidth(), _list[i].getHeight());
            PVector itemPos = pos.copy();

            if (_align == CENTER_ALIGN){
                itemPos.add(multByCoords(layoutSize.copy().sub(itemSize).div(2), crossAxis));
            } else if (_align == RIGHT_ALIGN){
                itemPos.add(multByCoords(layoutSize.copy().sub(itemSize), crossAxis));
            }

            _list[i].moveTo(itemPos.x, itemPos.y);
            pos.add(multByCoords(itemSize.copy().add(_spacing, _spacing), mainAxis));
        }

        return layoutSize;
    }

    protected PVector getMainAxis(boolean withDirection) {        
        float dir = (_direction == FORWARD) ? 1 : -1; 
        PVector res = new PVector(int(_orientation == HORIZONTAL), int(_orientation == VERTICAL));
        if(withDirection) res = res.mult(dir);
        return res;
    }

    protected PVector getCrossAxis() {
        return new PVector(int(_orientation == VERTICAL), int(_orientation == HORIZONTAL));
    }

    protected PVector getSize() {
        if(_width != -1 && _height != -1) return new PVector(_width, _height);
        if(_size == 0) return new PVector(0, 0);

        PVector mainAxis = getMainAxis(false);
        PVector crossAxis = getCrossAxis();
        PVector layoutSize = new PVector(0, 0);
            
        layoutSize.add(mainAxis.copy().mult(2 * _indents + (_size - 1) * _spacing));

        for(int i = 0; i < _size; i++){
            PVector itemSize = new PVector(_list[i].getWidth(), _list[i].getHeight());
            PVector itemMainCoord = multByCoords(itemSize, mainAxis);
            PVector itemCrossCoord = multByCoords(itemSize, crossAxis);

            layoutSize.add(itemMainCoord);

            if(itemCrossCoord.mag() > multByCoords(layoutSize, crossAxis).mag()){
                layoutSize = multByCoords(layoutSize, mainAxis);
                layoutSize.add(itemCrossCoord);
            }
        }

        return layoutSize;
    }



    //==========   PUBLIC МЕТОДЫ   ==========// 

    public void draw(){
        PVector layoutSize = update();

        // Фон
        noStroke();
        fill(_backgroundColor);
        rect(_x, _y, layoutSize.x, layoutSize.y);

        // Внутренние компоненты
        for(int i = 0; i < _size; i++){
            _list[i].draw();
        }
    }

    public void add(GuiObject item){
        _list[_size++] = item;
    }

    //==========   PUBLIC МЕТОДЫ: ГЕТТЕРЫ   ==========//

    public float getWidth(){
        return getSize().x;
    }

    public float getHeight(){
        return getSize().y;
    }



    //==========   PUBLIC МЕТОДЫ: СЕТТЕРЫ   ==========//

    public void setSpacing(float spacing){
        _spacing = spacing;
    }

    public void setIndents(float indents){
        _indents = indents;
    }
    
    public void setOrientation(int orientation){
        _orientation = orientation;
    }

    public void setDirection(int direction){
        _direction = direction;
    }

    public void setAlign(int align){
        _align = align;
    }

    public void setBackgroundColor(color backgroundColor){
        _backgroundColor = backgroundColor;
    }

}
