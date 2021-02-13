public class Timer extends GuiObject {

    PApplet _context;

    private Layout _layout;
    private TextLayout _missionTime;
    private TextLayout _localTime;

    private int _startTime = -1;
    private int _countdown = 10 * 1000; // 10 секунд обратный отсчет
    
    Timer(PApplet context) {
        _context = context;
        _context.registerMethod("mouseEvent", this);

        _layout = new Layout(2);
        _layout.setOrientation(VERTICAL);
        _layout.setSpacing(8);
        
        _missionTime = new TextLayout(getMissionTime());
        _missionTime.setFont(RobotoMono_med);
        _missionTime.setTextSize(36);
        _missionTime.setTextColor(color(0));
        _layout.add(_missionTime);
        
        _localTime = new TextLayout(getLocalTime());
        _localTime.setFont(RobotoMono_reg);
        _localTime.setTextSize(18);
        _localTime.setTextColor(color(0, 128));
        _layout.add(_localTime);
    }

    public void mouseEvent(MouseEvent event) {
        switch (event.getAction()) {
            case MouseEvent.CLICK:
                _startTime = millis() + _countdown;
                break;
        }
    }

    private String getMissionTime() {
        int ms = _startTime != -1 ? millis() - _startTime : -_countdown;
        String T = "T" + (ms < 0 ? "-" : "+");
        ms = abs(ms);
        
        String time = "";
        time += nf(ms / 60000, 2) + ":"; // Минуты
        ms %= 60000;
        time += nf(ms / 1000, 2) + ":"; // Секунды
        ms %= 1000;    
        time += nf(ms, 3); // Милисекунды

        return T + time;
    }

    private String getLocalTime() {
        String time = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
        String date = nf(day(), 2) + "." + nf(month(), 2) + "." + year();
        return time + " " + date;
    }

    public void draw(){
        _missionTime.setText(getMissionTime());
        _localTime.setText(getLocalTime());
        _layout.draw();
    }

    public void moveTo(float x, float y){
        _layout.moveTo(x, y);        
    }

    public float getWidth(){
        return _layout.getWidth();
    }
    
    public float getHeight(){
        return _layout.getHeight();
    }
}
