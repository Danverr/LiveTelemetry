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
    protected float _padding[] = { 0, 0, 0, 0 }; // mainBeg, mainEnd, crossLeft, crossRight
    protected int _size = 0;

    protected int _orientation = HORIZONTAL;
    protected int _direction = FORWARD;
    protected int _align = CENTER;
    protected int _alignType = PACKED; // При не фиксированном размере может быть только PACKED!

    protected color _backgroundColor = color(0, 1);

    PVector _layoutSize;
    PVector _contentSize;
    protected boolean _fixedSize = false;



    //==========   КОНСТРУКТОРЫ   ==========// 

    Layout(){
    }
    
    Layout(PApplet context, int size){
        _context = context; 
        _layout = new GuiObject[size];
    }

    Layout(PApplet context, float width, float height, int size){
        this(context, size);     
        _width = width;
        _height = height;
        _fixedSize = true;
    }



    //==========   PROTECTED МЕТОДЫ   ==========// 

    protected void update(){
        updateSize();

        PVector pos = new PVector(_x, _y);
        PVector mainAxis = getMainAxis(true);
        PVector crossAxis = getCrossAxis();

        // Делаем первый отступ от края по главной оси
        pos.add(mainAxis.copy().mult(_padding[0]));
        
        // Если SPACE_EVENLY, то нужно сделать еще отступ
        if (_alignType == SPACE_EVENLY) pos.add(mainAxis.copy().mult(_spacing));

        for(int i = 0; i < _size; i++){
            // Считаем размеры и позицию компонента Layout
            PVector itemSize = new PVector(_layout[i].getWidth(), _layout[i].getHeight());
            PVector itemPos = pos.copy();
            
            // Рассчитываем новую позицию с учетом выравнивания
            if (_align == CENTER){
                itemPos.add(multByCoords(_layoutSize.copy().sub(itemSize).div(2), crossAxis));
            } else if (_align == RIGHT){
                itemPos.add(multByCoords(_layoutSize.copy().sub(itemSize), crossAxis));
            }

            // Задаем новую позицию
            _layout[i].moveTo(itemPos.x, itemPos.y);

            // Двигаем нашу позицию по главной оси
            pos.add(multByCoords(itemSize.copy().add(_spacing, _spacing), mainAxis));
        }
    }

    protected void updateSize() {
        _contentSize = getContentSize();
        _layoutSize = getLayoutSize();
    }

    protected PVector getLayoutSize(){ // Вызывать только с актуальным _contentSize!!!
        PVector mainAxis = getMainAxis(false);
        PVector crossAxis = getCrossAxis();
        PVector layoutSize = new PVector(0, 0);

        if(_fixedSize) {
            // Если размеры уже заданы, обновляем растояния между объектами
            layoutSize = new PVector(_width, _height);
            
            float freeSpace = multByCoords(layoutSize, mainAxis).mag();
            freeSpace -= multByCoords(_contentSize, mainAxis).mag();
            freeSpace -= _padding[0] + _padding[1];

            if (_alignType == SPACE_BETWEEN){
                if(_size == 1) _spacing = 0;
                else _spacing = freeSpace / (_size - 1);
            } else if (_alignType == SPACE_EVENLY){
                _spacing = freeSpace / (_size + 1);         
            }            
        }else if(_alignType == PACKED && _size != 0) { 
            // Если размеры не заданы и внутри Layout что-то есть,
            // посчитаем размер исходя из отступов и размера контента
            layoutSize = _contentSize.copy();
            layoutSize.add(mainAxis.copy().mult(_padding[0] + _padding[1] + (_size - 1) * _spacing));
            layoutSize.add(crossAxis.copy().mult(_padding[2] + _padding[3]));
        }

        return layoutSize;
    }

    protected PVector getContentSize(){
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

    protected boolean isMouseOver(){
        updateSize();
        return mouseX >= _x && mouseX <= _x + _layoutSize.x && mouseY >= _y && mouseY <= _y + + _layoutSize.y;
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
