final int AUTO = -1;

final int HORIZONTAL = 0; 
final int VERTICAL = 1;

final int FORWARD = 0;
final int BACKWARD = 1;

// final int LEFT = system variable;
// final int CENTER = system variable;
// final int RIGHT = system variable;
// final int TOP = system variable;
// final int BOTTOM = system variable;

final int PACKED = 0;
final int SPACE_BETWEEN = 1;
final int SPACE_EVENLY = 2;

public class Layout extends GuiObject {

    //==========   ПЕРЕМЕННЫЕ   ==========// 

    protected GuiObject[] _layout;

    protected float _spacing = 0;
    protected float _padding[] = { 0, 0, 0, 0 }; // mainBeg, mainEnd, crossLeft, crossRight
    protected int _size = 0;

    protected int _orientation = HORIZONTAL;
    protected int _direction = FORWARD;
    protected int _align = CENTER;
    protected int _distribution = PACKED; // При не фиксированном размере может быть только PACKED!

    protected color _backgroundColor = color(0, 1);
    int[] _cornerRadius = new int[4];

    PVector _layoutSize;
    PVector _contentSize;



    //==========   КОНСТРУКТОРЫ   ==========// 

    Layout(){
    }
    
    Layout(PApplet context, int size){
        this(context, AUTO, AUTO, size);        
    }

    Layout(PApplet context, float width, float height, int size){
        super(context, width, height);
        _layout = new GuiObject[size];
    }



    //==========   PRIVATE МЕТОДЫ   ==========// 

    private void update(){
        updateSize();

        PVector mainAxis = getMainAxis(true);
        PVector crossAxis = getCrossAxis();

        // Устанавливаем позицию с нужного нам конца
        PVector pos = new PVector(_x, _y);
        if(_direction == BACKWARD){
            pos.sub(multByCoords(mainAxis, _layoutSize));
        }
        
        // Делаем первый отступ от края по главной оси
        pos.add(mainAxis.copy().mult(_padding[0]));
        
        // Если SPACE_EVENLY, то нужно сделать еще отступ
        if (_distribution == SPACE_EVENLY) pos.add(mainAxis.copy().mult(_spacing));

        for(int i = 0; i < _size; i++){
            // Считаем размеры и позицию компонента Layout
            PVector itemSize = new PVector(_layout[i].getWidth(), _layout[i].getHeight());
            PVector itemPos = pos.copy();
            
            // Рассчитываем новую позицию с учетом выравнивания
            if(_align == LEFT || _align == TOP){
                itemPos.add(crossAxis.copy().mult(_padding[2]));
            }else if (_align == CENTER){
                itemPos.add(multByCoords(_layoutSize.copy().sub(itemSize).div(2), crossAxis));
            } else if (_align == RIGHT || _align == BOTTOM){
                itemPos.add(multByCoords(_layoutSize.copy().sub(itemSize), crossAxis));
                itemPos.sub(crossAxis.copy().mult(_padding[3]));
            }

            if(_direction == BACKWARD){
                itemPos.add(multByCoords(itemSize, mainAxis));
            }

            // Задаем новую позицию
            _layout[i].moveTo(itemPos.x, itemPos.y);

            // Двигаем нашу позицию по главной оси
            pos.add(multByCoords(itemSize.copy().add(_spacing, _spacing), mainAxis));
        }
    }

    private void updateSize() {
        _contentSize = getContentSize();
        _layoutSize = getLayoutSize();
    }

    private PVector getLayoutSize(){ // Вызывать только с актуальным _contentSize!!!
        PVector mainAxis = getMainAxis(false);
        PVector crossAxis = getCrossAxis();
        PVector layoutSize = new PVector(_width, _height);            

        if(_width == AUTO) layoutSize.x = _contentSize.x;
        if(_height == AUTO) layoutSize.y = _contentSize.y;

        if(isMainAxisSizeFixed()) {
            // Если размеры уже заданы, обновляем растояния между объектами            
            float freeSpace = multByCoords(layoutSize, mainAxis).mag();
            freeSpace -= multByCoords(_contentSize, mainAxis).mag();
            freeSpace -= _padding[0] + _padding[1];

            if (_distribution == SPACE_BETWEEN){
                if(_size == 1) _spacing = 0;
                else _spacing = freeSpace / (_size - 1);
            } else if (_distribution == SPACE_EVENLY){
                _spacing = freeSpace / (_size + 1);         
            }            
        }else if(_distribution == PACKED) { 
            // Если размеры не заданы и внутри Layout что-то есть,
            // посчитаем размер исходя из отступов и размера контента
            layoutSize.add(mainAxis.copy().mult(_padding[0] + _padding[1] + (_size - 1) * _spacing));
            layoutSize.add(crossAxis.copy().mult(_padding[2] + _padding[3]));
        }

        return layoutSize;
    }

    private PVector getContentSize(){
        PVector mainAxis = getMainAxis(false);
        PVector crossAxis = getCrossAxis();
        PVector contentSize = new PVector(0, 0);

        for(int i = 0; i < _size; i++){
            // Считаем размеры компонента Layout
            PVector itemSize = new PVector(_layout[i].getWidth(), _layout[i].getHeight());
            PVector itemMainSize = multByCoords(itemSize, mainAxis);
            PVector itemCrossSize = multByCoords(itemSize, crossAxis);
            contentSize.add(itemMainSize);
            
            // Считаем максимальный размер по поперечной оси
            // Это и есть размер контента по поперечной оси
            if(itemCrossSize.mag() > multByCoords(contentSize, crossAxis).mag()){
                contentSize = multByCoords(contentSize, mainAxis);
                contentSize.add(itemCrossSize);
            }
        }

        return contentSize;
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

    protected boolean isMainAxisSizeFixed(){
        if(_orientation == HORIZONTAL){
            return _width != AUTO;
        }else if(_orientation == VERTICAL){
            return _height != AUTO;
        }

        return false;
    }


    //==========   PROTECTED МЕТОДЫ   ==========// 

    protected boolean isMouseOver(){
        updateSize();
        return mouseX >= _x && mouseX <= _x + _layoutSize.x && mouseY >= _y && mouseY <= _y + + _layoutSize.y;
    }



    //==========   PUBLIC МЕТОДЫ   ==========// 

    public void draw(){
        super.draw();
        update();

        // Фон
        if(_backgroundColor != TRANSPARENT){
            noStroke();
            fill(_backgroundColor);
            rect(
                _x, _y, _layoutSize.x, _layoutSize.y,
                _cornerRadius[0], _cornerRadius[1], _cornerRadius[2], _cornerRadius[3]
            );            
        }

        // Внутренние компоненты
        for(int i = 0; i < _size; i++){
            _layout[i].draw();
        }
    }

    public void add(GuiObject item){
        _layout[_size++] = item;
    }

    //==========   PUBLIC МЕТОДЫ: GETTERS   ==========//

    public float getWidth(){
        updateSize();
        return _layoutSize.x;
    }

    public float getHeight(){
        updateSize();
        return _layoutSize.y;
    }



    //==========   PUBLIC МЕТОДЫ: SETTERS   ==========//

    public void setSpacing(float spacing){
        _spacing = spacing;
    }

    public void setCornerRadius(int r1, int r2, int r3, int r4){
        _cornerRadius[0] = r1;
        _cornerRadius[1] = r2;
        _cornerRadius[2] = r3;
        _cornerRadius[3] = r4;
    }

    public void setCornerRadius(int rad){
        _cornerRadius[0] = _cornerRadius[1] = _cornerRadius[2] = _cornerRadius[3] = rad;
    }

    public void setPadding(float mainBeg, float mainEnd, float crossLeft, float crossRight){
        _padding[0] = mainBeg;
        _padding[1] = mainEnd;
        _padding[2] = crossLeft;
        _padding[3] = crossRight;
    }

    public void setPadding(float mainPadding, float crossPadding){
        _padding[0] = _padding[1] = mainPadding;
        _padding[2] = _padding[3] = crossPadding;
    }

    public void setPadding(float padding){
        _padding[0] = _padding[1] = _padding[2] = _padding[3] = padding;
    }
    
    public void setOrientation(int orientation){
        if(orientation != VERTICAL && orientation != HORIZONTAL){
            throw new Error("Orientation can only be VERTICAL or HORIZONTAL");
        }

        _orientation = orientation;
    }

    public void setDirection(int direction){
        if(direction != FORWARD && direction != BACKWARD){
            throw new Error("Direction can only be FORWARD or BACKWARD");
        }

        _direction = direction;
    }

    public void setAlign(int align){
        if(_orientation == VERTICAL && align != LEFT && align != CENTER && align != RIGHT) {
            throw new Error("Vertical align can only be LEFT, CENTER or RIGHT");
        } else if(_orientation == HORIZONTAL && align != TOP && align != CENTER && align != BOTTOM) {
            throw new Error("Horizontal align can only be TOP, CENTER or BOTTOM");
        }

        _align = align;
    }

    public void setDistribution(int distribution){
        if(distribution != PACKED && distribution != SPACE_BETWEEN && distribution != SPACE_EVENLY) {
            throw new Error("Align type can only be PACKED, SPACE_BETWEEN or SPACE_EVENLY");
        } else if (!isMainAxisSizeFixed() && distribution != PACKED) {
            throw new Error("Align type of Layout with non-fixed size can only be PACKED");
        }

        _distribution = distribution;
    }

    public void setBackgroundColor(color backgroundColor){
        _backgroundColor = backgroundColor;
    }

}
