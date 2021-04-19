class Timer extends Layout {
    
    private Text _missionTime;
    private Text _localTime;
    
    private int _startTime = - 1;
    private int _countdown = 10 * 1000; // 10 секунд обратный отсчет
    
    Timer(PApplet context) {
        super(context, 2);
        setOrientation(VERTICAL);
        setSpacing(8);
        
        _missionTime = new Text(_context, getMissionTime());
        _missionTime.setFont(RobotoMono_med);
        _missionTime.setTextSize(36);
        _missionTime.setColor(color(0));
        add(_missionTime);
        
        _localTime = new Text(_context, getLocalTime());
        _localTime.setFont(RobotoMono_reg);
        _localTime.setTextSize(18);
        _localTime.setColor(color(0, 128));
        add(_localTime);
    }
    
    protected void update() {
        _missionTime.setText(getMissionTime());
        _localTime.setText(getLocalTime());
        super.update();
    }
    
    public String getMissionTime() {
        int ms = _startTime != - 1 ? millis() - _startTime : - _countdown;
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
    
    public void start() {
        _startTime = millis() + _countdown;
    }

    public void reset() {
        _startTime = -1;
    }
    
}
