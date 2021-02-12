final int HORIZONTAL = 0; 
final int VERTICAL = 1;
final int FORWARD = 0;
final int BACKWARD = 2;

public class Layout {

    //==========   ПЕРЕМЕННЫЕ   ==========// 

    protected float _x = 0;
    protected float _y = 0;

    protected TextLayout[] _list;

    public float _spacing = 0;
    public float _indents = 0;
    protected int _size = 0;

    public int _direction = FORWARD | HORIZONTAL;



    //==========   КОНСТРУКТОРЫ   ==========// 

    Layout(int x, int y, int size){
        _x = x;
        _y = y;
        _list = new TextLayout[size];
    }



    //==========   PROTECTED МЕТОДЫ   ==========// 

    protected void update(){
        float x = _x;
        float y = _y;
        float mod = ((_direction & FORWARD) == FORWARD) ? 1 : -1;

        if((_direction & HORIZONTAL) == HORIZONTAL) x += _indents * mod;        
        else if((_direction & VERTICAL) == VERTICAL) y += _indents * mod;

        for(int i = 0; i < _size; i++){            
            _list[i].moveTo(x, y);            
            
            if((_direction & HORIZONTAL) == HORIZONTAL) x += (_spacing + _list[i].getWidth()) * mod;
            else if((_direction & VERTICAL) == VERTICAL) y += (_spacing + _list[i].getHeight()) * mod;
        }
    }



    //==========   PUBLIC МЕТОДЫ   ==========// 

    public void draw(){      
        for(TextLayout item : _list){
            item.draw();
        }
    }

    public void add(TextLayout item){
        _list[_size++] = item;
        update();
    }

    public float getWidth(){        
        float _width = 0;

        if(_direction == HORIZONTAL){
            if(_size == 0) return _width;
            _width = 2 * _indents + (_size - 1) * _spacing;

            for(int i = 0; i < _size; i++){
                _width += _list[i].getWidth();
            }

            return _width;
        } else if(_direction == VERTICAL){
            for(int i = 0; i < _size; i++){
                _width = max(_width, _list[i].getWidth());
            }
        }

        return _width;        
    }

    public float getHeight(){
        float _height = 0;

        if(_direction == HORIZONTAL){
            for(int i = 0; i < _size; i++){
                _height = max(_height, _list[i].getHeight());
            }
        } else if(_direction == VERTICAL){
            if(_size == 0) return _height;
            _height = 2 * _indents + (_size - 1) * _spacing;

            for(int i = 0; i < _size; i++){
                _height += _list[i].getHeight();
            }

            return _height;
        } 

        return _height;
    }



    //==========   PUBLIC МЕТОДЫ: СЕТТЕРЫ   ==========//

}