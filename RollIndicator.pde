class RollIndicator extends Layout {

    private Compass _compass;
    private Text _text;

    RollIndicator(PApplet context){
        super(context, 2);
        
        setSpacing(4);
        setOrientation(VERTICAL);

        _compass = new Compass(context, 96, 96);        
        
        _text = new Text(context, "град");
        _text.setFont(RobotoMono_reg);
        _text.setTextSize(18);
        _text.setColor(color(0));
        
        add(_compass);
        add(_text);
    }

}

class Compass extends GuiObject {

    private PImage _image;
    int _val = 0;
    private Text _text;

    Compass(PApplet context, float width, float height){
        super(context, width, height);
        
        _image = loadImage("compass.png");
        
        _text = new Text(context, str(0));
        _text.setFont(RobotoMono_reg);
        _text.setColor(color(0));
    }

    public void setValue(int val){
        _val = val;
        _text.setText(str(val));
    }

    public void draw(){
        super.draw();

        setValue(int(serialPort.getLastRow().getFloat("roll")));
        
        _text.draw();

        imageMode(CENTER);
        pushMatrix();
        translate(_x + _width / 2, _y + _height / 2);
        rotate(radians(_val));
        image(_image, 0, 0, _width, _height);
        popMatrix();
        imageMode(CORNER);
    }

    public void moveTo(float x, float y){
        super.moveTo(x, y);

        _text.moveTo(
            x + (_width  - _text.getWidth())  / 2.0,
            y + (_height - 24) / 2.0 - 4
        );
    }

}
