final color SUCCESS_SNACKBAR = SUCCESS_COLOR;
final color WARNING_SNACKBAR = WARNING_COLOR;
final color ERROR_SNACKBAR = DANGER_COLOR;
final color INFO_SNACKBAR = color(255);
final color DEFAULT_SNACKBAR = INFO_SNACKBAR;

class Snackbar extends Layout {

    private Button _button;
    private int _duration = 5000;
    private int _startTime = -_duration;
    
    Snackbar(PApplet context) {
        super(context, context.width, context.height, 1);
        
        _button = new Button(context, "");
        _button.setButtonColor(color(255));
        _button.setContentColor(color(0));
        _button.setButtonHoverColor(color(255, 196));
        _button.setContentHoverColor(color(0, 196));
        _button.setCornerRadius(16);
        _button.setPadding(48, 24);
        _button.setCallback(new Callback(){
            void execute(){ hide(); }
        });

        add(_button);
        setOrientation(VERTICAL);
        setDirection(BACKWARD);
        setPadding(32, 0);
    }

    public void show(String text){
        show(text, DEFAULT_SNACKBAR);
    }

    public void show(String text, color col){
        _button.setText(text);
        _startTime = millis();
        _button.setButtonColor(col);
        _button.setButtonHoverColor(color(col, 196));
    }

    public void hide(){
        _startTime = -_duration;
    }

    public void draw(){        
        if(millis() - _startTime > _duration){
            return;
        }        
        
        super.draw();
    }
    
}
