import toxi.geom.*;
import toxi.processing.*;

class DeviationIndicator extends Layout {

    private Arrow _arrow;
    private Text _unitText;
    private Text _valueText;

    DeviationIndicator(PApplet context){
        super(context, 3);

        setSpacing(8);
        setOrientation(VERTICAL);

        _arrow = new Arrow(context, 96, 96);

        _valueText = new Text(context, "0");
        _valueText.setFont(RobotoMono_reg);
        _valueText.setTextSize(18);

        _unitText = new Text(context, "Атака");
        _unitText.setFont(RobotoMono_reg);
        _unitText.setTextSize(18);

        add(_unitText);
        add(_arrow);
        add(_valueText);
    }

    public void draw(){
        // Get data from serial port
        TableRow row = serialPort.getLastRow();
        float[] ypr = {
            radians(row.getFloat("yaw")),
            radians(row.getFloat("pitch")),
            radians(row.getFloat("roll")),
        };

        _arrow.setQuat(Quaternion.createFromEuler(ypr[1], ypr[0], ypr[2])); // pitch, yaw, roll
        
        Vec3D vec = new Vec3D(0, 0, 1); // xyz = pyr
        vec.rotateX(ypr[1]);
        vec.rotateY(ypr[0]);
        float angle = degrees(vec.angleBetween(new Vec3D(0, 0, 1)));
        _valueText.setText(nf(angle, 0, 1) + "°");

        super.draw();
    }
}



class Arrow extends GuiObject{

    private PImage _indicatorCircle;
    private Quaternion _quat = new Quaternion(1, 0, 0, 0);

    Arrow(PApplet context, float width, float height){
        super(context, width, height);
        
        _indicatorCircle = loadImage("indicatorCircle.png");    
    }

    public void setQuat(Quaternion quat){
        _quat = quat;
    }

    public void draw(){
        float length = min(_width, _height) - 10;
        float xArrow = _x + _width / 2;
        float yArrow = _y + _height / 2;

        lights();
        directionalLight(128, 128, 128, 0, 1, 0);

        image(_indicatorCircle, _x, _y, _width, _height);

        pushMatrix();

        translate(xArrow, yArrow, length);
        scale(length / 200);        

        float[] axis = _quat.toAxisAngle();
        rotate(axis[0], -axis[2], -axis[3], axis[1]); // pitch, yaw, roll
        
        // draw main body in red
        fill(RED);
        box(10, 10, 200);

        // draw front-facing tip in blue
        fill(BLUE);
        pushMatrix();
        translate(0, 0, -120);
        rotateX(PI/2);
        cylinder(0, 20, 20, 8);
        popMatrix();

        // draw wings and tail fin in green
        fill(GREEN);
        beginShape(TRIANGLES);
        vertex(-100,  2, 30); vertex(0,  2, -80); vertex(100,  2, 30);  // wing top layer
        vertex(-100, -2, 30); vertex(0, -2, -80); vertex(100, -2, 30);  // wing bottom layer
        vertex(-2, 0, 98); vertex(-2, -30, 98); vertex(-2, 0, 70);  // tail left layer
        vertex( 2, 0, 98); vertex( 2, -30, 98); vertex( 2, 0, 70);  // tail right layer
        endShape();
        beginShape(QUADS);
        vertex(-100, 2, 30); vertex(-100, -2, 30); vertex(  0, -2, -80); vertex(  0, 2, -80);
        vertex( 100, 2, 30); vertex( 100, -2, 30); vertex(  0, -2, -80); vertex(  0, 2, -80);
        vertex(-100, 2, 30); vertex(-100, -2, 30); vertex(100, -2,  30); vertex(100, 2,  30);
        vertex(-2,   0, 98); vertex(2,   0, 98); vertex(2, -30, 98); vertex(-2, -30, 98);
        vertex(-2,   0, 98); vertex(2,   0, 98); vertex(2,   0, 70); vertex(-2,   0, 70);
        vertex(-2, -30, 98); vertex(2, -30, 98); vertex(2,   0, 70); vertex(-2,   0, 70);
        endShape();

        popMatrix();
    }
}