class RollIndicator extends Layout {

    private Compass _compass;
    private Text _valueText;
    private Text _text;

    RollIndicator(PApplet context){
        super(context, 3);
        
        setSpacing(8);
        setOrientation(VERTICAL);

        _compass = new Compass(context, 96, 96);

        _valueText = new Text(context, "0");
        _valueText.setFont(RobotoMono_reg);
        _valueText.setTextSize(18);
        
        _text = new Text(context, "Вращение");
        _text.setFont(RobotoMono_reg);
        _text.setTextSize(18);
        
        add(_text);
        add(_compass);
        add(_valueText);
    }

    public void draw(){
        TableRow row = serialPort.getLastRow(); 
        
        float roll = row.getFloat("roll");
        if(roll < 0) roll += 360;
        
        float rollSpeed = row.getFloat("rollSpeed");

        _valueText.setText(str(round(rollSpeed)) + "°/с");
        _compass.setRoll(roll);

        super.draw();
    }

}

class Compass extends GuiObject {

    private PImage _image;
    private float _roll = 0;
    private Text _text;

    Compass(PApplet context, float width, float height){
        super(context, width, height);
        
        _image = loadImage("compass.png");

        _text = new Text(context, "");
        _text.setFont(RobotoMono_reg);
        _text.setTextSize(18);
        _text.setColor(color(0));
    }

    public void setRoll(float roll){
        _roll = roll;
        _text.setText(str(round(_roll)));
    }

    public void draw(){
        super.draw();

        _text.draw();

        imageMode(CENTER);
        pushMatrix();
        translate(_x + _width / 2, _y + _height / 2);
        rotate(radians(_roll));
        image(_image, 0, 0, _width, _height);
        popMatrix();
        imageMode(CORNER);
    }

    public void moveTo(float x, float y){
        super.moveTo(x, y);

        _text.moveTo(
            x + (_width  - _text.getWidth())  / 2.0,
            y + (_height - 24) / 2.0
        );
    }

}
