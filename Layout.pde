final int HORIZONTAL = 0; 
final int VERTICAL = 1;

final int FORWARD = 0;
final int BACKWARD = 1;

// final int LEFT = system variable;
// final int CENTER = system variable;
// final int RIGHT = system variable;

final int PACKED = 0;
final int SPACE_BETWEEN = 1;
final int SPACE_EVENLY = 2;

public class Layout extends GuiObject {

    //==========   ПЕРЕМЕННЫЕ   ==========// 

    protected GuiObject[] _layout;

    protected float _spacing = 0;
    protected float _padding = 0;
    protected int _size = 0;

    protected int _orientation = HORIZONTAL;
    protected int _direction = FORWARD;
    protected int _align = CENTER;
    protected int _alignType = PACKED;

    protected color _backgroundColor = color(0, 1);

    PVector _layoutSize;
    PVector _contentSize;



    //==========   КОНСТРУКТОРЫ   ==========// 

    Layout(){
    }
    
    Layout(int size){
        _layout = new GuiObject[size];
    }

    Layout(float width, float height, int size){
        this(size);
        _width = width;
        _height = height;
    }



    //==========   PROTECTED МЕТОДЫ   ==========// 

    protected void update(){
        updateSize();

        PVector pos = new PVector(_x, _y);
        PVector mainAxis = getMainAxis(true);
        PVector crossAxis = getCrossAxis();

        if(_size > 0){
            float freeSpace = multByCoords(_layoutSize, mainAxis).mag();
            freeSpace -= multByCoords(_contentSize, mainAxis).mag() + 2 * _padding;

            if (_alignType == SPACE_BETWEEN){
                _spacing = freeSpace / (_size - 1);
            } else if (_alignType == SPACE_EVENLY){
                _spacing = freeSpace / (_size + 1);                
            }
        }

        pos.add(mainAxis.copy().mult(_padding));
        if (_alignType == SPACE_EVENLY) pos.add(mainAxis.copy().mult(_spacing));

        for(int i = 0; i < _size; i++){
            PVector itemSize = new PVector(_layout[i].getWidth(), _layout[i].getHeight());
            PVector itemPos = pos.copy();

            if (_align == CENTER){
                itemPos.add(multByCoords(_layoutSize.copy().sub(itemSize).div(2), crossAxis));
            } else if (_align == RIGHT){
                itemPos.add(multByCoords(_layoutSize.copy().sub(itemSize), crossAxis));
            }

            _layout[i].moveTo(itemPos.x, itemPos.y);
            pos.add(multByCoords(itemSize.copy().add(_spacing, _spacing), mainAxis));
        }
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

    protected void updateSize() {
        PVector mainAxis = getMainAxis(false);
        PVector crossAxis = getCrossAxis();
        PVector layoutSize = new PVector(0, 0);
        PVector contentSize = new PVector(0, 0);

        if(_width != -1 && _height != -1) {
            layoutSize = new PVector(_width, _height);
        }else if(_size != 0) {
            layoutSize.add(mainAxis.copy().mult(2 * _padding + (_size - 1) * _spacing));
        }        

        for(int i = 0; i < _size; i++){
            PVector itemSize = new PVector(_layout[i].getWidth(), _layout[i].getHeight());
            PVector itemMainCoord = multByCoords(itemSize, mainAxis);
            PVector itemCrossCoord = multByCoords(itemSize, crossAxis);
            contentSize.add(itemSize);

            if(_width == -1 && _height == -1) {
                layoutSize.add(itemMainCoord);            

                if(itemCrossCoord.mag() > multByCoords(layoutSize, crossAxis).mag()){
                    layoutSize = multByCoords(layoutSize, mainAxis);
                    layoutSize.add(itemCrossCoord);
                }
            }
        }

        _layoutSize = layoutSize;
        _contentSize = contentSize;
    }



    //==========   PUBLIC МЕТОДЫ   ==========// 

    public void draw(){
        update();

        // Фон
        noStroke();
        fill(_backgroundColor);
        rect(_x, _y, _layoutSize.x, _layoutSize.y);

        // Внутренние компоненты
        for(int i = 0; i < _size; i++){
            _layout[i].draw();
        }
    }

    public void add(GuiObject item){
        _layout[_size++] = item;
    }

    //==========   PUBLIC МЕТОДЫ: ГЕТТЕРЫ   ==========//

    public float getWidth(){
        updateSize();
        return _layoutSize.x;
    }

    public float getHeight(){
        updateSize();
        return _layoutSize.y;
    }



    //==========   PUBLIC МЕТОДЫ: СЕТТЕРЫ   ==========//

    public void setSpacing(float spacing){
        _spacing = spacing;
    }

    public void setPadding(float padding){
        _padding = padding;
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

    public void setAlignType(int alignType){
        _alignType = alignType;
    }

    public void setBackgroundColor(color backgroundColor){
        _backgroundColor = backgroundColor;
    }

}
